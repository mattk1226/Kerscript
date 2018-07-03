;Validates an IP, returns boolean.
IP_ValidIP(ByRef IPAddress){
	if (StrLen(IPAddress) > 15)
		Valid=0

	IfInString, IPAddress, %A_Space%
		Valid=0

	StringSplit, Octets, IPAddress, .
	if (Octets0 <> 4)
		Valid=0
	else if (Octets1 < 1 || Octets1 > 255)
		Valid=0
	else if (Octets2 < 0 || Octets2 > 255)
		Valid=0
	else if (Octets3 < 0 || Octets3 > 255)
		Valid=0
	else if (Octets4 < 0 || Octets4 > 255)
		Valid=0
	else Valid=1

	Oct1:=Octets1*0
	Oct2:=Octets2*0
	Oct3:=Octets3*0
	Oct4:=Octets4*0

	if (Oct1 <> 0 || Oct2 <> 0 || Oct3 <> 0 || Oct4 <> 0)
		Valid=0

	return %Valid%
}

;Validates an IP and breaks running script if invalid.
IP_CheckIPPrompt(ip){
	if not IP_ValidIP(ip)
	{
	    InputBox, ip, Clipboard Data, Please enter a valid IP address, , 200, 150 , , , , , 8.8.8.8
	}
	return %ip%
}

IP_Ping(){
	Display_TransparentSplash("Ping", 2000)
	ip := IO_QuickGrabSelection()
	ip := IP_CheckIPPrompt(ip)
	Runwait,%comspec% /k ping %ip% -t
	return
}

IP_Traceroute(){
	Display_TransparentSplash("Traceroute", 2000)
	ip := IO_QuickGrabSelection()
	ip := IP_CheckIPPrompt(ip)
	Runwait,%comspec% /k tracert -d %ip%
	return
}
;Displays onscreen menu with
IP_Tools(){
	options := "Kerscript IP Tools:`n1. Ping`n2. Traceroute`n3. Whois `n4. Subnet Calc"
	option := Display_TransparentMenu(options)
	if (option = 1){
		IP_Ping()
	}
	if (option = 2){
		IP_Traceroute()
	}
	if (option = 3){
		IP_WhoIs()
	}
	if (option = 4){
		IP_SubnetCalc()
	}
}

;Displays message box with Whois information from ARIN
IP_WhoIs(){
	ip := IO_QuickGrabSelection()
	ip := IP_CheckIPPrompt(ip)
	if ErrorLevel{
		Exit
	}
	url := "http://whois.arin.net/rest/ip/" . ip . ".txt"
	; Example: Download text to a variable:
	whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
  whr.Open("GET", url, true)
  whr.Send()
  ; Using 'true' above and the call below allows the script to remain responsive.
  whr.WaitForResponse()
  whoisresponse := whr.ResponseText
	MsgBox, , Whois %ip%, %whoisresponse%
	return
}

;Uses api.hackertarget.com to quickly help with subnet summarization.
IP_SubnetCalc(){
	;get clipboard
	selection := IO_QuickGrabSelection()
	selection := RegExReplace(selection, "\s+", " ")
	;split by / to check for cidr notation or subnet mask
	ipArray := StrSplit(selection,["/"," "])
	ip := StrReplace(ipArray[1], A_Space, "")
	; If the clipboard data isn't valid, get IP and subnet info.
	if not IP_ValidIP(ip){
		ip := IP_CheckIPPrompt(ip)
		InputBox, subnet, Missing Subnet Info, CIDR or Subnet Mask, , 200, 150 , , , , , 255.255.255.248
		If ErrorLevel{
			Exit
		}
	}
	; Otherwise Check if clipboard contains subnet size information, if not, get it.
	else if (ipArray.Length() < 2){
		InputBox, subnet, Missing Subnet Info, CIDR or Subnet Mask, , 200, 150 , , , , , 255.255.255.248
		If ErrorLevel{
			Exit
		}
	}
  else {
		subnet := StrReplace(ipArray[2], A_Space, "")
	}
	if not ((subnet >= 0 and <= 32) or IP_ValidIP){
		{
		    MsgBox, , Cidr or Mask Error, %subnet% is not a valid CIDR or Subnet Mask.
		    Exit
		}
	}
	url := "https://api.hackertarget.com/subnetcalc/?q=" . ip . "/" . subnet
	whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	whr.Open("GET", url, true)
	whr.Send()
	whr.WaitForResponse()
	subnetInfo := whr.ResponseText
  MsgBox, , Subnet Information, %subnetInfo%
	return
}
