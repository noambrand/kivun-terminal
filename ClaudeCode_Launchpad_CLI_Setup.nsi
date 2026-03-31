; ClaudeCode Launchpad CLI v2.0.0 - Professional Installer
; Claude Code installer for Windows
; Encoding: UTF-8

Unicode True

!define PRODUCT_NAME "ClaudeCode Launchpad CLI"
!define PRODUCT_VERSION "2.1.0"
!define PRODUCT_PUBLISHER "Noam Brand"
!define PRODUCT_WEB_SITE "https://github.com"
!define PRODUCT_DESCRIPTION "Claude Code installer for Windows"
!define PRODUCT_SUBTITLE "Automatic installation, light blue terminal, folder shortcuts"
!define INSTALL_DIR "$LOCALAPPDATA\Kivun"

; Modern UI
!include "MUI2.nsh"
!include "LogicLib.nsh"
!include "FileFunc.nsh"
!include "WinMessages.nsh"


; Request admin privileges
RequestExecutionLevel admin

; Installer settings
Name "${PRODUCT_NAME}"
OutFile "ClaudeCode_Launchpad_CLI_Setup.exe"
InstallDir "${INSTALL_DIR}"
ShowInstDetails show

; Version info
VIProductVersion "2.1.0.0"
VIAddVersionKey "ProductName" "${PRODUCT_NAME}"
VIAddVersionKey "ProductVersion" "${PRODUCT_VERSION}"
VIAddVersionKey "CompanyName" "${PRODUCT_PUBLISHER}"
VIAddVersionKey "FileDescription" "${PRODUCT_DESCRIPTION}"
VIAddVersionKey "FileVersion" "2.1.0.0"
VIAddVersionKey "LegalCopyright" "(C) 2026 ${PRODUCT_PUBLISHER}"

; Modern UI Configuration
!define MUI_ABORTWARNING
!define MUI_ICON "source\claude_code.ico"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP_NOSTRETCH
!define MUI_WELCOMEFINISHPAGE_BITMAP_NOSTRETCH

; Welcome page
!define MUI_WELCOMEPAGE_TITLE "Welcome to ${PRODUCT_NAME}"
!define MUI_WELCOMEPAGE_TEXT "This installer will set up ${PRODUCT_NAME} on your computer.$\r$\n$\r$\n${PRODUCT_DESCRIPTION}$\r$\n$\r$\nWhat will be installed:$\r$\n  - Node.js (if not already installed)$\r$\n  - Claude Code (via npm)$\r$\n  - Windows Terminal (recommended)$\r$\n  - Git (optional)$\r$\n$\r$\nFeatures:$\r$\n  - Light blue terminal color scheme$\r$\n  - Folder shortcuts and right-click integration$\r$\n  - One-click launch from desktop$\r$\n$\r$\nClick Next to continue."
!insertmacro MUI_PAGE_WELCOME

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
!define MUI_FINISHPAGE_TEXT "${PRODUCT_NAME} has been installed successfully.$\r$\n$\r$\n${PRODUCT_DESCRIPTION}$\r$\n$\r$\nLaunch ${PRODUCT_NAME} using the desktop shortcut.$\r$\n$\r$\nYou will need an Anthropic API key to use Claude Code.$\r$\nGet one at: https://console.anthropic.com/"
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

; Configuration page
Function ConfigPage
  !insertmacro MUI_HEADER_TEXT "Configuration" "Choose your display name and language preference"

