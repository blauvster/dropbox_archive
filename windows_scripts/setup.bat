@echo off

REM Exit on errors
setlocal enabledelayedexpansion
set ERRORS=0

REM Check if the current directory is "windows_scripts"
for %%I in ("%cd%") do (
    set "CURRENT_DIR=%%~nI"
)
if /i "%CURRENT_DIR%"=="windows_scripts" (
    cd ..
    set "RETURN_DIR=windows_scripts"
)

REM Check if Python 3 is installed
where python >nul 2>nul
if errorlevel 1 (
    echo Python 3 is not installed. Please install Python 3 to proceed.
    goto exit
)

REM Create a virtual environment in the current directory
python -m venv .venv
if errorlevel 1 (
    echo Failed to create a virtual environment.
    goto exit
)

REM Activate the virtual environment
call .venv\Scripts\activate

REM Check if requirements.txt exists
if not exist requirements.txt (
    echo requirements.txt file not found in the current directory.
    deactivate
    goto exit
)

REM Install the requirements from requirements.txt
pip install -r requirements.txt
if errorlevel 1 (
    echo Failed to install requirements.
    deactivate
    goto exit
)

echo Virtual environment setup complete and requirements installed.

REM Deactivate the virtual environment
deactivate

:exit
REM Return to the original directory if necessary
if defined RETURN_DIR (
    cd "%RETURN_DIR%"
)

exit /b
