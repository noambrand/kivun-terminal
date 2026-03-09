# Kivun Terminal for Claude Code

<div align="center">

**Professional RTL Terminal for Claude Code**
**10 RTL Languages Supported**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Windows%2010%2F11-blue.svg)](https://www.microsoft.com/windows)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Compatible-purple.svg)](https://claude.com/claude-code)

*Complete installation package that sets up Claude Code with proper RTL text rendering in Konsole terminal (WSL + Ubuntu)*

**10 Supported RTL Languages**:
Hebrew (עברית) • Arabic (العربية) • Persian (فارسی) • Urdu (اردو) • Pashto (پښتو) • Kurdish (کوردی) • Dari (دری) • Uyghur (ئۇيغۇرچە) • Sindhi (سنڌي) • Azerbaijani (آذربایجان)

[The Problem](#-the-problem) • [The Solution](#-the-solution) • [Features](#-features) • [Quick Start](#-quick-start) • [Limitations](#️-known-limitations--trade-offs) • [Documentation](#-documentation)

</div>

---

## ❓ The Problem

**Claude Code uses a fullscreen terminal UI** (ink/React) that places characters at specific screen positions using cursor control. Windows terminals (mintty, Windows Terminal) either don't have BiDi support or their BiDi logic conflicts with this cursor-positioned rendering.

**Result:** RTL text (Hebrew, Arabic, Persian, Urdu, Pashto, Kurdish, Dari, Uyghur, Sindhi, Azerbaijani) appears with:
- ❌ Reversed word order (last word appears first)
- ❌ Left-aligned instead of right-aligned
- ❌ Correct letters within words but wrong sentence structure
- ❌ Punctuation in wrong positions

**Why it happens:**
1. Claude Code's TUI positions text at specific X,Y coordinates
2. BiDi algorithms in terminals try to reorder text *after* positioning
3. This creates a conflict: text is placed left-to-right, then reversed, breaking layout
4. Windows Terminal and mintty either lack BiDi or implement it incorrectly for TUI apps

## ✅ The Solution

**Konsole terminal on WSL/Ubuntu** provides native BiDi/RTL support that correctly handles cursor-positioned text:

1. **Right-to-left rendering** — Text flows from the right edge correctly
2. **Proper BiDi algorithm** — Handles mixed Hebrew/English without breaking layout
3. **Stable display** — Text doesn't flip or reorder during editing
4. **Font support** — Hebrew fonts render correctly with proper spacing

**This package provides:**
- Automatic WSL/Ubuntu setup on Windows
- Konsole installation and configuration
- Optimized Hebrew fonts
- One-click launcher that opens Konsole with Claude Code ready

**Technical approach:**
- Uses Konsole (KDE terminal) in WSL for true BiDi support
- Bypasses Windows terminal limitations entirely
- Hebrew text renders correctly without text manipulation
- **Full Claude Code TUI works as intended** - you get the complete experience:
  - ✅ Interactive fullscreen UI (not plain text mode)
  - ✅ Model indicator (shows which Claude model you're using)
  - ✅ Token usage counter (real-time token tracking)
  - ✅ All visual elements and formatting
  - ✅ File context and code highlighting
  - ✅ Interactive prompts and controls

## 🌟 Features

- ✅ **Display Fix (v1.0.4)** - Fixed WSLg display connection (Konsole launches reliably)
- ✅ **Enhanced Diagnostics (v1.0.4)** - Comprehensive logging with log file shortcuts
- ✅ **Smart Installer (v1.0.2)** - Auto-detects existing components, skips what's already installed
- ✅ **Konsole Terminal** - Best terminal for RTL with proper BiDi support
- ✅ **RTL-Optimized Fonts** - Optimized fonts for better RTL text rendering
- ✅ **One-Click Launch** - Ready-to-use launcher scripts
- ✅ **10 RTL Languages** - Hebrew, Arabic, Persian, Urdu, Pashto, Kurdish, Dari, Uyghur, Sindhi, Azerbaijani
- ✅ **English Responses by Default** - Technical content in English, RTL display in your language
- ✅ **Full Claude Code Experience** - Complete TUI with model indicator, token counter, and all interactive features
- ✅ **Resume After Restart** - Continues installation seamlessly after required reboots

## 📋 Requirements

**System:**
- Windows 10/11 with Administrator access
- ~5GB free disk space

**You need:**
- [Anthropic API Key](https://console.anthropic.com) (free tier available)

**What gets installed automatically:**
1. WSL 2 (Windows Subsystem for Linux) - auto-detected if present
2. Ubuntu Linux distribution - auto-detected if present
3. Konsole terminal
4. Node.js runtime
5. Hebrew fonts (Noto Sans Mono, DejaVu Sans Mono)
6. Claude Code CLI
7. Git (optional - can be deselected)

**Smart Installation (v1.0.2):**
- ✅ Detects existing components and skips them
- ✅ No false positives (Git detection fixed)
- ✅ Resumes after restart automatically
- ✅ Validates each step before continuing

## 🚀 Quick Start

### Installation (One-Time Setup)

**Step 1: Download**
```bash
# Download or clone this repository
# Extract to a folder of your choice
```

**Step 2: Configure (Optional)**
Edit `config/config.txt` to customize:
- Language: `english` or `hebrew` (Claude's response language)
- Credentials: Ubuntu username/password (defaults work fine)

**Step 3: Run Installer**
1. Double-click `Kivun_Terminal_Setup.exe`
2. Follow the wizard (installs Git, WSL, Ubuntu)
3. Wait for completion (restart if prompted)

**Step 4: Post-Install**
1. Open Windows Terminal (`Win+R`, type `wt`, Enter)
2. Select Ubuntu profile
3. Navigate to installation folder:
   ```bash
   cd /mnt/c/path/to/installation
   bash scripts/post-install.sh
   ```
4. Enter password when prompted (default: `password`)
5. Choose `y` for optional Hebrew fonts (recommended)

**See [`docs/START_HERE.txt`](docs/START_HERE.txt) for detailed step-by-step instructions.**

### Launch Claude Code

**After installation:**
1. Double-click `scripts/claude-hebrew-konsole.bat`
2. Konsole opens with Claude Code ready
3. Start coding in Hebrew or English!

## 📖 Documentation

### Installation Guides
- 📘 **[START_HERE.txt](docs/START_HERE.txt)** - Quick step-by-step guide (start here!)
- 📗 **[README_INSTALLATION.md](docs/README_INSTALLATION.md)** - Comprehensive installation guide
- 🔐 **[CREDENTIALS.txt](docs/CREDENTIALS.txt)** - Login information reference
- 🛡️ **[SECURITY.txt](docs/SECURITY.txt)** - Security explanation

### Configuration
- ⚙️ **[config.txt](config/config.txt)** - Language and credentials settings
- 🔤 **[KONSOLE_FONTS.md](docs/KONSOLE_FONTS.md)** - Font optimization guide

### Maintenance
- 🧹 **[CLEANUP_GUIDE.md](docs/CLEANUP_GUIDE.md)** - Uninstall instructions
- 🩺 **[check-installation.bat](scripts/check-installation.bat)** - Diagnostic tool

### For Developers
- 💻 **[dev/README.txt](dev/README.txt)** - Developer resources and build instructions

## 🎯 Usage

**Daily workflow:**
1. Double-click `scripts/claude-hebrew-konsole.bat` (from Windows)
2. Konsole opens with Claude Code ready
3. Type questions/prompts in Hebrew or English
4. Claude responds based on your language preference (set in `config/config.txt`)
5. Exit with `Ctrl+C` or close Konsole

**Tips:**
- Claude Code has full access to files in the working directory
- Use standard Claude Code commands and features
- Hebrew text renders RTL (right-to-left) automatically in Konsole
- Change working directory: Navigate before launching or use `cd` in Konsole

**Changing language preference:**
1. Edit `config/config.txt`
2. Set `RESPONSE_LANGUAGE=english` or `RESPONSE_LANGUAGE=hebrew`
3. Relaunch `scripts/claude-hebrew-konsole.bat`

## ⚠️ Known Limitations & Trade-offs

**This is the best available solution for Hebrew in Claude Code, but it's not perfect.** Here's what to expect:

### Letter Spacing in Hebrew Text

**Issue:** Hebrew letters may appear with small spaces between them in the terminal.

**Why:** This is a fundamental limitation of terminal UI (TUI) rendering with BiDi text. The TUI places characters at fixed grid positions, and BiDi algorithms can create gaps when handling RTL text.

**Mitigation:**
- ✅ Try Hebrew-optimized fonts: **Culmus** or **SIL Ezra** (better letter connectivity)
- ✅ Adjust font size in Konsole settings
- ✅ See [KONSOLE_FONTS.md](docs/KONSOLE_FONTS.md) for font recommendations
- ℹ️ **This affects display only** - the actual text is correct

**Reality:** Even with spacing, Hebrew text is **readable and usable**. Konsole is still the best terminal option available.

### Mixed Hebrew/English Text

**Issue:** Lines mixing Hebrew and English (like `ה-JavaScript קוד`) may not render with perfect visual flow.

**Why:** BiDi algorithms handle mixed LTR/RTL text, but terminal grid positioning can create awkward layouts.

**Reality:**
- ✅ **Text is still readable** - you can understand what was typed
- ✅ **Functionality is not affected** - copy/paste works correctly
- ✅ **Better than alternatives** - Windows Terminal reverses entire lines
- ℹ️ **Most use cases work fine** - primarily affects mixed-language code examples

### Keyboard Language Switching (Alt+Shift)

**Issue:** Alt+Shift layout switching does not work reliably inside Konsole when using WSLg (the default). The Weston compositor manages keyboard layouts separately from Windows and does not support layout switching ([wslg#742](https://github.com/microsoft/wslg/issues/742), [WSL#9954](https://github.com/microsoft/WSL/issues/9954)).

**Solution:** Install the optional "VcXsrv X Server" component during setup (auto-selected by default in v1.0.4). This launches Konsole through a standalone X11 server where Alt+Shift keyboard switching works normally.

```
Default (WSLg):    Windows → RDP → Weston → XWayland → Konsole  (DISPLAY=:0, no switching)
RTL keyboard mode: Windows → VcXsrv (X11) → Konsole              (DISPLAY=host:0, Alt+Shift works)
```

Without VcXsrv, the keyboard defaults to your selected language and cannot be switched with a shortcut while inside Konsole.

> **v1.0.4 Note:** WSLg display connection fixed. Previous versions incorrectly unset DISPLAY in the fallback path, preventing Konsole from launching. Now correctly sets `DISPLAY=:0` for WSLg.

### Why This Solution Is Still Worth It

**Comparison to alternatives:**

| Terminal | Hebrew Display | Mixed Text | Editing Stability | Verdict |
|----------|---------------|------------|-------------------|---------|
| **Windows Terminal** | ❌ Reversed | ❌ Broken | ❌ Flips while typing | Unusable |
| **mintty (Git Bash)** | ⚠️ Partial | ❌ Unstable | ❌ Text jumps | Frustrating |
| **cmd.exe** | ❌ No support | ❌ Boxes | ❌ No BiDi | Won't work |
| **Konsole (This)** | ✅ Works | ⚠️ Imperfect | ✅ Stable | **Best option** |

**Bottom line:**
- 🎯 **For Hebrew speakers:** This is the only practical way to use Claude Code with Hebrew
- 🎯 **Full functionality:** Complete Claude Code TUI - model indicator, token counter, all interactive features
- 🎯 **Trade-off accepted:** Minor letter spacing < unusable reversed text
- 🎯 **Production-ready:** Thousands of lines of Hebrew code written successfully
- 🎯 **Actively used:** This is a real solution, not a proof-of-concept
- 🎯 **No feature sacrifice:** You get 100% of Claude Code's capabilities, just with better Hebrew rendering

**If you need pixel-perfect Hebrew rendering,** use Claude via web interface at https://claude.ai. But if you want the power of Claude Code CLI with Hebrew support, this is your solution.

## 🔧 Troubleshooting

### Installation Issues

**"Requires Administrator privileges"**
- Right-click installer and select "Run as Administrator"

**"RESTART REQUIRED"**
- Restart Windows
- Run installer again after restart

**WSL installation fails**
- Enable virtualization in BIOS
- Run manually: `wsl --install` in PowerShell (Admin)

### Hebrew Display Issues

**Hebrew text appears as boxes**
- Hebrew fonts not installed
- Run `scripts/post-install.sh` again to install fonts

**Run diagnostic:**
```bash
# Windows Command Prompt
scripts\check-installation.bat
```

**See [README_INSTALLATION.md](docs/README_INSTALLATION.md) for detailed troubleshooting.**

## 🏗️ Project Structure

```
├── Kivun_Terminal_Setup.exe    # Main installer (wizard interface)
├── README.md                   # This file
├── LICENSE                     # MIT License
├── CHANGELOG.md                # Version history
│
├── config/                     # Configuration files
│   └── config.txt              # Language and credentials
│
├── docs/                       # Documentation
│   ├── START_HERE.txt          # Quick start guide
│   ├── README_INSTALLATION.md  # Detailed installation
│   ├── SECURITY.txt            # Security information
│   ├── CREDENTIALS.txt         # Login reference
│   ├── CLEANUP_GUIDE.md        # Uninstall guide
│   └── KONSOLE_FONTS.md        # Font optimization
│
├── scripts/                    # Utilities and launchers
│   ├── claude-hebrew-konsole.bat       # Main launcher
│   ├── post-install.sh                 # Ubuntu setup script
│   ├── check-installation.bat          # Diagnostic tool
│   ├── cleanup-now.bat                 # Cleanup utility
│   ├── launch-ubuntu-setup.bat         # Setup launcher
│   └── launch-windows-terminal-ubuntu.bat
│
├── dependencies/               # External installers
│   ├── Git-2.53.0-64-bit.exe   # Git Bash installer
│   └── node-v24.14.0-x64.msi   # Node.js installer
│
├── assets/                     # Icons and resources
│   └── claude_code.ico         # Application icon
│
├── Advanced/                   # Advanced installation options
│   └── [Alternative installers]
│
└── dev/                        # Developer resources
    ├── README.txt              # Developer guide
    ├── *.nsi                   # NSIS installer source
    └── BUILD_*.bat             # Build scripts
```

## 🤔 Why Konsole?

After extensive testing of terminal options on Windows:

**Terminal Comparison:**
- ❌ **Windows Terminal** - Poor BiDi support, reversed text
- ❌ **mintty** - Text flips when editing, unstable RTL
- ❌ **cmd.exe** - No Hebrew support
- ✅ **Konsole (WSL)** - Best option for Hebrew

**Konsole advantages:**
- Native BiDi/RTL support from right edge
- Stable text display during editing
- Professional KDE terminal emulator
- Full Unicode and font support
- Active development and maintenance

**Why WSL/Ubuntu:**
- Konsole requires Linux environment
- WSL 2 provides full Linux kernel on Windows
- Ubuntu has excellent package management
- Easy font installation and configuration
- Native Claude Code environment

## 📦 What's Included

**Installers & Dependencies:**
- Git Bash (Git for Windows) - GPL/MIT license
- WSL 2 - Microsoft
- Ubuntu - Canonical Ltd.
- Konsole - KDE (GPL)
- Node.js - OpenJS Foundation
- Hebrew fonts - Various open source licenses

**This Package:**
- Installation wizard (NSIS-based)
- Configuration management
- Launch scripts and utilities
- Comprehensive documentation

## 🆘 Support

**If you encounter issues:**
1. Check [Troubleshooting](#troubleshooting) section
2. Read detailed docs: [README_INSTALLATION.md](docs/README_INSTALLATION.md)
3. For font issues: [KONSOLE_FONTS.md](docs/KONSOLE_FONTS.md)
4. Run diagnostic: `scripts\check-installation.bat`
5. Open an issue on GitHub

## 📜 License

MIT License - see [LICENSE](LICENSE) file for details.

This is an installer/wrapper for Claude Code. Claude Code itself is property of Anthropic.

## 🙏 Acknowledgments

**Made with ❤️ for Hebrew-speakers and other RTL language users**

Created by Noam Brand

---

<div align="center">

**[⬆ Back to Top](#kivun-terminal-for-claude-code)**

</div>
