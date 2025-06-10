---
packages: []
  - **Understanding `Unix.tm`:** The `Unix.tm` structure represents a local time. This structure includes fields like `tm_year`, `tm_mon`, and `tm_mday` for year, month, and day, respectively.
  - **Understanding `Format`:** Because `Unix.tm` is an abstract type, we must define a pretty printer for it.  The are usually two kinds of pretty printer for a type: `pp` uses `Format.formatter` to print a value, and `show` simply converts the value to a string.
---

(* The `unix` library, which ships with OCaml's standard library, provides
   functions to work with dates and times. *)
let today: Unix.tm = Unix.localtime (Unix.time ());;

(* The `Unix.tm` type represents date and time, but it lacks a pretty printer.
   We can define one for it. *)
let pp_tm ppf t =
  Format.fprintf ppf "%4d-%02d-%02dT%02d:%02d:%02dZ" (t.Unix.tm_year + 1900)
    (t.Unix.tm_mon + 1) t.Unix.tm_mday t.Unix.tm_hour t.Unix.tm_min
    t.Unix.tm_sec;;

(* Then define a function that converts `Unix.tm` to string. *)
let show_tm = Format.asprintf "%a" pp_tm;;

Format.printf "The current date and time is %a" pp_tm today;;

print_endline ("The current date and time is " ^ show_tm today);;
