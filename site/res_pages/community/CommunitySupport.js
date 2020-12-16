

import * as React from "react";
import Link from "next/link";

function CommunitySupport$P(Props) {
  var children = Props.children;
  return React.createElement("p", {
              className: "mb-6"
            }, children);
}

function CommunitySupport$H1(Props) {
  var children = Props.children;
  return React.createElement("h1", {
              className: "font-sans text-4xl font-bold leading-snug mb-2"
            }, children);
}

function CommunitySupport$H2(Props) {
  var children = Props.children;
  return React.createElement("h2", {
              className: "font-sans text-2xl font-bold leading-normal mb-2"
            }, children);
}

function CommunitySupport$H3(Props) {
  var children = Props.children;
  return React.createElement("h3", {
              className: "font-sans text-lg font-bold leading-normal mb-3"
            }, children);
}

function CommunitySupport$LINK(Props) {
  var href = Props.href;
  var children = Props.children;
  return React.createElement(Link, {
              href: href,
              children: React.createElement("a", {
                    className: "text-ocamlorange hover:underline"
                  }, children)
            });
}

function CommunitySupport$AEXT(Props) {
  var children = Props.children;
  var href = Props.href;
  return React.createElement("a", {
              className: "text-ocamlorange hover:underline",
              href: href,
              target: "_blank"
            }, children);
}

function $$default(param) {
  return React.createElement(React.Fragment, undefined, React.createElement(CommunitySupport$H1, {
                  children: "Support"
                }), React.createElement(CommunitySupport$P, {
                  children: null
                }, "A great way to get free support is by using\n     the active ", React.createElement(CommunitySupport$LINK, {
                      href: "/community/mailing_lists",
                      children: "mailing lists"
                    }), ". When you need to go beyond this \n     and get professional support, you have the following \n     options:"), React.createElement(CommunitySupport$H2, {
                  children: "Commercial Support"
                }), React.createElement(CommunitySupport$H3, {
                  children: "The OCamlPro Company"
                }), React.createElement(CommunitySupport$P, {
                  children: null
                }, React.createElement(CommunitySupport$AEXT, {
                      children: "OCamlPro",
                      href: "http://www.ocamlpro.com/"
                    }), " is the creator of many open-source \n    tools widely used throughout the community, such as ", React.createElement(CommunitySupport$AEXT, {
                      children: "Try OCaml",
                      href: "http://try.ocamlpro.com/"
                    }), ", the ", React.createElement(CommunitySupport$AEXT, {
                      children: "OPAM package manager",
                      href: "http://opam.ocamlpro.com/"
                    }), " and ", React.createElement(CommunitySupport$AEXT, {
                      children: "ocp-indent",
                      href: "http://www.typerex.org/ocp-indent.html"
                    }), ", as well as a large \n    contributor to OCaml itself. Besides commercially supporting \n    their tools, they offer to share their expertise through full \n    OCaml support packages. They also provide trainings and \n    specialized software developments."), React.createElement(CommunitySupport$P, {
                  children: null
                }, "OCamlPro is an INRIA spin-off with a team \n    of highly skilled experienced OCaml programmers, including \n    members of the OCaml core development team, and they have \n    expertise to help debug and optimize OCaml projects as \n    well as improve specific work environments. See details ", React.createElement(CommunitySupport$AEXT, {
                      children: "here",
                      href: "http://www.ocamlpro.com/"
                    }), "."), React.createElement(CommunitySupport$H3, {
                  children: "Gerd Stolpmann"
                }), React.createElement(CommunitySupport$P, {
                  children: null
                }, React.createElement(CommunitySupport$AEXT, {
                      children: "Gerd Stolpmann",
                      href: "http://www.gerd-stolpmann.de/buero/work_ocaml_search.html.en"
                    }), " has been helping companies master \n    OCaml since 2005. He is an expert of the ecosystem surrounding \n    OCaml and developed the ", React.createElement(CommunitySupport$AEXT, {
                      children: "GODI",
                      href: "http://godi.camlcity.org/godi/"
                    }), " platform. Stolpmann is a computer \n    scientist who has been a contractor for several long-running \n    OCaml projects. He has a focus on big data (including data \n    preparation, search/query engines, map/reduce), but his skills \n    also cover Unix system programming, SQL databases, \n    client/server, compiler development (e.g. for domain-specific languages), \n    and much more. Also visit his ", React.createElement(CommunitySupport$AEXT, {
                      children: "website on OCaml",
                      href: "http://camlcity.org/"
                    }), "."), React.createElement(CommunitySupport$H2, {
                  children: "Giving Support"
                }), React.createElement(CommunitySupport$H3, {
                  children: "Caml Consortium at Inria"
                }), React.createElement(CommunitySupport$P, {
                  children: null
                }, "You can join the Caml Consortium to support \n    development of the OCaml compiler itself. See details ", React.createElement(CommunitySupport$LINK, {
                      href: "/consortium/",
                      children: "here"
                    }), "."), React.createElement(CommunitySupport$H3, {
                  children: "OCaml Labs"
                }), React.createElement(CommunitySupport$P, {
                  children: null
                }, "You can support OCaml Labs, which runs a \n    variety of open source projects to support the OCaml community. \n    See details ", React.createElement(CommunitySupport$LINK, {
                      href: "/ocamllabs/",
                      children: "here"
                    }), "."), React.createElement(CommunitySupport$H3, {
                  children: "IRILL"
                }), React.createElement(CommunitySupport$P, {
                  children: null
                }, "You can support IRILL, the Center for Research \n    and Innovation on Free Software, a major actor of the OCaml \n    community, with projects such as ", React.createElement(CommunitySupport$AEXT, {
                      children: "js_of_ocaml",
                      href: "http://ocsigen.org/js_of_ocaml/"
                    }), " (the OCaml to JavaScript optimizing compiler), ", React.createElement(CommunitySupport$AEXT, {
                      children: "Dose",
                      href: "https://gforge.inria.fr/projects/dose/"
                    }), " (a key component of the OPAM package manager). They also \n    use OCaml to contribute to other major open source projects (", React.createElement(CommunitySupport$AEXT, {
                      children: "Coccinelle",
                      href: "http://coccinelle.lip6.fr/"
                    }), ", for example). See details ", React.createElement(CommunitySupport$AEXT, {
                      children: "here",
                      href: "http://www.irill.org/"
                    }), "."));
}

export {
  $$default ,
  $$default as default,
  
}
/* react Not a pure module */
