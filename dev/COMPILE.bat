@echo off
echo Compiling Kivun Terminal Installer...
echo.

"C:\Program Files (x86)\NSIS\makensis.exe" "%~dp0Kivun_Terminal_Setup.nsi"

echo.
if %ERRORLEVEL% EQU 0 (
    echo SUCCESS! Installer compiled successfully.
    echo Output: Kivun_Terminal_Setup.exe
) else (
    echo ERROR! Compilation failed with error code %ERRORLEVEL%
)

echo.
pause
