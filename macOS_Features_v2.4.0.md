# macOS Feature Parity - v2.4.0

## Summary

Version 2.4.0 brings **full feature parity** between Windows and macOS installers. macOS users now have access to all the features that were previously Windows-only.

---

## New macOS Features

### 1. Folder Picker Dialog 📁

**What it does:**  
When you double-click the desktop shortcut, a native macOS folder picker dialog appears (same UX as Windows).

**How it works:**
- Uses AppleScript `choose folder` dialog
- Shows graphical folder browser
- Launches Claude in the selected folder
- No need to type `cd /path/to/folder` anymore

**Location:**  
Desktop shortcut: `~/Desktop/ClaudeCode Launchpad CLI.command`

---

### 2. Right-Click Context Menu 🖱️

**What it does:**  
Right-click any folder in Finder → **"Open with ClaudeCode Launchpad"** appears in the Services menu.

**How it works:**
- Automator Quick Action installed to `~/Library/Services/`
- Reads your configuration (language, colors, flags)
- Opens Terminal and launches Claude in that folder
- Applies light blue color scheme if enabled

**How to access:**
1. Right-click any folder in Finder
2. **Services** → **Open with ClaudeCode Launchpad**
3. Terminal opens with Claude running in that folder

**Note:** May require logging out/in or restarting Finder for the menu item to appear.

---

### 3. Language Configuration 🌐

**What it does:**  
Same 24+ language support as Windows (Hebrew, Arabic, Persian, Urdu, Kurdish, etc.)

**How it works:**
- Configuration file: `~/Library/Application Support/ClaudeCode-Launchpad/config.txt`
- Edit the file to set `RESPONSE_LANGUAGE=hebrew` (or any supported language)
- Desktop shortcut and Quick Action both read this setting
- Automatically appends `--append-system-prompt "Always respond in Hebrew."` to Claude

**Configuration file structure:**
```ini
# Claude Code response language
RESPONSE_LANGUAGE=english

# Terminal color theme (kivun = light blue, default = keep current)
TERMINAL_COLOR=kivun

# Claude startup flags (optional)
CLAUDE_FLAGS=
```

**Supported languages:**
english, hebrew, arabic, persian, urdu, kurdish, pashto, sindhi, yiddish, syriac, dhivehi, nko, adlam, mandaic, samaritan, dari, uyghur, balochi, kashmiri, shahmukhi, azeri_south, jawi, hausa_ajami, rohingya, turoyo

---

## Updated Desktop Shortcut

The desktop shortcut (`ClaudeCode Launchpad CLI.command`) now:

1. ✅ Shows folder picker dialog
2. ✅ Reads `config.txt` for language and color preferences
3. ✅ Applies light blue Terminal colors (if enabled)
4. ✅ Launches Claude with language prompt and custom flags

---

## Feature Comparison: Windows vs macOS

| Feature | Windows | macOS v2.3.0 | macOS v2.4.0 |
|---------|---------|--------------|--------------|
| **Folder picker** | ✅ Native dialog | ❌ Manual `cd` | ✅ Native dialog |
| **Right-click menu** | ✅ Context menu | ❌ Not available | ✅ Quick Action |
| **Language config** | ✅ config.txt | ❌ Not available | ✅ config.txt |
| **Light blue theme** | ✅ Windows Terminal | ✅ AppleScript | ✅ AppleScript |
| **Desktop shortcut** | ✅ Yes | ✅ Yes | ✅ Enhanced |
| **Statusline** | ✅ Yes | ✅ Yes | ✅ Yes |
| **Native installer** | ✅ CMD (v2.4.0) | ❌ npm | ✅ Bash (v2.4.0) |

---

## Migration from npm to Native Installer

**Windows:** `curl -fsSL https://claude.ai/install.cmd` (CMD)  
**macOS:** `curl -fsSL https://claude.ai/install.sh` (Bash)

Both platforms now use Anthropic's official native installers instead of the deprecated npm package.

---

## Installation Instructions

### First-Time Install

1. Download `ClaudeCode_Launchpad_CLI_Setup_mac.pkg` from GitHub Releases
2. **Right-click** → **Open** (required for unsigned packages)
3. Enter password when prompted
4. After install:
   - Desktop shortcut appears
   - Right-click menu available (may need to log out/in)
   - Config file created at `~/Library/Application Support/ClaudeCode-Launchpad/config.txt`

