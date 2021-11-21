#include <File.au3>
#include "ImageSearch.au3"
#include "CoProc.au3"
Global $Auto_Enabled = FALSE
_SuperGlobalSet("enabled", false)
Local $vi = "AUTO9D.COM - Version 3.7 Vi"
Local $en = "AUTO9D.COM - Version 3.7 En"
Local $user1 = ""
Local $pass1 = ""
Local $filex = @ScriptDir&"\Script\Keylist.txt"
	FileOpen($filex, 0)
	For $i = 1 to _FileCountLines($filex)
		$zx = FileReadLine($filex, $i)
		Select
			case $i = 1
				 $user1 = $zx
			case $i = 2
				 $pass1 = $zx
		EndSelect
	Next
	FileClose($filex)
Global $SM_Bot = True


Global $color[5]
Global $filemode = @ScriptDir&"\Script\configx.txt"
Global $file = @ScriptDir&"\Script\config.txt"
Global $file2 = @ScriptDir&"\Script\config2.txt"
Global $target = 0
Func Terminate()
	$Auto_Enabled = FALSE
	_SuperGlobalSet("enabled", false)
	if ($target <> 0) Then
		ProcessClose($target)
		$target = 0
	EndIf
EndFunc
Func StartAgain()
	$Auto_Enabled = TRUE
	if ($target  <> 0) Then
		ProcessClose($target)
		$target = 0
		Sleep(1000)
	EndIf
	_SuperGlobalSet("enabled", true)
	_AutoTrain()
EndFunc

HotKeySet("{F4}", "Terminate")
HotKeySet("{F3}", "StartAgain")
FileOpen($filemode, 0)
Global $AutoMode = FileReadLine($filemode,1)
	Select
		Case $AutoMode = 1
			_AutoTrain()
		Case $AutoMode = 2
			_AutoTrap()
		Case $AutoMode = 3
			_AutoSkill()
		Case $AutoMode = 4
			_AutoClick()
		Case $AutoMode = 5
			_AutoRewardx()
		Case $AutoMode = 6
			_AutoTrain()
	EndSelect
FileClose($filemode)
Func _AutoTrain()
	FileOpen($file, 0)
		For $i = 1 to _FileCountLines($file)
			$line = FileReadLine($file, $i)
			Select
				Case $i = 1
					Global $ctk = $line ;1
				Case $i = 2
					Global $skilltrain = $line; 1
				Case $i = 3
					Global $phamvi = $line ;2
					_SuperGlobalSet ('phamvi', $line)
				Case $i = 4
					Global $cam = $line ;1
					_SuperGlobalSet ('camera', $line)
				Case $i = 5
					Global $regen = $line ;0
				Case $i = 6
					Global $ngoaithuong = $line ;0
				Case $i = 7
					Global $buffhp = $line ;0
				Case $i = 8
					Global $buffskill = $line;0
				Case $i = 9
					_SuperGlobalSet ('timerbx', $line);2
				Case $i = 10
					Global $reborn = $line;0
				Case $i = 11
					Global $maxtime = $line;3
				Case $i = 12
					Global $zombiex = $line;0
				Case $i = 13
					Global $mob10 = $line;0
				Case $i = 14
					_SuperGlobalSet ('pickx', $line);0
				Case $i = 15
					Global $pickcolor = $line;1
				Case $i = 16
					$color[0] = $line;0xFF7800 do cam
				Case $i = 17
					$color[1] = $line
				Case $i = 18
					$color[2] = $line
				Case $i = 19
					$color[3] = $line
				Case $i = 20
					$color[4] = $line
				Case $i = 21
					Global $partyx = $line
				Case $i = 22
					Global $atkboss = $line
				Case $i = 23
					Global $autou = $line
				Case $i = 24
					_SuperGlobalSet ('outgame', $line)
				Case $i = 25
					_SuperGlobalSet ('itembuff', $line)
				Case $i = 26
					Global $delayreborn = $line
				Case $i = 27
					_SuperGlobalSet ('autoparty', $line)
				EndSelect
		Next
	FileClose($file)
	$target = _CoProc ('_findmobx')
	_SuperGlobalSet ('autox', 0)
	If $buffskill <> 0 Then
		$rebuffx = _CoProc ('_Timerb')
	EndIf
	If $mob10 = 1 Then
		$mob10 = 1
	Else
		$mob10 = 10
	EndIf
	If $ctk = 1 Then
		If $skilltrain = 1 Then
			Global $typeatk = 3
		Else
			Global $typeatk = 1
		EndIf
	Else
		Global $typeatk = 2
	EndIf
	Winmove($hwnd,"",0,0)
	Sleep(2000)
	Sleep(4000)
	mousemove($gx1,$gy1)
	If $zombiex = 0 Then
		If $atkboss = 1 Then
			If $buffhp = 1 Then
				_mainhp()
			Else
				_main()
			EndIf
		Else
			If $buffhp = 1 Then
				_mainlvhp()
			Else
				_mainlv()
			EndIf
		EndIf
	Else
		If $atkboss = 1 Then
			If $buffhp = 1 Then
				_mainhpz()
			Else
				_mainz()
			EndIf
		Else
			If $buffhp = 1 Then
				_mainlvhpz()
			Else
				_mainlvz()
			EndIf
		EndIf
	EndIf
