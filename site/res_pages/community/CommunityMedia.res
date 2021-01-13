module LINK = Markdown.LINK

let s = React.string

let default = () =>
  <>
  <h1>{s(`Videos and Media`)}</h1>
  <p>
    {s(`Many videos about OCaml can be found on vimeo and youtube:`)}
    <ul>
      <li><LINK href="https://vimeo.com/search?q=ocaml">{s(`vimeo ocaml video results`)}</LINK></li>
      <li><LINK href="https://www.youtube.com/results?search_query=ocaml">{s(`youtube ocaml video results`)}</LINK></li>
    </ul>
  </p>
  <p>
    <LINK href="https://vimeo.com/user20888710/videos">{s(`John Whittington's videos for OCaml beginners`)}</LINK>
    {s(` explains basic ideas about OCaml.`)}
    {s(`. They are good companion material to `)}
    <LINK href="http://ocaml-book.com/">{s(`John Whittington's books for OCaml beginners`)}</LINK>
    {s(` (the videos do not require or depend on them though).`)} 
  </p>
  <p>
    <LINK href="http://vimeo.com/user8856528/videos">{s(`Dan Ghica's Foundations of Computer Science lectures`)}</LINK>
    {s(` use OCaml.`)}
  </p>
  <p>
    <LINK href="http://events.inf.ed.ac.uk/Milner2012/X_Leroy-html5-mp4.html">{s(`"The continuation of functional programming by other means" talk`)}</LINK>
    {s(`, Xavier Leroy`)}
  </p>
  <p>
    {s(`See the longer `)}
    <LINK href="http://vimeo.com/21564387">{s(`Effective ML (2011, Harvard CS51), Part 1 talk`)}</LINK>
    {s(` and `)}
    <LINK href="http://vimeo.com/21564926">{s(`Effective ML (2011, Harvard CS51), Part 2 talk`)}</LINK>
    {s(`. `)}
  </p>
  <p>
    {s(`At CMU, Yaron Minsky gave a `)}
    <LINK href="http://vimeo.com/14317442">{s(`talk titled "Caml Trading" about OCaml's strengths`)}</LINK>
    {s(`. It explains how the robustness, efficiency, and expressiveness of OCaml is used to 
    outperform the competition in the financial world.`)}
  </p>
  <p>
    <LINK href="http://vimeo.com/6652523">
      {s(`"Experience Report: OCaml for an Industrial-strength Static Analysis Framework" talk`)}
    </LINK>
    {s(` from `)}
    <LINK href="http://vimeo.com/user2191865">{s(`Malcolm Wallace`)}</LINK>
    {s(` on Vimeo.`)}
  </p>
  </>
