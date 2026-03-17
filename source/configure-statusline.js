// configure-statusline.js
// Adds statusLine configuration to Claude Code settings.json
// Usage: node configure-statusline.js <path-to-statusline.mjs>

const fs = require('fs');
const path = require('path');

const statuslinePath = process.argv[2];
if (!statuslinePath) {
    process.exit(1);
}

const claudeDir = path.join(process.env.HOME || process.env.USERPROFILE, '.claude');
const settingsFile = path.join(claudeDir, 'settings.json');

// Ensure .claude directory exists
try { fs.mkdirSync(claudeDir, { recursive: true }); } catch(e) {}

// Read existing settings or start fresh
let settings = {};
try {
    settings = JSON.parse(fs.readFileSync(settingsFile, 'utf8'));
} catch(e) {}

// Set statusLine config (normalize backslashes for cross-platform)
const normalizedPath = statuslinePath.replace(/\\/g, '/');
settings.statusLine = {
    type: 'command',
    command: 'node "' + normalizedPath + '"'
};

// Write back
fs.writeFileSync(settingsFile, JSON.stringify(settings, null, 2) + '\n');