nsDialogs::Create 1018
  Pop $0
  ${If} $0 == error
    Abort
  ${EndIf}

  ; Display name
  ${NSD_CreateLabel} 0 0 100% 12u "Your name (for display purposes):"
  Pop $0
  ${NSD_CreateText} 0 15u 100% 12u ""
  Pop $ConfigUsername

  ; Language selection
  ${NSD_CreateLabel} 0 40u 100% 12u "Claude Code response language:"
  Pop $0

  ${NSD_CreateDropList} 0 55u 100% 200u ""
  Pop $ConfigLanguage
  ${NSD_CB_AddString} $ConfigLanguage "English"
  ${NSD_CB_AddString} $ConfigLanguage "Hebrew"
  ${NSD_CB_AddString} $ConfigLanguage "Arabic"
  ${NSD_CB_AddString} $ConfigLanguage "Persian"
  ${NSD_CB_AddString} $ConfigLanguage "Urdu"
  ${NSD_CB_AddString} $ConfigLanguage "Kurdish"
  ${NSD_CB_AddString} $ConfigLanguage "Pashto"
  ${NSD_CB_AddString} $ConfigLanguage "Sindhi"
  ${NSD_CB_AddString} $ConfigLanguage "Yiddish"
  ${NSD_CB_AddString} $ConfigLanguage "Syriac"
  ${NSD_CB_AddString} $ConfigLanguage "Dhivehi"
  ${NSD_CB_AddString} $ConfigLanguage "NKo"
  ${NSD_CB_AddString} $ConfigLanguage "Adlam"
  ${NSD_CB_AddString} $ConfigLanguage "Mandaic"
  ${NSD_CB_AddString} $ConfigLanguage "Samaritan"
  ${NSD_CB_AddString} $ConfigLanguage "Dari"
  ${NSD_CB_AddString} $ConfigLanguage "Uyghur"
  ${NSD_CB_AddString} $ConfigLanguage "Balochi"
  ${NSD_CB_AddString} $ConfigLanguage "Kashmiri"
  ${NSD_CB_AddString} $ConfigLanguage "Shahmukhi"
  ${NSD_CB_AddString} $ConfigLanguage "Azeri South"
  ${NSD_CB_AddString} $ConfigLanguage "Jawi"
  ${NSD_CB_AddString} $ConfigLanguage "Hausa Ajami"
  ${NSD_CB_AddString} $ConfigLanguage "Rohingya"
  ${NSD_CB_AddString} $ConfigLanguage "Turoyo"
  ${NSD_CB_SelectString} $ConfigLanguage "English"

nsDialogs::Show
FunctionEnd

Function ConfigPageLeave
  ${NSD_GetText} $ConfigLanguage $ConfigLanguage
  ${NSD_GetText} $ConfigUsername $ConfigUsername
FunctionEnd

