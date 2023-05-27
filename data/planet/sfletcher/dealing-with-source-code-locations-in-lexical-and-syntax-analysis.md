---
title: Dealing with source code locations (in lexical and syntax analysis)
description: Locations             Writing compilers and interpreters requires rigorous
  management     of source code locations harvested during...
url: http://blog.shaynefletcher.org/2017/03/dealing-with-source-code-locations-in.html
date: 2017-03-30T19:58:00-00:00
preview_image:
featured:
authors:
- Shayne Fletcher
---


<html>
  <head>
    <title>Locations</title>
  </head>
  <body>

    <p>Writing compilers and interpreters requires rigorous management
    of source code locations harvested during syntax analysis and
    associated error handling mechanisms that involve reporting those
    locations along with details of errors they associate to.
    </p>

    <p>
    This article does a &quot;deep dive&quot; into the the <code>Location</code>
    module of the OCaml compiler. The original source can be found in
    the <code>ocaml/parsing</code> directory of an OCaml distribution
    (copyright <a href="https://en.wikipedia.org/wiki/Xavier_Leroy">Xavier
    Leroy</a>).
    </p>

    <p>
    <code>Location</code> is a <font size="5">masterclass</font> in
    using the standard library <code>Format</code> module. If you have
    had difficulties understanding <code>Format</code> and what it
    provides the OCaml programmer, then this is for
    you. Furthermore, <code>Location</code> contains invaluable idioms
    for error reporting &amp; exception handling. Learn them here to be
    able to apply them in your own programs.
    </p>

    <h2>Describing locations</h2>
    <p>
    A location corresponds to a range of characters in a source file.
    <code>Location</code> defines this type and a suite of functions
    for the production of location values.
    </p><pre>
type t = { 
  loc_start : Lexing.position;
  loc_end : Lexing.position;
  loc_ghost : bool
}

val none : t
val in_file : string &rarr; t
val init : Lexing.lexbuf &rarr; string &rarr; unit
val curr : Lexing.lexbuf &rarr; t

val symbol_rloc : unit &rarr; t
val symbol_gloc : unit &rarr; t
val rhs_loc : int &rarr; t

type 'a loc = { 
  txt : 'a;
  loc : t; 
}

val mkloc : 'a &rarr; t &rarr; 'a loc
val mknoloc : 'a &rarr; 'a loc
    </pre>
    

    <p>
    A value of the (standard library)
    type <code>Lexing.position</code> describes a point in a source
    file.
    </p><pre>
    type position = {
      pos_fname : string;
      pos_lnum : int;
      pos_bol : int;
      pos_cnum : int
    }
    </pre>
    The fields of this record have the following meanings:
    <ul>
    <li><code>pos_fname</code> is the file name</li>
    <li><code>pos_lnum</code> is the line number</li>
    <li><code>pos_bol</code> is the offset of the beginning of the
    line (the number of characters between the beginning of the lexbuf
    and the beginning of the line)</li>
    <li><code>pos_cnum</code> is the offset of the position (number of
    characters between the beginning of the lexbuf (details below) and
    the position)</li>
    </ul>
    The difference between <code>pos_cnum</code>
    and <code>pos_bol</code> is the character offset within the line
    (i.e. the column number, assuming each character is one column
    wide).
    

    <p>
    A location in a source file is defined by two positions : where
    the location starts and where the location ends.
    </p><pre>
type t = {
  loc_start : position;
  loc_end : position;
  loc_ghost : bool
}
    </pre>
    The third field <code>loc_ghost</code> is used to disambiguate
    locations that do not appear explicitly in the source file. A
    location will <em>not</em> be marked as ghost if it contains a
    piece of code that is syntactically valid and corresponds to an
    AST node and will be marked as a ghost location otherwise.
    

    <p>
    There is a specific value denoting a null position. It is
    called <code>none</code> and it is defined by the
    function <code>in_file</code>.
    </p><pre>
