// Dome Editor

import "io" for FileSystem 
import "graphics" for Canvas, Color
import "dome" for Platform

class Text {
  lines { _lines }
  lines=(value) { _lines = value }

  construct(text) {
    _lines = []
    var last = 0
    var i = 0
    for c in text {
      if (c == "\n") {
        _lines += text[last...i]
	last = i
      }
      i++
    }
    _lines += text[last...i]
  }

  static load(fileName) {
    return Text.new(FileSystem.load(fileName))
  }

  print(x, y, color) {
    var v = 0
    for line in lines {
      Canvas.print(line, x, y+v, color)
      v++
    }
  }
}

class Main {
  text { _text }
  x { _x }
  y { _y }
  textColor { _textColor }
  cursorOn { _cursorOn }

  construct new() {}
  init() {
    _text = Text.load("README.md")
    _x = 0
    _y = 0
    _textColor = Color.green
    _cursorOn = true
  }
  update() {
    _cursorOn = Platform.time % 2 == 1
  }
  draw(alpha) {
    Canvas.cls()
    text.print(x, y, textColor)
    var 
  }
}

var Game = Main.new()
