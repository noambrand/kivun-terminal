# Kivun Terminal for Claude Code - RTL Language Support

**Professional terminal solution with RTL (Right-to-Left) BiDi support**

Complete installation package that sets up Claude Code with proper RTL text rendering in Konsole terminal (WSL + Ubuntu).

**10 Supported RTL Languages**:
- Hebrew (עברית) • Arabic (العربية) • Persian (فارسی) • Urdu (اردو) • Pashto (پښتو)
- Kurdish (کوردی) • Dari (دری) • Uyghur (ئۇيغۇرچە) • Sindhi (سنڌي) • Azerbaijani (آذربایجان)

## Features

- ✅ **Smart Installer (v1.0.2)** - Auto-detects existing components, skips what's installed
- ✅ **Fixed Launcher (v1.0.3)** - claude-hebrew-konsole.bat now properly opens Konsole
- ✅ **Display Fix (v1.0.4)** - Fixed WSLg display connection (Konsole now launches reliably)
- ✅ **Enhanced Diagnostics (v1.0.4)** - Comprehensive logging with log file shortcuts
- ✅ **Keyboard Fix (v1.0.5)** - Alt+Shift switching works with VcXsrv, single Konsole window, folder picker fixed
- ✅ **Konsole Terminal** - Best terminal for RTL with proper BiDi support
- ✅ **RTL Fonts** - Optimized fonts for better RTL text rendering
- ✅ **One-Click Launch** - Ready-to-use launcher
- ✅ **10 RTL Languages** - Hebrew, Arabic, Persian, Urdu, Pashto, Kurdish, Dari, Uyghur, Sindhi, Azerbaijani
- ✅ **English Responses by Default** - Technical content in English, RTL display in your language
- ✅ **Full Claude Code** - All features and tools available
- ✅ **Resume After Restart** - Continues installation seamlessly after required reboots

## Requirements

**Windows 10/11** with Administrator access (installer handles everything else automatically)

**What gets installed:**
1. **WSL 2** - Windows Subsystem for Linux (auto-detected if present)
2. **Ubuntu** - Linux distribution (auto-detected if present)
3. **Konsole** - Terminal with full RTL support
4. **Node.js** - Runtime for Claude Code
5. **RTL Fonts** - Noto Sans Mono, DejaVu Sans Mono (+ optional Culmus, SIL Ezra)
6. **Claude Code** - AI coding assistant
7. **Git** - Version control (optional, can be deselected)

**You need:**
- Anthropic API Key from https://console.anthropic.com

## Quick Start

### Installation (One-Time Setup)

**Step 1: Run Installer**
1. Double-click `Kivun_Terminal_Setup.exe`
2. Select "Run as Administrator" if prompted
3. Follow the wizard:
   - Choose your primary RTL language (10 languages available)
   - Set Ubuntu username/password (or use defaults)
   - Select components (Git is optional)
4. Wait for completion (restart if prompted, then re-run)

**The installer automatically:**
- ✅ Detects what's already installed
- ✅ Skips components you already have
- ✅ Installs Konsole, fonts, Node.js, Claude Code
- ✅ Resumes after restart if needed

**Step 2: Launch**
- Two desktop shortcuts created automatically:
  - "Kivun Terminal" - opens in home folder
  - "Kivun Terminal (Choose Folder)" - pick a project folder
- Or use Start Menu → Kivun Terminal
- Or right-click any file/folder → Send To → Kivun Terminal

**See README_INSTALLATION.md for detailed instructions and troubleshooting.**

### Launch Claude Code

**After installation:**
1. Use Desktop shortcut "Kivun Terminal" (home folder) or "Kivun Terminal (Choose Folder)"
2. Or: Start Menu → Kivun Terminal
3. Or: Right-click any folder → Send To → Kivun Terminal
4. Or: Right-click any folder → "Open with Kivun Terminal"
5. Konsole opens maximized with title "Kivun Terminal"
6. A small cmd window says "you can ignore this window" and closes automatically
7. Start coding in Hebrew or English!