let in_file (name : string) : t =
  let loc : position = {
    pos_fname = name; (*The name of the file*)
    pos_lnum = 1; (*The line number of the position*)
    pos_bol = 0; (*Offset from the beginning of the lexbuf of the line*)
    pos_cnum = -1; (*Offset of the position from the beginning of the lexbuf*)
  } in
  { loc_start = loc; loc_end = loc; loc_ghost = true }

let none : t = in_file &quot;_none_&quot;
    </pre>
    

    <p><code>Lexing.lexbuf</code> is the (standard library) type of
    lexer buffers. A lexer buffer is the argument passed to the
    scanning functions defined by generated scanners (lexical
    analyzers). The lexer buffer holds the current state of the
    scanner plus a function to refill the buffer from the input.
    </p><pre>
type lexbuf = {
  refill_buff : lexbuf &rarr; unit;
  mutable lex_buffer : bytes;
  mutable lex_buffer_len : int;
  mutable lex_abs_pos : int;
  mutable lex_start_pos : int;
  mutable lex_curr_pos : int;
  mutable lex_last_pos : int;
  mutable lex_last_action : int;
  mutable lex_eof_reached : bool;
  mutable lex_mem : int array;
  mutable lex_start_p : position;
  mutable lex_curr_p : position;
}
    </pre>
    At each token, the lexing engine will copy <code>lex_curr_p</code>
    to <code>lex_start_p</code> then change the <code>pos_cnum</code>
    field of <code>lex_curr_p</code> by updating it with the number of
    characters read since the start of the <code>lexbuf</code>. The
    other fields are left unchanged by the the lexing engine. In order
    to keep them accurate, they must be initialized before the first
    use of the lexbuf and updated by the relevant lexer actions.
    <pre>
(*Set the file name and line number of the [lexbuf] to be the start
   of the named file*)
let init (lexbuf : Lexing.lexbuf) (fname : string) : unit =
  let open Lexing in
  lexbuf.lex_curr_p &lt;- {
    pos_fname = fname;
    pos_lnum = 1;
    pos_bol = 0;
    pos_cnum = 0;
  }
    </pre>
    The location of the current token in a lexbuf is computed by the
    function <code>curr</code>.
    <pre>
(*Get the location of the current token from the [lexbuf]*)
let curr (lexbuf : Lexing.lexbuf) : t = 
  let open Lexing in {
    loc_start = lexbuf.lex_start_p;
    loc_end = lexbuf.lex_curr_p;
    loc_ghost = false;
  }
    </pre>
    

    <p>
    <code>Parsing</code> is the run-time library for parsers generated
    by <code>ocamlyacc</code>. The functions <code>symbol_start</code>
    and <code>symbol_end</code> are to be called in the action part of
    a grammar rule (only). They return the offset of the string that
    matches the left-hand-side of the rule : <code>symbol_start</code>
    returns the offset of the first character; <code>symbol_end</code>
    returns the offset <em>after</em> the last character. The first
    character in a file is at offset 0.
    </p>
    
    <p>
    <code>symbol_start_pos</code> and <code>symbol_end_pos</code> are
    like <code>symbol_start</code> and <code>symbol_end</code> but
    return <code>Lexing.position</code> values instead of offsets.
    </p><pre>
(*Compute the span of the left-hand-side of the matched rule in the
   program source*)
let symbol_rloc () : t = {
  loc_start = Parsing.symbol_start_pos ();
  loc_end = Parsing.symbol_end_pos ();
  loc_ghost = false
}

(*Same as [symbol_rloc] but designates the span as a ghost range*)
let symbol_gloc () : t =  { 
  loc_start = Parsing.symbol_start_pos ();
  loc_end = Parsing.symbol_end_pos ();
  loc_ghost = true
}
    </pre>
    

    <p>
     The <code>Parsing</code> functions <code>rhs_start</code>
     and <code>rhs_end</code> are the same
     as <code>symbol_start</code> and <code>symbol_end</code> but
     return the offset of the string matching the <code>n</code>-th
     item on the right-hand-side of the rule where <code>n</code> is
     the integer parameter to <code>rhs_start</code>
     and <code>rhs_end</code>. <code>n</code> is 1 for the leftmost
     item. <code>rhs_start_pos</code> and <code>rhs_end_pos</code>
     return a position instead of an offset.
     </p><pre>
