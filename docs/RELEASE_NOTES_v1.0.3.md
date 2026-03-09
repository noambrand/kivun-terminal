# Kivun Terminal v1.0.3 / v1.0.4 - Release Notes

**Release Date**: 2026-03-09

> **Note:** v1.0.4 fixes the critical WSLg display connection bug that prevented Konsole from launching. See section 5 below.

## What's Fixed

### 1. Launcher Not Opening Konsole ✅

**Issue**: `claude-hebrew-konsole.bat` was not properly opening the Konsole terminal window.

**Root Cause**:
- Launcher was trying to invoke konsole directly from batch file with complex nested quotes
- Not using the kivun-launch.sh helper script
- Missing Windows→WSL path conversion
- Missing line ending fixes (CRLF → LF)

**Solution**:
- Updated `claude-hebrew-konsole.bat` to match the working `kivun-terminal.bat` pattern
- Now properly calls `kivun-launch.sh` with all 4 parameters
- Converts paths using `wslpath` command
- Fixes line endings before launch
- Lets kivun-launch.sh handle all Konsole configuration

**Impact**: Double-clicking the launcher now properly opens Konsole terminal with Claude Code.

---

### 2. Desktop Shortcuts Opening Wrong Terminal ✅

**Issue**: Desktop shortcuts and "Send To" were opening Claude Code in Windows CMD instead of Konsole terminal.

**Root Cause**:
- Shortcuts pointed to `kivun-terminal.bat` which has fallback logic
- When Konsole fails to start, `kivun-terminal.bat` falls back to `:run_direct`
- Fallback runs Claude directly in CMD window (lines 148-154)
- User sees "wrong terminal" - Windows CMD instead of Konsole

**Solution**:
- Updated all shortcuts to point to `claude-hebrew-konsole.bat` instead
- `claude-hebrew-konsole.bat` has no fallback - always tries to open Konsole
- Updated NSIS installer (lines 254, 937, 939, 1011-1013)
- Created `fix-shortcuts.bat` to update existing shortcuts

**Quick Fix for Existing Installations**:
```cmd
fix-shortcuts.bat
```
This recreates desktop and SendTo shortcuts with correct target.

**Impact**: Desktop shortcuts and "Send To" now properly open Konsole terminal.

---

### 3. VcXsrv Duplicate Process Error ✅

**Issue**: VcXsrv shows error "Cannot establish any listening sockets - Make sure an X server isn't already running"

**Root Cause**:
- Multiple VcXsrv instances running simultaneously
- All trying to use display :0
- Port conflict prevents new instances from starting

**Symptoms**:
- VcXsrv error dialog on launch
- Konsole fails to open
- Alt+Shift keyboard switching doesn't work

**Solution**:
```cmd
taskkill /F /IM vcxsrv.exe
```
Then launch again - fresh VcXsrv will start properly.

**Alternative**: Switch to WSLg mode
- Edit `config.txt`: Set `USE_VCXSRV=false`
- Or use: Start Menu → Kivun Terminal → Keyboard Mode

**Impact**: VcXsrv starts cleanly, keyboard switching works, Konsole opens properly.

---

### 4. Default VcXsrv Mode Changed ✅

**Issue**: Installer set USE_VCXSRV=true by default, but VcXsrv component is optional, causing Konsole launch failures.

**Root Cause**:
- If USE_VCXSRV=true but VcXsrv not installed/running
- kivun-launch.sh tries to connect to VcXsrv X server
- Connection fails, Konsole won't start
- User sees "old terminal" (CMD fallback) or nothing

**Solution**:
- Changed default to USE_VCXSRV=false
- WSLg mode works out-of-box on all Windows 10/11 systems
- VcXsrv is now truly optional (for Alt+Shift keyboard switching only)
- Updated config.txt default value
- Updated installer to set false by default

**Impact**: Konsole launches successfully on all PCs by default, maximum compatibility.

---

### 5. WSLg Display Connection Bug (v1.0.4) ✅

**Issue**: Konsole fails with `qt.qpa.xcb: could not connect to display` even though WSLg is working.

**Root Cause**:
- When VcXsrv is not reachable, kivun-launch.sh fallback used `unset DISPLAY`
- This removed the DISPLAY variable entirely
- WSLg provides display `:0` via `/tmp/.X11-unix/X0`
- But with DISPLAY unset, Konsole had no display to connect to

**Solution**:
- Changed `unset DISPLAY` to `export DISPLAY=:0` in kivun-launch.sh
- Also fixed: empty installation path (`"%~dp0"` → `"%~dp0."`)
- Also fixed: bash log path passed from Windows (WSL username ≠ Windows username)
- Also fixed: desktop launcher no longer blocks with `pause`
- Also fixed: Konsole errors captured in log (removed `2>/dev/null`)

**Impact**: Konsole now launches successfully on all systems with WSLg.

---

## What's Verified Working

After these fixes, all features confirmed working:

