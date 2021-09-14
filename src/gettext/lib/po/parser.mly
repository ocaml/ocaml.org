/**************************************************************************/
/*  ocaml-gettext: a library to translate messages                        */
/*                                                                        */
/*  Copyright (C) 2003-2008 Sylvain Le Gall <sylvain@le-gall.net>         */
/*                                                                        */
/*  This library is free software; you can redistribute it and/or         */
/*  modify it under the terms of the GNU Lesser General Public            */
/*  License as published by the Free Software Foundation; either          */
/*  version 2.1 of the License, or (at your option) any later version;    */
/*  with the OCaml static compilation exception.                          */
/*                                                                        */
/*  This library is distributed in the hope that it will be useful,       */
/*  but WITHOUT ANY WARRANTY; without even the implied warranty of        */
/*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU     */
/*  Lesser General Public License for more details.                       */
/*                                                                        */
/*  You should have received a copy of the GNU Lesser General Public      */
/*  License along with this library; if not, write to the Free Software   */
/*  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307   */
/*  USA                                                                   */
/**************************************************************************/

%{

open Types;;
open Exn;;
open Utils;;

type comment =
  | CommentFilePos of filepos list
  | CommentSpecial of string list
;;

let check_string_format _ref str =
  str
;;

let rec add_comment comments commented_translation =
  match comments with
  | CommentFilePos e :: comments_tl ->
      add_comment
        comments_tl
        {
          commented_translation with
            comment_filepos =
              List.append
                e
                commented_translation.comment_filepos
        }
  | CommentSpecial e :: comments_tl ->
      add_comment
        comments_tl
        {
          commented_translation with
            comment_special =
              List.append
                e
                commented_translation.comment_special
        }
  | [] ->
      commented_translation
;;

let check_plural id id_plural lst =
  let check_plural_one index lst =
    List.rev (
      snd (
        List.fold_left ( fun (index,lst) (cur_index,cur_elem) ->
          if index + 1 = cur_index then
            (cur_index, (check_string_format id cur_elem) :: lst)
          else
            raise (File_invalid_index(String.concat "" id,cur_index))
        ) (index,[]) lst
      )
    )
  in
  {
    comment_special = [];
    comment_filepos = [];
    comment_translation =
      Plural(id, (check_string_format id id_plural), (check_plural_one (-1) lst));
  }
;;

let check_singular id str =
  {
    comment_special = [];
    comment_filepos = [];
    comment_translation =
      Singular(id, check_string_format id str)
  }
;;

%}

%token MSGSTR
%token MSGID
%token MSGID_PLURAL
%token DOMAIN
%token LBRACKET
%token RBRACKET
%token <int> NUMBER
%token <string> STRING
%token EOF
%token <string> COMMENT_FILEPOS
%token <string> COMMENT_SPECIAL

%type <Types.content> msgfmt
%start msgfmt

%%

msgfmt:
  msgfmt domain         { let (d,l) = $2 in List.fold_left (add_translation_domain d) $1 l }
| domain                { let (d,l) = $1 in List.fold_left (add_translation_domain d) empty l }
| msgfmt message_list   { List.fold_left add_translation_no_domain $1 $2 }
| message_list          { List.fold_left add_translation_no_domain empty $1 }
| EOF                   { empty }
;

comment:
| COMMENT_FILEPOS
  {
    let lexbuf =
      Lexing.from_string $1
    in
    let lst =
      Comment_parser.comment_filepos
        Comment_lexer.comment_filepos
        lexbuf
    in
      CommentFilePos lst
  }
| COMMENT_SPECIAL
  {
    let lexbuf =
      Lexing.from_string $1
    in
    let lst =
      Comment_parser.comment_special
        Comment_lexer.comment_special
        lexbuf
    in
    CommentSpecial lst
  }
;

comment_list:
  comment_list comment { $2 :: $1 }
| comment              { [$1] }
;;

domain:
  DOMAIN STRING message_list { ($2,$3) }
| DOMAIN STRING              { ($2,[]) }
;

message_list:
  message_list message { $2 :: $1 }
| message              { [$1] }
;

message:
  comment_list MSGID string_list MSGSTR string_list
    { add_comment $1 (check_singular  (List.rev $3) (List.rev $5)) }
| MSGID string_list MSGSTR string_list
    { (check_singular (List.rev $2) (List.rev $4)) }
| comment_list MSGID string_list msgid_pluralform pluralform_list
    { add_comment $1 (check_plural (List.rev $3) $4 (List.rev $5)) }
| MSGID string_list msgid_pluralform pluralform_list
    { (check_plural (List.rev $2) $3 (List.rev $4)) }
;

msgid_pluralform:
  MSGID_PLURAL string_list { (List.rev $2) }
;

pluralform_list:
  pluralform_list pluralform  { $2 :: $1 }
| pluralform                  { [$1] }
;

pluralform:
  MSGSTR LBRACKET NUMBER RBRACKET string_list { ($3,(List.rev $5)) }
;

string_list:
  string_list STRING { $2 :: $1 }
| STRING             { [$1] }
;

