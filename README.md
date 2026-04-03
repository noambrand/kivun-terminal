<p align="left">
  <img src="ClaudeCode Launchpad CLI.jpeg" width="500">
</p>

# ClaudeCode Launchpad CLI

**Claude Code installer for Windows and macOS**

2-minute setup to get Claude Code working instead of 30+ minutes of manual configuration.

## [Download Latest Release](https://github.com/noambrand/kivun-terminal/releases/latest)

## What You Get

- **Automatic installation** - Node.js, Git, and Claude Code installed and kept up to date automatically
- **Clean, modern terminal** - light blue theme with dark text (Windows Terminal on Windows)
- **One-click launch** - double-click the desktop shortcut and Claude Code starts immediately (Windows)
- **Folder picker** - choose a project folder and Claude opens right there, no `cd` needed (Windows)
- **Right-click any folder** - "Open with ClaudeCode Launchpad CLI" context menu integration (Windows)
- **Status bar** - live display of model, context usage, token count, and session duration

## Status Bar

ClaudeCode Launchpad CLI adds a two-line status bar at the bottom of Claude Code that shows live session info:

```
BookWriter | Sonnet 4.6 | Context █████░░░░░ 51% | total tokens:284K | duration:24:13 | C:\Users\Lenovo\Downloads\BookWriter
  Session ████████░░ 77% resets in 4h15m  |  Weekly ██░░░░░░░░ 16% resets in 6d18h
```

**Line 1 — Session overview**

| Field | What it shows | Colors |
|-------|---------------|--------|
| **Project** | Current folder name | Cyan |
| **Model** | Active Claude model (e.g. "Sonnet 4.6") | Green = Opus, Yellow = Sonnet/Haiku |
| **Context** | % of context window consumed (progress bar) | Green < 50%, Yellow 50–79%, Red 80%+ |
| **Total tokens** | Combined input + output tokens this session | Yellow |
| **Duration** | Wall-clock session time (e.g. "24:13") | Gray |
| **Full path** | Complete working directory path | Gray |

**Line 2 — Usage limits**

| Field | What it shows | Colors |
|-------|---------------|--------|
| **Session** | Session token usage % with time until reset (progress bar) | Green < 50%, Yellow 50–79%, Red 80%+ |
| **Weekly** | Weekly token usage % with time until reset (progress bar) | Green < 50%, Yellow 50–79%, Red 80%+ |

> **Tip:** Watch the **Context** bar on line 1 — when it turns red (80%+), Claude is running low on context and may start forgetting earlier parts of the conversation. Consider starting a new session. Monitor **Session** and **Weekly** on line 2 to track your plan usage limits.

## Installation

### Windows

1. **[Download](https://github.com/noambrand/kivun-terminal/releases/latest)** `ClaudeCode_Launchpad_CLI_Setup.exe`
2. Run as Administrator - follow the wizard
3. Double-click the "ClaudeCode Launchpad CLI" desktop shortcut

The installer auto-detects what you already have and skips it.

### macOS

1. **[Download](https://github.com/noambrand/kivun-terminal/releases/latest)** `ClaudeCode_Launchpad_CLI_Setup_<version>.pkg`
2. **Right-click** the `.pkg` file → **Open** (required because the package is unsigned — macOS will block a regular double-click)
3. Enter your password when prompted — the installer needs admin access to install Homebrew, Node.js, Git, and Claude Code
4. Open **Terminal** (Applications → Utilities → Terminal) and type `claude`

> **What happens during install:** The .pkg runs a script that installs [Homebrew](https://brew.sh) (the macOS package manager), then uses it to install Node.js and Git, then installs Claude Code via `npm`. Everything is downloaded fresh — no binaries are bundled. An internet connection is required.

> **First time using Claude Code?** You'll need a Claude account (Pro/Max) or [Anthropic API key](https://console.anthropic.com). Claude will ask for it on first launch.

![Terminal Demo](/claudecode_launchpad_GIF.gif)

## A Note on RTL Support (v1.05 only)

The first version of ClaudeCode Launchpad CLI 1.05 included a custom RTL text-reversal fix that made Hebrew and Arabic display correctly in the terminal. Since then, **Claude has released a built-in RTL fix**, so the current version uses Claude's native implementation instead.

**Regardless of RTL**, the installer saves significant setup time and adds features (status bar, light blue theme, desktop shortcut, folder picker) that make it worthwhile on its own.

**Disclaimer:** Text alignment is left-to-right, but the text itself is fully readable.

### Differences between the original RTL fix and Claude's built-in fix

| | Original (v1.05) | Current (Claude's built-in) |
|---|---|---|
| Hebrew/Arabic display | Reversed per-line | Reversed natively |
| Copy Hebrew text from terminal | Worked correctly | May copy in visual order |
| Parentheses/brackets direction | Displayed correctly | May appear reversed |
| Mixed Hebrew + English | Could break ordering | Preserves original order |

The original fix had its own trade-offs — mixed Hebrew/English lines didn't always maintain the correct order. We hope Claude will continue improving their built-in RTL support to address the remaining edge cases.

> **For developers:** If you prefer the original RTL approach, you're welcome to [fork this repo](https://github.com/noambrand/kivun-terminal/fork) and build on it.

## Requirements

- **Windows**: Windows 10/11
- **macOS**: macOS 12 (Monterey) or later
- **Claude**: Pro/ Max 

## Documentation

- [Quick Start](docs/QUICK_START.md)
- [Changelog](docs/CHANGELOG.md)

## License

MIT

---
**Made by [Noam Brand](https://github.com/noambrand)**
