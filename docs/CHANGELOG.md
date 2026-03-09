# Changelog

All notable changes to Kivun Terminal for Claude Code will be documented in this file.

## [1.0.5] - 2026-03-09

### Fixed - Keyboard Switching & Double Launch

- **VcXsrv access control blocking WSL connections** - `DisableAC="False"` in `kivun.xlaunch` prevented WSL from connecting to VcXsrv. Changed to `DisableAC="True"`. Alt+Shift keyboard switching now works when VcXsrv is installed.
- **Duplicate Konsole window on launch** - Clicking desktop shortcut opened two Konsole terminals. Replaced overcomplicated lock file approach (race conditions, stale files, cleanup at every exit point) with a single `pgrep -x konsole` check in `kivun-launch.sh`.
- **Folder picker missing from installer** - "Choose Folder" shortcut fell through to manual path entry because `folder-picker.vbs` was never packaged in the installer. Now included.
- **Duplicate USE_VCXSRV in config.txt** - Installer wrote `USE_VCXSRV=false` initially, then VcXsrv section appended `USE_VCXSRV=true`, creating two conflicting lines. Removed the initial `false` line; VcXsrv section now writes the only entry.
- **Hardcoded path in folder-picker.vbs** - Start path was hardcoded to a specific user. Now uses `%USERPROFILE%` dynamically.

### Removed
- Lock file code from `claude-hebrew-konsole.bat` and `kivun-terminal.bat` (replaced by pgrep check)

## [1.0.4] - 2026-03-09

### Fixed - Critical Display Connection Bug

**Root Cause Identified:** WSLg fallback used `unset DISPLAY` which removed the display variable entirely. Konsole had no display to connect to, failing with `qt.qpa.xcb: could not connect to display`.

**Solution:** Changed to `export DISPLAY=:0` for WSLg fallback. WSLg provides display `:0` via `/tmp/.X11-unix/X0`.

### Fixed - Launch Issues
- **WSLg display connection** - `unset DISPLAY` → `export DISPLAY=:0` (critical fix that made Konsole launch work)
- **Empty installation path** - `wslpath "%~dp0"` returned empty → fixed with `"%~dp0."` (removes trailing backslash)
- **Bash log not writing** - WSL username (`username`) ≠ Windows username (`noam`) → log path now passed from Windows as 5th parameter to kivun-launch.sh
- **Desktop launcher blocking** - Removed `pause` that blocked the launcher; now shows "Konsole launching..." for 2 seconds then exits
- **Konsole errors hidden** - Removed `2>/dev/null` from Konsole launch; errors now captured in bash log

### Added - Enhanced Diagnostics
- **Comprehensive logging** - WSL version, WSL status, WSL distributions, computer name, script location all logged on every launch
- **Log file shortcuts** - `→ Windows Log.lnk` and `→ Bash Log.lnk` created in installation folder for quick access
- **Start Menu shortcuts** - "Open Log Folder", "View Windows Log", "View Bash Log" added
- **VcXsrv auto-selected** - VcXsrv component now checked by default during installation
- **OPEN_LOG_FOLDER.bat** - Opens log folder in Explorer

### Verified Working
- ✅ Konsole launches successfully via WSLg (DISPLAY=:0)
- ✅ Konsole launches successfully via VcXsrv (DISPLAY=host:0)
- ✅ Both log files populate correctly
- ✅ All 10 RTL languages supported
- ✅ Alt+Shift keyboard switching (VcXsrv mode)

## [1.0.3] - 2026-03-09

### Fixed - Launcher and VcXsrv Issues

- **Launcher Not Opening Konsole**: Fixed `claude-hebrew-konsole.bat` not properly launching Konsole terminal
  - Updated to match working `kivun-terminal.bat` pattern
  - Now properly calls `kivun-launch.sh` with all parameters
  - Converts Windows paths to WSL paths correctly
  - Fixes line endings (CRLF → LF) before launch

- **Desktop Shortcuts Opening Wrong Terminal**: Fixed shortcuts falling back to CMD instead of Konsole
  - Updated all shortcuts to point to `claude-hebrew-konsole.bat` (no fallback)
  - Added `fix-shortcuts.bat` script to update existing shortcuts

- **VcXsrv Duplicate Process Error**: Fixed "Cannot establish any listening sockets" error

- **Default VcXsrv Mode Issue**: Changed default from VcXsrv to WSLg for better compatibility

### Added - Comprehensive Logging
- Windows launcher log (`LAUNCH_LOG.txt`)
- Bash launcher log (`BASH_LAUNCH_LOG.txt`)
- "Collect Diagnostic Logs" Start Menu shortcut
- `COLLECT_LOGS.bat` for one-click log collection
- `docs/TROUBLESHOOTING.md` guide

### Documentation
- Added VcXsrv troubleshooting to README_INSTALLATION.md
- Updated all docs to reflect working state

## [1.0.2] - 2026-03-08

