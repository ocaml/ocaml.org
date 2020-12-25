

import * as React from "react";
import * as MainLayout from "../layouts/MainLayout.js";
import * as Router from "next/router";

function make(props) {
  var component = props.Component;
  var pageProps = props.pageProps;
  var router = Router.useRouter();
  var content = React.createElement(component, pageProps);
  console.log(router.route);
  var match = router.route;
  if (match === "/releases") {
    return React.createElement(MainLayout.make, {
                children: null,
                editpath: "site/index.md"
              }, React.createElement("h1", {
                    className: "font-bold"
                  }, "Releases Section"), React.createElement("div", undefined, content));
  } else {
    return React.createElement(MainLayout.make, {
                children: content,
                editpath: "site/index.md"
              });
  }
}

export {
  make ,
  
}
/* react Not a pure module */
