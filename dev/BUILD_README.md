# Building the RTL Terminal Setup Wizard

This guide explains how to build a single-file wizard installer that packages everything.

## Why Build a Wizard Installer?

**Current approach:** Multiple BAT files, manual steps
**Wizard approach:** One professional .exe with GUI that does everything automatically

## What Gets Packaged

The wizard installer (`RTL_Terminal_Setup.exe`) includes:
- ✅ Git Bash installer (64MB)
- ✅ Node.js installer (32MB)
- ✅ All scripts and configuration
- ✅ Complete documentation
- ✅ Icons and assets

**Result:** Single ~100MB installer that works offline

## Building the Installer

### Step 1: Ensure You Have Required Files

Make sure these files exist in the directory:
```
ClaudeHebrew_Installer/
├── RTL_Terminal_Setup.nsi         ← Installer script
├── BUILD_INSTALLER.bat            ← Build script
├── nsis-3.11-setup.exe           ← NSIS installer (auto-installs if needed)
├── Git-2.53.0-64-bit.exe         ← Bundled
├── node-v24.14.0-x64.msi         ← Bundled
├── claude_code.ico               ← Icon
├── claude-hebrew-konsole.bat     ← Launcher
├── post-install.sh               ← Ubuntu setup
├── config.txt                    ← Configuration
└── All documentation files
```

### Step 2: Run the Build Script

**Option A: Double-click**
```
BUILD_INSTALLER.bat
```

**Option B: Command line**
```cmd
cd C:\Path\To\ClaudeHebrew_Installer
BUILD_INSTALLER.bat
```

### Step 3: Wait for Compilation

The script will:
1. Check if NSIS is installed
2. Install NSIS if needed (automatically)
3. Compile the installer script
4. Create `RTL_Terminal_Setup.exe`

**Build time:** ~10-30 seconds

### Step 4: Test the Installer

```cmd
RTL_Terminal_Setup.exe
```

You should see a professional Windows installer wizard with:
- Welcome page
- Configuration page (language, credentials)
- Component selection
- Installation progress
- Finish page

## What the Wizard Does

### Installation Flow

1. **Welcome Screen**
   - Shows what will be installed
   - Explains requirements

2. **Configuration Page**
   - Language preference (English/Hebrew)
   - Ubuntu username/password

3. **Component Selection**
   - Core Components (required)
   - Git Bash installation
   - WSL & Ubuntu installation
   - Konsole & Claude Code installation
   - Desktop shortcut (optional)

4. **Installation**
   - Copies files to `%LOCALAPPDATA%\RTLTerminal`
   - Checks for Git Bash, installs if needed
   - Installs WSL 2 if needed
   - Installs Ubuntu distribution
   - Configures Ubuntu with chosen credentials
   - Runs post-install.sh (Konsole, fonts, Node.js, Claude Code)
   - Creates shortcuts

5. **Finish**
   - Shows completion message
   - Offers to create desktop shortcut
   - Warns if restart needed (for WSL)

### Post-Installation

**Installed to:** `C:\Users\YourName\AppData\Local\RTLTerminal`

**Shortcuts created:**
- Desktop: "RTL Terminal for Claude Code"
- Start Menu: "RTL Terminal for Claude Code" folder
  - RTL Terminal (launcher)
  - Configuration
  - Documentation
  - Uninstall

**Registry entries:**
- Add/Remove Programs entry for clean uninstallation

## Customizing the Installer

### Change Installer Appearance

Edit `RTL_Terminal_Setup.nsi`:

```nsis
; Change product name
!define PRODUCT_NAME "Your Name Here"

; Change version
!define PRODUCT_VERSION "2.0.0"

; Change publisher
!define PRODUCT_PUBLISHER "Your Company"

; Change icon
!define MUI_ICON "your_icon.ico"
```

### Change Installation Directory

```nsis
; Default: %LOCALAPPDATA%\RTLTerminal
!define INSTALL_DIR "$PROGRAMFILES64\RTLTerminal"
```

### Add/Remove Components

Add new sections:
```nsis
Section "Optional Component" SecOptional
  ; Installation commands here
SectionEnd
```

### Modify Welcome Text

```nsis
!define MUI_WELCOMEPAGE_TEXT "Your custom welcome message here"
```

## Distribution

### Single-File Distribution

After building, you only need to distribute:
```
RTL_Terminal_Setup.exe  (~100MB)
```

That's it! Users just:
1. Download `RTL_Terminal_Setup.exe`
2. Run it
3. Follow the wizard
4. Done!

### Advantages

✅ **Professional appearance** - Standard Windows installer UI
✅ **One-click installation** - No manual steps
✅ **Offline capable** - All dependencies bundled
✅ **Add/Remove Programs** - Clean uninstallation
✅ **Configuration wizard** - User-friendly setup
✅ **No confusion** - Single file, clear process

### Comparison

| Method | Files | Steps | User Experience |
|--------|-------|-------|-----------------|
| **BAT files** | 15+ files | 5-7 manual steps | Technical, confusing |
| **Wizard installer** | 1 file | 1 step (run .exe) | Professional, simple |

## Troubleshooting Build Issues

### NSIS Installation Fails

**Manual installation:**
1. Run `nsis-3.11-setup.exe` manually
2. Install to default location
3. Run `BUILD_INSTALLER.bat` again

### Compilation Errors

**Missing files:**
- Ensure all required files are in the directory
- Check file paths in .nsi script

**Syntax errors:**
- Open `RTL_Terminal_Setup.nsi` in NSIS editor
- Check line numbers in error messages
- Fix syntax issues

### Large File Size

The installer is ~100MB because it bundles:
- Git (64MB)
- Node.js (32MB)
- Scripts and docs (4MB)

**To reduce size:**
- Remove bundled installers (download on-demand instead)
- Use compression (already enabled by default)

## Advanced: Auto-Update System

To add auto-update capability, add to .nsi:

```nsis
Section "Check for Updates" SecUpdate
  ; Download version file
  inetc::get "https://yoursite.com/version.txt" "$TEMP\version.txt"

  ; Compare versions and update
  ; (implementation depends on your hosting)
SectionEnd
```

## Signing the Installer (Optional)

For professional distribution, sign the .exe:

```cmd
signtool sign /f certificate.pfx /p password RTL_Terminal_Setup.exe
```

**Benefits:**
- No "Unknown Publisher" warnings
- Users trust the installer
- Required for some enterprise environments

## Support

**Issues during build:**
1. Check NSIS is installed: `C:\Program Files (x86)\NSIS\makensis.exe`
2. Verify all files exist in directory
3. Check for syntax errors in .nsi file
4. Review build log for specific errors

**Issues with compiled installer:**
1. Test on a clean Windows machine
2. Check event viewer for errors
3. Run as Administrator
4. Verify WSL is enabled in Windows Features

---

**Ready to build?** Just run `BUILD_INSTALLER.bat` and you'll have a professional installer in seconds!
