module LINK = Markdown.LINK

let s = React.string

let default = () => <>
  <h1> {s(`OCaml logo`)} </h1>
  <p>
    {s(`Web sites related to the OCaml language or that use it are encouraged to 
      incorporate the OCaml logo somewhere in their page to indicate their support 
      for OCaml development. The logo should be linked to the OCaml website, ocaml.org. 
      The `)}
    <LINK href="https://github.com/ocaml/ocaml-logo/tree/master/Colour">
      {s(`logo is available in several formats`)}
    </LINK>
    {s(`. Also, the `)}
    <LINK href="https://github.com/ocaml/ocaml-logo">
      {s(`logo is available in several colors`)}
    </LINK>
    {s(`. Two versions are displayed below. To include one of them on your web page,
      just copy and paste the associated HTML code and tweak it (e.g. adapt the `)}
    <code> {s(`width`)} </code>
    {s(` or change the part after `)}
    <code> {s(`logo/`)} </code>
    {s(` to match the path of the file you want to use in the `)}
    <LINK href="https://github.com/ocaml/ocaml-logo"> {s(`logo repository`)} </LINK>
    {s(`). The `)}
    <LINK href="https://github.com/ocaml/ocaml.org/blob/master/LICENSE.md">
      {s(`OCaml logo is released under a liberal license`)}
    </LINK>
    {s(`.`)}
  </p>
  <p> {s(`Here is one example:`)} </p>
  <pre>
    <code>
      {s(`<a href="http://ocaml.org">
  <img src="http://ocaml.org/logo/Colour/PNG/colour-logo.png"
       alt="OCaml"
       style="border: none; width: 150px;" />
</a>`)}
    </code>
  </pre>
  <p> {s(`Here is another example:`)} </p>
  <pre>
    <code>
      {s(`<a href="http://ocaml.org">
  <img src="http://ocaml.org/logo/Colour/SVG/colour-logo.svg"
       alt="OCaml"
       style="border: none; width: 150px;" />
</a>`)}
    </code>
  </pre>
  <h2> {s(`Stickers`)} </h2>
  <img
    style={ReactDOM.Style.make(~width="150px", ())}
    src="/static/OCaml_Sticker.svg"
    alt="OCaml logo for sticker"
  />
  <p>
    {s(`The `)}
    <LINK href="https://ocaml.org/img/OCaml_Sticker.svg"> {s(`OCaml sticker SVG file`)} </LINK>
    {s(` is suitable to make stickers, as seen in this `)}
    <LINK href="https://twitter.com/ocamllabs/status/761191421680422912">
      {s(`tweet announcing stickers made`)}
    </LINK>
    {s(`. Similar to the logo, the `)}
    <LINK href="https://github.com/ocaml/ocaml.org/blob/master/LICENSE.md">
      {s(`OCaml sticker file is released under a liberal license`)}
    </LINK>
    {s(`, so do no hesitate to print your own stickers to promote OCaml!`)}
  </p>
  <p>
    {s(`Before printing some stickers, it would be great if you tweeted it with 
      tag `)}
    <code> {s(`#OCaml`)} </code>
    {s(` and mentioning "stickers", similar to these `)}
    <LINK href="https://twitter.com/search?q=%23OCaml%20stickers&src=typd">
      {s(`OCaml stickers tweets`)}
    </LINK>
    {s(`, so that other interested people in your area can get in touch with you!`)}
  </p>
</>
