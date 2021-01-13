

import * as React from "react";
import * as Markdown$Ocamlorg from "../../components/Markdown.js";

function $$default(param) {
  return React.createElement(React.Fragment, undefined, React.createElement("h1", undefined, "Caml Light"), React.createElement("h2", undefined, "Overview"), React.createElement("p", undefined, "Caml Light is a lightweight, portable implementation of the core Caml language that was \n        developed in the early 1990\'s, as a precursor to OCaml. It used to run on most Unix machines, \n        as well as PC under Microsoft Windows. The implementation is obsolete, no longer actively \n        maintained, and will be removed eventually. We recommend switching immediately to its \n        successor, OCaml."), React.createElement("p", undefined, "Caml Light is implemented as a bytecode compiler, and fully bootstrapped. The runtime \n        system and bytecode interpreter is written in standard C, hence Caml Light is easy to port \n        to almost any 32 or 64 bit platform. The whole system is quite small: about 100K for the \n        runtime system, and another 100K of bytecode for the compiler. Two megabytes of memory is \n        enough to recompile the whole system."), React.createElement("p", undefined, React.createElement(Markdown$Ocamlorg.LINK.make, {
                      href: "/learn/tutorials/debug.html",
                      children: "Debugging is possible by tracing function calls"
                    }), " in the same way as in OCaml. In the example therein, one should write ", React.createElement("code", undefined, "trace \"fib\";;"), " instead of ", React.createElement("code", undefined, "#trace fib;;"), " and ", React.createElement("code", undefined, "untrace \"fib\";;"), " instead of ", React.createElement("code", undefined, "#untrace fib;;"), ". There also exists a debugger, as a user contribution."), React.createElement("p", undefined, "Some common questions are answered in the ", React.createElement(Markdown$Ocamlorg.LINK.make, {
                      href: "/caml-light/faq",
                      children: "Frequently Asked Questions"
                    }), "."), React.createElement("h2", undefined, "Availability"), React.createElement("p", undefined, "The Caml Light system is open source software. Please read the ", React.createElement(Markdown$Ocamlorg.LINK.make, {
                      href: "/caml-light/license",
                      children: "Caml Light license"
                    }), " for more details. The ", React.createElement(Markdown$Ocamlorg.LINK.make, {
                      href: "/caml-light/releases",
                      children: "latest release"
                    }), " can be freely downloaded on this site, together with its ", React.createElement(Markdown$Ocamlorg.LINK.make, {
                      href: "http://caml.inria.fr/pub/docs/manual-caml-light/",
                      children: "user\'s manual"
                    }), ". See also ", React.createElement(Markdown$Ocamlorg.LINK.make, {
                      href: "http://caml.inria.fr/pub/docs/fpcl/index.html",
                      children: "\"Functional programming using Caml Light\" guide"
                    }), " for an introduction to functional programming \n        in general and the Caml Light language in particular."));
}

export {
  $$default ,
  $$default as default,
  
}
/* react Not a pure module */
