---
title: Introducing the GraphQL API for Irmin 2.0
description: "With the release of Irmin 2.0.0, we are happy to announce a new package
  - irmin-graphql, which can be used to serve data from Irmin over\u2026"
url: https://tarides.com/blog/2019-11-27-introducing-the-graphql-api-for-irmin-2-0
date: 2019-11-27T00:00:00-00:00
preview_image: https://tarides.com/static/774a33033c774c2c0c5b638f61694621/0d665/irmin-graphql.png
featured:
---

<p>With the release of Irmin 2.0.0, we are happy to announce a new package - <code>irmin-graphql</code>, which can be used to serve data from Irmin over HTTP. This blog post will give you some examples to help you get started, there is also <a href="https://irmin.org/tutorial/graphql">a section in the <code>irmin-tutorial</code></a> with similar information. To avoid writing the same thing twice, this post will cover the basics of getting started, plus a few interesting ideas for queries.</p>
<p>Getting the <code>irmin-graphql</code> server running from the command-line is easy:</p>
<div class="gatsby-highlight" data-language="shell"><pre class="language-shell"><code class="language-shell">$ irmin graphql --root<span class="token operator">=</span>/tmp/irmin</code></pre></div>
<p>where <code>/tmp/irmin</code> is the actual path to your repository. This will start the server on <code>localhost:8080</code>, but it's possible to customize this using the <code>--address</code> and <code>--port</code> flags.</p>
<p>The new GraphQL API has been added to address some of the shortcomings that have been identified with the old HTTP API, as well as enable a number of new features and capabilities.</p>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#graphql" aria-label="graphql permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>GraphQL</h1>
<p><a href="https://graphql.org/">GraphQL</a> is a query language for exposing data as a graph via an API, typically using HTTP as a transport. The centerpiece of a GraphQL API is the <em>schema</em>, which describes the graph in terms of types and relationships between these types. The schema is accessible by the consumer, and acts as a contract between the API and the consumer, by clearly defining all API operations and fully assigning types to all interactions.</p>
<p>Viewing Irmin data as a graph turns out to be a natural and useful model. Concepts such as branches and commits fit in nicely, and the stored application data is organized as a tree. Such highly hierarchical data can be challenging to interact with using REST, but is easy to represent and navigate with GraphQL.</p>
<p><span class="gatsby-resp-image-wrapper" style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; ">
      <span class="gatsby-resp-image-background-image" style="padding-bottom: 74.11764705882352%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAPCAYAAADkmO9VAAAACXBIWXMAAAsTAAALEwEAmpwYAAADeElEQVQ4y5WSf2xTVRTHTzcQHHMDaRmZESd/aHRxyiTGEDHGGBON/qn/QaL4l/6lLBlBM3UhiK7t66A/3qvOzKEJEOIvJgImaDKHC4zhbLe+/m6lfb/63r13bSnrsvaYW53BH//sJCfnnvfO/dxzz/cC/Mu2CgGwC5LN4ZHAIYhddkHc1+4K7G11+ffYBfE1hyDutHsk4N4hiPC/Vq/XIZWIQSouw6VwCJ4bO7FmzZAPtnik97Z4JOw69glu944gXzs80nkYdELf2QtNg5OXARGhVqv9F5iIRSAmz0EuGW8UPTNyHFqdvoMb3QG81zuCD4mjuMkdwHan77t9X403am71f5jXfRiSMRni8hyEfr26PiTLHZmfLnS8eer00098dmL/rk+/2P94cPTA7uOn+vac/ubF/NWpzrxRcBDGmjkshAgPuI+B3RUEIESxUao2a2p2bSwyD1ZBfzI0OxO+PHVpwtK1H6umcSY3Hx6/aWjjVatwDhHHdF0/mUgmfl5AvJsDX/3yzNo7PVKzXRBtQKnKoVAum1CtLsDLLzy7Mej134GILbllXAfTCK8cHGgbHPpwG3YBHPhF5121IOJtS553NoP0Ndzl8sJmLhQXiVJ1JyGKUCwVPigWDXcqOXeSMW3ANLPrLSv/PGOa07LyLkVJBtmCfoSQ/Ou8qw2uwKF7BP+1re7AD5sE8VuHRzprF8Ru3t1HjGmYyyUwEQ+jaeaQUhUtK99LqXqOEAWzmSimUxH+DYtMo86JiW12QbQ6j36MO4Jj2C2OcvWxczi4lwP7OUBV05hOzWPB+H0FeB+l6ud8nbsex0w6ghZRkFE1OTw50QqHh8fWDflibS7/bIvTd8125GgI3nc+xq/cRojyyM1F1oO41FMqFR62rHz30lLRRojSQYjSu7xc7kGs9lCq7jDMXBci3j4jy+9+f+WK9/z0tO9iKOyZikb9uq7t/luUGxULavUbUCwajbxSIY3IfbG6AMu1cqPWojqYjLYp2cxbGTnSH/1t9lAuEe9nhjFALOuplU1NlCpNPK74XwfZbv3XiNSwlVjaRkvag4u10qMzM5MvqUZmFyvrvYRdb4fVGCHqykH389lyARUlhbqerfOcC7xqICEq8Bnzl6HrWYzKs5hOR5DnhCi+VQL/nCml6gZClDcY0/orFdJXKpt9hChvc9H+ANUxo9tXG1thAAAAAElFTkSuQmCC'); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/77be7ca8c9940e693b03660d2d5cee01/c5bb3/git-data-model.png" class="gatsby-resp-image-image" alt="Git data model" title="Git data model" srcset="/static/77be7ca8c9940e693b03660d2d5cee01/04472/git-data-model.png 170w,
