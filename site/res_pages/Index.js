

import * as React from "react";

function Index$P(Props) {
  var children = Props.children;
  return React.createElement("p", {
              className: "mb-2"
            }, children);
}

var P = {
  make: Index$P
};

function $$default(param) {
  return React.createElement("div", undefined, React.createElement("h1", {
                  className: "text-3xl font-semibold"
                }, "OCaml is an industrial-strength programming language \n      supporting functional, imperative and object-oriented styles"), React.createElement(Index$P, {
                  children: "Install OCaml"
                }), React.createElement("h2", {
                  className: "text-2xl font-semibold mt-5"
                }, "Learn"), React.createElement("h2", {
                  className: "text-2xl font-semibold mt-5"
                }, "Documentation"), React.createElement("h2", {
                  className: "text-2xl font-semibold mt-5"
                }, "Packages"), React.createElement("h2", {
                  className: "text-2xl font-semibold mt-5"
                }, "Community"));
}

export {
  P ,
  $$default ,
  $$default as default,
  
}
/* react Not a pure module */
