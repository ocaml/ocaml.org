---
packages:
- name: "camomile"
  version: "1.0.2"
libraries:
- camomile
code_blocks:
- explanation: |
    Initialise the `camomile` library, which offers a large set of functions to deal with strings presented in various encodings. We will need to instanciate a module that deals with UTF8 strings. (In most cases, the source code is in UTF8, and when OCaml sees a constant string, it just copies the byte sequence for whatever its encoding.). The `Camomile` module declaration is required with the version 1 of `camomile` and mustn't be declared with the version 2:
  code: |
    module Camomile = CamomileLibrary.Make(CamomileDefaultConfig)
    module UTF8 = Camomile.CharEncoding.Make(Camomile.UTF8)
- explanation: Let's convert a UTF8 string into a Latin1 encoding. (Note, most terminals deal equaly with UTF8 and Latin1 characters, then both strings look equal on the screen).
  code: |
    let utf8 = "déjà"
    let () = assert (String.length utf8 = 6)
    let latin1 = UTF8.encode Camomile.CharEncoding.latin1 utf8
    let () = assert (String.length latin1 = 4)
- explanation: Let's convert the Latin1 character back to UTF8.
  code: |
    let utf8' = UTF8.decode Camomile.CharEncoding.latin1 latin1
    let () = assert (utf8 = utf8')
- explanation: |
    Some other encoding are not directly available in the `Camomile.CharEncoding` module, but the `of_name` function can get them. (Note: The Euro glyph (€) is not supported by Latin1. Note, "ISO_8859-16" can also be named "LATIN10")
  code: |
    let latin10 = UTF8.encode (Camomile.CharEncoding.of_name "ISO_8859-16") "100 €";;
---

- **Understanding `camomile`:** The `camomile` package provides many operations which deal with string encodings. More than 500 encodings are supported. It provides different modules that deal with string encoding/decoding. Some other functions are provided to extract single characters from an encoded string (UTF8 chars can use a variable number of bytes, which is not well supported by the `StdLib`), to identify characters classes, or to perform some uppercase/lowercase transformation)
- **Alternatives:** `coin` is an alternative that supports Unicode to/from KOI8-U/R (Ukranian/Russian encoding). `rosetta`, `text`, `ucorelib`, ` and `uutf` are also Unicode converters. `uuuu` is limited to Unicode from/to ISO-8859-* charsets. `unidecode` converts unicode to plain ASCII. `yuscii` is dedicated to UTF-7.
