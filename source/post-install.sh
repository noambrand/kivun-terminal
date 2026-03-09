#!/bin/bash
# ClaudeHebrew Post-Installation
# Run this inside Ubuntu after WSL installation

# Don't use set -e: some steps are optional and may fail without breaking the install

echo "============================================"
echo "  ClaudeHebrew - Ubuntu Setup"
echo "============================================"
echo

echo "[1/6] Updating Ubuntu package lists..."
export DEBIAN_FRONTEND=noninteractive

# Kill unattended-upgrades if it's holding the dpkg lock
sudo systemctl stop unattended-upgrades 2>/dev/null || true
sudo systemctl disable unattended-upgrades 2>/dev/null || true
sudo killall -9 unattended-upgr 2>/dev/null || true
# Wait for any lingering dpkg lock (max 60 seconds)
for i in $(seq 1 30); do
  if ! fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; then
    break
  fi
  echo "  Waiting for dpkg lock to release... ($i/30)"
  sleep 2
done
# Force-release if still locked
sudo rm -f /var/lib/dpkg/lock-frontend /var/lib/dpkg/lock 2>/dev/null || true
sudo dpkg --configure -a 2>/dev/null || true

echo "  Running apt-get update..."
sudo -E apt-get update -y 2>&1 || echo "  Warning: apt-get update had issues (continuing anyway)"

echo
echo "[2/6] Installing Konsole, xdotool, and window tools..."
echo "  This may take 10-20 minutes on first install..."
sudo -E apt-get install -y konsole xdotool wmctrl x11-xkb-utils libxcb-xinerama0 libxcb-cursor0

echo
echo "  Konsole installed successfully."
echo
echo "[3/6] Installing Hebrew fonts..."
sudo -E apt-get install -y fonts-noto-mono fonts-dejavu-mono fonts-liberation fonts-freefont-ttf 2>&1 || true
echo "  Hebrew fonts installed."

echo
echo "[4/6] Installing Node.js..."
echo "  Downloading Node.js setup..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
echo "  Installing Node.js..."
sudo -E apt-get install -y nodejs

echo
echo "[5/6] Installing Claude Code..."
echo "  This may take a few minutes..."
sudo npm install -g @anthropic-ai/claude-code

echo
echo "[6/7] Configuring Hebrew support..."
# Generate the locale so LC_ALL=en_US.UTF-8 actually works
sudo locale-gen en_US.UTF-8 2>/dev/null || true
sudo update-locale LANG=en_US.UTF-8 2>/dev/null || true

echo 'export LANG=en_US.UTF-8' >> ~/.bashrc
echo 'export LC_ALL=en_US.UTF-8' >> ~/.bashrc

cat >> ~/.inputrc << 'EOF'
set input-meta on
set output-meta on
set convert-meta off
set completion-ignore-case on
EOF

source ~/.bashrc 2>/dev/null || true

echo
echo "[7/7] Configuring Konsole color scheme..."
mkdir -p ~/.local/share/konsole

cat > ~/.local/share/konsole/ColorSchemeNoam.colorscheme << 'EOF'
[Background]
Color=200,230,255

[BackgroundFaint]
Color=200,230,255

[BackgroundIntense]
Color=200,230,255

[Color0]
Color=12,12,12

[Color0Faint]
Color=12,12,12

[Color0Intense]
Color=0,0,0

[Color1]
Color=197,15,31

[Color1Faint]
Color=197,15,31

[Color1Intense]
Color=255,19,40

[Color2]
Color=19,161,14

[Color2Faint]
Color=19,161,14

[Color2Intense]
Color=15,128,11

[Color3]
Color=193,156,0

[Color3Faint]
Color=193,156,0

[Color3Intense]
Color=171,138,0

[Color4]
Color=0,0,160

[Color4Faint]
Color=0,0,160

[Color4Intense]
Color=0,0,120

[Color5]
Color=136,23,152

[Color5Faint]
Color=136,23,152

[Color5Intense]
Color=105,18,117

[Color6]
Color=0,90,160

[Color6Faint]
Color=0,90,160

[Color6Intense]
Color=0,60,140

[Color7]
Color=204,204,204

[Color7Faint]
Color=204,204,204

[Color7Intense]
Color=94,94,94

[Foreground]
Color=12,12,12

[ForegroundFaint]
Color=12,12,12

[ForegroundIntense]
Color=12,12,12

[General]
Anchor=0.5,0.5
Blur=false
ColorRandomization=false
Description=Color Scheme Noam
FillStyle=Tile
Opacity=1
Wallpaper=
WallpaperFlipType=NoFlip
WallpaperOpacity=1

[Selection]
Color=50,255,241
EOF

cat > ~/.local/share/konsole/ClaudeHebrew.profile << 'EOF'
[Appearance]
ColorScheme=ColorSchemeNoam
Font=Monospace,11,-1,5,50,0,0,0,0,0

[Cursor Options]
CursorShape=0
CustomCursorColor=0,80,200
UseCustomCursorColor=true

[General]
Name=Claude Hebrew
Parent=FALLBACK/
LocalTabTitleFormat=Kivun Terminal
RemoteTabTitleFormat=Kivun Terminal

[Scrolling]
HistorySize=10000
ScrollBarPosition=1

[Terminal Features]
BlinkingCursorEnabled=true
EOF

echo "Konsole configured with custom color scheme"

echo
echo "============================================"
echo "  Installation Complete!"
echo "============================================"
echo
echo "To launch Claude Code with Hebrew support:"
echo "  1. Run: konsole"
echo "  2. In Konsole: configure font to Noto Sans Mono"
echo "  3. Run: claude"
echo
echo "Or use claude-hebrew-konsole.bat from Windows"
echo
