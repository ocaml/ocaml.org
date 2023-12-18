---
id: gui
question: Is OCaml GUI Yet?
answer: Not quite yet, but we're getting there!
categories:
  - name: Bogue-counter
    status: 🟡
    description: |
      A bogue counter with an increment an decrement button to update the label.
    packages:
      - name: bogue-counter
---

OCaml, traditionally known for its strength in systems programming, formal verification, and as the language of choice for numerous academic endeavors, is steadily maturing in the GUI development landscape. 

With its strong static typing, emphasis on immutability, and excellent performance, it is gradually making a case for itself as a viable alternative to mainstream GUI development languages.

OCaml has libraries that aid an easy integration and usage of Graphical User Interface (GUI), of which the Bogue library is one of it. 

## About Bogue

Bogue is an all-purpose GUI (Graphical user interface) library for ocaml, with animations, written from scratch in ocaml, based on SDL2.

It can be used to add interactivity to any program.
Can work within an already existing event loop, for instance to add GUI elements to a game.
Uses GPU acceleration (thanks to the SDL2 renderer library), which makes it quite fast.
Can deal with several windows.

Bogue is themable, and does not try to look like your desktop. Instead, it will look the same on every platform.
Graphics output is scalable (without need to recompile), and hence easily adapts to Hi-DPI displays.
Predefined animations (slide-in, fade-in, fade-out, rotate).
Built-in audio mixer.
Works with mouse, touchscreen, and even TAB focusing

Programming with bogue is easy if you're used to GUIs with widgets, layouts, callbacks, and of course it has a functional flavor. ​It uses Threads when non-blocking reactions are needed.

## Features

Some of the features of the Bogue library are:

### Widgets

Widgets are the building bricks, responsible for graphic elements that respond to events (mouse, touchscreen, keyboard, etc.).

### Layouts

widgets can be combined in various ways into layouts. For instance, a check box followed by a text label is a common layout.

Some of the examples of GUIs created with the Bogue library are listed below:

