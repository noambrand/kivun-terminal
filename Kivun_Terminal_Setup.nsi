; Kivun Terminal v1.0.2 - Professional Installer
; RTL support for Claude Code
; Supports 10 major RTL languages for development
; Encoding: UTF-8

Unicode True

!define PRODUCT_NAME "Kivun Terminal"
!define PRODUCT_VERSION "1.0.2"
!define PRODUCT_PUBLISHER "Noam Brand"
!define PRODUCT_WEB_SITE "https://github.com"
!define PRODUCT_DESCRIPTION "RTL support for Claude Code"
!define PRODUCT_SUBTITLE "Support for 10 RTL languages - Hebrew, Arabic, Persian, Urdu, Pashto, Kurdish, Dari, Uyghur, Sindhi, Azerbaijani"
!define INSTALL_DIR "$LOCALAPPDATA\Kivun"

; Modern UI
!include "MUI2.nsh"
!include "LogicLib.nsh"
!include "FileFunc.nsh"
!include "StrFunc.nsh"
${StrRep}

; Request admin privileges
RequestExecutionLevel admin

; Installer settings
Name "${PRODUCT_NAME}"
OutFile "Kivun_Terminal_Setup.exe"
InstallDir "${INSTALL_DIR}"
ShowInstDetails show

; Version info
VIProductVersion "1.0.2.0"
VIAddVersionKey "ProductName" "${PRODUCT_NAME}"
VIAddVersionKey "ProductVersion" "${PRODUCT_VERSION}"
VIAddVersionKey "CompanyName" "${PRODUCT_PUBLISHER}"
VIAddVersionKey "FileDescription" "${PRODUCT_DESCRIPTION}"
VIAddVersionKey "FileVersion" "1.0.2.0"
VIAddVersionKey "LegalCopyright" "(C) 2026 ${PRODUCT_PUBLISHER}"

; Modern UI Configuration
!define MUI_ABORTWARNING
!define MUI_ICON "source\claude_code.ico"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP_NOSTRETCH
!define MUI_WELCOMEFINISHPAGE_BITMAP_NOSTRETCH

; Welcome page
!define MUI_WELCOMEPAGE_TITLE "Welcome to ${PRODUCT_NAME}"
!define MUI_WELCOMEPAGE_TEXT "This installer will set up ${PRODUCT_NAME} on your computer.$\r$\n$\r$\nIt installs a preconfigured terminal environment that enables proper RTL (right-to-left) support for Claude Code.$\r$\n$\r$\nSupported RTL Languages (10):$\r$\n  Hebrew, Arabic, Persian, Urdu, Pashto,$\r$\n  Kurdish, Dari, Uyghur, Sindhi, Azerbaijani$\r$\n$\r$\nWhat will be installed:$\r$\n  - WSL 2 with Ubuntu$\r$\n  - Konsole terminal with RTL support$\r$\n  - RTL-optimized fonts$\r$\n  - Node.js and Claude Code$\r$\n  - Git (optional)$\r$\n$\r$\nClick Next to continue."
!insertmacro MUI_PAGE_WELCOME

; License page (optional - add if you want)
; !insertmacro MUI_PAGE_LICENSE "LICENSE.txt"

; Configuration page
Page custom ConfigPage ConfigPageLeave

; Components page
!insertmacro MUI_PAGE_COMPONENTS

; Directory page
!insertmacro MUI_PAGE_DIRECTORY

; Installation page
!insertmacro MUI_PAGE_INSTFILES

; Finish page
!define MUI_FINISHPAGE_TITLE "${PRODUCT_NAME} Installation Complete!"
!define MUI_FINISHPAGE_TEXT "${PRODUCT_NAME} has been installed successfully.$\r$\n$\r$\n${PRODUCT_DESCRIPTION}$\r$\n${PRODUCT_SUBTITLE}$\r$\n$\r$\nIMPORTANT: If WSL was just installed, you may need to restart your computer.$\r$\n$\r$\nAfter any required restart, launch ${PRODUCT_NAME} using the desktop shortcut.$\r$\n$\r$\nIf you encounter any issues, use Start Menu → Kivun Terminal → Diagnostics to check your system."
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_TEXT "Create Desktop Shortcut"
!define MUI_FINISHPAGE_RUN_FUNCTION CreateDesktopShortcut
!define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\QUICK_START.md"
!define MUI_FINISHPAGE_SHOWREADME_TEXT "View Quick Start Guide"
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

; Languages
!insertmacro MUI_LANGUAGE "English"

; Variables
Var ConfigLanguage
Var ConfigUsername
Var ConfigPassword
Var NeedsRestart
Var WSLInstallPath

; Configuration page
Function ConfigPage
  !insertmacro MUI_HEADER_TEXT "Configuration" "Choose your language preference and Ubuntu credentials"

nsDialogs::Create 1018
  Pop $0
  ${If} $0 == error
    Abort
  ${EndIf}

  ; Language selection
  ${NSD_CreateLabel} 0 0 100% 12u "Select your primary RTL language (response language can be changed in config):"
  Pop $0

  ${NSD_CreateDropList} 0 15u 100% 13u ""
  Pop $ConfigLanguage
  ${NSD_CB_AddString} $ConfigLanguage "Hebrew"
  ${NSD_CB_AddString} $ConfigLanguage "Arabic"
  ${NSD_CB_AddString} $ConfigLanguage "Persian"
  ${NSD_CB_AddString} $ConfigLanguage "Urdu"
  ${NSD_CB_AddString} $ConfigLanguage "Pashto"
  ${NSD_CB_AddString} $ConfigLanguage "Kurdish"
  ${NSD_CB_AddString} $ConfigLanguage "Dari"
  ${NSD_CB_AddString} $ConfigLanguage "Uyghur"
  ${NSD_CB_AddString} $ConfigLanguage "Sindhi"
  ${NSD_CB_AddString} $ConfigLanguage "Azerbaijani"
  ${NSD_CB_SelectString} $ConfigLanguage "Hebrew"

  ; Ubuntu credentials
  ${NSD_CreateGroupBox} 0 40u 100% 70u "Ubuntu Credentials (for sudo commands)"
  Pop $0

  ${NSD_CreateLabel} 10u 55u 50% 12u "Username:"
  Pop $0
  ${NSD_CreateText} 10u 70u 90% 12u "username"
  Pop $ConfigUsername

  ${NSD_CreateLabel} 10u 90u 50% 12u "Password:"
  Pop $0
  ${NSD_CreateText} 10u 105u 90% 12u "password"
  Pop $ConfigPassword

nsDialogs::Show
FunctionEnd

Function ConfigPageLeave
  ${NSD_GetText} $ConfigLanguage $ConfigLanguage
  ${NSD_GetText} $ConfigUsername $ConfigUsername
  ${NSD_GetText} $ConfigPassword $ConfigPassword
FunctionEnd

