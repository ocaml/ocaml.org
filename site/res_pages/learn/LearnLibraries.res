module LINK = Markdown.LINK

let s = React.string

let default = () =>
  <>
  <h1>{s(`Libraries`)}</h1>
  <p>
    {s(`There are thousands of OCaml libraries available. Here is a list of the most 
    popular sites where you can find them.`)}
    <ul>
      <li>
        <LINK href="http://opam.ocaml.org/">{s(`Official OPAM repository`)}</LINK>
        {s(` is the first place to check. The most high quality and most widely used libraries 
        are provided as OPAM packages.`)}
      </li>
      <li>
        {s(`GitHub is an extremely popular code hosting site. `)}
        <LINK href="https://github.com/trending/ocaml">
          {s(`Github is very widely used amongst OCaml programmers`)}
        </LINK> 
        {s(`. Click the link to find OCaml projects. Remember that many of these libraries are 
        provided as OPAM packages, so you'll have already found them in OPAM. However, there are 
        some libraries here that people haven't pushed to OPAM for one reason or another.`)}
      </li>
      <li>
        <LINK href="https://bitbucket.org/repo/all/relevance?name=ocaml&language=ocaml">
          {s(`Bitbucket is a far less used code hosting site`)}
        </LINK>
        {s(` amongst OCaml programmers. Click the link to find OCaml libraries.`)}
      </li>
      <li>
        <LINK href="http://caml.inria.fr/cgi-bin/hump.en.cgi">
          {s(`Caml Hump is a deprecated site for OCaml libraries`)}
        </LINK>
        {s(`. For many years, it was the definitive source to search for OCaml libraries. It is 
        hosted on the old caml.inria.fr, which is being retained because there are many links on 
        the internet pointing to this site, but is no longer maintained. You should not rely on 
        it for up-to-date information.`)}
      </li>
    </ul>
  </p>
  </>
