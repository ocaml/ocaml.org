module Link = Next.Link;
module UL = Markdown.UL;

// TODO: rename this file to index.re once duplicate names issue resolved
module P = {
  @react.component
  let make = (~children) => <p className="mb-6"> children </p>;
};
module H1 = {
  // TODO: use mb-1.5 and tailwind 2
  @react.component
  let make = (~children) => 
    <h1 className="font-sans text-4xl font-bold leading-snug mb-2"> children </h1>;
};
// TODO: I haven't been able to implement "A" without include "Link" yet. Troubleshoot why
module LINK = {
  @react.component
  let make = (~href, ~children) => 
    <Link href={href}><a className="text-ocamlorange hover:underline"> children </a></Link>;
};
module AEXT = {
  @react.component
  let make = (~children, ~href) => 
    <a href={href} className="text-ocamlorange hover:underline" target="_blank" > children </a>;
};

let default = () =>
  <>
    <H1>{React.string("Releases")}</H1>
    <P>{React.string("The ")} 
    <LINK href="/releases/latest/">{React.string("latest")}</LINK>
    {React.string(" page points to the most recent release of the OCaml compiler 
     distribution. Below is a list of the recent releases.")}
    </P>
    <P>{React.string("See also the ")}
    <LINK href="/docs/install.html">{React.string("install")}</LINK>
    {React.string(" page for instructions on installing OCaml by other means, such as
    the OPAM package manager and platform specific package managers.")}
    </P>
    <UL>
    <li>
    {React.string("OCaml ")}
    <LINK href="/releases/4.11.1.html">{React.string("4.11.1")}</LINK>
    {React.string(", released Aug 31, 2020.")}
    </li>
    <li>
    {React.string("OCaml ")}
    <LINK href="/releases/4.11.0.html">{React.string("4.11.0")}</LINK>
    {React.string(", released Aug 19, 2020.")}
    </li>
    <li>
    {React.string("OCaml ")}
    <LINK href="/releases/4.10.1.html">{React.string("4.10.1")}</LINK>
    {React.string(", released Aug 20, 2020.")}
    </li>
    <li>
    {React.string("OCaml ")}
    <LINK href="/releases/4.10.0.html">{React.string("4.10.0")}</LINK>
    {React.string(", released Feb 21, 2020.")}
    </li>
    <li>
    {React.string("OCaml ")}
    <LINK href="/releases/4.09.1.html">{React.string("4.09.1")}</LINK>
    {React.string(", released Mar 18, 2020.")}
    </li>
    <li>
    {React.string("OCaml ")}
    <LINK href="/releases/4.09.0.html">{React.string("4.09.0")}</LINK>
    {React.string(", released Sep 18, 2019.")}
    </li>
    <li>
    {React.string("OCaml ")}
    <LINK href="/releases/4.08.1.html">{React.string("4.08.1")}</LINK>
    {React.string(", released Aug 5, 2019.")}
    </li>
    <li>
    {React.string("OCaml ")}
    <LINK href="/releases/4.08.0.html">{React.string("4.08.0")}</LINK>
    {React.string(", released Jun 14, 2019.")}
    </li>
    <li>
    {React.string("OCaml ")}
    <LINK href="/releases/4.07.1.html">{React.string("4.07.1")}</LINK>
    {React.string(", released Oct 4, 2018.")}
    </li>
    <li>
    {React.string("OCaml ")}
    <LINK href="/releases/4.07.0.html">{React.string("4.07.0")}</LINK>
    {React.string(", released Jul 10, 2018.")}
    </li>
    <li>
    {React.string("OCaml ")}
    <LINK href="/releases/4.07.0.html">{React.string("4.07.0")}</LINK>
    {React.string(", released Jul 10, 2018.")}
    </li>
    <li>
    {React.string("OCaml ")}
    <LINK href="/releases/4.06.1.html">{React.string("4.06.1")}</LINK>
    {React.string(", released Feb 16, 2018.")}
    </li>
    <li>
    {React.string("OCaml ")}
    <LINK href="/releases/4.06.0.html">{React.string("4.06.0")}</LINK>
    {React.string(", released Nov 3, 2017.")}
    </li>
    <li>
    {React.string("OCaml ")}
    <LINK href="/releases/4.05.0.html">{React.string("4.05.0")}</LINK>
    {React.string(", released July 13, 2017.")}
    </li>
    <li>
    {React.string("OCaml ")}
    <LINK href="/releases/4.04.2.html">{React.string("4.04.2")}</LINK>
    {React.string(", released Jun 23, 2017.")}
    </li>
    <li>
    {React.string("OCaml ")}
    <LINK href="/releases/4.04.1.html">{React.string("4.04.1")}</LINK>
    {React.string(", released Apr 14, 2017.")}
    </li>
    <li>
    {React.string("OCaml ")}
    <LINK href="/releases/4.04.0.html">{React.string("4.04.0")}</LINK>
    {React.string(", released Nov 4, 2016.")}
    </li>
    <li>
    {React.string("OCaml ")}
    <LINK href="/releases/4.03.0.html">{React.string("4.03.0")}</LINK>
    {React.string(", released Apr 25, 2016.")}
    </li>
    <li>
    {React.string("OCaml ")}
    <LINK href="/releases/4.02.3.html">{React.string("4.02.3")}</LINK>
    {React.string(", released Jul 27, 2015.")}
    </li>
    <li>
    {React.string("OCaml ")}
    <LINK href="/releases/4.02.2.html">{React.string("4.02.2")}</LINK>
    {React.string(", released Jun 17, 2015.")}
    </li>
    <li>
    {React.string("OCaml ")}
    <LINK href="/releases/4.02.1.html">{React.string("4.02.1")}</LINK>
    {React.string(", released Oct 14, 2014.")}
    </li>
    <li>
    {React.string("OCaml ")}
    <LINK href="/releases/4.02.0.html">{React.string("4.02.0")}</LINK>
    {React.string(", released Aug 29, 2014.")}<br />
    {React.string("(4.02.0 suffers from one known bug that noticeably increases compilation time,
    you should use 4.02.1 or later versions instead.)")}
    </li>
    <li>
    {React.string("OCaml ")}
    <LINK href="/releases/4.01.0.html">{React.string("4.01.0")}</LINK>
    {React.string(", released Sep 12, 2013.")}
    </li>
    <li>
    {React.string("OCaml ")}
    <LINK href="/releases/4.00.1.html">{React.string("4.00.1")}</LINK>
    {React.string(", released Oct 5, 2012.")}
    </li>
    <li>
    {React.string("OCaml ")}
    <LINK href="/releases/3.12.1.html">{React.string("3.12.1")}</LINK>
    {React.string(", released July 4, 2011.")}
    </li>
    <li>
    {React.string("Earlier releases are available ")}
    <AEXT href="http://caml.inria.fr/pub/distrib/">{React.string("here")}</AEXT>
    {React.string(".")}
    </li>
    </UL>
    <P>{React.string("You may also want to check the ")} 
    <AEXT href="https://github.com/ocaml/ocaml">{React.string("development version")}</AEXT>
    {React.string(" of OCaml.")}
    </P>
  </>;
