# Kivun Terminal - Launcher Fixes

## Overview

This document describes the fixes applied to resolve launcher reliability issues where the terminal would flash and close immediately.

## v1.0.5 Fixes (2026-03-09)

### 11. **VcXsrv Access Control Blocking WSL (Critical)**
- **Problem**: Alt+Shift keyboard switching doesn't work — VcXsrv runs but WSL can't connect to it
- **Root Cause**: `kivun.xlaunch` had `DisableAC="False"`, enabling X11 access control. WSL connections were rejected, causing fallback to WSLg where Alt+Shift doesn't work.
- **Solution**: Changed `DisableAC="True"` in `kivun.xlaunch`
- **Impact**: VcXsrv now accepts WSL connections, Alt+Shift keyboard switching works

### 12. **Duplicate Konsole Window on Launch**
- **Problem**: Clicking desktop shortcut opens TWO Konsole terminals
- **Root Cause**: Both `.bat` launchers could trigger `kivun-launch.sh` before the first Konsole was fully started
- **Old approach**: Lock files in both `.bat` files — overcomplicated, race conditions, stale files, cleanup needed at 5+ exit points
- **Solution**: Single `pgrep -x konsole` check in `kivun-launch.sh`. If Konsole is already running, exit immediately.
- **Impact**: Only one Konsole window opens per launch

### 13. **Folder Picker Missing from Installer**
- **Problem**: "Choose Folder" desktop shortcut falls through to manual path entry
- **Root Cause**: `folder-picker.vbs` was in `dev/` but never added to installer `.nsi` file
- **Solution**: Created `source/folder-picker.vbs` (with generic `%USERPROFILE%` start path) and added `File "source\folder-picker.vbs"` to NSIS script
- **Impact**: Folder picker dialog now appears when using "Choose Folder" shortcut

### 14. **Duplicate USE_VCXSRV in config.txt**
- **Problem**: Config file had two `USE_VCXSRV` lines (first `false`, then `true` appended by VcXsrv section)
- **Root Cause**: Installer wrote `USE_VCXSRV=false` in initial config, then VcXsrv section appended `USE_VCXSRV=true`
- **Solution**: Removed the initial `USE_VCXSRV=false` from config generation; VcXsrv section writes the only entry when installed
- **Impact**: Clean config file, no conflicting duplicate values

## v1.0.4 Fixes (2026-03-09)

### 7. **WSLg Display Connection Bug (Critical)**
- **Problem**: Konsole fails with `qt.qpa.xcb: could not connect to display`
- **Root Cause**: When VcXsrv is not reachable, the fallback code used `unset DISPLAY` which removed the DISPLAY variable entirely. WSLg provides display `:0` but the script was clearing it.
- **Solution**: Changed `unset DISPLAY` to `export DISPLAY=:0` in kivun-launch.sh
- **Impact**: Konsole now launches successfully via WSLg

### 8. **Empty Installation WSL Path**
- **Problem**: `wslpath "%~dp0"` returned empty string (trailing backslash issue)
- **Solution**: Changed to `wslpath "%~dp0."` (dot removes trailing backslash)
- **Impact**: Bash script path now resolves correctly

### 9. **Bash Log Not Writing**
- **Problem**: WSL username (`username`) differs from Windows username (`noam`), so bash log path was wrong
- **Solution**: Pass bash log path from Windows as 5th parameter to kivun-launch.sh
- **Impact**: Bash log now captures all output including Konsole errors

### 10. **Enhanced Diagnostics**
- Added WSL version, status, and distributions to log header
- Added computer name and script location to log header
- Konsole errors captured (removed `2>/dev/null`)
- Log file shortcuts (`→ Windows Log.lnk`, `→ Bash Log.lnk`) in installation folder
- Start Menu shortcuts: View Windows Log, View Bash Log, Open Log Folder
- VcXsrv auto-selected by default in installer

## v1.0.3 Fixes (2026-03-09)

### 5. **claude-hebrew-konsole.bat Not Opening Konsole**
- **Problem**: Launcher was trying to invoke konsole directly from batch file with complex nested quotes
- **Root Cause**:
  - Not calling kivun-launch.sh helper script
  - Missing path conversion
  - Missing line ending fixes
  - Complex nested command structure failed
