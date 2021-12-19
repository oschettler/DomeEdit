// Dome Editor

import "graphics" for Canvas, Color
import "font" for Font
import "dome" for Platform, Window
import "io" for FileSystem 

// var DefaultFont = "/usr/share/fonts/truetype/piboto/Piboto-Regular.ttf"
var DefaultFont = "/usr/share/fonts/truetype/noto/NotoMono-Regular.ttf"
var FontSize = 14
var GutterWidth = 20
var BackgroundColor = Color.black

class Cursor {
  x { _x }
  y { _y }
  w { _w }
  h { _h }

  construct new() {
    _x = 0 + GutterWidth
    _y = 0
    _w = 10
    _h = FontSize
  }
}

class Text {

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
    lines.addAll(Text.fit(line[split...line.count], width)
    
    return lines
  }

  cursor(x, y) {
    return Cursor.new() 
  }

  print() {
    var y = 0
    var lineNumber = 1
    
    for (line in lines) {
      Canvas.print(lineNumber, 0, y, Color.green)
      for (shortLine in Text.fit(line, Canvas.width)) {
        Canvas.print(shortLine, GutterWidth, y, Color.white)
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
    _text = Text.load("README.md")
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
    _text.print()

    var cursor = _text.cursor(_x, _y)
    if (_cursorOn) {
      Canvas.rect(cursor.x, cursor.y, cursor.w, cursor.h, Color.green)
    }
  }
}

var Game = Main.new()
