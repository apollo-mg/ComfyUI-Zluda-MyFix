@echo off
setlocal enabledelayedexpansion

echo ==================================================
echo XTTS-WebUI Fix: Force Installing AV Binary
echo ==================================================

call venv\Scripts\activate

echo Installing AV from binary to avoid build failure...
pip install av --only-binary :all:

echo Verifying faster-whisper installation...
pip install "faster-whisper==1.0.1"

echo ==================================================
echo Fix Complete!
echo ==================================================