## Usage

**Daily workflow:**
1. Double-click `claude-hebrew-konsole.bat` (from Windows)
2. Konsole opens with Claude Code ready
3. Type questions/prompts in Hebrew or English
4. Claude responds based on your language preference (set in config.txt)
5. Exit with `Ctrl+C` or close Konsole

**Tips:**
- Claude Code has full access to files in the working directory
- Use standard Claude Code commands and features
- Hebrew text renders RTL (right-to-left) automatically in Konsole
- Change working directory: Navigate before launching or use `cd` in Konsole

**Changing language preference:**
1. Edit `config.txt`
2. Set `RESPONSE_LANGUAGE=english` or `RESPONSE_LANGUAGE=hebrew`
3. Relaunch `claude-hebrew-konsole.bat`

## Keyboard Language Switching

**With VcXsrv (recommended, fixed in v1.0.5):** Alt+Shift toggles between Hebrew and English. VcXsrv is auto-selected during installation and keyboard switching works out of the box.

**Without VcXsrv (WSLg mode):** Alt+Shift does not work reliably. The keyboard defaults to your selected language. This is a known WSLg limitation.

**To toggle keyboard mode after installation:** Start Menu -> Kivun Terminal -> Keyboard Mode (or run `kivun-toggle-vcxsrv.bat`).

## Troubleshooting

### Installation Issues

**"Requires Administrator privileges"**
- Right-click installer and select "Run as Administrator"

**"RESTART REQUIRED"**
- Restart Windows
- Run installer again after restart

**WSL installation fails**
- Enable virtualization in BIOS
- Run: `wsl --install` manually in PowerShell (Admin)

### Hebrew Display Issues

**Hebrew text has spaces between letters**
- This is a TUI limitation with BiDi rendering
- **Solution:** Change font in Konsole (see KONSOLE_FONTS.md)
- Try Hebrew-optimized fonts: Culmus or SIL Ezra
- Konsole is already the best terminal for Hebrew

**Hebrew text appears as boxes**
- Hebrew fonts not installed
- Run `post-install.sh` again to install fonts

**Konsole shows permission warnings**
```
QStandardPaths: wrong permissions on runtime directory...
```
- This is normal in WSL - safe to ignore
- Doesn't affect functionality

### Launch Issues

**"claude: command not found"**
- Claude Code not installed
- Run `post-install.sh` again

**Konsole doesn't open**
- Check bash log: Start Menu → Kivun Terminal → View Bash Log
- If log shows `qt.qpa.xcb: could not connect to display`: Fixed in v1.0.4 (reinstall with latest installer)
- Verify installation: `wsl -d Ubuntu which konsole`

### Diagnostic Logs (NEW!)

**Having issues? Get detailed diagnostics automatically:**

1. **Launch Kivun Terminal** - the window now stays open and shows what happened
2. **Go to Start Menu → Kivun Terminal → "Collect Diagnostic Logs"**
3. **Share the report** - a file will be created on your Desktop: `Kivun_Diagnostic_Report.txt`

