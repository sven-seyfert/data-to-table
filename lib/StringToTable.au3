;~ v0.3.1 by ioa747

#include-once
#include <Array.au3>
#include <String.au3>

; #FUNCTION# --------------------------------------------------------------------------------------------------------------------
; Name...........: _StringToTable
; Description....: Converts a string or array to a formatted table with alignment and frame options.
; Syntax.........: _StringToTable( $vString [, $iFrame = 3 [, $sSeparator = @TAB [, $sAlign = ""]]] )
; Parameters.....: $vString    - The input string or array containing data values.
;                  $iFrame     - [optional] Frame type (0=NoFrame, 1=FrameNoHeader, 2=HeaderNoFrame, 3=FrameAndHeader) (Default is 3)
;                  $sSeparator - [optional] Separator used in the input string. (Default is @TAB)
;                  $sAlign     - [optional] Alignment options for each column (e.g., "L,R,C"). (Default is "" (left-aligned))
; Return values..: The formatted table as a string.
; Author ........: ioa747
; Modified ......: Sven Seyfert (SOLVE-SMART)
; Notes .........: This function processes an input string\array, splits it into rows and columns,
;                  and formats them into a visually table with optional frames and alignment.
; Link ..........: https://www.autoitscript.com/forum/topic/212876-_stringtotable/
; Dependencies...: __FormatCell()
;--------------------------------------------------------------------------------------------------------------------------------
Func _StringToTable($vString, $iFrame = 3, $sSeparator = @TAB, $sAlign = "")

    If $iFrame < 0 Or $iFrame > 3 Then $iFrame = 3
    If $sSeparator = Default Or $sSeparator = -1 Then $sSeparator = @TAB

    If IsArray($vString) Then
        $vString = _ArrayToString($vString, $sSeparator, Default, Default, Default, Default, Default)
    EndIf

    ;Prepare string
    $vString = StringRegExpReplace($vString, "(\r\n|\n)", @CRLF)
    $vString = StringReplace($vString, $sSeparator & @CRLF, @CRLF)
    $vString = StringReplace($vString, @CRLF & $sSeparator, @CRLF)
    $vString = StringStripCR(StringRegExpReplace($vString, "(\r\n)$", ""))
    ;ConsoleWrite($vString & @CRLF)

    Local $aRows = StringSplit($vString, @LF, 1)
    If $aRows[0] = 0 Then Return SetError(1, 0, "")

    Local $aTable[UBound($aRows)][0]
    Local $iCols = 0

    For $i = 1 To $aRows[0]
        Local $aCols = StringSplit($aRows[$i], $sSeparator, 1)
        If $i = 1 Then
            $iCols = $aCols[0]
            ReDim $aTable[$aRows[0]][$iCols]
        Else
            If $aCols[0] < $iCols Then
                ReDim $aCols[$iCols + 1]
                For $k = $aCols[0] + 1 To $iCols
                    $aCols[$k] = ""
                Next
            EndIf
        EndIf

        For $j = 0 To $iCols - 1
            $aTable[$i - 1][$j] = StringStripWS($aCols[$j + 1], 3)
        Next
    Next

    Local $aColWidths[$iCols]
    For $j = 0 To $iCols - 1
        $aColWidths[$j] = 0
        For $i = 0 To UBound($aTable) - 1
            $aColWidths[$j] = $aColWidths[$j] > StringLen($aTable[$i][$j]) ? $aColWidths[$j] : StringLen($aTable[$i][$j])
        Next
    Next

    ; Alignment
    Local $aAlign[$iCols]
    If $sAlign <> "" Then
        Local $aRawAlign = StringSplit($sAlign, ",", 2)
        For $j = 0 To $iCols - 1
            Local $iIndex = $j
            If $iIndex >= UBound($aRawAlign) Then $iIndex = UBound($aRawAlign) - 1
            $aAlign[$j] = StringStripWS(StringUpper($aRawAlign[$iIndex]), 3)

            If Not StringRegExp($aAlign[$j], "^[LRC]$") Then $aAlign[$j] = "L"
        Next
    Else
        For $j = 0 To $iCols - 1
            $aAlign[$j] = "L"
        Next
    EndIf

    ; label Meaning
    ; $TL   ┌ Top Left
    ; $TR   ┐ Top Right
    ; $BL   └ Bottom Left
    ; $BR   ┘ Bottom Right
    ; $H    ─ Horizontal
    ; $V    │ Vertical
    ; $TH   ┬ Top Head
    ; $CH   ┴ Column Head
    ; $LH   ├ Left Head
    ; $RH   ┤ Right Head
    ; $C    ┼ Center

    Local Const $TL = "┌", $TR = "┐", $BL = "└", $BR = "┘"
    Local Const $H = "─", $V = "│", $C = "┼"
    Local Const $TH = "┬", $CH = "┴", $LH = "├", $RH = "┤"

    Local $sResult = ""
    Local $bHeader = ($iFrame = 2 Or $iFrame = 3)
    Local $bBorder = ($iFrame = 1 Or $iFrame = 3)
    Local $sPre = ($iFrame = 0 ? "" : " ")

    ; Top border
    If $bBorder Then
        $sResult &= $TL
        For $j = 0 To $iCols - 1
            $sResult &= _StringRepeat($H, $aColWidths[$j] + 2)
            $sResult &= ($j < $iCols - 1) ? $TH : $TR
        Next
        $sResult &= @LF
    EndIf

    ; Header row
    If $bHeader Then
        If $bBorder Or $iFrame = 2 Then $sResult &= $V
        For $j = 0 To $iCols - 1
            $sResult &= $sPre & __FormatCell($aTable[0][$j], $aColWidths[$j], $aAlign[$j]) & " "
            If $j < $iCols - 1 Then $sResult &= ($bBorder Or $iFrame = 2) ? $V : ""
        Next
        If $bBorder Or $iFrame = 2 Then $sResult &= $V
        $sResult &= @LF

        ; Header separator
        If $bBorder Then
            $sResult &= $LH
        ElseIf $iFrame = 2 Then
            $sResult &= $V
        EndIf

        For $j = 0 To $iCols - 1
            $sResult &= _StringRepeat($H, $aColWidths[$j] + 2)
            If $j < $iCols - 1 Then
                $sResult &= ($bBorder ? $C : ($iFrame = 2 ? $C : ""))
            Else
                If $bBorder Then $sResult &= $RH
            EndIf
        Next
        If $iFrame = 2 Then $sResult &= $V
        $sResult &= @LF
    EndIf

    ; Data rows
    For $i = ($bHeader ? 1 : 0) To UBound($aTable) - 1
        If $bBorder Or $iFrame = 2 Then $sResult &= $V
        For $j = 0 To $iCols - 1
            $sResult &= $sPre & __FormatCell($aTable[$i][$j], $aColWidths[$j], $aAlign[$j]) & " "
            If $j < $iCols - 1 Then $sResult &= ($bBorder Or $iFrame = 2) ? $V : ""
        Next
        If $bBorder Or $iFrame = 2 Then $sResult &= $V
        $sResult &= @LF
    Next

    ; Bottom border
    If $bBorder Then
        $sResult &= $BL
        For $j = 0 To $iCols - 1
            $sResult &= _StringRepeat($H, $aColWidths[$j] + 2)
            $sResult &= ($j < $iCols - 1) ? $CH : $BR
        Next
        $sResult &= @LF
    EndIf

    Return $sResult
EndFunc   ;==>_StringToTable
;---------------------------------------------------------------------------------------
Func __FormatCell($text, $width, $align) ; internal
    Switch $align
        Case "R"
            Return StringFormat("%" & $width & "s", $text)
        Case "C"
            Local $pad = $width - StringLen($text)
            Local $left = Floor($pad / 2)
            Local $right = $pad - $left
            Return _StringRepeat(" ", $left) & $text & _StringRepeat(" ", $right)
        Case Else ; "L"
            Return StringFormat("%-" & $width & "s", $text)
    EndSwitch
EndFunc   ;==>__FormatCell
;---------------------------------------------------------------------------------------
