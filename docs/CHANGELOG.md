# Changelog

## [2.4.1] - 2026-04-12

### Security Fixes - IMPORTANT UPDATE

**macOS users should update immediately.** This release fixes critical security vulnerabilities in the macOS installer.

#### Fixed Vulnerabilities

1. **Command Injection via Configuration File** (Critical - CVE pending)
   - **Risk**: Malicious code execution if config.txt is modified
   - **Fix**: Removed `eval` usage, implemented proper argument passing
   - **Affected**: macOS installer v2.4.0 only
   - **Impact**: Desktop shortcut and Finder Quick Action now safely handle user-provided flags

2. **Privilege Escalation via Temporary Sudo** (High)
   - **Risk**: Passwordless sudo could persist if installer is interrupted
   - **Fix**: Added trap handler to ensure cleanup even on crash/Ctrl+C
   - **Affected**: macOS installer v2.4.0 only
   - **Impact**: `/etc/sudoers.d/` cleanup now guaranteed

3. **Unquoted Variable Expansion** (Medium)
   - **Risk**: Malformed paths or flags could break execution
   - **Fix**: Proper quoting throughout macOS scripts
   - **Affected**: macOS installer v2.4.0 only

#### Recommendation

If you installed v2.4.0 on macOS:
1. **Download and install v2.4.1** to get security fixes
2. **Verify no leftover sudo files**: `ls /etc/sudoers.d/kivun-brew-temp` (should not exist)
3. **Review your config.txt** if you edited it manually

Windows installer is **not affected** by these vulnerabilities.

See `SECURITY_REVIEW_v2.4.0.md` for full technical details.

---

## [2.4.0] - 2026-04-12

### Changed - Windows & macOS
- **Claude Code native installer**: Migrated from deprecated `npm install -g @anthropic-ai/claude-code` to Anthropic's official native installer
  - **Windows**: `curl -fsSL https://claude.ai/install.cmd` (CMD)
  - **macOS**: `curl -fsSL https://claude.ai/install.sh` (Bash)
  - **Why**: npm package is deprecated; native installer is the official supported method
  - **Benefits**: Works on Windows Server and LTSC builds where winget is unavailable; avoids PowerShell execution policy restrictions
  - **Node.js still required**: Only for statusline display (`statusline.mjs`, `configure-statusline.js`, `apply-wt-settings.js`)

### Changed - Windows Only
- **Dependency installation via `install.cmd`**: Replaced bundled MSI/EXE installers with a new `install.cmd` script that downloads Node.js and Git via `curl.exe` (built-in on Windows 10 1803+), with automatic winget fallback if curl is unavailable
- **No PowerShell dependency**: The entire install chain is now pure CMD — works in environments where PowerShell execution policy is restricted
- **Smaller installer**: No bundled binaries; Node.js and Git are downloaded at install time from official sources
- **NSIS sections simplified**: SecNodeJS, SecGit, SecWindowsTerminal, and SecClaudeCode now delegate to `install.cmd` with `/node`, `/git`, `/wt`, `/claude` flags
- **PATH refresh**: `install.cmd` re-reads PATH from the registry after each install, so subsequent steps see newly installed tools without requiring a restart
- **Installer messaging updated**: Welcome page, error messages, and section descriptions now reference the native installer instead of npm

### Added - macOS Feature Parity
- **Folder picker dialog**: Desktop shortcut now shows native macOS folder picker (AppleScript `choose folder`) before launching Claude — matches Windows folder picker experience
- **Right-click context menu**: Finder Quick Action adds "Open with ClaudeCode Launchpad" to right-click menu on any folder (appears in Services menu)
- **Language configuration**: `~/Library/Application Support/ClaudeCode-Launchpad/config.txt` with same options as Windows (24+ languages including Hebrew, Arabic, Persian, etc.)
- **Configuration file**: macOS now supports `config.txt` with `RESPONSE_LANGUAGE`, `TERMINAL_COLOR`, and `CLAUDE_FLAGS` settings — full feature parity with Windows

### Added - Windows Only
- `source/install.cmd`: Standalone dependency installer — can also be run outside the NSIS wizard to repair or reinstall components
- `TROUBLESHOOTING.md`: Added "Download failed during installation" section

## [2.3.0] - 2026-04-04

### Added
- **Optional color theme**: Installer checkbox (checked by default) — uncheck to keep your existing terminal colors instead of applying the Kivun light-blue theme
- **New no-color WT fragment** (`claudecode-launchpad-wt-fragment-nocolor.json`): registers the WT profile without overriding the color scheme
- **One-time Claude flags**: After typing a folder path in the text-input fallback, a prompt asks for optional Claude flags (e.g. `--continue`). Flags are written to `kivun-claude-flags.txt`, read at launch, then deleted
- **Persistent Claude flags**: `CLAUDE_FLAGS=` key in `config.txt` — set once, applied on every launch
- `docs/RELEASING.md`: Release checklist documenting required assets and build steps for every release

### Changed
- `claudecode-launchpad.bat`: Phase 2 config re-read moved before ANSI color block so `TERMINAL_COLOR` is available when Windows Terminal launches via `--run`
- `apply-wt-settings.js` is now only executed when the color theme checkbox is checked
- WT fragment copy is now conditional: color fragment for checked, no-color fragment for unchecked

