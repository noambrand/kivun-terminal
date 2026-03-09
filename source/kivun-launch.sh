#!/bin/bash
# Kivun Terminal Launcher - handles profile, colors, title, maximize
# Called by kivun-terminal.bat with: bash kivun-launch.sh <wsl_path> <claude_prompt> <primary_language>

# Get parameters
WSL_PATH="${1:-~}"
CLAUDE_PROMPT="$2"
PRIMARY_LANG="${3:-hebrew}"
USE_VCXSRV="${4:-false}"
LOG_FILE="${5:-/tmp/kivun-bash-launch.log}"

# Initialize bash log file
mkdir -p "$(dirname "$LOG_FILE")" 2>/dev/null

# Start new log entry
{
    echo "========================================"
    echo "KIVUN BASH LAUNCHER LOG"
    echo "========================================"
    echo "Date: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "User: $USER"
    echo "Working Directory: $(pwd)"
    echo "Log File: $LOG_FILE"
    echo "========================================"
    echo ""
} >> "$LOG_FILE"

log() {
    echo "[$(date '+%H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "START - Bash launcher started"
log "INFO - Parameters received:"
log "  WSL_PATH=$WSL_PATH"
log "  PRIMARY_LANG=$PRIMARY_LANG"
log "  USE_VCXSRV=$USE_VCXSRV"
log "  LOG_FILE=$LOG_FILE"

# Prevent double-launch: if Konsole is already running, skip
if pgrep -x konsole > /dev/null 2>&1; then
    log "INFO - Konsole already running, skipping duplicate launch"
    exit 0
fi

# Fix XDG_RUNTIME_DIR if not owned by current user (UID mismatch between WSL users)
log "INFO - Checking XDG_RUNTIME_DIR ownership"
if [ ! -O "${XDG_RUNTIME_DIR:-/mnt/wslg/runtime-dir}" ] 2>/dev/null; then
  export XDG_RUNTIME_DIR="/tmp/runtime-$(id -u)"
  mkdir -p "$XDG_RUNTIME_DIR"
  chmod 700 "$XDG_RUNTIME_DIR"
  log "SUCCESS - Created new XDG_RUNTIME_DIR: $XDG_RUNTIME_DIR"
else
  log "SUCCESS - XDG_RUNTIME_DIR is correctly owned"
fi

# --- Set up keyboard layout (Alt+Shift to toggle) ---
log "INFO - Setting up keyboard layout for $PRIMARY_LANG"
# Map primary language to XKB layout code
case "$PRIMARY_LANG" in
  hebrew)     KBD_PRIMARY="il" ;;
  arabic)     KBD_PRIMARY="ara" ;;
  persian)    KBD_PRIMARY="ir" ;;
  urdu)       KBD_PRIMARY="pk" ;;
  pashto)     KBD_PRIMARY="af" ;;
  kurdish)    KBD_PRIMARY="iq" ;;
  dari)       KBD_PRIMARY="af" ;;
  uyghur)     KBD_PRIMARY="cn" ;;
  sindhi)     KBD_PRIMARY="pk" ;;
  azerbaijani) KBD_PRIMARY="az" ;;
  *)          KBD_PRIMARY="il" ;;
esac
log "SUCCESS - Keyboard layout mapped to: $KBD_PRIMARY"

if [ "$USE_VCXSRV" = "true" ]; then
  # --- VcXsrv mode: Alt+Shift keyboard switching works ---
  log "INFO - VcXsrv mode enabled, testing connection"
  WINDOWS_HOST=$(grep nameserver /etc/resolv.conf | awk '{print $2}')
  export DISPLAY="${WINDOWS_HOST}:0"
  log "INFO - DISPLAY set to $DISPLAY"

  # Test if VcXsrv is reachable
  if xdpyinfo -display "$DISPLAY" >/dev/null 2>&1; then
    log "SUCCESS - VcXsrv is reachable"
    # Allow WSL connections
    xhost +local: 2>/dev/null || true
    # Set keyboard layout with Alt+Shift toggle
    setxkbmap -layout "${KBD_PRIMARY},us" -option "" -option grp:alt_shift_toggle 2>/dev/null || true
    log "SUCCESS - Keyboard layout configured (VcXsrv mode, Alt+Shift enabled)"
    echo "Keyboard mode: VcXsrv (Alt+Shift toggle enabled)"
  else
    # VcXsrv not reachable — fall back to WSLg
    log "WARNING - VcXsrv not reachable, falling back to WSLg"
    echo "VcXsrv not reachable, using WSLg (keyboard switching limited)"
    export DISPLAY=:0  # WSLg uses :0
    log "INFO - DISPLAY reset to :0 for WSLg"
    setxkbmap -layout "${KBD_PRIMARY},us" -option "" -option grp:alt_shift_toggle 2>/dev/null || true
    log "SUCCESS - Keyboard layout configured (WSLg fallback mode)"
  fi