EndFunc
Func _mainz()
	Sleep(2000)
	WinActivate($hwnd)
	Local $x,$y,$a,$b = 0
		While $Auto_Enabled
			If $phamvi = 2 Then
				 Local $monster = _maintarget(@ScriptDir & "\Image\hpmbar.bmp",1,$x,$y,$mob10)
				 DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $x + $y * 0x10000)
					If $monster = 1 Then
						$monster = _maintarget(@ScriptDir & "\hpmbar.bmp",1,$a,$b,$mob10)
						If ($a == $x) And ($b == $y) Then
							DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $a + $b * 0x10000)
							DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $a + $b * 0x10000)
							Sleep(10)
							MouseClick("Left")
							_AtkMob($typeatk)
						EndIf
					EndIf
			Else
			   Local $monster = _TargetGh(@ScriptDir & "\Image\hpmbar.bmp",1,$x,$y,$mob10)
					If $monster = 1 Then
						DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $x + $y * 0x10000)
						DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $x + $y * 0x10000)
						Sleep(10)
						mouseclick("left")
						Sleep(200)
						_AtkMob($typeatk)
					Else
						$monster = _TargetGh(@ScriptDir & "\Image\hpmbar2.bmp",1,$x,$y,$mob10)
						If $monster = 1 Then
							DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", ($x - 80)  + $y * 0x10000)
							DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", ($x - 80) + $y * 0x10000)
							Sleep(10)
							mouseclick("left")
							Sleep(200)
							_AtkMob($typeatk)
						 Else
							If $phamvi = 1 Then
							$monster = _TargetFs(@ScriptDir & "\hpmbar.bmp",1,$x,$y,$mob10)
								If $monster = 1 Then
									DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $x + $y * 0x10000)
									Sleep(10)
									mouseclick("left")
									Sleep(200)
									_AtkMob($typeatk)
								Endif
						   EndIf
						EndIf
					EndIf
		EndIf
		If $pickcolor = 1 Then
								_PickColor()
					EndIf
					If $monster = 0 Then
								If $regen = 1 Then
									Send("p")
									Sleep(2000)
								EndIf
					EndIf
	WEnd
EndFunc
Func _mainlvz()
	Sleep(2000)
	WinActivate($hwnd)
	Local $x,$y,$a,$b = 0
		While $Auto_Enabled
			If $phamvi = 2 Then
				 Local $monster = _maintarget(@ScriptDir & "\Image\hpmbar.bmp",1,$x,$y,$mob10)
				 DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $x + $y * 0x10000)
					If $monster = 1 Then
						$monster = _maintarget(@ScriptDir & "\Image\hpmbar.bmp",1,$a,$b,$mob10)
						If ($a == $x) And ($b == $y) Then
							DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $a + $b * 0x10000)
							DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $a + $b * 0x10000)
							MouseClick("Left")
							_AtkMob($typeatk)
						EndIf
					EndIf
			Else
			   Local $monster = _TargetGh(@ScriptDir & "\Image\hpmbar.bmp",1,$x,$y,$mob10)
					If $monster = 1 Then
						DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $x + $y * 0x10000)
						DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $x + $y * 0x10000)
						Sleep(10)
						mouseclick("left")
						Sleep(200)
						_AtkMoblv($typeatk)
					Else
						$monster = _TargetGh(@ScriptDir & "\Image\hpmbar2.bmp",1,$x,$y,$mob10)
						If $monster = 1 Then
							DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", ($x - 80)  + $y * 0x10000)
							DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", ($x - 80) + $y * 0x10000)
							Sleep(10)
							mouseclick("left")
							Sleep(200)
							_AtkMoblv($typeatk)
						 Else
							If $phamvi = 1 Then
							$monster = _TargetFs(@ScriptDir & "\Image\hpmbar.bmp",1,$x,$y,$mob10)
								If $monster = 1 Then
									DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $x + $y * 0x10000)
									Sleep(10)
									mouseclick("left")
									Sleep(200)
									_AtkMoblv($typeatk)
								Endif
						   EndIf
						EndIf
					EndIf
			EndIf
			If $pickcolor = 1 Then
								_PickColor()
					EndIf
					If $monster = 0 Then
								If $regen = 1 Then
									Send("p")
									Sleep(2000)
								EndIf
					EndIf
	WEnd
EndFunc
Func _mainhpz()
	Sleep(2000)
	WinActivate($hwnd)
	Local $x,$y,$a,$b = 0
		While $Auto_Enabled
			If $phamvi = 2 Then
				 Local $monster = _maintarget(@ScriptDir & "\Image\hpmbar.bmp",1,$x,$y,$mob10)
				 DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $x + $y * 0x10000)
					If $monster = 1 Then
						$monster = _maintarget(@ScriptDir & "\Image\hpmbar.bmp",1,$a,$b,$mob10)
						If ($a == $x) And ($b == $y) Then
							DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $a + $b * 0x10000)
							DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $a + $b * 0x10000)
							MouseClick("Left")
							_AtkMob($typeatk)
						EndIf
					EndIf
			Else
			   Local $monster = _TargetGh(@ScriptDir & "\Image\hpmbar.bmp",1,$x,$y,$mob10)
					If $monster = 1 Then
						DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $x + $y * 0x10000)
						DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $x + $y * 0x10000)
						Sleep(10)
						mouseclick("left")
						Sleep(200)
						_AtkMobhp($typeatk)
					Else
						$monster = _TargetGh(@ScriptDir & "\Image\hpmbar2.bmp",1,$x,$y,$mob10)
						If $monster = 1 Then
							DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", ($x-80) + $y * 0x10000)
							DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", ($x-80) + $y * 0x10000)
							Sleep(10)
							mouseclick("left")
							Sleep(200)
							_AtkMobhp($typeatk)
						 Else
							If $phamvi = 1 Then
							$monster = _TargetFs(@ScriptDir & "\Image\hpmbar.bmp",1,$x,$y,$mob10)
								If $monster = 1 Then
									DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $x + $y * 0x10000)
									Sleep(10)
									mouseclick("left")
									Sleep(200)
									_AtkMobhp($typeatk)
								Endif
						   EndIf
						EndIf
					EndIf
		EndIf
		If $pickcolor = 1 Then
								_PickColor()
					EndIf
					If $monster = 0 Then
								If $regen = 1 Then
									Send("p")
									Sleep(2000)
								EndIf
					EndIf
	WEnd
