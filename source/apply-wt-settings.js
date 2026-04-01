// ClaudeCode Launchpad CLI - Apply Windows Terminal color scheme
// Closes WT first (it overwrites settings while running), then adds Noam scheme
// Node.js replacement for apply-wt-settings.vbs (eliminates VBS antivirus false positives)

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const settingsPath = path.join(
  process.env.LOCALAPPDATA,
  'Packages',
  'Microsoft.WindowsTerminal_8wekyb3d8bbwe',
  'LocalState',
  'settings.json'
);

if (!fs.existsSync(settingsPath)) {
  console.log('Windows Terminal settings not found');
  process.exit(0);
}

// Close Windows Terminal so it doesn't overwrite our changes
try {
  execSync('taskkill /f /im WindowsTerminal.exe', { stdio: 'ignore' });
} catch (e) {
  // WT may not be running
}

// Brief pause for WT to fully close
try {
  execSync('timeout /t 1 /nobreak', { stdio: 'ignore' });
} catch (e) {}

let content = fs.readFileSync(settingsPath, 'utf8');
let changed = false;

// --- 1. Add Noam color scheme if missing ---
if (!content.includes('"name": "Noam"') && !content.includes('"name":"Noam"')) {
  const noamScheme =
`        {
            "name": "Noam",
            "background": "#C8E6FF",
            "foreground": "#0C0C0C",
            "cursorColor": "#0050C8",
            "selectionBackground": "#32FFF1",
            "black": "#0C0C0C",
            "red": "#C50F1F",
            "green": "#13A10E",
            "yellow": "#C19C00",
            "blue": "#0000A0",
            "purple": "#881798",
            "cyan": "#005AA0",
            "white": "#CCCCCC",
            "brightBlack": "#000000",
            "brightRed": "#FF1328",
            "brightGreen": "#0F800B",
            "brightYellow": "#AB8A00",
            "brightBlue": "#000078",
            "brightPurple": "#691275",
            "brightCyan": "#003C8C",
            "brightWhite": "#5E5E5E"
        }`;

  content = content.replace('"schemes": []', '"schemes": [\n' + noamScheme + '\n    ]');
  if (content.includes('"name": "Noam"')) {
    changed = true;
    console.log('Added Noam color scheme');
  }
}

// --- 2. Add colorScheme to ClaudeCode Launchpad CLI profile if missing ---
const profileIdx = content.indexOf('"ClaudeCode Launchpad CLI"');
if (profileIdx > -1) {
  // Find the opening brace of this profile
  let braceStart = -1;
  for (let i = profileIdx; i >= 0; i--) {
    if (content[i] === '{') { braceStart = i; break; }
  }

  if (braceStart > -1) {
    // Find matching closing brace
    let depth = 0;
    let braceEnd = -1;
    for (let i = braceStart; i < content.length; i++) {
      if (content[i] === '{') depth++;
      if (content[i] === '}') depth--;
      if (depth === 0) { braceEnd = i; break; }
    }

    if (braceEnd > -1) {
      const profileText = content.substring(braceStart, braceEnd + 1);
      if (!profileText.includes('"colorScheme"')) {
        const nlPos = content.indexOf('\n', braceStart);
        if (nlPos > -1) {
          const insertion =
            '                "colorScheme": "Noam",\n' +
            '                "cursorShape": "bar",\n' +
            '                "font": { "face": "Cascadia Mono", "size": 11 },\n' +
            '                "scrollbarState": "visible",\n' +
            '                "tabTitle": "ClaudeCode Launchpad CLI",\n';
          content = content.substring(0, nlPos + 1) + insertion + content.substring(nlPos + 1);
          changed = true;
          console.log('Updated ClaudeCode Launchpad CLI profile');
        }
      }
    }
  }
}

// Write file (preserves original formatting, comments, etc.)
if (changed) {
  fs.writeFileSync(settingsPath, content, 'utf8');
  console.log('Settings saved');
} else {
  console.log('No changes needed');
}
