

import * as React from "react";
import Link from "next/link";

function Markdown$P(Props) {
  var children = Props.children;
  return React.createElement("p", {
              className: "mb-6"
            }, children);
}

var P = {
  make: Markdown$P
};

function Markdown$H1(Props) {
  var children = Props.children;
  return React.createElement("h1", {
              className: "font-sans text-4xl font-bold leading-snug mb-2"
            }, children);
}

var H1 = {
  make: Markdown$H1
};

function Markdown$H2(Props) {
  var children = Props.children;
  return React.createElement("h2", {
              className: "font-sans text-2xl font-bold leading-normal mb-2"
            }, children);
}

var H2 = {
  make: Markdown$H2
};

function Markdown$H3(Props) {
  var children = Props.children;
  return React.createElement("h3", {
              className: "font-sans text-lg font-bold leading-normal mb-3"
            }, children);
}

var H3 = {
  make: Markdown$H3
};

function Markdown$UL(Props) {
  var children = Props.children;
  return React.createElement("ul", {
              className: "pl-8 space-y-3 mb-6 list-disc"
            }, children);
}

var UL = {
  make: Markdown$UL
};

function Markdown$LINK(Props) {
  var href = Props.href;
  var children = Props.children;
  return React.createElement(Link, {
              href: href,
              children: React.createElement("a", {
                    className: "text-ocamlorange underline"
                  }, children)
            });
}

var LINK = {
  make: Markdown$LINK
};

var $$default = {
  p: Markdown$P,
  h1: Markdown$H1,
  h2: Markdown$H2,
  h3: Markdown$H3,
  a: Markdown$LINK
};

var Link$1;

export {
  Link$1 as Link,
  P ,
  H1 ,
  H2 ,
  H3 ,
  UL ,
  LINK ,
  $$default ,
  $$default as default,
  
}
/* react Not a pure module */
