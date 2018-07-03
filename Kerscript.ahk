#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Display_TransparentSplash("Starting Script...", 2000)

CapsLock:: ; IP Tools
  IP_Tools()
  return

!f11:: ; Alt + F11 - TEST KEY AT THIS TIME
  IP_Tools()
  return

!f12:: ; Alt+F12 - Unending ping against selected text, restores clipboard.
  IP_Traceroute()
  return

^!f12:: ; Ctrl+Alt+F12 - Ping 8.8.8.8
  Display_TransparentSplash("Pinging Google DNS...", 2000)
  Runwait,%comspec% /k ping 8.8.8.8
  return

pgdn:: ; Page Down - Restart Script
  Display_TransparentSplash("Restarting Script...", 500)
  Sleep 500
  Reload
  return

^pgdn:: ; Ctrl+Page Down - Exit Script
  ExitApp
