@echo off
setlocal enabledelayedexpansion

echo ==================================================
echo XTTS-WebUI Fix: Missing faster_whisper
echo ==================================================

call venv\Scripts\activate

echo Installing faster-whisper (again)...
REM It seems it was uninstalled or lost during the conflicts.
pip install "faster-whisper==1.0.1"

echo ==================================================
echo Fix Complete!
echo ==================================================