EndFunc
Func _mainlvhpz()
	Sleep(2000)
	WinActivate($hwnd)
	Local $x,$y,$a,$b = 0
		While $Auto_Enabled
			If $phamvi = 2 Then
				 Local $monster = _maintarget(@ScriptDir & "\Image\hpmbar.bmp",1,$x,$y,$mob10)
				 DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $x + $y * 0x10000)
					If $monster = 1 Then
						$monster = _maintarget(@ScriptDir & "\Image\hpmbar.bmp",1,$a,$b,$mob10)
						If ($a == $x) And ($b == $y) Then
							DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $a + $b * 0x10000)
							DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $a + $b * 0x10000)
							MouseClick("Left")
							_AtkMob($typeatk)
						EndIf
					EndIf
			Else
			   Local $monster = _TargetGh(@ScriptDir & "\Image\hpmbar.bmp",1,$x,$y,$mob10)
					If $monster = 1 Then
						DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $x + $y * 0x10000)
							DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $x + $y * 0x10000)
							Sleep(10)
							mouseclick("left")
							Sleep(200)
							_AtkMoblvhp($typeatk)
					Else
						$monster = _TargetGh(@ScriptDir & "\Image\hpmbar2.bmp",1,$x,$y,$mob10)
						If $monster = 1 Then
							DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", ($x-80) + $y * 0x10000)
							DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", ($x-80) + $y * 0x10000)
							Sleep(10)
							mouseclick("left")
							Sleep(200)
							_AtkMoblvhp($typeatk)
						 Else
							If $phamvi = 1 Then
							$monster = _TargetFs(@ScriptDir & "\Image\hpmbar.bmp",1,$x,$y,$mob10)
								If $monster = 1 Then
									DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $x + $y * 0x10000)
									Sleep(10)
									mouseclick("left")
									Sleep(200)
									_AtkMoblvhp($typeatk)
								Endif
						   EndIf
						EndIf
					EndIf
							EndIf
					If $pickcolor = 1 Then
								_PickColor()
					EndIf
					If $monster = 0 Then
								If $regen = 1 Then
									Send("p")
									Sleep(2000)
								EndIf
					EndIf
	WEnd
EndFunc
Func _main()
	Sleep(2000)
	WinActivate($hwnd)
	Local $x,$y,$a,$b = 0
		While $Auto_Enabled
			If $phamvi = 2 Then
				 Local $monster = _maintarget(@ScriptDir & "\Image\hpmbar.bmp",1,$x,$y,$mob10)
				 DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $x + $y * 0x10000)
					If $monster = 1 Then
						$monster = _maintarget(@ScriptDir & "\Image\hpmbar.bmp",1,$a,$b,$mob10)
						If ($a == $x) And ($b == $y) Then
							DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $a + $b * 0x10000)
							DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $a + $b * 0x10000)
							MouseClick("Left")
							_AtkMob($typeatk)
						EndIf
					EndIf
			Else
			   Local $monster = _TargetGh(@ScriptDir & "\Image\hpmbar.bmp",1,$x,$y,$mob10)
					If $monster = 1 Then
						DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $x + $y * 0x10000)
							DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $x + $y * 0x10000)
							Sleep(10)
							mouseclick("left")
						_AtkMob($typeatk)
					Else
						$monster = _TargetGh(@ScriptDir & "\Image\hpmbar2.bmp",1,$x,$y,$mob10)
						If $monster = 1 Then
							DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", ($x-80) + $y * 0x10000)
							DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", ($x-80) + $y * 0x10000)
							Sleep(10)
							mouseclick("left")
						    _AtkMob($typeatk)
						 Else
							If $phamvi = 1 Then
							$monster = _TargetFs(@ScriptDir & "\Image\hpmbar.bmp",1,$x,$y,$mob10)
								If $monster = 1 Then
									DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $x + $y * 0x10000)
									Sleep(10)
									mouseclick("left")
									_AtkMob($typeatk)
								Endif
						   EndIf
						EndIf
					EndIf
							EndIf
							If $pickcolor = 1 Then
								_PickColor()
					EndIf
					If $monster = 0 Then
								If $regen = 1 Then
									Send("p")
									Sleep(2000)
								EndIf
					EndIf
	WEnd
EndFunc
Func _mainlv()
	Sleep(2000)
	WinActivate($hwnd)
	Local $x,$y,$a,$b = 0
		While $Auto_Enabled
			If $phamvi = 2 Then
				 Local $monster = _maintarget(@ScriptDir & "\Image\hpmbar.bmp",1,$x,$y,$mob10)
				 DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $x + $y * 0x10000)
					ConsoleWrite($monster)
					If $monster = 1 Then
						$monster = _maintarget(@ScriptDir & "\Image\hpmbar.bmp",1,$a,$b,$mob10)
						ConsoleWrite("a: " & $a & " B: " & $b & "X: " & $x & " Y: " & $y & @LF)
						If ($a == $x) And ($b == $y) Then
							DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $a + $b * 0x10000)
							DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $a + $b * 0x10000)
							MouseClick("Left", $x, $y)
							_AtkMob($typeatk)
						EndIf
					EndIf
			Else
			   Local $monster = _TargetGh(@ScriptDir & "\Image\hpmbar.bmp",1,$x,$y,$mob10)
					If $monster = 1 Then
						DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $x + $y * 0x10000)
							DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $x + $y * 0x10000)
							Sleep(10)
							mouseclick("left")
						_AtkMoblv($typeatk)
					Else
						$monster = _TargetGh(@ScriptDir & "\Image\hpmbar2.bmp",1,$x,$y,$mob10)
						If $monster = 1 Then
							DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", ($x-80) + $y * 0x10000)
							DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", ($x-80) + $y * 0x10000)
							Sleep(10)
							mouseclick("left")
						    _AtkMoblv($typeatk)
						 Else
							If $phamvi = 1 Then
							$monster = _TargetFs(@ScriptDir & "\Image\hpmbar.bmp",1,$x,$y,$mob10)
								If $monster = 1 Then
									DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $x + $y * 0x10000)
									Sleep(10)
									mouseclick("left")
									_AtkMoblv($typeatk)
								Endif
						   EndIf
						EndIf
					EndIf
							EndIf
							If $pickcolor = 1 Then
								;_PickColor()
					EndIf
					If $monster = 0 Then
								If $regen = 1 Then
									Send("p")
									Sleep(2000)
								EndIf
					EndIf
	WEnd