- **Solution**: Updated to match working kivun-terminal.bat pattern
  - Read config.txt for all settings (RESPONSE_LANGUAGE, PRIMARY_LANGUAGE, USE_VCXSRV)
  - Convert Windows paths to WSL paths using wslpath
  - Fix line endings in kivun-launch.sh (CRLF → LF)
  - Call kivun-launch.sh with all 4 parameters
  - Let kivun-launch.sh handle Konsole invocation
- **Impact**: Launcher now properly opens Konsole terminal window

### 6. **VcXsrv Duplicate Process Error**
- **Problem**: VcXsrv shows "Cannot establish any listening sockets" error
- **Root Cause**: Multiple VcXsrv instances trying to use display :0 (port conflict)
- **Symptoms**:
  - VcXsrv error dialog on launch
  - Konsole fails to open
  - Alt+Shift keyboard switching doesn't work
- **Solution**:
  - Kill duplicate VcXsrv processes: `taskkill /F /IM vcxsrv.exe`
  - Then launch again - fresh VcXsrv will start properly
  - Alternative: Switch to WSLg mode (USE_VCXSRV=false in config.txt)
- **Impact**: VcXsrv starts properly, keyboard switching works

## Problems Fixed

### 1. **Hidden Errors (Critical)**
- **Problem**: The `/min` flag minimized the window immediately, hiding all error messages
- **Solution**: Removed `/min` flag, allowing errors to be visible
- **Impact**: Users can now see what went wrong

### 2. **WSL Startup Delays**
- **Problem**: After Windows restart, WSL needs time to initialize
- **Solution**: Added WSL readiness check with automatic retry
- **Impact**: Launcher now waits for WSL and attempts restart if needed

### 3. **Silent Path Conversion Failures**
- **Problem**: Windows→WSL path conversion could fail silently
- **Solution**: Use explicit `wslpath` command with error checking
- **Impact**: Path conversion errors are now caught and reported

### 4. **No User Feedback**
- **Problem**: Users didn't know what was happening or what went wrong
- **Solution**: Added status messages at each step
- **Impact**: Clear visibility into launch process

## New Tools

### Debug Launcher (`kivun-terminal-debug.bat`)

A diagnostic version that shows detailed step-by-step progress:

```batch
========================================
  Kivun Terminal - Starting...
========================================

[1/5] Language: english
[2/5] Work dir: C:\Users\noam
[3/5] Checking WSL...
  WSL: OK
[4/5] Converting path...
  WSL path: /mnt/c/Users/noam
[5/5] Launching Konsole...
```

**When to use**: When the normal launcher fails and you need to see where it's failing.

### Diagnostic Tool (`diagnose.bat`)

System-wide diagnostic that checks all components:

- Windows version
- WSL installation and version
- Default distribution
- Ubuntu accessibility
- Konsole installation
- Claude Code installation
- Node.js version

**When to use**: To verify your system is configured correctly.

### Quick Fix Script (`fix-launcher.bat`)

Automatically updates launcher files to the latest fixed version:

- Backs up current launcher
- Installs fixed version
- Updates all shortcuts
- Tests WSL connectivity

**When to use**: To update an existing installation with the fixes.

## What Changed in the Launcher

### Before (Old Version)
```batch
start "Kivun Terminal" /min wsl bash -c "cd \"$(wslpath '%WORK_DIR%')\" 2>/dev/null || cd ~; ..."
```

**Issues**:
- `/min` hides errors
- `start` creates detached process
- Path conversion happens inline (no error checking)
- No WSL readiness check

### After (Fixed Version)
```batch
# Check WSL is running
wsl -d Ubuntu echo "WSL ready" >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: WSL/Ubuntu not responding
    wsl --shutdown
    timeout /t 2 /nobreak >nul
    wsl -d Ubuntu echo "WSL ready" >nul 2>&1
)

# Convert path with error checking
for /f "delims=" %%i in ('wsl wslpath "%WORK_DIR%" 2^>nul') do set "WSL_PATH=%%i"
if "%WSL_PATH%"=="" (
    set "WSL_PATH=~"
)

# Launch without /min, use & to background
wsl bash -c "cd '%WSL_PATH%' 2>/dev/null || cd ~; konsole ..." &
```

**Improvements**:
- WSL readiness check with retry
- Explicit path conversion with fallback
- No `/min` flag (errors visible)
- Background with `&` instead of `start /min`
- Clear status messages

## Testing the Fixes

### Test 1: After Fresh Boot

1. Restart Windows
2. Double-click "Kivun Terminal" desktop shortcut
3. **Expected**: Should show "Starting WSL..." and launch successfully
4. **If fails**: Run `diagnose.bat` to see what component is missing