; Installation sections
Section "!Core Components (Required)" SecCore
  SectionIn RO  ; Read-only, cannot be deselected

  SetOutPath "$INSTDIR"

  ; Copy essential files from source/
  File "source\claude_code.ico"
  File "source\config.txt"
  File "source\kivun.xlaunch"
  File "source\ClaudeHebrew.profile"
  File "source\ColorSchemeNoam.colorscheme"
  File "source\post-install.sh"
  File "source\claude-hebrew-konsole.bat"
  File "source\kivun-terminal-choose-folder.bat"
  File "source\folder-picker.vbs"
  File "source\create-shortcut.vbs"
  File "source\kivun-launch.sh"
  File "source\COLLECT_LOGS.bat"
  File "source\OPEN_LOG_FOLDER.bat"

  ; Copy launcher scripts (fixed versions)
  File "source\kivun-terminal.bat"
  File "source\kivun-terminal-debug.bat"
  File "source\kivun-toggle-vcxsrv.bat"
  File "source\fix-shortcuts.bat"

  ; Copy documentation
  File "README.md"
  File "docs\README_INSTALLATION.md"
  File "docs\QUICK_START.md"
  File "docs\LAUNCHER_FIXES.md"
  File "docs\START_HERE.txt"
  File "docs\SECURITY.txt"
  File "docs\CREDENTIALS.txt"
  File "docs\KONSOLE_FONTS.md"

  ; Copy bundled installers
  File "bundled\Git-2.53.0-64-bit.exe"
  File "bundled\node-v24.14.0-x64.msi"
  File "bundled\vcxsrv-64.1.20.14.0.installer.exe"

  ; Create config.txt with user preferences
  Delete "$INSTDIR\config.txt"
  FileOpen $0 "$INSTDIR\config.txt" w

  ; Write header
  FileWrite $0 "# Kivun Terminal Configuration$\r$\n"
  FileWrite $0 "# Primary RTL language and Claude response language$\r$\n"
  FileWrite $0 "$\r$\n"

  ; Write selected RTL language (for display purposes)
  ${If} $ConfigLanguage == "Hebrew"
    FileWrite $0 "# Selected RTL Language: Hebrew$\r$\n"
    FileWrite $0 "PRIMARY_LANGUAGE=hebrew$\r$\n"
  ${ElseIf} $ConfigLanguage == "Arabic"
    FileWrite $0 "# Selected RTL Language: Arabic$\r$\n"
    FileWrite $0 "PRIMARY_LANGUAGE=arabic$\r$\n"
  ${ElseIf} $ConfigLanguage == "Persian"
    FileWrite $0 "# Selected RTL Language: Persian$\r$\n"
    FileWrite $0 "PRIMARY_LANGUAGE=persian$\r$\n"
  ${ElseIf} $ConfigLanguage == "Urdu"
    FileWrite $0 "# Selected RTL Language: Urdu$\r$\n"
    FileWrite $0 "PRIMARY_LANGUAGE=urdu$\r$\n"
  ${ElseIf} $ConfigLanguage == "Pashto"
    FileWrite $0 "# Selected RTL Language: Pashto$\r$\n"
    FileWrite $0 "PRIMARY_LANGUAGE=pashto$\r$\n"
  ${ElseIf} $ConfigLanguage == "Kurdish"
    FileWrite $0 "# Selected RTL Language: Kurdish$\r$\n"
    FileWrite $0 "PRIMARY_LANGUAGE=kurdish$\r$\n"
  ${ElseIf} $ConfigLanguage == "Dari"
    FileWrite $0 "# Selected RTL Language: Dari$\r$\n"
    FileWrite $0 "PRIMARY_LANGUAGE=dari$\r$\n"
  ${ElseIf} $ConfigLanguage == "Uyghur"
    FileWrite $0 "# Selected RTL Language: Uyghur$\r$\n"
    FileWrite $0 "PRIMARY_LANGUAGE=uyghur$\r$\n"
  ${ElseIf} $ConfigLanguage == "Sindhi"
    FileWrite $0 "# Selected RTL Language: Sindhi$\r$\n"
    FileWrite $0 "PRIMARY_LANGUAGE=sindhi$\r$\n"
  ${ElseIf} $ConfigLanguage == "Azerbaijani"
    FileWrite $0 "# Selected RTL Language: Azerbaijani$\r$\n"
    FileWrite $0 "PRIMARY_LANGUAGE=azerbaijani$\r$\n"
  ${Else}
    FileWrite $0 "# Selected RTL Language: Hebrew (default)$\r$\n"
    FileWrite $0 "PRIMARY_LANGUAGE=hebrew$\r$\n"
  ${EndIf}

  ; ALWAYS default to English responses (user can change this)
  FileWrite $0 "$\r$\n# Claude Code Response Language$\r$\n"
  FileWrite $0 "# Options: english, hebrew, arabic, persian, urdu, pashto, kurdish, dari, uyghur, sindhi, azerbaijani$\r$\n"
  FileWrite $0 "# Default: english (most compatible with technical content)$\r$\n"
  FileWrite $0 "# Change this to your preferred response language if needed$\r$\n"
  FileWrite $0 "RESPONSE_LANGUAGE=english$\r$\n"

  FileWrite $0 "$\r$\n# Ubuntu credentials (for sudo commands)$\r$\n"
  FileWrite $0 "USERNAME=$ConfigUsername$\r$\n"
  FileWrite $0 "PASSWORD=$ConfigPassword$\r$\n"

  FileClose $0

  ; Note: Launcher scripts are now copied from files above, not generated

  ; Initialize empty log files for shortcuts to work
  FileOpen $0 "$INSTDIR\LAUNCH_LOG.txt" w
  FileWrite $0 "Kivun Terminal Launch Log - Waiting for first launch...$\r$\n"
  FileWrite $0 "This file will be populated when you launch Kivun Terminal.$\r$\n"
  FileClose $0

  FileOpen $0 "$INSTDIR\BASH_LAUNCH_LOG.txt" w
  FileWrite $0 "Kivun Terminal Bash Launch Log - Waiting for first launch...$\r$\n"
  FileWrite $0 "This file will be populated when the bash script runs.$\r$\n"
  FileClose $0

  ; Create shortcuts to log files IN the installation folder (for easy access)
  CreateShortCut "$INSTDIR\→ Windows Log.lnk" "notepad.exe" "$INSTDIR\LAUNCH_LOG.txt" "" 0 SW_SHOWNORMAL "" "Open Windows launcher log"
  CreateShortCut "$INSTDIR\→ Bash Log.lnk" "notepad.exe" "$INSTDIR\BASH_LAUNCH_LOG.txt" "" 0 SW_SHOWNORMAL "" "Open Bash script log"

  ; Write uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"

  ; Create Start Menu shortcuts
  CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk" "$INSTDIR\claude-hebrew-konsole.bat" "" "$INSTDIR\claude_code.ico" 0 SW_SHOWNORMAL "" "${PRODUCT_DESCRIPTION}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Choose Folder.lnk" "$INSTDIR\kivun-terminal-choose-folder.bat" "" "$INSTDIR\claude_code.ico" 0 SW_SHOWNORMAL "" "Launch in a specific folder"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Debug Mode.lnk" "$INSTDIR\kivun-terminal-debug.bat" "" "$INSTDIR\claude_code.ico" 0 SW_SHOWNORMAL "" "Debug launcher with detailed output"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Diagnostics.lnk" "$INSTDIR\diagnose.bat" "" "$INSTDIR\claude_code.ico" 0 SW_SHOWNORMAL "" "Run system diagnostics"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Collect Diagnostic Logs.lnk" "$INSTDIR\COLLECT_LOGS.bat" "" "$INSTDIR\claude_code.ico" 0 SW_SHOWNORMAL "" "Collect logs for troubleshooting"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Open Log Folder.lnk" "$INSTDIR\OPEN_LOG_FOLDER.bat" "" "$INSTDIR\claude_code.ico" 0 SW_SHOWNORMAL "" "Open the log folder in Explorer"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\View Windows Log.lnk" "notepad.exe" "$INSTDIR\LAUNCH_LOG.txt" "" 0 SW_SHOWNORMAL "" "View Windows launcher log file"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\View Bash Log.lnk" "notepad.exe" "$INSTDIR\BASH_LAUNCH_LOG.txt" "" 0 SW_SHOWNORMAL "" "View Bash script log file"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Keyboard Mode.lnk" "$INSTDIR\kivun-toggle-vcxsrv.bat" "" "$INSTDIR\claude_code.ico" 0 SW_SHOWNORMAL "" "Toggle keyboard switching mode (VcXsrv/WSLg)"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Configuration.lnk" "notepad.exe" "$INSTDIR\config.txt" "" 0 SW_SHOWNORMAL "" "Configure language and credentials"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Documentation.lnk" "$INSTDIR\README_INSTALLATION.md" "" "" 0 SW_SHOWNORMAL "" "View complete documentation"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall.lnk" "$INSTDIR\Uninstall.exe" "" "" 0 SW_SHOWNORMAL "" "Uninstall ${PRODUCT_NAME}"

  ; Write registry for Add/Remove Programs
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Kivun" "DisplayName" "${PRODUCT_NAME}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Kivun" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Kivun" "Publisher" "${PRODUCT_PUBLISHER}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Kivun" "UninstallString" "$INSTDIR\Uninstall.exe"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Kivun" "DisplayIcon" "$INSTDIR\claude_code.ico"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Kivun" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Kivun" "HelpLink" "${PRODUCT_WEB_SITE}"
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Kivun" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Kivun" "NoRepair" 1

  ; Add right-click context menu for folders: "Open with Kivun Terminal"
  WriteRegStr HKCR "Directory\shell\KivunTerminal" "" "Open with Kivun Terminal"
  WriteRegStr HKCR "Directory\shell\KivunTerminal" "Icon" "$INSTDIR\claude_code.ico"
  WriteRegStr HKCR "Directory\shell\KivunTerminal\command" "" '"$INSTDIR\kivun-terminal.bat" "%1"'

  ; Also add to directory background (right-click inside a folder)
  WriteRegStr HKCR "Directory\Background\shell\KivunTerminal" "" "Open Kivun Terminal here"
  WriteRegStr HKCR "Directory\Background\shell\KivunTerminal" "Icon" "$INSTDIR\claude_code.ico"
  WriteRegStr HKCR "Directory\Background\shell\KivunTerminal\command" "" '"$INSTDIR\kivun-terminal.bat" "%V"'

