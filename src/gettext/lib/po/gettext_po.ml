(**************************************************************************)
(*  ocaml-gettext: a library to translate messages                        *)
(*                                                                        *)
(*  Copyright (C) 2003-2008 Sylvain Le Gall <sylvain@le-gall.net>         *)
(*                                                                        *)
(*  This library is free software; you can redistribute it and/or         *)
(*  modify it under the terms of the GNU Lesser General Public            *)
(*  License as published by the Free Software Foundation; either          *)
(*  version 2.1 of the License, or (at your option) any later version;    *)
(*  with the OCaml static compilation exception.                          *)
(*                                                                        *)
(*  This library is distributed in the hope that it will be useful,       *)
(*  but WITHOUT ANY WARRANTY; without even the implied warranty of        *)
(*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU     *)
(*  Lesser General Public License for more details.                       *)
(*                                                                        *)
(*  You should have received a copy of the GNU Lesser General Public      *)
(*  License along with this library; if not, write to the Free Software   *)
(*  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307   *)
(*  USA                                                                   *)
(**************************************************************************)

(** @author Sylvain Le Gall *)

open Exn
include Types

type t = content = {
  no_domain : translations;
  domain : translations String_map.t;
}

module Exn = Exn

let empty_po = Utils.empty

let add_translation_no_domain po translation =
  try Utils.add_translation_no_domain po translation
  with Inconsistent_merge (str1, str2) ->
    raise (Inconsistent_merge (str1, str2))

let add_translation_domain po domain translation =
  try Utils.add_translation_domain po domain translation
  with Inconsistent_merge (str1, str2) ->
    raise (Inconsistent_merge (str1, str2))

let merge_po po1 po2 =
  (* We take po2 as the initial set, we merge po1 into po2 beginning with
     po1.no_domain and then po1.domain *)
  let merge_no_domain =
    String_map.fold
      (fun _ translation po -> add_translation_no_domain po translation)
      po1.no_domain po2
  in
  let merge_one_domain domain map_domain po =
    String_map.fold
      (fun _ translation po -> add_translation_domain domain po translation)
      map_domain po
  in
  String_map.fold merge_one_domain po1.domain merge_no_domain

let merge_pot pot po =
  let order_map ?domain () =
    match domain with
    | None ->
        po.no_domain :: String_map.fold (fun _ x lst -> x :: lst) po.domain []
    | Some domain -> (
        let tl =
          po.no_domain
          :: String_map.fold
               (fun key x lst -> if key = domain then lst else x :: lst)
               po.domain []
        in
        try String_map.find domain po.domain :: tl with Not_found -> tl)
  in
  let merge_translation map_lst key commented_translation_pot =
    let translation_pot = commented_translation_pot.comment_translation in
    let translation_merged =
      try
        let commented_translation_po =
          let map_po = List.find (String_map.mem key) map_lst in
          String_map.find key map_po
        in
        let translation_po = commented_translation_po.comment_translation in
        (* Implementation of the rule given above *)
        match (translation_pot, translation_po) with
        | Singular (str_id, _), Plural (_, _, str :: _) -> Singular (str_id, str)
        | Plural (str_id, str_plural, _ :: tl), Singular (_, str) ->
            Plural (str_id, str_plural, str :: tl)
        | Plural (str_id, str_plural, []), Singular (_, str) ->
            Plural (str_id, str_plural, [ str ])
        | _, translation -> translation
      with Not_found ->
        (* Fallback to the translation provided in the POT *)
        translation_pot
    in
    { commented_translation_pot with comment_translation = translation_merged }
  in
  (* We begin with an empty po, and merge everything according to the rule
     above. *)
  let merge_no_domain =
    String_map.fold
      (fun key pot_translation po ->
        add_translation_no_domain po
          (merge_translation (order_map ()) key pot_translation))
      pot.no_domain empty_po
  in
  let merge_one_domain domain map_domain po =
    String_map.fold
      (fun key pot_translation po ->
        add_translation_domain domain po
          (merge_translation (order_map ~domain ()) key pot_translation))
      map_domain po
  in
  String_map.fold merge_one_domain pot.domain merge_no_domain

