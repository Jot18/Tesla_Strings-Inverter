@echo off
setlocal EnableExtensions
cd /d "%~dp0"

REM ===== EDIT THESE =====
set "TEDAPI_HOST=192.168.91.1"
set "TEDAPI_PASSWORD=Password123"
set "PORT=8800"
set "INTERVAL=60"
REM ======================

REM --- pick a Python launcher; prefer 'py' (the python.org launcher) which never triggers
REM     the Microsoft Store stub that causes the "stuck on first run" hang ---
set "PY="
where py >nul 2>nul && set "PY=py -3"
if not defined PY where python >nul 2>nul && set "PY=python"
if not defined PY goto :nopy
%PY% --version >nul 2>nul
if errorlevel 1 goto :nopy
echo Using Python: %PY%

REM --- create the virtual environment if it is missing ---
if exist ".venv\Scripts\python.exe" goto :havevenv
echo Creating virtual environment, one-time...
%PY% -m venv .venv
if errorlevel 1 goto :venvfail
:havevenv
set "VENVPY=.venv\Scripts\python.exe"

REM --- make sure the dependencies are really importable; this self-heals a first run that
REM     was interrupted or only half-installed (the old "if .venv exists, skip" trap) ---
"%VENVPY%" -c "import flask, openpyxl, pypowerwall" >nul 2>nul
if not errorlevel 1 goto :run
echo Installing dependencies, one-time, this can take a minute...
"%VENVPY%" -m pip install --upgrade --no-input --timeout 60 --retries 3 pip
"%VENVPY%" -m pip install --no-input --timeout 60 --retries 3 -r requirements.txt
"%VENVPY%" -c "import flask, openpyxl, pypowerwall" >nul 2>nul
if errorlevel 1 goto :depfail

:run
echo.
echo Collecting AND serving the Strings page on http://localhost:%PORT%/   -  Ctrl+C to stop
start "" "http://localhost:%PORT%/"
"%VENVPY%" strings_server.py --host %TEDAPI_HOST% --password %TEDAPI_PASSWORD% --db "%~dp0StringsDB.db" --port %PORT% --interval %INTERVAL%
echo.
echo The program has stopped.
pause
goto :eof

:nopy
echo.
echo ERROR: Python 3.11+ was not found.
echo Install it from https://www.python.org/downloads/ and tick "Add python.exe to PATH",
echo then run this file again. Avoid the Microsoft Store version.
echo.
pause
goto :eof

:venvfail
echo.
echo ERROR: could not create the virtual environment.
echo If a Microsoft Store window opened, install real Python from python.org instead,
echo then delete any .venv folder here and run this again.
echo.
pause
goto :eof

:depfail
echo.
echo ERROR: dependency install did not complete.
echo Check your internet connection or proxy, then DELETE the .venv folder and run this again.
echo.
pause
goto :eof
