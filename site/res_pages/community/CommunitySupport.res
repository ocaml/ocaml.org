module Link = Next.Link;

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
module UL = {
  @react.component
  let make = (~children) => 
    <ul className="mb-6 ml-6 -mt-3 list-disc"> children </ul>;
};
module LI = {
  @react.component
  let make = (~children) => 
    <li className="mb-3"> children </li>;
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

    <H2>{React.string(`Commercial Support`)}</H2>

    <H3>{React.string(`The OCamlPro Company`)}</H3>

    <H3>{React.string(`Gerd Stolpmann`)}</H3>

    <H2>{React.string(`Giving Support`)}</H2>

    <H3>{React.string(`Caml Consortium at Inria`)}</H3>

    <H3>{React.string(`OCaml Labs`)}</H3>

    <H3>{React.string(`IRILL`)}</H3>
  </>;