SectionEnd

Section "Install Git Bash (Optional)" SecGit
  DetailPrint "Checking for Git Bash..."

  ; Check if Git is installed (using git.exe, not bash, to avoid false positives from WSL)
nsExec::ExecToStack 'where git.exe'
  Pop $0

  ${If} $0 != 0
    DetailPrint "Git not found - Installing..."

    ; Use bundled installer
    DetailPrint "Installing Git for Windows (this may take a few minutes)..."
    ExecWait '"$INSTDIR\Git-2.53.0-64-bit.exe" /VERYSILENT /NORESTART /NOCANCEL /SP- /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /COMPONENTS="icons,ext\reg\shellhere,assoc,assoc_sh"'

    DetailPrint "Git installed successfully"
  ${Else}
    DetailPrint "Git already installed - skipping"
  ${EndIf}
SectionEnd

Section "Install WSL & Ubuntu" SecWSL
  DetailPrint "Checking WSL and Ubuntu installation..."
  CreateDirectory "$INSTDIR"

  ; ============================================
  ; DIAGNOSTIC DUMP using cmd.exe shell redirection
  ; NSIS FileOpen/FileWrite is broken with Unicode True
  ; cmd.exe >> is reliable native Windows I/O
  ; ============================================
  DetailPrint "Running system diagnostics..."

  ; Create log file with header (> creates, >> appends)
  nsExec::ExecToLog 'cmd /c echo KIVUN TERMINAL DIAGNOSTIC LOG > $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
  Pop $8
  nsExec::ExecToLog 'cmd /c echo ================================== >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
  Pop $8
  nsExec::ExecToLog 'cmd /c echo. >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
  Pop $8

  ; Capture wsl --version
  nsExec::ExecToLog 'cmd /c echo --- wsl --version --- >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
  Pop $8
  nsExec::ExecToLog 'cmd /c wsl.exe --version >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\" 2>&1'
  Pop $0
  nsExec::ExecToLog 'cmd /c echo. >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
  Pop $8

  ; Capture wsl --status
  nsExec::ExecToLog 'cmd /c echo --- wsl --status --- >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
  Pop $8
  nsExec::ExecToLog 'cmd /c wsl.exe --status >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\" 2>&1'
  Pop $0
  nsExec::ExecToLog 'cmd /c echo. >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
  Pop $8

  ; Capture wsl -l -v
  nsExec::ExecToLog 'cmd /c echo --- wsl -l -v --- >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
  Pop $8
  nsExec::ExecToLog 'cmd /c wsl.exe -l -v >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\" 2>&1'
  Pop $0
  nsExec::ExecToLog 'cmd /c echo. >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
  Pop $8

  ; Capture wsl -d Ubuntu echo OK
  nsExec::ExecToLog 'cmd /c echo --- wsl -d Ubuntu echo OK --- >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
  Pop $8
  nsExec::ExecToLog 'cmd /c wsl.exe -d Ubuntu echo OK >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\" 2>&1'
  Pop $0
  nsExec::ExecToLog 'cmd /c echo. >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
  Pop $8

  ; Check .wsl-updated file
  nsExec::ExecToLog 'cmd /c if exist $\"$INSTDIR\.wsl-updated$\" (echo .wsl-updated: EXISTS) else (echo .wsl-updated: DOES NOT EXIST) >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
  Pop $8
  nsExec::ExecToLog 'cmd /c echo ================================== >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
  Pop $8

  DetailPrint "Diagnostics saved to: $INSTDIR\DIAGNOSTIC-LOG.txt"

  ; ============================================
  ; INSTALLATION LOGIC
  ; Errors append to log using cmd /c echo >>
  ; ============================================

  ; Check for state file from previous run
  IfFileExists "$INSTDIR\.wsl-updated" wsl_already_updated wsl_check_fresh

wsl_already_updated:
    DetailPrint "WSL was updated in a previous run - verifying it works now..."
    ; Don't skip - we need to verify WSL actually works now!
    ; Fall through to wsl_check_fresh

wsl_check_fresh:

  ; First, try to check if Ubuntu is already installed and working
