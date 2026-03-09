@echo off
REM Move obsolete files to TRASH

cd /d "%~dp0"

echo Moving obsolete files to TRASH...

move /Y claude-hebrew-web.bat TRASH\ 2>nul
move /Y claude-hebrew-web.sh TRASH\ 2>nul
move /Y start-web-ui.bat TRASH\ 2>nul
move /Y start-web-ui.sh TRASH\ 2>nul
move /Y ClaudeHebrew.bat TRASH\ 2>nul
move /Y claude-hebrew-mintty.bat TRASH\ 2>nul
move /Y claude-hebrew-interactive.bat TRASH\ 2>nul
move /Y claude-hebrew-stable.bat TRASH\ 2>nul
move /Y claude-hebrew-stable.sh TRASH\ 2>nul
move /Y claude-hebrew-stable-v2.sh TRASH\ 2>nul
move /Y claude-hebrew-wt.bat TRASH\ 2>nul
move /Y claude-hebrew-wt.sh TRASH\ 2>nul
move /Y claude-hebrew-decrst.bat TRASH\ 2>nul
move /Y claude-hebrew-decrst.sh TRASH\ 2>nul
move /Y launch.bat TRASH\ 2>nul
move /Y launch-konsole-claude.bat TRASH\ 2>nul
move /Y launch-hebrew-cli.bat TRASH\ 2>nul
move /Y claude-hebrew.sh TRASH\ 2>nul
move /Y claude_hebrew.sh TRASH\ 2>nul
move /Y screenshot_smart.sh TRASH\ 2>nul
move /Y screenshot_verify.sh TRASH\ 2>nul
move /Y run_csc.bat TRASH\ 2>nul
move /Y compile_screenshot.bat TRASH\ 2>nul

echo Done! Obsolete files moved to TRASH folder.
echo.
echo You can now easily find: claude-hebrew-konsole.bat
pause
