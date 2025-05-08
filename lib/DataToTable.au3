;~ v0.2.0 by Sven Seyfert (SOLVE-SMART)

#include-once
#include <Array.au3>
#include <String.au3>

Global $mConst[]
Global $mParam[]
Global $mFrame[]

; #FUNCTION# ====================================================================================================================
; Name...........: _DataToTable
; Description....: Converts a string or array to a formatted table with alignment and border options.
; Syntax.........: _DataToTable( $vData [, $iBorderStyle = 3 [, $sSeparator = @TAB [, $sColumnAlign = '']]] )
; Parameters.....: $vData        - The input string or array containing data values.
;                  $iBorderStyle - [optional] Border style (Default is 3)
;                                      0=NoBorder
;                                      1=HeaderNoBorder
;                                      2=BorderNoHeader
;                                      3=BorderAndHeader
;                                      4=BorderAndHeaderEdgesWithAccent
;                  $sSeparator   - [optional] Separator used in the input string. (Default is @TAB)
;                  $sColumnAlign - [optional] Alignment options for each column (e.g. 'L,R,C'). (Default is '' (left-aligned))
; Return values..: Success - The formatted table as a string.
;                  Failure - Sets the @error flag to non-zero.
; Author ........: Sven Seyfert (SOLVE-SMART)
; Modified ......: -
; Remarks .......: This function processes an input string/array, splits it into rows and columns,
;                  and formats them into a visually table with optional frames and alignment.
; Related .......: -
; Link ..........: https://www.autoitscript.com/forum/topic/212876-_DataToTable/
; Dependencies...: Internal functions (internal use only), prefixed by "__".
; Example .......: Local Const $aData[][5] = _
;                      [ _
;                          ['Language',    'Popularity (%)', 'Job Demand',      'Typical Use'                             ], _
;                          ['JavaScript',  '62.3',           'Very High',       'Web Development, Frontend/Backend'       ], _
;                          ['C#',          '27.1',           'High',            'Game Development, Windows Apps, Web Dev' ], _
;                          ['Go',          '13.8',           'Growing',         'Cloud Services, System Programming'      ], _
;                          ['PowerShell',  '13.5',           'Low to Moderate', 'Task Automation, DevOps, System Admin'   ], _
;                          ['AutoIt',      '0.5',            'Low',             'Windows GUI Automation, Scripting'       ] _
;                      ]
;                  ConsoleWrite(_DataToTable($aData, 3, @TAB, 'L, R, C, L'))
; ===============================================================================================================================
Func _DataToTable($vData, $iBorderStyle = 3, $sSeparator = @TAB, $sColumnAlign = '')
    __ConfigureParameters($iBorderStyle, $sSeparator, $sColumnAlign)
    __InitConstants()
    __InitFrameCharacters()

    Local Const $sData = __ExtractRawData($vData)
    If @error Then
        __Log('at __ExtractRawData()')
        Return SetError(1)
    EndIf

    Local Const $sPreparedData = _NormalizeLineEndings($sData)
    If @error Then
        __Log('at _NormalizeLineEndings()')
        Return SetError(1)
    EndIf

    Local Const $aRows = __SplitIntoRows($sPreparedData)
    If @error Then
        __Log('at __SplitIntoRows()')
        Return SetError(1)
    EndIf

    Local Const $aTable = __BuildTable($aRows)
    If @error Then
        __Log('at __BuildTable()')
        Return SetError(1)
    EndIf

    Local Const $aColWidths = __MeasureColumnWidths($aTable)
    Local Const $iCols      = UBound($aTable, 2)

    Local Const $aAlign = __DetermineColumnAlignments($iCols)
    If @error Then
        __Log('at __DetermineColumnAlignments()')
        Return SetError(1)
    EndIf

    ; build result
    Local $sResult, $sInterimResult
    Local Const $bHeader = ($mParam.BorderStyle = 1 Or $mParam.BorderStyle = 3 Or $mParam.BorderStyle = 4)
    Local Const $bBorder = ($mParam.BorderStyle = 2 Or $mParam.BorderStyle = 3 Or $mParam.BorderStyle = 4)
    Local Const $sPrefix = ($mParam.BorderStyle = 0) ? '' : $mConst.Whitespace

    If $bBorder Then
        $sResult &= __RenderTopBorder($iCols, $aColWidths)
    EndIf

    If $bHeader Then
        $sInterimResult = __RenderHeaderRow($bBorder, $iCols, $sPrefix, $aTable, $aColWidths, $aAlign)
        If @error Then
            __Log('at __RenderHeaderRow()')
            Return SetError(1)
        EndIf

        $sResult &= $sInterimResult
    EndIf

    $sInterimResult = __RenderDataRows($bHeader, $aTable, $bBorder, $iCols, $sPrefix, $aColWidths, $aAlign)
    If @error Then
        __Log('at __RenderDataRows()')
        Return SetError(1)
    EndIf

    $sResult &= $sInterimResult

    If Not $bBorder Then
        Return $sResult
    EndIf

    $sInterimResult = __RenderBottomBorder($iCols, $aColWidths)
    If @error Then
        __Log('at __RenderBottomBorder()')
        Return SetError(1)
    EndIf

    $sResult &= $sInterimResult
    Return $sResult