; Installation sections
Section "!Core Components (Required)" SecCore
  SectionIn RO  ; Read-only, cannot be deselected

  SetOutPath "$INSTDIR"

  ; Copy essential files from source/
  File "source\claude_code.ico"
  File "source\config.txt"
  File "source\claudecode-launchpad.bat"
  File "source\claudecode-launchpad-choose-folder.bat"
  File "source\folder-picker.vbs"
  File "source\folder-picker-launcher.vbs"
  File "source\write-path.vbs"
  File "source\create-shortcut.vbs"
  File "source\post-install.bat"
  File "source\claudecode-launchpad-wt-fragment.json"
  File "source\apply-wt-settings.vbs"
  File "source\statusline.mjs"
  File "source\configure-statusline.js"

  ; Copy documentation
  File "README.md"
  File "docs\QUICK_START.md"
  File "docs\CHANGELOG.md"

  ; Create config.txt with user preferences
  Delete "$INSTDIR\config.txt"
  FileOpen $0 "$INSTDIR\config.txt" w
  FileWrite $0 "# ClaudeCode Launchpad CLI Configuration$\r$\n"
  FileWrite $0 "# Claude Code response language$\r$\n"
  FileWrite $0 "#$\r$\n"
  FileWrite $0 "# Options: english, hebrew, arabic, persian, urdu, kurdish, pashto, sindhi, yiddish, syriac, dhivehi, nko, adlam, mandaic, samaritan, dari, uyghur, balochi, kashmiri, shahmukhi, azeri_south, jawi, hausa_ajami, rohingya, turoyo$\r$\n"
  FileWrite $0 "# Default: english$\r$\n"

  ${If} $ConfigLanguage == "Hebrew"
    FileWrite $0 "RESPONSE_LANGUAGE=hebrew$\r$\n"
  ${ElseIf} $ConfigLanguage == "Arabic"
    FileWrite $0 "RESPONSE_LANGUAGE=arabic$\r$\n"
  ${ElseIf} $ConfigLanguage == "Persian"
    FileWrite $0 "RESPONSE_LANGUAGE=persian$\r$\n"
  ${ElseIf} $ConfigLanguage == "Urdu"
    FileWrite $0 "RESPONSE_LANGUAGE=urdu$\r$\n"
  ${ElseIf} $ConfigLanguage == "Kurdish"
    FileWrite $0 "RESPONSE_LANGUAGE=kurdish$\r$\n"
  ${ElseIf} $ConfigLanguage == "Pashto"
    FileWrite $0 "RESPONSE_LANGUAGE=pashto$\r$\n"
  ${ElseIf} $ConfigLanguage == "Sindhi"
    FileWrite $0 "RESPONSE_LANGUAGE=sindhi$\r$\n"
  ${ElseIf} $ConfigLanguage == "Yiddish"
    FileWrite $0 "RESPONSE_LANGUAGE=yiddish$\r$\n"
  ${ElseIf} $ConfigLanguage == "Syriac"
    FileWrite $0 "RESPONSE_LANGUAGE=syriac$\r$\n"
  ${ElseIf} $ConfigLanguage == "Dhivehi"
    FileWrite $0 "RESPONSE_LANGUAGE=dhivehi$\r$\n"
  ${ElseIf} $ConfigLanguage == "NKo"
    FileWrite $0 "RESPONSE_LANGUAGE=nko$\r$\n"
  ${ElseIf} $ConfigLanguage == "Adlam"
    FileWrite $0 "RESPONSE_LANGUAGE=adlam$\r$\n"
  ${ElseIf} $ConfigLanguage == "Mandaic"
    FileWrite $0 "RESPONSE_LANGUAGE=mandaic$\r$\n"
  ${ElseIf} $ConfigLanguage == "Samaritan"
    FileWrite $0 "RESPONSE_LANGUAGE=samaritan$\r$\n"
  ${ElseIf} $ConfigLanguage == "Dari"
    FileWrite $0 "RESPONSE_LANGUAGE=dari$\r$\n"
  ${ElseIf} $ConfigLanguage == "Uyghur"
    FileWrite $0 "RESPONSE_LANGUAGE=uyghur$\r$\n"
  ${ElseIf} $ConfigLanguage == "Balochi"
    FileWrite $0 "RESPONSE_LANGUAGE=balochi$\r$\n"
  ${ElseIf} $ConfigLanguage == "Kashmiri"
    FileWrite $0 "RESPONSE_LANGUAGE=kashmiri$\r$\n"
  ${ElseIf} $ConfigLanguage == "Shahmukhi"
    FileWrite $0 "RESPONSE_LANGUAGE=shahmukhi$\r$\n"
  ${ElseIf} $ConfigLanguage == "Azeri South"
    FileWrite $0 "RESPONSE_LANGUAGE=azeri_south$\r$\n"
  ${ElseIf} $ConfigLanguage == "Jawi"
    FileWrite $0 "RESPONSE_LANGUAGE=jawi$\r$\n"
  ${ElseIf} $ConfigLanguage == "Hausa Ajami"
    FileWrite $0 "RESPONSE_LANGUAGE=hausa_ajami$\r$\n"
  ${ElseIf} $ConfigLanguage == "Rohingya"
    FileWrite $0 "RESPONSE_LANGUAGE=rohingya$\r$\n"
  ${ElseIf} $ConfigLanguage == "Turoyo"
    FileWrite $0 "RESPONSE_LANGUAGE=turoyo$\r$\n"
  ${Else}
    FileWrite $0 "RESPONSE_LANGUAGE=english$\r$\n"
  ${EndIf}

  FileClose $0

  ; Write uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"

  ; Create Start Menu shortcuts
  CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk" "wscript.exe" '"$INSTDIR\folder-picker-launcher.vbs"' "$INSTDIR\claude_code.ico" 0 SW_SHOWNORMAL "" "${PRODUCT_DESCRIPTION}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Configuration.lnk" "notepad.exe" "$INSTDIR\config.txt" "" 0 SW_SHOWNORMAL "" "Configure language settings"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall.lnk" "$INSTDIR\Uninstall.exe" "" "" 0 SW_SHOWNORMAL "" "Uninstall ${PRODUCT_NAME}"

  ; Clean up old-name entries from previous "Kivun Terminal" installs
  Delete "$DESKTOP\Kivun Terminal.lnk"
  Delete "$SENDTO\Kivun Terminal.lnk"
  RMDir /r "$SMPROGRAMS\Kivun Terminal"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Kivun"
  DeleteRegKey HKCR "Directory\shell\KivunTerminal"
  DeleteRegKey HKCR "Directory\Background\shell\KivunTerminal"
  RMDir /r "$LOCALAPPDATA\Microsoft\Windows Terminal\Fragments\KivunTerminal"

  ; Create Desktop shortcut
  CreateShortCut "$DESKTOP\ClaudeCode Launchpad CLI.lnk" "wscript.exe" '"$INSTDIR\folder-picker-launcher.vbs"' "$INSTDIR\claude_code.ico" 0 SW_SHOWNORMAL "" "${PRODUCT_DESCRIPTION}"

  ; Create SendTo shortcut
  CreateShortCut "$SENDTO\ClaudeCode Launchpad CLI.lnk" "$INSTDIR\claudecode-launchpad.bat" "" "$INSTDIR\claude_code.ico" 0 SW_SHOWNORMAL "" "Open with ClaudeCode Launchpad CLI"

  ; Write registry for Add/Remove Programs
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\ClaudeCodeLaunchpad" "DisplayName" "${PRODUCT_NAME}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\ClaudeCodeLaunchpad" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\ClaudeCodeLaunchpad" "Publisher" "${PRODUCT_PUBLISHER}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\ClaudeCodeLaunchpad" "UninstallString" "$INSTDIR\Uninstall.exe"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\ClaudeCodeLaunchpad" "DisplayIcon" "$INSTDIR\claude_code.ico"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\ClaudeCodeLaunchpad" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\ClaudeCodeLaunchpad" "HelpLink" "${PRODUCT_WEB_SITE}"
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\ClaudeCodeLaunchpad" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\ClaudeCodeLaunchpad" "NoRepair" 1

  ; Add right-click context menu for folders: "Open with ClaudeCode Launchpad CLI"
  WriteRegStr HKCR "Directory\shell\ClaudeCodeLaunchpad" "" "Open with ClaudeCode Launchpad CLI"
  WriteRegStr HKCR "Directory\shell\ClaudeCodeLaunchpad" "Icon" "$INSTDIR\claude_code.ico"
  WriteRegStr HKCR "Directory\shell\ClaudeCodeLaunchpad\command" "" '"$INSTDIR\claudecode-launchpad.bat" "%1"'

  ; Also add to directory background (right-click inside a folder)
  WriteRegStr HKCR "Directory\Background\shell\ClaudeCodeLaunchpad" "" "Open ClaudeCode Launchpad CLI here"
  WriteRegStr HKCR "Directory\Background\shell\ClaudeCodeLaunchpad" "Icon" "$INSTDIR\claude_code.ico"
  WriteRegStr HKCR "Directory\Background\shell\ClaudeCodeLaunchpad\command" "" '"$INSTDIR\claudecode-launchpad.bat" "%V"'

  ; Install Windows Terminal fragment
  CreateDirectory "$LOCALAPPDATA\Microsoft\Windows Terminal\Fragments\ClaudeCodeLaunchpad"
  CopyFiles /SILENT "$INSTDIR\claudecode-launchpad-wt-fragment.json" "$LOCALAPPDATA\Microsoft\Windows Terminal\Fragments\ClaudeCodeLaunchpad\claudecode-launchpad-wt-fragment.json"

  ; Apply Noam color scheme directly to WT settings (fragments alone may not apply colors)
  DetailPrint "Applying Windows Terminal color scheme..."
  nsExec::ExecToLog 'cscript //nologo "$INSTDIR\apply-wt-settings.vbs"'
  Pop $0

  ; Set CLAUDE_CODE_STATUSLINE environment variable (system-wide, persists)
  DetailPrint "Setting CLAUDE_CODE_STATUSLINE environment variable..."
  WriteRegExpandStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "CLAUDE_CODE_STATUSLINE" "$INSTDIR\statusline.mjs"
  ; Broadcast WM_SETTINGCHANGE so running processes pick it up
  SendMessage ${HWND_BROADCAST} ${WM_SETTINGCHANGE} 0 "STR:Environment" /TIMEOUT=5000

