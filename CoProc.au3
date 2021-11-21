
#ce
Global $gs_SuperGlobalRegistryBase = "HKEY_CURRENT_USER\Software\AutoIt v3\CoProc"
Global $gi_CoProcParent = 0
Global $gs_CoProcReciverFunction = ""
Global $gv_CoProcReviverParameter = 0
Func _CoProc($sFunction = Default, $vParameter = Default)
	Local $iPid, $iOldRunErrorsFatal
	If IsKeyword($sFunction) Or $sFunction = "" Then $sFunction = "__CoProcDummy"
	EnvSet("CoProc", "0x" & Hex(StringToBinary ($sFunction)))
	EnvSet("CoProcParent", @AutoItPID)
	If Not IsKeyword($vParameter) Then
		EnvSet("CoProcParameterPresent", "True")
		EnvSet("CoProcParameter", StringToBinary ($vParameter))
	Else
		EnvSet("CoProcParameterPresent", "False")
	EndIf
	If @Compiled Then
		$iPid = Run(FileGetShortName(@AutoItExe), @WorkingDir, @SW_HIDE, 1 + 2 + 4)
	Else
		$iPid = Run(FileGetShortName(@AutoItExe) & ' "' & @ScriptFullPath & '"', @WorkingDir, @SW_HIDE, 1 + 2 + 4)
	EndIf
	If @error Then SetError(1)
	Return $iPid
EndFunc
Func _SuperGlobalSet($sName, $vValue = Default, $sRegistryBase = Default)
	Local $vTmp
	If $sRegistryBase = Default Then $sRegistryBase = $gs_SuperGlobalRegistryBase
	If $vValue = "" Or $vValue = Default Then
		RegDelete($sRegistryBase, $sName)
		If @error Then Return SetError(2, 0, False)
	Else
		RegWrite($sRegistryBase, $sName, "REG_SZ",$vValue)
		If @error Then Return SetError(2, 0, False)
	EndIf
	Return True
EndFunc
Func _SuperGlobalGet($sName, $fOption = Default, $sRegistryBase = Default)
	Local $vTmp
	If $fOption = "" Or $fOption = Default Then $fOption = False
	If $sRegistryBase = Default Then $sRegistryBase = $gs_SuperGlobalRegistryBase
	$vTmp = RegRead($sRegistryBase, $sName)
	If @error Then Return SetError(1, 0, "")
	If $fOption Then
		_SuperGlobalSet($sName)
		If @error Then SetError(2)
	EndIf
	Return $vTmp
EndFunc
Func _ProcSuspend($vProcess, $iReserved = 0)
	Local $iPid, $vTmp, $hThreadSnap, $ThreadEntry32, $iThreadID, $hThread, $iThreadCnt, $iThreadCntSuccess, $sFunction
	Local $TH32CS_SNAPTHREAD = 0x00000004
	Local $INVALID_HANDLE_VALUE = 0xFFFFFFFF
	Local $THREAD_SUSPEND_RESUME = 0x0002
	Local $THREADENTRY32_StructDef = "int;" _
			 & "int;" _
			 & "int;" _
			 & "int;" _
			 & "int;" _
			 & "int;" _
			 & "int"
	$iPid = ProcessExists($vProcess)
	If Not $iPid Then Return SetError(1, 0, False)
	$vTmp = DllCall("kernel32.dll", "ptr", "CreateToolhelp32Snapshot", "int", $TH32CS_SNAPTHREAD, "int", 0)
	If @error Then Return SetError(2, 0, False)
	If $vTmp[0] = $INVALID_HANDLE_VALUE Then Return SetError(2, 0, False)
	$hThreadSnap = $vTmp[0]
	$ThreadEntry32 = DllStructCreate($THREADENTRY32_StructDef)
	DllStructSetData($ThreadEntry32, 1, DllStructGetSize($ThreadEntry32))
	$vTmp = DllCall("kernel32.dll", "int", "Thread32First", "ptr", $hThreadSnap, "long", DllStructGetPtr($ThreadEntry32))
	If @error Then Return SetError(3, 0, False)
	If Not $vTmp[0] Then
		DllCall("kernel32.dll", "int", "CloseHandle", "ptr", $hThreadSnap)
		Return SetError(3, 0, False)
	EndIf
	While 1
		If DllStructGetData($ThreadEntry32, 4) = $iPid Then
			$iThreadID = DllStructGetData($ThreadEntry32, 3)
			$vTmp = DllCall("kernel32.dll", "ptr", "OpenThread", "int", $THREAD_SUSPEND_RESUME, "int", False, "int", $iThreadID)
			If Not @error Then
				$hThread = $vTmp[0]
				If $hThread Then
					If $iReserved Then
						$sFunction = "ResumeThread"
					Else
						$sFunction = "SuspendThread"
					EndIf
					$vTmp = DllCall("kernel32.dll", "int", $sFunction, "ptr", $hThread)
					If $vTmp[0] <> -1 Then $iThreadCntSuccess += 1
					DllCall("kernel32.dll", "int", "CloseHandle", "ptr", $hThread)
				EndIf
			EndIf
			$iThreadCnt += 1
		EndIf
		$vTmp = DllCall("kernel32", "int", "Thread32Next", "ptr", $hThreadSnap, "long", DllStructGetPtr($ThreadEntry32))
		If @error Then Return SetError(4, 0, False)
		If Not $vTmp[0] Then ExitLoop
	WEnd
	DllCall("kernel32.dll", "int", "CloseToolhelp32Snapshot", "ptr", $hThreadSnap)
	If Not $iThreadCntSuccess Or $iThreadCnt > $iThreadCntSuccess Then Return SetError(5, $iThreadCnt, $iThreadCntSuccess)
	Return SetError(0, $iThreadCnt, $iThreadCntSuccess)
