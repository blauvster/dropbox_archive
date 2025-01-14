@echo off

REM Relative path to the target script (relative to the script's directory)
set "TARGET_SCRIPT=run.bat"

REM Task schedule time (e.g., daily at 2:00 AM)
set "SCHEDULE_TIME=02:00"

REM Get the absolute directory of the current script
for %%I in ("%~dp0.") do set "SCRIPT_DIR=%%~fI"

REM Full path to the target script
set "FULL_TARGET_SCRIPT=%SCRIPT_DIR%\%TARGET_SCRIPT%"

REM Check if the target script exists
if not exist "%FULL_TARGET_SCRIPT%" (
    echo Error: Target script not found at "%FULL_TARGET_SCRIPT%"
    exit /b 1
)

REM Create a unique task name based on the target script name
set "TASK_NAME=DropboxArchive"

REM Remove any existing scheduled task with the same name
schtasks /Delete /TN "%TASK_NAME%" /F >nul 2>&1

REM Create a new scheduled task
schtasks /Create /SC DAILY /ST %SCHEDULE_TIME% /TR "\"%FULL_TARGET_SCRIPT%\"" /TN "%TASK_NAME%"

if %ERRORLEVEL% equ 0 (
    echo Task scheduled successfully: %TASK_NAME% at %SCHEDULE_TIME%.
) else (
    echo Failed to schedule task. Please check permissions or syntax.
)