SectionEnd

Section "!Install Node.js (Required)" SecNodeJS
  SectionIn RO  ; Read-only, cannot be deselected

  DetailPrint "Checking for Node.js..."
  nsExec::ExecToStack 'where node.exe'
  Pop $0

  ${If} $0 != 0
    DetailPrint "Node.js not found - Installing..."

    ; Try bundled installer first
    SetOutPath "$INSTDIR"
    File /nonfatal "bundled\node-v24.14.0-x64.msi"

    IfFileExists "$INSTDIR\node-v24.14.0-x64.msi" 0 node_try_winget
      ; Silent install from bundled MSI
      DetailPrint "Installing Node.js v24.14.0 (this may take a few minutes)..."
      ExecWait 'msiexec /i "$INSTDIR\node-v24.14.0-x64.msi" /qn /norestart' $0
      DetailPrint "Node.js installer exit code: $0"

      ${If} $0 != 0
        MessageBox MB_OK "Node.js installation may have failed (exit code: $0).$\n$\nYou can install Node.js manually from https://nodejs.org/"
      ${EndIf}
      Goto node_verify

    node_try_winget:
      ; No bundled installer - try winget
      DetailPrint "Bundled installer not found - trying winget..."
      nsExec::ExecToStack 'where winget.exe'
      Pop $0
      ${If} $0 == 0
        DetailPrint "Installing Node.js via winget..."
        ExecWait 'cmd /c winget install OpenJS.NodeJS.LTS --accept-package-agreements --accept-source-agreements' $0
        DetailPrint "winget install Node.js exit code: $0"
      ${Else}
        MessageBox MB_OK "Node.js is required but could not be installed automatically.$\n$\nPlease install Node.js manually from https://nodejs.org/"
      ${EndIf}

    node_verify:

    ; Verify installation
    nsExec::ExecToStack 'where node.exe'
    Pop $0
    ${If} $0 == 0
      DetailPrint "Node.js installed successfully"
    ${Else}
      DetailPrint "WARNING: node.exe not found in PATH after install - may need restart"
    ${EndIf}
  ${Else}
    DetailPrint "Node.js already installed - skipping"
  ${EndIf}