EndFunc
Func _ProcResume($vProcess)
	Local $fRval = _ProcSuspend($vProcess, True)
	Return SetError(@error, @extended, $fRval)
EndFunc
Func _ProcessGetWinList($vProcess, $sTitle = Default, $iOption = 0)
	Local $aWinList, $iCnt, $aTmp, $aResult[1], $iPid, $fMatch, $sClassname
	$iPid = ProcessExists($vProcess)
	If Not $iPid Then Return SetError(1)
	If $sTitle = "" Or IsKeyword($sTitle) Then
		$aWinList = WinList()
	Else
		$aWinList = WinList($sTitle)
	EndIf
	For $iCnt = 1 To $aWinList[0][0]
		$hWnd = $aWinList[$iCnt][1]
		$iProcessId = WinGetProcess($hWnd)
		If $iProcessId = $iPid Then
			If $iOption = 0 Or IsKeyword($iOption) Or $iOption = 16 Then
				$fMatch = True
			Else
				$fMatch = False
				$sClassname = DllCall("user32.dll", "int", "GetClassName", "hwnd", $hWnd, "str", "", "int", 1024)
				If @error Then Return SetError(3)
				If $sClassname[0] = 0 Then Return SetError(3)
				$sClassname = $sClassname[2]
				If BitAND($iOption, 2) Then
					If $sClassname = "AutoIt v3 GUI" Then $fMatch = True
				EndIf
				If BitAND($iOption, 4) Then
					If $sClassname = "AutoIt v3" Then $fMatch = True
				EndIf
			EndIf
			If $fMatch Then
				If BitAND($iOption, 16) Then Return $hWnd
				ReDim $aResult[UBound($aResult) + 1]
				$aResult[UBound($aResult) - 1] = $hWnd
			EndIf
		EndIf
	Next
	$aResult[0] = UBound($aResult) - 1
	If $aResult[0] < 1 Then Return SetError(2, 0, 0)
	Return $aResult
EndFunc
Func _CoProcReciver($sFunction = Default)
	Local $sHandlerFuction = "__CoProcReciverHandler", $hWnd, $aTmp
	If IsKeyword($sFunction) Then $sFunction = ""
	$hWnd = _ProcessGetWinList(@AutoItPID, "", 16 + 2)
	If Not IsHWnd($hWnd) Then
		$hWnd = GUICreate("CoProcEventReciver")
		If @error Then Return SetError(1, 0, False)
	EndIf
	If $sFunction = "" Or IsKeyword($sFunction) Then $sHandlerFuction = ""
	If Not GUIRegisterMsg(0x4A, $sHandlerFuction) Then Return SetError(2, 0, False)
	If Not GUIRegisterMsg(0x400 + 0x64, $sHandlerFuction) Then Return SetError(2, 0, False)
	$gs_CoProcReciverFunction = $sFunction
	Return True
