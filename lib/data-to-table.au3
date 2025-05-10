; Copyright © Sven Seyfert (SOLVE-SMART)
; Version v0.3.0 - 2025-05-09
; Distributed under the MIT License

#include-once
#include <Array.au3>
#include <String.au3>

Global $mParam[]
Global $mConst[]
Global $mBorder[]

; #FUNCTION# ====================================================================================================================
; Name...........: _DataToTable
; Description....: Transforms a string or array to a formatted table with alignment and different border styles.
; Syntax.........: _DataToTable( $vData [, $iBorderStyle = 3 [, $sSeparator = @TAB [, $sColumnAlign = '']]] )
; Parameters.....: $vData        - The input string or array containing data values.
;                  $iBorderStyle - [optional] Border style (default is 4).
;                                             1 = no-border
;                                             2 = inner-border-header
;                                             3 = border-no-header
;                                             4 = border-and-header
;                                             5 = border-edges-with-accent-and-header
;                                             6 = double-outter-border-no-header
;                                             7 = all-double-border-and-header
;                                             8 = double-outter-border-and-header-with-single-inner-border
;                                             9 = rounded-corner-outside-border-only-no-header
;                                             10 = double-outside-border-only-no-header
;                  $sSeparator   - [optional] Separator used in the input string (default is @TAB).
;                  $sColumnAlign - [optional] Alignment for each column (default is '' (left-aligned)).
;                                             Accepted characters are 'C, L, R' (otherwise fallback '' hits).
;                                             For example 'L,R,C' would align three columns > left-aligned, right-aligned, centered.
; Return values..: Success - The formatted table as a string.
;                  Failure - Sets the @error flag to non-zero and logs the error occurrences to the console.
; Author.........: Sven Seyfert (SOLVE-SMART)
; Modified.......: -
; Remarks........: See README.md file at https://github.com/sven-seyfert/data-to-table/blob/main/README.md.
; Related........: StringToTable.au3 (UDF by "ioa747") at https://www.autoitscript.com/forum/topic/212876-_stringtotable/.
; Link...........: https://github.com/sven-seyfert/data-to-table
; Dependencies...: Internal functions (internal use only), prefixed by "__".
; Example........: Local Const $aData[][5] = _
;                      [ _
;                          ['Language',    'Popularity (%)', 'Job Demand',      'Typical Use'                             ], _
;                          ['JavaScript',  '62.3',           'Very High',       'Web Development, Frontend/Backend'       ], _
;                          ['C#',          '27.1',           'High',            'Game Development, Windows Apps, Web Dev' ], _
;                          ['Go',          '13.8',           'Growing',         'Cloud Services, System Programming'      ], _
;                          ['PowerShell',  '13.5',           'Low to Moderate', 'Task Automation, DevOps, System Admin'   ], _
;                          ['AutoIt',      '0.5',            'Low',             'Windows GUI Automation, Scripting'       ] _
;                      ]
;                  ConsoleWrite(_DataToTable($aData, 3, @TAB, 'L, R, C, R'))
; ===============================================================================================================================
Func _DataToTable($vData, $iBorderStyle = 3, $sSeparator = @TAB, $sColumnAlign = '')
    __ConfigureParameters($iBorderStyle, $sSeparator, $sColumnAlign)

    __SetConstants()
    __SetBorderStyle()

    Local Const $sData = __ExtractRawData($vData)
    If @error Then
        __Log('at __ExtractRawData()')
        Return SetError(1)
    EndIf

    Local Const $sPreparedData = __NormalizeLineEndings($sData)
    If @error Then
        __Log('at __NormalizeLineEndings()')
        Return SetError(1)
    EndIf

    Local Const $aDataList = __SplitIntoRows($sPreparedData)
    If @error Then
        __Log('at __SplitIntoRows()')
        Return SetError(1)
    EndIf

    Local Const $aTable = __BuildTable($aDataList)
    If @error Then
        __Log('at __BuildTable()')
        Return SetError(1)
    EndIf

    Local Const $aColWidths = __MeasureColumnWidths($aTable)
    Local Const $iColumns   = UBound($aTable, 2)

    Local Const $aAlign = __DetermineColumnAlignments($iColumns)
    If @error Then
        __Log('at __DetermineColumnAlignments()')
        Return SetError(1)
    EndIf

    ; build result (border, header and aligned cell text)
    Local $sResult, $sInterimResult

    If $mBorder.HasBorder Then
        $sResult &= __BuildTopBorder($iColumns, $aColWidths)
    EndIf

    If $mBorder.HasHeaderBorder Then
        $sInterimResult = __BuildHeaderRowBorder($iColumns, $aTable, $aColWidths, $aAlign)
        If @error Then
            __Log('at __BuildHeaderRowBorder()')
            Return SetError(1)
        EndIf

        $sResult &= $sInterimResult
    EndIf

    $sInterimResult = __BuildDataRowsBorder($aTable, $iColumns, $aColWidths, $aAlign)
    If @error Then
        __Log('at __BuildDataRowsBorder()')
        Return SetError(1)
    EndIf

    $sResult &= $sInterimResult

    If Not $mBorder.HasBorder Then
        Return $sResult
    EndIf

    $sInterimResult = __BuildBottomBorder($iColumns, $aColWidths)
    If @error Then
        __Log('at __BuildBottomBorder()')
        Return SetError(1)
    EndIf

    $sResult &= $sInterimResult
    Return $sResult
