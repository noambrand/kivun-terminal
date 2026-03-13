' Create shortcut helper
' Usage: cscript create-shortcut.vbs "shortcut_path" "target_path" "icon_path" "description" "working_directory"

Set objArgs = WScript.Arguments
If objArgs.Count < 4 Then
    WScript.Echo "Usage: create-shortcut.vbs shortcut_path target_path icon_path description [working_directory]"
    WScript.Quit 1
End If

shortcutPath = objArgs(0)
targetPath = objArgs(1)
iconPath = objArgs(2)
description = objArgs(3)

' Extract working directory from target path if not provided
Set fso = CreateObject("Scripting.FileSystemObject")
If objArgs.Count >= 5 Then
    workingDir = objArgs(4)
Else
    workingDir = fso.GetParentFolderName(targetPath)
End If

Set WshShell = WScript.CreateObject("WScript.Shell")
Set shortcut = WshShell.CreateShortcut(shortcutPath)
shortcut.TargetPath = targetPath
shortcut.WorkingDirectory = workingDir
shortcut.IconLocation = iconPath
shortcut.Description = description
shortcut.Save

WScript.Echo "Created: " & shortcutPath
