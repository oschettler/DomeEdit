// Dome Editor

import "io" for FileSystem 
import "graphics" for Canvas, Color
import "font" for Font
import "dome" for Platform

// var DefaultFont = "/usr/share/fonts/truetype/piboto/Piboto-Regular.ttf"
var DefaultFont = "/usr/share/fonts/truetype/noto/NotoMono-Regular.ttf"
var FontSize = 20

class Text {
  lines { _lines } //  list of long lines
  lines=(value) { _lines = value }

  construct new(text) {
    _lines = Text.split(text)
  }

  static load(fileName) {
    return Text.new(FileSystem.load(fileName))
  }

  static split(text) {
    var lines = []
    var last = 0
    var i = 0
    for (c in text) {
      if (c == "\n") {
        lines.add(text[last...i])
	last = i
      }
      i = i + 1
    }
    lines.add(text[last...i])
    return lines
  }

  static flatten(list, flattened) {
    for (el in list) {
      if (el is List) {
        Text.flatten(el, flattened)
      } else {
        flattened.add(el)
      }
    }
  }

  static fit(line, width) {
    var area = Canvas.getPrintArea(line)
    
    if (area.x < width) {
      return [ line ]
    }
    
    var split = (line.count * width / area.x).floor

    var lines = []
    Text.flatten([
      Text.fit(line[0...split], width),
      Text.fit(line[split...line.count], width)
    ], lines)

    return lines
  }

  print() {
    var y = 0
    var lineNumber = 1
    
    for (line in lines) {
      Canvas.print(lineNumber, 0, y, Color.green)
      //System.print("%(lineNumber)\n")
      for (shortLine in Text.fit(line, Canvas.width)) {
        Canvas.print(shortLine, 16, y, Color.white)
	//System.print("  %(shortLine)\n")
        y = y + FontSize + 4
      }
      lineNumber = lineNumber + 1
    }
  }
}

class Main {
  text { _text }
  x { _x }
  y { _y }
  cursorOn { _cursorOn }

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
    _cursorOn = Platform.time % 2 == 1
  }
  draw(alpha) {
    Canvas.cls()
    text.print()
    if (cursorOn) {
      Canvas.rect(x, y, 10, 24, Color.green)
    }
  }
}

var Game = Main.new()
