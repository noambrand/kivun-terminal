# Contributing to Kivun Terminal

Thank you for your interest in contributing to Kivun Terminal! This document provides guidelines for contributing to the project.

## Table of Contents
- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Project Structure](#project-structure)
- [Making Changes](#making-changes)
- [Testing](#testing)
- [Submitting Changes](#submitting-changes)

## Code of Conduct

This project follows a simple code of conduct: be respectful, constructive, and helpful.

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR-USERNAME/kivun-terminal.git
   cd kivun-terminal
   ```
3. **Create a branch** for your changes:
   ```bash
   git checkout -b feature/my-new-feature
   ```

## Development Setup

### Prerequisites
- Windows 10 (build 19041+) or Windows 11
- NSIS 3.x for building the installer
- WSL 2 with Ubuntu (for testing)
- Git for Windows

### Building the Installer

1. Install NSIS from `dev/nsis-3.11-setup.exe` or download from https://nsis.sourceforge.io/
2. Update paths in `build/Kivun_Terminal_Setup.nsi` if needed
3. Right-click `build/Kivun_Terminal_Setup.nsi` → "Compile NSIS Script"
4. Installer will be created as `Kivun_Terminal_Setup.exe`

## Project Structure

```
kivun-terminal/
├── README.md                   # Main documentation
├── LICENSE                     # MIT License
├── CONTRIBUTING.md             # This file
├── CHANGELOG.md               # Version history
├── .gitignore                 # Git ignore rules
│
├── Kivun_Terminal_Setup.exe   # Main installer (built artifact)
│
├── .github/                   # GitHub-specific files
│   ├── ISSUE_TEMPLATE.md      # Issue template
│   └── PULL_REQUEST_TEMPLATE.md  # PR template
│
├── assets/                    # Static assets
│   └── claude_code.ico        # Application icon
│
├── build/                     # Build system
│   ├── Kivun_Terminal_Setup.nsi  # NSIS installer script
│   └── .bundled/              # Bundled dependencies
│       ├── Git-*.exe
│       ├── node-*.msi
│       └── vcxsrv-*.exe
│
├── config/                    # Configuration files
│   ├── config.txt             # User configuration template
│   ├── ClaudeHebrew.profile   # Konsole profile
│   ├── ColorSchemeNoam.colorscheme  # Color scheme
│   └── kivun.xlaunch          # VcXsrv configuration
│
├── docs/                      # Documentation
│   ├── README_INSTALLATION.md # Installation guide
│   ├── QUICK_START.md         # Quick start guide
│   ├── RELEASE_NOTES_*.md     # Release notes
│   ├── START_HERE.txt         # Quick reference
│   └── ... (other docs)
│
├── scripts/                   # Scripts
│   ├── claude-hebrew-konsole.bat  # Main launcher
│   ├── kivun-launch.sh        # WSL helper script
│   ├── post-install.sh        # Dependency installer
│   └── ... (other scripts)
│
└── dev/                       # Development files
    ├── Advanced/              # Legacy scripts
    ├── docs/                  # Development notes
    └── ... (testing tools)
```

## Making Changes

### Code Style
- **Batch scripts**: Use `REM` for comments, indent with 2 spaces
- **Bash scripts**: Use `#` for comments, follow standard bash conventions
- **NSIS scripts**: Follow NSIS syntax, indent sections clearly

### Documentation
- Update relevant documentation when making changes
- Add entries to `docs/CHANGELOG.md` for user-facing changes
- Create release notes for version updates

### Commits
- Write clear commit messages
- Use present tense ("Add feature" not "Added feature")
- Reference issue numbers when applicable

Example:
```
Fix launcher path conversion (#42)

- Update claude-hebrew-konsole.bat to use wslpath
- Add error handling for path conversion failures
- Update documentation with troubleshooting steps
```

## Testing

Before submitting changes, test on:

1. **Clean Windows 11** (if possible)
2. **Windows 10 with existing WSL** (if possible)
3. **Both WSLg and VcXsrv modes**

### Test Checklist
- [ ] Installer builds without errors
- [ ] Installation completes successfully
- [ ] Launcher opens Konsole terminal
- [ ] Claude Code starts in Konsole
- [ ] RTL text displays correctly
- [ ] Keyboard switching works (if VcXsrv mode)
- [ ] Documentation is accurate

### Running Diagnostics
Use the diagnostic tools:
```cmd
# From dev/ folder
diagnose.bat              # System diagnostics
diagnose-terminal.bat     # Terminal launch diagnostics
check-installation.bat    # Verify installation
```

## Submitting Changes

### Pull Request Process

1. **Update documentation**
   - Update `docs/CHANGELOG.md` with your changes
   - Update `README.md` if needed
   - Add inline comments for complex code

2. **Create a Pull Request**
   - Use the PR template (`.github/PULL_REQUEST_TEMPLATE.md`)
   - Provide a clear description of changes
   - List what you've tested
   - Reference related issues

3. **Code Review**
   - Address review comments
   - Update your branch as needed
   - Keep discussions focused and constructive

4. **Merge**
   - Once approved, your PR will be merged
   - Thank you for contributing!

## Areas for Contribution

### High Priority
- Multi-PC testing and bug reports
- Support for additional RTL languages
- Improved error handling and diagnostics
- Performance optimizations

### Documentation
- Translations of documentation
- Video tutorials
- FAQ additions
- Troubleshooting guides

### Code
- Automated testing scripts
- Installer improvements
- WSL configuration enhancements
- Font rendering improvements

## Questions?

- **Issues**: https://github.com/YOUR-USERNAME/kivun-terminal/issues
- **Discussions**: Use GitHub Discussions for questions

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

**Thank you for contributing to Kivun Terminal!** 🚀