else
  # --- WSLg mode (default): keyboard switching limited ---
  log "INFO - WSLg mode (default)"
  setxkbmap -layout "${KBD_PRIMARY},us" -option "" -option grp:alt_shift_toggle 2>/dev/null || true
  log "SUCCESS - Keyboard layout configured (WSLg mode)"
  echo "Keyboard mode: WSLg (Alt+Shift may not work)"
fi

# --- Deploy Konsole profile (blue cursor, Kivun Terminal title) ---
log "INFO - Deploying Konsole profile and color scheme"
mkdir -p ~/.local/share/konsole

cat > ~/.local/share/konsole/ClaudeHebrew.profile << 'PROFEOF'
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
PROFEOF

cat > ~/.local/share/konsole/ColorSchemeNoam.colorscheme << 'CSEOF'
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
CSEOF

log "SUCCESS - Profile and color scheme deployed"

# --- Launch Konsole ---
log "INFO - Changing directory to: $WSL_PATH"
cd "$WSL_PATH" 2>/dev/null || cd ~
log "SUCCESS - Current directory: $(pwd)"

# Write a temp launch script to avoid quoting issues with konsole -e
log "INFO - Creating temporary launch script"
LAUNCH_TMP="/tmp/kivun-claude-launch.sh"
cat > "$LAUNCH_TMP" << LAUNCHEOF
#!/bin/bash -l
claude --append-system-prompt "$CLAUDE_PROMPT"
echo
echo "Claude exited. Press Enter to close."
read
LAUNCHEOF
chmod +x "$LAUNCH_TMP"
log "SUCCESS - Launch script created: $LAUNCH_TMP"

log "INFO - Launching Konsole with ClaudeHebrew profile"
log "INFO - Command: konsole --profile ClaudeHebrew -e $LAUNCH_TMP"

# Launch Konsole and capture errors
konsole --profile ClaudeHebrew -e "$LAUNCH_TMP" >> "$LOG_FILE" 2>&1 &
KPID=$!

if [ $KPID -gt 0 ]; then
    log "SUCCESS - Konsole started with PID: $KPID"
else
    log "ERROR - Failed to start Konsole!"
    log "ERROR - Check if konsole is installed: command -v konsole"
    command -v konsole >> "$LOG_FILE" 2>&1
    exit 1
fi

# --- Wait for window to appear, then rename + maximize ---
log "INFO - Waiting 3 seconds for Konsole window to appear"
sleep 3

# Try wmctrl first (can rename + maximize)
if command -v wmctrl >/dev/null 2>&1; then
  log "INFO - Using wmctrl for window management"
  wmctrl -r "Konsole" -N "Kivun Terminal" 2>/dev/null
  wmctrl -r "Kivun Terminal" -b add,maximized_vert,maximized_horz 2>/dev/null
  log "SUCCESS - Window renamed and maximized via wmctrl"
else
  log "WARNING - wmctrl not available"
fi

# Fallback/supplement with xdotool
if command -v xdotool >/dev/null 2>&1; then
  log "INFO - Using xdotool for window management"
  WID=$(xdotool search --class konsole 2>/dev/null | head -1)
  if [ -n "$WID" ]; then
    log "SUCCESS - Found Konsole window (ID: $WID)"
    xdotool set_window --name "Kivun Terminal" "$WID" 2>/dev/null
    # Maximize if wmctrl didn't work
    xdotool windowsize "$WID" 100% 100% 2>/dev/null
    xdotool windowmove "$WID" 0 0 2>/dev/null
    log "SUCCESS - Window renamed and maximized via xdotool"
  else
    log "WARNING - Could not find Konsole window with xdotool"
  fi
else
  log "WARNING - xdotool not available"
fi

log "INFO - Waiting for Konsole process to complete"
wait $KPID
log "COMPLETE - Bash launcher finished (Konsole process ended)"
