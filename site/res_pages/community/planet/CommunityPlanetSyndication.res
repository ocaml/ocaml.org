module LINK = Markdown.LINK

let s = React.string

let default = () =>
  <>
  <div>
    <nav role="navigation" ariaLabel="Table of Contents">
      <h2>{s("Contents")}</h2>
        <ul>
          <li><LINK href="#guidelines">{s(`Guidelines`)}</LINK></li>
          <li><LINK href="#how-to-syndicate-your-feed">{s(`How to syndicate your feed`)}</LINK></li>
          <li><LINK href="#how-to-read-planet-from-your-rss-reader">{s(`How to read planet from your RSS reader`)}</LINK></li>
        </ul>
    </nav>
    <div>
      <h1>{s(`OCaml Planet Syndication`)}</h1>
        <h2 id="guidelines">{s(`Guidelines`)}</h2>
          <p>
            {s(`Two types of feeds are aggregated by the `)}
            <LINK href="/community/planet">{s(`OCaml Planet`)}</LINK>
            {s(`: personal and institutional.`)}
          </p>
          <p>
            {s(`Personal feeds are for individuals working with OCaml. Writing about OCaml 
            in every entry is not mandatory. On the contrary, this is an opportunity to broaden 
            the discussion. However, entries must respect the terms of use and the philosophy of 
            ocaml.org. Posts should avoid focusing on overtly commercial topics. If you write a 
            personal blog that also has many posts on other topics, we will be thankful if you 
            provide us with an already filtered feed (e.g., tagging posts and using a tag subfeed).`)}
          </p>
          <p>
            {s(`Institutional feeds are those that only handle OCaml information. The best way to define 
            what they are is by giving some examples:`)}
          </p>
          <ul>
            <li>{s(`NEWS of an ocaml project (release of OCaml, release of PXP...)`)}</li>
            <li><LINK href="http://alan.petitepomme.net/cwn/index.html">{s(`Caml Weekly News`)}</LINK></li>
            <li>{s(`...`)}</li>
          </ul>
        <h2 id="how-to-syndicate-your-feed">{s(`How to syndicate your feed`)}</h2>
          <p>
            {s(`Due to spam, the ocaml.org team has disabled automatic planet syndication. You can 
            still ask to be added to the planet by editing the `)}
            <LINK href="https://github.com/ocaml/ocaml.org/blob/master/planet_feeds.txt">
              {s(`planet feed file`)}
            </LINK>
            {s(` and submitting a `)}
            <em>{s(`pull request`)}</em>
            {s(`. In the comment to the pull request, please provide the following three pieces 
            of information:`)}
          </p>
          <ul>
            <li>
              {s(`A name for the feed: this can be your name if the feed is about a person (e.g. "Sylvain Le Gall"), 
              or the name of the official OCaml information channel (e.g. "Caml Weekly News")`)}
            </li>
            <li>
              {s(`An URL for downloading the feed: this URL must give access to the RSS feed itself`)}
            </li>
            <li>
              {s(`Whether this feed is Personal or an official OCaml information channel (Institutional). 
              See the above guidelines concerning syndication for these two different kinds of feed.`)}
            </li>
          </ul>
          <p>
            {s(`If you are unable to do that, an alternative slower route is to `)}
            <LINK href="https://github.com/ocaml/ocaml.org/issues">
              {s(`submit an issue to be added to the planet`)}
            </LINK>
            {s(` with the title "Add URL to planet" and the above three pieces of information.`)}
          </p>
          <p>
            {s(`Once you have provided this information, your syndication will be reviewed by an administrator 
            and put online. If you want to have a good chance to join the feed there must be at least one 
            post about OCaml in the most recent entries.`)}
          </p>
        <h2 id="how-to-read-planet-from-your-rss-reader">{s(`How to read planet from your RSS reader`)}</h2>
          <p>
            {s(`We provide the following kinds of feed:`)}
          </p>
          <ul>
            <li><LINK href="/feed.xml">{s(`Atom feed (xml)`)}</LINK></li>
            <li><LINK href="/opml.xml">{s(`OPML feed (xml)`)}</LINK></li>
          </ul>
          <p>
            {s(`Copy/paste one of these links into your favorite feed reader to enjoy planet news.`)}
          </p>
    </div>
  </div>
  </>
