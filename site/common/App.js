

import * as React from "react";
import * as MainLayout from "../layouts/MainLayout.js";
import * as Router from "next/router";

import '../styles/main.css'
;

function make(props) {
  var component = props.Component;
  var pageProps = props.pageProps;
  var router = Router.useRouter();
  var content = React.createElement(component, pageProps);
  console.log(router.route);
  var match = router.route;
  if (match === "/examples") {
    return React.createElement(MainLayout.make, {
                children: null
              }, React.createElement("h1", {
                    className: "font-bold"
                  }, "Examples Section"), React.createElement("div", undefined, content));
  } else {
    return React.createElement(MainLayout.make, {
                children: content
              });
  }
}

export {
  make ,
  
}
/*  Not a pure module */