nsExec::ExecToStack 'wsl.exe -d Ubuntu echo OK'
  Pop $0

  ${If} $0 == 0
    DetailPrint "Ubuntu is already installed, checking configuration..."
    nsExec::ExecToStack 'wsl.exe -d Ubuntu -- whoami'
    Pop $0

    ${If} $0 == 0
      DetailPrint "Ubuntu is fully configured - skipping all setup"
      nsExec::ExecToLog 'wsl.exe --set-default Ubuntu'
      Pop $8
      nsExec::ExecToLog 'cmd /c echo [OK] Ubuntu already fully configured >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
      Pop $8
      Goto WSLComplete
    ${Else}
      DetailPrint "Ubuntu is installed but broken (no default user)"
      nsExec::ExecToLog 'cmd /c echo [ERROR] Ubuntu installed but broken - no default user >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
      Pop $8

      DetailPrint "Removing broken Ubuntu installation..."
      nsExec::ExecToLog 'wsl.exe --unregister Ubuntu'
      Pop $0
      ${If} $0 != 0
        DetailPrint "WARNING: Failed to unregister Ubuntu (exit code $0)"
      ${Else}
        DetailPrint "Ubuntu unregistered successfully"
      ${EndIf}
      Sleep 2000
      DetailPrint "Will reinstall Ubuntu cleanly..."
    ${EndIf}
  ${EndIf}

  ; Ubuntu not installed - check WSL version
  DetailPrint "Checking WSL version..."
nsExec::ExecToStack 'wsl.exe --version'
  Pop $0

  nsExec::ExecToStack 'wsl.exe -l'
  Pop $1  ; Exit code
  Pop $2  ; Output text
  DetailPrint "WSL check: wsl --version exit=$0, wsl -l exit=$1"

  ; If wsl -l succeeded but WSL not functional, test with wsl -l -v
  ${If} $1 == 0
    nsExec::ExecToStack 'wsl.exe -l -v'
    Pop $3  ; Exit code
    Pop $4  ; Output
    ${If} $3 != 0
      DetailPrint "WSL commands exist but WSL feature not enabled (exit code $3)"
      StrCpy $1 "1"  ; Mark as failed
    ${EndIf}
  ${EndIf}

  ${If} $0 != 0  ; wsl --version failed
  ${OrIf} $1 != 0  ; wsl -l failed
    DetailPrint "WSL is not functional"

    ; Check if we already tried to install WSL before
    IfFileExists "$INSTDIR\.wsl-updated" wsl_still_broken wsl_first_install

