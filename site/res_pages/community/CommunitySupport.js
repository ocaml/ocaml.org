

import * as Fs from "fs";
import * as React from "react";
import * as Markdown$Ocamlorg from "../../components/Markdown.js";
import Hydrate from "next-mdx-remote/hydrate";
import RenderToString from "next-mdx-remote/render-to-string";

function $$default(props) {
  var content = Hydrate(props.source, {
        components: Markdown$Ocamlorg.$$default
      });
  return React.createElement(React.Fragment, undefined, content);
}

function getStaticProps(_ctx) {
  var source = Fs.readFileSync("_content/community/support.mdx");
  var __x = RenderToString(source, {
        components: Markdown$Ocamlorg.$$default
      });
  return __x.then(function (mdxSource) {
              var props = {
                source: mdxSource
              };
              return Promise.resolve({
                          props: props
                        });
            });
}

export {
  $$default ,
  $$default as default,
  getStaticProps ,
  
}
/* fs Not a pure module */
