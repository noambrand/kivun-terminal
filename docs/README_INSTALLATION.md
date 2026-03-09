# RTL Terminal for Claude Code - Installation Guide

## Configuration (Optional - Do This First!)

Before installation, you can customize settings by editing `config.txt`:

### Language Preference
Choose if Claude responds in English or Hebrew by default:
```
RESPONSE_LANGUAGE=english   (default)
RESPONSE_LANGUAGE=hebrew    (for Hebrew responses)
```

### Custom Credentials
Change the Ubuntu username/password (optional):
```
USERNAME=yourusername
PASSWORD=yourpassword
```

**Default credentials work fine for most users.** See `SECURITY.txt` for details.

**To customize:**
1. Open `config.txt` in Notepad
2. Edit the values you want to change
3. Save the file
4. Proceed with installation below

---

## What You're Installing

- **WSL 2** (Windows Subsystem for Linux) - Required
- **Ubuntu** (Linux distribution) - Required
- **Konsole** (Terminal with Hebrew BiDi support) - Required
- **Hebrew Fonts** (Noto Sans Mono, DejaVu Sans Mono) - Required
- **Optional Hebrew Fonts** (Culmus, SIL Ezra - for better letter spacing) - Optional
- **Node.js** (Runtime for Claude Code) - Required
- **Claude Code** (AI coding assistant) - Required
- **Git** (Version control) - Optional (not required for WSL)

## Why Ubuntu Needs a Username/Password

Ubuntu is a Linux system that requires:
1. **User account** - For system security
2. **Password for `sudo`** - To install packages (konsole, Node.js, fonts, etc.)
3. **File permissions** - To manage your home directory

## Installation

**STEP 1: Run the installer**
1. Find file: `Kivun_Terminal_Setup.exe` (or compile from `Kivun_Terminal_Setup.nsi`)
2. **Right-click** on it
3. Select: **"Run as Administrator"**
4. Follow the installation wizard:
   - Choose language preference (English/Hebrew)
   - Set Ubuntu credentials (or use defaults)
   - Select components (Git is optional - you can deselect it)
5. Wait for installation to complete

**What the installer does:**
- Detects and skips components already installed (Git, WSL, Ubuntu)
- Installs WSL 2 (if not present)
- Installs Ubuntu distribution (if not present)
- Creates user account with your configured credentials
- Installs Konsole, fonts, Node.js, and Claude Code

**Smart Installation (v1.0.2+):**
- ✅ Automatically detects existing Git installation (no false positives)
- ✅ Skips Ubuntu installation if already working
- ✅ Resumes properly after restart
- ✅ Validates each step before continuing

**If it says "RESTART REQUIRED":**
- Click OK to exit installer
- Restart your computer
- After restart, run the installer again (it will resume from where it left off)

**If it says "Ubuntu already installed - skipping":**
- This is normal if you ran it before or have Ubuntu from another source
- Installer will verify it's working and continue

**What this creates:**
- Username: `username`
- Password: `password`
- (Used for `sudo` commands later)

---

## After Installation

### STEP 2: Open Windows Terminal

**Important:** Use "Windows Terminal", NOT cmd.exe

**Option A (easiest):**
1. Press **Windows Key + R** on keyboard
2. Type: `wt`
3. Press **Enter**

**Option B:**
1. Click **Start Menu**
2. Type: "Windows Terminal"
3. Click on it

**What you should see:** Ubuntu tab opens automatically with a prompt like `username@...`

### STEP 3: Run Post-Installation Script

**Note**: The installer (v1.0.2+) automatically runs post-install during installation. You only need these steps if re-running manually.

**If needed, navigate to installation directory:**
```bash
# The installer installs to %LOCALAPPDATA%\Kivun
# Which in WSL is: /mnt/c/Users/YourUsername/AppData/Local/Kivun
cd /mnt/c/Users/YourUsername/AppData/Local/Kivun
```
Replace `YourUsername` with your Windows username, then press **Enter**

**Then run:**
```bash
bash post-install.sh
```
Press **Enter**

**When it asks for password:**
- Type: `password`
- **Nothing will show on screen - this is normal!**
- Press **Enter**

**Wait for it to complete** (shows "Installation Complete!")