wsl_still_broken:
    DetailPrint "WSL still not working after restart - trying additional methods..."
    nsExec::ExecToLog 'cmd /c echo. >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
    Pop $8
    nsExec::ExecToLog 'cmd /c echo [INFO] WSL not working after restart - trying winget >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
    Pop $8

    ; Windows features were enabled (via dism) but wsl.exe still doesn't exist
    ; On Windows 11, wsl.exe is a separate Store app - try winget

    ; First check if winget exists (fast check - won't hang)
    nsExec::ExecToStack 'cmd /c where winget.exe'
    Pop $0
    Pop $1
    DetailPrint "winget exists: exit=$0"
    nsExec::ExecToLog 'cmd /c echo [CHECK] winget exists: exit=$0 >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
    Pop $8

    ${If} $0 != 0
      ; winget not available - skip straight to manual instructions
      DetailPrint "winget not found - cannot auto-install WSL"
      nsExec::ExecToLog 'cmd /c echo [WARNING] winget not found - skipping auto-install >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
      Pop $8
      Goto wsl_all_methods_failed
    ${EndIf}

    ; winget exists - run it with ExecWait so user sees a visible console window
    ; (nsExec would hang with no visible progress)
    DetailPrint "Installing WSL via winget (a console window will open)..."
    nsExec::ExecToLog 'cmd /c echo [STEP] Running winget install Microsoft.WSL with visible window >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
    Pop $8
    ExecWait 'cmd /c winget install --id Microsoft.WSL --accept-package-agreements --accept-source-agreements' $0
    DetailPrint "winget install WSL: exit=$0"
    nsExec::ExecToLog 'cmd /c echo [STEP] winget install Microsoft.WSL exit: $0 >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
    Pop $8

    ; Check if wsl.exe exists now (regardless of winget exit code)
    nsExec::ExecToStack 'cmd /c where wsl.exe'
    Pop $2
    Pop $3
    DetailPrint "wsl.exe check after winget: exit=$2"
    nsExec::ExecToLog 'cmd /c echo [CHECK] wsl.exe after winget: exit=$2 >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
    Pop $8

    ${If} $2 == 0
      ; wsl.exe now exists! Delete old marker and continue
      DetailPrint "wsl.exe is now available!"
      nsExec::ExecToLog 'cmd /c echo [OK] wsl.exe found after winget install >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
      Pop $8
      Delete "$INSTDIR\.wsl-updated"

      ; Try wsl --install to set up the kernel
      DetailPrint "Running: wsl --install --no-distribution..."
      ExecWait 'cmd /c wsl.exe --install --no-distribution' $0
      DetailPrint "wsl --install: exit=$0"
      nsExec::ExecToLog 'cmd /c echo [STEP] wsl --install after winget: exit=$0 >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
      Pop $8

      ; Check if WSL is now functional
      nsExec::ExecToStack 'cmd /c wsl.exe --version'
      Pop $0
      Pop $1
      ${If} $0 == 0
        DetailPrint "WSL is now functional!"
        nsExec::ExecToLog 'cmd /c echo [OK] WSL is functional after winget + wsl --install >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
        Pop $8
        Goto wsl_update_done
      ${Else}
        ; WSL app installed but needs another restart for kernel
        DetailPrint "WSL app installed but kernel needs restart"
        nsExec::ExecToLog 'cmd /c echo [INFO] WSL app installed but needs another restart >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
        Pop $8
        FileOpen $0 "$INSTDIR\.wsl-updated" w
        FileWrite $0 "WSL app installed via winget - restart required for kernel"
        FileClose $0
        MessageBox MB_OK "WSL app has been installed but needs one more restart.$\n$\nPlease restart your computer and run the installer again."
        Quit
      ${EndIf}
    ${EndIf}

wsl_all_methods_failed:
    ; winget didn't work or not available - give up with clear instructions
    DetailPrint "CRITICAL: Cannot install WSL - all methods failed"
    nsExec::ExecToLog 'cmd /c echo [CRITICAL] ALL METHODS FAILED >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
    Pop $8
    nsExec::ExecToLog 'cmd /c echo dism.exe was run + restart done + winget failed or not available >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
    Pop $8
    nsExec::ExecToLog 'cmd /c echo MANUAL INSTALLATION REQUIRED >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
    Pop $8
    nsExec::ExecToLog 'cmd /c echo COPY THIS FILE FOR DEBUGGING >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
    Pop $8
    ; Delete marker so next run tries from scratch
    Delete "$INSTDIR\.wsl-updated"
    MessageBox MB_OK "CRITICAL ERROR: Cannot install WSL automatically.$\n$\nAll methods tried:$\n- dism.exe (Windows Features) + restart$\n- winget install Microsoft.WSL$\n$\nPlease install WSL manually:$\n1. Open PowerShell as Administrator$\n2. Run: winget install Microsoft.WSL$\n3. Restart your computer$\n4. Run this installer again$\n$\nDIAGNOSTIC: $INSTDIR\DIAGNOSTIC-LOG.txt"
    Abort "WSL installation failed - all methods exhausted"

wsl_first_install:
    DetailPrint "Proceeding to install/update WSL..."

    ; Check if wsl.exe exists at all
    nsExec::ExecToStack 'cmd /c where wsl.exe'
    Pop $0
    Pop $1
    DetailPrint "wsl.exe exists check: exit=$0"
    nsExec::ExecToLog 'cmd /c echo [CHECK] wsl.exe exists: exit=$0 >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
    Pop $8

    ${If} $0 != 0
      ; wsl.exe does NOT exist - use dism.exe to enable Windows features
      DetailPrint "wsl.exe not found - enabling WSL via Windows Features..."
      nsExec::ExecToLog 'cmd /c echo [INFO] wsl.exe not found, using dism.exe fallback >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
      Pop $8

      DetailPrint "Enabling Microsoft-Windows-Subsystem-Linux..."
      nsExec::ExecToStack 'cmd /c dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart'
      Pop $0
      Pop $1
      DetailPrint "dism WSL feature: exit=$0"
      nsExec::ExecToLog 'cmd /c echo [STEP] dism WSL feature exit: $0 >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
      Pop $8

      ${If} $0 != 0
        DetailPrint "ERROR: Failed to enable WSL feature (exit code $0)"
        nsExec::ExecToLog 'cmd /c echo [CRITICAL] dism WSL feature FAILED >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
        Pop $8
        MessageBox MB_OK "Failed to enable WSL Windows feature.$\n$\nExit code: $0$\n$\nMake sure you are running as Administrator.$\n$\nDIAGNOSTIC: $INSTDIR\DIAGNOSTIC-LOG.txt"
        Abort "WSL feature installation failed"
      ${EndIf}

      DetailPrint "Enabling VirtualMachinePlatform..."
      nsExec::ExecToStack 'cmd /c dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart'
      Pop $0
      Pop $1
      DetailPrint "dism VirtualMachinePlatform: exit=$0"
      nsExec::ExecToLog 'cmd /c echo [STEP] dism VirtualMachinePlatform exit: $0 >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
      Pop $8

      ${If} $0 != 0
        DetailPrint "WARNING: Failed to enable VirtualMachinePlatform (exit code $0)"
        nsExec::ExecToLog 'cmd /c echo [WARNING] dism VirtualMachinePlatform FAILED - may not be needed >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
        Pop $8
      ${EndIf}

      DetailPrint "Windows features enabled. Now installing WSL application..."

      ; After enabling features, try to install the WSL app via winget
      ; On Windows 11, wsl.exe comes from the Store app, not just from features
      DetailPrint "Running: winget install Microsoft.WSL (a console window will open)..."
      ExecWait 'cmd /c winget install --id Microsoft.WSL --accept-package-agreements --accept-source-agreements' $0
      DetailPrint "winget install WSL: exit=$0"
      nsExec::ExecToLog 'cmd /c echo [STEP] winget install Microsoft.WSL exit: $0 >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
      Pop $8

      ${If} $0 == 0
        DetailPrint "WSL app installed via winget!"
        nsExec::ExecToLog 'cmd /c echo [OK] WSL app installed via winget >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
        Pop $8

        ; Check if wsl.exe is now available
        nsExec::ExecToStack 'cmd /c where wsl.exe'
        Pop $0
        Pop $1
        ${If} $0 == 0
          DetailPrint "wsl.exe is now available! May still need restart for kernel."
          nsExec::ExecToLog 'cmd /c echo [OK] wsl.exe now found after winget install >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
          Pop $8
        ${EndIf}
      ${Else}
        DetailPrint "winget not available or failed (exit=$0) - will try after restart"
        nsExec::ExecToLog 'cmd /c echo [WARNING] winget install failed exit=$0 - will retry after restart >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
        Pop $8
      ${EndIf}

    ${Else}
      ; wsl.exe exists - use wsl commands
      DetailPrint "Running: wsl --update (this may take a few minutes)..."
      nsExec::ExecToStack 'wsl.exe --update'
      Pop $0
      Pop $1
      DetailPrint "wsl --update: exit=$0"
      nsExec::ExecToLog 'cmd /c echo [STEP] wsl --update exit code: $0 >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
      Pop $8
      Sleep 3000

      DetailPrint "Running: wsl --install --no-distribution..."
      nsExec::ExecToStack 'wsl.exe --install --no-distribution'
      Pop $0
      Pop $1
      DetailPrint "wsl --install: exit=$0"
      nsExec::ExecToLog 'cmd /c echo [STEP] wsl --install exit code: $0 >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
      Pop $8

      ${If} $0 != 0
        DetailPrint "ERROR: wsl --install failed with exit code $0"
        nsExec::ExecToLog 'cmd /c echo [CRITICAL] wsl --install FAILED >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
        Pop $8
        nsExec::ExecToLog 'cmd /c echo COPY THIS FILE FOR DEBUGGING >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
        Pop $8
        MessageBox MB_OK "WSL installation failed.$\n$\nExit code: $0$\n$\nDIAGNOSTIC FILE:$\n$INSTDIR\DIAGNOSTIC-LOG.txt$\n$\nCOPY THAT FILE for debugging."
        Abort "WSL installation failed"
      ${Else}
        DetailPrint "WSL installation initiated successfully"
      ${EndIf}
      Sleep 3000

    ${EndIf}

    ; Mark that restart is needed
    StrCpy $NeedsRestart "1"
    FileOpen $0 "$INSTDIR\.wsl-updated" w
    FileWrite $0 "WSL updated - restart required"
    FileClose $0
    DetailPrint "WSL installed/updated - restart required"

    nsExec::ExecToLog 'cmd /c echo [RESTART REQUIRED] WSL was installed - must restart >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
    Pop $8

    MessageBox MB_OKCANCEL "WSL has been installed/updated.$\r$\n$\r$\nYou MUST restart your computer now.$\r$\n$\r$\nAfter restart, run this installer again.$\r$\n$\r$\nDiagnostic: $INSTDIR\DIAGNOSTIC-LOG.txt$\r$\n$\r$\nClick OK to exit.$\r$\nClick Cancel to continue anyway (not recommended)." IDOK exit_now IDCANCEL continue_anyway

exit_now:
  Quit

continue_anyway:
  DetailPrint "User chose to continue without restart (not recommended)"
  Goto wsl_update_done

  ${Else}
    DetailPrint "WSL is installed with modern version"
    nsExec::ExecToLog 'cmd /c echo [OK] WSL is functional >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
    Pop $8
  ${EndIf}

wsl_update_done:

  ; Install Ubuntu distribution
  DetailPrint "Installing Ubuntu distribution..."
  DetailPrint "This may take several minutes..."
nsExec::ExecToLog 'wsl.exe --install -d Ubuntu --no-launch'
  Pop $0
  DetailPrint "Ubuntu install command: exit=$0"
  nsExec::ExecToLog 'cmd /c echo [STEP] wsl --install -d Ubuntu exit: $0 >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
  Pop $8

  ${If} $0 != 0
    DetailPrint "ERROR: Ubuntu installation command failed (exit code $0)"
    nsExec::ExecToLog 'cmd /c echo [CRITICAL] Ubuntu install command FAILED >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
    Pop $8
    nsExec::ExecToLog 'cmd /c echo COPY THIS FILE FOR DEBUGGING >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
    Pop $8
    MessageBox MB_OK "Failed to start Ubuntu installation.$\n$\nExit code: $0$\n$\nDIAGNOSTIC: $INSTDIR\DIAGNOSTIC-LOG.txt$\n$\nCOPY that file for debugging."
    Abort "Ubuntu installation failed to start"
  ${EndIf}

  ; Poll for Ubuntu installation completion (max 90 attempts = 3 minutes)
  DetailPrint "Waiting for Ubuntu installation to complete..."
  DetailPrint "This may take 1-3 minutes..."
  StrCpy $0 "0"
poll_ubuntu_start:
    IntOp $0 $0 + 1

    ; Show progress every 15 attempts (30 seconds)
    IntOp $2 $0 % 15
    ${If} $2 == 0
      IntOp $3 $0 * 2
      DetailPrint "Still waiting for Ubuntu... ($3 seconds elapsed)"
    ${EndIf}

    ${If} $0 > 90
      DetailPrint "ERROR: Timeout waiting for Ubuntu installation (3 minutes)"
      nsExec::ExecToLog 'cmd /c echo. >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
      Pop $8
      nsExec::ExecToLog 'cmd /c echo [TIMEOUT] Ubuntu did not install in 3 minutes >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
      Pop $8
      nsExec::ExecToLog 'cmd /c echo --- post-timeout wsl -l -v --- >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
      Pop $8
      nsExec::ExecToLog 'cmd /c wsl.exe -l -v >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\" 2>&1'
      Pop $8
      nsExec::ExecToLog 'cmd /c echo COPY THIS FILE FOR DEBUGGING >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
      Pop $8
      MessageBox MB_OK "Ubuntu installation timed out (3 minutes).$\n$\nDIAGNOSTIC FILE:$\n$INSTDIR\DIAGNOSTIC-LOG.txt$\n$\nCOPY AND SHARE for debugging."
      Abort "Ubuntu installation timeout"
    ${EndIf}

    nsExec::ExecToStack 'wsl.exe -d Ubuntu echo OK'
    Pop $1
    ${If} $1 == 0
      DetailPrint "Ubuntu installation completed successfully!"
      nsExec::ExecToLog 'cmd /c echo [OK] Ubuntu ready after $0 attempts >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
      Pop $8
      Goto poll_ubuntu_done
    ${EndIf}

    Sleep 2000
    Goto poll_ubuntu_start

poll_ubuntu_done:

  ; Set Ubuntu as default distribution
  DetailPrint "Setting Ubuntu as default distribution..."
nsExec::ExecToLog 'wsl.exe --set-default Ubuntu'
  Pop $0
  ${If} $0 != 0
    DetailPrint "WARNING: Failed to set Ubuntu as default"
  ${EndIf}

ConfigureUser:
  DetailPrint "Configuring Ubuntu default user..."
  nsExec::ExecToLog 'cmd /c echo [STEP] Configuring user >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
  Pop $8

  ; Shutdown WSL to ensure clean state
  nsExec::ExecToLog 'wsl.exe --shutdown'
  Sleep 3000

  ; Set root as default user BEFORE any user operations
  DetailPrint "Setting root as default user..."
  nsExec::ExecToLog '"ubuntu.exe" config --default-user root'
  Pop $0
  ${If} $0 != 0
    DetailPrint "WARNING: ubuntu.exe config failed (code $0), trying alternative path..."
    nsExec::ExecToLog '"$PROGRAMFILES\WindowsApps\CanonicalGroupLimited.Ubuntu_2204.0.10.0_x64__79rhkp1fndgsc\ubuntu.exe" config --default-user root'
    Pop $0
    ${If} $0 != 0
      DetailPrint "WARNING: Could not configure default user via ubuntu.exe (code $0)"
    ${EndIf}
  ${EndIf}
  Sleep 2000

  ; Check if user already exists
  DetailPrint "Checking if user already exists..."
  nsExec::ExecToStack 'wsl.exe -d Ubuntu -u root -- id $ConfigUsername'
  Pop $1
  ${If} $1 == 0
    DetailPrint "User $ConfigUsername already exists, skipping creation"
    nsExec::ExecToLog 'cmd /c echo [OK] User $ConfigUsername already exists >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
    Pop $8
    Goto UserAlreadyExists
  ${EndIf}

  ; Create user
  DetailPrint "Creating user: $ConfigUsername..."

  DetailPrint "Step 1: Creating user account..."
  nsExec::ExecToLog 'wsl.exe -d Ubuntu -u root -- useradd -m -s /bin/bash $ConfigUsername'
  Pop $0
  nsExec::ExecToLog 'cmd /c echo Step 1 useradd exit: $0 >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
  Pop $8
  ${If} $0 != 0
    DetailPrint "ERROR: Failed to create user account (exit code $0)"
    nsExec::ExecToLog 'cmd /c echo [ERROR] useradd FAILED >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
    Pop $8
    MessageBox MB_OKCANCEL|MB_ICONEXCLAMATION "Failed to create Ubuntu user account.$\n$\nExit code: $0$\n$\nDIAGNOSTIC: $INSTDIR\DIAGNOSTIC-LOG.txt$\n$\nClick OK to continue, Cancel to abort." IDOK ContinueAfterUserError
    Abort "User creation failed"
ContinueAfterUserError:
    DetailPrint "Continuing despite user creation error..."
  ${EndIf}

  DetailPrint "Step 2: Setting password..."
  nsExec::ExecToLog 'wsl.exe -d Ubuntu -u root -- bash -c "echo $\'$ConfigUsername:$ConfigPassword$\' | chpasswd"'
  Pop $0
  nsExec::ExecToLog 'cmd /c echo Step 2 chpasswd exit: $0 >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
  Pop $8
  ${If} $0 != 0
    DetailPrint "ERROR: Failed to set password (exit code $0)"
    nsExec::ExecToLog 'cmd /c echo [ERROR] chpasswd FAILED >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
    Pop $8
    MessageBox MB_OK "Failed to set password. Exit code: $0$\n$\nDIAGNOSTIC: $INSTDIR\DIAGNOSTIC-LOG.txt"
    Abort "Password configuration failed"
  ${EndIf}

  DetailPrint "Step 3: Adding to sudo group..."
  nsExec::ExecToLog 'wsl.exe -d Ubuntu -u root -- usermod -aG sudo $ConfigUsername'
  Pop $0
  nsExec::ExecToLog 'cmd /c echo Step 3 usermod exit: $0 >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
  Pop $8
  ${If} $0 != 0
    DetailPrint "ERROR: Failed to add to sudo group (exit code $0)"
    nsExec::ExecToLog 'cmd /c echo [ERROR] usermod FAILED >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
    Pop $8
    MessageBox MB_OK "Failed to configure sudo. Exit code: $0$\n$\nDIAGNOSTIC: $INSTDIR\DIAGNOSTIC-LOG.txt"
    Abort "Sudo configuration failed"
  ${EndIf}

  DetailPrint "Step 4: Configuring sudoers..."
  nsExec::ExecToLog 'wsl.exe -d Ubuntu -u root -- bash -c "echo $\'$ConfigUsername ALL=(ALL) NOPASSWD:ALL$\' > /etc/sudoers.d/$ConfigUsername"'
  Pop $0
  nsExec::ExecToLog 'cmd /c echo Step 4 sudoers exit: $0 >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
  Pop $8
  ${If} $0 != 0
    DetailPrint "WARNING: Failed to create sudoers file (exit code $0)"
  ${EndIf}

  nsExec::ExecToLog 'wsl.exe -d Ubuntu -u root -- chmod 0440 /etc/sudoers.d/$ConfigUsername'
  Pop $0

  DetailPrint "Step 5: Setting default user in wsl.conf..."
  nsExec::ExecToLog 'wsl.exe -d Ubuntu -u root -- bash -c "mkdir -p /etc"'
  Pop $0
  nsExec::ExecToLog 'wsl.exe -d Ubuntu -u root -- bash -c "echo -e $\'[user]\ndefault=$ConfigUsername$\' > /etc/wsl.conf"'
  Pop $0
  nsExec::ExecToLog 'cmd /c echo Step 5 wsl.conf exit: $0 >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
  Pop $8
  ${If} $0 != 0
    DetailPrint "WARNING: Failed to write wsl.conf (exit code $0)"
  ${EndIf}

  DetailPrint "Step 6: Setting default user via ubuntu.exe..."
  nsExec::ExecToLog '"ubuntu.exe" config --default-user $ConfigUsername'
  Pop $0
  nsExec::ExecToLog 'cmd /c echo Step 6 ubuntu.exe exit: $0 >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
  Pop $8
  ${If} $0 != 0
    DetailPrint "WARNING: Failed to set default user via ubuntu.exe (code $0)"
  ${EndIf}
  Sleep 1000

  DetailPrint "User creation completed"

UserAlreadyExists:

  ; Shutdown WSL to apply wsl.conf
  DetailPrint "Restarting WSL to apply configuration..."
  nsExec::ExecToLog 'wsl.exe --shutdown'
  Sleep 3000

  ; Verify user was created
  DetailPrint "Verifying Ubuntu configuration..."
nsExec::ExecToLog 'wsl.exe -d Ubuntu -- whoami'
  Pop $0
  nsExec::ExecToLog 'cmd /c echo [VERIFY] whoami exit: $0 >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
  Pop $8

  ${If} $0 != 0
    DetailPrint "ERROR: Ubuntu user verification failed (exit code $0)"
    nsExec::ExecToLog 'cmd /c echo [CRITICAL] Verification FAILED >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
    Pop $8
    nsExec::ExecToLog 'cmd /c echo COPY THIS FILE FOR DEBUGGING >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
    Pop $8
    MessageBox MB_OK "Ubuntu verification failed.$\n$\nDIAGNOSTIC: $INSTDIR\DIAGNOSTIC-LOG.txt$\n$\nCOPY that file for debugging."
    Abort "Ubuntu verification failed"
  ${Else}
    DetailPrint "Ubuntu configured successfully with username: $ConfigUsername"
    nsExec::ExecToLog 'cmd /c echo [OK] Verification passed >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
    Pop $8
  ${EndIf}

WSLComplete:
  DetailPrint "WSL and Ubuntu setup complete"
  nsExec::ExecToLog 'cmd /c echo [DONE] WSL and Ubuntu setup complete >> $\"$INSTDIR\DIAGNOSTIC-LOG.txt$\"'
  Pop $8
  DetailPrint "Diagnostic log: $INSTDIR\DIAGNOSTIC-LOG.txt"
SectionEnd

Section "Install Konsole & Claude Code" SecKonsole
  DetailPrint "Installing Konsole, fonts, Node.js, and Claude Code in Ubuntu..."

  ; Ensure WSL is running
  DetailPrint "Starting WSL..."
nsExec::ExecToLog 'wsl.exe -d Ubuntu -- echo WSL ready'
  Pop $0
  ${If} $0 != 0
    DetailPrint "ERROR: WSL is not running or Ubuntu is not available"
    MessageBox MB_OK "WSL/Ubuntu is not available. Cannot continue installation.$\r$\n$\r$\nPlease ensure WSL and Ubuntu are properly installed."
    Abort
  ${EndIf}
  Sleep 1000

  ; Run post-install script
  DetailPrint "Running post-installation (this may take 5-10 minutes)..."
  DetailPrint "Installing: Konsole, Hebrew fonts, Node.js, Claude Code..."

  ; Get the Windows path to post-install.sh and convert to WSL path
  SetOutPath "$INSTDIR"

  ; Convert Windows path to WSL path
  Push "$INSTDIR\post-install.sh"
  Call WindowsToWSLPath
  Pop $WSLInstallPath

  ; Execute post-install.sh as the configured user
  DetailPrint "Running as user: $ConfigUsername"
  DetailPrint "Script path: $WSLInstallPath"
ExecWait 'wsl.exe -d Ubuntu -u $ConfigUsername -- bash -c "bash $\"$WSLInstallPath$\""' $0
  ${If} $0 != 0
    DetailPrint "WARNING: Post-installation script encountered errors (exit code: $0)"
    MessageBox MB_OKCANCEL "Post-installation encountered errors. Some components may not be installed correctly.$\r$\n$\r$\nContinue anyway?" IDOK continue_post_install IDCANCEL abort_post_install
abort_post_install:
  Abort
continue_post_install:
  ${EndIf}

  DetailPrint "Konsole and Claude Code installed successfully!"
SectionEnd

Section "Create Desktop Shortcut" SecDesktop
  CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\claude-hebrew-konsole.bat" "" "$INSTDIR\claude_code.ico" 0 SW_SHOWNORMAL "" "${PRODUCT_DESCRIPTION}"
  CreateShortCut "$DESKTOP\${PRODUCT_NAME} (Choose Folder).lnk" "$INSTDIR\kivun-terminal-choose-folder.bat" "" "$INSTDIR\claude_code.ico" 0 SW_SHOWNORMAL "" "Launch in a specific folder"
  CreateShortCut "$SENDTO\Kivun Terminal.lnk" "$INSTDIR\claude-hebrew-konsole.bat" "" "$INSTDIR\claude_code.ico" 0 SW_SHOWNORMAL "" "Open with Kivun Terminal"
SectionEnd

Section "VcXsrv X Server (for keyboard switching)" SecVcXsrv
  SectionIn 1  ; Selected by default
  DetailPrint "Checking for VcXsrv..."

  ; Check if VcXsrv is already installed
  IfFileExists "C:\Program Files\VcXsrv\vcxsrv.exe" vcxsrv_already_installed vcxsrv_do_install

vcxsrv_do_install:
  ; Check if bundled installer exists
  IfFileExists "$INSTDIR\vcxsrv-64.1.20.14.0.installer.exe" vcxsrv_has_installer vcxsrv_no_installer

vcxsrv_no_installer:
  DetailPrint "WARNING: VcXsrv installer not found in $INSTDIR"
  DetailPrint "Download from https://sourceforge.net/projects/vcxsrv/ and place in installer directory"
  MessageBox MB_OK "VcXsrv installer not found.$\r$\n$\r$\nPlease download vcxsrv-64.1.20.14.0.installer.exe from:$\r$\nhttps://sourceforge.net/projects/vcxsrv/$\r$\n$\r$\nPlace it in: $INSTDIR$\r$\nThen run the installer again, or install VcXsrv manually."
  Goto vcxsrv_write_config

vcxsrv_has_installer:
  DetailPrint "Installing VcXsrv (silent install)..."
  ExecWait '"$INSTDIR\vcxsrv-64.1.20.14.0.installer.exe" /S' $0
  DetailPrint "VcXsrv installer exit code: $0"

  ${If} $0 != 0
    DetailPrint "WARNING: VcXsrv installation may have failed (exit code $0)"
    MessageBox MB_OK "VcXsrv installation returned exit code $0.$\r$\n$\r$\nYou can install VcXsrv manually from:$\r$\nhttps://sourceforge.net/projects/vcxsrv/"
  ${Else}
    DetailPrint "VcXsrv installed successfully"
  ${EndIf}

  Goto vcxsrv_add_firewall

vcxsrv_already_installed:
  DetailPrint "VcXsrv already installed - skipping"

vcxsrv_add_firewall:
  ; Add firewall rule scoped to WSL2 subnet
  DetailPrint "Adding firewall rule for VcXsrv..."
  nsExec::ExecToLog 'netsh advfirewall firewall delete rule name="VcXsrv - Kivun Terminal"'
  Pop $0
  nsExec::ExecToLog 'netsh advfirewall firewall add rule name="VcXsrv - Kivun Terminal" dir=in action=allow program="C:\Program Files\VcXsrv\vcxsrv.exe" enable=yes remoteip=172.16.0.0/12,192.168.0.0/16'
  Pop $0
  ${If} $0 != 0
    DetailPrint "WARNING: Failed to add firewall rule (exit code $0)"
  ${Else}
    DetailPrint "Firewall rule added for VcXsrv"
  ${EndIf}

vcxsrv_write_config:
  ; Update config.txt to enable VcXsrv mode
  DetailPrint "Enabling VcXsrv mode in config.txt..."
  FileOpen $0 "$INSTDIR\config.txt" a
  FileSeek $0 0 END
  FileWrite $0 "$\r$\n# VcXsrv X Server (for keyboard switching)$\r$\n"
  FileWrite $0 "# Enables Alt+Shift keyboard switching between Hebrew and English$\r$\n"
  FileWrite $0 "USE_VCXSRV=true$\r$\n"
  FileClose $0
  DetailPrint "VcXsrv configuration complete"
SectionEnd

; Section descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecCore} "Core files, documentation, and bundled installers (required)"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecWSL} "Install WSL 2 and Ubuntu Linux distribution (required)"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecKonsole} "Install Konsole terminal, Hebrew fonts, Node.js, and Claude Code (required)"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecGit} "Install Git for version control (optional - not required for WSL)"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecDesktop} "Create a desktop shortcut for easy access (recommended)"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecVcXsrv} "Install VcXsrv X server to enable Alt+Shift keyboard language switching in Konsole (optional)"
!insertmacro MUI_FUNCTION_DESCRIPTION_END

