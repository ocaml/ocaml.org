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
module UL = {
  @react.component
  let make = (~children) =>
    <ul className="pl-8 space-y-3 mb-6 list-disc"> children </ul>
}
// TODO: refactor to only "a" tag, using instructions in next/link docs
module LINK = {
  @react.component
  let make = (~href, ~children) => 
    <Link href={href}><a className="text-ocamlorange underline"> children </a></Link>;
};
/* fold this code into a branch in "LINK"
module AEXT = {
  @react.component
  let make = (~children, ~href) => 
    <a href={href} className="text-ocamlorange hover:underline" target="_blank" > children </a>;
};
*/

let default = Mdx.Components.t(
    ~p=P.make,
    ~h1=H1.make,
    ~h2=H2.make,
    ~h3=H3.make,
    ~a=LINK.make,
    (),
)