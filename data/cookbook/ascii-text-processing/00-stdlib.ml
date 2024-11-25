---
packages: []
---

(*
Get the length of the string:
*)
let () = assert (String.length "string" = 6)

(*
Get a character at a given index (the first character index is 0):
*)
let () = assert (String.get "string" 2 = 'r')

(*
Concatenate two strings or a list of strings:
*)
let () = assert (String.cat "aze" "rty" = "azerty")
let () = assert ("aze" ^ "rty" = "azerty")
let () = assert (String.concat "," ["aze";"rty";"uiop"] = "aze,rty,uiop")

(*
Check if a string starts or ends with a prefix/suffix:
*)
let () = assert (String.starts_with ~prefix:"a=" "a=42")
let () = assert (String.ends_with ~suffix:"**" "str**")

(*
String character search functions:
- `String.contains`: checks if a character exists anywhere in the string
- `String.contains_from s i c`: searches for character 'c' in string 's' starting at index 'i'
  (ignores characters at positions 0 to i-1)
- `String.rcontains_from s i c`: searches for character 'c' in string 's' from start up to index 'i'
  (ignores characters at positions i+1 onwards)

All functions return true if the character is found, false otherwise.
*)
let () = assert (String.contains_from "azerty" 3 'y')
let () = assert (String.rcontains_from "azerty" 3 'a')
let () = assert (String.contains "azerty" 'y')

(*
Search a character in a string:
- index_from: searches forward starting from given position
- rindex_from: searches backward from given position
- index: searches forward from start
- rindex: searches backward from end

The _opt variants return None if character isn't found, instead of
raising the Not_found exception.
*)
let () = assert (String.index_from "azerty" 3 'y' = 5)
let () = assert (String.index_from_opt "azerty" 3 'y' = Some 5)
let () = assert (String.rindex_from "azerty" 3 'a' = 0)
let () = assert (String.rindex_from_opt "azerty" 3 'a' = Some 0)
let () = assert (String.index "azerty-azerty" 'y' = 5)
let () = assert (String.index_opt "azerty" 'y' = Some 5)
let () = assert (String.rindex "azerty-azerty" 'y' = 12)
let () = assert (String.rindex_opt "azerty-azerty" 'y' = Some 12)

(*
Extract a substring at a given index with a given length
*)
let () = assert (String.sub "azerty" 2 3 = "ert")

(*
Split a string using a given character as a separator,
returning a list of substrings:
*)
let () = assert
  (String.split_on_char ',' "abc,def,ghi"
    = [ "abc"; "def"; "ghi"])

(*
Remove whitspace (' ', '\t', '\r', '\n', '\x0C' (form-feed))
at the beginning and end of the string.
*)
let () = assert (String.trim "  abcd   \r\n" = "abcd")

(*
Escape special characters like quotes and control characters.
Useful when generating string literals programmatically.
*)
let () = assert (String.escaped {|"abcd"|} = "\\\"abcd\\\"")

(* Case conversion functions: *)
let () = assert (String.uppercase_ascii "abcdef" = "ABCDEF")
let () = assert (String.lowercase_ascii "ABCDEF" = "abcdef")
let () = assert (String.capitalize_ascii "abcdef" = "Abcdef")
let () = assert (String.uncapitalize_ascii "ABCDEF" = "aBCDEF")

