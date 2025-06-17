#pragma compile(FileVersion, 0.5.0)
#pragma compile(LegalCopyright, © Sven Seyfert (SOLVE-SMART))
#pragma compile(ProductVersion, 0.5.0 - 2025-05-10)

#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
;~ #AutoIt3Wrapper_Icon=..\assets\icons\favicon.ico
;~ #AutoIt3Wrapper_Outfile_x64=..\build\main.exe
;~ #AutoIt3Wrapper_Run_Au3Stripper=y
;~ #AutoIt3Wrapper_UseUpx=n
;~ #AutoIt3Wrapper_UseX64=y
;~ #Au3Stripper_Parameters=/sf /sv /mo /rm /rsln

#include-once
#include <File.au3>
#include "../lib/data-to-table.au3"

_Main()

Func _Main()
    ;~ Local Const $sInputDataString = _
    ;~     'Language	Popularity (%)	Job Demand	Typical Use' & @CRLF & _
    ;~     'JavaScript	62.3	Very High	Web Development, Frontend/Backend' & @CRLF & _
    ;~     'C#	27.1	High	Game Development, Windows Apps, Web Dev' & @CRLF & _
    ;~     'Go	13.8	Growing	Cloud Services, System Programming' & @CRLF & _
    ;~     'PowerShell	13.5	Low to Moderate	Task Automation, DevOps, System Admin' & @CRLF & _
    ;~     'AutoIt	0.5	Low	Windows GUI Automation, Scripting'

    Local Const $aInputDataArray[][5] = _
        [ _
            ['Language',    'Popularity (%)', 'Job Demand',      'Typical Use'                            ], _
            ['JavaScript',  '62.3',           'Very High',       'Web Development, Frontend/Backend'      ], _
            ['C#',          '27.1',           'High',            'Game Development, Windows Apps, Web Dev'], _
            ['Go',          '13.8',           'Growing',         'Cloud Services, System Programming'     ], _
            ['PowerShell',  '13.5',           'Low to Moderate', 'Task Automation, DevOps, System Admin'  ], _
            ['AutoIt',      '0.5',            'Low',             'Windows GUI Automation, Scripting'      ] _
        ]

    ;~ _ExampleStringDataToTable($sInputDataString)
    _ExampleArrayDataToTable($aInputDataArray)
    ;~ _ExampleStringDataToTableToGui($sInputDataString)

    ;~ _SomeOtherTests($aInputDataArray)
EndFunc

Func _ExampleStringDataToTable($sData)
    Local Const $sResult = _DataToTable($sData, 4, @TAB, 'L, R, C, R')
    If @error Then
        _ShowError()
    EndIf
    Local Const $sOut = StringFormat('==> Border style 3:\n\n%s', $sResult)

    _ShowResult($sOut)
EndFunc

Func _ExampleArrayDataToTable($aData)
    Local $sResult, $sOut

    ;~ 1 = no-border
    $sResult = _DataToTable($aData, 1, @TAB, 'L, R, C, R')
    If @error Then
        _ShowError()
    EndIf
    $sOut &= StringFormat('==> Border style: "1 = no-border"\n\n%s', $sResult)

    ;~ 2 = inner-border-header
    $sResult = _DataToTable($aData, 2, @TAB, 'L, R, C, R')
    If @error Then
        _ShowError()
    EndIf
    $sOut &= StringFormat('\n==> Border style: "2 = inner-border-header"\n\n%s', $sResult)

    ;~ 3 = border-no-header
    $sResult = _DataToTable($aData, 3, @TAB, 'L, R, C, R')
    If @error Then
        _ShowError()
    EndIf
    $sOut &= StringFormat('\n==> Border style: "3 = border-no-header"\n\n%s', $sResult)

    ;~ 4 = border-and-header
    $sResult = _DataToTable($aData, 4, @TAB, 'L, R, C, R')
    If @error Then
        _ShowError()
    EndIf
    $sOut &= StringFormat('\n==> Border style: "4 = border-and-header"\n\n%s', $sResult)

    ;~ 5 = border-edges-with-accent-and-header
    $sResult = _DataToTable($aData, 5, @TAB, 'L, R, C, R')
    If @error Then
        _ShowError()
    EndIf
    $sOut &= StringFormat('\n==> Border style: "5 = border-edges-with-accent-and-header"\n\n%s', $sResult)

    ;~ 6 = double-outter-border-no-header
    $sResult = _DataToTable($aData, 6, @TAB, 'L, R, C, R')
    If @error Then
        _ShowError()
    EndIf
    $sOut &= StringFormat('\n==> Border style: "6 = double-outter-border-no-header"\n\n%s', $sResult)

    ;~ 7 = all-double-border-and-header
    $sResult = _DataToTable($aData, 7, @TAB, 'L, R, C, R')
    If @error Then
        _ShowError()
    EndIf
    $sOut &= StringFormat('\n==> Border style: "7 = all-double-border-and-header"\n\n%s', $sResult)

    ;~ 8 = double-outter-border-and-header-with-single-inner-border
    $sResult = _DataToTable($aData, 8, @TAB, 'L, R, C, R')
    If @error Then
        _ShowError()
    EndIf
    $sOut &= StringFormat('\n==> Border style: "8 = double-outter-border-and-header-with-single-inner-border"\n\n%s', $sResult)

    ;~ 9 = rounded-corner-outside-border-only-no-header
    $sResult = _DataToTable($aData, 9, @TAB, 'L, R, C, R')
    If @error Then
        _ShowError()
    EndIf
    $sOut &= StringFormat('\n==> Border style: "9 = rounded-corner-outside-border-only-no-header"\n\n%s', $sResult)

    ;~ 10 = double-outside-border-only-no-header
    $sResult = _DataToTable($aData, 10, @TAB, 'L, R, C, R')
    If @error Then
        _ShowError()
    EndIf
    $sOut &= StringFormat('\n==> Border style: "10 = double-outside-border-only-no-header"\n\n%s', $sResult)

    _ShowResult($sOut)
EndFunc

Func _ExampleStringDataToTableToGui($sData)
    Local Const $sResult = _DataToTable($sData, 8, @TAB, 'L, R, C, R')
    If @error Then
        _ShowError()
    EndIf

    GUICreate('data-to-table', 580, 200)
    Local Const $cIdText = GUICtrlCreateLabel('', 15, 15, 550, 170)
    GUICtrlSetFont($cIdText, Default, Default, Default, 'Consolas')
    GUISetState()

    GUICtrlSetData($cIdText, $sResult)

    Sleep(5000)
EndFunc

Func _SomeOtherTests($aData)
    Local $sResult, $sOut

    ; fallback behavior
    $sResult = _DataToTable($aData, 'bla', @TAB, 'L, R, C, R')
    If @error Then
        _ShowError()
    EndIf
    $sOut &= StringFormat('\n==> With invalid border style (back to default):\n\n%s', $sResult)

    ; open issues - TOOD: fix that
    $sResult = _DataToTable($aData, 2, ',', 'L, R, C, R')
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

    Local Const $sOutputFile = _PathFull('..\data\output-result.txt')
    _WriteFile($sOutputFile, $sOut)
    ShellExecute('notepad.exe', StringFormat('"%s"', $sOutputFile))
EndFunc

Func _WriteFile($sFile, $sText)
    Local Const $iUtf8WithoutBomAndOverwriteCreationMode = 256 + 2 + 8

    Local $hFile = FileOpen($sFile, $iUtf8WithoutBomAndOverwriteCreationMode)
    FileWrite($hFile, $sText)
    FileClose($hFile)
EndFunc
