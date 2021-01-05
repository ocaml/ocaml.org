module Link = Next.Link;
module UL = Markdown.UL;

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
    <H1>{React.string(`OCaml Users and Developers Workshop`)}</H1>
    <UL>
    <li>
    <LINK href="/meetings/ocaml/2020/">{React.string(`OCaml 2020`)}</LINK>
    {React.string(`: Jersey City (New Jersey, USA), August 28, colocated with ICFP 2020.`)}
    </li>
    <li>
    <LINK href="/meetings/ocaml/2019/">{React.string(`OCaml 2019`)}</LINK>
    {React.string(`: Berlin (Germany), August 23, colocated with ICFP 2019.`)}
    </li>
    <li>
    <LINK href="/meetings/ocaml/2018/">{React.string(`OCaml 2018`)}</LINK>
    {React.string(`: St Louis (Missouri, USA), September 27, colocated with ICFP 2018.`)}
    </li>
    <li>
    <LINK href="/meetings/ocaml/2017/">{React.string(`OCaml 2017`)}</LINK>
    {React.string(`: Oxford (UK), September 8, colocated with ICFP 2017.`)}
    </li>
    <li>
    <LINK href="/meetings/ocaml/2016/">{React.string(`OCaml 2016`)}</LINK>
    {React.string(`: Nara (Japan), September 23, colocated with ICFP 2016.`)}
    </li>
    <li>
    <LINK href="/meetings/ocaml/2015/">{React.string(`OCaml 2015`)}</LINK>
    {React.string(`: Vancouver (BC, Canada), September 4, colocated with ICFP 2015.`)}
    </li>
    <li>
    <LINK href="/meetings/ocaml/2014/">{React.string(`OCaml 2014`)}</LINK>
    {React.string(`: Gothenburg (Sweden), September 5, colocated with ICFP 2014.`)}
    </li>
    <li>
    <LINK href="/meetings/ocaml/2013/">{React.string(`OCaml 2013`)}</LINK>
    {React.string(`: Boston (MA, USA), September 24, colocated with ICFP 2013.`)}
    </li>
    <li>
    <LINK href="/meetings/ocaml/2012/">{React.string(`OUD 2012`)}</LINK>
    {React.string(`: Copenhagen (Denmark), September 14th, colocated with ICFP 2012.`)}
    </li>
    </UL>

    <H1>{React.string(`OCaml Meetings`)}</H1>

    <H2>{React.string(`In Europe`)}</H2>
    <UL>
    <li>
    {React.string(`2014, July 8, 7:00 PM: `)}
    <AEXT href="http://www.meetup.com/ocaml-paris/events/188634632/">{React.string(`Rencontre d'été`)}</AEXT>
    {React.string(`, Mozilla Paris, 16 boulevard Montmartre 75009 Paris. Organized by `)}    
    <AEXT href="http://www.meetup.com/ocaml-paris/">{React.string(`OCaml Users in PariS (OUPS)`)}</AEXT>
    {React.string(`.`)}
    </li>
    <li>
    {React.string(`2014, May 22, 7:00 PM: `)}
    <AEXT href="http://www.meetup.com/ocaml-paris/events/181647232/">{React.string(`Rencontre de Printemps`)}</AEXT>
    {React.string(`, IRILL 23, avenue d'Italie 75013 Paris. Organized by `)}    
    <AEXT href="http://www.meetup.com/ocaml-paris/">{React.string(`OCaml Users in PariS (OUPS)`)}</AEXT>
    {React.string(`.`)}
    </li>
    <li>
    {React.string(`2013, May 21, 7:30 PM: `)}
    <AEXT href="http://www.meetup.com/ocaml-paris/events/116100692/">{React.string(`Rencontre de Mai`)}</AEXT>
    {React.string(`, IRILL 23, avenue d'Italie 75013 Paris. Organized by `)}    
    <AEXT href="http://www.meetup.com/ocaml-paris/">{React.string(`OCaml Users in PariS (OUPS)`)}</AEXT>
    {React.string(`.`)}
    </li>
    <li>
    {React.string(`2013, January 29, 8:00 PM: `)}
    <AEXT href="http://www.meetup.com/ocaml-paris/events/99222322/">{React.string(`First "OPAM Party"`)}</AEXT>
    {React.string(`, IRILL 23, avenue d'Italie 75013 Paris. Organized by `)}    
    <AEXT href="http://www.meetup.com/ocaml-paris/">{React.string(`OCaml Users in PariS (OUPS)`)}</AEXT>
    {React.string(`.`)}
    </li>
    <li>
    {React.string(`2011: `)}
    <LINK href="/meetings/ocaml/2011/">{React.string(`Paris`)}</LINK>
    </li>
    <li>
    {React.string(`2010: `)}
    <LINK href="/meetings/ocaml/2010/">{React.string(`Paris`)}</LINK>
    </li>
    <li>
    {React.string(`2009: `)}
    <LINK href="/meetings/ocaml/2009/">{React.string(`Grenoble`)}</LINK>
    </li>
    <li>
    {React.string(`2008: `)}
    <LINK href="/meetings/ocaml/2008/">{React.string(`Paris`)}</LINK>
    </li>
    </UL>

    <H2>{React.string(`In Japan`)}</H2>
    <UL>
    <li>
    {React.string(`2013: `)}
    <AEXT href="http://ocaml.jp/um2013">{React.string(`Nagoya`)}</AEXT>
    </li>
    <li>
    {React.string(`2010: `)}
    <AEXT href="http://ocaml.jp/um2010">{React.string(`Nagoya`)}</AEXT>
    </li>
    <li>
    {React.string(`2010: Tokyo`)}
    </li>
    </UL>

    <H2>{React.string(`In the US`)}</H2>
    <UL>
    <li>
    {React.string(`2012-present: `)}
    <AEXT href="http://www.meetup.com/NYC-OCaml/">{React.string(`NYC OCaml Meetup`)}</AEXT>
    </li>
    <li>
    {React.string(`2014-present: `)}
    <AEXT href="http://www.meetup.com/sv-ocaml/">{React.string(`Silicon Valley OCaml meetups`)}</AEXT>
    </li>
    </UL>

    <H2>{React.string(`In the UK`)}</H2>
    <UL>
    <li>
    {React.string(`2012: `)}
    <AEXT href="http://www.meetup.com/Cambridge-NonDysFunctional-Programmers/">{React.string(`Cambridge NonDysFunctional Programmers`)}</AEXT>
    </li>
    </UL>
  </>;