### Added - 10 RTL Language Support
- **Comprehensive RTL Language Support**: Added support for 10 major RTL languages
  - Hebrew (עברית) - Default selection, tech hub language
  - Arabic (العربية) - Most widely spoken RTL language
  - Persian/Farsi (فارسی) - Iran, Afghanistan
  - Urdu (اردو) - Pakistan, India
  - Pashto (پښتو) - Afghanistan, Pakistan
  - Kurdish (کوردی) - Kurdistan region
  - Dari (دری) - Afghanistan (Persian variant)
  - Uyghur (ئۇيغۇرچە) - China (Xinjiang)
  - Sindhi (سنڌي) - Pakistan, India
  - Azerbaijani (آذربایجان) - Azerbaijan (Arabic script)
- Hebrew as default language selection
- English as default response language (optimal for technical content)
- Language selection in installer wizard with native script display
- Separate PRIMARY_LANGUAGE (RTL display) and RESPONSE_LANGUAGE (Claude responses)
- Unicode UTF-8 encoding throughout installer (no encoding issues)
- Updated all documentation to reflect 10-language support

### Fixed - Critical Bugs
- **Git Detection False Positives**: Fixed Git Bash detection always failing when WSL installed
  - Changed detection from `where bash` to `where git.exe` (prevents WSL bash false positives)
  - Git now correctly detected on systems with WSL
  - No more unnecessary Git installations when Git already present

- **Ubuntu Re-installation Bug**: Fixed Ubuntu being re-installed even when already working
  - Restructured WSL section flow with proper label placement
  - Ubuntu installation now properly skipped when detected as working
  - Significantly faster on systems with existing Ubuntu

- **WSL Path Conversion**: Fixed script execution failures in WSL
  - Added `WindowsToWSLPath` function to convert Windows paths to WSL format
  - Scripts (init-ubuntu.sh, post-install.sh) now execute correctly
  - Proper handling of `C:\path\file` → `/mnt/c/path/file` conversion

- **Ubuntu User Creation Failure**: Fixed "Failed to create Ubuntu user" error after restart
  - Use `ubuntu.exe config --default-user root` before user creation
  - Properly set default user context before running WSL commands
  - Prevents installation loop and user creation failures
  - Resolves "ERROR: Failed to create Ubuntu user" abort issue

### Added
- State file tracking (`.wsl-updated`) for multi-run installations
  - Prevents duplicate WSL checks after restart
  - Faster second run when restart required
- Error checking after all critical operations
  - User creation validation
  - WSL availability checks
  - Post-install script error detection
- Ubuntu installation polling (replaces fixed sleep)
  - Polls every 2 seconds until ready
  - 2-minute timeout with warning
  - Continues immediately when Ubuntu ready

### Improved
- **Git Made Optional**: Git Bash no longer required for WSL
  - Section marked as "Optional" in installer
  - Can be deselected without affecting installation
  - Modern WSL doesn't need Git on Windows side
- Enhanced user verification
  - Detects partial installation states
  - Handles Ubuntu installed but user not configured
- Removed duplicate WSL update logic
- Better error messages with actionable next steps
- Comprehensive installation documentation

### Documentation
- `INSTALLER_FIXES_APPLIED.md` - Detailed documentation of all fixes
- `IMPLEMENTATION_SUMMARY.md` - Quick reference guide
- `test-installer-fixes.bat` - Verification script for fixes
- Updated installation guides with new behavior

## [1.0.1] - 2026-03-08

### Fixed
- **Git Installation Error**: Fixed "The following process(es) use Git for Windows" error
  - Git installation now ALWAYS skipped if Git already detected, regardless of checkbox state
  - Added runtime detection in Git section - checks `where bash` before attempting install
  - Removed `/CLOSEAPPLICATIONS` flag to prevent conflicts with running Git processes
  - **Users can now click "Next" without unchecking - installer automatically skips Git**

### Added
- `INSTALL_TROUBLESHOOTING.md` - Comprehensive installation troubleshooting guide
- `docs/QUICK_FIX_GIT_ERROR.txt` - Quick reference for Git installation errors
- Auto-detection of existing Git installation in installer initialization

### Improved
- Installer now detects existing Git Bash and skips installation automatically
- Better error messages when Git is already installed
- Reduced conflicts with running terminal processes during installation

## [1.0.0] - 2026-03-08

### Added
- Initial release
- Complete installer with wizard interface
- Automatic installation of Git Bash, WSL 2, Ubuntu, Konsole terminal
- Hebrew RTL/BiDi support with optimized fonts
- Configurable language preference (English/Hebrew)
- One-click launcher for Claude Code in Konsole
- Comprehensive documentation and guides
- Diagnostic and cleanup utilities
- Advanced installation options for power users
- Developer resources for customization

### Features
- ✅ Auto-installs all dependencies (Git, WSL, Ubuntu, Node.js)
- ✅ Konsole terminal with proper Hebrew text rendering
- ✅ Optimized Hebrew fonts (Noto Sans Mono, DejaVu Sans Mono)
- ✅ Configurable response language
- ✅ Security-focused with documented credential options
- ✅ Full Claude Code functionality

### System Requirements
- Windows 10/11 with Administrator access
- Anthropic API Key required

---

## Version History

### Version Numbering
- **Major.Minor.Patch** (e.g., 1.0.0)
- Major: Breaking changes or significant new features
- Minor: New features, backward compatible
- Patch: Bug fixes and minor improvements