EndFunc

; #INTERNAL_USE_ONLY# ===========================================================================================================
Func __SetConstants()
    $mConst.AcceptedAlignCharacters = 'CLR'
    $mConst.Delimiter              = @LF
    $mConst.EmptyString            = ''
    $mConst.EntireDelimiterFlag    = 1
    $mConst.LeadingTrailingFlag    = 1 + 2
    $mConst.SingleWhitespace       = ' '
    $mConst.ZeroBasedArrayFlag     = 2

    $mParam.AlignCenter            = 'C'
    $mParam.AlignLeft              = 'L'
    $mParam.AlignRight             = 'R'
EndFunc

Func __SetBorderStyle()
    Local Const $aBorderStyle[][11] = _
        [ _
            ['',                     1,     2,     3,     4,     5,     6,     7,     8,     9,     10 ], _
            ['EdgeTopLeft',         '',    '┌',   '┌',   '┌',   '╔',   '╔',   '╔',   '╔',   '╭',   '╔'], _
            ['EdgeTopRight',        '',    '┐',   '┐',   '┐',   '╗',   '╗',   '╗',   '╗',   '╮',   '╗'], _
            ['EdgeBottomLeft',      '',    '└',   '└',   '└',   '╚',   '╚',   '╚',   '╚',   '╰',   '╚'], _
            ['EdgeBottomRight',     '',    '┘',   '┘',   '┘',   '╝',   '╝',   '╝',   '╝',   '╯',   '╝'], _
            _
            ['TopCross',            '',    '┬',   '┬',   '┬',   '┬',   '╤',   '╦',   '╤',   '─',   '═'], _
            ['HeaderCross',         '',    '┼',   '┼',   '┼',   '┼',   '┼',   '╬',   '┼',   ' ',   ' '], _
            ['BottomCross',         '',    '┴',   '┴',   '┴',   '┴',   '╧',   '╩',   '╧',   '─',   '═'], _
            _
            ['TopHorizontal',       '',    '─',   '─',   '─',   '─',   '═',   '═',   '═',   '─',   '═'], _
            ['HeaderHorizontal',    '',    '─',   '─',   '─',   '─',   '─',   '═',   '─',   ' ',   ' '], _
            ['BottomHorizontal',    '',    '─',   '─',   '─',   '─',   '═',   '═',   '═',   '─',   '═'], _
            _
            ['HeaderVerticalLeft',  '',    '',    '│',   '│',   '│',   '│',   '║',   '║',   '│',   '║'], _
            ['HeaderSeparator',     '',    '│',   '│',   '│',   '│',   '│',   '║',   '│',   ' ',   ' '], _
            ['HeaderVerticalRight', '',    '',    '│',   '│',   '│',   '│',   '║',   '║',   '│',   '║'], _
            ['HeaderLeft',          '',    '',    '├',   '│',   '├',   '├',   '╠',   '╟',   '│',   '║'], _
            ['HeaderRight',         '',    '',    '┤',   '│',   '┤',   '┤',   '╣',   '╢',   '│',   '║'], _
            _
            ['VerticalLeft',        '',    '',    '│',   '│',   '│',   '║',   '║',   '║',   '│',   '║'], _
            ['Vertical',            '',    '│',   '│',   '│',   '│',   '│',   '║',   '│',   ' ',   ' '], _
            ['VerticalRight',       '',    '',    '│',   '│',   '│',   '║',   '║',   '║',   '│',   '║'], _
            _
            ['HasBorder',           '',    '',    'x',   'x',   'x',   'x',   'x',   'x',   'x',   'x'], _
            ['HasHeaderBorder',     '',    'x',   '',    'x',   'x',   '',    'x',   'x',   '',   ''] _
        ]

    $mBorder.EdgeTopLeft         = $aBorderStyle[1][$mParam.BorderStyle]
    $mBorder.EdgeTopRight        = $aBorderStyle[2][$mParam.BorderStyle]
    $mBorder.EdgeBottomLeft      = $aBorderStyle[3][$mParam.BorderStyle]
    $mBorder.EdgeBottomRight     = $aBorderStyle[4][$mParam.BorderStyle]

    $mBorder.TopCross            = $aBorderStyle[5][$mParam.BorderStyle]
    $mBorder.HeaderCross         = $aBorderStyle[6][$mParam.BorderStyle]
    $mBorder.BottomCross         = $aBorderStyle[7][$mParam.BorderStyle]

    $mBorder.TopHorizontal       = $aBorderStyle[8][$mParam.BorderStyle]
    $mBorder.HeaderHorizontal    = $aBorderStyle[9][$mParam.BorderStyle]
    $mBorder.BottomHorizontal    = $aBorderStyle[10][$mParam.BorderStyle]

    $mBorder.HeaderVerticalLeft  = $aBorderStyle[11][$mParam.BorderStyle]
    $mBorder.HeaderSeparator     = $aBorderStyle[12][$mParam.BorderStyle]
    $mBorder.HeaderVerticalRight = $aBorderStyle[13][$mParam.BorderStyle]
    $mBorder.HeaderLeft          = $aBorderStyle[14][$mParam.BorderStyle]
    $mBorder.HeaderRight         = $aBorderStyle[15][$mParam.BorderStyle]

    $mBorder.VerticalLeft        = $aBorderStyle[16][$mParam.BorderStyle]
    $mBorder.Vertical            = $aBorderStyle[17][$mParam.BorderStyle]
    $mBorder.VerticalRight       = $aBorderStyle[18][$mParam.BorderStyle]

    $mBorder.HasBorder           = StringLower($aBorderStyle[19][$mParam.BorderStyle]) == 'x' ? True : False
    $mBorder.HasHeaderBorder     = StringLower($aBorderStyle[20][$mParam.BorderStyle]) == 'x' ? True : False