## [2.2.0] - 2026-04-01

### Changed
- **VBS → JScript migration**: All `.vbs` scripts replaced with `.js` for better compatibility
- **Statusline fix**: Second line now shows on session start (configures `lines: 2` by default)
- **Folder picker paste support**: Cancelling the folder picker now falls through to a text input prompt where users can paste or type a folder path
- Icon renamed to `claude_icon.ico`
- NSIS installer updated for all file changes

## [2.1.0] - 2026-03-31

### Changed
- **Renamed product** from "Kivun Terminal" to "ClaudeCode Launchpad CLI" (v2.0+; v1.x keeps original name)
- Fixed WT color fallback: self-invoking ANSI pattern (`--run` flag) replaces profile dependency
  - WT path now calls `claudecode-launchpad.bat --run` instead of `cmd /c claude`
  - Phase 2 applies ANSI RGB escape sequences (#C8E6FF) directly inside the terminal
  - Colors work regardless of whether the WT profile/fragment is loaded
- Removed `color B0` fallback (replaced by 24-bit ANSI RGB)
- CMD fallback reuses the same ANSI color logic via `goto :run_claude`

## [2.0.2] - 2026-03-14

### Added
- Integrated `statusline.mjs` into both Windows (NSIS) and macOS (.pkg) installers
- Windows installer sets `CLAUDE_CODE_STATUSLINE` system environment variable and broadcasts change
- macOS installer copies statusline to `/usr/local/share/kivun/` and adds export to shell profile
- Uninstaller cleans up the environment variable on both platforms

### Changed
- Updated `START_HERE.txt` for v2.0.1 (removed v1.x references)
- Updated `SECURITY.md` with real policy and v2.0.x support
- Updated `LICENSE` third-party section (removed WSL/Ubuntu/Konsole/Hebrew Fonts, added Windows Terminal)
- Updated `.gitignore` to exclude `bundled/` directory
- Updated macOS build workflow to include `statusline.mjs` in .pkg payload

## [2.0.1] - 2026-03-13

### Fixed
- Fixed apply-wt-settings.vbs corrupting Windows Terminal settings.json when adding properties to the Kivun Terminal profile. The insertion point landed inside the opening `{` of the profile object, splitting the `"guid"` value and duplicating properties. The script now inserts after the first newline following the brace so existing fields stay intact.
- Fixed folder-picker.vbs writing a UTF-8 BOM to kivun-workdir.txt. The BOM prefix made the path appear relative, so Windows Terminal concatenated it with the install directory (e.g. `C:\...\Kivun\﻿C:\Users\...`), causing error 0x8007010b "directory name is invalid". The file is now written without BOM, matching write-path.vbs.

## [2.0.0] - 2026-03-13

### Major Release - Windows + macOS

Complete rewrite removing WSL/Ubuntu/Konsole dependency. Claude Code now runs natively on Windows. Added macOS installer.

### Changed
- Architecture: NSIS -> Node.js -> Claude Code -> Windows Terminal (was: NSIS -> WSL -> Ubuntu -> Konsole -> VcXsrv -> Claude Code)
- Launcher scripts rewritten as pure Windows batch files (no more bash/WSL)
- Config simplified to single setting: RESPONSE_LANGUAGE (english + 24 RTL languages)
- Installer simplified: Node.js + Claude Code + Windows Terminal (recommended) + Git (optional)

### Added
- macOS installer (.pkg) via pkgbuild — installs Homebrew, Node.js, Git, and Claude Code
- GitHub Actions workflows for building and testing macOS installer
- Windows Terminal integration with "Kivun Terminal" profile and Noam color scheme (light blue)
- Windows Terminal auto-installation via winget
- cmd.exe fallback with light blue color scheme when Windows Terminal is not available
- post-install.bat for Windows-native Claude Code installation

### Removed
- WSL and Ubuntu installation (no longer needed)
- Konsole terminal (replaced by Windows Terminal)
- VcXsrv X server (no longer needed)
- RTL-specific infrastructure (keyboard switching, Hebrew fonts, xkb, X11)
- Diagnostic/debug scripts (kivun-terminal-debug.bat, diagnose-shortcut.bat, fix-shortcuts.bat, COLLECT_LOGS.bat, etc.)
- Konsole profiles and color scheme files (replaced by Windows Terminal fragment)
- Ubuntu credentials configuration
- PRIMARY_LANGUAGE and USE_VCXSRV config options

## [1.0.5] - 2026-03-09

### Initial Public Release

RTL language support for Claude Code on Windows via Konsole terminal (WSL + Ubuntu).

### Features
- Smart installer - auto-detects existing components, skips what's installed, resumes after restart
- 10 RTL languages: Hebrew, Arabic, Persian, Urdu, Pashto, Kurdish, Dari, Uyghur, Sindhi, Azerbaijani
- Alt+Shift keyboard switching (via VcXsrv)
- Konsole terminal with custom profile, blue cursor, light blue color scheme
- Window auto-maximizes with "Kivun Terminal" title
- Desktop shortcuts: "Kivun Terminal" and "Kivun Terminal (Choose Folder)"
- Right-click context menu: "Open with Kivun Terminal"
- Send To integration
- Comprehensive diagnostic logging (Windows + Bash logs)
- Configurable response language (English/Hebrew)