(*Compute the span of the [n]th item of the right-hand-side of the
   matched rule*)
let rhs_loc n = {
  loc_start = Parsing.rhs_start_pos n;
  loc_end = Parsing.rhs_end_pos n;
  loc_ghost = false;
}
     </pre>
    

    <p>The type <code>'a</code> loc associates a value with a
    location.
    </p><pre>
(*A type for the association of a value with a location*)
type 'a loc = { 
  txt : 'a;
  loc : t; 
}

(*Create an ['a loc] value from an ['a] value and location*)
let mkloc (txt : 'a) (loc : t) : 'a loc = { txt ; loc }

(*Create an ['a loc] value bound to the distinguished location called
   [none]*)
let mknoloc (txt : 'a) : 'a loc = mkloc txt none
    </pre>
    

    <h2>Error reporting with locations</h2>
    <p>
    <code>Location</code> has a framework for error reporting across
    modules concerned with locations (think lexer, parser,
    type-checker, etc).
    </p><pre>
open Format

type error =
{
  loc : t;
  msg : string;
  sub : error list;
}

val error_of_printer : t &rarr;  (formatter &rarr; 'a &rarr; unit) &rarr; 'a &rarr; error
val errorf_prefixed : ?loc : t &rarr; ?sub : error list &rarr; ('a, Format.formatter, unit, error) format4 &rarr; 'a
    </pre>
    So, in the definition of the <code>error</code>
    record, <code>loc</code> is a location in the source
    code, <code>msg</code> an explanation of the error
    and <code>sub</code> a list of related errors.  We deal here with
    the error formatting functions. The utility
    function <code>print_error_prefix</code> simply writes an error
    prefix to a formatter.
    <pre>
let error_prefix = &quot;Error&quot;

let warning_prefix = &quot;Warning&quot;

let print_error_prefix (ppf : formatter) () : unit =
  fprintf ppf &quot;@{&lt;error&gt;%s@}:&quot; error_prefix;
  ()
    </pre>
    The syntax, &quot;<code>@{&lt;error&gt;%s}@</code>&quot; associates the embedded text
    with the named tag &quot;error&quot;.
  

  <p>
  Next another utility, <code>pp_ksprintf</code>.
  </p><pre>
let pp_ksprintf 
    ?(before : (formatter &rarr; unit) option) 
    (k : string &rarr; 'd)
    (fmt : ('a, formatter, unit, 'd) format4) : 'a =
  let buf = Buffer.create 64 in
  let ppf = Format.formatter_of_buffer buf in
  begin match before with
    | None &rarr; ()
    | Some f &rarr; f ppf
  end;
  kfprintf
    (fun (_ : formatter) : 'd &rarr;
      pp_print_flush ppf ();
      let msg = Buffer.contents buf in
      k msg)
    ppf fmt
    </pre>
    It proceeds as follows. A buffer and a formatter over that buffer
    is created. When presented with all of the arguments of the format
    operations implied by the <code>fmt</code> argument, if
    the <code>before</code> argument is non-empty, call it on the
    formatter. Finally, call <code>kfprintf</code> (from the standard
    library <code>Format</code> module) which performs the format
    operations on the buffer before handing control to a function that
    retrieves the contents of the now formatted buffer and passes them
    to the user provided continuation <code>k</code>.
    

    <p>With <code>pp_ksprintf</code> at our disposal, one can write
    the function <code>errorf_prefixed</code>.
    </p><pre>
let errorf_prefixed 
    ?(loc:t = none) 
    ?(sub : error list = []) 
    (fmt : ('a, Format.formatter, unit, error) format4) : 'a =
  let e : 'a =
    pp_ksprintf
      ~before:(fun ppf &rarr; fprintf ppf &quot;%a &quot; print_error_prefix ())
      (fun (msg : string) : error &rarr; {loc; msg; sub})
    fmt
  in e
    </pre>
    <code>errorf_prefixed</code> computes a function. The function it
    computes provides the means to produce <code>error</code> values
    by way of formatting operations to produce the <code>msg</code>
    field of the <code>error</code> result value. The formatting
    operations include prefixing the <code>msg</code> field with
    the <code>error_prefix</code> string. The type of the arguments of
    the computed function unifies with the type
    variable <code>'a</code>. In other words, the type of the computed
    function is <code>'a &rarr; error</code>. For example, the type
    of <code>errorf_prefixed &quot;%d %s&quot;</code> is <code>int &rarr; string &rarr;
    error</code>.
    

    <p>
    The groundwork laid with <code>errorf_prefixed</code> above means
    a polymorphic function <code>error_of_printer</code> can now be
    produced.
    </p><pre>
let error_of_printer 
    (loc : t) 
    (printer : formatter &rarr; 'error_t &rarr; unit) 
    (x : 'error_t) : error =
  let mk_err : 'error_t &rarr; error = 
    errorf_prefixed ~loc &quot;%a@?&quot; printer in
  mk_err x
      </pre>
    The idea is that <code>error_of_printer</code> is provided a
    function that can format a value of type <code>'error</code>. This
    function is composed with <code>errorf_prefixed</code> thereby
    producing a function of type <code>'error &rarr; error</code>. For
    example, we can illustrate how this works by making an error of a
    simple integer with code like the following:
    <pre>
# error_of_printer none (fun ppf x &rarr; Format.fprintf ppf &quot;Code %d&quot; x) 3;;
- : error =
{loc =
  {loc_start =
    {pos_fname = &quot;_none_&quot;; pos_lnum = 1; pos_bol = 0; pos_cnum = -1};
   loc_end = {pos_fname = &quot;_none_&quot;; pos_lnum = 1; pos_bol = 0; pos_cnum = -1};
   loc_ghost = true};
 msg = &quot;Error: Code 3&quot;; sub = []}
    </pre>
    
    <p>So, that's <code>error_of_printer</code>. The following utility
    function is much simpler - it simply writes a given filename to a
    formatter.
    </p><pre>
let print_filename (ppf : formatter) (file : string) : unit =
  fprintf ppf &quot;%s&quot; file
    </pre>
    Next, a set of constants for consistent messages that involve
    locations and a function to get the file, line and column of a
    position.
    <pre>
let (msg_file, msg_line, msg_chars, msg_to, msg_colon) =
    (&quot;File \&quot;&quot;,        (*'msg file'*)
     &quot;\&quot;, line &quot;,      (*'msg line'*)
     &quot;, characters &quot;,  (*'msg chars'*)
     &quot;-&quot;,              (*'msg to'*)
     &quot;:&quot;)              (*'msg colon'*)

let get_pos_info pos = (pos.pos_fname, pos.pos_lnum, pos.pos_cnum - pos.pos_bol)
    </pre>
    Making use of the above we have now <code>print_loc</code> : a
    function to print a location on a formatter in terms of file, line
    and character numbers.
    <pre>
let print_loc (ppf : formatter) (loc : t) : unit  =
  let (file, line, startchar) = get_pos_info loc.loc_start in
  let endchar = loc.loc_end.pos_cnum - loc.loc_start.pos_cnum + startchar in
  if file = &quot;//toplevel//&quot; then
    fprintf ppf &quot;Characters %i-%i&quot;
      loc.loc_start.pos_cnum loc.loc_end.pos_cnum
  else begin
    fprintf ppf &quot;%s@{&lt;loc&gt;%a%s%i&quot; msg_file print_filename file msg_line line;
    if startchar &gt;= 0 then
      fprintf ppf &quot;%s%i%s%i&quot; msg_chars startchar msg_to endchar;
    fprintf ppf &quot;@}&quot;
  end
</pre>
Locations generally speaking come out in a
    format along the lines of: <code>File &quot;&lt;string&gt;, line 1,
    characters 0-10:&quot;</code>
<pre>
let print (ppf : formatter) (loc : t) : unit =
  (* The syntax, [@{&lt;loc&gt;%a@}] associates the embedded text with the
     named tag 'loc'*)
  fprintf ppf &quot;@{&lt;loc&gt;%a@}%s@.&quot; print_loc loc msg_colon
    </pre>
    That last function, <code>print</code> is just a small wrapper
    over <code>print_loc</code> that appends a colon to the location.
    

    <h2>Exception handling involving errors with locations</h2>
    <p>This section is concerned with the following section of
    the <code>Location</code>'s signature.
    </p><pre>
val register_error_of_exn : (exn &rarr; error option) &rarr; unit
val error_of_exn : exn &rarr; error option
val error_reporter : (formatter &rarr; error &rarr; unit) ref
val report_error : formatter &rarr; error &rarr; unit
val report_exception : formatter &rarr; exn &rarr; unit
    </pre>
    <code>Location</code> contains a mutable list of exception
    handlers where an exception handler is a function of
    type <code>exn &rarr; error option</code>.
    <pre>
let error_of_exn : (exn &rarr; error option) list ref = ref []
    </pre>
    A function is provided that adds an exception handler to the above
    list.
    <pre>
let register_error_of_exn f = error_of_exn := f :: !error_of_exn
    </pre>
    The next function <code>error_of_exn</code> (yes, it is the only
    remaining function that manipulates the
    list <code>error_exn</code> previously defined directly) walks the
    list looking for a handler returning the contents of the result of
    the first such function that doesn't return a <code>None</code>
    value.
    <pre>
let error_of_exn exn =
  let rec loop = function
    | [] &rarr; None
    | f :: rest &rarr;
      match f exn with
      | Some _ as r &rarr; r
      | None &rarr; loop rest
  in
  loop !error_of_exn
    </pre>
    
    <p>We define now a &quot;default&quot; error reporting function. Given a
    formatter and an error, write the error location, an explanation
    of the error to the formatter and the same for any associated
    &quot;sub&quot; errors.
    </p><pre>
let rec default_error_reporter 
    (ppf : formatter) ({loc; msg; sub} : error) : unit =
  print ppf loc;
  Format.pp_print_string ppf msg;
  List.iter (Format.fprintf ppf &quot;@\n@[&lt;2&gt;%a@]&quot; default_error_reporter) sub
    </pre>
    Now, <code>error_reporter</code> itself is a reference cell with
    default value <code>default_error_reporter</code>.
    <pre>
let error_reporter = ref default_error_reporter
    </pre>
    This next function, <code>print_updating_num_loc_lines</code>
    looks more complicated than it is but does demonstrate a rather
    advanced usage of <code>Format</code> by containing calls to the
    functions <code>pp_get_formatter_out_functions</code>,
    <code>pp_set_formatter_out_functions</code> to tempoarily replace
    the default function for writing strings. The semantic of the
    function is to print an error on a formatter incidentally
    recording the number of lines required to do so.
    <pre>
(* A mutable line count*)
let num_loc_lines : int ref = ref 0

(*Prints an error on a formatter incidentally recording the number of
  lines required to do so*)
let print_updating_num_loc_lines 
    (ppf : formatter) 
    (f : formatter &rarr; error &rarr; unit) 
    (arg : error) : unit =
  (*A record of functions of output primitives*)
  let out_functions : formatter_out_functions
      = pp_get_formatter_out_functions ppf () in
  (*The strategoy is to temporarily replace the basic function for
    writing a string with this one*)
  let out_string (str : string) (start : int) (len : int) : unit =
    (*A function for counting line breaks in [str]. [c] is the current
      count, [i] is the current char under consideration*)
    let rec count (i : int) (c : int) : int=
      if i = start + len then c
      else if String.get str i = '\n' then count (succ i) (succ c)
      else count (succ i) c 
    in
    (*Update the count*)
    num_loc_lines := !num_loc_lines + count start 0;
    (*Write the string to the formatter*)
    out_functions.out_string str start len 
  in
  (*Replace the standard string output primitive with the one just
    defined *)
  pp_set_formatter_out_functions ppf 
    {out_functions with out_string} ;
  (*Write the error to the formatter*)
  f ppf arg ;
  pp_print_flush ppf ();
  (*Restore the standard primitive*)
  pp_set_formatter_out_functions ppf out_functions
    </pre>
    The function <code>report_error</code> uses the currently
    installed error reporter to write an error report for a given
    error and formatter incidentally updating a count indicating the
    number of lines written.
    <pre>
let report_error (ppf : formatter) (err : error) : unit=
  print_updating_num_loc_lines ppf !error_reporter err
    </pre>
    
    <p>This next function, <code>report_exception_rec</code> tries a
    number of times to find a handler for a given error and if
    successful formats it. In the worst case a handler is never found
    and the exception propogates.
    </p><pre>
let rec report_exception_rec (n : int) (ppf : formatter) (exn : exn) : unit =
  (*Try to find a handler for the exception*)
  try match error_of_exn exn with
  | Some err &rarr; 
    (*Format the resulting error using the current error reporter*)
    fprintf ppf &quot;@[%a@]@.&quot; report_error err 
  (*The syntax @[%a@]@ writes function output in a box followed by a
    'cut' break hint*)
  | None &rarr; raise exn (*A handler could not be found*)
  with exn when n &gt; 0 &rarr;
    (*A handler wasn't found. Try again*)
    report_exception_rec (n - 1) ppf exn
    </pre>
    The last piece is <code>report_exception</code>. It attempts to
    write an error report for the given exception on the provided
    formatter. The exception can be re-raised if no handler is found.
    <pre>
let report_exception (ppf : formatter) (exn : exn) : unit = 
  report_exception_rec 5 ppf exn
    </pre>
    

    <h3>Usage</h3>

    <p>In this section we see how an example of how the above
    machinery is used. Consider defining a lexical analyzer as an
    example. Suppose the scanner is defined by the
    file <code>lexer.mll</code> (the input file
    to <code>ocamllex</code>). We can imagine its header containing
    code like the following.
    </p><pre>
     {
        (*The cases of lexer errors*)
        type error =
          | Illegal_character of char
          | Unterminated_comment of Location.t

        (*The lexer exception type*)
        exception Error of error * Location.t

        (*This function takes a formatter and an instance of type
          [error] and writes a message to the formatter explaining the
          meaning. This is a &quot;printer&quot;*)
        let report_error (ppf : Format.formatter) : error &rarr; unit = function
         | Illegal_character c &rarr; 
            Format.fprintf ppf &quot;Illegal character (%s)&quot; (Char.escaped c)
         | Unterminated_comment _ &rarr; 
            Format.fprintf ppf &quot;Comment not terminated&quot;

        (*Note that [report_error] is a function that unifies with
          the [formatter &rarr; 'a &rarr; unit] parameter of
          [error_of_printer]*)

        (*Register an exception handler for the lexer exception type*)
        let () =
         Location.register_error_of_exn
          (function
           | Error (err, loc) &rarr;
              Some (Location.error_of_printer loc report_error err)
           | _ &rarr;  None
          )
     }

     /*...*/
     rule token = ...
    </pre>
    A function to handle errors with attached locations (in a REPL for
    example) is expressible as an idiom as simple as something like
    this.
    <pre>
let handle_interpreter_error ?(finally=(fun () &rarr; ())) ex =
  finally ();
  Location.report_exception (Format.std_formatter) ex

let safe_proc ?finally f =
  try f ()
  with exn &rarr; handle_interpreter_error ?finally exn
    </pre>
    
    <hr/>
  </body>
</html>