EndFunc

; #INTERNAL_USE_ONLY# ===========================================================================================================
Func __InitConstants()
    $mConst.Delimiter           = @LF
    $mConst.EntireDelimiterFlag = 1
    $mConst.LeadingTrailingFlag = 1 + 2
    $mConst.Whitespace          = ' '
    $mParam.AlignLeft           = 'L'
    $mParam.AlignCenter         = 'C'
    $mParam.AlignRight          = 'R'
EndFunc

Func __InitFrameCharacters()
    $mFrame.TopLeft     = ($mParam.BorderStyle = 4) ? '╔' : '┌'
    $mFrame.TopRight    = ($mParam.BorderStyle = 4) ? '╗' : '┐'
    $mFrame.BottomLeft  = ($mParam.BorderStyle = 4) ? '╚' : '└'
    $mFrame.BottomRight = ($mParam.BorderStyle = 4) ? '╝' : '┘'
    $mFrame.Horizontal  = '─'
    $mFrame.Vertical    = '│'
    $mFrame.Center      = '┼'
    $mFrame.TopHead     = '┬'
    $mFrame.ColumnHead  = '┴'
    $mFrame.LeftHead    = '├'
    $mFrame.RightHead   = '┤'
EndFunc

Func __ConfigureParameters($iBorderStyle, $sSeparator, $sColumnAlign)
    $mParam.BorderStyle = $iBorderStyle
    $mParam.Separator   = $sSeparator
    $mParam.ColumnAlign = StringUpper($sColumnAlign)

    If $mParam.BorderStyle < 0 Or $mParam.BorderStyle > 4 Or Not IsInt($mParam.BorderStyle) Then
        $mParam.BorderStyle = 3
    EndIf

    If $mParam.Separator = Default Or $mParam.Separator = -1 Then
        $mParam.Separator = @TAB
    EndIf
EndFunc

Func __ExtractRawData($vData)
    If Not IsArray($vData) Then
        Return $vData
    EndIf

    Local $sData = _ArrayToString($vData, $mParam.Separator)
    If @error Then
        __Log('_ArrayToString() error')
        Return SetError(1)
    EndIf

    Return $sData
EndFunc

Func _NormalizeLineEndings($sData)
    $sData = StringRegExpReplace($sData, '(\r\n|\n)', @CRLF)
    If @error Then
        __Log('StringRegExpReplace() error')
        Return SetError(1)
    EndIf

    $sData = StringReplace($sData, $mParam.Separator & @CRLF, @CRLF)
    $sData = StringReplace($sData, @CRLF & $mParam.Separator, @CRLF)
    $sData = StringRegExpReplace($sData, '(\r\n)$', '')
    If @error Then
        __Log('StringRegExpReplace() error')
        Return SetError(1)
    EndIf

    Return StringStripCR($sData)
EndFunc