EndFunc

Func __ConfigureParameters($iBorderStyle, $sSeparator, $sColumnAlign)
    $mParam.BorderStyle = $iBorderStyle
    $mParam.Separator   = $sSeparator
    $mParam.ColumnAlign = StringUpper($sColumnAlign)

    Local Const $iMaxBorderStyles    = 10
    Local Const $iDefaultBorderStyle = 4

    If Not IsInt($mParam.BorderStyle) Or $mParam.BorderStyle < 1 Or $mParam.BorderStyle > $iMaxBorderStyles Then
        $mParam.BorderStyle = $iDefaultBorderStyle
    EndIf

    If $mParam.Separator = Default Or $mParam.Separator == -1 Then
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

Func __NormalizeLineEndings($sData)
    $sData = StringRegExpReplace($sData, '(\r\n|\n)', @CRLF)
    If @error Then
        __Log('StringRegExpReplace() error')
        Return SetError(1)
    EndIf

    $sData = StringReplace($sData, $mParam.Separator & @CRLF, @CRLF)
    $sData = StringReplace($sData, @CRLF & $mParam.Separator, @CRLF)

    $sData = StringRegExpReplace($sData, '(\r\n)$', $mConst.EmptyString)
    If @error Then
        __Log('StringRegExpReplace() error')
        Return SetError(1)
    EndIf

    Return StringStripCR($sData)
