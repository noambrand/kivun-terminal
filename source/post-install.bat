@echo off
chcp 65001 >nul 2>&1
echo ============================================
echo   ClaudeCode Launchpad CLI - Post Installation
echo ============================================
echo.

echo [1/3] Installing Claude Code...
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
echo [2/3] Setting Claude Code to update from the current release channel...
REM Anthropic ships two release channels: `stable`, which can sit on the same
REM build for weeks, and `latest`, the current one. Whichever channel a machine
REM is on is the one its auto-updater follows, so without this a user can end up
REM dozens of releases behind while the updater reports itself healthy. This
REM writes one settings key and downloads nothing; the newer build arrives on
REM Claude's next check. A failure here is not fatal - Claude still works.
call node "%~dp0configure-fast-updates.js"
if errorlevel 1 (
    echo   WARNING: could not set the update channel. Claude Code still works.
) else (
    echo   Done - new versions will arrive automatically.
)

echo.
echo [3/3] Verifying installation...
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
