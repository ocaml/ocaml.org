module Link = Next.Link

module P = {
  @react.component
  let make = (~children) => <p className="mb-6"> children </p>
}
module H1 = {
  // TODO: use mb-1.5 and tailwind 2
  @react.component
  let make = (~children) =>
    <h1 className="font-sans text-4xl font-bold leading-snug mb-2"> children </h1>
}
module H2 = {
  @react.component
  let make = (~children, ~id) =>
    <h2 id className="font-sans text-2xl font-bold leading-normal mb-2"> children </h2>
}
module H3 = {
  // TODO: use mb-2.5 and tailwind 2
  @react.component
  let make = (~children, ~id) =>
    <h3 id className="font-sans text-lg font-bold leading-normal mb-3"> children </h3>
}
module AEXT = {
  @react.component
  let make = (~children, ~href) =>
    <a href={href} className="text-ocamlorange hover:underline" target="_blank"> children </a>
}
module ITAL = {
  @react.component
  let make = (~children) => <span className="italic"> children </span>
}
module AFRAG = {
  @react.component
  let make = (~children, ~href) =>
    <Link href={href}> <a className="text-ocamlorange hover:underline"> children </a> </Link>
}

module LeftNav = {
  @react.component
  let make = () => {
    let s = React.string
    <>
      <h3 className="font-sans text-lg font-bold text-gray-700 leading-normal mb-2">
        {s("Contents")}
      </h3>
      <ul className="list-disc list-inside text-sm font-bold pl-3">
        <li> <AFRAG href="#web-forums"> {s("Web Forums")} </AFRAG> </li>
        <ul className="pl-6 list-disc list-inside">
          <li> <AFRAG href="#discuss-at-ocamlorg"> {s("Discuss at OCaml.org")} </AFRAG> </li>
        </ul>
        <li> <AFRAG href="#mailing-lists"> {s("Mailing Lists")} </AFRAG> </li>
        <ul className="pl-6 list-disc list-inside">
          <li> <AFRAG href="#official-ocaml-list"> {s("Official OCaml List")} </AFRAG> </li>
          <li>
            <AFRAG href="#ocaml-jobs-and-internships"> {s("OCaml Jobs and Internships")} </AFRAG>
          </li>
          <li> <AFRAG href="#ocaml-announcements"> {s("OCaml Announcements")} </AFRAG> </li>
        </ul>
        <li> <AFRAG href="#discussion-groups"> {s("Discussion Groups")} </AFRAG> </li>
        <ul className="pl-6 list-disc list-inside">
          <li> <AFRAG href="#irc-channel--english"> {s("IRC Channel - English")} </AFRAG> </li>
          <li> <AFRAG href="#discord-server"> {s("Discord Server")} </AFRAG> </li>
          <li> <AFRAG href="#irc-channel--french"> {s("IRC Channel - French")} </AFRAG> </li>
          <li> <AFRAG href="#about-ml"> {s("About ML")} </AFRAG> </li>
          <li>
            <AFRAG href="#about-functional-languages"> {s("About Functional Languages")} </AFRAG>
          </li>
        </ul>
        <li> <AFRAG href="#other"> {s("Other")} </AFRAG> </li>
        <ul className="pl-6 list-disc list-inside">
          <li> <AFRAG href="#bug-tracker"> {s("Bug Tracker")} </AFRAG> </li>
        </ul>
      </ul>
    </>
  }
}

