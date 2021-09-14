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

%}

%token UNDERSCORE
%token DOT
%token AT
%token EOF
%token <string> ID

%start main
%type <Types.locale> main
%%

main:
  locale EOF          { (*print_endline "eof";*) $1 }
;

locale:
| locale UNDERSCORE ID  { (*print_endline "underscore";*) { $1 with territory = Some $3 } }
| locale DOT ID         { (*print_endline "dot";*) { $1 with codeset = Some $3 } }
| locale AT ID          { (*print_endline "at";*) { $1 with modifier = Some $3 } }
| ID                    { (*print_endline "id";*) create_locale $1 }
;
