@echo off
REM Fix Kivun Terminal Shortcuts - Point to claude-hebrew-konsole.bat
REM This updates existing shortcuts to use the working launcher

echo ========================================
echo   Fixing Kivun Terminal Shortcuts
echo ========================================
echo.

REM Get installation directory (where this script is)
set "INST_DIR=%~dp0"
set "INST_DIR=%INST_DIR:~0,-1%"

echo Installation directory: %INST_DIR%
echo.

REM Delete old shortcuts
echo [1/3] Removing old shortcuts...
del "%USERPROFILE%\Desktop\Kivun Terminal.lnk" 2>nul
del "%APPDATA%\Microsoft\Windows\SendTo\Kivun Terminal.lnk" 2>nul
del "%APPDATA%\Microsoft\Windows\SendTo\kivun-terminal.bat.lnk" 2>nul
echo   Old shortcuts removed.

echo.
echo [2/3] Creating new desktop shortcut...
REM Create shortcut using VBScript (PowerShell is blocked)
cscript //nologo "%INST_DIR%\create-shortcut.vbs" "%USERPROFILE%\Desktop\Kivun Terminal.lnk" "%INST_DIR%\claude-hebrew-konsole.bat" "%INST_DIR%\claude_code.ico" "Hebrew RTL Support for Claude Code"

echo.
echo [3/3] Creating SendTo shortcut...
cscript //nologo "%INST_DIR%\create-shortcut.vbs" "%APPDATA%\Microsoft\Windows\SendTo\Kivun Terminal.lnk" "%INST_DIR%\claude-hebrew-konsole.bat" "%INST_DIR%\claude_code.ico" "Open with Kivun Terminal"

echo.
echo ========================================
echo   Shortcuts Fixed!
echo ========================================
echo.
echo Desktop shortcut: Kivun Terminal
echo SendTo: Right-click folder → Send To → Kivun Terminal
echo.
echo Both now use: claude-hebrew-konsole.bat
echo.
pause