let default = () => {
  <>
    <div className="flex">
      <div className="flex-none w-1/3 pt-12 pr-4"> <LeftNav /> </div>
      <div className="flex-1">
        <H1> {React.string("Mailing Lists and Web Forums")} </H1>
        <P>
          {React.string("Mailing lists and other forums used to discuss OCaml in 
    general are listed below. There are thousands of other forums related to 
    individual projects. Several mailing lists are hosted on the ")}
          <AEXT href="http://lists.ocaml.org"> {React.string("lists.ocaml.org")} </AEXT>
          {React.string(" domain. Projects on ")}
          <AEXT href="https://github.com/trending?l=ocaml&since=monthly">
            {React.string("GitHub")}
          </AEXT>
          {React.string(" actively use GitHub's Issue system for discussions.")}
        </P>
        <H2 id="web-forums"> {React.string("Web Forums")} </H2>
        <H3 id="discuss-at-ocamlorg"> {React.string("Discuss at OCaml.org")} </H3>
        <P>
          <AEXT href="https://discuss.ocaml.org"> {React.string("discuss.ocaml.org")} </AEXT>
          {React.string("This is the most active forum about OCaml. Topics are grouped into a 
    variety of categories, which can be followed independently. This forum welcomes 
    people at all levels of proficiency, including beginners. A mailing-list mode 
    is also available for those who wish to receive all messages.")}
        </P>
        <P>
          {React.string("Most categories are in English but categories in other languages 
    are welcome.")}
        </P>
        <H2 id="mailing-lists"> {React.string("Mailing Lists")} </H2>
        <H3 id="official-ocaml-list"> {React.string("Official OCaml List")} </H3>
        <P>
          <ITAL> {React.string("caml-list AT inria.fr")} </ITAL>
          {React.string(" The OCaml mailing list is intended for all 
    users of the OCaml implementations developed at Inria. The purpose of this list is 
    to share experience, exchange ideas and code, and report on applications of the 
    OCaml language. This list is not moderated, but posting is restricted to the 
    subscribers of the list. Messages are generally in English but sometimes also in French.")}
        </P>
        <P>
          <AEXT href="https://sympa.inria.fr/sympa/subscribe/caml-list">
            {React.string("Subscribe")}
          </AEXT>
          {React.string(" | ")}
          <AEXT href="https://inbox.ocaml.org/caml-list"> {React.string("OCaml Archives")} </AEXT>
          {React.string(" | ")}
          <AEXT href="https://sympa.inria.fr/sympa/arc/caml-list">
            {React.string("Inria Archives")}
          </AEXT>
        </P>
        <P>
          {React.string("The ")}
          <AEXT href="http://alan.petitepomme.net/cwn/"> {React.string("OCaml Weekly News")} </AEXT>
          {React.string(" also provides a curated summary of camll-list discussions.")}
        </P>
        <H3 id="ocaml-jobs-and-internships"> {React.string("OCaml Jobs and Internships")} </H3>
        <P>
          <ITAL> {React.string("ocaml-jobs AT inria.fr")} </ITAL>
          {React.string(" This list is for exchanges 
    between people looking for a job or an internship requiring skills 
    in OCaml and people, corporations, universities, ..., offering such jobs 
    or internships.")}
        </P>
        <P>
          <AEXT href="https://sympa.inria.fr/sympa/info/ocaml-jobs">
            {React.string("(Un)subscribe")}
          </AEXT>
        </P>
        <H3 id="ocaml-announcements"> {React.string("OCaml Announcements")} </H3>
        <P>
          <ITAL> {React.string("caml-announce AT inria.fr")} </ITAL>
          {React.string(" This is a low-traffic, moderated list 
    for announcements of OCaml releases and new OCaml-related software, libraries, 
    documents, etc.")}
        </P>
        <P>
          <AEXT href="https://sympa.inria.fr/sympa/subscribe/caml-announce">
            {React.string("(Un)subscribe")}
          </AEXT>
        </P>
        <H2 id="discussion-groups"> {React.string("Discussion Groups")} </H2>
        <H3 id="irc-channel--english"> {React.string("IRC Channel - English")} </H3>
        <P>
          <ITAL> {React.string("irc.freenode.net #ocaml")} </ITAL>
          {React.string(" This is a real-time communication channel, where 
    you can ask for help. There are about a hundred users hanging around; don't ask 
    if you can ask, just ask, and be patient: not everyone is in the same timezone. 
    The IRC Channel can be accessed through a web interface or any regular IRC client.")}
        </P>
        <P>
          {React.string("Public channel logs are available at ")}
          <AEXT href="http://irclog.whitequark.org/ocaml/">
            {React.string("http://irclog.whitequark.org/ocaml/")}
          </AEXT>
        </P>
        <P>
          {React.string(
            "If you wish to use a web-based IRC client, you can use Freenode's webchat ",
          )}
          <AEXT href="https://webchat.freenode.net/">
            {React.string("https://webchat.freenode.net/")}
          </AEXT>
          {React.string(".")}
        </P>
        <H3 id="discord-server"> {React.string("Discord Server")} </H3>
        <P>
          <AEXT href="https://discord.gg/cCYQbqN"> {React.string("discord link")} </AEXT>
          {React.string(": As a more recent addition to the OCaml community, the OCaml discord 
    server benefits from the proximity of the ReasonML community's discord server, as well 
    as discord's ability to have multiple channels. One of the channels is called #IRC, 
    and automatically connects to the main IRC channel.")}
        </P>
        <H3 id="irc-channel--french"> {React.string("IRC Channel - French")} </H3>
        <P>
          <ITAL> {React.string("irc.freenode.net #ocaml-fr")} </ITAL>
          {React.string(" As above, but for French speakers.")}
        </P>
        <H3 id="about-ml"> {React.string("About ML")} </H3>
        <P>
          <ITAL> {React.string("comp.lang.ml")} </ITAL>
          {React.string(" This is a moderated Usenet newsgroup about all variants of ML. 
    Discussions generally concern Standard ML implementations (such as SML-NJ), but some threads 
    concern the OCaml branch.")}
        </P>
        <P>
          <AEXT href="http://groups.google.com/groups?group=comp.lang.ml">
            {React.string("Archives at Google Groups")}
          </AEXT>
          {React.string(" | ")}
          <AEXT href="http://www.faqs.org/faqs/meta-lang-faq/"> {React.string("FAQ")} </AEXT>
        </P>
        <H3 id="about-functional-languages"> {React.string("About Functional Languages")} </H3>
        <P>
          <ITAL> {React.string("comp.lang.functional")} </ITAL>
          {React.string(" This is an unmoderated usenet newsgroup for the discussion 
    of all aspects of functional programming languages, including their design, application, 
    theoretical foundation, and implementation. Discussions concern all families of functional 
    programming languages including non-strict ones (e.g. Haskell) and strict ones (e.g. Scheme, 
    SML or OCaml).")}
        </P>
        <P>
          <AEXT href="http://groups.google.com/groups?group=comp.lang.functional">
            {React.string("Archives at Google Groups")}
          </AEXT>
          {React.string(" | ")}
          <AEXT href="http://www.cs.nott.ac.uk/~gmh/faq.html"> {React.string("FAQ")} </AEXT>
        </P>
        <H2 id="other"> {React.string("Other")} </H2>
        <H3 id="bug-tracker"> {React.string("Bug Tracker")} </H3>
        <P>
          {React.string("Use ")}
          <AEXT href="https://github.com/ocaml/ocaml/issues">
            {React.string("Github issues")}
          </AEXT>
          {React.string(" to request features or report bugs.")}
        </P>
      </div>
    </div>
  </>
}
