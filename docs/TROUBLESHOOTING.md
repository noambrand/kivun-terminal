# Troubleshooting Guide

## Comprehensive Diagnostic Logging

Kivun Terminal now includes comprehensive logging to help diagnose any issues.

### How It Works

Every time you launch Kivun Terminal, it creates detailed logs showing:
- What checks were performed (WSL, Ubuntu, Konsole, Claude)
- Which checks passed and which failed
- Any error messages or warnings
- Configuration settings used
- Path conversions
- Launch commands executed

### Log File Locations

Two log files are created automatically:

1. **Windows Launcher Log**
   - Location: `%LOCALAPPDATA%\Kivun\LAUNCH_LOG.txt`
   - Full path: `C:\Users\[YourUsername]\AppData\Local\Kivun\LAUNCH_LOG.txt`
   - Shortcut: `→ Windows Log.lnk` in the Kivun folder
   - Contains: Windows batch script execution details, WSL version/status/distributions

2. **Bash Launcher Log**
   - Location: `%LOCALAPPDATA%\Kivun\BASH_LAUNCH_LOG.txt`
   - Full path: `C:\Users\[YourUsername]\AppData\Local\Kivun\BASH_LAUNCH_LOG.txt`
   - Shortcut: `→ Bash Log.lnk` in the Kivun folder
   - Contains: Bash script execution details (keyboard setup, display connection, Konsole launch, errors)

### Reporting Issues

If Kivun Terminal doesn't work on your PC:

#### Step 1: Try Launching

