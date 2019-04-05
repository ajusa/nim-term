import os, strformat, system, strutils, unicode
import illwill

proc exitProc() {.noconv.} =
  illwillDeinit()
  quit(0)

var str = getEnv("DYNALIST_KEY")
illwillInit(fullscreen=true)
setControlCHook(exitProc)

proc writeWrap(tb: var TerminalBuffer, x, y: Natural, s: string): Natural =
  var lines = wordWrap(s, tb.width - x).splitLines()
  for i, str in lines: tb.write(x, y + i, str)
  return y + lines.len #last line we write to

while true:
  var tb = newTerminalBuffer(terminalWidth(), terminalHeight())
  discard tb.writeWrap(10,0, str)
  #tb.write(0,1, $tb[0, 0].ch)
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

