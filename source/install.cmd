@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

REM ============================================
REM   ClaudeCode Launchpad CLI - Dependency Installer
REM   Uses curl.exe (built-in Windows 10 1803+)
REM   Falls back to winget if curl unavailable
REM ============================================

REM --- Version Pins (update these for new releases) ---
set "NODE_VERSION=22.15.0"
set "NODE_URL=https://nodejs.org/dist/v%NODE_VERSION%/node-v%NODE_VERSION%-x64.msi"
set "GIT_VERSION=2.49.0"
set "GIT_URL=https://github.com/git-for-windows/git/releases/download/v%GIT_VERSION%.windows.1/Git-%GIT_VERSION%-64-bit.exe"
set "TEMP_DIR=%TEMP%\ClaudeCodeSetup"
set "EXIT_CODE=0"

REM --- Parse Arguments ---
set "DO_NODE=0"
set "DO_GIT=0"
set "DO_CLAUDE=0"
set "DO_WT=0"

:parse_args
if "%~1"=="" goto :args_done
if /i "%~1"=="/node"   set "DO_NODE=1"
if /i "%~1"=="/git"    set "DO_GIT=1"
if /i "%~1"=="/claude" set "DO_CLAUDE=1"
if /i "%~1"=="/wt"     set "DO_WT=1"
if /i "%~1"=="/all"    set "DO_NODE=1" & set "DO_GIT=1" & set "DO_CLAUDE=1" & set "DO_WT=1"
shift
goto :parse_args
:args_done

REM --- Check for curl.exe ---
set "USE_CURL=0"
where curl.exe >nul 2>&1 && set "USE_CURL=1"

if "!USE_CURL!"=="0" (
    echo [INFO] curl.exe not found. Will use winget as fallback.
)

REM --- Create temp directory ---
mkdir "%TEMP_DIR%" 2>nul

REM ====== NODE.JS ======
if "!DO_NODE!"=="1" (
    where node.exe >nul 2>&1
    if not errorlevel 1 (
        echo [SKIP] Node.js already installed.
        goto :node_done
    )

    if "!USE_CURL!"=="1" (
        echo [DOWNLOAD] Node.js v%NODE_VERSION%...
        curl.exe -L -o "%TEMP_DIR%\node-setup.msi" "%NODE_URL%" --progress-bar
        if errorlevel 1 (
            echo [WARN] curl download failed. Trying winget...
            goto :node_winget
        )
        echo [INSTALL] Node.js v%NODE_VERSION% ^(silent^)...
        msiexec /i "%TEMP_DIR%\node-setup.msi" /qn /norestart
        if errorlevel 1 (
            echo [ERROR] Node.js MSI install failed.
            set "EXIT_CODE=1"
            goto :cleanup
        )
        call :refresh_path
        goto :node_verify
    )

    :node_winget
    where winget.exe >nul 2>&1
    if errorlevel 1 (
        echo [ERROR] Neither curl nor winget available. Cannot install Node.js.
        echo         Install manually from https://nodejs.org/
        set "EXIT_CODE=10"
        goto :cleanup
    )
    echo [INSTALL] Node.js via winget...
    cmd /c winget install OpenJS.NodeJS.LTS --accept-package-agreements --accept-source-agreements
    call :refresh_path

    :node_verify
    where node.exe >nul 2>&1
    if errorlevel 1 (
        echo [WARN] node.exe not found in PATH after install. May need restart.
    ) else (
        echo [OK] Node.js installed.
    )
    :node_done
)

REM ====== GIT ======
if "!DO_GIT!"=="1" (
    where git.exe >nul 2>&1
    if not errorlevel 1 (
        echo [SKIP] Git already installed.
        goto :git_done
    )

    if "!USE_CURL!"=="1" (
        echo [DOWNLOAD] Git v%GIT_VERSION%...
        curl.exe -L -o "%TEMP_DIR%\git-setup.exe" "%GIT_URL%" --progress-bar
        if errorlevel 1 (
            echo [WARN] curl download failed. Trying winget...
            goto :git_winget
        )
        echo [INSTALL] Git v%GIT_VERSION% ^(silent^)...
        "%TEMP_DIR%\git-setup.exe" /VERYSILENT /NORESTART /NOCANCEL /SP- /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /COMPONENTS="icons,ext\reg\shellhere,assoc,assoc_sh"
        if errorlevel 1 (
            echo [ERROR] Git installer failed.
            set "EXIT_CODE=2"
            goto :cleanup
        )
        call :refresh_path
        goto :git_verify
    )

    :git_winget
    where winget.exe >nul 2>&1
    if errorlevel 1 (
        echo [ERROR] Neither curl nor winget available. Cannot install Git.
        echo         Install manually from https://git-scm.com/
        set "EXIT_CODE=10"
        goto :cleanup
    )
    echo [INSTALL] Git via winget...
    cmd /c winget install Git.Git --accept-package-agreements --accept-source-agreements
    call :refresh_path

    :git_verify
    where git.exe >nul 2>&1
    if errorlevel 1 (
        echo [WARN] git.exe not found in PATH after install. May need restart.
    ) else (
        echo [OK] Git installed.
    )
    :git_done
)

REM ====== CLAUDE CODE ======
if "!DO_CLAUDE!"=="1" (
    call :refresh_path

    where npm.cmd >nul 2>&1
    if errorlevel 1 (
        echo [ERROR] npm not found. Node.js may not be installed correctly.
        set "EXIT_CODE=3"
        goto :cleanup
    )

    where claude.cmd >nul 2>&1 && (
        echo [SKIP] Claude Code already installed.
        goto :claude_done
    )
    where claude >nul 2>&1 && (
        echo [SKIP] Claude Code already installed.
        goto :claude_done
    )

    echo [INSTALL] Claude Code via npm...
    cmd /c npm install -g @anthropic-ai/claude-code
    if errorlevel 1 (
        echo [ERROR] npm install failed.
        set "EXIT_CODE=3"
        goto :cleanup
    )
    call :refresh_path
    echo [OK] Claude Code installed.
    :claude_done
)

REM ====== WINDOWS TERMINAL ======
if "!DO_WT!"=="1" (
    where wt.exe >nul 2>&1
    if not errorlevel 1 (
        echo [SKIP] Windows Terminal already installed.
        goto :wt_done
    )

    REM WT is an MSIX/Store package — winget is the only automated method
    where winget.exe >nul 2>&1
    if errorlevel 1 (
        echo [WARN] winget not available. Install Windows Terminal from the Microsoft Store.
        set "EXIT_CODE=4"
        goto :wt_done
    )
    echo [INSTALL] Windows Terminal via winget...
    cmd /c winget install Microsoft.WindowsTerminal --accept-package-agreements --accept-source-agreements
    if errorlevel 1 (
        echo [WARN] winget install failed. Install Windows Terminal from the Microsoft Store.
        set "EXIT_CODE=4"
    ) else (
        echo [OK] Windows Terminal installed.
    )
    :wt_done
)

:cleanup
rmdir /s /q "%TEMP_DIR%" 2>nul
exit /b %EXIT_CODE%

REM ============================================
REM   Refresh PATH from registry (picks up
REM   changes made by MSI/EXE installers)
REM ============================================
:refresh_path
set "SYS_PATH="
set "USR_PATH="
for /f "tokens=2*" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path 2^>nul') do set "SYS_PATH=%%B"
for /f "tokens=2*" %%A in ('reg query "HKCU\Environment" /v Path 2^>nul') do set "USR_PATH=%%B"
if defined SYS_PATH if defined USR_PATH set "PATH=!SYS_PATH!;!USR_PATH!"
goto :eof
