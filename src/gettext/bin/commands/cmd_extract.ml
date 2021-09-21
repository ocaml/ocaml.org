open Gettext_po
open Parsetree
open Longident
module String_set = Set.Make (String)
module String_map = Map.Make (String)

type t =
  { po_content : Gettext_po.t
  ; translated : String_set.t
  }

let translations =
  ref { po_content = Gettext_po.empty_po; translated = String_set.empty }

let default_textdomain = ref None

let current_file = ref ""

let add_translation loc singular plural_opt domain =
  let t = !translations in
  let filepos =
    let start = loc.Location.loc_start in
    let fname =
      match start.Lexing.pos_fname with "" -> !current_file | fname -> fname
    in
    fname, start.Lexing.pos_lnum
  in
  let translated = String_set.add singular t.translated in
  let translated, translation =
    match plural_opt with
    | Some plural ->
      ( String_set.add plural translated
      , { comment_special = []
        ; comment_filepos = [ filepos ]
        ; comment_translation =
            Plural ([ singular ], [ plural ], [ [ "" ]; [ "" ] ])
        } )
    | None ->
      ( translated
      , { comment_special = []
        ; comment_filepos = [ filepos ]
        ; comment_translation = Singular ([ singular ], [ "" ])
        } )
  in
  let po_content =
    match domain, !default_textdomain with
    | Some domain, _ ->
      add_translation_domain domain t.po_content translation
    | None, Some domain ->
      add_translation_domain domain t.po_content translation
    | None, None ->
      add_translation_no_domain t.po_content translation
  in
  translations := { po_content; translated }

let output_translations ?output_file t =
  let fd = match output_file with Some f -> open_out f | None -> stdout in
  Gettext_po.output_po fd t

let rec is_like lid = function
  | [] ->
    false
  | func :: functions ->
    (match lid with
    | (Lident f | Ldot (_, f)) when f = func ->
      true
    | _ ->
      is_like lid functions)

let visit_expr (iterator : Ast_iterator.iterator) expr =
  let loc = expr.pexp_loc in
  match expr.pexp_desc with
  | Pexp_apply
      ( { pexp_desc = Pexp_ident { Asttypes.txt = lid; _ }; _ }
      , ( Asttypes.Nolabel
        , { pexp_desc = Pexp_constant (Pconst_string (singular, _, _)); _ } )
        :: _ )
    when is_like lid [ "gettext"; "fgettext" ] ->
    (* Add a singular / default domain string *)
    add_translation loc singular None None
  | Pexp_apply
      ( { pexp_desc = Pexp_ident { Asttypes.txt = lid; _ }; _ }
      , ( Asttypes.Nolabel
        , { pexp_desc = Pexp_constant (Pconst_string (singular, _, _)); _ } )
        :: ( Asttypes.Nolabel
           , { pexp_desc = Pexp_constant (Pconst_string (plural, _, _)); _ } )
           :: _ )
    when is_like lid [ "ngettext"; "fngettext" ] ->
    (* Add a plural / default domain string *)
    add_translation loc singular (Some plural) None
  | Pexp_apply
      ( { pexp_desc = Pexp_ident { Asttypes.txt = lid; _ }; _ }
      , _
        :: ( Asttypes.Nolabel
           , { pexp_desc = Pexp_constant (Pconst_string (domain, _, _)); _ } )
           :: ( Asttypes.Nolabel
              , { pexp_desc = Pexp_constant (Pconst_string (singular, _, _))
                ; _
                } )
              :: _ )
    when is_like lid [ "dgettext"; "fdgettext"; "dcgettext"; "fdcgettext" ] ->
    (* Add a singular / defined domain string *)
    add_translation loc singular None (Some domain)
  | Pexp_apply
      ( { pexp_desc = Pexp_ident { Asttypes.txt = lid; _ }; _ }
      , _
        :: ( Asttypes.Nolabel
           , { pexp_desc = Pexp_constant (Pconst_string (domain, _, _)); _ } )
           :: ( Asttypes.Nolabel
              , { pexp_desc = Pexp_constant (Pconst_string (singular, _, _))
                ; _
                } )
              :: ( Asttypes.Nolabel
                 , { pexp_desc = Pexp_constant (Pconst_string (plural, _, _))
                   ; _
                   } )
                 :: _ )
    when is_like lid [ "dngettext"; "fdngettext"; "dcngettext"; "fdcngettext" ]
    ->
    (* Add a plural / defined domain string *)
    add_translation loc singular (Some plural) (Some domain)
  | _ ->
    Ast_iterator.default_iterator.expr iterator expr

let ast_iterator = { Ast_iterator.default_iterator with expr = visit_expr }

let parse_file fn =
  current_file := fn;
  try
    let lexbuf = Lexing.from_channel (open_in fn) in
    let structure = Parse.implementation lexbuf in
    ast_iterator.Ast_iterator.structure ast_iterator structure
  with
  | exn ->
    failwith (fn ^ ": " ^ Printexc.to_string exn)

let run files =
  let rec aux = function
    | [] ->
      ()
    | f :: rest ->
      parse_file f;
      aux rest
  in
  aux files;
  output_translations !translations.po_content;
  0

(* Command line interface *)

open Cmdliner

let doc = "Extract translatable strings from OCaml source files."

let sdocs = Manpage.s_common_options

let exits = Common.exits

let envs = Common.envs

let man =
  [ `S Manpage.s_description
  ; `P
      "$(tname) extracts translatable strings from OCaml source files by \
       parsing the AST and looking for calls to gettext and ngettext \
       functions."
  ]

let info = Term.info "extract" ~doc ~sdocs ~exits ~envs ~man

let term =
  let open Common.Syntax in
  let+ _term = Common.term
  and+ files =
    let doc = "The files to extract the translation strings from" in
    let docv = "FILES" in
    Arg.(non_empty & pos_all file [] & info [] ~doc ~docv)
  in
  run files

let cmd = term, info