; Desktop shortcut function
Function CreateDesktopShortcut
  CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\claude-hebrew-konsole.bat" "" "$INSTDIR\claude_code.ico" 0 SW_SHOWNORMAL "" "${PRODUCT_DESCRIPTION}"
  CreateShortCut "$DESKTOP\${PRODUCT_NAME} (Choose Folder).lnk" "$INSTDIR\kivun-terminal-choose-folder.bat" "" "$INSTDIR\claude_code.ico" 0 SW_SHOWNORMAL "" "Launch in a specific folder"
  CreateShortCut "$SENDTO\Kivun Terminal.lnk" "$INSTDIR\claude-hebrew-konsole.bat" "" "$INSTDIR\claude_code.ico" 0 SW_SHOWNORMAL "" "Open with Kivun Terminal"
FunctionEnd

; Convert Windows path to WSL path
; Input: Push "C:\path\to\file"
; Output: Pop "/mnt/c/path/to/file"
Function WindowsToWSLPath
  Exch $0  ; Get input path
  Push $1  ; Temp variable
  Push $2  ; Temp variable

  ; Replace backslashes with forward slashes
  ${StrRep} $0 $0 "\" "/"

  ; Check if path starts with drive letter (e.g., C:/)
  StrCpy $1 $0 2
  ${If} $1 == "C:"
    StrCpy $2 $0 "" 2  ; Get everything after "C:"
    StrCpy $0 "/mnt/c$2"
  ${ElseIf} $1 == "D:"
    StrCpy $2 $0 "" 2
    StrCpy $0 "/mnt/d$2"
  ${ElseIf} $1 == "E:"
    StrCpy $2 $0 "" 2
    StrCpy $0 "/mnt/e$2"
  ${EndIf}

  Pop $2
  Pop $1
  Exch $0  ; Return converted path