SectionEnd

Section "!Install Claude Code (Required)" SecClaudeCode
  SectionIn RO  ; Read-only, cannot be deselected

  DetailPrint "Installing Claude Code..."
  DetailPrint "Running: npm install -g @anthropic-ai/claude-code"

  ; Use ExecWait so user sees progress in a console window
  ExecWait 'cmd /c npm install -g @anthropic-ai/claude-code' $0
  DetailPrint "npm install exit code: $0"

  ${If} $0 != 0
    DetailPrint "WARNING: Claude Code installation may have failed"
    MessageBox MB_OK "Claude Code installation may have failed.$\n$\nYou can install it manually by running:$\nnpm install -g @anthropic-ai/claude-code"
  ${Else}
    DetailPrint "Claude Code installed successfully"
  ${EndIf}

  ; Verify
  nsExec::ExecToStack 'where claude.cmd'
  Pop $0
  ${If} $0 == 0
    DetailPrint "Claude Code verified: claude command found"
  ${Else}
    nsExec::ExecToStack 'where claude'
    Pop $0
    ${If} $0 == 0
      DetailPrint "Claude Code verified: claude command found"
    ${Else}
      DetailPrint "WARNING: claude command not found in PATH - may need restart"
    ${EndIf}
  ${EndIf}

  ; Configure statusline in Claude Code settings.json
  DetailPrint "Configuring Claude Code statusline..."
  nsExec::ExecToLog 'node "$INSTDIR\configure-statusline.js" "$INSTDIR\statusline.mjs"'
  Pop $0
  ${If} $0 == 0
    DetailPrint "Statusline configured in Claude Code settings"
  ${Else}
    DetailPrint "WARNING: Could not configure statusline in settings (exit code: $0)"
  ${EndIf}