EndFunc
Func _mainhp()
	Sleep(2000)
	WinActivate($hwnd)
	Local $x,$y,$a,$b = 0
		While $Auto_Enabled
			If $phamvi = 2 Then
				 Local $monster = _maintarget(@ScriptDir & "\Image\hpmbar.bmp",1,$x,$y,$mob10)
				 DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $x + $y * 0x10000)
					If $monster = 1 Then
						$monster = _maintarget(@ScriptDir & "\Image\hpmbar.bmp",1,$a,$b,$mob10)
						If ($a == $x) And ($b == $y) Then
							DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $a + $b * 0x10000)
							DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $a + $b * 0x10000)
							MouseClick("Left")
							_AtkMob($typeatk)
						EndIf
					EndIf
			Else
			   Local $monster = _TargetGh(@ScriptDir & "\Image\hpmbar.bmp",1,$x,$y,$mob10)
					If $monster = 1 Then
						DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $x + $y * 0x10000)
							DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $x + $y * 0x10000)
							Sleep(10)
							mouseclick("left")
						_AtkMobhp($typeatk)
					Else
						$monster = _TargetGh(@ScriptDir & "\Image\hpmbar2.bmp",1,$x,$y,$mob10)
						If $monster = 1 Then
							DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", ($x-80) + $y * 0x10000)
							DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", ($x-80) + $y * 0x10000)
							Sleep(10)
							mouseclick("left")
						    _AtkMobhp($typeatk)
						 Else
							If $phamvi = 1 Then
							$monster = _TargetFs(@ScriptDir & "\Image\hpmbar.bmp",1,$x,$y,$mob10)
								If $monster = 1 Then
									DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $x + $y * 0x10000)
									Sleep(10)
									mouseclick("left")
									_AtkMobhp($typeatk)
								Endif
						   EndIf
						EndIf
					EndIf
							EndIf
							If $pickcolor = 1 Then
								_PickColor()
					EndIf
					If $monster = 0 Then
								If $regen = 1 Then
									Send("p")
									Sleep(2000)
								EndIf
					EndIf
	WEnd
EndFunc
Func _mainlvhp()
	Sleep(2000)
	WinActivate($hwnd)
	Local $x,$y,$a,$b = 0
		While $Auto_Enabled
			If $phamvi = 2 Then
				 Local $monster = _maintarget(@ScriptDir & "\Image\hpmbar.bmp",1,$x,$y,$mob10)
				 DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $x + $y * 0x10000)
					If $monster = 1 Then
						$monster = _maintarget(@ScriptDir & "\Image\hpmbar.bmp",1,$a,$b,$mob10)
						If ($a == $x) And ($b == $y) Then
							DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $a + $b * 0x10000)
							DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $a + $b * 0x10000)
							MouseClick("Left")
							_AtkMob($typeatk)
						EndIf
					EndIf
			Else
			   Local $monster = _TargetGh(@ScriptDir & "\Image\hpmbar.bmp",1,$x,$y,$mob10)
					If $monster = 1 Then
						DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $x + $y * 0x10000)
							DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $x + $y * 0x10000)
							Sleep(10)
							mouseclick("left")
						_AtkMoblvhp($typeatk)
					Else
						$monster = _TargetGh(@ScriptDir & "\Image\hpmbar2.bmp",1,$x,$y,$mob10)
						If $monster = 1 Then
							DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", ($x-80) + $y * 0x10000)
							DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", ($x-80) + $y * 0x10000)
							Sleep(10)
							mouseclick("left")
						    _AtkMoblvhp($typeatk)
						 Else
							If $phamvi = 1 Then
							$monster = _TargetFs(@ScriptDir & "\Image\hpmbar.bmp",1,$x,$y,$mob10)
								If $monster = 1 Then
									DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $x + $y * 0x10000)
									Sleep(10)
									mouseclick("left")
									_AtkMoblvhp($typeatk)
								Endif
						   EndIf
						EndIf
					EndIf
						EndIf
						If $pickcolor = 1 Then
								_PickColor()
					EndIf
					If $monster = 0 Then
								If $regen = 1 Then
									Send("p")
									Sleep(2000)
								EndIf
					EndIf
	WEnd
EndFunc
Func _AtkMob($typeatk)
	Local $x,$y = 0
	Select
		Case $typeatk = 3
		Local $numsk= 1
		Local $npc = _ImageSearch(@ScriptDir & "\Image\npc.bmp",0,$x,$y,10)
		ConsoleWrite($npc)
				If $npc = 1 Then
					ConsoleWrite("ATK")
					For $i= 1 to $maxtime*2
						Local $mob = _ImageSearch(@ScriptDir & "\Image\mob.bmp",0,$x,$y,5)
						ConsoleWrite(@LF & "Mob")
						ConsoleWrite($mob)
							If $mob = 1 Then
								Send($numsk)
								Send("a")
								$numsk +=1
								Local $ttrien = _ImageSearch(@ScriptDir & "\Image\ttrien.bmp",0,$x,$y,5)
								ConsoleWrite(@LF & "TTrien")
								ConsoleWrite($ttrien)
									If $ttrien = 1 Then
										Sleep(2000)
									EndIf
								If $numsk >= 6 Then
									$numsk = 1
								Endif
							Else
								ConsoleWrite(@LF & "Mob out")
								ExitLoop
							EndIf
						Next
						If $autou = 1 Then
							Send("u")
						EndIf
					If $mob = 1 Then
						_canceltarget()
					EndIf
				Else
					ConsoleWrite("NPC")
					_canceltarget()
				Endif
	Case $typeatk = 2
		Local $numsk= 1
		Local $npc = _ImageSearch(@ScriptDir & "\Image\npc.bmp",0,$x,$y,10)
				If $npc =  Then
					For $i= 1 to $maxtime*2
						Local $mob = _ImageSearch(@ScriptDir & "\Image\mob.bmp",0,$x,$y,5)
							If $mob = 1 Then
								Send($numsk)
								$numsk +=1
								Local $ttrien = _ImageSearch(@ScriptDir & "\Image\ttrien.bmp",0,$x,$y,5)
									If $ttrien = 1 Then
										Sleep(2000)
									EndIf
								If $numsk >= 6 Then
									$numsk = 1
								Endif
							Else
								ExitLoop
							EndIf
						Next
						If $autou = 1 Then
							Send("u")
						EndIf
					If $mob = 1 Then
						_canceltarget()
					EndIf
				Else
					_canceltarget()
				Endif
		Case $typeatk = 1
				Local $npc = _ImageSearch(@ScriptDir & "\Image\npc.bmp",0,$x,$y,10)
				If $npc = 0 Then
					For $i= 1 to $maxtime*3
						Local $mob = _ImageSearch(@ScriptDir & "\Image\mob.bmp",0,$x,$y,5)
							If $mob = 1 Then
								Send("a")
							Else
								ExitLoop
							EndIf
						Next
						If $autou = 1 Then
							Send("u")
						EndIf
					If $mob = 1 Then
						_canceltarget()
					EndIf
				Else
					_canceltarget()
				Endif
	EndSelect
			Local $trangthai = _SuperGlobalGet ('autox',1)
			If $trangthai <> 0 Then
				_hoisinh($trangthai)
			EndIf
