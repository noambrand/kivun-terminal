# Kivun Terminal - Quick Start Guide

## What is Kivun Terminal?

Kivun Terminal provides RTL (Right-to-Left) language support for Claude Code on Windows, enabling proper Hebrew display in the terminal.

**Version 1.0.5** - Fixed VcXsrv keyboard switching (Alt+Shift now works), fixed duplicate Konsole window, fixed folder picker, fixed duplicate config entries.

## Installation

1. Run `Kivun_Terminal_Setup.exe` as Administrator
2. Follow the wizard:
   - Choose language (English/Hebrew)
   - Set Ubuntu credentials (or use defaults)
   - Select components (Git is optional)
3. Wait for installation (restarts automatically if needed)

**Smart Installation**: The installer automatically detects what you already have and skips it!

## First Time Setup

After installation:

1. **Check if everything is installed**
   - Run: `diagnose.bat`
   - All checks should show "OK"

2. **Launch Kivun Terminal**
   - Double-click desktop shortcut "Kivun Terminal" (opens in home folder)
   - Or double-click "Kivun Terminal (Choose Folder)" (pick a project folder)
   - Or use Start Menu → Kivun Terminal

## Using Kivun Terminal

### Method 1: Default Launch (Home Directory)

Double-click the desktop shortcut "Kivun Terminal" - opens maximized in your home folder.

A small cmd window appears briefly saying "you can ignore this window" - it closes automatically.

### Method 2: Choose a Folder

1. Double-click desktop shortcut "Kivun Terminal (Choose Folder)"
2. Or: Start Menu → Kivun Terminal → Choose Folder
3. Pick a folder using the folder picker
4. Or type/paste the path

### Method 3: Right-Click Send To

1. Right-click any file or folder in Windows Explorer
2. Send To → Kivun Terminal
3. Terminal opens in that folder

### Method 4: Right-Click Context Menu

1. Right-click any folder in Windows Explorer
2. Select "Open with Kivun Terminal"
3. Terminal opens in that folder

## Keyboard Language Switching

**With VcXsrv (recommended, fixed in v1.0.5):** Alt+Shift toggles between Hebrew and English. VcXsrv is auto-selected during installation and keyboard switching works out of the box.

**Without VcXsrv (WSLg mode):** Alt+Shift does not work reliably. The keyboard defaults to your selected language and cannot be switched with a shortcut while inside Konsole. This is a known WSLg limitation.

**To toggle keyboard mode after installation:**
- Start Menu -> Kivun Terminal -> Keyboard Mode
- Or run `kivun-toggle-vcxsrv.bat` from the installation folder

## If Something Goes Wrong

### The window flashes and closes immediately

**Solution 1**: Run Debug Mode
```
Start Menu → Kivun Terminal → Debug Mode
```
This shows detailed step-by-step progress and any errors.

**Solution 2**: Run Diagnostics
```
Start Menu → Kivun Terminal → Diagnostics
```
This checks all components and shows what's missing.

### After Windows Restart

The launcher automatically handles WSL startup delays. You might see:
```
Starting WSL...
```
This is normal! WSL needs a few seconds to start after a reboot.

### WSL Not Responding

If you see "WSL not responding":

1. Open Command Prompt or PowerShell
2. Run: `wsl --shutdown`
3. Wait 5 seconds
4. Try launching Kivun Terminal again

## Configuration

### Change Language Preference

1. Start Menu → Kivun Terminal → Configuration
2. Edit the line: `RESPONSE_LANGUAGE=english` or `RESPONSE_LANGUAGE=hebrew`
3. Save and close

### Change Ubuntu Credentials

Edit the same config file:
```
USERNAME=your_username
PASSWORD=your_password
```

## Files and Folders

Everything is installed in: `%LOCALAPPDATA%\Kivun`

Key files:
- `kivun-terminal.bat` - Main launcher
- `kivun-terminal-debug.bat` - Debug mode launcher
- `diagnose.bat` - System diagnostics
- `config.txt` - Your configuration
- `post-install.sh` - Re-runs Ubuntu setup if needed
- `LAUNCH_LOG.txt` - Windows launcher log
- `BASH_LAUNCH_LOG.txt` - Bash launcher log
- `→ Windows Log.lnk` - Shortcut to open Windows log
- `→ Bash Log.lnk` - Shortcut to open Bash log

## Getting Help

1. **First**: Run `diagnose.bat` to check your system
2. **Second**: Run `kivun-terminal-debug.bat` to see detailed errors
3. **Check**: `README_INSTALLATION.md` for full documentation
4. **Check**: `LAUNCHER_FIXES.md` for technical details

## Common Issues

### "Konsole not found"

Re-run the Ubuntu setup:
```
cd %LOCALAPPDATA%\Kivun
wsl bash post-install.sh
```

### "Claude Code not found"

Install Claude Code:
```
wsl -d Ubuntu
npm install -g @anthropic-ai/claude-code
```

### "Ubuntu not responding"

Set Ubuntu as default:
```
wsl --set-default Ubuntu
```

### Konsole doesn't launch (qt.qpa.xcb error)

**Fixed in v1.0.4**: WSLg display connection bug fixed (`unset DISPLAY` → `export DISPLAY=:0`).

If you're on an older version, update to v1.0.4. Check bash log for details:
- Start Menu → Kivun Terminal → View Bash Log
- Or open `→ Bash Log.lnk` in the Kivun folder

### VcXsrv Error "Cannot establish listening sockets"

**Quick Fix**:
```cmd
taskkill /F /IM vcxsrv.exe
```
Then launch Kivun Terminal again.

### Checking logs

Two ways to access logs:
1. **In Kivun folder**: Click `→ Windows Log.lnk` or `→ Bash Log.lnk`
2. **Start Menu**: Kivun Terminal → View Windows Log / View Bash Log
3. **Collect all**: Start Menu → Kivun Terminal → Collect Diagnostic Logs

## Advanced Features

### Debug Mode

Shows each step of the launch process:
- Language detection
- Working directory
- WSL status
- Path conversion
- Konsole launch

Use this when normal launcher fails.

### Diagnostics

Checks 7 components:
1. Windows version
2. WSL installation
3. Default distribution
4. Ubuntu access
5. Konsole installation
6. Claude Code installation
7. Node.js version

### Quick Fix

If launcher is not working:
```
cd %LOCALAPPDATA%\Kivun
fix-launcher.bat
```

This updates the launcher to the latest fixed version.

## Tips

- The launcher shows status messages - read them!
- If you see an error, it will tell you how to fix it
- Debug mode is your friend when troubleshooting
- After Windows updates, WSL might need a moment to start

## Uninstalling

Start Menu → Kivun Terminal → Uninstall

Note: This removes Kivun Terminal but keeps WSL and Ubuntu for potential reuse.

---

**Enjoy using Kivun Terminal! 🚀**

For technical details, see: `LAUNCHER_FIXES.md`
For installation details, see: `README_INSTALLATION.md`