SectionEnd

Section "Install Windows Terminal (Recommended)" SecWindowsTerminal
  DetailPrint "Checking for Windows Terminal..."
  nsExec::ExecToStack 'where wt.exe'
  Pop $0

  ${If} $0 != 0
    DetailPrint "Windows Terminal not found - attempting to install via winget..."

    ; Check if winget exists
    nsExec::ExecToStack 'where winget.exe'
    Pop $0

    ${If} $0 == 0
      DetailPrint "Installing Windows Terminal via winget..."
      ExecWait 'cmd /c winget install Microsoft.WindowsTerminal --accept-package-agreements --accept-source-agreements' $0
      DetailPrint "winget install exit code: $0"

      ${If} $0 != 0
        DetailPrint "winget install failed - recommending manual install"
        MessageBox MB_OK "Could not install Windows Terminal automatically.$\n$\nPlease install it from the Microsoft Store:$\nSearch for 'Windows Terminal'$\n$\nClaudeCode Launchpad CLI will fall back to cmd.exe until Windows Terminal is installed."
      ${Else}
        DetailPrint "Windows Terminal installed successfully"
      ${EndIf}
    ${Else}
      DetailPrint "winget not available - recommending manual install"
      MessageBox MB_OK "Could not install Windows Terminal automatically (winget not available).$\n$\nPlease install it from the Microsoft Store:$\nSearch for 'Windows Terminal'$\n$\nClaudeCode Launchpad CLI will fall back to cmd.exe until Windows Terminal is installed."
    ${EndIf}
  ${Else}
    DetailPrint "Windows Terminal already installed - skipping"
  ${EndIf}
SectionEnd

Section "Install Git (Optional)" SecGit
  DetailPrint "Checking for Git..."
  nsExec::ExecToStack 'where git.exe'
  Pop $0

  ${If} $0 != 0
    DetailPrint "Git not found - Installing..."

    ; Try bundled installer first
    SetOutPath "$INSTDIR"
    File /nonfatal "bundled\Git-2.53.0-64-bit.exe"

    IfFileExists "$INSTDIR\Git-2.53.0-64-bit.exe" 0 git_try_winget
      DetailPrint "Installing Git for Windows (this may take a few minutes)..."
      ExecWait '"$INSTDIR\Git-2.53.0-64-bit.exe" /VERYSILENT /NORESTART /NOCANCEL /SP- /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /COMPONENTS="icons,ext\reg\shellhere,assoc,assoc_sh"'
      DetailPrint "Git installed successfully"
      Goto git_done

    git_try_winget:
      ; No bundled installer - try winget
      DetailPrint "Bundled installer not found - trying winget..."
      nsExec::ExecToStack 'where winget.exe'
      Pop $0
      ${If} $0 == 0
        DetailPrint "Installing Git via winget..."
        ExecWait 'cmd /c winget install Git.Git --accept-package-agreements --accept-source-agreements' $0
        DetailPrint "winget install Git exit code: $0"
      ${Else}
        DetailPrint "Git not installed - winget not available. Install manually from https://git-scm.com/"
      ${EndIf}

    git_done:
  ${Else}
    DetailPrint "Git already installed - skipping"
  ${EndIf}
