;Displays a splash window (transparent and unfocusable) with custom text and delay.
Display_TransparentSplash(text, delay){
  Gui +LastFound +AlwaysOnTop -Caption +ToolWindow  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
  Gui, Color, FFFFFF ; set initial color for TransColor to work properly.
  WinSet, TransColor, FFFFFF 200
  Gui, Font, s32  ; Set a large font size (32-point).
  Gui, Add, Text, cLime, %text%
  Gui, show, x0 y0 NoActivate
  Sleep %delay%
  Gui Destroy
  return
}

Display_TransparentMenu(text){
  Gui +LastFound +AlwaysOnTop -Caption +ToolWindow  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
  Gui, Color, FFFFFF ; set initial color for TransColor to work properly.
  WinSet, TransColor, FFFFFF 200
  Gui, Font, s32  ; Set a large font size (32-point).
  Gui, Add, Text, cLime, %text%
  Gui, show, x0 y0
  Input, option, L1, {LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{CapsLock}{NumLock}{PrintScreen}{Pause}
  Gui Destroy
  return %option%
}
