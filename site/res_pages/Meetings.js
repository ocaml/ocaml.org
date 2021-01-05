

import * as React from "react";
import * as Markdown from "../components/Markdown.js";
import Link from "next/link";

function Meetings$H1(Props) {
  var children = Props.children;
  return React.createElement("h1", {
              className: "font-sans text-4xl font-bold leading-snug mb-2"
            }, children);
}

function Meetings$H2(Props) {
  var children = Props.children;
  return React.createElement("h2", {
              className: "font-sans text-2xl font-bold leading-normal mb-2"
            }, children);
}

function Meetings$LINK(Props) {
  var href = Props.href;
  var children = Props.children;
  return React.createElement(Link, {
              href: href,
              children: React.createElement("a", {
                    className: "text-ocamlorange hover:underline"
                  }, children)
            });
}

function Meetings$AEXT(Props) {
  var children = Props.children;
  var href = Props.href;
  return React.createElement("a", {
              className: "text-ocamlorange hover:underline",
              href: href,
              target: "_blank"
            }, children);
}

function $$default(param) {
  return React.createElement(React.Fragment, undefined, React.createElement(Meetings$H1, {
                  children: "OCaml Users and Developers Workshop"
                }), React.createElement(Markdown.UL.make, {
                  children: null
                }, React.createElement("li", undefined, React.createElement(Meetings$LINK, {
                          href: "/meetings/ocaml/2020/",
                          children: "OCaml 2020"
                        }), ": Jersey City (New Jersey, USA), August 28, colocated with ICFP 2020."), React.createElement("li", undefined, React.createElement(Meetings$LINK, {
                          href: "/meetings/ocaml/2019/",
                          children: "OCaml 2019"
                        }), ": Berlin (Germany), August 23, colocated with ICFP 2019."), React.createElement("li", undefined, React.createElement(Meetings$LINK, {
                          href: "/meetings/ocaml/2018/",
                          children: "OCaml 2018"
                        }), ": St Louis (Missouri, USA), September 27, colocated with ICFP 2018."), React.createElement("li", undefined, React.createElement(Meetings$LINK, {
                          href: "/meetings/ocaml/2017/",
                          children: "OCaml 2017"
                        }), ": Oxford (UK), September 8, colocated with ICFP 2017."), React.createElement("li", undefined, React.createElement(Meetings$LINK, {
                          href: "/meetings/ocaml/2016/",
                          children: "OCaml 2016"
                        }), ": Nara (Japan), September 23, colocated with ICFP 2016."), React.createElement("li", undefined, React.createElement(Meetings$LINK, {
                          href: "/meetings/ocaml/2015/",
                          children: "OCaml 2015"
                        }), ": Vancouver (BC, Canada), September 4, colocated with ICFP 2015."), React.createElement("li", undefined, React.createElement(Meetings$LINK, {
                          href: "/meetings/ocaml/2014/",
                          children: "OCaml 2014"
                        }), ": Gothenburg (Sweden), September 5, colocated with ICFP 2014."), React.createElement("li", undefined, React.createElement(Meetings$LINK, {
                          href: "/meetings/ocaml/2013/",
                          children: "OCaml 2013"
                        }), ": Boston (MA, USA), September 24, colocated with ICFP 2013."), React.createElement("li", undefined, React.createElement(Meetings$LINK, {
                          href: "/meetings/ocaml/2012/",
                          children: "OUD 2012"
                        }), ": Copenhagen (Denmark), September 14th, colocated with ICFP 2012.")), React.createElement(Meetings$H1, {
                  children: "OCaml Meetings"
                }), React.createElement(Meetings$H2, {
                  children: "In Europe"
                }), React.createElement(Markdown.UL.make, {
                  children: null
                }, React.createElement("li", undefined, "2014, July 8, 7:00 PM: ", React.createElement(Meetings$AEXT, {
                          children: "Rencontre d\'été",
                          href: "http://www.meetup.com/ocaml-paris/events/188634632/"
                        }), ", Mozilla Paris, 16 boulevard Montmartre 75009 Paris. Organized by ", React.createElement(Meetings$AEXT, {
                          children: "OCaml Users in PariS (OUPS)",
                          href: "http://www.meetup.com/ocaml-paris/"
                        }), "."), React.createElement("li", undefined, "2014, May 22, 7:00 PM: ", React.createElement(Meetings$AEXT, {
                          children: "Rencontre de Printemps",
                          href: "http://www.meetup.com/ocaml-paris/events/181647232/"
                        }), ", IRILL 23, avenue d\'Italie 75013 Paris. Organized by ", React.createElement(Meetings$AEXT, {
                          children: "OCaml Users in PariS (OUPS)",
                          href: "http://www.meetup.com/ocaml-paris/"
                        }), "."), React.createElement("li", undefined, "2013, May 21, 7:30 PM: ", React.createElement(Meetings$AEXT, {
                          children: "Rencontre de Mai",
                          href: "http://www.meetup.com/ocaml-paris/events/116100692/"
                        }), ", IRILL 23, avenue d\'Italie 75013 Paris. Organized by ", React.createElement(Meetings$AEXT, {
                          children: "OCaml Users in PariS (OUPS)",
                          href: "http://www.meetup.com/ocaml-paris/"
                        }), "."), React.createElement("li", undefined, "2013, January 29, 8:00 PM: ", React.createElement(Meetings$AEXT, {
                          children: "First \"OPAM Party\"",
                          href: "http://www.meetup.com/ocaml-paris/events/99222322/"
                        }), ", IRILL 23, avenue d\'Italie 75013 Paris. Organized by ", React.createElement(Meetings$AEXT, {
                          children: "OCaml Users in PariS (OUPS)",
                          href: "http://www.meetup.com/ocaml-paris/"
                        }), "."), React.createElement("li", undefined, "2011: ", React.createElement(Meetings$LINK, {
                          href: "/meetings/ocaml/2011/",
                          children: "Paris"
                        })), React.createElement("li", undefined, "2010: ", React.createElement(Meetings$LINK, {
                          href: "/meetings/ocaml/2010/",
                          children: "Paris"
                        })), React.createElement("li", undefined, "2009: ", React.createElement(Meetings$LINK, {
                          href: "/meetings/ocaml/2009/",
                          children: "Grenoble"
                        })), React.createElement("li", undefined, "2008: ", React.createElement(Meetings$LINK, {
                          href: "/meetings/ocaml/2008/",
                          children: "Paris"
                        }))), React.createElement(Meetings$H2, {
                  children: "In Japan"
                }), React.createElement(Markdown.UL.make, {
                  children: null
                }, React.createElement("li", undefined, "2013: ", React.createElement(Meetings$AEXT, {
                          children: "Nagoya",
                          href: "http://ocaml.jp/um2013"
                        })), React.createElement("li", undefined, "2010: ", React.createElement(Meetings$AEXT, {
                          children: "Nagoya",
                          href: "http://ocaml.jp/um2010"
                        })), React.createElement("li", undefined, "2010: Tokyo")), React.createElement(Meetings$H2, {
                  children: "In the US"
                }), React.createElement(Markdown.UL.make, {
                  children: null
                }, React.createElement("li", undefined, "2012-present: ", React.createElement(Meetings$AEXT, {
                          children: "NYC OCaml Meetup",
                          href: "http://www.meetup.com/NYC-OCaml/"
                        })), React.createElement("li", undefined, "2014-present: ", React.createElement(Meetings$AEXT, {
                          children: "Silicon Valley OCaml meetups",
                          href: "http://www.meetup.com/sv-ocaml/"
                        }))), React.createElement(Meetings$H2, {
                  children: "In the UK"
                }), React.createElement(Markdown.UL.make, {
                  children: React.createElement("li", undefined, "2012: ", React.createElement(Meetings$AEXT, {
                            children: "Cambridge NonDysFunctional Programmers",
                            href: "http://www.meetup.com/Cambridge-NonDysFunctional-Programmers/"
                          }))
                }));
}

export {
  $$default ,
  $$default as default,
  
}
/* react Not a pure module */
