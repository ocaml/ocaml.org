

import * as React from "react";
import Link from "next/link";

function ReleasesIndex$P(Props) {
  var children = Props.children;
  return React.createElement("p", {
              className: "mb-6"
            }, children);
}

function ReleasesIndex$H1(Props) {
  var children = Props.children;
  return React.createElement("h1", {
              className: "font-sans text-4xl font-bold leading-snug mb-2"
            }, children);
}

function ReleasesIndex$UL(Props) {
  var children = Props.children;
  return React.createElement("ul", {
              className: "mb-6 ml-6 -mt-3 list-disc"
            }, children);
}

function ReleasesIndex$LI(Props) {
  var children = Props.children;
  return React.createElement("li", {
              className: "mb-3"
            }, children);
}

function ReleasesIndex$LINK(Props) {
  var href = Props.href;
  var children = Props.children;
  return React.createElement(Link, {
              href: href,
              children: React.createElement("a", {
                    className: "text-ocamlorange hover:underline"
                  }, children)
            });
}

function ReleasesIndex$AEXT(Props) {
  var children = Props.children;
  var href = Props.href;
  return React.createElement("a", {
              className: "text-ocamlorange hover:underline",
              href: href,
              target: "_blank"
            }, children);
}

function $$default(param) {
  return React.createElement(React.Fragment, undefined, React.createElement(ReleasesIndex$H1, {
                  children: "Releases"
                }), React.createElement(ReleasesIndex$P, {
                  children: null
                }, "The ", React.createElement(ReleasesIndex$LINK, {
                      href: "/releases/latest/",
                      children: "latest"
                    }), " page points to the most recent release of the OCaml compiler \n     distribution. Below is a list of the recent releases."), React.createElement(ReleasesIndex$P, {
                  children: null
                }, "See also the ", React.createElement(ReleasesIndex$LINK, {
                      href: "/docs/install.html",
                      children: "install"
                    }), " page for instructions on installing OCaml by other means, such as\n    the OPAM package manager and platform specific package managers."), React.createElement(ReleasesIndex$UL, {
                  children: null
                }, React.createElement(ReleasesIndex$LI, {
                      children: null
                    }, "OCaml ", React.createElement(ReleasesIndex$LINK, {
                          href: "/releases/4.11.1.html",
                          children: "4.11.1"
                        }), ", released Aug 31, 2020."), React.createElement(ReleasesIndex$LI, {
                      children: null
                    }, "OCaml ", React.createElement(ReleasesIndex$LINK, {
                          href: "/releases/4.11.0.html",
                          children: "4.11.0"
                        }), ", released Aug 19, 2020."), React.createElement(ReleasesIndex$LI, {
                      children: null
                    }, "OCaml ", React.createElement(ReleasesIndex$LINK, {
                          href: "/releases/4.10.1.html",
                          children: "4.10.1"
                        }), ", released Aug 20, 2020."), React.createElement(ReleasesIndex$LI, {
                      children: null
                    }, "OCaml ", React.createElement(ReleasesIndex$LINK, {
                          href: "/releases/4.10.0.html",
                          children: "4.10.0"
                        }), ", released Feb 21, 2020."), React.createElement(ReleasesIndex$LI, {
                      children: null
                    }, "OCaml ", React.createElement(ReleasesIndex$LINK, {
                          href: "/releases/4.09.1.html",
                          children: "4.09.1"
                        }), ", released Mar 18, 2020."), React.createElement(ReleasesIndex$LI, {
                      children: null
                    }, "OCaml ", React.createElement(ReleasesIndex$LINK, {
                          href: "/releases/4.09.0.html",
                          children: "4.09.0"
                        }), ", released Sep 18, 2019."), React.createElement(ReleasesIndex$LI, {
                      children: null
                    }, "OCaml ", React.createElement(ReleasesIndex$LINK, {
                          href: "/releases/4.08.1.html",
                          children: "4.08.1"
                        }), ", released Aug 5, 2019."), React.createElement(ReleasesIndex$LI, {
                      children: null
                    }, "OCaml ", React.createElement(ReleasesIndex$LINK, {
                          href: "/releases/4.08.0.html",
                          children: "4.08.0"
                        }), ", released Jun 14, 2019."), React.createElement(ReleasesIndex$LI, {
                      children: null
                    }, "OCaml ", React.createElement(ReleasesIndex$LINK, {
                          href: "/releases/4.07.1.html",
                          children: "4.07.1"
                        }), ", released Oct 4, 2018."), React.createElement(ReleasesIndex$LI, {
                      children: null
                    }, "OCaml ", React.createElement(ReleasesIndex$LINK, {
                          href: "/releases/4.07.0.html",
                          children: "4.07.0"
                        }), ", released Jul 10, 2018."), React.createElement(ReleasesIndex$LI, {
                      children: null
                    }, "OCaml ", React.createElement(ReleasesIndex$LINK, {
                          href: "/releases/4.07.0.html",
                          children: "4.07.0"
                        }), ", released Jul 10, 2018."), React.createElement(ReleasesIndex$LI, {
                      children: null
                    }, "OCaml ", React.createElement(ReleasesIndex$LINK, {
                          href: "/releases/4.06.1.html",
                          children: "4.06.1"
                        }), ", released Feb 16, 2018."), React.createElement(ReleasesIndex$LI, {
                      children: null
                    }, "OCaml ", React.createElement(ReleasesIndex$LINK, {
                          href: "/releases/4.06.0.html",
                          children: "4.06.0"
                        }), ", released Nov 3, 2017."), React.createElement(ReleasesIndex$LI, {
                      children: null
                    }, "OCaml ", React.createElement(ReleasesIndex$LINK, {
                          href: "/releases/4.05.0.html",
                          children: "4.05.0"
                        }), ", released July 13, 2017."), React.createElement(ReleasesIndex$LI, {
                      children: null
                    }, "OCaml ", React.createElement(ReleasesIndex$LINK, {
                          href: "/releases/4.04.2.html",
                          children: "4.04.2"
                        }), ", released Jun 23, 2017."), React.createElement(ReleasesIndex$LI, {
                      children: null
                    }, "OCaml ", React.createElement(ReleasesIndex$LINK, {
                          href: "/releases/4.04.1.html",
                          children: "4.04.1"
                        }), ", released Apr 14, 2017."), React.createElement(ReleasesIndex$LI, {
                      children: null
                    }, "OCaml ", React.createElement(ReleasesIndex$LINK, {
                          href: "/releases/4.04.0.html",
                          children: "4.04.0"
                        }), ", released Nov 4, 2016."), React.createElement(ReleasesIndex$LI, {
                      children: null
                    }, "OCaml ", React.createElement(ReleasesIndex$LINK, {
                          href: "/releases/4.03.0.html",
                          children: "4.03.0"
                        }), ", released Apr 25, 2016."), React.createElement(ReleasesIndex$LI, {
                      children: null
                    }, "OCaml ", React.createElement(ReleasesIndex$LINK, {
                          href: "/releases/4.02.3.html",
                          children: "4.02.3"
                        }), ", released Jul 27, 2015."), React.createElement(ReleasesIndex$LI, {
                      children: null
                    }, "OCaml ", React.createElement(ReleasesIndex$LINK, {
                          href: "/releases/4.02.2.html",
                          children: "4.02.2"
                        }), ", released Jun 17, 2015."), React.createElement(ReleasesIndex$LI, {
                      children: null
                    }, "OCaml ", React.createElement(ReleasesIndex$LINK, {
                          href: "/releases/4.02.1.html",
                          children: "4.02.1"
                        }), ", released Oct 14, 2014."), React.createElement(ReleasesIndex$LI, {
                      children: null
                    }, "OCaml ", React.createElement(ReleasesIndex$LINK, {
                          href: "/releases/4.02.0.html",
                          children: "4.02.0"
                        }), ", released Aug 29, 2014.", React.createElement("br", undefined), "(4.02.0 suffers from one known bug that noticeably increases compilation time,\n    you should use 4.02.1 or later versions instead.)"), React.createElement(ReleasesIndex$LI, {
                      children: null
                    }, "OCaml ", React.createElement(ReleasesIndex$LINK, {
                          href: "/releases/4.01.0.html",
                          children: "4.01.0"
                        }), ", released Sep 12, 2013."), React.createElement(ReleasesIndex$LI, {
                      children: null
                    }, "OCaml ", React.createElement(ReleasesIndex$LINK, {
                          href: "/releases/4.00.1.html",
                          children: "4.00.1"
                        }), ", released Oct 5, 2012."), React.createElement(ReleasesIndex$LI, {
                      children: null
                    }, "OCaml ", React.createElement(ReleasesIndex$LINK, {
                          href: "/releases/3.12.1.html",
                          children: "3.12.1"
                        }), ", released July 4, 2011."), React.createElement(ReleasesIndex$LI, {
                      children: null
                    }, "Earlier releases are available ", React.createElement(ReleasesIndex$AEXT, {
                          children: "here",
                          href: "http://caml.inria.fr/pub/distrib/"
                        }), ".")), React.createElement(ReleasesIndex$P, {
                  children: null
                }, "You may also want to check the ", React.createElement(ReleasesIndex$AEXT, {
                      children: "development version",
                      href: "https://github.com/ocaml/ocaml"
                    }), " of OCaml."));
}

export {
  $$default ,
  $$default as default,
  
}
/* react Not a pure module */
