@echo off
setlocal enabledelayedexpansion

echo ==================================================
echo XTTS-WebUI Fix: Version Specific AV Binary
echo ==================================================

call venv\Scripts\activate

echo Uninstalling incompatible AV version...
pip uninstall -y av

echo Installing AV 11.0.0 (Binary Only)...
REM Using 11.0.0 as requested by faster-whisper dependencies
pip install av==11.0.0 --only-binary :all:

echo Verifying faster-whisper installation...
pip install "faster-whisper==1.0.1"

echo ==================================================
echo Fix Complete!
echo ==================================================
