;Saves current clipboard to memory, copies the selection and returns the
;clipboard if you want to restore the clipboard after use.
IO_QuickGrabSelection()
{
  tempclip = %clipboard%
  clipboard = ;
  Send ^c
  ClipWait, 2
  if ErrorLevel
  {
      MsgBox, The attempt to copy text onto the clipboard failed.
      clipboard = %tempclip%
      return
  }
  selection = %clipboard%
  clibpoard = %tempclip%
  return %selection%
}
