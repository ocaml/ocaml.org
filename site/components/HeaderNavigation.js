

import * as React from "react";
import Link from "next/link";

function HeaderNavigation(Props) {
  var editpath = Props.editpath;
  var editUrl = "https://github.com/ocaml/ocaml.org/edit/master/" + editpath;
  return React.createElement("nav", {
              "aria-label": "Main",
              className: "p-2 h-12 flex border-b border-gray-200 items-center text-sm",
              role: "navigation"
            }, React.createElement(Link, {
                  href: "/",
                  children: React.createElement("a", {
                        className: "flex items-center w-1/3"
                      }, null, React.createElement("span", {
                            className: "text-xl ml-2 align-middle font-semibold text-ocamlorange"
                          }, "OCaml"))
                }), React.createElement("div", {
                  className: "flex w-2/3 justify-end"
                }, React.createElement(Link, {
                      href: "/learn",
                      children: React.createElement("a", {
                            className: "px-3"
                          }, "Learn")
                    }), React.createElement(Link, {
                      href: "/documentation",
                      children: React.createElement("a", {
                            className: "px-3"
                          }, "Documentation")
                    }), React.createElement("a", {
                      className: "px-3 font-bold",
                      href: "https://opam.ocaml.org",
                      target: "_blank"
                    }, "Packages"), React.createElement(Link, {
                      href: "/community",
                      children: React.createElement("a", {
                            className: "px-3"
                          }, "Community")
                    }), React.createElement(Link, {
                      href: "/news",
                      children: React.createElement("a", {
                            className: "px-3"
                          }, "News")
                    }), React.createElement("span", {
                      className: "px-3",
                      role: "search"
                    }, "Search"), React.createElement("a", {
                      className: "px-3 font-bold",
                      href: editUrl,
                      target: "_blank"
                    }, "Edit")));
}

var Link$1;

var make = HeaderNavigation;

export {
  Link$1 as Link,
  make ,
  
}
/* react Not a pure module */
