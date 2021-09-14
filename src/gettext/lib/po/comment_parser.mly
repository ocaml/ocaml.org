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
%}

%token COLON
%token <int> LINE
%token <string> KEYWORD
%token <string> FILENAME
%token COMMENT_EOF

%type <Types.filepos list> comment_filepos
%type <Types.special list> comment_special
%start comment_filepos comment_special

%%

comment_filepos:
  filepos_list COMMENT_EOF { List.rev $1 }
| COMMENT_EOF              { [] }
;

filepos_list:
  filepos_list filepos { $2 :: $1 }
| filepos              { [$1] }
;

filepos:
  FILENAME COLON LINE { ($1,$3) }
;

comment_special:
  special_list COMMENT_EOF { List.rev $1 }
| COMMENT_EOF              { [] }
;

special_list:
  special_list KEYWORD { $2 :: $1 }
| KEYWORD              { [$1] }
;

