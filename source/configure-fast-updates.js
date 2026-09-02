// configure-fast-updates.js
// Puts Claude Code on Anthropic's CURRENT release channel by setting
// "autoUpdatesChannel": "latest" in the user's ~/.claude/settings.json.
// Usage: node configure-fast-updates.js
//
// Why this exists: Anthropic publishes two channels. `stable` is conservative
// and can sit on one build for weeks; `latest` is the current one. Whichever
// channel a machine installed from is the channel its built-in auto-updater
// follows forever, so a `stable` install silently falls dozens of releases
// behind while reporting itself up to date (observed 2026-09-03: stable
// 2.1.236, latest 2.1.258).
//
// install.cmd already passes `latest` when it INSTALLS Claude, but it skips
// that path entirely when Claude is already present — which is most upgrades.
// This runs either way, writes one key, and needs no download, so the newer
// build simply arrives on Claude's next update check.
//
// Deliberately mirrors configure-statusline.js: same settings file, same
// tolerant read, same exit-code contract (0 = fine, 1 = could not write).

const fs = require('fs');
const path = require('path');

const claudeDir = path.join(process.env.HOME || process.env.USERPROFILE, '.claude');
const settingsFile = path.join(claudeDir, 'settings.json');

// Ensure .claude directory exists
try { fs.mkdirSync(claudeDir, { recursive: true }); } catch (e) {}

// Read existing settings or start fresh. A settings.json that exists but is
// unreadable or malformed must NOT be overwritten — it holds the user's own
// hooks, permissions and model choice, and losing those to fix an update
// channel is a far worse trade than skipping the change.
let settings = {};
if (fs.existsSync(settingsFile)) {
    try {
        settings = JSON.parse(fs.readFileSync(settingsFile, 'utf8'));
    } catch (e) {
        process.exit(1);
    }
    if (settings === null || typeof settings !== 'object' || Array.isArray(settings)) {
        process.exit(1);
    }
}

settings.autoUpdatesChannel = 'latest';

// Write back
try {
    fs.writeFileSync(settingsFile, JSON.stringify(settings, null, 2) + '\n');
} catch (e) {
    process.exit(1);
}
