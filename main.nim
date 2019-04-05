import os, strformat, system, strutils, unicode
import illwill

type Pos = tuple[x: int, y: int]

proc exitProc() {.noconv.} =
  illwillDeinit()
  showCursor()
  quit(0)

var str = readFile("dynalist_key")
illwillInit(fullscreen=true)
setControlCHook(exitProc)

proc writeWrap(tb: var TerminalBuffer, x, y: int, s: string): Pos {.discardable.} =
  var lines = wordWrap(s.replace("\r", ""), tb.width - x).splitLines()
  for i, str in lines: tb.write(x, y + i, str)
  return (lines[^1].len, y + lines.len) #last line we write to
var pos: Pos = (0,0)
hideCursor()
while true:
  var tb = newTerminalBuffer(terminalWidth(), terminalHeight())
  tb.writeWrap(10,0, str)
  tb.setBackgroundColor(bgRed)
  tb.write(0, tb.height - 1, "ESC to quit")
  var key = getKey()
  case key
  of Key.Backspace: str.delete(str.len, str.len)
  #of Key.Enter:
  of Key.Left: pos.x = max(0, pos.x-1)
  of Key.Up: pos.y = max(0, pos.y-1)
  of Key.Down: pos.y = min(tb.height-1, pos.y+1)
  of Key.Right: pos.x = min(tb.width-1, pos.x+1)
  of Key.Escape: exitProc()
  of Key.None: discard
  else: str &= chr(min(ord key, 255))
  var ch = tb[pos.x,pos.y]
  ch.bg = bgWhite
  ch.fg = fgBlack
  tb[pos.x,pos.y] = ch
  tb.display()
  sleep(20)

