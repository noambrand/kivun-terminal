' write-path.vbs - Writes a path to kivun-workdir.txt as UTF-8
' Called by bat launchers to preserve Hebrew/Unicode folder names
' Usage: cscript //nologo write-path.vbs "C:\path\to\folder"

Set wshShell = CreateObject("WScript.Shell")
Dim filePath
filePath = wshShell.ExpandEnvironmentStrings("%LOCALAPPDATA%") & "\Kivun\kivun-workdir.txt"

Dim stream
Set stream = CreateObject("ADODB.Stream")
stream.Type = 2
stream.Charset = "utf-8"
stream.Open
stream.WriteText WScript.Arguments(0)

' Save without BOM: copy to binary stream skipping first 3 bytes
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
