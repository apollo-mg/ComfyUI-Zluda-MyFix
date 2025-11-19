# Project: XTTS-WebUI on ZLUDA (AMD GPU) - Final Report

## 1. The Challenge
We aimed to install and run the `daswer123/xtts-webui` voice cloning application on a Windows machine equipped with a high-end AMD GPU (RX 9070 XT), utilizing the **ZLUDA** translation layer to run CUDA binaries.
*   **Core Obstacle:** The application is heavily optimized for NVIDIA (CUDA) and relies on libraries (`DeepSpeed`, `cublasSgemm`) that are fundamentally incompatible with the current state of ZLUDA on Windows.

## 2. Technical Obstacles & Solutions

### A. Dependency Hell
*   **Problem:** `faster-whisper` required `av`, but installing `av` triggered a source build that failed due to missing FFmpeg libraries.
*   **Solution:** Created `fix_av_force.bat` to force-install a binary wheel of `av` and install `faster-whisper` with `--no-deps`.

### B. DeepSpeed Incompatibility (The "Nuclear" Fix)
*   **Problem:** DeepSpeed caused immediate crashes (`CUBLAS_STATUS_NOT_SUPPORTED`) due to unsupported kernels in ZLUDA. The app aggressively re-installed it on startup.
*   **Solution:**
    1.  **Force Uninstall:** Removed DeepSpeed.
    2.  **Patch Auto-Installer:** Modified `scripts/modeldownloader.py` to disable the auto-reinstall logic.
    3.  **Patch Imports:** Modified `resemble_enhance` scripts (`enhancer/train.py`, `denoiser/train.py`, `utils/engine.py`, etc.) to make DeepSpeed imports optional/dummy.

### C. ZLUDA Inference Failures
*   **Problem:** Even without DeepSpeed, the XTTS model's matrix operations crashed ZLUDA. Attempts to use **BFloat16** (supported by hardware) failed with `cublasGemmEx` errors.
*   **Solution (The "CPU Pivot"):**
    *   Modified `scripts/tts_funcs.py` to **force CPU execution** (`self.device = "cpu"`).
    *   Implemented **Dynamic Quantization** (`qint8`) for Linear layers to boost CPU inference speed significantly.
    *   Result: Stable, high-quality voice generation running locally on the CPU.

### D. UI Bugs
*   **Problem:** `gradio_client` crashed with a boolean iterable error.
*   **Solution:** Patched `gradio_client/utils.py`.

## 3. Infrastructure & Cloud Sync
*   **Git Integration:** Initialized a new repository `apollo-mg/ComfyUI-Zluda-MyFix`.
*   **Cloud Context:** Committed this `GEMINI.md` file to the repo, allowing the "AI Agent Context" to travel with the code.
*   **Workflow:** Changes are now tracked, versioned, and pushed to GitHub (`main` branch).

## 4. Future Roadmap (Linux Migration)
*   **Status:** Windows/ZLUDA is viable for inference but dead-end for training.
*   **Plan:** Migrate to **Ubuntu 22.04 LTS** to unlock:
    *   Native ROCm support (Kernel 6.8 via HWE).
    *   Full VRAM usage & Training capabilities.
    *   DeepSpeed & Flash Attention support.
*   **Pre-Flight Check:** Hardware (GPU, Network, Storage) is fully compatible with Ubuntu 22.04.5.
*   **BIOS Settings:** Disable Secure Boot & Fast Startup before installation.

---
*Last Updated: 2025-11-18*