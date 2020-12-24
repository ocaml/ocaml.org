

import * as React from "react";

function Footer(Props) {
  return React.createElement("footer", {
              className: "flex justify-center py-2 space-x-4 text-xs"
            }, React.createElement("span", undefined, "Privacy"), React.createElement("span", undefined, "Sitemap"));
}

var make = Footer;

export {
  make ,
  
}
/* react Not a pure module */
