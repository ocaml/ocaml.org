module Link = Next.Link;

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
module H2 = {
  @react.component
  let make = (~children) => 
    <h2 className="font-sans text-2xl font-bold leading-normal mb-2"> children </h2>;
};
module H3 = {
  // TODO: use mb-2.5 and tailwind 2
  @react.component
  let make = (~children) => 
    <h3 className="font-sans text-lg font-bold leading-normal mb-3"> children </h3>;
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
    <H1>{React.string(`Support`)}</H1>
    <P>{React.string(`A great way to get free support is by using
     the active `)}
     <LINK href="/community/mailing_lists">{React.string(`mailing lists`)}</LINK>     
     {React.string(`. When you need to go beyond this 
     and get professional support, you have the following 
     options:`)}
    </P>

    <H2>{React.string(`Commercial Support`)}</H2>

    <H3>{React.string(`The OCamlPro Company`)}</H3>
    <P><AEXT href="http://www.ocamlpro.com/">{React.string(`OCamlPro`)}</AEXT>
    {React.string(` is the creator of many open-source 
    tools widely used throughout the community, such as `)}
    <AEXT href="http://try.ocamlpro.com/">{React.string(`Try OCaml`)}</AEXT>
    {React.string(`, the `)}
    <AEXT href="http://opam.ocamlpro.com/">{React.string(`OPAM package manager`)}</AEXT>
    {React.string(` and `)}
    <AEXT href="http://www.typerex.org/ocp-indent.html">{React.string(`ocp-indent`)}</AEXT>
    {React.string(`, as well as a large 
    contributor to OCaml itself. Besides commercially supporting 
    their tools, they offer to share their expertise through full 
    OCaml support packages. They also provide trainings and 
    specialized software developments.`)}
    </P>
    <P>{React.string(`OCamlPro is an INRIA spin-off with a team 
    of highly skilled experienced OCaml programmers, including 
    members of the OCaml core development team, and they have 
    expertise to help debug and optimize OCaml projects as 
    well as improve specific work environments. See details `)}
    <AEXT href="http://www.ocamlpro.com/">{React.string(`here`)}</AEXT>
    {React.string(`.`)}
    </P>


    <H3>{React.string(`Gerd Stolpmann`)}</H3>
    <P>
    <AEXT href="http://www.gerd-stolpmann.de/buero/work_ocaml_search.html.en">{React.string(`Gerd Stolpmann`)}</AEXT>
    {React.string(` has been helping companies master 
    OCaml since 2005. He is an expert of the ecosystem surrounding 
    OCaml and developed the `)}
    <AEXT href="http://godi.camlcity.org/godi/">{React.string(`GODI`)}</AEXT>
    {React.string(` platform. Stolpmann is a computer 
    scientist who has been a contractor for several long-running 
    OCaml projects. He has a focus on big data (including data 
    preparation, search/query engines, map/reduce), but his skills 
    also cover Unix system programming, SQL databases, 
    client/server, compiler development (e.g. for domain-specific languages), 
    and much more. Also visit his `)}
    <AEXT href="http://camlcity.org/">{React.string(`website on OCaml`)}</AEXT>
    {React.string(`.`)}</P>

    <H2>{React.string(`Giving Support`)}</H2>
    
    <H3>{React.string(`Caml Consortium at Inria`)}</H3>
    <P>{React.string(`You can join the Caml Consortium to support 
    development of the OCaml compiler itself. See details `)}
    <LINK href="/consortium/">{React.string(`here`)}</LINK>
    {React.string(`.`)}</P>

    <H3>{React.string(`OCaml Labs`)}</H3>
    <P>{React.string(`You can support OCaml Labs, which runs a 
    variety of open source projects to support the OCaml community. 
    See details `)}
    <LINK href="/ocamllabs/">{React.string(`here`)}</LINK>
    {React.string(`.`)}</P>

    <H3>{React.string(`IRILL`)}</H3>
    <P>{React.string(`You can support IRILL, the Center for Research 
    and Innovation on Free Software, a major actor of the OCaml 
    community, with projects such as `)}
    <AEXT href="http://ocsigen.org/js_of_ocaml/">{React.string(`js_of_ocaml`)}</AEXT>
    {React.string(` (the OCaml to JavaScript optimizing compiler), `)}
    <AEXT href="https://gforge.inria.fr/projects/dose/">{React.string(`Dose`)}</AEXT>
    {React.string(` (a key component of the OPAM package manager). They also 
    use OCaml to contribute to other major open source projects (`)}
    <AEXT href="http://coccinelle.lip6.fr/">{React.string(`Coccinelle`)}</AEXT>
    {React.string(`, for example). See details `)}
    <AEXT href="http://www.irill.org/">{React.string(`here`)}</AEXT>
    {React.string(`.`)}
    </P>
  </>;
