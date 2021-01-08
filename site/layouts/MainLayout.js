

import * as React from "react";
import * as Footer$Ocamlorg from "../components/Footer.js";
import * as HeaderNavigation$Ocamlorg from "../components/HeaderNavigation.js";

function MainLayout(Props) {
  var children = Props.children;
  var editpath = Props.editpath;
  var navMainStyle = {
    minWidth: "20rem",
    flex: "1 0 auto"
  };
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "flex flex-col min-h-screen font-base text-gray-900"
                }, React.createElement("div", {
                      className: "flex lg:justify-center",
                      style: navMainStyle
                    }, React.createElement("div", {
                          className: "max-w-5xl w-full lg:w-3/4"
                        }, React.createElement(HeaderNavigation$Ocamlorg.make, {
                              editpath: editpath
                            }), React.createElement("main", {
                              className: "mt-4 mx-4",
                              role: "main"
                            }, children))), React.createElement("div", {
                      className: "flex-shrink-0 flex lg:justify-center"
                    }, React.createElement("div", {
                          className: "max-w-5xl w-full lg:w-3/4"
                        }, React.createElement(Footer$Ocamlorg.make, {})))));
}

var make = MainLayout;

export {
  make ,
  
}
/* react Not a pure module */
