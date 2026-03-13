# Kivun Terminal - Quick Start Guide

## What is Kivun Terminal?

Kivun Terminal is a Claude Code installer for Windows and macOS. It sets up Node.js, Claude Code, and a preconfigured terminal environment.

## Installation

### Windows

> **Note:** The installer may close open terminal windows (Windows Terminal, cmd.exe) during setup — particularly when installing Git or Windows Terminal. Save your work in any open terminals before running the installer.

1. Run `Kivun_Terminal_Setup.exe` as Administrator
2. Follow the wizard:
   - Enter your name
   - Choose response language (English or Hebrew)
   - Select components (Windows Terminal recommended, Git optional)
3. Done! Launch from the desktop shortcut.

### macOS

1. Double-click `Kivun_Terminal_Setup_<version>.pkg`
2. Follow the installer (may need right-click - Open for unsigned package)
3. Open Terminal and run `claude`

The installer sets up Homebrew, Node.js, Git, and Claude Code automatically.

## Using Kivun Terminal

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
2. Select "Open with Kivun Terminal"
3. Claude Code opens in that folder

## Configuration

### Change Language

1. Start Menu - Kivun Terminal - Configuration
2. Edit `RESPONSE_LANGUAGE=english` to `RESPONSE_LANGUAGE=hebrew`
3. Save and close

## Files

Everything is installed in: `%LOCALAPPDATA%\Kivun`

Key files:
- `kivun-terminal.bat` - Main launcher
- `kivun-terminal-choose-folder.bat` - Folder picker launcher
- `config.txt` - Your configuration
- `post-install.bat` - Re-runs Claude Code installation if needed

## Troubleshooting

### "Claude Code not found"

Install Claude Code manually:
```
npm install -g @anthropic-ai/claude-code
```

### Windows Terminal not installed

Kivun Terminal falls back to cmd.exe with a light blue color scheme. For the best experience, install Windows Terminal from the Microsoft Store.

### Node.js not found

Download and install from https://nodejs.org/

## Uninstalling

Start Menu - Kivun Terminal - Uninstall
