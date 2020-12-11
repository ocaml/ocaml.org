

import * as React from "react";
import Link from "next/link";

function MainLayout$Navigation(Props) {
  var editpath = Props.editpath;
  var editUrl = "https://github.com/ocaml/ocaml.org/edit/master/" + editpath;
  return React.createElement("nav", {
              className: "p-2 h-12 flex border-b border-gray-200 justify-between items-center text-sm"
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
                      className: "px-3"
                    }, "Search"), React.createElement("a", {
                      className: "px-3 font-bold",
                      href: editUrl,
                      target: "_blank"
                    }, "Edit")));
}

var Navigation = {
  make: MainLayout$Navigation
};

function MainLayout(Props) {
  var children = Props.children;
  var editpath = Props.editpath;
  var minWidth = {
    minWidth: "20rem"
  };
  return React.createElement("div", {
              className: "flex lg:justify-center",
              style: minWidth
            }, React.createElement("div", {
                  className: "max-w-5xl w-full lg:w-3/4 text-gray-900 font-base"
                }, React.createElement(MainLayout$Navigation, {
                      editpath: editpath
                    }), React.createElement("main", {
                      className: "mt-4 mx-4"
                    }, children)));
}

var Link$1;

var make = MainLayout;

export {
  Link$1 as Link,
  Navigation ,
  make ,
  
}
/* react Not a pure module */
