@echo off
echo Testing WSL path...
set WSL="%SystemRoot%\System32\wsl.exe"
echo WSL variable: %WSL%
%WSL% --version
pause