let input_po chn =
  let lexbuf = Lexing.from_channel chn in
  try Parser.msgfmt Lexer.token lexbuf with
  | Parsing.Parse_error -> raise (Invalid_file ("parse error", lexbuf))
  | Failure s -> raise (Invalid_file (s, lexbuf))
  | Inconsistent_merge (str1, str2) -> raise (Inconsistent_merge (str1, str2))

let output_po chn po =
  let () = set_binary_mode_out chn true in
  let comment_max_length = 80 in
  let fpf x = Printf.fprintf chn x in
  let escape_string str =
    let rec escape_string_aux buff i =
      if i < String.length str then
        let () =
          match str.[i] with
          | '\n' -> Buffer.add_string buff "\\n"
          | '\t' -> Buffer.add_string buff "\\t"
          | '\b' -> Buffer.add_string buff "\\b"
          | '\r' -> Buffer.add_string buff "\\r"
          | '\012' -> Buffer.add_string buff "\\f"
          | '\011' -> Buffer.add_string buff "\\v"
          | '\007' -> Buffer.add_string buff "\\a"
          | '"' -> Buffer.add_string buff "\\\""
          | '\\' -> Buffer.add_string buff "\\\\"
          | e -> Buffer.add_char buff e
        in
        escape_string_aux buff (i + 1)
      else ()
    in
    let buff = Buffer.create (String.length str + 2) in
    Buffer.add_char buff '"';
    escape_string_aux buff 0;
    Buffer.add_char buff '"';
    Buffer.contents buff
  in
  let hyphens chn lst =
    match lst with
    | [] -> ()
    | lst ->
        Printf.fprintf chn "%s"
          (String.concat "\n" (List.map escape_string lst))
  in
  let comment_line str_hyphen str_sep line_max_length token_lst =
    let str_len =
      List.fold_left (fun acc str -> acc + String.length str) 0 token_lst
      + (List.length token_lst * String.length str_sep)
    in
    let buff =
      Buffer.create
        (str_len + (String.length str_hyphen * (str_len / line_max_length)))
    in
    let rec comment_line_aux first_token line_length lst =
      match lst with
      | str :: tl ->
          let sep_length =
            if first_token then 0
            else if String.length str + line_length > line_max_length then (
              Buffer.add_char buff '\n';
              Buffer.add_string buff str_hyphen;
              Buffer.add_string buff str_sep;
              String.length str_hyphen + String.length str_sep)
            else (
              Buffer.add_string buff str_sep;
              String.length str_sep)
          in
          Buffer.add_string buff str;
          comment_line_aux false
            (sep_length + String.length str + line_length)
            tl
      | [] -> Buffer.contents buff
    in
    comment_line_aux true 0 token_lst
  in
  let output_translation_aux _ commented_translation =
    (match commented_translation.comment_filepos with
    | [] -> ()
    | lst ->
        fpf "%s\n"
          (comment_line "#." " " comment_max_length
             ("#:"
             :: List.map
                  (fun (str, line) -> Printf.sprintf "%s:%d" str line)
                  lst)));
    (match commented_translation.comment_special with
    | [] -> ()
    | lst -> fpf "%s\n" (comment_line "#." " " comment_max_length ("#," :: lst)));
    (match commented_translation.comment_translation with
    | Singular (id, str) ->
        fpf "msgid %a\n" hyphens id;
        fpf "msgstr %a\n" hyphens str
    | Plural (id, id_plural, lst) ->
        fpf "msgid %a\n" hyphens id;
        fpf "msgid_plural %a\n" hyphens id_plural;
        let _ =
          List.fold_left
            (fun i s ->
              fpf "msgstr[%i] %a\n" i hyphens s;
              i + 1)
            0 lst
        in
        ());
    fpf "\n"
  in
  String_map.iter output_translation_aux po.no_domain;
  String_map.iter
    (fun domain map ->
      fpf "domain %S\n\n" domain;
      String_map.iter output_translation_aux map)
    po.domain

let read_po s =
  let lexbuf = Lexing.from_string s in
  try Parser.msgfmt Lexer.token lexbuf with
  | Parsing.Parse_error -> raise (Invalid_file ("parse error", lexbuf))
  | Failure s -> raise (Invalid_file (s, lexbuf))
  | Inconsistent_merge (str1, str2) -> raise (Inconsistent_merge (str1, str2))
