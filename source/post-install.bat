@echo off
chcp 65001 >nul 2>&1
echo ============================================
echo   Kivun Terminal - Post Installation
echo ============================================
echo.

echo [1/2] Installing Claude Code...
echo   Running: npm install -g @anthropic-ai/claude-code
call npm install -g @anthropic-ai/claude-code
if errorlevel 1 (
    echo.
    echo ERROR: Failed to install Claude Code.
    echo Make sure Node.js is installed and npm is in your PATH.
    echo.
    pause
    exit /b 1
)

echo.
echo [2/2] Verifying installation...
claude --version
if errorlevel 1 (
    echo.
    echo WARNING: claude command not found after install.
    echo You may need to restart your terminal.
    echo.
    pause
    exit /b 1
)

echo.
echo ============================================
echo   Installation Complete!
echo ============================================
echo.
echo Claude Code is ready. Launch it with the desktop shortcut.
echo.
pause
