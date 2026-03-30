# Changelog

## [2.1.0] - 2026-03-31

### Changed
- **Renamed product** from "Kivun Terminal" to "ClaudeCode Launchpad CLI" (v2.0+; v1.x keeps original name)
- Fixed WT color fallback: self-invoking ANSI pattern (`--run` flag) replaces profile dependency
  - WT path now calls `kivun-terminal.bat --run` instead of `cmd /c claude`
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