EndFunc
Func __CoProcReciverHandler($hWnd, $iMsg, $WParam, $LParam)
	If $iMsg = 0x4A Then
		Local $COPYDATA, $MyData
		$COPYDATA = DllStructCreate("ptr;dword;ptr", $LParam)
		$MyData = DllStructCreate("char[" & DllStructGetData($COPYDATA, 2) & "]", DllStructGetData($COPYDATA, 3))
		$gv_CoProcReviverParameter = DllStructGetData($MyData, 1)
		Return 256
	ElseIf $iMsg = 0x400 + 0x64 Then
		If $gv_CoProcReviverParameter Then
			Call($gs_CoProcReciverFunction, $gv_CoProcReviverParameter)
			If @error And @Compiled = 0 Then MsgBox(16, "CoProc Error", "Unable to Call: " & $gs_CoProcReciverFunction)
			$gv_CoProcReviverParameter = 0
			Return 0
		EndIf
	EndIf
EndFunc
Func _CoProcSend($vProcess, $vParameter, $iTimeout = 500, $fAbortIfHung = True)
	Local $iPid, $hWndTarget, $MyData, $aTmp, $COPYDATA, $iFuFlags
	$iPid = ProcessExists($vProcess)
	If Not $iPid Then Return SetError(1, 0, False)
	$hWndTarget = _ProcessGetWinList($vProcess, "", 16 + 2)
	If @error Or (Not $hWndTarget) Then Return SetError(2, 0, False)
	$MyData = DllStructCreate("char[" & StringLen($vParameter) + 1 & "]")
	$COPYDATA = DllStructCreate("ptr;dword;ptr")
	DllStructSetData($MyData, 1, $vParameter)
	DllStructSetData($COPYDATA, 1, 1)
	DllStructSetData($COPYDATA, 2, DllStructGetSize($MyData))
	DllStructSetData($COPYDATA, 3, DllStructGetPtr($MyData))
	If $fAbortIfHung Then
		$iFuFlags = 0x2
	Else
		$iFuFlags = 0x0
	EndIf
	$aTmp = DllCall("user32.dll", "int", "SendMessageTimeout", "hwnd", $hWndTarget, "int", 0x4A _
			, "int", 0, "ptr", DllStructGetPtr($COPYDATA), "int", $iFuFlags, "int", $iTimeout, "long*", 0)
	If @error Then Return SetError(3, 0, False)
	If Not $aTmp[0] Then Return SetError(3, 0, False)
	If $aTmp[7] <> 256 Then Return SetError(3, 0, False)
	$aTmp = DllCall("user32.dll", "int", "PostMessage", "hwnd", $hWndTarget, "int", 0x400 + 0x64, "int", 0, "int", 0)
	If @error Then Return SetError(4, 0, False)
	If Not $aTmp[0] Then Return SetError(4, 0, False)
	Return True
EndFunc
Func _ConsoleForward($iPid1, $iPid2 = Default, $iPid3 = Default, $iPid4 = Default, $iPid5 = Default, $iPid6 = Default, $iPid7 = Default, $iPid8 = Default, $iPid9 = Default, $iPid10 = Default, $iPid11 = Default, $iPid12 = Default, $iPid13 = Default, $iPid14 = Default, $iPid15 = Default, $iPid16 = Default)
	Local $iPid, $i, $iPeek
	For $i = 1 To 16
		$iPid = Eval("iPid" & $i)
		If $iPid = Default Or Not $iPid Then ContinueLoop
		If ProcessExists($iPid) Then
			$iPeek = StdoutRead($iPeek, 0, True)
			If Not @error And $iPeek > 0 Then
				ConsoleWrite(StdoutRead($iPid))
			EndIf
			$iPeek = StderrRead($iPeek, 0, True)
			If Not @error And $iPeek > 0 Then
				ConsoleWriteError(StderrRead($iPid))
			EndIf
		EndIf
	Next
