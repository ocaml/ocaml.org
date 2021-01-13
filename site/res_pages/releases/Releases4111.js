

import * as React from "react";
import * as Markdown$Ocamlorg from "../../components/Markdown.js";

function $$default(param) {
  return React.createElement(React.Fragment, undefined, React.createElement("h1", undefined, "OCaml 4.11.1"), React.createElement("p", undefined, "This page describe OCaml ", React.createElement("strong", undefined, "4.11.1"), ", released on Aug 31, 2020. It is a bug-fix ", React.createElement(Markdown$Ocamlorg.LINK.make, {
                      href: "/releases/4.11.0",
                      children: "release of OCaml 4.11.0"
                    }), "."), React.createElement("h2", undefined, "Bug fixes:"), React.createElement("ul", undefined, React.createElement("li", undefined, "#9856, #9857: ", React.createElement(Markdown$Ocamlorg.LINK.make, {
                          href: "https://github.com/ocaml/ocaml/issues/9856",
                          children: "Issue: Prevent polymorphic type annotations from generalizing weak polymorphic variables"
                        }), ". ", React.createElement(Markdown$Ocamlorg.LINK.make, {
                          href: "https://github.com/ocaml/ocaml/issues/9857",
                          children: "PR: Prevent polymorphic type annotations from generalizing weak polymorphic variables"
                        }), ". (Leo White, report by Thierry Martinez, review by Jacques Garrigue)"), React.createElement("li", undefined, "#9859, #9862: ", React.createElement(Markdown$Ocamlorg.LINK.make, {
                          href: "https://github.com/ocaml/ocaml/issues/9859",
                          children: "Issue: Remove an erroneous assertion when inferred function types appear in the right \n          hand side of an explicit :> coercion"
                        }), ". ", React.createElement(Markdown$Ocamlorg.LINK.make, {
                          href: "https://github.com/ocaml/ocaml/issues/9862",
                          children: "PR: Remove an erroneous assertion when inferred function types appear in the right \n          hand side of an explicit :> coercion"
                        }), ". (Florian Angeletti, report by Jerry James, review by Thomas Refis)")));
}

export {
  $$default ,
  $$default as default,
  
}
/* react Not a pure module */
