# Release Checklist

Every GitHub release **must** include all three assets. Missing any asset breaks the download links in the README and website.

## Required Assets

| Asset | Built on | Notes |
|-------|----------|-------|
| `ClaudeCode_Launchpad_CLI_Setup.exe` | Windows | Compiled from `ClaudeCode_Launchpad_CLI_Setup.nsi` using NSIS |
| `ClaudeCode_Launchpad_CLI_Setup_v<VERSION>.pkg` | macOS | Built with `pkgbuild` from `mac/scripts/postinstall` |
| `kivun_terminal_Hebrew_2_0_2.mp4` | — | Demo video, same file every release |

## Steps

### 1. Build the Windows installer
On Windows, with [NSIS](https://nsis.sourceforge.io) installed:
```
makensis ClaudeCode_Launchpad_CLI_Setup.nsi
```
Output: `ClaudeCode_Launchpad_CLI_Setup.exe`

### 2. Build the macOS installer
On a Mac:
```bash
cp source/statusline.mjs mac/scripts/statusline.mjs
cp source/configure-statusline.js mac/scripts/configure-statusline.js
pkgbuild \
  --identifier com.noambrand.claudecode-launchpad \
  --version <VERSION> \
  --scripts mac/scripts \
  --nopayload \
  ClaudeCode_Launchpad_CLI_Setup_v<VERSION>.pkg
```

### 3. Create the GitHub release
```bash
gh release create v<VERSION> \
  ClaudeCode_Launchpad_CLI_Setup.exe \
  ClaudeCode_Launchpad_CLI_Setup_v<VERSION>.pkg \
  kivun_terminal_Hebrew_2_0_2.mp4 \
  --title "ClaudeCode Launchpad CLI v<VERSION>" \
  --notes "..."
```

Or upload to an existing release:
```bash
gh release upload v<VERSION> \
  ClaudeCode_Launchpad_CLI_Setup.exe \
  ClaudeCode_Launchpad_CLI_Setup_v<VERSION>.pkg \
  kivun_terminal_Hebrew_2_0_2.mp4 \
  --clobber
```

### 4. Verify
```bash
gh release view v<VERSION> --json assets -q '.assets[].name'
```
Expected output:
```
ClaudeCode_Launchpad_CLI_Setup.exe
ClaudeCode_Launchpad_CLI_Setup_v<VERSION>.pkg
kivun_terminal_Hebrew_2_0_2.mp4
```