EndFunc
Func _ProcessEmptyWorkingSet($vPid = @AutoItPID, $hDll_psapi = "psapi.dll", $hDll_kernel32 = "kernel32.dll")
	Local $av_EWS, $av_OP, $iRval
	If $vPid = -1 Then
		$av_EWS = DllCall($hDll_psapi, "int", "EmptyWorkingSet", "ptr", -1)
	Else
		$vPid = ProcessExists($vPid)
		If Not $vPid Then Return SetError(1, 0, 0)
		$av_OP = DllCall($hDll_kernel32, "int", "OpenProcess", "dword", 0x1F0FFF, "int", 0, "dword", $vPid)
		If $av_OP[0] = 0 Then Return SetError(2, 0, 0)
		$av_EWS = DllCall($hDll_psapi, "int", "EmptyWorkingSet", "ptr", $av_OP[0])
		DllCall($hDll_kernel32, "int", "CloseHandle", "int", $av_OP[0])
	EndIf
	If $av_EWS[0] Then
		Return $av_EWS[0]
	Else
		Return SetError(3, 0, 0)
	EndIf
EndFunc
Func _DuplicateHandle($dwSourcePid, $hSourceHandle, $dwTargetPid = @AutoItPID, $fCloseSource = False)
	Local $hTargetHandle, $hPrSource, $hPrTarget, $dwOptions
	$hPrSource = __dh_OpenProcess($dwSourcePid)
	$hPrTarget = __dh_OpenProcess($dwTargetPid)
	If $hPrSource = 0 Or $hPrTarget = 0 Then
		_CloseHandle($hPrSource)
		_CloseHandle($hPrTarget)
		Return SetError(1, 0, 0)
	EndIf
	If $fCloseSource <> False Then
		$dwOptions = 0x01 + 0x02
	Else
		$dwOptions = 0x02
	EndIf
	$hTargetHandle = DllCall("kernel32.dll", "int", "DuplicateHandle", "ptr", $hPrSource, "ptr", $hSourceHandle, "ptr", $hPrTarget, "long*", 0, "dword", 0, "int", 1, "dword", $dwOptions)
	If @error Then Return SetError(2, 0, 0)
	If $hTargetHandle[0] = 0 Or $hTargetHandle[4] = 0 Then
		_CloseHandle($hPrSource)
		_CloseHandle($hPrTarget)
		Return SetError(2, 0, 0)
	EndIf
	Return $hTargetHandle[4]
EndFunc
Func __dh_OpenProcess($dwProcessId)
	Local $hPr = DllCall("kernel32.dll", "ptr", "OpenProcess", "dword", 0x40, "int", 0, "dword", $dwProcessId)
	If @error Then Return SetError(1, 0, 0)
	Return $hPr[0]
EndFunc
#region Internal Functions
Func __CoProcStartup()
	Local $sCmd = EnvGet("CoProc")
	If StringLeft($sCmd, 2) = "0x" Then
		$sCmd = BinaryToString ($sCmd)
		$gi_CoProcParent = Number(EnvGet("CoProcParent"))
		If StringInStr($sCmd, "(") And StringInStr($sCmd, ")") Then
			Execute($sCmd)
			If @error And Not @Compiled Then MsgBox(16, "CoProc Error", "Unable to Execute: " & $sCmd)
			Exit
		EndIf
		If EnvGet("CoProcParameterPresent") = "True" Then
			Call($sCmd, BinaryToString (EnvGet("CoProcParameter")))
			If @error And Not @Compiled Then MsgBox(16, "CoProc Error", "Unable to Call: " & $sCmd & @LF & "Parameter: " & BinaryToString (EnvGet("CoProcParameter")))
		Else
			Call($sCmd)
			If @error And Not @Compiled Then MsgBox(16, "CoProc Error", "Unable to Call: " & $sCmd)
		EndIf
		Exit
	EndIf
EndFunc
Func __CoProcDummy($vPar = Default)
	If Not IsKeyword($vPar) Then _CoProcReciver($vPar)
	While ProcessExists($gi_CoProcParent)
		Sleep(500)
	WEnd
EndFunc
__CoProcStartup()