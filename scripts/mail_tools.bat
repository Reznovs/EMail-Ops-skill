@echo off
setlocal
set SCRIPT_DIR=%~dp0

where python >nul 2>&1
if %errorlevel% equ 0 (
    python "%SCRIPT_DIR%mail_tools.py" %*
    goto :eof
)

where py >nul 2>&1
if %errorlevel% equ 0 (
    py "%SCRIPT_DIR%mail_tools.py" %*
    goto :eof
)

where python3 >nul 2>&1
if %errorlevel% equ 0 (
    python3 "%SCRIPT_DIR%mail_tools.py" %*
    goto :eof
)

echo Error: No Python interpreter found (tried python, py, python3) >&2
exit /b 1
