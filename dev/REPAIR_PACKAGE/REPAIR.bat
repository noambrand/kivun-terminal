@echo off
title Kivun Terminal - Repair
echo ========================================
echo KIVUN TERMINAL - REPAIR
echo ========================================
echo.
echo This will fix the missing files and config issues.
echo.
pause

set INSTALL_DIR=%LOCALAPPDATA%\Kivun

echo [1] Copying missing files...
copy /Y ClaudeHebrew.profile "%INSTALL_DIR%\"
copy /Y ColorSchemeNoam.colorscheme "%INSTALL_DIR%\"
echo.

echo [2] Fixing config.txt...
copy /Y config.txt "%INSTALL_DIR%\"
echo.

echo ========================================
echo REPAIR COMPLETE!
echo ========================================
echo.
echo Files fixed:
echo  - ClaudeHebrew.profile
echo  - ColorSchemeNoam.colorscheme
echo  - config.txt (fixed duplicate USE_VCXSRV)
echo.
echo Try the launcher again now.
echo.
pause
