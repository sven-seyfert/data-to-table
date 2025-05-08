;~ v0.3.1 by ioa747

#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y

#include "..\lib\StringToTable.au3"

Example1() ; Example string to table
Example2() ; Example array to table

;---------------------------------------------------------------------------------------
Func Example1() ; Example string to table
    Local $sTxt, $sOut
    Local $sData = _
            "Company" & @TAB & "Contact" & @TAB & "Revenue" & @CRLF & _
            "Alfreds Futterkiste" & @TAB & "Maria Anders" & @TAB & "1200" & @CRLF & _
            "Centro Moctezuma" & @TAB & "Francisco Chang" & @TAB & "950" & @CRLF & _
            "Island Trading" & @TAB & "Helen Bennett" & @TAB & "15800"

    $sOut = _StringToTable($sData, 3, @TAB, "L,C,R")
    ConsoleWrite($sOut & @CRLF & @CRLF)
    $sTxt &= $sOut & @CRLF & @CRLF

    $sOut = _StringToTable($sData, 0, @TAB, "L,C,R")
    ConsoleWrite($sOut & @CRLF & @CRLF)
    $sTxt &= $sOut & @CRLF & @CRLF

    $sOut = " https://www.autoitscript.com/forum/topic/212833-json-udf-using-json-c/#findComment-1542670"
    ConsoleWrite($sOut & @CRLF)
    $sTxt &= $sOut & @CRLF

    $sData = "" ; from https://www.autoitscript.com/forum/topic/212833-json-udf-using-json-c/#findComment-1542670
    $sData &= " name                 | time[ms] | factor | Std. Dev | Std. Err. | min    | max     | range  |" & @CRLF
    $sData &= " StringRegExp only    | 1.691    | 1      | 0.351    | 0.035     | 1.304  | 3.167   | 1.863  |" & @CRLF
    $sData &= " jq UDF               | 32.933   | 19.48  | 2.929    | 0.293     | 29.308 | 43.169  | 13.861 |" & @CRLF
    $sData &= " JsonC-UDF            | 51.086   | 30.21  | 3.205    | 0.321     | 45.625 | 63.46   | 17.835 |" & @CRLF
    $sData &= " pure AutoIt JSON-UDF | 97.916   | 57.9   | 5.685    | 0.569     | 86.362 | 113.467 | 27.105 |" & @CRLF
    $sData &= " JSMN-based JSON-UDF  | 108.248  | 64.01  | 5.512    | 0.551     | 99.029 | 130.864 | 31.835 |" & @CRLF

    $sOut = _StringToTable($sData, 3, "|", "L,R,R,R,R,R,R,R")
    ConsoleWrite($sOut & @CRLF & @CRLF)
    $sTxt &= $sOut & @CRLF & @CRLF

    ClipPut($sTxt)
    ShellExecute("notepad.exe")
    WinWaitActive("[CLASS:Notepad]", "", 5)
    Sleep(100)
    Send("^v")
EndFunc   ;==>Example1
;---------------------------------------------------------------------------------------
Func Example2() ; Example array to table

    ; Make example array
    Local $aArray[10][5]
    For $i = 0 To 9
        For $j = 0 To 4
            $aArray[$i][$j] = $i & "-" & $j
        Next
    Next
    ;_ArrayDisplay($aArray, "example array")

    ; Make header and insert to array (when needed)
    Local $sHeader = "Column 0|Column 1|Column 2|Column 3|Column 4"
    _ArrayInsert($aArray, 0, $sHeader)
    If @error Then Exit MsgBox(16, "@error: " & @error, "Something went wrong with _ArrayInsert()")

    Local $sOut = _StringToTable($aArray, 3, @TAB, "C,C,C,C,C")
    ConsoleWrite($sOut & @CRLF & @CRLF)

    ClipPut($sOut)
    ShellExecute("notepad.exe")
    WinWaitActive("[CLASS:Notepad]", "", 5)
    Sleep(100)
    Send("^v")

EndFunc   ;==>Example2
;---------------------------------------------------------------------------------------
