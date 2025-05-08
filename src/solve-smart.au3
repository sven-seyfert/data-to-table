;~ v0.1.0 by Sven Seyfert (SOLVE-SMART)

#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y

#include-once
#include "../lib/DataToTable.au3"

_Main()

Func _Main()
    _DemoStringDataToTable()
    _DemoArrayDataToTable()
EndFunc

Func _DemoStringDataToTable()
    Local Const $sData = _
        'Language	Popularity (%)	Job Demand	Typical Use' & @CRLF & _
        'JavaScript	62.3	Very High	Web Development, Frontend/Backend' & @CRLF & _
        'C#	27.1	High	Game Development, Windows Apps, Web Dev' & @CRLF & _
        'Go	13.8	Growing	Cloud Services, System Programming' & @CRLF & _
        'PowerShell	13.5	Low to Moderate	Task Automation, DevOps, System Admin' & @CRLF & _
        'AutoIt	0.5	Low	Windows GUI Automation, Scripting'

    Local $sResult, $sOut

    $sResult = _DataToTable($sData, 3, @TAB, 'L, R, C, L')
    If @error Then
        _ShowError()
    EndIf
    $sOut &= '==> Border style 3:' & @CRLF & $sResult

    _ShowResult($sOut)
EndFunc

Func _DemoArrayDataToTable()
    Local Const $aData[][5] = _
        [ _
            ['Language',    'Popularity (%)', 'Job Demand',      'Typical Use'                             ], _
            ['JavaScript',  '62.3',           'Very High',       'Web Development, Frontend/Backend'       ], _
            ['C#',          '27.1',           'High',            'Game Development, Windows Apps, Web Dev' ], _
            ['Go',          '13.8',           'Growing',         'Cloud Services, System Programming'      ], _
            ['PowerShell',  '13.5',           'Low to Moderate', 'Task Automation, DevOps, System Admin'   ], _
            ['AutoIt',      '0.5',            'Low',             'Windows GUI Automation, Scripting'       ] _
        ]

    Local $sResult, $sOut

    $sResult = _DataToTable($aData, 0, @TAB, 'L, R, C, L')
    If @error Then
        _ShowError()
    EndIf
    $sOut &= '==> Border style 0:' & @CRLF & $sResult

    $sResult = _DataToTable($aData, 1, @TAB, 'L, R, C, L')
    If @error Then
        _ShowError()
    EndIf
    $sOut &= '==> Border style 1:' & @CRLF & $sResult

    $sResult = _DataToTable($aData, 2, @TAB, 'L, R, C, L')
    If @error Then
        _ShowError()
    EndIf
    $sOut &= '==> Border style 2:' & @CRLF & $sResult

    $sResult = _DataToTable($aData, 3, @TAB, 'L, R, C, L')
    If @error Then
        _ShowError()
    EndIf
    $sOut &= '==> Border style 3:' & @CRLF & $sResult

    $sResult = _DataToTable($aData, 'bla', @TAB, 'L, R, C, L')
    If @error Then
        _ShowError()
    EndIf
    $sOut &= '==> With invalid border style (back to default):' & @CRLF & $sResult

    $sResult = _DataToTable($aData, 1, ',', 'L, R, C, L')
    If @error Then
        _ShowError()
    EndIf
    $sOut &= '==> With different separator (loose data because comma separated):' & @CRLF & $sResult

    _ShowResult($sOut)
EndFunc

Func _ShowError($sMessage = 'at _DataToTable()')
    ConsoleWrite(StringFormat('  %s\n', $sMessage))
    Exit -1
EndFunc

Func _ShowResult($sOut)
    ConsoleWrite($sOut)

    ClipPut($sOut)
    ShellExecute('notepad.exe')
    WinWaitActive('[CLASS:Notepad]', '', 5)
    Sleep(100)
    Send('^v')
EndFunc