EndFunc
Func _AtkMoblv($typeatk)
	Local $x,$y = 0
	Select
		Case $typeatk = 3
		Local $numsk = 1
		Local $npc = _ImageSearch(@ScriptDir & "\Image\npc.bmp",0,$x,$y,10)
				If $npc = 0 Then
					For $i= 1 to $maxtime*2
						Local $mob = _ImageSearch(@ScriptDir & "\Image\moblv.bmp",0,$x,$y,5)
							If $mob = 1 Then
								Send($numsk)
								Send("a")
								$numsk +=1
								Local $ttrien = _ImageSearch(@ScriptDir & "\Image\ttrien.bmp",0,$x,$y,5)
									If $ttrien = 1 Then
										Sleep(2000)
									EndIf
								If $numsk >= 6 Then
									$numsk = 1
								Endif
							Else
								ExitLoop
							EndIf
						Next
						If $autou = 1 Then
							Send("u")
						EndIf
					If $mob = 1 Then
						_canceltarget()
					EndIf
				Else
					_canceltarget()
				Endif
	Case $typeatk = 2
		Local $numsk = 1
		Local $npc = _ImageSearch(@ScriptDir & "\Image\npc.bmp",0,$x,$y,10)
				If $npc = 0 Then
					For $i= 1 to $maxtime*2
						Local $mob = _ImageSearch(@ScriptDir & "\Image\moblv.bmp",0,$x,$y,5)
							If $mob = 1 Then
								Send($numsk)
								$numsk +=1
								Local $ttrien = _ImageSearch(@ScriptDir & "\Image\ttrien.bmp",0,$x,$y,5)
									If $ttrien = 1 Then
										Sleep(2000)
									EndIf
								If $numsk >= 6 Then
									$numsk = 1
								Endif
							Else
								ExitLoop
							EndIf
						Next
						If $autou = 1 Then
							Send("u")
						EndIf
					If $mob = 1 Then
						_canceltarget()
					EndIf
				Else
					_canceltarget()
				Endif
		Case $typeatk = 1
				Local $npc = _ImageSearch(@ScriptDir & "\Image\npc.bmp",0,$x,$y,10)
				If $npc = 0 Then
					For $i= 1 to $maxtime*3
						Local $mob = _ImageSearch(@ScriptDir & "\Image\moblv.bmp",0,$x,$y,5)
							If $mob = 1 Then
								Send("a")
							Else
								ExitLoop
							EndIf
						Next
					If $mob = 1 Then
						_canceltarget()
					EndIf
				Else
					_canceltarget()
				Endif
			EndSelect
			If $autou = 1 Then
				Send("u")
			EndIf
			Local $trangthai = _SuperGlobalGet ('autox',1)
			If $trangthai <> 0 Then
				_hoisinh($trangthai)
			EndIf
EndFunc
Func _AtkMobhp($typeatk)
	Local $x,$y = 0
	Select
		Case $typeatk = 3
		local $numsk = 1
		Local $npc = _ImageSearch(@ScriptDir & "\Image\npc.bmp",0,$x,$y,10)
				If $npc = 0 Then
					For $i= 1 to $maxtime*2
						Local $mob = _ImageSearch(@ScriptDir & "\Image\mob.bmp",0,$x,$y,5)
							If $mob = 1 Then
								Send($numsk)
								Send("a")
								$numsk +=1
								Local $ttrien = _ImageSearch(@ScriptDir & "\Image\ttrien.bmp",0,$x,$y,5)
									If $ttrien = 1 Then
										Sleep(2000)
									EndIf
								If $numsk >= 6 Then
									$numsk = 1
								Endif
							Else
								ExitLoop
							EndIf
						Next
						If $autou = 1 Then
							Send("u")
						EndIf
					If $mob = 1 Then
						_canceltarget()
					EndIf
				Else
					_canceltarget()
				Endif
	Case $typeatk = 2
		local $numsk = 1
		Local $npc = _ImageSearch(@ScriptDir & "\Image\npc.bmp",0,$x,$y,10)
				If $npc = 0 Then
					For $i= 1 to $maxtime*2
						Local $mob = _ImageSearch(@ScriptDir & "\Image\mob.bmp",0,$x,$y,5)
							If $mob = 1 Then
								Send($numsk)
								$numsk +=1
								Local $ttrien = _ImageSearch(@ScriptDir & "\Image\ttrien.bmp",0,$x,$y,5)
									If $ttrien = 1 Then
										Sleep(2000)
									EndIf
								If $numsk >= 6 Then
									$numsk = 1
								Endif
							Else
								ExitLoop
							EndIf
						Next
						If $autou = 1 Then
							Send("u")
						EndIf
					If $mob = 1 Then
						_canceltarget()
					EndIf
				Else
					_canceltarget()
				Endif
		Case $typeatk = 1
				Local $npc = _ImageSearch(@ScriptDir & "\Image\npc.bmp",0,$x,$y,10)
				If $npc = 0 Then
					For $i= 1 to $maxtime*3
						Local $mob = _ImageSearch(@ScriptDir & "\Image\mob.bmp",0,$x,$y,5)
							If $mob = 1 Then
								Send("a")
							Else
								ExitLoop
							EndIf
						Next
						If $autou = 1 Then
							Send("u")
						EndIf
					If $mob = 1 Then
						_canceltarget()
					EndIf
				Else
					_canceltarget()
				Endif
			EndSelect
			_HP()
			Local $trangthai = _SuperGlobalGet ('autox',1)
			If $trangthai <> 0 Then
				_hoisinh($trangthai)
			EndIf
