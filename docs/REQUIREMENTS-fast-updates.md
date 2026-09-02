# Requirements: Claude Code on the `latest` release channel

*Feature files: `source/configure-fast-updates.js`, the `latest` argument in `source/install.cmd`, `source/post-install.bat`, `mac/scripts/postinstall`, `server-recovery/FIX-CLAUDE-ON-THIS-SERVER.cmd`, and the packaging in `ClaudeCode_Launchpad_CLI_Setup.nsi`. The CI guard derived from this file is `.github/workflows/validate-fast-updates.yml`.*

## Business intent

A person who installed Claude Code through Launchpad should be running the same Claude Code as someone who installed it yesterday. Anthropic ships two channels, `stable` and `latest`; an install that never names a channel lands on `stable` and its auto-updater follows `stable` forever, which on 2026-09-03 meant twenty-two releases behind while the updater reported itself healthy. Launchpad states the channel on every install and every upgrade so nobody is stranded.

## Invariants

- A fresh install of Claude Code through Launchpad always passes `latest` to Anthropic's installer, on Windows, macOS and the server recovery path.
- An upgrade on a machine that already has Claude Code sets `"autoUpdatesChannel": "latest"` in `~/.claude/settings.json` without touching any other key in that file.
- A `settings.json` that exists but cannot be parsed is never overwritten. The channel step fails (exit 1) and the install carries on.
- The channel step never downloads anything and never blocks the installer: a failure is reported as a warning, the installer continues, and Claude Code still works.
- The installer packages `configure-fast-updates.js` and runs it with the same Node it uses for the statusline, on every install, not only first installs.

## Money and data consequences

- Wrong: the user's `settings.json` is clobbered. That file holds their hooks, permissions and model choice; losing it costs them a support round trip and, for a paying Claude user, a broken workday. This is why a parse failure exits without writing.
- Wrong: a machine stays on `stable`. The user sees "Claude stopped updating", blames Launchpad, and files a bug that is not one. That is the exact report this feature exists to end.

## Out of scope

- Switching a machine back to `stable`. Anyone who wants the slow channel edits one key by hand.
- Upgrading Claude Code itself during the install. The step only sets the channel; Claude's own updater does the download on its next check.
- Machines with no Node at all. The Windows installer always has one by the time this step runs; on macOS the step uses `claude install latest` and needs no Node.

## Known misuse paths

- Running the installer while Claude Code is open. The key is written to disk; the running Claude reads it on its next update check, not immediately. No harm, just a delay.
- A user who set `autoUpdatesChannel` to `stable` on purpose. The next Launchpad upgrade flips it to `latest` again. Accepted: Launchpad's promise is the current build, and the key is one line to change back.
- Editing `settings.json` by hand into invalid JSON, then upgrading. The step refuses to write and warns; the user keeps their file, broken as it is, and Claude itself will complain about it on start.
