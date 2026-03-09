#!/bin/bash
# Kivun Terminal - GitHub Upload Script
# Run this script to initialize git and upload to GitHub

set -e

echo "======================================"
echo "Kivun Terminal - GitHub Upload"
echo "======================================"
echo ""

# Step 1: Initialize git
echo "[1/6] Initializing git repository..."
git init

# Step 2: Add all files
echo "[2/6] Adding all files..."
git add .

# Step 3: Check what will be committed
echo "[3/6] Files to be committed:"
git status --short | head -20
echo "..."
echo ""

# Step 4: Create commit
echo "[4/6] Creating commit..."
git commit -m "Initial release v1.0.2 - RTL Terminal for Claude Code

🌍 10 RTL Language Support
- Hebrew, Arabic, Persian, Urdu, Pashto, Kurdish, Dari, Uyghur, Sindhi, Azerbaijani
- Smart installer with auto-detection
- Unicode UTF-8 encoding throughout

🐛 Critical Bugs Fixed
- Git detection (no false positives from WSL)
- Ubuntu re-installation bug
- WSL path conversion

✨ Features
- Smart component detection (skips what's installed)
- State tracking for multi-run installations
- Comprehensive error checking
- Git made optional
- Resume after restart

📚 Complete Documentation
- Installation guide
- RTL language support guide
- Troubleshooting
- Font configuration
- Release notes

Made with ❤️ for RTL developers worldwide"

# Step 5: Add remote (user needs to edit)
echo "[5/6] Setting up remote..."
echo ""
echo "⚠️  IMPORTANT: Edit this script and add your GitHub repository URL"
echo ""
echo "Uncomment and edit the following line:"
echo "# git remote add origin https://github.com/YOUR_USERNAME/kivun-terminal.git"
echo ""
echo "Then uncomment the push command:"
echo "# git branch -M main"
echo "# git push -u origin main"
echo ""

# Ready to push! Uncomment these lines:
# git remote add origin https://github.com/noambrand/kivun-terminal.git
# git branch -M main
# git push -u origin main

echo "[6/6] Ready!"
echo ""
echo "Next steps:"
echo "1. Create repository on GitHub: https://github.com/new"
echo "   Name: kivun-terminal"
echo "2. Uncomment the three lines above in this script"
echo "3. Run this script again to push"
echo ""
echo "Or run manually:"
echo "  git remote add origin https://github.com/noambrand/kivun-terminal.git"
echo "  git branch -M main"
echo "  git push -u origin main"
echo ""
echo "For large files (Git, Node.js installers):"
echo "- Go to GitHub repository → Releases → Create new release"
echo "- Tag: v1.0.2"
echo "- Upload Git-2.53.0-64-bit.exe and node-v24.14.0-x64.msi"
echo ""
echo "✅ Repository initialized and committed!"