EndFunc
Func _AtkMoblvhp($typeatk)
	Local $x,$y = 0
	Select
		Case $typeatk = 3
		Local $numsk = 1
		Local $npc = _ImageSearch(@ScriptDir & "\Image\npc.bmp",0,$x,$y,10)
				If $npc = 0 Then
					For $i= 1 to $maxtime*2
						Local $mob = _ImageSearch(@ScriptDir & "\Image\moblv.bmp",0,$x,$y,5)
							If $mob = 1 Then
								Send($numsk)
								Send("a")
								$numsk +=1
								Local $ttrien = _ImageSearch(@ScriptDir & "\Image\ttrien.bmp",0,$x,$y,5)
									If $ttrien = 1 Then
										Sleep(2000)
									EndIf
								If $numsk >= 6 Then
									$numsk = 1
								Endif
							Else
								ExitLoop
							EndIf
						Next
						If $autou = 1 Then
							Send("u")
						EndIf
					If $mob = 1 Then
						_canceltarget()
					EndIf
				Else
					_canceltarget()
				Endif
	Case $typeatk = 2
		Local $numsk = 1
		Local $npc = _ImageSearch(@ScriptDir & "\Image\npc.bmp",0,$x,$y,10)
				If $npc = 0 Then
					For $i= 1 to $maxtime*2
						Local $mob = _ImageSearch(@ScriptDir & "\Image\moblv.bmp",0,$x,$y,5)
							If $mob = 1 Then
								Send($numsk)
								$numsk +=1
								Local $ttrien = _ImageSearch(@ScriptDir & "\Image\ttrien.bmp",0,$x,$y,5)
									If $ttrien = 1 Then
										Sleep(2000)
									EndIf
								If $numsk >= 6 Then
									$numsk = 1
								Endif
							Else
								ExitLoop
							EndIf
						Next
						If $autou = 1 Then
							Send("u")
						EndIf
					If $mob = 1 Then
						_canceltarget()
					EndIf
				Else
					_canceltarget()
				Endif
		Case $typeatk = 1
				Local $npc = _ImageSearch(@ScriptDir & "\Image\npc.bmp",0,$x,$y,10)
				If $npc = 0 Then
					For $i= 1 to $maxtime*3
						Local $mob = _ImageSearch(@ScriptDir & "\Image\moblv.bmp",0,$x,$y,5)
							If $mob = 1 Then
								Send("a")
							Else
								ExitLoop
							EndIf
						Next
						If $autou = 1 Then
							Send("u")
						EndIf
					If $mob = 1 Then
						_canceltarget()
					EndIf
				Else
					_canceltarget()
				Endif
			EndSelect
				_HP()
			Local $trangthai = _SuperGlobalGet ('autox',1)
			If $trangthai <> 0 Then
				_hoisinh($trangthai)
			EndIf
EndFunc
Func _hoisinh( byref $trangthai )
	tooltip("x",0,0)
	Select
	Case $trangthai = 1
		While $Auto_Enabled
			Local $a,$b = 0
			Local $exit = _ImageSearch(@ScriptDir & "\Image\reborn.bmp",1,$a,$b,20)
				If $exit = 1 Then
					Select
						Case $reborn = 0
							Sleep(2000)
							send("{f4}")
							Exit
						Case $reborn = 1
							Sleep(1000)
							mousemove($a-10,$b+42,0)
							Sleep(200)
							MouseClick("left")
							Sleep(4000)
							Send("{down}")
							Sleep(1000)
							Local $tt = _ImageSearch(@ScriptDir & "\Image\sleep.bmp",0,$a,$b,5)
							If $tt = 1 Then
								mousemove($a,$b-5,0)
								MouseClick("left")
								mousemove(300,300,0)
								ToolTip("Ðã b?t chi?n d?u.",250,0)
							EndIf
							_SuperGlobalSet ('autox', 0)
							ExitLoop
						Case $reborn = 2
							If $delayreborn > 0 Then
								Select
									Case $delayreborn = 1
										ToolTip("Ðang delay 5 phút - vui lòng d?i.",250,0)
										Sleep(300000)
									Case $delayreborn = 2
										ToolTip("Ðang delay 15 phút - vui lòng d?i.",250,0)
										Sleep(900000)
								EndSelect
							EndIf
							Sleep(1000)
							mousemove($a-10,$b+65,0)
							Sleep(200)
							MouseClick("left")
							Sleep(2000)
							Send("{down}")
							Sleep(1000)
							send("{end 3}")
							Sleep(1000)
							Local $tt = _ImageSearch(@ScriptDir & "\Image\sleep.bmp",0,$a,$b,5)
							If $tt = 1 Then
								mousemove($a,$b-5,0)
								MouseClick("left")
								mousemove(300,300,0)
								ToolTip("Ðã b?t chi?n d?u.",250,0)
							EndIf
							_SuperGlobalSet ('autox', 0)
							ExitLoop
					EndSelect
				EndIf
			WEnd
			Case $trangthai = 2
				_Rebuff()
			EndSelect
EndFunc
Func _canceltarget()
	Send("{esc}")
	Sleep(1000)
EndFunc
Func _PickColor()
	Sleep(500)
		For $ix = 1 To 3
			For $i = 0 To 4
				If $color[$i] <> "" Then
					$pixel = PixelSearch($GHX1,$GHY1,$GHX2,$GHY2,$color[$i])
					If IsArray($pixel) Then
						Sleep(100)
						mousemove($pixel[0]+20,$pixel[1]+11,0)
						Sleep(100)
						mouseclick("left")
						Sleep(1000)
					EndIf
				Endif
			Next
		Next
