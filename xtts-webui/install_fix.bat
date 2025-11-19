@echo off
setlocal enabledelayedexpansion

echo ==================================================
echo XTTS-WebUI Installer (Fix for Dependencies)
echo ==================================================

REM 1. Create VENV
if not exist "venv" (
    echo Creating virtual environment...
    python -m venv venv
) else (
    echo Virtual environment already exists.
)

REM 2. Activate VENV
call venv\Scripts\activate
if %ERRORLEVEL% NEQ 0 (
    echo Failed to activate venv.
    pause
    exit /b 1
)

REM 3. Update Pip
echo Upgrading pip...
python -m pip install --upgrade pip

REM 4. Install Torch (ZLUDA/CUDA 11.8 compatible)
echo Installing PyTorch...
python -m pip install torch==2.1.1+cu118 torchaudio==2.1.1+cu118 --index-url https://download.pytorch.org/whl/cu118

REM 5. Install Coqui-TTS (This is the heavy one)
echo Installing Coqui-TTS (may take a while)...
python -m pip install "coqui-tts[languages]==0.24.2"

REM 6. Install Other Requirements (filtered)
echo Installing other requirements...
if exist requirements_filtered.txt (
    python -m pip install -r requirements_filtered.txt
) else (
    echo Warning: requirements_filtered.txt not found!
)

REM 7. Force Install Specific Versions (The Fix)
echo Force installing specific versions to resolve conflicts...
REM Force installing transformers 4.42.4. This may complain about coqui-tts dependencies but is required for the WebUI.
python -m pip install "transformers==4.42.4"
python -m pip install "faster-whisper==1.0.1"

REM 8. Run Downloader
echo Running model downloader...
python scripts/modeldownloader.py

echo ==================================================
echo Installation Complete!
echo You can now run the webui using start_xtts_webui.bat
echo ==================================================

