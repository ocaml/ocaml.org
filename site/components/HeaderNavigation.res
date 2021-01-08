module Link = Next.Link;

@react.component
let make = (~editpath) => {
    let editUrl = "https://github.com/ocaml/ocaml.org/edit/master/" ++ editpath;
    <nav
      role="navigation"
      ariaLabel="Main"
      className="p-2 h-12 flex border-b border-gray-200 items-center text-sm">

      <Link href="/">
        <a className="flex items-center w-1/3">
          {/* TODO: add ocaml logo */ React.null}
          <span className="text-xl ml-2 align-middle font-semibold text-ocamlorange">
          {React.string("OCaml")}
          </span>
        </a>
      </Link>
      
      <div className="flex w-2/3 justify-end">
        <Link href="/learn"> <a className="px-3"> {React.string("Learn")} </a> </Link>
        <Link href="/documentation"> <a className="px-3"> {React.string("Documentation")} </a> </Link>
        <a 
          className="px-3 font-bold"
          target="_blank"
          href="https://opam.ocaml.org">
          {React.string("Packages")} 
        </a>
        <Link href="/community"> <a className="px-3"> {React.string("Community")} </a> </Link>
        <Link href="/news"> <a className="px-3"> {React.string("News")} </a> </Link>
        <span role="search" className="px-3"> {React.string("Search")} </span>
        <a 
          className="px-3 font-bold"
          target="_blank"
          href={editUrl}>
          {React.string("Edit")}
        </a>
      </div>

    </nav>;
}