EndFunc
Func _findmobx()
	Local $hwnd = WinGetHandle("[CLASS:X3DKernel]")
	Local $a = 0
	Local $b = 0
	Local $cam = _SuperGlobalGet ('camera',1)
	Local $phamvi = _SuperGlobalGet ('phamvi',1)
	Local $pick = _SuperGlobalGet ('pickx',1)
	Local $exitgamex = _SuperGlobalGet ('outgame',1)
	Local $party = _SuperGlobalGet ('autoparty',1)
	Local $item678 = _SuperGlobalGet ('itembuff',1)
	Local $zbuff = 6
	Local $AutoEnabled = _SuperGlobalGet ('enabled', true) 
	While 1
		If ($AutoEnabled) Then
			ToolTip("Running...", 250, 0)
			If $phamvi = 1 Then
				 $monster = _TargetFs(@ScriptDir & "\Image\hpmbar.bmp",0,$a,$b,0)
			Else
				 $monster = _TargetFs(@ScriptDir & "\Image\hpmbar.bmp",0,$a,$b,0)
			 EndIf
			ToolTip("Found", 250, 0)
			If $monster = 0 Then
				ToolTip("Not Found", 250, 0)
				$monster = _TargetGh(@ScriptDir & "\Image\hpmbar2.bmp",0,$a,$b,0)
				If $monster = 0 Then
					ToolTip("Not Found 2", 250, 0)
					If $cam = 1 Then
						send("{right}")
						Sleep(1000)
					EndIf
				Else
					ToolTip("Found 2", 250, 0)
				EndIf
			EndIf
			If $pick = 1 Then
				Send("{space}")
			EndIf
			If $item678 = 1 Then
				send($zbuff)
				$zbuff += 1
				If $zbuff > 8 Then
					$zbuff = 6
				EndIf
			EndIf
			Local $ngoaithuong = _ImageSearch(@ScriptDir & "\Image\nt.bmp",0,$a,$b,1)
			If $ngoaithuong = 1 Then
				send("9")
			EndIf
			Local $escbar = _ImageSearch(@ScriptDir & "\Image\esc.bmp",0,$a,$b,1)
			If $escbar  = 1 Then
				send("o")
			EndIf
			Local $exit = _TargetFs(@ScriptDir & "\Image\exit.bmp",0,$a,$b,10)
			If $exit = 1 Then
				ToolTip("D?ng chi?n d?u.",700,0)
				_SuperGlobalSet ('autox', 1)
			Else
				ToolTip("Ðang chi?n d?u 2.",700,0)
			EndIf
			Local $tt = _ImageSearch(@ScriptDir & "\Image\sleep.bmp",0,$a,$b,5)
								If $tt = 1 Then
									send("{tab}")
									EndIf
			If $exitgamex = 1 Then
				Local $pvp = _ImageSearch(@ScriptDir & "\Image\pvp.bmp",0,$a,$b,10)
					If $pvp = 1 Then
					ToolTip("PVP mode - out game",200,0)
					Run('"Off.exe" "DlSoloRoad"')
					send("{F4}")
				EndIf
			EndIf
			Local $aPos = MouseGetPos()
			If $aPos[0] = 0 Or $aPos[0] >= $aClientSize[0] Then
				;mousemove($gx1,$gy1,0)
			EndIf
			If $aPos[1] <= 5 Or $aPos[1] >= $aClientSize[1] Then
				;mousemove($gx1,$gy1,0)
			EndIf
		EndIf
	WEnd
EndFunc
Func _Timerb()
	Local $timex = _SuperGlobalGet ('timerbx',1)
		If $timex = 2 Then
			Sleep(900000)
		Else
			Sleep(300000)
		Endif
		_SuperGlobalSet ('autox', 2)
EndFunc
Func _Rebuff()
	Sleep(1000)
	Select
	Case $buffskill = 1
		Send("u")
		For $i = 1 To 3
			Send("^" & $i)
			If $i < 3 Then
				Sleep(4000)
			EndIf
		Next
		Send("{esc}")
		Sleep(100)
		Send("{esc}")
	Case $buffskill = 2
		Send("u")
		For $i = 1 To 5
			Send("^" & $i)
			If $i < 5 Then
				Sleep(4000)
			EndIf
		Next
		Send("{esc}")
		Sleep(100)
		Send("{esc}")
	EndSelect
	If $AutoMode = 6 Then
		_AutoReward()
	EndIf
	_SuperGlobalSet ('autox', 0)
	$rebuffx = _CoProc ('_Timerb')
EndFunc
Func _HP()
	Local $a,$b = 0
	Local $HPx = _ImageSearch(@ScriptDir & "\Image\hpchar.bmp",0,$a,$b,10)
	If $HPx = 0 Then
		send("u")
		Sleep(1500)
		send("0")
		Sleep(2000)
	EndIf
EndFunc
Func _AutoClick()
	ToolTip("AUTO9D.COM - AUTO CLICK",0,0)
	FileOpen($file2,0)
	Local $timeclick = FileReadLine($file2,1)
	FileClose($file2)
	WinActivate($hwnd)
		While 1
			If ($Auto_Enabled) Then
				MouseClick("Left")
				Sleep($timeclick*1000)
				send("{space}")
			EndIf
		WEnd
