---
packages: []
sections:
- filename: main.ml
  language: ocaml
  code_blocks:
  - explanation: |
      Get the length of the string:
    code: |
      let () = assert (String.length "string" = 6)
  - explanation: |
      Get a character at a given index (the first character index is 0):
    code: |
      let () = assert (String.get 2 "string" = 'r')
  - explanation: |
      Concatenate two strings or a list of strings:
    code: |
      let () = assert (String.cat "aze" "rty" = "azerty")
      let () = assert ("aze" ^ "rty" = "azerty")
      let () = assert (String.concat "," ["aze";"rty";"uiop"] = "aze,rty,uiop"])
  - explanation: |
      Verifying if a string starts or ends with a prefix/suffix:
    code: |
      let () = assert (String.starts_with ~prefix:"a=" "a=42")
      let () = assert (String.ends_with ~suffix:" "**" "str**")
  - explanation: |
      Verifying if the string contains a given char. `contains_from` ignore characters before a given index. `rcontains_from` ignore characters after the given index. (The character pointed by the index is always considered).
    code: |
      let () = assert (String.contains_from "azerty" 3 'y')
      let () = assert (String.rcontains_from "azerty" 3 'a')
      let () = assert (String.contains "azerty" 'y')
  - explanation: |
      Searching a character in a string, returning its index. These functions are similar to the previous ones. The `_opt` versions return `None` if the character is not found, and `Some index` if it exists. The other functions raise a `Not_found` if no characters are found. The `r` functions search backward from the index (or the end with `rindex`).
    code: |
      let () = assert (String.index_from "azerty" 3 'y' = 5)
      let () = assert (String.index_from_opt "azerty" 3 'y' = Some 5)
      let () = assert (String.rindex_from "azerty" 3 'a' = 0)
      let () = assert (String.rindex_from_opt "azerty" 3 'a' = Some 0)
      let () = assert (String.index "azerty-azerty" 'y' = 5)
      let () = assert (String.index_opt "azerty" 'y' = Some 5)
      let () = assert (String.rindex "azerty-azerty" 'y' = 12)
      let () = assert (String.rindex_opt "azerty" 'y' = Some 12)
  - explanation: |
      Extracting a substring at a given index with a given length
    code: |
      let () = assert (String.sub "azerty" 2 3 = "ert")
  - explanation: |
      Spliting a string using a given character as a separator returning a list of substrings:
    code: |
      let () = assert (String.split_on_char ',' "abc,def,ghi" = [ "abc"; "def"; "ghi"])
  - explanation: |
      Suppressing a tailling whitspace: ' ', '\t', '\r', '\n', '\x0C' (form-feed)
    code: |
      let () = assert (String.trim "abcd   \r\n" = "abcd")
  - explanation: |
      Replacing each character by an escaped version if '\\' or '"'.
    code: |
      let () = assert (String.escaped {|"abcd"|} = "\\\"abcdef\\\""
  - explanation: |
      Some lower/uppercase functions:
    code: |
      let () = assert (String.uppercase_ascii "abcdef" = "ABCDEF")
      let () = assert (String.lowercase_ascii "ABCDEF" = "abcdef")
      let () = assert (String.capitalize_ascii "abcdef" = "Abcdef")
      let () = assert (String.uncapitalize_ascii "ABCDEF" = "aBCDEF")
---

- **Understanding `String`: `String` is a module from the `stdlib` library. It contains many functions which process ASCII strings. Their use may be not adequate with accentuated strings. (The `length` return simply the number of bytes used by the string without taking into account characters coded with multiple characters.) The documentation of the `String` module is in the [API reference](https://v2.ocaml.org/api/Stdlib.String.html).
- **Alternative Libraries:** There are other libraries that are more adequate if we need to deal with UTF-8 strings (`camomile` for example).
