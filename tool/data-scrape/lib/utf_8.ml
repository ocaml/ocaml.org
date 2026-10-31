(* Scraped text is written into data/, which must be valid UTF-8: the data
   packer rejects any file that is not. Feeds can carry badly encoded text, so
   every string taken from a remote source goes through [sanitize] first. *)

(* [replace_invalid s] is [s] with each invalid UTF-8 sequence replaced by
   U+FFFD. It returns [s] itself when [s] is already valid. *)
let replace_invalid s =
  if String.is_valid_utf_8 s then s
  else
    let len = String.length s in
    let b = Buffer.create len in
    let rec go i =
      if i < len then (
        let d = String.get_utf_8_uchar s i in
        Buffer.add_utf_8_uchar b (Uchar.utf_decode_uchar d);
        go (i + Uchar.utf_decode_length d))
    in
    go 0;
    Buffer.contents b

(* [sanitize ~what s] is [replace_invalid s], with a warning on stderr naming
   [what] when [s] was not valid UTF-8. *)
let sanitize ~what s =
  let s' = replace_invalid s in
  if s' != s then
    Printf.eprintf "\nwarning: invalid UTF-8 replaced with U+FFFD in %s\n%!"
      what;
  s'
