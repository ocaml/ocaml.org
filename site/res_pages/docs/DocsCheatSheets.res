module LINK = Markdown.LINK

let s = React.string

let default = () => <>
  <h1> {s(`Cheat Sheets`)} </h1>
  <p>
    {s(`OCamlPro has published the following cheat sheets (one or two-page summaries) on OCaml. `)}
    <LINK href="http://www.ocamlpro.com/"> {s(`(Learn more about OCamlPro here)`)} </LINK>
    <ul>
      <li>
        <LINK href="http://www.ocamlpro.com/wp-content/uploads/2019/09/ocaml-lang.pdf">
          {s(`The OCaml Language Cheat Sheet (PDF)`)}
        </LINK>
        {s(`, updated September 2019`)}
        <br />
        {s(`General overview of the OCaml language: basic data types, basic 
        concepts, functions, modules, etc.`)}
      </li>
      <li>
        <LINK href="http://www.ocamlpro.com/files/ocaml-tools.pdf">
          {s(`OCaml Standard Tools Cheat Sheet (PDF)`)}
        </LINK>
        {s(`, updated June 2011`)}
        <br />
        {s(`Overview of OCaml compilers and their options, tools for lexing 
        and parsing, Makefile rules, etc.`)}
      </li>
      <li>
        <LINK href="http://www.ocamlpro.com/wp-content/uploads/2019/09/ocaml-stdlib.pdf">
          {s(`OCaml Standard Library Cheat Sheet (PDF)`)}
        </LINK>
        {s(`, updated September 2019`)}
        <br />
        {s(`Overview of the standard library's most common modules.`)}
      </li>
      <li>
        <LINK href="http://www.ocamlpro.com/files/tuareg-mode.pdf">
          {s(`OCaml Emacs Mode (Tuareg) Cheat Sheet (PDF)`)}
        </LINK>
        {s(`, updated June 2011`)}
        <br />
        {s(`Overview of the Emacs Tuareg mode keyboard shortcuts.`)}
      </li>
    </ul>
  </p>
</>