SectionEnd

; Section descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecCore} "Core files: launcher scripts, shortcuts, configuration, and Windows Terminal profile."
  !insertmacro MUI_DESCRIPTION_TEXT ${SecNodeJS} "Node.js runtime (required for Claude Code). Skipped if already installed."
  !insertmacro MUI_DESCRIPTION_TEXT ${SecClaudeCode} "Claude Code CLI tool (installed via npm)."
  !insertmacro MUI_DESCRIPTION_TEXT ${SecWindowsTerminal} "Windows Terminal with light blue color scheme. Falls back to cmd.exe if not installed."
  !insertmacro MUI_DESCRIPTION_TEXT ${SecGit} "Git version control (optional, for development workflows)."
!insertmacro MUI_FUNCTION_DESCRIPTION_END

; Desktop shortcut creation function (called from finish page)
Function CreateDesktopShortcut
  Delete "$DESKTOP\Kivun Terminal.lnk"
  CreateShortCut "$DESKTOP\ClaudeCode Launchpad CLI.lnk" "wscript.exe" '"$INSTDIR\folder-picker-launcher.vbs"' "$INSTDIR\claude_code.ico" 0 SW_SHOWNORMAL "" "${PRODUCT_DESCRIPTION}"
FunctionEnd

; Uninstaller
Section "Uninstall"
  ; Remove install directory
  RMDir /r "$INSTDIR"

  ; Remove Start Menu shortcuts
  RMDir /r "$SMPROGRAMS\${PRODUCT_NAME}"

  ; Remove Desktop shortcut (both old and new names)
  Delete "$DESKTOP\Kivun Terminal.lnk"
  Delete "$DESKTOP\ClaudeCode Launchpad CLI.lnk"

  ; Remove SendTo shortcut (both old and new names)
  Delete "$SENDTO\Kivun Terminal.lnk"
  Delete "$SENDTO\ClaudeCode Launchpad CLI.lnk"

  ; Remove old Start Menu folder
  RMDir /r "$SMPROGRAMS\Kivun Terminal"

  ; Remove old registry entries
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Kivun"
  DeleteRegKey HKCR "Directory\shell\KivunTerminal"
  DeleteRegKey HKCR "Directory\Background\shell\KivunTerminal"
  RMDir /r "$LOCALAPPDATA\Microsoft\Windows Terminal\Fragments\KivunTerminal"

  ; Remove registry entries - Add/Remove Programs
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\ClaudeCodeLaunchpad"

  ; Remove context menu entries
  DeleteRegKey HKCR "Directory\shell\ClaudeCodeLaunchpad"
  DeleteRegKey HKCR "Directory\Background\shell\ClaudeCodeLaunchpad"

  ; Remove Windows Terminal fragment
  RMDir /r "$LOCALAPPDATA\Microsoft\Windows Terminal\Fragments\ClaudeCodeLaunchpad"

  ; Remove CLAUDE_CODE_STATUSLINE environment variable
  DeleteRegValue HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "CLAUDE_CODE_STATUSLINE"
  SendMessage ${HWND_BROADCAST} ${WM_SETTINGCHANGE} 0 "STR:Environment" /TIMEOUT=5000

SectionEnd