EndFunc
Func _AutoTrap()
	Local $x = 0
	Local $y = 0
	Local $dtrap = 0
	FileOpen($file2,0)
	For $i = 1 to _FileCountLines($file2)
    Local $line = FileReadLine($file2, $i)
		Select
			Case $i = 1
				Local $trapmode = $line
			Case $i = 2
				Local $delay1 = $line
			Case $i = 3
				Local $cool1 = $line
			Case $i = 4
				Local $delay2 = $line
			Case $i = 5
				Local $cool2 = $line
			Case $i = 6
				Local $ptrap = $line
		EndSelect
	Next
	FileClose($file2)
	WinActivate($hwnd)
	Sleep(500)
	send("{down 5}")
	Sleep(100)
	send("{end 6}")
	Sleep(100)
	Local $Hpchar = _ImageSearch(@ScriptDir & "\Image\Hpbarchar.bmp",1,$x,$y,20)
	If $Hpchar = 1 Then
		mousemove($x,$y,0)
	Select
	ToolTip("AUTO9D.COM - AUTO TRAP",0,0)
	Case $trapmode = 1
		Local $xleft = $x + 50
		Local $coolx1 = $cool1*1000
		While 1
		send("1")
		Sleep(100)
		DllCall("GPPMX.dll", "int", "PMX", "hwnd", $hwnd, "int", 0x200, "int", 0x1, "long", $xleft + $y * 0x10000)
		Sleep(10)
		MouseClick("Left")
		Sleep($delay1*1000 + 2000)
		$dtrap += 1
		If $dtrap >= $ptrap Then
			$dtrap = 0
			ToolTip('Regen1',200,0,0,1)
			_regenx()
		Else
			Sleep(500)
			send("3")
			Sleep($coolx1)
		EndIf
		WEnd
	Case $trapmode = 2
		Local $xleft = $x - 200
		Local $xright = $x + 300
		Local $coolx2 = ($cool2*1000) - ($delay2*1000+2000)
		While 1
		send("1")
		Sleep(100)
		MouseMove($xleft,$y,0)
		Sleep(200)
		MouseClick("Left")
		Sleep($delay1*1000 + 2000)
		$dtrap += 1
		If $dtrap >= $ptrap Then
			$dtrap = 0
			ToolTip('Regen2',200,0,0,1)
			_regenx()
		Else
			send("3")
			Sleep(1500)
			Send("2")
		EndIf
		Sleep(100)
		MouseMove($xright,$y,0)
		Sleep(200)
		MouseClick("Left")
		Sleep($delay2*1000 +2000)
		$dtrap += 1
		ToolTip('Trap',200,0,$dtrap,1)
		If $dtrap >= $ptrap Then
			$dtrap = 0
			ToolTip('Regen2',200,0,0,1)
			_regenx()
		Else
			Sleep(500)
			send("3")
			Sleep($coolx2)
		EndIf
		WEnd
	EndSelect
	Else
		msgbox(0,0,"Vui lòng b?t: Hi?n sinh m?nh khi dang chi?n d?u")
	EndIf
EndFunc
Func _regenx()
	ToolTip("AUTO9D.COM - MEDITATION",0,0)
	Sleep(1000)
	Send("p")
	Local $x = 0
	Local $y = 0
	While 1
		Local $mana = _ImageSearch(@ScriptDir & "\mana.bmp",1,$x,$y,1)
		If $mana = 1 Then
			Sleep(5000)
			ExitLoop
		EndIf
	Wend
EndFunc
Func _AutoSkill()
	WinActivate($hwnd)
	FileOpen($file2,0)
	Local $rsk = 0
	Local $arsk = FileReadLine($file2, 11)
	ToolTip("AUTO9D.COM - AUTO SKILL",0,0)
	While 1
		If ($Auto_Enabled) Then
			For $i = 1 to 10
			Local $line = FileReadLine($file2, $i)
				If $line > 0 Then
					send($i)
					$rsk+=1
					Sleep($line*1000)
				EndIf
				If $rsk >= $arsk Then
					$rsk = 0
					_regenx()
				EndIf
			Next
			$i=1
		EndIf
	Wend
	FileClose($file2)
EndFunc
Func _AutoReward()
	ToolTip("AUTO9D.COM - AUTO REWARD",0,0)
	FileOpen($file2,0)
	Local $row = FileReadLine($file2, 1)
	FileClose($file2)
	WinActivate($hwnd)
	Local $x = 0
	Local $y = 0
	send("h")
	Sleep(1000)
	Local $reward = _ImageSearch(@ScriptDir & "\Image\reward2.bmp",1,$x,$y,40)
	If $reward = 1 Then
		Select
		Case $row = 1
			$y-= 25
		Case $row = 2
			$y -= 5
		Case $row = 3
			$y += 15
		Case $row = 4
			$y += 30
		Case $row = 5
			$y += 45
		Case $row = 6
			$y += 60
		EndSelect
		Sleep(100)
		mousemove($x,$y,0)
		Sleep(100)
		MouseClick("left")
		Sleep(1500)
		$button = _ImageSearch(@ScriptDir & "\Image\button2.bmp",1,$x,$y,20)
		If $button = 1 Then
			Sleep(100)
			Send("{tab}")
			$y -= 25
			Sleep(200)
			mousemove($x,$y,0)
			Sleep(500)
			MouseClick("left")
			Sleep(500)
			Send("{enter}")
			Sleep(500)
			Send("{tab}")
			Sleep(500)
			Send("h")
		Else
				Sleep(500)
				send("h")
		EndIf
	Else
		send("h")
		Sleep(1000)
	EndIf
EndFunc
Func _AutoRewardx()
	ToolTip("AUTO9D.COM - AUTO REWARD",0,0)
	FileOpen($file2,0)
	Local $row = FileReadLine($file2, 1)
	FileClose($file2)
	WinActivate($hwnd)
	While 1
		
		If ($Auto_Enabled) Then
			Local $x = 0
			Local $y = 0
			send("h")
			Sleep(1000)
			Local $reward = _ImageSearch(@ScriptDir & "\Image\reward2.bmp",1,$x,$y,20)
			If $reward = 1 Then
				Select
				Case $row = 1
					$y-= 25
				Case $row = 2
					$y -= 5
				Case $row = 3
					$y += 15
				Case $row = 4
					$y += 30
				Case $row = 5
					$y += 45
				Case $row = 6
					$y += 60
				EndSelect
				Sleep(100)
				mousemove($x,$y,0)
				Sleep(100)
				MouseClick("left")
				Sleep(2000)
				$button = _ImageSearch(@ScriptDir & "\Image\button2.bmp",1,$x,$y,20)
				If $button = 1 Then
					Sleep(100)
					Send("{tab}")
					$y -= 25
					Sleep(200)
					mousemove($x,$y,0)
					Sleep(500)
					MouseClick("left")
					Sleep(500)
					Send("{enter}")
					Sleep(500)
					Send("{tab}")
					Sleep(500)
					Send("h")
				Else
						Sleep(500)
						send("h")
				EndIf
			Else
				send("h")
			EndIf
			MouseMove(500,200,0)
			Sleep(60000)
		EndIf
	WEnd
EndFunc
