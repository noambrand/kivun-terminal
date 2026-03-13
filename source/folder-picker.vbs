Set wshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' Ask user: browse or paste?
Dim choice
choice = MsgBox("Click YES to browse for a folder." & vbCrLf & vbCrLf & _
                "Click NO to type or paste a folder path.", _
                vbYesNoCancel + vbQuestion, "Kivun Terminal - Choose Folder")

If choice = vbCancel Then
    WScript.Echo "CANCELLED"
    WScript.Quit
End If

Dim selectedPath

If choice = vbNo Then
    ' Paste mode
    Dim pastedPath
    pastedPath = InputBox("Type or paste the full folder path:", _
                          "Kivun Terminal - Folder Path")

    If pastedPath = "" Then
        WScript.Echo "CANCELLED"
        WScript.Quit
    End If

    If Not fso.FolderExists(pastedPath) Then
        MsgBox "Folder not found:" & vbCrLf & pastedPath, vbExclamation, "Kivun Terminal"
        WScript.Echo "CANCELLED"
        WScript.Quit
    End If

    selectedPath = pastedPath
Else
    ' Browse mode
    Set objShell = CreateObject("Shell.Application")
    Dim startPath
    startPath = wshShell.ExpandEnvironmentStrings("%USERPROFILE%")
    Set objFolder = objShell.BrowseForFolder(0, "Select folder for Kivun Terminal", 0, startPath)

    If objFolder Is Nothing Then
        WScript.Echo "CANCELLED"
        WScript.Quit
    End If

    selectedPath = objFolder.Self.Path
End If

' Write path to file as UTF-8 without BOM (avoids cmd.exe Unicode corruption)
Dim filePath
filePath = wshShell.ExpandEnvironmentStrings("%LOCALAPPDATA%") & "\Kivun\kivun-workdir.txt"

Dim stream
Set stream = CreateObject("ADODB.Stream")
stream.Type = 2
stream.Charset = "utf-8"
stream.Open
stream.WriteText selectedPath

' Strip the 3-byte UTF-8 BOM before saving
stream.Position = 0
stream.Type = 1
stream.Position = 3

Dim outStream
Set outStream = CreateObject("ADODB.Stream")
outStream.Type = 1
outStream.Open
stream.CopyTo outStream
outStream.SaveToFile filePath, 2
outStream.Close
stream.Close

' Echo ASCII-only marker for the bat to capture
WScript.Echo "OK"
