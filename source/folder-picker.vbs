Set objShell = CreateObject("Shell.Application")
Set wshShell = CreateObject("WScript.Shell")
startPath = wshShell.ExpandEnvironmentStrings("%USERPROFILE%")
Set objFolder = objShell.BrowseForFolder(0, "Select folder for Kivun Terminal", 0, startPath)

If objFolder Is Nothing Then
    WScript.Echo "CANCELLED"
Else
    WScript.Echo objFolder.Self.Path
End If