/static/77be7ca8c9940e693b03660d2d5cee01/9f933/git-data-model.png 340w,
/static/77be7ca8c9940e693b03660d2d5cee01/c5bb3/git-data-model.png 680w,
/static/77be7ca8c9940e693b03660d2d5cee01/5a190/git-data-model.png 800w" sizes="(max-width: 680px) 100vw, 680px" style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;" loading="lazy" decoding="async"/>
    </span>
(image from <a href="https://git-scm.com/book/en/v2/Git-Internals-Git-Objects">Pro Git</a>)</p>
<p>As a consumer of an API, one of the biggest initial challenges is understanding what operations are exposed and how to use them. Conversely, as a developer of an API, keeping documentation up-to-date is challenging and time consuming. Though no substitute for more free-form documentation, a GraphQL schema provides an excellent base line for understanding a GraphQL API that is guaranteed to be accurate and up-to-date. This issue is definitely true of the old Irmin HTTP API, which was hard to approach for newcomers due to lack of documentation.</p>
<p>Being able to inspect the schema of a GraphQL API enables powerful tooling. A great example of this is <a href="https://tarides.com/graphiql">GraphiQL</a>, which is a browser-based IDE for GraphQL queries. GraphiQL can serve both as an interactive API explorer and query designer with intelligent autocompletion, formatting and more.</p>
<p><span class="gatsby-resp-image-wrapper" style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; ">
      <a href="https://tarides.com/static/19632cbb13504bb32d6d6d285ec1f542/82e86/graphiql.png" class="gatsby-resp-image-link" style="display: block" target="_blank" rel="noopener">
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 48.23529411764706%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAKCAYAAAC0VX7mAAAACXBIWXMAABYlAAAWJQFJUiTwAAABd0lEQVQoz3WS6Y6EIBCEff9X3PmzyRyOitA0N2htGp09JtlOKojCZxXNcLlccLvdcL/fvzWOI5RSXYtoWf5I3lsOcCFj3zYQEUqpyDljWDXBh9gnL5VS4LyHmhTIENg5WD4kz9oYqFVjXhRCPPa21roGwxGjYgD7qaNSTlCTxsfnBE0WMWWElPpoLWNd1+40l4LfNQiEfQIToWVCrceCGGP/+0NZXJ8K3gd4DgghwjLDWotaNmDf0WpCaxK/CRCotYHJoBUv30+HGc6HDp5WgjUOPGo4zT3i0wRcbxOC/kSJGiUR9q1g2Latn1mrFfu+YT+JKR1A0VMR2Di4ib6BMyUs04jqp26kldD3DwIT6KvegdKw7lAz+L7CkUNMCblW5LSjlYiWJb6kaxikMwL5rQOYDqAPmFcCkzg0cOR7c17r3mvAP5Xzj8NF2yOysn0eYuqphPluZpjnGY/Ho1+DEMSR7yMz982icSXQQuCrgrOnw/OY3p1+Ac4PCEwKkZ1MAAAAAElFTkSuQmCC'); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/19632cbb13504bb32d6d6d285ec1f542/c5bb3/graphiql.png" class="gatsby-resp-image-image" alt="GraphiQL" title="GraphiQL" srcset="/static/19632cbb13504bb32d6d6d285ec1f542/04472/graphiql.png 170w,
/static/19632cbb13504bb32d6d6d285ec1f542/9f933/graphiql.png 340w,
/static/19632cbb13504bb32d6d6d285ec1f542/c5bb3/graphiql.png 680w,
/static/19632cbb13504bb32d6d6d285ec1f542/b12f7/graphiql.png 1020w,
/static/19632cbb13504bb32d6d6d285ec1f542/b5a09/graphiql.png 1360w,
/static/19632cbb13504bb32d6d6d285ec1f542/82e86/graphiql.png 1978w" sizes="(max-width: 680px) 100vw, 680px" style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;" loading="lazy" decoding="async"/>
  </a>
    </span></p>
