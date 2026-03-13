' Kivun Terminal - Folder Picker & Launcher
' Shows folder picker dialog (browse or paste), then launches Kivun Terminal.
' No intermediate cmd window is displayed.

Set wshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' Determine script directory
scriptDir = fso.GetParentFolderName(WScript.ScriptFullName)

' Ask user: browse or paste?
Dim choice
choice = MsgBox("Click YES to browse for a folder." & vbCrLf & vbCrLf & _
                "Click NO to type or paste a folder path.", _
                vbYesNoCancel + vbQuestion, "Kivun Terminal - Choose Folder")

If choice = vbCancel Then
    WScript.Quit
End If

Dim selectedPath

If choice = vbNo Then
    ' Paste mode
    Dim pastedPath
    pastedPath = InputBox("Type or paste the full folder path:", _
                          "Kivun Terminal - Folder Path")

    If pastedPath = "" Then
        WScript.Quit
    End If

    If Not fso.FolderExists(pastedPath) Then
        MsgBox "Folder not found:" & vbCrLf & pastedPath, vbExclamation, "Kivun Terminal"
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
        WScript.Quit
    End If

    selectedPath = objFolder.Self.Path
End If

' Write selected path to file (UTF-8 without BOM)
Dim kivunDir, filePath
kivunDir = wshShell.ExpandEnvironmentStrings("%LOCALAPPDATA%") & "\Kivun"
filePath = kivunDir & "\kivun-workdir.txt"

If Not fso.FolderExists(kivunDir) Then
    fso.CreateFolder kivunDir
End If

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

' Launch kivun-terminal.bat with READFILE argument
' Window style 0 = hidden cmd window (WT opens its own visible window)
wshShell.Run """" & scriptDir & "\kivun-terminal.bat"" ""READFILE""", 0, False