- ✅ **Fonts**: Noto Sans Mono, DejaVu Sans Mono, Liberation, FreeFont
- ✅ **Alt+Shift Keyboard Switching**: Working in VcXsrv mode
- ✅ **Color Scheme**: ColorSchemeNoam (light blue background #C8E6FF)
- ✅ **Konsole Profile**: Blue cursor, 10K history, "Kivun Terminal" title
- ✅ **Window Management**: wmctrl/xdotool renaming and maximizing
- ✅ **10 RTL Languages**: Hebrew, Arabic, Persian, Urdu, Pashto, Kurdish, Dari, Uyghur, Sindhi, Azerbaijani
- ✅ **Configuration**: config.txt with RESPONSE_LANGUAGE, PRIMARY_LANGUAGE, USE_VCXSRV

---

## Updated Files

**Core Files:**
- `claude-hebrew-konsole.bat` - Fixed launcher
- `CHANGELOG.md` - Version 1.0.3 entry
- `START_HERE.txt` - Updated version, added VcXsrv troubleshooting
- `README.md` - Added v1.0.3 features
- `README_INSTALLATION.md` - Added VcXsrv and launcher troubleshooting
- `QUICK_START.md` - Updated version, added VcXsrv troubleshooting
- `LAUNCHER_FIXES.md` - Added v1.0.3 fixes section

**No Changes to Working Files:**
- `kivun-terminal.bat` - Already working correctly
- `kivun-launch.sh` - Handles all Konsole configuration (working)
- `config.txt` - Configuration file (working)
- `post-install.sh` - Dependency installation (working)
- `ClaudeHebrew.profile` - Konsole profile (working)
- `ColorSchemeNoam.colorscheme` - Color scheme (working)

---

## Upgrade Instructions

**If you're using v1.0.2:**

1. **No reinstallation needed** - Just update the launcher file
2. Copy new `claude-hebrew-konsole.bat` to your installation folder
3. If VcXsrv error appears: `taskkill /F /IM vcxsrv.exe`
4. Launch again - should work properly

**Fresh Installation:**
- Use the installer as normal
- All fixes are already included

---

## Troubleshooting

### VcXsrv Error Persists

**Check for running processes:**
```cmd
wmic process where "name='vcxsrv.exe'" get ProcessId,CommandLine
```

**Kill all instances:**
```cmd
taskkill /F /IM vcxsrv.exe
```

**Or switch to WSLg mode:**
1. Edit `config.txt`
2. Set `USE_VCXSRV=false`
3. Relaunch

### Launcher Still Not Opening Konsole

**Use the production launcher:**
- `kivun-terminal.bat` (most robust)

**Or debug mode:**
- `kivun-terminal-debug.bat` (shows detailed progress)

**Run diagnostics:**
```cmd
diagnose.bat
```

---

## Technical Details

### Launcher Architecture (Corrected in v1.0.3)

```
Windows User Double-clicks claude-hebrew-konsole.bat
          ↓
Read config.txt (RESPONSE_LANGUAGE, PRIMARY_LANGUAGE, USE_VCXSRV)
          ↓
Convert Windows paths → WSL paths (wslpath)
          ↓
Fix line endings in kivun-launch.sh (sed -i "s/\r$//")
          ↓
start /min wsl -d Ubuntu bash kivun-launch.sh [params]
          ↓
[Inside WSL] kivun-launch.sh
  ├─ Fix XDG_RUNTIME_DIR
  ├─ Configure keyboard (setxkbmap)
  ├─ Deploy Konsole profile & color scheme
  ├─ Create temp launcher script
  ├─ Launch konsole --profile ClaudeHebrew
  └─ Window management (wmctrl/xdotool)
          ↓
[Inside Konsole] Claude Code runs
```

### Key Parameters Passed to kivun-launch.sh

1. `WSL_PATH` - Working directory in WSL format (e.g., `/mnt/c/Users/username`)
2. `CLAUDE_PROMPT` - System prompt based on RESPONSE_LANGUAGE
3. `PRIMARY_LANGUAGE` - Keyboard layout (e.g., "hebrew", "arabic")
4. `USE_VCXSRV` - X server mode ("true" or "false")
5. `BASH_LOG_WSL` - Path to bash log file in WSL format (v1.0.4)

All 5 parameters are required for proper operation.

---

## Version Comparison

| Feature | v1.0.2 | v1.0.3 | v1.0.4 |
|---------|--------|--------|--------|
| Smart Installer | ✅ | ✅ | ✅ |
| 10 RTL Languages | ✅ | ✅ | ✅ |
| claude-hebrew-konsole.bat | ❌ Broken | ✅ Fixed | ✅ Fixed |
| VcXsrv Duplicate Process | ⚠️ Issue | ✅ Fixed | ✅ Fixed |
| WSLg Display Connection | ❌ Broken | ❌ Broken | ✅ Fixed |
| Diagnostic Logging | ❌ None | ✅ Basic | ✅ Enhanced |
| Log File Shortcuts | ❌ None | ❌ None | ✅ Added |
| VcXsrv Auto-Select | ❌ No | ❌ No | ✅ Yes |

---

## Credits

**Fixed by**: Claude Sonnet 4.5
**Reported by**: User testing
**Date**: 2026-03-09

---

## Next Steps

After upgrading to v1.0.3:

1. ✅ **Test the launcher**: Double-click `claude-hebrew-konsole.bat`
2. ✅ **Verify Konsole opens**: Window title should be "Kivun Terminal"
3. ✅ **Check color scheme**: Light blue background
4. ✅ **Test keyboard switching**: Alt+Shift (if USE_VCXSRV=true)
5. ✅ **Start coding**: Claude Code should be ready to use

**Enjoy the fixed launcher!** 🚀

---

**For support**: See `README_INSTALLATION.md` for full troubleshooting guide.
