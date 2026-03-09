Set objShell = CreateObject("Shell.Application")
Set objFolder = objShell.BrowseForFolder(0, "Select folder for Kivun Terminal", 0, "C:\Users\noam.ORHITEC")

If objFolder Is Nothing Then
    WScript.Echo "CANCELLED"
Else
    WScript.Echo objFolder.Self.Path
End If
