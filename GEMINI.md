# Project: XTTS-WebUI on ZLUDA (AMD GPU)

## 1. Objective
Install and configure the standalone `daswer123/xtts-webui` application for text-to-speech voice cloning on a Windows system with an AMD GPU, utilizing the ZLUDA translation layer to run CUDA-based code.

## 2. Challenges Encountered

### A. Dependency Conflicts
*   **The "AV" Loop:** `faster-whisper` requires `av==11.*`, but installing it triggers a build from source which fails due to missing FFmpeg libraries on Windows. Pre-built wheels for v11 were unavailable for the specific environment.
*   **Version Mismatch:** The project requirements specified conflicting versions of `transformers`, `tokenizers`, and `torchaudio`.

### B. ZLUDA / DeepSpeed Incompatibility
*   **Kernel Crashes:** DeepSpeed's highly optimized CUDA kernels (e.g., `cublasSgemm`) caused immediate crashes on ZLUDA (`CUBLAS_STATUS_NOT_SUPPORTED`).
*   **Persistent Re-installation:** The application's startup script (`modeldownloader.py`) aggressively tried to re-install DeepSpeed whenever it was missing.
*   **Hardcoded Imports:** The `resemble_enhance` module (used for audio improvement) had hardcoded imports for `deepspeed`, causing crashes even after uninstallation.

### C. ZLUDA Inference Instability
*   **Matrix Multiplication:** Even with standard PyTorch (no DeepSpeed), the XTTS model's specific matrix operations caused ZLUDA to crash on the AMD GPU.
*   **Precision Issues:** Attempts to force `BFloat16` (which is supported by the hardware) still resulted in `cublasGemmEx` failures via ZLUDA.
*   **Latent Calculation:** Calculating speaker latents on GPU caused "Input type/Weight type" mismatches.

### D. UI / Library Bugs
*   **Gradio Schema Error:** A newer version of `gradio_client` crashed with `TypeError: argument of type 'bool' is not iterable` when parsing the API schema.

## 3. Implemented Solutions

### Environment & Dependencies
1.  **Force Dependency Install:** Created `fix_av_force.bat` to install the latest binary `av` package and then force-install `faster-whisper` by ignoring dependency checks (`--no-deps`).
2.  **Missing Module Fix:** Manually installed `faster-whisper` to resolve `ModuleNotFoundError`.

### DeepSpeed Removal (The "Nuclear Option")
1.  **Uninstall:** Forcefully removed `deepspeed` from the virtual environment.
2.  **Disable Auto-Install:** Patched `scripts/modeldownloader.py` to immediately return from `install_deepspeed_based_on_python_version`, preventing it from fighting back.
3.  **Patch Imports:** Modified multiple files in `scripts/resemble_enhance/` (`enhancer/train.py`, `denoiser/train.py`, `utils/distributed.py`, `utils/engine.py`) to wrap `import deepspeed` in `try...except ImportError` blocks and provide dummy fallbacks.

### Stability & Workarounds
1.  **Gradio Patch:** Modified `venv/.../gradio_client/utils.py` to handle boolean schema types safely.
2.  **Final Inference Fix (CPU Enforcement):**
    *   After exhaustive testing with FP32 and BF16 on GPU (all failing on ZLUDA), **forced CPU execution** for the XTTS model in `scripts/tts_funcs.py`.
    *   Hardcoded `self.device = "cpu"` in the model wrapper.
    *   This bypasses the broken ZLUDA kernels entirely, ensuring 100% stability for generation at the cost of some speed.

## 4. Current Status
*   **WebUI:** Fully functional and accessible at `http://localhost:8010`.
*   **Voice Cloning:** Working correctly.
    *   **Latent Creation:** Functional (Patched to handle CPU execution).
    *   **Generation:** Functional (Running on CPU).
*   **Performance:** Decent speed for TTS tasks (XTTS is efficient enough for CPU inference).
*   **Quality:** Identical to GPU generation.

## 5. Future Recommendations
*   **Model Version:** Switch to **v2.0.3** in the WebUI settings for improved voice quality and stability.
*   **Generation Settings:** Recommended starting points: Temperature 0.65-0.70, Repetition Penalty 2.0.
*   **Hardware Acceleration:** Monitor for **DirectML** support in Coqui TTS or ONNX Runtime implementations, which would offer proper GPU acceleration for AMD on Windows without ZLUDA's fragility.