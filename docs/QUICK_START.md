# ClaudeCode Launchpad CLI - Quick Start Guide

## What is ClaudeCode Launchpad CLI?

ClaudeCode Launchpad CLI is a Claude Code installer for Windows and macOS. It sets up Node.js, Claude Code, and a preconfigured terminal environment.

## Installation

### Windows

> **Note:** The installer may close open terminal windows (Windows Terminal, cmd.exe) during setup- particularly when installing Git or Windows Terminal. Save your work in any open terminals before running the installer.

1. Run `Kivun_Terminal_Setup.exe` as Administrator
2. Follow the wizard:
   - Enter your name
   - Choose response language (English or Hebrew)
   - Select components (Windows Terminal recommended, Git optional)
3. Done! Launch from the desktop shortcut.

### macOS

> **Note:** An internet connection is required. The installer downloads all dependencies via Homebrew - no binaries are bundled in the .pkg.

1. Download `Kivun_Terminal_Setup_<version>.pkg` from the [latest release](https://github.com/noambrand/kivun-terminal/releases/latest)
2. **Right-click** the `.pkg` file → select **Open** (macOS blocks unsigned packages on double-click)
3. Click "Open" again in the confirmation dialog
4. Enter your Mac password when prompted (admin access is needed to install packages)
5. Wait for the installer to finish - it installs Homebrew, Node.js, Git, and Claude Code
6. Open **Terminal** (Finder → Applications → Utilities → Terminal)
7. Type `claude` and press Enter

On first launch, Claude Code will ask for your account details or Anthropic API key.

**If something goes wrong:** Check the install log at `/tmp/kivun_install.log`.

## Using ClaudeCode Launchpad CLI

### Method 1: Default Launch

Double-click the desktop shortcut "Kivun Terminal" - opens Claude Code in your home folder.

### Method 2: Choose a Folder

1. Double-click desktop shortcut "Kivun Terminal (Choose Folder)"
2. Pick a folder using the folder picker (or type/paste the path)
3. Claude Code opens in that folder

### Method 3: Right-Click Send To

1. Right-click any file or folder in Windows Explorer
2. Send To - Kivun Terminal
3. Claude Code opens in that folder

### Method 4: Right-Click Context Menu

1. Right-click any folder in Windows Explorer
2. Select "Open with ClaudeCode Launchpad CLI"
3. Claude Code opens in that folder

## Configuration

## Status Bar

ClaudeCode Launchpad CLI adds a status bar at the bottom of Claude Code. It updates automatically and shows:

```
Opus 4.6 | context used:23% | my-project | total tokens:45K | duration:12m | /Users/me/my-project
```

**Fields:**

- **Model** - which Claude model is active. Green = Opus, Yellow = Sonnet or Haiku.
- **Context used** - how much of the context window has been consumed.
  - Green: under 40% - plenty of room
  - Yellow: 40–69% - getting there
  - Red: 70%+ - running low, consider starting a new session
- **Project** - the name of your current working folder (cyan).
- **Total tokens** - combined input and output tokens used this session (e.g. "45K", "1.2M").
- **Duration** - how long the session has been running (e.g. "12m" or "1:30" for hours).
- **Full path** - the complete path to your working directory.

The status bar is installed automatically - no configuration needed.

## Files

Everything is installed in: `%LOCALAPPDATA%\Kivun`

Key files:
- `kivun-terminal.bat` - Main launcher
- `kivun-terminal-choose-folder.bat` - Folder picker launcher
- `config.txt` - Your configuration
- `post-install.bat` - Re-runs Claude Code installation if needed

## Troubleshooting


### Windows Terminal not installed

ClaudeCode Launchpad CLI falls back to cmd.exe with a light blue color scheme. For the best experience, install Windows Terminal from the Microsoft Store.

### Node.js not found

Download and install from https://nodejs.org/

## Uninstalling

Start Menu - ClaudeCode Launchpad CLI - Uninstall
