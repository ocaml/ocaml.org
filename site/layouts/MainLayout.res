module Link = Next.Link;

// Converting this file to rescript causes the stylesheets
//  to fail to load. Need to troubleshoot further.
module Navigation = {
  @react.component
  let make = (~editpath) => {
    let editUrl = "https://github.com/ocaml/ocaml.org/edit/master/" ++ editpath;
    <nav
      className="p-2 h-12 flex border-b border-gray-200 justify-between items-center text-sm">
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
        <span className="px-3"> {React.string("Search")} </span>
        <a 
          className="px-3 font-bold"
          target="_blank"
          href={editUrl}>
          {React.string("Edit")}
        </a>
      </div>
    </nav>;
  }
};

@react.component
let make = (~children, ~editpath) => {
  let minWidth = ReactDOMRe.Style.make(~minWidth="20rem", ());
  <div style=minWidth className="flex lg:justify-center">
    <div className="max-w-5xl w-full lg:w-3/4 text-gray-900 font-base">
      <Navigation editpath={editpath} />
      <main className="mt-4 mx-4"> children </main>
    </div>
  </div>;
};