**Log file locations:**
- Windows log: `%LOCALAPPDATA%\Kivun\LAUNCH_LOG.txt`
- Bash log: `%LOCALAPPDATA%\Kivun\BASH_LAUNCH_LOG.txt`
- Log shortcuts: In `%LOCALAPPDATA%\Kivun\` folder (→ Windows Log.lnk, → Bash Log.lnk)

Every launch is logged with:
- WSL version and status
- What checks were run (WSL, Ubuntu, Konsole, Claude)
- Which passed and which failed
- Error messages and warnings
- Configuration used
- Commands executed

**Common error in logs:**
```
qt.qpa.xcb: could not connect to display
```
**Solution:** Fixed in v1.0.4. The WSLg display fallback was incorrectly unsetting DISPLAY instead of setting it to `:0`. Update to latest installer to fix.

**No more guessing what went wrong!** The launcher window stays open and log files capture everything.

See **docs/TROUBLESHOOTING.md** for complete diagnostic guide.

See also **README_INSTALLATION.md** for detailed installation troubleshooting.

## Technical Details

### Architecture
```
Windows → WSL 2 → Ubuntu → Konsole → Claude Code CLI
```

### Key Files
- `Kivun_Terminal_Setup.exe` - Main installer (wizard interface)
- `Kivun_Terminal_Setup.nsi` - Installer source code (NSIS)
- `post-install.sh` - Ubuntu package installer (Konsole, fonts, Node.js, Claude Code)
- `kivun-terminal.bat` - Main launcher script
- `kivun-launch.sh` - Konsole launch helper (profile, colors, title, maximize)
- `kivun-terminal-debug.bat` - Debug mode launcher
- `diagnose.bat` - System diagnostics
- `config.txt` - Configuration (language, credentials)

### How It Works
1. **Installer Detection** (v1.0.2) - Smart detection of existing components
   - Git detection: `where git.exe` (prevents WSL false positives)
   - Ubuntu detection: `wsl -d Ubuntu echo OK`
   - State tracking: `.wsl-updated` file for resume after restart
2. **WSL 2** - Runs full Linux kernel on Windows
3. **Ubuntu** - Linux distribution with package management
4. **Konsole** - KDE terminal with BiDi/RTL support
5. **Hebrew Fonts** - Optimized for terminal Hebrew rendering
6. **Claude Code** - Runs natively in Linux environment
7. **Git** (Optional) - Version control for Windows side

### Font Optimization
- Default fonts: Noto Sans Mono, DejaVu Sans Mono
- Optional fonts: Culmus, SIL Ezra, Liberation Mono
- Font choice affects Hebrew letter spacing
- See **KONSOLE_FONTS.md** for detailed guide

## Why Konsole?

After extensive testing of terminal options on Windows:

**Terminal Comparison:**
- ❌ **Windows Terminal** - Poor BiDi support, reversed text
- ❌ **mintty** - Text flips when editing, unstable RTL
- ❌ **cmd.exe** - No Hebrew support
- ✅ **Konsole (WSL)** - Best option for Hebrew

**Konsole advantages:**
- Native BiDi/RTL support
- Hebrew text flows from right edge correctly
- Stable text display during editing
- Professional terminal emulator from KDE
- Full Unicode and font support
- Active development and maintenance

**Why WSL/Ubuntu:**
- Konsole requires Linux environment
- WSL 2 provides full Linux kernel on Windows
- Ubuntu has excellent package management
- Easy font installation and configuration
- Native Claude Code environment

## Documentation

**Installation:**
- **START_HERE.txt** - Quick step-by-step guide
- **README_INSTALLATION.md** - Comprehensive installation guide
- **CREDENTIALS.txt** - Login information reference
- **SECURITY.txt** - Security explanation

**Configuration:**
- **config.txt** - Language and credentials settings
- **KONSOLE_FONTS.md** - Font optimization guide

**Overview:**
- **README.md** - This file (overview)

## Support

**If you encounter issues:**
1. Check troubleshooting section above
2. Read detailed docs: README_INSTALLATION.md
3. For font issues: See KONSOLE_FONTS.md
4. Verify installation: Run `check-installation.bat`

## License

This is an installer/wrapper for Claude Code. Claude Code itself is property of Anthropic.

**Included Components:**
- Git Bash (Git for Windows) - GPL/MIT license
- WSL 2 - Microsoft
- Ubuntu - Canonical Ltd.
- Konsole - KDE (GPL)
- Node.js - OpenJS Foundation
- Hebrew fonts - Various open source licenses

---

**Made with ❤️ for Hebrew-speakers and other RTL languages by Noam Brand**
