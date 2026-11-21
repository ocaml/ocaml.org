---
title: Vdom 0.3 brings Elm-style decoders to OCaml
description: 'With the release of Vdom 0.3, OCaml developers now have access to a
  powerful new feature: Elm-like decoders. They provide an elegant and efficient means
  to access data fields within tree-like structures, such as JavaScript objects. In
  this new version of the Vdom library, you can now define custom event handlers,
  moving away from the previously hard-coded system.'
url: https://www.lexifi.com/blog/ocaml/decoders/
date: 2023-10-23T00:00:00-00:00
preview_image:
authors:
- LexiFi
source:
ignore:
keywords:
- decoder
- decoders
- elm-style
- event
- field
- gadt
- javascript
- msg
- objects
- vdom
---

<p>With the release of <a href="https://opam.ocaml.org/packages/vdom/">Vdom</a> 0.3, OCaml developers now have access to a powerful new feature: <a href="https://package.elm-lang.org/packages/elm/json/latest/Json.Decode">Elm-like decoders</a>. They provide an elegant and efficient means to access data fields within tree-like structures, such as JavaScript objects.</p>
<p>In this new version of the <a href="https://opam.ocaml.org/packages/vdom/">Vdom</a> library, you can now define custom event handlers, moving away from the previously hard-coded system. Before this update, event handling was confined to a predefined set of event types, with limited data extraction capabilities. With the introduction of decoders, the approach becomes more flexible and extensible. This shift allows for more intricate operations and expands the potential use cases. Previously unsupported complex operations, such as retrieving files that users drag and drop, can now be defined with ease.</p>