EndFunc

Func __SplitIntoRows($sData)
    Local Const $aDataList = StringSplit($sData, $mConst.Delimiter, $mConst.EntireDelimiterFlag)
    If @error Then
        __Log('StringSplit() error')
        Return SetError(1)
    EndIf

    Return $aDataList
EndFunc

Func __BuildTable($aRows)
    Local Const $iCount = $aRows[0]
    Local $iColumns = 0
    Local $aTable[UBound($aRows)][0]

    For $i = 1 To $iCount
        Local $aColums = StringSplit($aRows[$i], $mParam.Separator, $mConst.EntireDelimiterFlag)
        If @error Then
            __Log('StringSplit() error')
            Return SetError(1)
        EndIf

        If $i == 1 Then
            $iColumns = $aColums[0]
            ReDim $aTable[$iCount][$iColumns]
        EndIf

        If $iColumns < $aColums[0] Then
            ReDim $aColums[$iColumns + 1]
            For $j = $aColums[0] + 1 To $iColumns
                $aColums[$j] = $mConst.EmptyString
            Next
        EndIf

        For $x = 0 To $iColumns - 1
            $aTable[$i - 1][$x] = StringStripWS($aColums[$x + 1], $mConst.LeadingTrailingFlag)
        Next
    Next

    Return $aTable
EndFunc

Func __MeasureColumnWidths($aTable)
    Local $iRows    = UBound($aTable) - 1
    Local $iColumns = UBound($aTable, 2) - 1
    Local $aWidths[$iColumns + 1]
    Local $sCell

    For $iColumn = 0 To $iColumns
        For $iRow = 0 To $iRows
            $sCell = $aTable[$iRow][$iColumn]

            If $aWidths[$iColumn] > StringLen($sCell) Then
                ContinueLoop
            EndIf

            $aWidths[$iColumn] = StringLen($sCell)
        Next
    Next

    Return $aWidths
EndFunc

Func __DetermineColumnAlignments($iColumns)
    Local $aAlign[$iColumns]

    If $mParam.ColumnAlign == $mConst.EmptyString Then
        For $i = 0 To $iColumns - 1
            $aAlign[$i] = $mParam.AlignLeft ; default
        Next
        Return $aAlign
    EndIf

    Local $aRawAlign = StringSplit($mParam.ColumnAlign, ',', $mConst.ZeroBasedArrayFlag)
    If @error Then
        __Log('StringSplit() error')
        Return SetError(1)
    EndIf

    Local $iIndex
    For $i = 0 To $iColumns - 1
        $iIndex = $i >= UBound($aRawAlign) ? UBound($aRawAlign) - 1 : $i
        $aAlign[$i] = StringStripWS($aRawAlign[$iIndex], $mConst.LeadingTrailingFlag)

        If Not StringRegExp($aAlign[$i], '^[' & $mConst.AcceptedAlignCharacters & ']$') Then
            $aAlign[$i] = $mParam.AlignLeft
        EndIf
    Next

    Return $aAlign
EndFunc

Func __BuildTopBorder($iColumns, $aColWidths)
    Local $sString = $mBorder.EdgeTopLeft
    For $i = 0 To $iColumns - 1
        $sString &= _StringRepeat($mBorder.TopHorizontal, $aColWidths[$i] + 2)
        $sString &= ($i < $iColumns - 1) ? $mBorder.TopCross : $mBorder.EdgeTopRight
    Next
    $sString &= $mConst.Delimiter

    Return $sString
EndFunc

Func __BuildHeaderRowBorder($iColumns, $aTable, $aColWidths, $aAlign)
    Local $sString

    If $mBorder.HasBorder Or $mParam.BorderStyle == 2 Then
        $sString &= $mBorder.HeaderVerticalLeft
    EndIf

    Local Const $sPrefix = ($mParam.BorderStyle = 1) ? $mConst.EmptyString : $mConst.SingleWhitespace

    Local $sCell
    For $i = 0 To $iColumns - 1
        $sCell = __AlignCellText($aTable[0][$i], $aColWidths[$i], $aAlign[$i]) & $mConst.SingleWhitespace
        If @error Then
            __Log('at __AlignCellText()')
            Return SetError(1)
        EndIf

        $sString &= $sPrefix & $sCell
        If $i < $iColumns - 1 Then
            $sString &= ($mBorder.HasBorder Or $mParam.BorderStyle = 2) ? $mBorder.HeaderSeparator : $mConst.EmptyString
        EndIf
    Next

    If $mBorder.HasBorder Or $mParam.BorderStyle == 2 Then
        $sString &= $mBorder.HeaderVerticalRight
    EndIf

    $sString &= $mConst.Delimiter

    If $mBorder.HasBorder Then
        $sString &= $mBorder.HeaderLeft
    EndIf

    If $mParam.BorderStyle == 2 Then
        $sString &= $mBorder.HeaderLeft
    EndIf

    Local $sHorizontalChars
    For $i = 0 To $iColumns - 1
        $sHorizontalChars = _StringRepeat($mBorder.HeaderHorizontal, $aColWidths[$i] + 2)
        If @error Then
            __Log('_StringRepeat() error')
            Return SetError(1)
        EndIf

        $sString &= $sHorizontalChars

        Select
            Case $i < $iColumns - 1 And $mBorder.HasBorder
                $sString &= $mBorder.HeaderCross

            Case $i < $iColumns - 1 And $mParam.BorderStyle = 2
                $sString &= $mBorder.HeaderCross

            Case $i >= $iColumns - 1 And $mBorder.HasBorder
                $sString &= $mBorder.HeaderRight
        EndSelect
    Next

    If $mParam.BorderStyle == 2 Then
        $sString &= $mBorder.HeaderRight
    EndIf

    $sString &= $mConst.Delimiter

    Return $sString
EndFunc

Func __BuildDataRowsBorder($aTable, $iColumns, $aColWidths, $aAlign)
    Local $sString

    Local Const $iStart  = $mBorder.HasHeaderBorder ? 1 : 0
    Local Const $sPrefix = ($mParam.BorderStyle = 1) ? $mConst.EmptyString : $mConst.SingleWhitespace
    Local Const $sSuffix = $mConst.SingleWhitespace

    Local $sCell
    For $i = $iStart To UBound($aTable) - 1
        If $mBorder.HasBorder Or $mParam.BorderStyle == 2 Then
            $sString &= $mBorder.VerticalLeft
        EndIf

        For $j = 0 To $iColumns - 1
            $sCell = __AlignCellText($aTable[$i][$j], $aColWidths[$j], $aAlign[$j]) & $sSuffix
            If @error Then
                __Log('at __AlignCellText()')
                Return SetError(1)
            EndIf

            $sString &= $sPrefix & $sCell

            If $j < $iColumns - 1 And ($mBorder.HasBorder Or $mParam.BorderStyle == 2) Then
                $sString &= $mBorder.Vertical
            EndIf
        Next

        If $mBorder.HasBorder Or $mParam.BorderStyle == 2 Then
            $sString &= $mBorder.VerticalRight
        EndIf

        If $mParam.BorderStyle == 1 Then
            $sString = StringTrimRight($sString, 1)
        EndIf

        $sString &= $mConst.Delimiter
    Next

    Return $sString
EndFunc

Func __BuildBottomBorder($iColumns, $aColWidths)
    Local $sString = $mBorder.EdgeBottomLeft

    Local $sHorizontalChars
    For $j = 0 To $iColumns - 1
        $sHorizontalChars = _StringRepeat($mBorder.BottomHorizontal, $aColWidths[$j] + 2)
        If @error Then
            __Log('_StringRepeat() error')
            Return SetError(1)
        EndIf
        $sString &= $sHorizontalChars

        $sString &= ($j < ($iColumns - 1)) ? $mBorder.BottomCross : $mBorder.EdgeBottomRight
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

            Local Const $sCell  = _StringRepeat($mConst.SingleWhitespace, $iLeft) & $sText & _StringRepeat($mConst.SingleWhitespace, $iRight)
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
