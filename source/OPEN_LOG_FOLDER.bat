@echo off
title Opening Kivun Terminal Log Folder
echo Opening log folder: %LOCALAPPDATA%\Kivun
echo.
echo This folder contains:
echo   - LAUNCH_LOG.txt (Windows launcher log)
echo   - BASH_LAUNCH_LOG.txt (Bash script log)
echo   - All Kivun Terminal files
echo.
explorer "%LOCALAPPDATA%\Kivun"