Func __SplitIntoRows($sData)
    Local Const $aRows = StringSplit($sData, $mConst.Delimiter, $mConst.EntireDelimiterFlag)

    If @error Or $aRows[0] = 0 Then
        __Log('StringSplit() error')
        Return SetError(1)
    EndIf

    Return $aRows
EndFunc

Func __BuildTable($aRows)
    Local Const $iCount = $aRows[0]
    Local $iCols = 0
    Local $aTable[UBound($aRows)][0]

    For $i = 1 To $iCount
        Local $aCols = StringSplit($aRows[$i], $mParam.Separator, $mConst.EntireDelimiterFlag)
        If @error Then
            __Log('StringSplit() error')
            Return SetError(1)
        EndIf

        If $i = 1 Then
            $iCols = $aCols[0]
            ReDim $aTable[$iCount][$iCols]
        EndIf

        If $iCols < $aCols[0] Then
            ReDim $aCols[$iCols + 1]
            For $k = $aCols[0] + 1 To $iCols
                $aCols[$k] = ''
            Next
        EndIf

        For $j = 0 To $iCols - 1
            $aTable[$i - 1][$j] = StringStripWS($aCols[$j + 1], $mConst.LeadingTrailingFlag)
        Next
    Next

    Return $aTable
EndFunc

Func __MeasureColumnWidths($aTable)
    Local $iRows = UBound($aTable) - 1
    Local $iCols = UBound($aTable, 2) - 1
    Local $sCell, $aWidths[$iCols + 1]

    For $j = 0 To $iCols
        For $i = 0 To $iRows
            $sCell = $aTable[$i][$j]

            If $aWidths[$j] > StringLen($sCell) Then
                ContinueLoop
            EndIf

            $aWidths[$j] = StringLen($sCell)
        Next
    Next

    Return $aWidths
EndFunc

Func __DetermineColumnAlignments($iCols)
    Local $aAlign[$iCols]

    If $mParam.ColumnAlign == '' Then
        For $i = 0 To $iCols - 1
            $aAlign[$i] = $mParam.AlignLeft
        Next
        Return $aAlign
    EndIf

    Local $aRawAlign = StringSplit($mParam.ColumnAlign, ',', 2)
    If @error Then
        __Log('StringSplit() error')
        Return SetError(1)
    EndIf

    Local $iIndex
    For $i = 0 To $iCols - 1
        $iIndex = $i >= UBound($aRawAlign) ? UBound($aRawAlign) - 1 : $i
        $aAlign[$i] = StringStripWS($aRawAlign[$iIndex], $mConst.LeadingTrailingFlag)

        If Not StringRegExp($aAlign[$i], '^[LRC]$') Then
            $aAlign[$i] = $mParam.AlignLeft
        EndIf
    Next

    Return $aAlign
EndFunc

Func __RenderTopBorder($iCols, $aColWidths)
    Local $sString = $mFrame.TopLeft
    For $j = 0 To $iCols - 1
        $sString &= _StringRepeat($mFrame.Horizontal, $aColWidths[$j] + 2)
        $sString &= ($j < $iCols - 1) ? $mFrame.TopHead : $mFrame.TopRight
    Next
    $sString &= $mConst.Delimiter

    Return $sString
EndFunc

