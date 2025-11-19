@echo off
setlocal enabledelayedexpansion

echo ==================================================
echo XTTS-WebUI Fix: Force Ignore Dependency Check
echo ==================================================

call venv\Scripts\activate

echo Installing working AV binary (latest)...
pip install av --only-binary :all:

echo Forcing faster-whisper installation (ignoring dependency check)...
REM We install faster-whisper without dependencies first to bypass the strict av check
pip install "faster-whisper==1.0.1" --no-deps

echo Installing other faster-whisper dependencies manually...
REM We assume these are missing or need update, but we skip av
pip install ctranslate2 tokenizers onnxruntime huggingface-hub

echo ==================================================
echo Fix Complete!
echo ==================================================
