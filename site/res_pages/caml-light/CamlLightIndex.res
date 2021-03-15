module LINK = Markdown.LINK

let s = React.string

let default = () => <>
  <h1> {s(`Caml Light`)} </h1>
  <h2> {s(`Overview`)} </h2>
  <p>
    {s(`Caml Light is a lightweight, portable implementation of the core Caml language that was 
        developed in the early 1990's, as a precursor to OCaml. It used to run on most Unix machines, 
        as well as PC under Microsoft Windows. The implementation is obsolete, no longer actively 
        maintained, and will be removed eventually. We recommend switching immediately to its 
        successor, OCaml.`)}
  </p>
  <p>
    {s(`Caml Light is implemented as a bytecode compiler, and fully bootstrapped. The runtime 
        system and bytecode interpreter is written in standard C, hence Caml Light is easy to port 
        to almost any 32 or 64 bit platform. The whole system is quite small: about 100K for the 
        runtime system, and another 100K of bytecode for the compiler. Two megabytes of memory is 
        enough to recompile the whole system.`)}
  </p>
  <p>
    <LINK href="/learn/tutorials/debug">
      {s(`Debugging is possible by tracing function calls`)}
    </LINK>
    {s(` in the same way as in OCaml. In the example therein, one should write `)}
    <code> {s(`trace "fib";;`)} </code>
    {s(` instead of `)}
    <code> {s(`#trace fib;;`)} </code>
    {s(` and `)}
    <code> {s(`untrace "fib";;`)} </code>
    {s(` instead of `)}
    <code> {s(`#untrace fib;;`)} </code>
    {s(`. There also exists a debugger, as a user contribution.`)}
  </p>
  <p>
    {s(`Some common questions are answered in the `)}
    <LINK href="/caml-light/faq"> {s(`Frequently Asked Questions`)} </LINK>
    {s(`.`)}
  </p>
  <h2> {s(`Availability`)} </h2>
  <p>
    {s(`The Caml Light system is open source software. Please read the `)}
    <LINK href="/caml-light/license"> {s(`Caml Light license`)} </LINK>
    {s(` for more details. The `)}
    <LINK href="/caml-light/releases"> {s(`latest release`)} </LINK>
    {s(` can be freely downloaded on this site, together with its `)}
    <LINK href="http://caml.inria.fr/pub/docs/manual-caml-light/"> {s(`user's manual`)} </LINK>
    {s(`. See also `)}
    <LINK href="http://caml.inria.fr/pub/docs/fpcl/index.html">
      {s(`"Functional programming using Caml Light" guide`)}
    </LINK>
    {s(` for an introduction to functional programming 
        in general and the Caml Light language in particular.`)}
  </p>
</>
