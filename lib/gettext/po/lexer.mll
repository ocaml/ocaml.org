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

{

open Parser;;

let next_line lexbuf =
  lexbuf.Lexing.lex_curr_p <-
  {
    lexbuf.Lexing.lex_curr_p with
    Lexing.pos_lnum = lexbuf.Lexing.lex_curr_p.Lexing.pos_lnum + 1;
    Lexing.pos_bol  = lexbuf.Lexing.lex_curr_p.Lexing.pos_cnum;
  }
;;

}

rule
token = parse
  "msgstr"                   { MSGSTR }
| "msgid"                    { MSGID }
| "msgid_plural"             { MSGID_PLURAL }
| "domain"                   { DOMAIN }
| '['                        { LBRACKET }
| ']'                        { RBRACKET }
| ['0'-'9']+ as nbr          { NUMBER (int_of_string nbr) }
| '"'                        { STRING (string_val lexbuf) }
| "#:"                       { COMMENT_FILEPOS(comment_join (Buffer.create 80) lexbuf)}
| "#,"                       { COMMENT_SPECIAL(comment_join (Buffer.create 80) lexbuf)}
| '#'                        { comment_skip lexbuf }
| [' ''\t']                  { token lexbuf }
| ['\r''\n']                 { next_line lexbuf; token lexbuf }
| eof                        { EOF }
and

string_val = parse
  "\\n"              { "\n" ^ ( string_val lexbuf) }
| "\\t"              { "\t" ^ ( string_val lexbuf) }
| "\\b"              { "\b" ^ ( string_val lexbuf) }
| "\\r"              { "\r" ^ ( string_val lexbuf) }
| "\\f"              { "\012" ^ ( string_val lexbuf) }
| "\\v"              { "\011" ^ ( string_val lexbuf) }
| "\\a"              { "\007" ^ ( string_val lexbuf) }
| "\\\""             { "\"" ^ ( string_val lexbuf) }
| "\\\\"             { "\\" ^ ( string_val lexbuf) }
| '\\' (['0'-'7'] ['0'-'7']? ['0'-'7']?) as oct
                     {
                       let chr =
                         try
                           char_of_int (int_of_string ( "0o" ^ oct ))
                         with _ ->
                           char_of_int 255
                       in
                       ( String.make 1 chr ) ^ ( string_val lexbuf )
                     }
| "\\x" (['0'-'9''A'-'F''a'-'f'] ['0'-'9''A'-'F''a'-'f']?) as hex
                     {
                       let chr =
                         try
                           char_of_int (int_of_string ("0x" ^ hex ))
                         with _ ->
                           char_of_int 255
                       in
                       ( String.make 1 chr ) ^ ( string_val lexbuf )
                     }
| [^'"''\\']+ as str { str ^ (string_val lexbuf) }
| '"'                { "" }
and

comment_skip = parse
 ['\n']    { next_line lexbuf; token lexbuf }
| _            { comment_skip lexbuf }
and

comment_join strbuf = parse
| "\n#."          { next_line lexbuf; comment_join strbuf lexbuf }
| '\n'            { next_line lexbuf; Buffer.contents strbuf }
| '\r'            { comment_join strbuf lexbuf }
| [^'\n''\r']* as str { Buffer.add_string strbuf str; comment_join strbuf lexbuf }

