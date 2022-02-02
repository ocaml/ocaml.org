type t = Types.locale = {
  language : string;
  territory : string option;
  codeset : string option;
  modifier : string option;
}

let compare_opt_strings t1 t2 =
  match (t1, t2) with
  | Some t1, Some t2 -> 3 * String.compare t1 t2
  | Some _, None -> 1
  | None, Some _ -> -1
  | None, None -> 0

let compare t1 t2 =
  (4 * String.compare t1.language t2.language)
  + (3 * compare_opt_strings t1.territory t2.territory)
  + (2 * compare_opt_strings t1.codeset t2.codeset)
  + (1 * compare_opt_strings t1.modifier t2.modifier)

let of_string s =
  let lexbuf = Lexing.from_string s in
  Parser.main Lexer.token lexbuf

let pp_territory_opt ppf = function
  | Some s -> Format.fprintf ppf "_%s" s
  | None -> ()

let pp_codeset_opt ppf = function
  | Some s -> Format.fprintf ppf ".%s" s
  | None -> ()

let pp_modifier_opt ppf = function
  | Some s -> Format.fprintf ppf "@%s" s
  | None -> ()

let to_string t =
  Format.asprintf "%s%a%a%a" t.language pp_territory_opt t.territory
    pp_codeset_opt t.codeset pp_modifier_opt t.modifier
