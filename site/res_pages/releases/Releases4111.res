module LINK = Markdown.LINK

let s = React.string

let default = () =>
  <>
  <h1>{s(`OCaml 4.11.1`)}</h1>
    <p>
      {s(`This page describe OCaml `)}
      <strong>{s(`4.11.1`)}</strong>
      {s(`, released on Aug 31, 2020. It is a bug-fix `)}
      <LINK href="/releases/4.11.0">{s(`release of OCaml 4.11.0`)}</LINK>
      {s(`.`)}
    </p>
  <h2>{s(`Bug fixes:`)}</h2>
    <ul>
      <li>
        {s(`#9856, #9857: `)}
        <LINK href="https://github.com/ocaml/ocaml/issues/9856">
          {s(`Issue: Prevent polymorphic type annotations from generalizing weak polymorphic variables`)}
        </LINK>
        {s(`. `)}
        <LINK href="https://github.com/ocaml/ocaml/issues/9857">
          {s(`PR: Prevent polymorphic type annotations from generalizing weak polymorphic variables`)}
        </LINK>
        {s(`. (Leo White, report by Thierry Martinez, review by Jacques Garrigue)`)}
      </li>
      <li>
        {s(`#9859, #9862: `)}
        <LINK href="https://github.com/ocaml/ocaml/issues/9859">
          {s(`Issue: Remove an erroneous assertion when inferred function types appear in the right 
          hand side of an explicit :> coercion`)}
        </LINK>
        {s(`. `)}
        <LINK href="https://github.com/ocaml/ocaml/issues/9862">
          {s(`PR: Remove an erroneous assertion when inferred function types appear in the right 
          hand side of an explicit :> coercion`)}
        </LINK>
        {s(`. (Florian Angeletti, report by Jerry James, review by Thomas Refis)`)}
      </li>
    </ul>
  </>
