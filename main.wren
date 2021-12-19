// Dome Editor

import "graphics" for Canvas, Color
import "font" for Font
import "dome" for Platform, Window
import "io" for FileSystem 

// var DefaultFont = "/usr/share/fonts/truetype/piboto/Piboto-Regular.ttf"
var DefaultFont = "/usr/share/fonts/truetype/noto/NotoMono-Regular.ttf"
var FontSize = 14
var BackgroundColor = Color.black

class Cursor {
  x { _x }
  y { _y }
  w { _w }
  h { _h }

  construct new(x, y) {
    _x = x
    _y = y
    _w = 10
    _h = FontSize
  }
}

class Text {

  // https://rosettacode.org/wiki/Category_talk:Wren-fmt
  rjust(s, w) {
    var c = s.count
    return (w > c) ? " " * (w - c) + s : s
  }

  gutterWidth {
    var area = Canvas.getPrintArea(_lines.count.max(10).toString)
    return area.x + 4
  }

  gutterPrint(lineNumber, y) {
    var w = _lines.count.max(10).toString.count
    Canvas.print(rjust(lineNumber.toString, w), 2, y, Color.white)
  }

  construct new(text) {
    _lines = text.split("\n")
  }

  static load(fileName) {
    return Text.new(FileSystem.load(fileName))
  }

  static fit(line, width) {
    var area = Canvas.getPrintArea(line)
    
    if (area.x < width) {
      return [ line ]
    }
    
    var split = (line.count * width / area.x).floor

    var lines = Text.fit(line[0...split], width)
    lines.addAll(Text.fit(line[split...line.count], width))
    
    return lines
  }

  cursor(x, y) {
    return Cursor.new(x + gutterWidth, y) 
  }

  print() {
    var y = 6
    var lineNumber = 1

    for (line in _lines) {
      gutterPrint(lineNumber, y)
      for (shortLine in Text.fit(line, Canvas.width - gutterWidth - 4)) {
        Canvas.print(shortLine, gutterWidth + 2, y, Color.white)
        y = y + FontSize + 4
      }
      lineNumber = lineNumber + 1
    }
  }
}

class Main {

  construct new() {}

  init() {
    Font.load("default", DefaultFont, FontSize)
    Font["default"].antialias = true
    Canvas.font = "default"

    _fileName = "README.md"

    _text = Text.load(_fileName)
    _x = 0
    _y = 0
    _cursorOn = true
  }

  update() {
    if (Canvas.width != Window.width || Canvas.height != Window.height) {
      System.print("Resize -> %(Window.width), %(Window.height)")
      Canvas.resize(Window.width, Window.height, BackgroundColor)
    }
    _cursorOn = Platform.time % 2 == 1
  }

  draw(alpha) {
    Canvas.cls(BackgroundColor)

    var gutterWidth = _text.gutterWidth

    // Status line
    var statusY = Canvas.height - FontSize - 4
    Canvas.rectfill(0, statusY, Canvas.width, FontSize + 4, Color.darkblue)
    Canvas.print("%(_fileName) %(_y+1):%(_x+1)", 4, statusY + 6, Color.white)

    // Gutter
    Canvas.rectfill(0, 0, gutterWidth, Canvas.height - FontSize - 4, Color.darkblue)
    _text.print()

    var cursor = _text.cursor(_x, _y)
    if (_cursorOn) {
      Canvas.rect(cursor.x, cursor.y, cursor.w, cursor.h, Color.green)
    }
  }
}

var Game = Main.new()