Func __RenderHeaderRow($bBorder, $iCols, $sPrefix, $aTable, $aColWidths, $aAlign)
    Local $sString

    ; border left
    If $bBorder Or $mParam.BorderStyle = 1 Then
        $sString &= $mFrame.Vertical
    EndIf

    Local $sCell
    For $i = 0 To $iCols - 1
        $sCell = __AlignCellText($aTable[0][$i], $aColWidths[$i], $aAlign[$i]) & $mConst.Whitespace
        If @error Then
            __Log('at __AlignCellText()')
            Return SetError(1)
        EndIf

        $sString &= $sPrefix & $sCell
        If $i < $iCols - 1 Then
            $sString &= ($bBorder Or $mParam.BorderStyle = 1) ? $mFrame.Vertical : ''
        EndIf
    Next

    ; border right
    If $bBorder Or $mParam.BorderStyle = 1 Then
        $sString &= $mFrame.Vertical
    EndIf

    $sString &= $mConst.Delimiter

    ; header separator
    If $bBorder Then
        $sString &= $mFrame.LeftHead
    EndIf
    If $mParam.BorderStyle = 1 Then
        $sString &= $mFrame.LeftHead
    EndIf

    Local $sEnhancedString
    For $i = 0 To $iCols - 1
        $sEnhancedString = _StringRepeat($mFrame.Horizontal, $aColWidths[$i] + 2)
        If @error Then
            __Log('_StringRepeat() error')
            Return SetError(1)
        EndIf

        $sString &= $sEnhancedString

        Select
            Case $i < $iCols - 1 And $bBorder
                $sString &= $mFrame.Center

            Case $i < $iCols - 1 And $mParam.BorderStyle = 1
                $sString &= $mFrame.Center

            Case $i >= $iCols - 1 And $bBorder
                $sString &= $mFrame.RightHead
        EndSelect

    Next

    If $mParam.BorderStyle = 1 Then
        $sString &= $mFrame.RightHead
    EndIf

    $sString &= $mConst.Delimiter

    Return $sString
EndFunc

Func __RenderDataRows($bHeader, $aTable, $bBorder, $iCols, $sPrefix, $aColWidths, $aAlign)
    Local $sString
    Local Const $iStart = $bHeader ? 1 : 0
    Local $sCell

    For $i = $iStart To UBound($aTable) - 1
        If $bBorder Or $mParam.BorderStyle = 1 Then
            $sString &= $mFrame.Vertical
        EndIf

        For $j = 0 To $iCols - 1
            $sCell = __AlignCellText($aTable[$i][$j], $aColWidths[$j], $aAlign[$j]) & $mConst.Whitespace
            If @error Then
                __Log('at __AlignCellText()')
                Return SetError(1)
            EndIf

            $sString &= $sPrefix & $sCell

            If $j < $iCols - 1 And ($bBorder Or $mParam.BorderStyle = 1) Then
                $sString &= $mFrame.Vertical
            EndIf
        Next

        If $bBorder Or $mParam.BorderStyle = 1 Then
            $sString &= $mFrame.Vertical
        EndIf

        $sString &= $mConst.Delimiter
    Next

    Return $sString
EndFunc

Func __RenderBottomBorder($iCols, $aColWidths)
    Local $sString = $mFrame.BottomLeft

    Local $s
    For $j = 0 To $iCols - 1
        $s = _StringRepeat($mFrame.Horizontal, $aColWidths[$j] + 2)
        If @error Then
            __Log('_StringRepeat() error')
            Return SetError(1)
        EndIf
        $sString &= $s

        $sString &= ($j < ($iCols - 1)) ? $mFrame.ColumnHead : $mFrame.BottomRight
    Next

    $sString &= $mConst.Delimiter

    Return $sString
EndFunc

Func __AlignCellText($sText, $iWidth, $sAlignChar)
    Switch $sAlignChar
        Case $mParam.AlignRight
            Return StringFormat('%' & $iWidth & 's', $sText)

        Case $mParam.AlignCenter
            Local Const $iPad   = $iWidth - StringLen($sText)
            Local Const $iLeft  = Floor($iPad / 2)
            Local Const $iRight = $iPad - $iLeft
            Local Const $sCell  = _StringRepeat($mConst.Whitespace, $iLeft) & $sText & _StringRepeat($mConst.Whitespace, $iRight)
            If @error Then
                __Log('_StringRepeat() error')
                Return SetError(1)
            EndIf
            Return $sCell

        Case Else ; $mParam.AlignLeft
            Return StringFormat('%-' & $iWidth & 's', $sText)
    EndSwitch
EndFunc

Func __Log($sMessage)
    If StringLeft($sMessage, 3) == 'at ' Then
        ConsoleWrite(StringFormat('  %s\n', $sMessage))
        Return
    EndIf

    ConsoleWrite(StringFormat('%s\n', $sMessage))
EndFunc
; ===============================================================================================================================
