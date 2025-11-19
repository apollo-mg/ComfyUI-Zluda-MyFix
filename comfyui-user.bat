@echo off

set "ROCM_PATH=C:\Program Files\AMD\ROCm\6.4"
set "ZLUDA_PATH=%~dp0zluda"
set "VENV_PYTHON=%~dp0venv\Scripts\python.exe"

set "PATH=%ROCM_PATH%\bin;%ZLUDA_PATH%;%PATH%"

echo [INFO] Temporarily setting PATH for this session:
echo [INFO] PATH=%PATH%
echo.

set "COMMANDLINE_ARGS=--auto-launch --use-quad-cross-attention --reserve-vram 0.8 --force-fp16 --fp32-vae"

echo [INFO] Launching application...
echo.

call %VENV_PYTHON% main.py %COMMANDLINE_ARGS%

pause
