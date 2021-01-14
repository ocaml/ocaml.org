

import * as React from "react";
import * as Markdown$Ocamlorg from "../../../components/Markdown.js";

function $$default(param) {
  return React.createElement(React.Fragment, undefined, React.createElement("div", undefined, React.createElement("nav", {
                      "aria-label": "Table of Contents",
                      role: "navigation"
                    }, React.createElement("h2", undefined, "Contents"), React.createElement("ul", undefined, React.createElement("li", undefined, React.createElement(Markdown$Ocamlorg.LINK.make, {
                                  href: "#guidelines",
                                  children: "Guidelines"
                                })), React.createElement("li", undefined, React.createElement(Markdown$Ocamlorg.LINK.make, {
                                  href: "#how-to-syndicate-your-feed",
                                  children: "How to syndicate your feed"
                                })), React.createElement("li", undefined, React.createElement(Markdown$Ocamlorg.LINK.make, {
                                  href: "#how-to-read-planet-from-your-rss-reader",
                                  children: "How to read planet from your RSS reader"
                                })))), React.createElement("div", undefined, React.createElement("h1", undefined, "OCaml Planet Syndication"), React.createElement("h2", {
                          id: "guidelines"
                        }, "Guidelines"), React.createElement("p", undefined, "Two types of feeds are aggregated by the ", React.createElement(Markdown$Ocamlorg.LINK.make, {
                              href: "/community/planet",
                              children: "OCaml Planet"
                            }), ": personal and institutional."), React.createElement("p", undefined, "Personal feeds are for individuals working with OCaml. Writing about OCaml \n            in every entry is not mandatory. On the contrary, this is an opportunity to broaden \n            the discussion. However, entries must respect the terms of use and the philosophy of \n            ocaml.org. Posts should avoid focusing on overtly commercial topics. If you write a \n            personal blog that also has many posts on other topics, we will be thankful if you \n            provide us with an already filtered feed (e.g., tagging posts and using a tag subfeed)."), React.createElement("p", undefined, "Institutional feeds are those that only handle OCaml information. The best way to define \n            what they are is by giving some examples:"), React.createElement("ul", undefined, React.createElement("li", undefined, "NEWS of an ocaml project (release of OCaml, release of PXP...)"), React.createElement("li", undefined, React.createElement(Markdown$Ocamlorg.LINK.make, {
                                  href: "http://alan.petitepomme.net/cwn/index.html",
                                  children: "Caml Weekly News"
                                })), React.createElement("li", undefined, "...")), React.createElement("h2", {
                          id: "how-to-syndicate-your-feed"
                        }, "How to syndicate your feed"), React.createElement("p", undefined, "Due to spam, the ocaml.org team has disabled automatic planet syndication. You can \n            still ask to be added to the planet by editing the ", React.createElement(Markdown$Ocamlorg.LINK.make, {
                              href: "https://github.com/ocaml/ocaml.org/blob/master/planet_feeds.txt",
                              children: "planet feed file"
                            }), " and submitting a ", React.createElement("em", undefined, "pull request"), ". In the comment to the pull request, please provide the following three pieces \n            of information:"), React.createElement("ul", undefined, React.createElement("li", undefined, "A name for the feed: this can be your name if the feed is about a person (e.g. \"Sylvain Le Gall\"), \n              or the name of the official OCaml information channel (e.g. \"Caml Weekly News\")"), React.createElement("li", undefined, "An URL for downloading the feed: this URL must give access to the RSS feed itself"), React.createElement("li", undefined, "Whether this feed is Personal or an official OCaml information channel (Institutional). \n              See the above guidelines concerning syndication for these two different kinds of feed.")), React.createElement("p", undefined, "If you are unable to do that, an alternative slower route is to ", React.createElement(Markdown$Ocamlorg.LINK.make, {
                              href: "https://github.com/ocaml/ocaml.org/issues",
                              children: "submit an issue to be added to the planet"
                            }), " with the title \"Add URL to planet\" and the above three pieces of information."), React.createElement("p", undefined, "Once you have provided this information, your syndication will be reviewed by an administrator \n            and put online. If you want to have a good chance to join the feed there must be at least one \n            post about OCaml in the most recent entries."), React.createElement("h2", {
                          id: "how-to-read-planet-from-your-rss-reader"
                        }, "How to read planet from your RSS reader"), React.createElement("p", undefined, "We provide the following kinds of feed:"), React.createElement("ul", undefined, React.createElement("li", undefined, React.createElement(Markdown$Ocamlorg.LINK.make, {
                                  href: "/feed.xml",
                                  children: "Atom feed (xml)"
                                })), React.createElement("li", undefined, React.createElement(Markdown$Ocamlorg.LINK.make, {
                                  href: "/opml.xml",
                                  children: "OPML feed (xml)"
                                }))), React.createElement("p", undefined, "Copy/paste one of these links into your favorite feed reader to enjoy planet news."))));
}

export {
  $$default ,
  $$default as default,
  
}
/* react Not a pure module */
