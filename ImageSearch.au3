
; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Users\Admin\Downloads\Develop\Auto\Test Script\ImageSearch.au3>
; ----------------------------------------------------------------------------
Global Const $hwnd = WinGetHandle("[CLASS:X3DKernel]")
Global Const $aClientSize = WinGetClientSize($hwnd)
Global Const $GHX1 = Int(Number($aClientSize[0]/4))
Global Const $GHY1 = Int(Number($aClientSize[1]/4))
Global Const $GHX2 = $GHX1 * 3
Global Const $GHY2 = $GHY1 * 3
Global  $gx1 = Int(Number($aClientSize[0]/2))
Global  $gy1 = Int(Number($aClientSize[1]/2))
Func _ImageSearch($findImage, $resultPosition, ByRef $x, ByRef $y, $tolerance, $transparency = 0)
	Return _ImageSearchArea($findImage, $resultPosition, 0, 0, @DesktopWidth, @DesktopHeight, $x, $y, $tolerance, $transparency)
EndFunc
Func _TargetFs($findImage, $resultPosition, ByRef $x, ByRef $y, $tolerance, $transparency = 0)
	Return _TargetArea($findImage, $resultPosition, 0, 0, $aClientSize[0], $aClientSize[1], $x, $y, $tolerance, $transparency)
EndFunc
Func _TargetGh($findImage, $resultPosition, ByRef $x, ByRef $y, $tolerance, $transparency = 0)
	Return _TargetArea($findImage, $resultPosition,$GHX1 , $GHY1, $GHX2, $GHY2, $x, $y, $tolerance, $transparency)
EndFunc
Func _maintarget($findImage, $resultPosition, ByRef $x, ByRef $y, $tolerance, $transparency = 0)
	Return _IMSM($findImage, $resultPosition, $gx1 - 100, $gy1 - 60, $gx1 + 100, $gy1 + 100, $x, $y, $tolerance, $transparency)
EndFunc
Func _maintargetR($findImage, $resultPosition, ByRef $x, ByRef $y, $tolerance, $transparency = 0)
	Return _IMSMR($findImage, $resultPosition, $gx1 - 50, $gy1 - 40, $gx1 + 50, $gy1 + 40, $x, $y, $tolerance, $transparency)
EndFunc
Func _TargetArea($findImage, $resultPosition, $x1, $y1, $right, $bottom, ByRef $x, ByRef $y, $tolerance, $transparency = 0)
	If Not ($transparency = 0) Then $findImage = "*" & $transparency & " " & $findImage
	If $tolerance > 0 Then $findImage = "*" & $tolerance & " " & $findImage
	$result = DllCall("ImageSearchDLL.dll", "str", "ImageSearch", "int", $x1, "int", $y1, "int", $right, "int", $bottom, "str", $findImage)
	If $result[0] = "0" Then Return 0
	$array = StringSplit($result[0], "|")
	$x = Int(Number($array[2]))
	$y = Int(Number($array[3]))
	If $resultPosition = 1 Then
		$x = $x + Int(Number($array[4]) / 2)
		$y = $y + Int(Number($array[5]) / 2)
		$x += 45
		$y += 7
	EndIf
	Return 1
EndFunc
Func _ImageSearchArea($findImage, $resultPosition, $x1, $y1, $right, $bottom, ByRef $x, ByRef $y, $tolerance, $transparency = 0)
	If Not ($transparency = 0) Then $findImage = "*" & $transparency & " " & $findImage
	If $tolerance > 0 Then $findImage = "*" & $tolerance & " " & $findImage
	$result = DllCall("ImageSearchDLL.dll", "str", "ImageSearch", "int", $x1, "int", $y1, "int", $right, "int", $bottom, "str", $findImage)
	If $result[0] = "0" Then Return 0
	$array = StringSplit($result[0], "|")
	$x = Int(Number($array[2]))
	$y = Int(Number($array[3]))
	If $resultPosition = 1 Then
		$x = $x + Int(Number($array[4]) / 2)
		$y = $y + Int(Number($array[5]) / 2)
	EndIf
	Return 1
EndFunc
Func _IMSM($findImage, $resultPosition, $x1, $y1, $right, $bottom, ByRef $x, ByRef $y, $tolerance, $transparency = 0)
	Local $result
	If Not ($transparency = 0) Then $findImage = "*" & $transparency & " " & $findImage
	If $tolerance > 0 Then $findImage = "*" & $tolerance & " " & $findImage
		While $x1 >= 0 or $y1 >=0
			$result = DllCall("ImageSearchDLL.dll", "str", "ImageSearch", "int", $x1, "int", $y1, "int", $right, "int", $bottom, "str", $findImage)
			If $result[0] = "0" Then
				$x1 -= 30
				$y1 -= 15
				$right += 30
				$bottom += 15
			Else
				$array = StringSplit($result[0], "|")
				$x = Int(Number($array[2]))
				$y = Int(Number($array[3]))
				If $resultPosition = 1 Then
						$x = 45 + $x + Int(Number($array[4]) / 2)
						$y = 7 + $y + Int(Number($array[5]) / 2)
						Return 1
						ExitLoop
				EndIf
			EndIf
		WEnd
		If $result[0] = "0" Then
				Return 0
			EndIf
EndFunc
Func _IMSMR($findImage, $resultPosition, $x1, $y1, $right, $bottom, ByRef $x, ByRef $y, $tolerance, $transparency = 0)
	Local $result
	If Not ($transparency = 0) Then $findImage = "*" & $transparency & " " & $findImage
	If $tolerance > 0 Then $findImage = "*" & $tolerance & " " & $findImage
		While $x1 >= 0 or $y1 >=0
			$result = DllCall("ImageSearchDLL.dll", "str", "ImageSearch", "int", $x1, "int", $y1, "int", $right, "int", $bottom, "str", $findImage)
			If $result[0] = "0" Then
				$x1 -= 30
				$y1 -= 15
				$right += 30
				$bottom += 15
			Else
				$array = StringSplit($result[0], "|")
				$x = Int(Number($array[2]))
				$y = Int(Number($array[3]))
				If $resultPosition = 1 Then
						$x = $x + Int(Number($array[4]) / 2) - 45
						$y = $y + Int(Number($array[5]) / 2) + 7
						Return 1
						ExitLoop
				EndIf
			EndIf
		WEnd
		If $result[0] = "0" Then
				Return 0
		EndIf
EndFunc