### Test 2: Debug Mode

1. Run `kivun-terminal-debug.bat`
2. **Expected**: See all 5 steps complete successfully
3. **If fails**: Error message shows which step failed

### Test 3: Different Folders

1. Right-click a folder → Send To → Kivun Terminal
2. **Expected**: Terminal opens in that folder
3. **If fails**: Path conversion error will be shown

### Test 4: Manual Path

1. Run `kivun-terminal-choose-folder.bat`
2. Pick a folder with folder picker or type path
3. **Expected**: Terminal opens in chosen folder

## Troubleshooting

### Error: "WSL not responding"

**Cause**: WSL not installed or not set to Ubuntu as default

**Solutions**:
```batch
# Check WSL status
wsl --version
wsl -l -v

# Set Ubuntu as default
wsl --set-default Ubuntu

# Restart WSL
wsl --shutdown
wsl -d Ubuntu
```

### Error: "Path conversion failed"

**Cause**: Invalid Windows path or wslpath not working

**Solutions**:
- Verify the path exists in Windows
- Terminal will fall back to home directory (~)
- Try using a different folder

### Error: "Konsole failed to launch"

**Cause**: Konsole or Claude Code not installed in WSL

**Solutions**:
```batch
# Check installations
wsl -d Ubuntu which konsole
wsl -d Ubuntu which claude

# Re-run post-install
cd %LOCALAPPDATA%\Kivun
wsl bash post-install.sh
```

### Terminal still flashes and closes

**Solutions**:
1. Run `diagnose.bat` to check all components
2. Run `kivun-terminal-debug.bat` to see detailed errors
3. Run `fix-launcher.bat` to update to latest launcher
4. Check `README_INSTALLATION.md` for full setup guide

## For Developers

### Creating the Installer

The installer (`Kivun_Terminal_Setup.nsi`) now includes:

1. Updated launcher with WSL checks
2. Debug launcher for diagnostics
3. Diagnostic tool
4. Start Menu shortcuts for all tools

To rebuild the installer:

```batch
cd C:\Users\noam.ORHITEC\Downloads\ClaudeHebrew_Installer
makensis Kivun_Terminal_Setup.nsi
```

### Testing on Fresh PC

1. Install on clean Windows 11
2. After installation completes
3. **Don't restart yet** - Try desktop shortcut
4. Should see "Starting WSL..." message
5. If WSL needs restart, launcher will show clear message

## UX Improvements (v1.0.3)

### Window Title
- Konsole window title shows "Kivun Terminal" instead of "bash - Konsole"
- Uses `wmctrl`/`xdotool` to rename the window after launch (auto-installed)

### Window Size
- Konsole opens maximized (full size with title bar visible)

### Cursor and Colors
- Cursor color changed from pink to blue (#0050C8)
- Blue/cyan ANSI colors darkened for better contrast on light blue background

### Desktop Shortcuts
- Two desktop shortcuts: "Kivun Terminal" and "Kivun Terminal (Choose Folder)"
- Send To menu entry: right-click any file/folder → Send To → Kivun Terminal

### Cmd Window
- Title says "Kivun Terminal - Loading (you can ignore this window)"
- Shows message: "This window will close automatically. Focus on the Konsole window."

### Launch Architecture
- New `kivun-launch.sh` script handles profile deployment, window title, and maximize
- Profile and color scheme are written inline (no external file dependencies)
- Auto-installs `wmctrl` and `xdotool` if missing

## Summary

### Key Parameters Passed to kivun-launch.sh (v1.0.4)

1. `WSL_PATH` - Working directory in WSL format
2. `CLAUDE_PROMPT` - System prompt based on RESPONSE_LANGUAGE
3. `PRIMARY_LANGUAGE` - Keyboard layout (e.g., "hebrew", "arabic")
4. `USE_VCXSRV` - X server mode ("true" or "false")
5. `BASH_LOG_WSL` - Path to bash log file in WSL format (NEW in v1.0.4)

All 5 parameters are required for proper operation.

## Summary

The key insight was that `/min` flag was masking all errors. By removing it and adding proper error handling, users can now:

- See what's happening during launch
- Diagnose issues themselves with `diagnose.bat`
- Use debug mode to pinpoint exact failure point
- Get clear error messages with suggested solutions

This makes the launcher much more reliable and debuggable across different PCs and system states.
