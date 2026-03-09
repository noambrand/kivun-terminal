' Check shortcut target
Set objArgs = WScript.Arguments
If objArgs.Count < 1 Then
    WScript.Echo "Usage: cscript check-shortcut.vbs shortcut_path"
    WScript.Quit 1
End If

shortcutPath = objArgs(0)

Set WshShell = WScript.CreateObject("WScript.Shell")
Set shortcut = WshShell.CreateShortcut(shortcutPath)

WScript.Echo "Shortcut: " & shortcutPath
WScript.Echo "Target: " & shortcut.TargetPath
WScript.Echo "Arguments: " & shortcut.Arguments
WScript.Echo "WorkingDirectory: " & shortcut.WorkingDirectory
WScript.Echo "Icon: " & shortcut.IconLocation