**What gets configured:**
- Step [7/7] automatically creates a custom Konsole color scheme:
  - Light blue background (#C8E6FF)
  - Black text for readability
  - Blue cursor (#0050C8)
  - Cyan selection highlight (#32FFF1)
  - All ANSI colors matched to your terminal preferences

**No manual configuration needed** - the launcher (`claude-hebrew-konsole.bat`) automatically uses this color scheme.

### STEP 4: Launch RTL Terminal for Claude Code

**For Hebrew/RTL text (recommended):**

1. Double-click **`claude-hebrew-konsole.bat`**
2. Konsole opens with Claude Code ready
3. Start typing Hebrew or other RTL languages!

**For English only:**
- Run `claude` directly in Ubuntu terminal

## Optimizing Hebrew Display (Optional)

### Font Selection for Better Hebrew Rendering

Font choice significantly affects Hebrew letter spacing in Claude Code's TUI mode.

**Default fonts (already installed):**
- Noto Sans Mono (current default - works great)
- DejaVu Sans Mono (solid alternative)

**Optional Hebrew-optimized fonts:**
During post-install.sh, you'll be asked if you want to install additional fonts:
- Culmus (Hebrew-specific, reduces letter spacing)
- SIL Ezra (Hebrew-specific, academic quality)
- Liberation Mono (good fallback)

**Answer "y" if:** You work primarily in Hebrew and want the best possible letter spacing.

**Answer "n" if:** You're fine with the defaults (which work well for most users).

### Changing Font and Appearance in Konsole

The installer automatically configures a custom color scheme (light blue background, dark text, blue cursor). To change fonts or other settings:

See **KONSOLE_FONTS.md** for detailed instructions on:
- How to change font in Konsole settings
- Recommended font sizes (12pt-14pt)
- Visual comparison of different fonts
- Anti-aliasing and smoothing settings
- Troubleshooting font issues

**Quick version:**
1. Launch Konsole via `claude-hebrew-konsole.bat`
2. Settings → Configure Konsole → Profiles → Edit Profile → Appearance
3. Select font: Noto Sans Mono (or try others if you installed optional fonts)
4. Size: 12pt or 14pt
5. Apply and test with Hebrew text

**Color scheme:** Pre-configured automatically - no manual setup needed

### Keyboard Language Switching

Alt+Shift layout switching does not work reliably inside Konsole when using WSLg (the default). This is a known WSLg limitation.

**To enable Alt+Shift switching:** Install the optional "VcXsrv X Server" component during setup. This launches Konsole through a standalone X11 server where keyboard switching works normally.

**To toggle keyboard mode after installation:** Start Menu -> Kivun Terminal -> Keyboard Mode (or run `kivun-toggle-vcxsrv.bat`).

Without VcXsrv, the keyboard defaults to your selected language and cannot be switched with a shortcut while inside Konsole.

### Understanding the Limitation

Claude Code's TUI has inherent BiDi rendering limitations. Font choice can **reduce** visible gaps between Hebrew letters, but cannot eliminate them completely.

**Konsole is the best terminal option** because it properly supports RTL text direction, rendering Hebrew from the right edge correctly.

---

## Troubleshooting

### WSL not installed
- Run script as Administrator
- Restart computer if prompted
- Run script again after restart

### Ubuntu not found
Check:
```cmd
wsl --list --verbose
```

Should show "Ubuntu" in the list.

### Windows Terminal doesn't open Ubuntu
1. Close Windows Terminal completely
2. Reopen it
3. OR: Click dropdown (v) next to + button → Select "Ubuntu"

### Konsole shows permission warnings
When launching Konsole, you'll see:
```
QStandardPaths: wrong permissions on runtime directory /mnt/wslg/runtime-dir, 0777 instead of 0700
```

**This is normal in WSL.** WSLg uses different permissions than Qt expects. These warnings don't affect functionality - ignore them.

### VcXsrv Error: "Cannot establish any listening sockets"

**Symptom:** VcXsrv shows error dialog:
```
A fatal error has occurred and VcXsrv will now exit.
Cannot establish any listening sockets - Make sure an X server isn't already running
```

**Root Cause:** Multiple VcXsrv instances trying to use display :0 (port conflict)

**Fix:**
1. **Check for duplicate VcXsrv processes:**
   ```cmd
   wmic process where "name='vcxsrv.exe'" get ProcessId,CommandLine
   ```

2. **Kill all VcXsrv processes:**
   ```cmd
   taskkill /F /IM vcxsrv.exe
   ```

3. **Then launch again** - Fresh VcXsrv will start properly

**Alternative:** Switch to WSLg mode (simpler, but Alt+Shift won't work)
- Edit `config.txt`: Set `USE_VCXSRV=false`
- Or use: Start Menu → Kivun Terminal → Keyboard Mode toggle

**Alt+Shift not switching languages (fixed in v1.0.5):**
- VcXsrv was launched with access control enabled, blocking WSL connections
- Update to v1.0.5 which sets `DisableAC="True"` in `kivun.xlaunch`
- Manual fix: Edit `kivun.xlaunch`, change `DisableAC="False"` to `DisableAC="True"`, restart VcXsrv

### Launcher not opening Konsole

**Symptom:** Double-click launcher, but Konsole window doesn't appear

**Common cause (fixed in v1.0.4):** `qt.qpa.xcb: could not connect to display` — the WSLg display fallback was unsetting DISPLAY instead of setting it to `:0`. Update to v1.0.4 to fix.

**Check logs:**
1. Open `→ Bash Log.lnk` in the Kivun folder (or Start Menu → View Bash Log)
2. Look for error messages near "Launching Konsole"

**Other fixes:**
1. **Use main production launcher:** `kivun-terminal.bat` (most robust, has error checking)
2. **Or use:** `kivun-terminal-debug.bat` (shows detailed progress)
3. **Check WSL status:**
   ```cmd
   wsl --status
   wsl -d Ubuntu echo test
   ```
4. **Run diagnostics:** `diagnose.bat` to check all components

### Hebrew text has spaces between letters

Hebrew letters may appear with spaces between them in Claude Code's TUI.

This is a **known limitation** of terminal-based text interfaces with BiDi/RTL rendering.

**What you can do:**
1. **Change font** - Hebrew-optimized fonts reduce (but don't eliminate) letter spacing
   - See **KONSOLE_FONTS.md** for detailed font guide
   - Try: Culmus or SIL Ezra (install during post-install.sh)
   - Quick fix: In Konsole Settings → Change font to different option

2. **Use Konsole** - Already the best terminal option for Hebrew
   - Konsole properly renders RTL text from right edge
   - Other terminals (Windows Terminal, mintty) have worse BiDi support

**Important:** Claude understands Hebrew perfectly - the issue is only visual display in the terminal interface.

### Verification
Run: `check-installation.bat` to see status

## Files Explained

**Installation Scripts:**
- `install-wsl-ubuntu-simple.bat` - Main installer (recommended)
- `Advanced/` - Alternative installers for specific use cases

**Helper Scripts:**
- `check-installation.bat` - Verify what's installed
- `launch-ubuntu-setup.bat` - Manual Ubuntu launcher
- `launch-windows-terminal-ubuntu.bat` - Force open Windows Terminal with Ubuntu

**Post-Installation:**
- `post-install.sh` - Run inside Ubuntu to install Konsole, fonts, Node.js, Claude, and configure color scheme
- `config.txt` - Language preference and credentials configuration

**Launchers:**
- `claude-hebrew-konsole.bat` - Launch Claude in Konsole with custom color scheme (recommended)

**Documentation:**
- `README_INSTALLATION.md` - This file - complete installation guide
- `START_HERE.txt` - Quick reference
- `SECURITY.txt` - Password security explanation
- `CREDENTIALS.txt` - Login information
- `KONSOLE_FONTS.md` - Font configuration guide

## Default Credentials

**Generic User (install-wsl-ubuntu-simple.bat):**
- Username: `username`
- Password: `password`

Used for running `sudo` commands during package installation.

**Important:** When typing passwords in Ubuntu, nothing appears on screen (not even dots or asterisks). This is normal Linux security behavior. Just type the password and press Enter.

## Security Note

The generic credentials are for convenience during setup. Ubuntu runs in an isolated WSL environment on your local machine. If you need to secure it:

```bash
passwd  # Change password in Ubuntu
```

## Support

See `INSTALLATION.md` for detailed troubleshooting.

---

**Made with ❤️ for Hebrew-speakers and other RTL languages by Noam Brand**