### Customizing Language

```bash
# Open config file
nano ~/Library/Application\ Support/ClaudeCode-Launchpad/config.txt

# Change language (example: Hebrew)
RESPONSE_LANGUAGE=hebrew

# Save and close (Ctrl+X, Y, Enter)
```

Next time you launch via desktop shortcut or right-click menu, Claude will respond in Hebrew.

---

## Testing Checklist

- [ ] Desktop shortcut shows folder picker
- [ ] Folder picker launches Claude in selected folder
- [ ] Right-click on folder → Services → "Open with ClaudeCode Launchpad" works
- [ ] Changing `RESPONSE_LANGUAGE=hebrew` makes Claude respond in Hebrew
- [ ] `TERMINAL_COLOR=kivun` applies light blue background
- [ ] `TERMINAL_COLOR=default` keeps native Terminal colors
- [ ] `CLAUDE_FLAGS=--continue` passes flag to Claude

---

## Troubleshooting

**Right-click menu doesn't appear:**
- Log out and log back in, or run:
  ```bash
  killall Finder
  /System/Library/CoreServices/pbs -flush
  ```

**Folder picker doesn't show:**
- Check that the desktop shortcut is executable:
  ```bash
  chmod +x ~/Desktop/ClaudeCode\ Launchpad\ CLI.command
  ```

**Language not working:**
- Verify config file exists and has correct syntax:
  ```bash
  cat ~/Library/Application\ Support/ClaudeCode-Launchpad/config.txt
  ```

**Colors not applied:**
- Make sure `TERMINAL_COLOR=kivun` in config.txt
- AppleScript only affects Terminal.app, not iTerm2 or other terminals

---

## Files Created

| File | Purpose |
|------|---------|
| `~/Desktop/ClaudeCode Launchpad CLI.command` | Desktop shortcut with folder picker |
| `~/Library/Services/Open with ClaudeCode Launchpad.workflow` | Finder Quick Action (right-click menu) |
| `~/Library/Application Support/ClaudeCode-Launchpad/config.txt` | Configuration file |
| `/usr/local/share/kivun/statusline.mjs` | Status bar script |
| `~/.zshrc` (or `~/.bashrc`) | CLAUDE_CODE_STATUSLINE environment variable |

---

## Uninstallation

To remove:

```bash
# Remove shortcuts and Quick Action
rm ~/Desktop/ClaudeCode\ Launchpad\ CLI.command
rm -rf ~/Library/Services/Open\ with\ ClaudeCode\ Launchpad.workflow

# Remove config
rm -rf ~/Library/Application\ Support/ClaudeCode-Launchpad

# Remove statusline
sudo rm -rf /usr/local/share/kivun

# Remove env var from shell profile
nano ~/.zshrc  # Remove CLAUDE_CODE_STATUSLINE line
```

---

## Developer Notes

### Folder Picker Implementation

Uses AppleScript `choose folder` dialog:
```applescript
tell application "Finder"
    try
        set selectedFolder to choose folder with prompt "Select a folder to open with Claude Code:"
        return POSIX path of selectedFolder
    on error
        return ""
    end try
end tell
```

### Quick Action Implementation

Automator workflow with "Run Shell Script" action:
- **Input type:** Files and Folders (Folders only)
- **Service receives:** Folder
- **Application:** Finder
- **Shell script:** Reads config, applies colors, launches Terminal with `osascript`

### Color Application

AppleScript sets Terminal tab colors:
```applescript
tell application "Terminal"
    tell front window
        set background color of selected tab to {51400, 59110, 65535}  # #C8E6FF
        set normal text color of selected tab to {0, 0, 0}            # Black
    end tell
end tell
```

RGB values are in 16-bit (0-65535 range):
- #C8E6FF (200, 230, 255) → (51400, 59110, 65535)
- #000000 (0, 0, 0) → (0, 0, 0)

---

## Future Enhancements

Potential additions for future versions:
- [ ] macOS Terminal profile (like Windows Terminal profile)
- [ ] Menu bar app for quick folder selection
- [ ] Integration with Alfred/Raycast workflows
- [ ] Launch Agent for auto-start
- [ ] Custom icon for desktop shortcut
