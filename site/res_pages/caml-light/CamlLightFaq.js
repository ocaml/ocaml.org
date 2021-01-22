

import * as React from "react";

function s(prim) {
  return prim;
}

function $$default(param) {
  return React.createElement(React.Fragment, undefined, React.createElement("h1", undefined, "Caml Light - FAQ"), React.createElement("h2", undefined, "Is it possible to get error message in my own language?"), React.createElement("p", undefined, "You can choose the language that Caml Light uses to write its messages. For this:", React.createElement("ul", undefined, React.createElement("li", undefined, "under Unix: define the ", React.createElement("code", undefined, "LANG"), " environment variable, or call the Caml Light system with option ", React.createElement("code", undefined, "-lang"), "."), React.createElement("li", undefined, "under Windows use the ", React.createElement("code", undefined, "-lang"), " option on the command line, or in the ", React.createElement("code", undefined, "CAMLWIN.INI"), " file."), React.createElement("li", undefined, "with a Macintosh, edit the resource of the Caml application.")), "Language currently available are:", React.createElement("ul", undefined, React.createElement("li", undefined, React.createElement("code", undefined, "fr"), ": french.", React.createElement("code", undefined, "es"), ": spanish.", React.createElement("code", undefined, "de"), ": german.", React.createElement("code", undefined, "it"), ": italian.", React.createElement("code", undefined, "src"), ": english.")), "English is the default language for messages that cannot be translated. If your language \n        is not yet available, and if you want to translate Caml Light messages (about 50 messages), \n        you\'re welcome to contact the Caml team (mail to caml-light@inria.fr)."));
}

export {
  s ,
  $$default ,
  $$default as default,
  
}
/* react Not a pure module */
