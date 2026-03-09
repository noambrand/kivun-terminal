========================================
KIVUN TERMINAL - REPAIR PACKAGE
========================================

This package fixes the issues found on the other PC:

ISSUES FIXED:
1. Missing ClaudeHebrew.profile
2. Missing ColorSchemeNoam.colorscheme
3. Duplicate USE_VCXSRV in config.txt

========================================
HOW TO USE:
========================================

1. Copy this entire REPAIR_PACKAGE folder to the other PC
   (e.g., via USB drive, network share, etc.)

2. On the other PC, double-click: REPAIR.bat

3. The script will copy the missing files to:
   C:\Users\[Username]\AppData\Local\Kivun\

4. Try the launcher again - it should work now!

========================================
WHAT'S IN THIS PACKAGE:
========================================

- REPAIR.bat                    (Repair script)
- ClaudeHebrew.profile          (Konsole terminal profile)
- ColorSchemeNoam.colorscheme   (Light blue color scheme)
- config.txt                    (Fixed configuration)
- README.txt                    (This file)

========================================
IF IT STILL DOESN'T WORK:
========================================

Try running manually:
1. Open Command Prompt
2. cd %LOCALAPPDATA%\Kivun
3. kivun-terminal.bat

This will show detailed error messages.

========================================
