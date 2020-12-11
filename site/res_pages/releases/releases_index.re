module Link = Next.Link;

// TODO: rename this file to index.re once duplicate names issue resolved
module P = {
  [@react.component]
  let make = (~children) => <p className="mb-6"> children </p>;
};
module H1 = {
  [@react.component]
  let make = (~children) => 
    <h1 className="font-sans text-4xl font-bold leading-snub mb-1.5"> children </h1>;
};
module UL = {
  [@react.component]
  let make = (~children) => 
    <ul className="mb-6 ml-6 -mt-3 list-disc"> children </ul>;
};
module LI = {
  [@react.component]
  let make = (~children) => 
    <li className="mb-3"> children </li>;
};
module A = {
  [@react.component]
  let make = (~children) => 
    <a className="text-ocamlorange hover:underline"> children </a>;
};
module AEXT = {
  [@react.component]
  let make = (~children, ~href) => 
    <a href={href} className="text-ocamlorange hover:underline" target="_blank" > children </a>;
};

let default = () =>
  <>
    <H1>{React.string("Releases")}</H1>
    <P>{React.string("The ")} 
    <Link href="/releases/latest/"><A>{React.string("latest")}</A></Link>
    {React.string(" page points to the most recent release of the OCaml compiler 
     distribution. Below is a list of the recent releases.")}
    </P>
    <P>{React.string("See also the ")}
    <Link href="/docs/install.html"><A>{React.string("install")}</A></Link>
    {React.string(" page for instructions on installing OCaml by other means, such as
    the OPAM package manager and platform specific package managers.")}
    </P>
    <UL>
    <LI>
    {React.string("OCaml ")}
    <Link href="/releases/4.11.1.html"><A>{React.string("4.11.1")}</A></Link>
    {React.string(", released Aug 31, 2020.")}
    </LI>
    <LI>
    {React.string("OCaml ")}
    <Link href="/releases/4.11.0.html"><A>{React.string("4.11.0")}</A></Link>
    {React.string(", released Aug 19, 2020.")}
    </LI>
    <LI>
    {React.string("OCaml ")}
    <Link href="/releases/4.10.1.html"><A>{React.string("4.10.1")}</A></Link>
    {React.string(", released Aug 20, 2020.")}
    </LI>
    <LI>
    {React.string("OCaml ")}
    <Link href="/releases/4.10.0.html"><A>{React.string("4.10.0")}</A></Link>
    {React.string(", released Feb 21, 2020.")}
    </LI>
    <LI>
    {React.string("OCaml ")}
    <Link href="/releases/4.09.1.html"><A>{React.string("4.09.1")}</A></Link>
    {React.string(", released Mar 18, 2020.")}
    </LI>
    <LI>
    {React.string("OCaml ")}
    <Link href="/releases/4.09.0.html"><A>{React.string("4.09.0")}</A></Link>
    {React.string(", released Sep 18, 2019.")}
    </LI>
    <LI>
    {React.string("OCaml ")}
    <Link href="/releases/4.08.1.html"><A>{React.string("4.08.1")}</A></Link>
    {React.string(", released Aug 5, 2019.")}
    </LI>
    <LI>
    {React.string("OCaml ")}
    <Link href="/releases/4.08.0.html"><A>{React.string("4.08.0")}</A></Link>
    {React.string(", released Jun 14, 2019.")}
    </LI>
    <LI>
    {React.string("OCaml ")}
    <Link href="/releases/4.07.1.html"><A>{React.string("4.07.1")}</A></Link>
    {React.string(", released Oct 4, 2018.")}
    </LI>
    <LI>
    {React.string("OCaml ")}
    <Link href="/releases/4.07.0.html"><A>{React.string("4.07.0")}</A></Link>
    {React.string(", released Jul 10, 2018.")}
    </LI>
    <LI>
    {React.string("OCaml ")}
    <Link href="/releases/4.07.0.html"><A>{React.string("4.07.0")}</A></Link>
    {React.string(", released Jul 10, 2018.")}
    </LI>
    <LI>
    {React.string("OCaml ")}
    <Link href="/releases/4.06.1.html"><A>{React.string("4.06.1")}</A></Link>
    {React.string(", released Feb 16, 2018.")}
    </LI>
    <LI>
    {React.string("OCaml ")}
    <Link href="/releases/4.06.0.html"><A>{React.string("4.06.0")}</A></Link>
    {React.string(", released Nov 3, 2017.")}
    </LI>
    <LI>
    {React.string("OCaml ")}
    <Link href="/releases/4.05.0.html"><A>{React.string("4.05.0")}</A></Link>
    {React.string(", released July 13, 2017.")}
    </LI>
    <LI>
    {React.string("OCaml ")}
    <Link href="/releases/4.04.2.html"><A>{React.string("4.04.2")}</A></Link>
    {React.string(", released Jun 23, 2017.")}
    </LI>
    <LI>
    {React.string("OCaml ")}
    <Link href="/releases/4.04.1.html"><A>{React.string("4.04.1")}</A></Link>
    {React.string(", released Apr 14, 2017.")}
    </LI>
    <LI>
    {React.string("OCaml ")}
    <Link href="/releases/4.04.0.html"><A>{React.string("4.04.0")}</A></Link>
    {React.string(", released Nov 4, 2016.")}
    </LI>
    <LI>
    {React.string("OCaml ")}
    <Link href="/releases/4.03.0.html"><A>{React.string("4.03.0")}</A></Link>
    {React.string(", released Apr 25, 2016.")}
    </LI>
    <LI>
    {React.string("OCaml ")}
    <Link href="/releases/4.02.3.html"><A>{React.string("4.02.3")}</A></Link>
    {React.string(", released Jul 27, 2015.")}
    </LI>
    <LI>
    {React.string("OCaml ")}
    <Link href="/releases/4.02.2.html"><A>{React.string("4.02.2")}</A></Link>
    {React.string(", released Jun 17, 2015.")}
    </LI>
    <LI>
    {React.string("OCaml ")}
    <Link href="/releases/4.02.1.html"><A>{React.string("4.02.1")}</A></Link>
    {React.string(", released Oct 14, 2014.")}
    </LI>
    <LI>
    {React.string("OCaml ")}
    <Link href="/releases/4.02.0.html"><A>{React.string("4.02.0")}</A></Link>
    {React.string(", released Aug 29, 2014.")}<br />
    {React.string("(4.02.0 suffers from one known bug that noticeably increases compilation time,
    you should use 4.02.1 or later versions instead.)")}
    </LI>
    <LI>
    {React.string("OCaml ")}
    <Link href="/releases/4.01.0.html"><A>{React.string("4.01.0")}</A></Link>
    {React.string(", released Sep 12, 2013.")}
    </LI>
    <LI>
    {React.string("OCaml ")}
    <Link href="/releases/4.00.1.html"><A>{React.string("4.00.1")}</A></Link>
    {React.string(", released Oct 5, 2012.")}
    </LI>
    <LI>
    {React.string("OCaml ")}
    <Link href="/releases/3.12.1.html"><A>{React.string("3.12.1")}</A></Link>
    {React.string(", released July 4, 2011.")}
    </LI>
    <LI>
    {React.string("Earlier releases are available ")}
    <AEXT href="http://caml.inria.fr/pub/distrib/">{React.string("here")}</AEXT>
    {React.string(".")}
    </LI>
    </UL>
    <P>{React.string("You may also want to check the ")} 
    <AEXT href="https://github.com/ocaml/ocaml">{React.string("development version")}</AEXT>
    {React.string(" of OCaml.")}
    </P>
  </>;
