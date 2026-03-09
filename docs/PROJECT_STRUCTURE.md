# Kivun Terminal - Project Structure

## Overview

This document describes the organized folder structure following GitHub best practices.

## Directory Tree

```
kivun-terminal/
├── .github/                        # GitHub configuration
│   ├── ISSUE_TEMPLATE.md          # Issue reporting template
│   └── PULL_REQUEST_TEMPLATE.md   # Pull request template
│
├── assets/                         # Static assets
│   └── claude_code.ico            # Application icon
│
├── build/                          # Build system
│   ├── Kivun_Terminal_Setup.nsi   # NSIS installer source
│   └── .bundled/                  # Bundled dependencies (Git, Node, VcXsrv)
│
├── config/                         # Configuration files
│   ├── config.txt                 # User configuration (template)
│   ├── ClaudeHebrew.profile       # Konsole terminal profile
│   ├── ColorSchemeNoam.colorscheme # Konsole color scheme
│   └── kivun.xlaunch              # VcXsrv X Server configuration
│
├── docs/                           # Documentation
│   ├── CHANGELOG.md               # Version history
│   ├── README_INSTALLATION.md     # Installation guide
│   ├── QUICK_START.md             # Quick start guide
│   ├── LAUNCHER_FIXES.md          # Troubleshooting
│   ├── RELEASE_NOTES_v*.md        # Release notes by version
│   ├── CODE_REVIEW_v*.md          # Code reviews
│   └── *.txt                      # Text documentation
│
├── scripts/                        # Executable scripts
│   ├── claude-hebrew-konsole.bat  # Main launcher
│   ├── kivun-terminal.bat         # Production launcher (with fallback)
│   ├── kivun-terminal-debug.bat   # Debug launcher
│   ├── kivun-launch.sh            # WSL helper script
│   ├── post-install.sh            # WSL dependency installer
│   ├── fix-shortcuts.bat          # Shortcut repair utility
│   └── *.vbs                      # VBScript helpers
│
├── dev/                            # Development files (not for end users)
│   ├── Advanced/                  # Legacy installation scripts
│   ├── docs/                      # Development documentation
│   ├── *.bat                      # Testing and diagnostic tools
│   └── nsis-3.11-setup.exe       # NSIS installer
│
├── .backup/                        # Backups (gitignored)
│   └── v1.0.3/                    # Working state backups
│
├── README.md                       # Main project documentation
├── LICENSE                         # MIT License
├── CONTRIBUTING.md                 # Contribution guidelines
├── .gitignore                      # Git ignore rules
└── Kivun_Terminal_Setup.exe       # Built installer (main deliverable)
```

## Folder Descriptions

### Root Directory
Contains only essential top-level files:
- **README.md** - Main entry point for users and developers
- **LICENSE** - MIT License
- **CONTRIBUTING.md** - How to contribute
- **Kivun_Terminal_Setup.exe** - The final installer (built from `build/`)

### .github/
GitHub-specific configuration:
- Issue templates for bug reports
- Pull request templates
- (Future: GitHub Actions workflows)

### assets/
Static files used by the application:
- Icons
- Images (future: screenshots, logos)

