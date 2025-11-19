@echo off
setlocal enabledelayedexpansion

echo ==================================================
echo XTTS-WebUI Installer (Phase 2: Resume)
echo ==================================================

REM Activate VENV
call venv\Scripts\activate
if %ERRORLEVEL% NEQ 0 (
    echo Failed to activate venv.
    pause
    exit /b 1
)

echo Venv activated.

REM Install 'av' first (latest binary) to avoid build hangs
echo Ensuring 'av' is installed...
python -m pip install av

REM Install Other Requirements (filtered, now without whisperx)
echo Installing remaining requirements...
if exist requirements_filtered.txt (
    python -m pip install -r requirements_filtered.txt
) else (
    echo Warning: requirements_filtered.txt not found!
)

REM Force Install Specific Versions
echo Enforcing critical package versions...
python -m pip install "transformers==4.42.4"
python -m pip install "faster-whisper==1.0.1"

REM Install WhisperX with --no-deps to avoid downgrading things, then fix its distinct deps
echo Installing WhisperX (no deps to avoid conflicts)...
python -m pip install whisperx --no-deps

REM Manually install WhisperX dependencies that we might have missed or are safe
REM pyannote.audio is a big one for whisperx
echo Installing pyannote.audio...
python -m pip install pyannote.audio

REM Run Downloader
echo Running model downloader...
python scripts/modeldownloader.py

echo ==================================================
echo Installation Complete!
echo ==================================================
