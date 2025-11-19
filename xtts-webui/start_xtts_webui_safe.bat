@echo off
setlocal enabledelayedexpansion

echo ==================================================
echo Starting XTTS-WebUI (SAFE MODE - NO DEEPSPEED)
echo ==================================================

REM Set Temporary Directory
set "TEMP=%cd%\temp"
if not exist "%TEMP%" mkdir "%TEMP%"

REM Activate VENV
call venv\Scripts\activate

REM Locate ZLUDA
set "ZLUDA_EXE=..\zluda\zluda.exe"
for %%I in ("%ZLUDA_EXE%") do set "ZLUDA_FULL=%%~fI"

if not exist "%ZLUDA_FULL%" goto :NO_ZLUDA

:ZLUDA
echo ZLUDA found at %ZLUDA_FULL%
echo Launching with ZLUDA (DeepSpeed DISABLED)...
"%ZLUDA_FULL%" -- python app.py
goto :END

:NO_ZLUDA
echo WARNING: ZLUDA executable not found at %ZLUDA_EXE%
echo Attempting to launch with standard Python...
python app.py
goto :END

:END
pause