### build/
Build system and installer source:
- **Kivun_Terminal_Setup.nsi** - NSIS installer script (references paths via `..`)
- **.bundled/** - Large dependencies bundled in installer (gitignored)

The installer is built from this directory and outputs to `../Kivun_Terminal_Setup.exe`

### config/
Configuration templates and profiles:
- **config.txt** - User settings (language, VcXsrv mode, credentials)
- **ClaudeHebrew.profile** - Konsole terminal profile settings
- **ColorSchemeNoam.colorscheme** - Light blue color scheme
- **kivun.xlaunch** - VcXsrv launch configuration

### docs/
All user-facing and technical documentation:
- Installation guides
- Quick start tutorials
- Release notes
- Troubleshooting guides
- Code reviews
- Change logs

### scripts/
All executable scripts (.bat, .sh, .vbs):
- Windows batch scripts for launching
- WSL bash scripts for Konsole setup
- VBScript helpers for shortcuts
- Utility scripts

### dev/
Development-only files (for contributors):
- Legacy/obsolete scripts
- Development notes
- Testing tools
- Build tools (NSIS installer)
- Diagnostic scripts

**Not for end users** - these are for developers and testing.

## File Organization Principles

### GitHub Best Practices
✅ Minimal root directory
✅ Clear README.md in root
✅ docs/ for all documentation
✅ Proper .gitignore
✅ GitHub templates in .github/
✅ Separate build/ for build artifacts
✅ LICENSE in root

### User-Friendly
✅ Main installer (Kivun_Terminal_Setup.exe) in root - easy to find
✅ All documentation in docs/ - easy to browse
✅ Scripts organized by type
✅ Configuration files grouped together

### Developer-Friendly
✅ Clear separation: user files vs dev files
✅ Build system isolated in build/
✅ Development tools in dev/
✅ CONTRIBUTING.md with project structure
✅ Consistent naming conventions

## Path References

### NSIS Installer
The `build/Kivun_Terminal_Setup.nsi` script references files using relative paths:
```nsis
File "..\assets\claude_code.ico"       # Icon
File "..\config\config.txt"            # Configuration
File "..\scripts\*.bat"                # Scripts
File "..\docs\*.md"                    # Documentation
File ".bundled\*.exe"                  # Bundled installers
```

Output goes to: `OutFile "..\Kivun_Terminal_Setup.exe"`

### Installers
Scripts installed to `%LOCALAPPDATA%\Kivun\` reference each other:
- Batch scripts use `%~dp0` for installation directory
- WSL scripts receive paths via parameters
- Configuration is read from same directory

## Git Workflow

### Tracked Files
- Source code (scripts, NSIS)
- Configuration templates
- Documentation
- Assets (icons)
- LICENSE, README, CONTRIBUTING

### Ignored Files (.gitignore)
- `.backup/` - Backups
- `build/.bundled/*.exe` - Large bundled installers
- `*.log`, `*.tmp` - Temporary files
- Development artifacts

### Releases
- Tag versions: `v1.0.3`
- Attach `Kivun_Terminal_Setup.exe` to GitHub release
- Include release notes from `docs/RELEASE_NOTES_vX.X.X.md`

## Build Process

1. **Edit source files** in respective folders
2. **Update documentation** in docs/
3. **Update CHANGELOG.md**
4. **Compile installer**:
   - Right-click `build/Kivun_Terminal_Setup.nsi`
   - Select "Compile NSIS Script"
   - Output: `Kivun_Terminal_Setup.exe` in root
5. **Test installer** on clean VM
6. **Commit changes** (excluding .exe if needed)
7. **Create release** on GitHub
8. **Attach .exe** to release

## Migration Notes

### From Previous Structure
```
OLD → NEW
BUILD_FILES/ → build/.bundled/
DEVELOPMENT/ → dev/
BACKUP_v1.0.3_WORKING_STATE/ → .backup/
(root)/*.md → docs/*.md (except README.md)
(root)/*.bat → scripts/*.bat
(root)/*.sh → scripts/*.sh
(root)/config.txt → config/config.txt
(root)/claude_code.ico → assets/claude_code.ico
```

NSIS paths updated to reference new locations via `..` paths.

## Maintenance

### Adding New Features
1. Add scripts to `scripts/`
2. Add config to `config/`
3. Update `build/Kivun_Terminal_Setup.nsi` to include new files
4. Document in `docs/`
5. Update `docs/CHANGELOG.md`

### Creating Backups
```bash
# Create timestamped backup
mkdir .backup/vX.X.X_YYYY-MM-DD
cp -r scripts config build docs .backup/vX.X.X_YYYY-MM-DD/
```

### Cleaning Up
- Keep root minimal
- Move old docs to `dev/docs/`
- Archive old versions in `.backup/`
- Update .gitignore as needed

---

**Last Updated**: 2026-03-09
**Version**: 1.0.5
