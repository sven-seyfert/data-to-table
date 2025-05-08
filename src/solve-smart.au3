;~ v0.2.0 by Sven Seyfert (SOLVE-SMART)

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
    $sOut &= StringFormat('==> Border style 3:\n\n%s', $sResult)

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
    $sOut &= StringFormat('==> Border style: "0=NoBorder"\n\n%s', $sResult)

    $sResult = _DataToTable($aData, 1, @TAB, 'L, R, C, L')
    If @error Then
        _ShowError()
    EndIf
    $sOut &= StringFormat('\n==> Border style: "1=HeaderNoBorder"\n\n%s', $sResult)

    $sResult = _DataToTable($aData, 2, @TAB, 'L, R, C, L')
    If @error Then
        _ShowError()
    EndIf
    $sOut &= StringFormat('\n==> Border style: "2=BorderNoHeader"\n\n%s', $sResult)

    $sResult = _DataToTable($aData, 3, @TAB, 'L, R, C, L')
    If @error Then
        _ShowError()
    EndIf
    $sOut &= StringFormat('\n==> Border style: "3=BorderAndHeader"\n\n%s', $sResult)

    $sResult = _DataToTable($aData, 4, @TAB, 'L, R, C, L')
    If @error Then
        _ShowError()
    EndIf
    $sOut &= StringFormat('\n==> Border style: "4=BorderAndHeaderEdgesWithAccent"\n\n%s', $sResult)

    ; other tests
    $sOut &= StringFormat('\n%s\n\nother tests:\n', _StringRepeat('-', 80))

    $sResult = _DataToTable($aData, 'bla', @TAB, 'L, R, C, L')
    If @error Then
        _ShowError()
    EndIf
    $sOut &= StringFormat('\n==> With invalid border style (back to default):\n\n%s', $sResult)

    $sResult = _DataToTable($aData, 1, ',', 'L, R, C, L')
    If @error Then
        _ShowError()
    EndIf
    $sOut &= StringFormat('\n==> With "," as separator (loose data because comma separated content):\n\n%s', $sResult)

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
