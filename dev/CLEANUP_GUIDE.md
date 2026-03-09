# Cleanup Guide - Remove Obsolete Files

**IMPORTANT:** Only perform this cleanup AFTER you have successfully tested the comprehensive installer end-to-end.

## Test First

Before cleaning up, verify:
1. ✅ `install-wsl-ubuntu-simple.bat` successfully installs Git Bash (if missing)
2. ✅ `install-wsl-ubuntu-simple.bat` successfully installs WSL + Ubuntu
3. ✅ `post-install.sh` successfully installs Konsole, fonts, Node.js, Claude Code
4. ✅ Optional font installation works (Culmus, SIL Ezra)
5. ✅ `claude-hebrew-konsole.bat` successfully launches Claude Code in Konsole
6. ✅ Hebrew text displays properly in Konsole
7. ✅ Font changes in Konsole settings work as expected

## Files to Move to TRASH

Once testing is complete, move these obsolete files to the TRASH folder:

### Web Interface Files (No Longer Needed)
```
claude-hebrew-web.bat
claude-hebrew-web.sh
start-web-ui.bat
start-web-ui.sh
ClaudeHebrew.bat (web launcher)
WEB_INTERFACE.md (if exists)
```

### Mintty-Related Files (Superseded by Konsole)
```
claude-hebrew-mintty.bat
claude-hebrew-interactive.bat
claude-hebrew-stable.bat
claude-hebrew-stable.sh
claude-hebrew-stable-v2.sh
claude-hebrew-wt.bat
claude-hebrew-wt.sh
claude-hebrew-decrst.bat
claude-hebrew-decrst.sh
.minttyrc (any mintty config files)
```

### Old/Duplicate Launcher Files
```
launch.bat
launch-konsole-claude.bat (superseded by claude-hebrew-konsole.bat)
launch-hebrew-cli.bat
claude-hebrew.sh (generic, replaced by specific launchers)
claude_hebrew.sh (underscore version)
```

### Screenshot/Test Utility Files (Development Only)
```
screenshot_smart.sh
screenshot_verify.sh
run_csc.bat
compile_screenshot.bat
```

### Alternative Installer Files (If Using Simple Installer)
Keep only `install-wsl-ubuntu-simple.bat` as the main installer.

Consider moving to TRASH (if you don't need manual options):
```
install-claude-hebrew.bat (old version)
install-claude-hebrew-improved.bat (manual username selection)
install-wsl-ubuntu-auto.bat (auto from Windows username)
auto-setup-ubuntu.bat (alternative approach)
```

Keep these (useful utilities):
```
launch-ubuntu-setup.bat (useful for manual access)
launch-windows-terminal-ubuntu.bat (useful utility)
check-installation.bat (verification tool)
```

## Files to KEEP

These are essential and should NOT be moved:

**Installer:**
- `install-wsl-ubuntu-simple.bat` ✅ (comprehensive installer)
- `post-install.sh` ✅ (Ubuntu package installer)

**Launcher:**
- `claude-hebrew-konsole.bat` ✅ (main launcher)

**Configuration:**
- `config.txt` ✅ (user configuration)

**Documentation:**
- `README.md` ✅ (overview)
- `README_INSTALLATION.md` ✅ (installation guide)
- `KONSOLE_FONTS.md` ✅ (font optimization guide)
- `NEXT_STEPS.txt` ✅ (quick reference)
- `CREDENTIALS.txt` ✅ (login info)
- `SECURITY.txt` ✅ (security explanation)
- `setup-konsole-wsl.md` ✅ (Konsole details)
- `FILES.txt` ✅ (file reference)

**Utilities:**
- `check-installation.bat` ✅ (verification)
- `launch-ubuntu-setup.bat` ✅ (manual Ubuntu access)
- `launch-windows-terminal-ubuntu.bat` ✅ (terminal launcher)

## How to Clean Up

### Option 1: Move Files Manually
1. Open File Explorer
2. Navigate to ClaudeHebrew_Installer folder
3. Select obsolete files listed above
4. Drag to TRASH subfolder

### Option 2: Use PowerShell Script
Create a PowerShell script to automate:

```powershell
# Save as cleanup.ps1
$basePath = "C:\Users\noam.ORHITEC\Downloads\ClaudeHebrew_Installer"
$trashPath = "$basePath\TRASH"

$filesToMove = @(
    "claude-hebrew-web.bat",
    "claude-hebrew-web.sh",
    "start-web-ui.bat",
    "start-web-ui.sh",
    "ClaudeHebrew.bat",
    "claude-hebrew-mintty.bat",
    "claude-hebrew-interactive.bat",
    "claude-hebrew-stable.bat",
    "claude-hebrew-stable.sh",
    "claude-hebrew-stable-v2.sh",
    "claude-hebrew-wt.bat",
    "claude-hebrew-wt.sh",
    "claude-hebrew-decrst.bat",
    "claude-hebrew-decrst.sh",
    "launch.bat",
    "launch-konsole-claude.bat",
    "launch-hebrew-cli.bat",
    "claude-hebrew.sh",
    "claude_hebrew.sh",
    "screenshot_smart.sh",
    "screenshot_verify.sh",
    "run_csc.bat",
    "compile_screenshot.bat"
)

foreach ($file in $filesToMove) {
    $source = Join-Path $basePath $file
    if (Test-Path $source) {
        Move-Item -Path $source -Destination $trashPath -Force
        Write-Host "Moved: $file"
    }
}

Write-Host "Cleanup complete!"
```

Run with: `powershell -ExecutionPolicy Bypass -File cleanup.ps1`

## After Cleanup

Your installer directory should contain only:

**Core Files:**
- install-wsl-ubuntu-simple.bat
- post-install.sh
- claude-hebrew-konsole.bat
- config.txt

**Documentation:**
- README.md
- README_INSTALLATION.md
- KONSOLE_FONTS.md
- NEXT_STEPS.txt
- CREDENTIALS.txt
- SECURITY.txt
- setup-konsole-wsl.md
- FILES.txt
- CLEANUP_GUIDE.md (this file)

**Utilities:**
- check-installation.bat
- launch-ubuntu-setup.bat
- launch-windows-terminal-ubuntu.bat

**Optional (if you want manual install options):**
- install-claude-hebrew-improved.bat
- install-wsl-ubuntu-auto.bat
- auto-setup-ubuntu.bat

**Folder:**
- TRASH/ (contains all obsolete files)

## Updating FILES.txt

After cleanup, update `FILES.txt` to reflect the new simplified file structure:

1. Remove entries for moved files
2. Add entry for `KONSOLE_FONTS.md`
3. Update descriptions to match new installer flow
4. Clarify which files are essential vs optional

## Final Verification

After cleanup:
1. ✅ README.md has no web/mintty references
2. ✅ README_INSTALLATION.md has no web/mintty references
3. ✅ NEXT_STEPS.txt has no web interface instructions
4. ✅ Only Konsole-related files remain in root directory
5. ✅ All obsolete files safely stored in TRASH
6. ✅ Installation still works end-to-end
7. ✅ Documentation is consistent and focused

## Rollback

If something doesn't work after cleanup:
1. Check TRASH folder
2. Move needed files back from TRASH to root
3. Files are not deleted, just organized

## Summary

**Before Cleanup:** 40+ files in root directory (confusing, multiple approaches)

**After Cleanup:** ~15 essential files (clean, single focused approach)

**Result:** Clear, professional installer focused solely on Konsole + WSL solution with font optimization.