1. Double-click the Kivun Terminal shortcut (Desktop or Start Menu)
2. **The diagnostic window will now stay open** (it won't close automatically)
3. Read the messages in the window to see what happened
4. Note any errors or warnings

#### Step 2: Collect Diagnostic Logs

Go to **Start Menu → Kivun Terminal → "Collect Diagnostic Logs"**

This will create a comprehensive report on your Desktop called:
**`Kivun_Diagnostic_Report.txt`**

The report includes:
- Both log files (Windows and Bash)
- System information (Windows version, WSL version)
- WSL status
- Ubuntu accessibility check

#### Step 3: Share the Report

When reporting an issue, simply attach the `Kivun_Diagnostic_Report.txt` file from your Desktop.

This gives complete diagnostic information without needing to manually run commands or copy/paste outputs.

## Common Issues

### Issue: Konsole Doesn't Launch (qt.qpa.xcb error)

**Log shows:**
```
qt.qpa.xcb: could not connect to display
qt.qpa.plugin: Could not load the Qt platform plugin "xcb"
```

**Cause:** Fixed in v1.0.4. The WSLg display fallback was using `unset DISPLAY` which removed the display variable entirely. WSLg provides display `:0` but the script was clearing it.

**Solution:**
1. **Update to v1.0.4** — This bug is fixed. The script now sets `export DISPLAY=:0` for WSLg fallback instead of unsetting it.
2. **If still having issues after update:** Check that WSLg is working: `wsl bash -c 'echo $DISPLAY'` should show `:0`
3. **Alternative:** Run Claude directly in WSL terminal: `wsl -d Ubuntu -- bash -l -c "claude"`

### Issue: Window Opens and Closes Immediately

**Before:** No way to see what went wrong.

**Now (v1.0.4):** The desktop shortcut launcher shows "Konsole launching..." for 2 seconds then exits. The main launcher stays open. Check the log files for details:
- `→ Windows Log.lnk` — shortcut in the Kivun installation folder
- `→ Bash Log.lnk` — shortcut in the Kivun installation folder
- Start Menu → Kivun Terminal → View Windows Log / View Bash Log

### Issue: WSL Not Found

**Log will show:**
```
[14:30:15] ERROR - WSL not found or not working (error 1)
```

**Solution:** Run the Kivun Terminal installer to set up WSL.

### Issue: Ubuntu Not Responding

**Log will show:**
```
[14:30:20] WARNING - Ubuntu not responding, attempting WSL restart
[14:30:23] SUCCESS - Ubuntu is now responding after restart
```

or

```
[14:30:20] WARNING - Ubuntu not responding, attempting WSL restart
[14:30:23] ERROR - Ubuntu not available after restart (error 1)
```

**Solution:** If restart fails, run: `wsl --install -d Ubuntu` in PowerShell (admin).

### Issue: Konsole Not Starting

**Log will show:**
```
[14:30:28] WARNING - Konsole process not detected, may not have started (WSLg issue?)
[14:30:30] INFO - Falling back to direct Claude execution in terminal
```

**Possible causes:**
- WSLg not available on this Windows version (requires Windows 11 or Windows 10 with updates)
- Graphics drivers issue
- WSL configuration issue

**Solution:** The launcher will automatically fall back to running Claude directly in the terminal.

### Issue: VcXsrv Mode Not Working / Alt+Shift Not Switching Languages

**Log will show:**
```
[14:30:25] INFO - VcXsrv mode enabled, testing connection
[14:30:26] WARNING - VcXsrv not reachable, falling back to WSLg
```

**Cause (fixed in v1.0.5):** VcXsrv was launched with access control enabled (`DisableAC="False"` in `kivun.xlaunch`), blocking WSL connections. The script fell back to WSLg where Alt+Shift doesn't work.

**Solution:**
1. **Update to v1.0.5** — This is fixed. VcXsrv now launches with `DisableAC="True"`.
2. **Manual fix:** Edit `kivun.xlaunch` in the Kivun folder, change `DisableAC="False"` to `DisableAC="True"`, then kill VcXsrv (`taskkill /F /IM vcxsrv.exe`) and relaunch.
3. **If VcXsrv not installed:** Install it via the installer or set `USE_VCXSRV=false` in config.txt.

### Issue: Two Konsole Windows Open

**Cause (fixed in v1.0.5):** Desktop shortcut triggered duplicate launches.

**Solution:** Update to v1.0.5. The launcher now checks if Konsole is already running (`pgrep -x konsole`) and skips duplicate launches.

### Issue: Folder Picker Not Working ("Choose Folder" shortcut)

**Cause (fixed in v1.0.5):** `folder-picker.vbs` was missing from the installer package.

**Solution:** Update to v1.0.5. The folder picker VBScript is now included in the installer.

## Manual Log Inspection

If you want to check the logs yourself before reporting:

### Windows:

1. Press `Win + R`
2. Type: `%LOCALAPPDATA%\Kivun`
3. Press Enter
4. Open `LAUNCH_LOG.txt` in Notepad

### Bash Log:

1. Follow steps above
2. Open `BASH_LAUNCH_LOG.txt` in Notepad

## Log Format

Logs use a clear timestamp format:

```
========================================
KIVUN TERMINAL LAUNCH LOG
========================================
Date: Mon 03/09/2026 16:32:43.70
User: noam
Computer: NOAMB-PC
Working Directory: C:\Users\noam.ORHITEC\AppData\Local\Kivun
Script Location: C:\Users\noam.ORHITEC\AppData\Local\Kivun\
========================================
WSL VERSION:
WSL version: 2.6.3.0
Kernel version: 6.6.87.2-1
...
========================================

[16:32:44] START - Launching Kivun Terminal (Desktop Shortcut Mode)
[16:32:44] INFO - Using default work directory: C:\Users\noam.ORHITEC
[16:32:44] INFO - Reading config.txt
[16:32:44] SUCCESS - Installation WSL path: /mnt/c/Users/noam.ORHITEC/AppData/Local/Kivun/
[16:32:44] INFO - Bash log WSL path: /mnt/c/Users/.../BASH_LAUNCH_LOG.txt
[16:32:44] SUCCESS - Launch command executed
...
```

## Getting Help

If the logs don't help you diagnose the issue:

1. Collect the diagnostic report (Start Menu → Collect Diagnostic Logs)
2. Share the `Kivun_Diagnostic_Report.txt` file
3. Include any specific error messages from the launcher window

This provides complete information needed to diagnose and fix the issue.

## Log History

Logs **append** rather than overwrite, so you can see the history of all launch attempts. This helps identify patterns (e.g., "it works sometimes but not always").

If the log files become too large, you can safely delete them - they'll be recreated on the next launch.
