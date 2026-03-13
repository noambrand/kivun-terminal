' Kivun Terminal - Apply Windows Terminal color scheme
' Closes WT first (it overwrites settings while running), then adds Noam scheme

Set fso = CreateObject("Scripting.FileSystemObject")
Set wshShell = CreateObject("WScript.Shell")

settingsPath = wshShell.ExpandEnvironmentStrings("%LOCALAPPDATA%") & _
    "\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

If Not fso.FileExists(settingsPath) Then
    WScript.Echo "Windows Terminal settings not found"
    WScript.Quit 0
End If

' Close Windows Terminal so it doesn't overwrite our changes
wshShell.Run "taskkill /f /im WindowsTerminal.exe", 0, True
WScript.Sleep 1000

' Read file
Set f = fso.OpenTextFile(settingsPath, 1, False, 0)
content = f.ReadAll
f.Close

changed = False

' --- 1. Add Noam color scheme if missing ---
If InStr(content, """name"": ""Noam""") = 0 And InStr(content, """name"":""Noam""") = 0 Then
    noamScheme = "        {" & vbCrLf & _
        "            ""name"": ""Noam""," & vbCrLf & _
        "            ""background"": ""#C8E6FF""," & vbCrLf & _
        "            ""foreground"": ""#0C0C0C""," & vbCrLf & _
        "            ""cursorColor"": ""#0050C8""," & vbCrLf & _
        "            ""selectionBackground"": ""#32FFF1""," & vbCrLf & _
        "            ""black"": ""#0C0C0C""," & vbCrLf & _
        "            ""red"": ""#C50F1F""," & vbCrLf & _
        "            ""green"": ""#13A10E""," & vbCrLf & _
        "            ""yellow"": ""#C19C00""," & vbCrLf & _
        "            ""blue"": ""#0000A0""," & vbCrLf & _
        "            ""purple"": ""#881798""," & vbCrLf & _
        "            ""cyan"": ""#005AA0""," & vbCrLf & _
        "            ""white"": ""#CCCCCC""," & vbCrLf & _
        "            ""brightBlack"": ""#000000""," & vbCrLf & _
        "            ""brightRed"": ""#FF1328""," & vbCrLf & _
        "            ""brightGreen"": ""#0F800B""," & vbCrLf & _
        "            ""brightYellow"": ""#AB8A00""," & vbCrLf & _
        "            ""brightBlue"": ""#000078""," & vbCrLf & _
        "            ""brightPurple"": ""#691275""," & vbCrLf & _
        "            ""brightCyan"": ""#003C8C""," & vbCrLf & _
        "            ""brightWhite"": ""#5E5E5E""" & vbCrLf & _
        "        }"

    ' Replace empty schemes array
    content = Replace(content, """schemes"": []", """schemes"": [" & vbCrLf & noamScheme & vbCrLf & "    ]")
    If InStr(content, """name"": ""Noam""") > 0 Then
        changed = True
        WScript.Echo "Added Noam color scheme"
    End If
End If

' --- 2. Add colorScheme to Kivun Terminal profile if missing ---
pos = InStr(content, """Kivun Terminal""")
If pos > 0 Then
    profileStart = 0
    For i = pos To 1 Step -1
        If Mid(content, i, 1) = "{" Then
            profileStart = i
            Exit For
        End If
    Next

    If profileStart > 0 Then
        braceCount = 0
        profileEnd = 0
        For i = profileStart To Len(content)
            ch = Mid(content, i, 1)
            If ch = "{" Then braceCount = braceCount + 1
            If ch = "}" Then braceCount = braceCount - 1
            If braceCount = 0 Then
                profileEnd = i
                Exit For
            End If
        Next

        If profileEnd > 0 Then
            profileText = Mid(content, profileStart, profileEnd - profileStart + 1)
            If InStr(profileText, """colorScheme""") = 0 Then
                ' Find the first newline after the opening brace so we insert
                ' between lines instead of splitting an existing value.
                nlPos = InStr(profileStart, content, vbLf)
                If nlPos = 0 Then nlPos = profileStart  ' fallback

                insertion = "                ""colorScheme"": ""Noam""," & vbCrLf & _
                    "                ""cursorShape"": ""bar""," & vbCrLf & _
                    "                ""font"": { ""face"": ""Cascadia Mono"", ""size"": 11 }," & vbCrLf & _
                    "                ""scrollbarState"": ""visible""," & vbCrLf & _
                    "                ""tabTitle"": ""Kivun Terminal""," & vbCrLf
                content = Left(content, nlPos) & insertion & Mid(content, nlPos + 1)
                changed = True
                WScript.Echo "Updated Kivun Terminal profile"
            End If
        End If
    End If
End If

' Write as plain ASCII (no BOM issues)
If changed Then
    Set f = fso.CreateTextFile(settingsPath, True, False)
    f.Write content
    f.Close
    WScript.Echo "Settings saved"
Else
    WScript.Echo "No changes needed"
End If
