

import * as React from "react";
import * as Markdown$Ocamlorg from "../../components/Markdown.js";

function s(prim) {
  return prim;
}

var pageHeader = "Industrial Users of OCaml";

var pageOverview = "Ocaml is a popular choice for companies who make use of its features in key\n     aspects of their technologies. Some companies that use OCaml code are listed below:";

var facebookHeader = "Facebook, United States";

var facebookBody = "Facebook has built a number of major development tools using OCaml. Hack \n  is a compiler for a variant of PHP that aims to reconcile the fast development \n  cycle of PHP with the discipline provided by static typing. Flow is a similar project \n  that provides static type checking for Javascript. Both systems are highly responsive, \n  parallel programs that can incorporate source code changes in real time. Pfff is a set \n  of tools for code analysis, visualizations, and style-preserving source transformations, \n  written in OCaml, but supporting many languages.";

var dockerHeader = "Docker, United States";

var dockerBody = "Docker provides an integrated technology suite that enables development and IT operations \n  teams to build, ship, and run distributed applications anywhere. Their native applications \n  for Mac and Windows, use OCaml code taken from the MirageOS library operating system project.";

var taridesHeader = "Tarides, France";

var taridesBody = "We are building and maintaining open-source infrastructure tools in OCaml: (1) MirageOS, \n  the most advanced unikernel project, where we build sandboxes, network and storage protocol \n  implementations as libraries, so we can link them to our applications to run them without the \n  need of an underlying operating system; (2) Irmin, a Git-like datastore, which allows us to \n  create fully auditable distributed systems which can work offline and be synced when needed; \n  and (3) OCaml development tools (build system, code linters, documentation generators, etc), to \n  make us more efficient. Tarides was founded in early 2018 and is mainly based in Paris, France \n  (remote work is possible).";

var solvuuHeader = "Solvuu, United States";

var solvuuBody = "Solvuu\'s software allows users to store big and small data sets, share the data with \n  collaborators, execute computationally intensive algorithms and workflows, and visualize \n  results. Its initial focus is on genomics data, which has important implications for healthcare, \n  agriculture, and fundamental research. Virtually all of Solvuu\'s software stack is \n  implemented in OCaml.";

function $$default(param) {
  return React.createElement(React.Fragment, undefined, React.createElement("article", undefined, React.createElement("h1", undefined, pageHeader), React.createElement("p", undefined, pageOverview), React.createElement("ul", undefined, React.createElement("li", undefined, React.createElement("img", {
                              alt: ""
                            }), React.createElement("h2", undefined, React.createElement(Markdown$Ocamlorg.LINK.make, {
                                  href: "https://facebook.com",
                                  children: facebookHeader
                                })), React.createElement("p", undefined, facebookBody)), React.createElement("li", undefined, React.createElement("img", {
                              alt: ""
                            }), React.createElement("h2", undefined, React.createElement(Markdown$Ocamlorg.LINK.make, {
                                  href: "https://docker.com",
                                  children: dockerHeader
                                })), React.createElement("p", undefined, dockerBody)), React.createElement("li", undefined, React.createElement("img", {
                              alt: ""
                            }), React.createElement("h2", undefined, React.createElement(Markdown$Ocamlorg.LINK.make, {
                                  href: "https://tarides.com",
                                  children: taridesHeader
                                })), React.createElement("p", undefined, taridesBody)), React.createElement("li", undefined, React.createElement("img", {
                              alt: ""
                            }), React.createElement("h2", undefined, React.createElement(Markdown$Ocamlorg.LINK.make, {
                                  href: "https://solvuu.com",
                                  children: solvuuHeader
                                })), React.createElement("p", undefined, solvuuBody)))));
}

var LINK;

export {
  LINK ,
  s ,
  pageHeader ,
  pageOverview ,
  facebookHeader ,
  facebookBody ,
  dockerHeader ,
  dockerBody ,
  taridesHeader ,
  taridesBody ,
  solvuuHeader ,
  solvuuBody ,
  $$default ,
  $$default as default,
  
}
/* react Not a pure module */
