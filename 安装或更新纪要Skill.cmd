@echo off
setlocal
chcp 65001 >nul
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0install-or-update.ps1"
set "INSTALL_EXIT_CODE=%ERRORLEVEL%"
echo.
if "%INSTALL_EXIT_CODE%"=="0" (
  echo Installation finished. Restart Codex Desktop or start a new task before first use.
) else (
  echo Installation failed. Keep this window open and report the error shown above.
)
echo.
pause
exit /b %INSTALL_EXIT_CODE%
