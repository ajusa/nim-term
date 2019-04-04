import os, strformat, system, strutils
import illwill

proc exitProc() {.noconv.} =
  illwillDeinit()
  quit(0)

var str = ""


illwillInit(fullscreen=true)
setControlCHook(exitProc)

while true:
  var tb = newTerminalBuffer(terminalWidth(), terminalHeight())
  tb.write(0,0, str)
  var key = getKey()
  case key
  of Key.Backspace: 
    str.delete(str.len, str.len)
  of Key.Enter:
    tb.setCursorYPos(tb.getCursorYPos() + 1)
  of Key.Left, Key.Right, Key.Up, Key.Down, Key.None: discard
  else: str &= chr(min(ord key, 255))
  tb.display()
  sleep(20)