<p>The combination of introspection and a strongly typed schema also allows creating smart clients using code generation. This is already a quite wide-spread idea with <a href="https://tarides.com/apollo-swift">Apollo for iOS</a>, <a href="https://tarides.com/apollo-java">Apollo for Android</a> or <a href="https://tarides.com/graphql_ppx"><code>graphql_ppx</code></a> for OCaml/Reason. Though generic GraphQL client libraries will do a fine job interacting with the Irmin GraphQL API, these highlighted libraries will offer excellent ergonomics and type-safety out of the box.</p>
<p>One of the problems that GraphQL set out to solve is that of over- and underfetching. When designing REST API response payloads, there is always a tension between including too little data, which will require clients to make more network requests, and including too much data, which wastes resources for both client and server (serialization, network transfer, deserialization, etc).<br/>
The existing low-level Irmin HTTP API is a perfect example of this. Fetching the contents of a particular file on the master branch requires at least 4 HTTP requests (fetch the branch, fetch the commit, fetch the tree, fetch the blob), i.e. massive underfetching. By comparison, this is something easily solved with a single request to the new GraphQL API. More generally, the GraphQL API allows you to fetch <em>exactly</em> the data you need in a single request without making one-off endpoints.</p>
<p>For the curious, here's the GraphQL query to fetch the contents of <code>README.md</code> from the branch <code>master</code>:</p>
<div class="gatsby-highlight" data-language="graphql"><pre class="language-graphql"><code class="language-graphql"><span class="token keyword">query</span> <span class="token punctuation">{</span>
  <span class="token object">master</span> <span class="token punctuation">{</span>
    <span class="token object">tree</span> <span class="token punctuation">{</span>
      <span class="token property-query">get</span><span class="token punctuation">(</span><span class="token attr-name">key</span><span class="token punctuation">:</span> <span class="token string">&quot;README.md&quot;</span><span class="token punctuation">)</span>
    <span class="token punctuation">}</span>
  <span class="token punctuation">}</span>
<span class="token punctuation">}</span></code></pre></div>
<p>The response will look something like this:</p>
<div class="gatsby-highlight" data-language="json"><pre class="language-json"><code class="language-json"><span class="token punctuation">{</span>
  <span class="token property">&quot;data&quot;</span><span class="token operator">:</span> <span class="token punctuation">{</span>
    <span class="token property">&quot;master&quot;</span><span class="token operator">:</span> <span class="token punctuation">{</span>
      <span class="token property">&quot;tree&quot;</span><span class="token operator">:</span> <span class="token punctuation">{</span>
        <span class="token property">&quot;get&quot;</span><span class="token operator">:</span> <span class="token string">&quot;The contents of README.md&quot;</span>
      <span class="token punctuation">}</span>
    <span class="token punctuation">}</span>
  <span class="token punctuation">}</span>
<span class="token punctuation">}</span></code></pre></div>
<p>The GraphQL API is not limited to only reading data, you can also write data to your Irmin store. Here's a simple example that will set the key <code>README.md</code> to <code>&quot;foo&quot;</code>, and return the hash of that commit:</p>
<div class="gatsby-highlight" data-language="graphql"><pre class="language-graphql"><code class="language-graphql"><span class="token keyword">mutation</span> <span class="token punctuation">{</span>
  <span class="token property-query property-mutation">set</span><span class="token punctuation">(</span><span class="token attr-name">key</span><span class="token punctuation">:</span> <span class="token string">&quot;README.md&quot;</span><span class="token punctuation">,</span> <span class="token attr-name">value</span><span class="token punctuation">:</span> <span class="token string">&quot;foo&quot;</span><span class="token punctuation">)</span> <span class="token punctuation">{</span>
    <span class="token property">hash</span>
  <span class="token punctuation">}</span>
<span class="token punctuation">}</span></code></pre></div>
<p>By default, GraphQL allows you to do multiple operations in a single query, so you get bulk operations for free. Here's a more complex example that modifies two different branches, <code>branch-a</code> and <code>branch-b</code>, and then merges <code>branch-b</code> into <code>branch-a</code> <em>all in a single query</em>:</p>
<div class="gatsby-highlight" data-language="graphql"><pre class="language-graphql"><code class="language-graphql"><span class="token keyword">mutation</span> <span class="token punctuation">{</span>
  <span class="token attr-name">branch_a</span><span class="token punctuation">:</span> <span class="token property-query">set</span><span class="token punctuation">(</span><span class="token attr-name">branch</span><span class="token punctuation">:</span> <span class="token string">&quot;branch-a&quot;</span><span class="token punctuation">,</span> <span class="token attr-name">key</span><span class="token punctuation">:</span> <span class="token string">&quot;foo&quot;</span><span class="token punctuation">,</span> <span class="token attr-name">value</span><span class="token punctuation">:</span> <span class="token string">&quot;bar&quot;</span><span class="token punctuation">)</span> <span class="token punctuation">{</span>
    <span class="token property">hash</span>
  <span class="token punctuation">}</span>

  <span class="token attr-name">branch_b</span><span class="token punctuation">:</span> <span class="token property-query">set</span><span class="token punctuation">(</span><span class="token attr-name">branch</span><span class="token punctuation">:</span> <span class="token string">&quot;branch-a&quot;</span><span class="token punctuation">,</span> <span class="token attr-name">key</span><span class="token punctuation">:</span> <span class="token string">&quot;baz&quot;</span><span class="token punctuation">,</span> <span class="token attr-name">value</span><span class="token punctuation">:</span> <span class="token string">&quot;qux&quot;</span><span class="token punctuation">)</span> <span class="token punctuation">{</span>
    <span class="token property">hash</span>
  <span class="token punctuation">}</span>

  <span class="token property-query">merge_with_branch</span><span class="token punctuation">(</span><span class="token attr-name">branch</span><span class="token punctuation">:</span> <span class="token string">&quot;branch-b&quot;</span><span class="token punctuation">,</span> <span class="token attr-name">from</span><span class="token punctuation">:</span> <span class="token string">&quot;branch-a&quot;</span><span class="token punctuation">)</span> <span class="token punctuation">{</span>
    <span class="token property">hash</span>
    <span class="token object">tree</span> <span class="token punctuation">{</span>
      <span class="token object">list_contents_recursively</span> <span class="token punctuation">{</span>
        <span class="token property">key</span>
        <span class="token property">value</span>
      <span class="token punctuation">}</span>
    <span class="token punctuation">}</span>
  <span class="token punctuation">}</span>
<span class="token punctuation">}</span></code></pre></div>
<p>Here's what the response might look like:</p>
<div class="gatsby-highlight" data-language="json"><pre class="language-json"><code class="language-json"><span class="token punctuation">{</span>
  <span class="token property">&quot;data&quot;</span><span class="token operator">:</span> <span class="token punctuation">{</span>
    <span class="token property">&quot;branch_a&quot;</span><span class="token operator">:</span> <span class="token punctuation">{</span>
      <span class="token property">&quot;hash&quot;</span><span class="token operator">:</span> <span class="token string">&quot;0a1313ae9dfe1d4339aee946dd76b383e02949b6&quot;</span>
    <span class="token punctuation">}</span><span class="token punctuation">,</span>
    <span class="token property">&quot;branch_b&quot;</span><span class="token operator">:</span> <span class="token punctuation">{</span>
      <span class="token property">&quot;hash&quot;</span><span class="token operator">:</span> <span class="token string">&quot;28855c277671ccc180c81058a28d3254f17d2f7b&quot;</span>
    <span class="token punctuation">}</span><span class="token punctuation">,</span>
    <span class="token property">&quot;merge_with_branch&quot;</span><span class="token operator">:</span> <span class="token punctuation">{</span>
      <span class="token property">&quot;hash&quot;</span><span class="token operator">:</span> <span class="token string">&quot;7b17437a16a858816d2710a94ccaa1b9c3506d1f&quot;</span><span class="token punctuation">,</span>
      <span class="token property">&quot;tree&quot;</span><span class="token operator">:</span> <span class="token punctuation">{</span>
        <span class="token property">&quot;list_contents_recursively&quot;</span><span class="token operator">:</span> <span class="token punctuation">[</span>
          <span class="token punctuation">{</span>
            <span class="token property">&quot;key&quot;</span><span class="token operator">:</span> <span class="token string">&quot;/foo&quot;</span><span class="token punctuation">,</span>
            <span class="token property">&quot;value&quot;</span><span class="token operator">:</span> <span class="token string">&quot;bar&quot;</span>
          <span class="token punctuation">}</span><span class="token punctuation">,</span>
          <span class="token punctuation">{</span>
            <span class="token property">&quot;key&quot;</span><span class="token operator">:</span> <span class="token string">&quot;/baz&quot;</span><span class="token punctuation">,</span>
            <span class="token property">&quot;value&quot;</span><span class="token operator">:</span> <span class="token string">&quot;qux&quot;</span>
          <span class="token punctuation">}</span>
        <span class="token punctuation">]</span>
      <span class="token punctuation">}</span>
    <span class="token punctuation">}</span>
  <span class="token punctuation">}</span>
<span class="token punctuation">}</span></code></pre></div>
<p>Overall, the new GraphQL API operates at a much higher level than the old HTTP API, and offers a number of complex operations that were tricky to accomplish before.</p>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#customizable" aria-label="customizable permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Customizable</h1>
<p>With GraphQL, all request and response data is fully described by the schema. Because Irmin allows the user to have custom content types, this leaves the question of what type to assign to such values. By default, the GraphQL API will expose all values as strings, i.e. the serialized version of the data that your application stores. This works quite well when Irmin is used as a simple key-value store, but it can be very inconvenient scheme when storing more complex values. As an example, consider storing contacts (name, email, phone, tags, etc) in your Irmin store, where values have the following type:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token comment">(* Custom content type: a contact *)</span>
<span class="token keyword">type</span> contact <span class="token operator">=</span> <span class="token punctuation">{</span>
  name <span class="token punctuation">:</span> string<span class="token punctuation">;</span>
  email <span class="token punctuation">:</span> string<span class="token punctuation">;</span>
  <span class="token comment">(* ... *)</span>
<span class="token punctuation">}</span></code></pre></div>
<p>Fetching such a value will by default be returned to the client as the JSON encoded representation. Assume we're storing a contact under the key <code>john-doe</code>, which we fetch with the following query:</p>
<div class="gatsby-highlight" data-language="graphql"><pre class="language-graphql"><code class="language-graphql"><span class="token keyword">query</span> <span class="token punctuation">{</span>
  <span class="token object">master</span> <span class="token punctuation">{</span>
    <span class="token object">tree</span> <span class="token punctuation">{</span>
      <span class="token property-query">get</span><span class="token punctuation">(</span><span class="token attr-name">key</span><span class="token punctuation">:</span> <span class="token string">&quot;john-doe&quot;</span><span class="token punctuation">)</span>
    <span class="token punctuation">}</span>
  <span class="token punctuation">}</span>
<span class="token punctuation">}</span></code></pre></div>
<p>The response would then look something like this:</p>
<div class="gatsby-highlight" data-language="json"><pre class="language-json"><code class="language-json"><span class="token punctuation">{</span>
  <span class="token property">&quot;master&quot;</span><span class="token operator">:</span> <span class="token punctuation">{</span>
    <span class="token property">&quot;tree&quot;</span><span class="token operator">:</span> <span class="token punctuation">{</span>
      <span class="token property">&quot;get&quot;</span><span class="token operator">:</span> <span class="token string">&quot;{\&quot;name\&quot;:\&quot;John Doe\&quot;, \&quot;email\&quot;: \&quot;john.doe@gmail.com/&quot;</span><span class="token punctuation">,</span> ...<span class="token punctuation">}</span>&quot;
    <span class="token punctuation">}</span>
  <span class="token punctuation">}</span>
<span class="token punctuation">}</span></code></pre></div>
<p>The client will have to parse this JSON string and cannot choose to only fetch parts of the value (say, only the email). Optimally we would want the client to get a structured response such as the following:</p>
<div class="gatsby-highlight" data-language="json"><pre class="language-json"><code class="language-json"><span class="token punctuation">{</span>
  <span class="token property">&quot;master&quot;</span><span class="token operator">:</span> <span class="token punctuation">{</span>
    <span class="token property">&quot;tree&quot;</span><span class="token operator">:</span> <span class="token punctuation">{</span>
      <span class="token property">&quot;get&quot;</span><span class="token operator">:</span> <span class="token punctuation">{</span>
        <span class="token property">&quot;name&quot;</span><span class="token operator">:</span> <span class="token string">&quot;John Doe&quot;</span><span class="token punctuation">,</span>
        <span class="token property">&quot;email&quot;</span><span class="token operator">:</span> <span class="token string">&quot;john.doe@gmail.com&quot;</span><span class="token punctuation">,</span>
        ...
      <span class="token punctuation">}</span>
    <span class="token punctuation">}</span>
  <span class="token punctuation">}</span>
<span class="token punctuation">}</span></code></pre></div>
<p>To achieve this, the new GraphQL API allows providing an &quot;output type&quot; and an &quot;input type&quot; for most of the configurable types in your store (<code>contents</code>, <code>key</code>, <code>metadata</code>, <code>hash</code>, <code>branch</code>). The output type specifies how data is presented to the client, while the input type controls how data can be provided by the client. Let's take a closer look at specifying a custom output type.</p>
<p>Essentially you have to construct a value of type <code>(unit, 'a option) Graphql_lwt.Schema.typ</code> (from the <a href="https://tarides.com/ocaml-graphql-server"><code>graphql-lwt</code></a> package), assuming your content type is <code>'a</code>. We could construct a GraphQL object type for our example content type <code>contact</code> as follows:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token comment">(* (unit, contact option) Graphql_lwt.Schema.typ *)</span>
<span class="token keyword">let</span> contact_schema_typ <span class="token operator">=</span> <span class="token module variable">Graphql_lwt</span><span class="token punctuation">.</span><span class="token module variable">Schema</span><span class="token punctuation">.</span><span class="token punctuation">(</span>obj <span class="token string">&quot;Contact&quot;</span>
  <span class="token label function">~fields</span><span class="token punctuation">:</span><span class="token punctuation">(</span><span class="token keyword">fun</span> <span class="token punctuation">_</span> <span class="token operator">-&gt;</span> <span class="token punctuation">[</span>
    field <span class="token string">&quot;name&quot;</span>
      <span class="token label function">~typ</span><span class="token punctuation">:</span><span class="token punctuation">(</span>non_null string<span class="token punctuation">)</span>
      <span class="token label function">~args</span><span class="token punctuation">:</span><span class="token punctuation">[</span><span class="token punctuation">]</span>
      <span class="token label function">~resolve</span><span class="token punctuation">:</span><span class="token punctuation">(</span><span class="token keyword">fun</span> <span class="token punctuation">_</span> contact <span class="token operator">-&gt;</span>
        contact<span class="token punctuation">.</span>name
      <span class="token punctuation">)</span>
    <span class="token punctuation">;</span>
    <span class="token comment">(* ... more fields *)</span>
  <span class="token punctuation">]</span><span class="token punctuation">)</span>
<span class="token punctuation">)</span></code></pre></div>
<p>To use the custom type, you need to instantiate the functor <code>Irmin_unix.Graphql.Server.Make_ext</code> (assuming you're deploying to a Unix target) with an Irmin store (type <code>Irmin.S</code>) and a custom types module (type <code>Irmin_graphql.Server.CUSTOM_TYPES</code>). This requires a bit of plumbing:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token comment">(* Instantiate the Irmin functor somehow *)</span>
<span class="token keyword">module</span> S <span class="token punctuation">:</span> <span class="token module variable">Irmin</span><span class="token punctuation">.</span>S <span class="token keyword">with</span> <span class="token keyword">type</span> contents <span class="token operator">=</span> contact <span class="token operator">=</span>
  <span class="token comment">(* ... *)</span>

<span class="token comment">(* Custom GraphQL presentation module *)</span>
<span class="token keyword">module</span> <span class="token module variable">Custom_types</span> <span class="token operator">=</span> <span class="token keyword">struct</span>
  <span class="token comment">(* Construct default GraphQL types *)</span>
  <span class="token keyword">module</span> <span class="token module variable">Defaults</span> <span class="token operator">=</span> <span class="token module variable">Irmin_graphql</span><span class="token punctuation">.</span><span class="token module variable">Server</span><span class="token punctuation">.</span><span class="token module variable">Default_types</span> <span class="token punctuation">(</span>S<span class="token punctuation">)</span>

  <span class="token comment">(* Use the default types for most things *)</span>
  <span class="token keyword">module</span> <span class="token module variable">Key</span> <span class="token operator">=</span> <span class="token module variable">Defaults</span><span class="token punctuation">.</span><span class="token module variable">Key</span>
  <span class="token keyword">module</span> <span class="token module variable">Metadata</span> <span class="token operator">=</span> <span class="token module variable">Defaults</span><span class="token punctuation">.</span><span class="token module variable">Metadata</span>
  <span class="token keyword">module</span> <span class="token module variable">Hash</span> <span class="token operator">=</span> <span class="token module variable">Defaults</span><span class="token punctuation">.</span><span class="token module variable">Hash</span>
  <span class="token keyword">module</span> <span class="token module variable">Branch</span> <span class="token operator">=</span> <span class="token module variable">Defaults</span><span class="token punctuation">.</span><span class="token module variable">Branch</span>

  <span class="token comment">(* Use custom output type for contents *)</span>
  <span class="token keyword">module</span> <span class="token module variable">Contents</span> <span class="token operator">=</span> <span class="token keyword">struct</span>
    <span class="token keyword">include</span> <span class="token module variable">Defaults</span><span class="token punctuation">.</span><span class="token module variable">Contents</span>
    <span class="token keyword">let</span> schema_typ <span class="token operator">=</span> contact_schema_typ
  <span class="token keyword">end</span>
<span class="token keyword">end</span>

<span class="token keyword">module</span> <span class="token module variable">Remote</span> <span class="token operator">=</span> <span class="token keyword">struct</span>
  <span class="token keyword">let</span> remote <span class="token operator">=</span> <span class="token module variable">Some</span> s<span class="token punctuation">.</span>remote
<span class="token keyword">end</span>

<span class="token keyword">module</span> <span class="token module variable">GQL</span> <span class="token operator">=</span> <span class="token module variable">Irmin_unix</span><span class="token punctuation">.</span><span class="token module variable">Graphql</span><span class="token punctuation">.</span><span class="token module variable">Server</span><span class="token punctuation">.</span><span class="token module variable">Make_ext</span> <span class="token punctuation">(</span>S<span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token module variable">Remote</span><span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token module variable">Custom_types</span><span class="token punctuation">)</span></code></pre></div>
<p>With this in hand, we can now query specifically for the email of <code>john-doe</code>:</p>
<div class="gatsby-highlight" data-language="graphql"><pre class="language-graphql"><code class="language-graphql"><span class="token keyword">query</span> <span class="token punctuation">{</span>
  <span class="token object">master</span> <span class="token punctuation">{</span>
    <span class="token object">tree</span> <span class="token punctuation">{</span>
      <span class="token property-query">get</span><span class="token punctuation">(</span><span class="token attr-name">key</span><span class="token punctuation">:</span> <span class="token string">&quot;john-doe&quot;</span><span class="token punctuation">)</span> <span class="token punctuation">{</span>
        <span class="token property">email</span>
      <span class="token punctuation">}</span>
    <span class="token punctuation">}</span>
  <span class="token punctuation">}</span>
<span class="token punctuation">}</span></code></pre></div>
<p>... and get a nicely structured JSON response back:</p>
<div class="gatsby-highlight" data-language="json"><pre class="language-json"><code class="language-json"><span class="token punctuation">{</span>
  <span class="token property">&quot;master&quot;</span><span class="token operator">:</span> <span class="token punctuation">{</span>
    <span class="token property">&quot;tree&quot;</span><span class="token operator">:</span> <span class="token punctuation">{</span>
      <span class="token property">&quot;get&quot;</span><span class="token operator">:</span> <span class="token punctuation">{</span>
        <span class="token property">&quot;email&quot;</span><span class="token operator">:</span> <span class="token string">&quot;john.doe@gmail.com&quot;</span>
      <span class="token punctuation">}</span>
    <span class="token punctuation">}</span>
  <span class="token punctuation">}</span>
<span class="token punctuation">}</span></code></pre></div>
<p>The custom types is very powerful and opens up for transforming or enriching the data at query time, e.g. geocoding the address of a contact, or checking an on-line status.</p>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#watches" aria-label="watches permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Watches</h1>
<p>A core feature of Irmin is the ability to <em>watch</em> for changes to the underlying data store in real-time. <code>irmin-graphql</code> takes advantage of GraphQL subscriptions to expose Irmin watches. Subscriptions are a relative recent addition to the GraphQL spec (<a href="https://tarides.com/graphql-spec-june-2018">June 2018</a>), which allows clients to <em>subscribe</em> to changes. These changes are pushed to the client over a suitable transport mechanism, e.g. websockets, Server-Sent Events, or a chunked HTTP response, as a regular GraphQL response.</p>
<p>As an example, the following query watches for all changes and returns the new hash:</p>
<div class="gatsby-highlight" data-language="graphql"><pre class="language-graphql"><code class="language-graphql"><span class="token keyword">subscription</span> <span class="token punctuation">{</span>
  <span class="token object">watch</span> <span class="token punctuation">{</span>
    <span class="token object">commit</span> <span class="token punctuation">{</span>
      <span class="token property">hash</span>
    <span class="token punctuation">}</span>
  <span class="token punctuation">}</span>
<span class="token punctuation">}</span></code></pre></div>
<p>For every change, a message like the following will be sent:</p>
<div class="gatsby-highlight" data-language="json"><pre class="language-json"><code class="language-json"><span class="token punctuation">{</span>
  <span class="token property">&quot;watch&quot;</span><span class="token operator">:</span> <span class="token punctuation">{</span>
    <span class="token property">&quot;commit&quot;</span><span class="token operator">:</span> <span class="token punctuation">{</span>
      <span class="token property">&quot;hash&quot;</span><span class="token operator">:</span> <span class="token string">&quot;c01a59bacc16d89e9cdd344a969f494bb2698d8f&quot;</span>
    <span class="token punctuation">}</span>
  <span class="token punctuation">}</span>
<span class="token punctuation">}</span></code></pre></div>
<p>Under the hood, subscriptions in <code>irmin-graphql</code> are implemented using Irmin watches, but this is opaque to the client -- this will work with any GraphQL spec compliant client!</p>
<p>Here's a video, which hows how the GraphQL response changes live as the Irmin store is being manipulated:</p>
<p><video controls="controls" width="680"><source src="/blog/2019-11-27-introducing-irmin-graphql/irmin-subscriptions.mp4" type="video/mp4"></source></video></p>
<p>Note that the current implementation only supports websockets with more transport options coming soon.</p>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#wrap-up" aria-label="wrap up permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Wrap-up</h1>
<p>Irmin 2.0 ships with a powerful new GraphQL API, that makes it much easier to interact with Irmin over the network. This makes Irmin available for many more languages and contexts, not just applications using OCaml (or Javascript). The new API operates at a much high level than the old API, and offers advanced features such as &quot;bring your own GraphQL types&quot;, and watching for changes via GraphQL subscriptions.</p>
<p>We're looking forward to seeing what you'll build with it!</p>
