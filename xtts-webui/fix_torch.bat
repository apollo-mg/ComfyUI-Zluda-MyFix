@echo off
setlocal enabledelayedexpansion

echo ==================================================
echo XTTS-WebUI Fix: Reverting Torch & Pyannote
echo ==================================================

call venv\Scripts\activate

echo Uninstalling incompatible packages...
pip uninstall -y torch torchaudio pyannote.audio lightning

echo Re-installing ZLUDA-compatible PyTorch...
pip install torch==2.1.1+cu118 torchaudio==2.1.1+cu118 --index-url https://download.pytorch.org/whl/cu118

echo Installing older pyannote.audio compatible with Torch 2.1...
REM whisperx often likes 3.1.1 or 3.3.1
pip install "pyannote.audio==3.1.1"

echo Verifying Torch...
python -c "import torch; print(f'Torch: {torch.__version__}, CUDA: {torch.version.cuda}, IsAvailable: {torch.cuda.is_available()}')"

echo ==================================================
echo Fix Complete!
echo ==================================================