FunctionEnd

; Check for restart on finish
Function .onInstSuccess
  ${If} $NeedsRestart == "1"
    MessageBox MB_YESNO "WSL was just installed and may require a system restart.$\r$\n$\r$\nWould you like to restart now?" IDYES restart IDNO norestart
restart:
  Reboot
norestart:
  MessageBox MB_OK "Please restart your computer if ${PRODUCT_NAME} doesn't work immediately.$\r$\n$\r$\nAfter restart, launch using the desktop shortcut."
  ${EndIf}
FunctionEnd

; Uninstaller
Section "Uninstall"
  ; Remove files
  Delete "$INSTDIR\*.*"
  RMDir /r "$INSTDIR"

  ; Remove shortcuts
  Delete "$DESKTOP\${PRODUCT_NAME}.lnk"
  Delete "$DESKTOP\${PRODUCT_NAME} (Choose Folder).lnk"
  Delete "$SENDTO\Kivun Terminal.lnk"
  RMDir /r "$SMPROGRAMS\${PRODUCT_NAME}"

  ; Remove registry entries
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Kivun"

  ; Remove context menu entries
  DeleteRegKey HKCR "Directory\shell\KivunTerminal"
  DeleteRegKey HKCR "Directory\Background\shell\KivunTerminal"

  ; Remove VcXsrv firewall rule (if it exists)
  nsExec::ExecToLog 'netsh advfirewall firewall delete rule name="VcXsrv - Kivun Terminal"'
  Pop $0

  MessageBox MB_OK "${PRODUCT_NAME} has been uninstalled.$\r$\n$\r$\nNote: WSL, Ubuntu, and installed packages remain on your system for potential reuse."
SectionEnd
