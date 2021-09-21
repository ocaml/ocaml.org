
type t =
  { title : string
  ; slug : string
  ; description : string option
  ; url : string
  ; date : string
  ; preview_image : string option
  ; body_html : string
  }
  
let all = 
[
  { title = {js|Building Ahrefs codebase with Melange|js}
  ; slug = {js|building-ahrefs-codebase-with-melange|js}
  ; description = Some {js|What we learnt after experimenting with Melange, a fork of ReScript with a strong focus on keeping compatibility with OCaml.|js}
  ; url = {js|https://tech.ahrefs.com/building-ahrefs-codebase-with-melange-9f881f6d022b?source=rss----303662d88bae--ocaml|js}
  ; date = {js|2021-05-18T15:24:20-00:00|js}
  ; preview_image = Some {js|https://miro.medium.com/max/1200/1*tYLUO4FDmJ6bzlsPp14LdQ.jpeg|js}
  ; body_html = {js|<figure><img alt="" src="https://cdn-images-1.medium.com/max/1024/1*tYLUO4FDmJ6bzlsPp14LdQ.jpeg" /><figcaption>Photo by <a href="https://unsplash.com/@madebyjens?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Jens Lelie</a> on <a href="https://unsplash.com/s/photos/fork-road?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Unsplash</a></figcaption></figure><p>At Ahrefs, we have been using BuckleScript and ReasonML in production <a href="https://tech.ahrefs.com/one-and-a-half-years-of-reasonml-in-production-2250cf5ba63b">for more than two years</a>. We already have a codebase of tens of thousands of lines of code, with several web applications that are data intensive and communicate with backend services written in <a href="http://ocaml.org/">OCaml</a>, using tools like <a href="https://github.com/ahrefs/atd">atd</a>.</p><p>Given our investment in these technologies, we have been following closely the recent changes in <a href="https://rescript-lang.org/">ReScript</a>, with its rebrand and renaming, and the split with the ReasonML project, explained in the project <a href="https://rescript-lang.org/blog/bucklescript-is-rebranding">blog post</a>.</p><h3>ReScript: becoming its own language</h3><p>We are excited about the way ReScript is unifying the experience and making it easier for developers who are getting started to find documentation in a single place, as well as continuing its strong focus on performance and readable JavaScript output.</p><p>On the other hand, we are trying to figure out the implications of this change in the mid- and long-term, especially regarding the integration with the OCaml ecosystem. And more importantly, what this evolution will mean for production users like us who rely on this integration.</p><p>ReScript integration with OCaml has historically been seamless, as BuckleScript started originally as a <a href="https://www.reddit.com/r/ocaml/comments/4enok3/bloombergbucklescript_a_back_end_for_the_ocaml/">new backend for the OCaml compiler</a>. However, in recent months, there have been several hints that ReScript wants to evolve towards becoming its own language:</p><ul><li>It has now <a href="https://github.com/rescript-lang/syntax">its own parser</a>, incompatible with OCaml native applications</li><li>Official repository guidelines for technical writing mentions explicitly that <a href="https://github.com/rescript-association/rescript-lang.org/blob/master/CONTRIBUTING.md#technical-writing-documentation">no reference to OCaml</a> should appear in docs</li><li>Upgrades to the latest version of OCaml compiler, which <a href="https://web.archive.org/web/20210208054855if_/https://github.com/rescript-lang/rescript-compiler/wiki">used to be part of the roadmap</a>, have been <a href="https://forum.rescript-lang.org/t/some-thoughts-on-community-building/1474">deprioritized</a> recently.</li></ul><p>So, even if officially ReScript has not announced that they will break backwards compatibility with OCaml, just the fact that it is sticking with an old version of the OCaml compiler poses some challenges for us in terms of tooling. The uncertainty about the future and the pace of changes add some risk to the high-level goals we have for our teams and codebase: we would like to share <em>more</em> code between frontend and backend, not less.</p><h3>Melange: a fork of ReScript, focused on OCaml compatibility</h3><p>When António Monteiro <a href="https://anmonteiro.com/2021/03/on-ocaml-and-the-js-platform/">announced Melange</a>, a fork of ReScript but with a strong focus on keeping compatibility with OCaml, we decided to try it out and see how it could work for us.</p><p>Ultimately, the experiment was successful. We managed to build all our frontend applications with Melange, while keeping the existing bundling setup, which currently uses Webpack.</p><p>Throughout this process, we had to modify some parts of the code. We will now go through the most relevant parts of the process:</p><ul><li>Upgrade to OCaml 4.12: the most relevant part was the deprecation of Pervasives module to use Stdlib.</li><li>Use ppxlib in our ppxs: we had to upgrade the two ppxs that we use in the frontend codebase to the latest compiler version, <a href="https://github.com/ahrefs/bs-emotion/compare/master...jchavarri:ocaml4.12-ppxlib">bs-emotion-ppx</a> and an in-house <a href="https://github.com/ahrefs/bs-react-intl-ppx">ppx for internationalization</a>.</li><li>Configure esy: we were already using esy to bring the editor tooling into scope of the developer environment, so we just had to make sure melange would also be included in the json configuration.</li><li>Upgrade to Reason 3.7.0: a quite simple change too, as the whole process is automated by using refmt. As a side note, we ran into <a href="https://github.com/reasonml/reason/issues/2636">a small bug</a> with some type annotations, that we were able to work around.</li><li>“Lift” dune workspace to the root of our monorepo: this is probably the most intrusive change. Because we have shared code between backend and frontend, and Dune needs to have access to all sources under its workspace, we had to “lift” the Dune workspace from the backend directory to the root of monorepo.</li></ul><h3>The good</h3><p>This experiment allowed us to experience what a project like Melange could offer for our use case. Here are some of the things we might be able to leverage in a codebase built with Melange:</p><ul><li>Recent version of the OCaml compiler: at some point, we could pin compiler version between backend and frontend teams, making upgrades more straightforward as they would happen atomically.</li><li>Shared editor tooling: the official OCaml <a href="https://github.com/ocamllabs/vscode-ocaml-platform">vscode extension</a> works great with Melange, as well as any other OCaml editor integration. Having backend and frontend teams use similar editor setup removes a lot of maintenance work for us.</li><li>Consuming ppxs from source: Melange allows to consume ppxs from source, which also removes issues with pre-compiled ppxs (like this issue with the recent <a href="https://github.com/ahrefs/bs-emotion/issues/53">M1 Macs</a>).</li><li>Melange allows to run all ppxs <a href="https://github.com/melange-re/melange/pull/171">from a single executable file</a>, which has some nice performance benefits.</li><li>Use Dune for atd files generators: ReScript “generators” are unfortunately <a href="https://web.archive.org/web/20200710044513if_/https://reasonml.org/docs/reason-compiler/latest/build-advanced">not documented anymore</a>, but we use them extensively for atd file generation. Being able to share Dune rules in backend and frontend would make our build setup easier.</li><li>Access to OCaml documentation tooling: Melange allows to leverage existing tooling for generating documentation, like <a href="https://github.com/ocaml/odoc/">odoc</a>.</li><li>Async syntax: the latest Reason version <a href="https://github.com/reasonml/reason/pull/2487">supports “let op” syntax</a>, which is handy for client-side code.</li></ul><h3>The bad</h3><p>While there are many things that are exciting about Melange, there are some other parts that can be improved.</p><ul><li>Build performance: We already knew that performance would be far worse than ReScript, as Melange uses Dune in a way that it was not designed for. In our tests, builds with Melange are roughly 1 order of magnitude slower than ReScript ones.</li><li>First-class Dune support: if there was a deeper integration between Dune and Melange, we could explore features like shared libraries or shared rules between backend and frontend. As of today, Dune has no knowledge about Melange environment, so it can perform basic rules execution, but there is no access to high level stanzas like library in Melange.</li><li>Two-headed goal: finally, we see a more strategic risk in Melange proposition. Right now it has two goals: keep compatibility with both ReScript and OCaml. But we don’t know how long these goals will be feasible. If at some point ReScript decides to move away from the OCaml compiler fully, then Melange users would not be able to consume any updates to the ReScript ecosystem anymore.</li></ul><h3>Alright, but are you migrating to Melange or ReScript?</h3><p>With all the information available, the answer is: we don’t know yet. 😄 We want to keep exploring all the available options and have as much information as possible before committing further. So for now, we are upgrading the codebase to recent versions of ReScript, but we are holding up on features that only work one way. For example, we have not migrated our codebase to the ReScript syntax yet, as <a href="https://github.com/rescript-lang/syntax/issues/405">there is no way to translate back to Reason syntax</a>.</p><p>In the meantime, we will keep exploring how far the limitations of Melange can be mitigated. To be continued! 🚀</p><p><em>Thanks to Igor and Feihong for reviewing and improving earlier versions of this post.</em></p><img src="https://medium.com/_/stat?event=post.clientViewed&referrerSource=full_rss&postId=9f881f6d022b" width="1" height="1" alt=""><hr><p><a href="https://tech.ahrefs.com/building-ahrefs-codebase-with-melange-9f881f6d022b">Building Ahrefs codebase with Melange</a> was originally published in <a href="https://tech.ahrefs.com">ahrefs</a> on Medium, where people are continuing the conversation by highlighting and responding to this story.</p>|js}
  };
 
  { title = {js|Getting started with atdgen and bucklescript|js}
  ; slug = {js|getting-started-with-atdgen-and-bucklescript|js}
  ; description = Some {js|atdgen is a project to create types and data structures that can be serialized to JSON. It is very convenient when communicating between…|js}
  ; url = {js|https://tech.ahrefs.com/getting-started-with-atdgen-and-bucklescript-1f3a14004081?source=rss----303662d88bae--ocaml|js}
  ; date = {js|2018-09-12T02:53:58-00:00|js}
  ; preview_image = None
  ; body_html = {js|<p><a href="https://github.com/mjambon/atd">atdgen</a> is a project to create types and data structures that can be serialized to JSON. It is very convenient when communicating between multiple processes, creating a REST API or consuming JSON objects from other tools. It can be compared to <a href="https://json-schema.org/">JSON schema</a> or <a href="https://developers.google.com/protocol-buffers/">Protocol Buffers</a>, but with richer types and more features.</p><p>The idea is to write a list of types in a specification file, an .atd file. Then running atdgen, it is possible to generate OCaml or Java code to serialize/deserialize values of those types to/from corresponding json.</p><p>Until very recently, atdgen could generate code only for native OCaml. But <a href="https://github.com/mjambon/atd/pull/44">the support of bucklescript has been merged</a>! atdgen the cli tool is still a native OCaml binary. But it can output some OCaml code that can be compiled using <a href="https://bucklescript.github.io/">bucklescript</a>.</p><p>The work to implement this new feature of atdgen has been funded by <a href="https://ahrefs.com/">Ahrefs</a>. We highly appreciate open source tools. And as much as possible, we prefer to contribute to existing open source projects rather than to re-invent the wheel internally.</p><h3>Installation</h3><p>To install atdgen we first need to install <a href="https://opam.ocaml.org">opam</a> (OCaml package manager), as atdgen doesn’t provide ready to use binaries and is only distributed as source package via opam. The procedure is simple and documented here: <a href="https://opam.ocaml.org/doc/2.0/Install.html">https://opam.ocaml.org/doc/2.0/Install.html</a></p><p>Then we need to initialize opam and create a switch. Any version of ocaml greater or equal to 4.03.0 should be fine.</p><pre>opam init -a<br>opam switch create . 4.07.1 -y</pre><p>Once it is done, we have to install the development version of atdgen. The support of bucklescript is not officially released.</p><pre>opam pin add atd --dev-repo   <br>opam pin add atdgen --dev-repo</pre><p>Make sure that atdgen is available.</p><pre>$ which atdgen                 <br>(current $PWD)/_opam/bin/atdgen</pre><p>Of course, we need bucklescript.</p><pre>yarn init                 <br>yarn add bs-platform --dev</pre><p>We also need the bucklescript runtime for atdgen, as it is not currently provided by atdgen itself. So we have written and open-sourced our version of the runtime : <a href="https://github.com/ahrefs/bs-atdgen-codec-runtime">https://github.com/ahrefs/bs-atdgen-codec-runtime</a>.</p><p>This runtime is responsible for the conversion between JSON values and OCaml values. The JSON values are based on the standard <a href="https://bucklescript.github.io/bucklescript/api/Js.Json.html#TYPEt">Js.Json.t type</a> provided by bucklescript to be sure that it is easy to interoperate with the rest of the ecosystem.</p><p>It is published on npm for easy integration in bucklescript projects.</p><pre>yarn add @ahrefs/bs-atdgen-codec-runtime</pre><h3>Project configuration</h3><p>After the previous section, package.json should be almost ready. We can add a few scripts to make it more convenient to compile the project. Here is how it should look once completed.</p><pre>{<br>  &quot;name&quot;: &quot;demo-bs-atdgen&quot;,<br>  &quot;version&quot;: &quot;0.0.1&quot;,<br>  &quot;description&quot;: &quot;demo of atdgen with bucklescript&quot;,<br>  &quot;scripts&quot;: {<br>    &quot;clean&quot;: &quot;bsb -clean-world&quot;,<br>    &quot;build&quot;: &quot;bsb -make-world&quot;,<br>    &quot;watch&quot;: &quot;bsb -make-world -w&quot;,<br>    &quot;atdgen&quot;: &quot;atdgen -t meetup.atd &amp;&amp; atdgen -bs meetup.atd&quot;<br>  },<br>  &quot;devDependencies&quot;: {<br>    &quot;bs-platform&quot;: &quot;^4.0.5&quot;<br>  },<br>  &quot;peerDependencies&quot;: {<br>    &quot;bs-platform&quot;: &quot;^4.0.5&quot;<br>  },<br>  &quot;dependencies&quot;: {<br>    &quot;<a href="http://twitter.com/ahrefs/bs-atdgen-codec-runtime">@ahrefs/bs-atdgen-codec-runtime</a>&quot;: &quot;^1.0.4&quot;<br>  }<br>}</pre><p>The bucklescript configuration is very simple. We use the basic configuration that can be found in any bucklescript project. Except that we need to add one dependency to bsconfig.json:</p><pre>{<br>  &quot;name&quot;: &quot;demo-bs-atdgen&quot;,<br>  &quot;version&quot;: &quot;0.0.1&quot;,<br>  &quot;sources&quot;: {<br>    &quot;dir&quot;: &quot;src&quot;,<br>    &quot;subdirs&quot;: true<br>  },<br>  &quot;package-specs&quot;: {<br>    &quot;module&quot;: &quot;commonjs&quot;,<br>    &quot;in-source&quot;: true<br>  },<br>  &quot;suffix&quot;: &quot;.bs.js&quot;,<br>  &quot;bs-dependencies&quot;: [<br>    &quot;<a href="http://twitter.com/ahrefs/bs-atdgen-codec-runtime">@ahrefs/bs-atdgen-codec-runtime</a>&quot;<br>  ],<br>  &quot;warnings&quot;: {<br>    &quot;error&quot;: &quot;+101&quot;<br>  },<br>  &quot;generate-merlin&quot;: true,<br>  &quot;namespace&quot;: true,<br>  &quot;refmt&quot;: 3<br>}</pre><h3>First ATD definitions</h3><p>It is time to create a first .atd file, containing our types. This part is also documented on <a href="https://atd.readthedocs.io/en/latest/tutorial.html#getting-started">https://atd.readthedocs.io/en/latest/tutorial.html#getting-started</a></p><p>For this example, I decided to go with a meetup event. Put the type definitions in src/meetup.atd.</p><pre>(* This is a comment. Same syntax as in ocaml. *)</pre><pre>type access = [ Private | Public ]</pre><pre>(* the date will be a float in the json and a Js.Date.t in ocaml *)<br>type date = float wrap &lt;ocaml module=&quot;Js.Date&quot; wrap=&quot;Js.Date.fromFloat&quot; unwrap=&quot;Js.Date.valueOf&quot;&gt;</pre><pre>(* Some people don&#39;t want to provide a phone number, make it optional *)<br>type person = {<br>  name: string;<br>  email: string;<br>  ?phone: string nullable;<br>}</pre><pre>type event = {<br>  access: access;<br>  name: string;<br>  host: person;<br>  date: date;<br>  guests: person list;<br>}</pre><pre>type events = event list</pre><p>We use the atdgen binary (compiled previously) to generate the ocaml types and the code to serialize/deserialize those types.</p><pre>atdgen -t meetup.atd # generates an ocaml file containing the types<br>atdgen -bs meetup.atd # generates the code to (de)serialize</pre><p>The generated files are:</p><ul><li>meetup_t.ml(i) which contain the ocaml types corresponding to our ATD definitions.</li><li>meetup_bs.ml(i) which contain the ocaml code to transform from and to json values.</li></ul><p>At this point we can compile our project.</p><pre>yarn build</pre><p>If everything worked properly, we now have two .bs.js files in the src directory.</p><pre>$ tree src<br>src<br>├── meetup.atd<br>├── meetup_bs.bs.js<br>├── meetup_bs.ml<br>├── meetup_bs.mli<br>├── meetup_t.bs.js<br>├── meetup_t.ml<br>└── meetup_t.mli</pre><pre>0 directories, 7 files</pre><p>At this point, we can create new OCaml/Reason files in the src directory and use all the code atdgen generated for us. Two examples to illustrate that.</p><h3>Query a REST API</h3><p>A common usage of atdgen is to decode the JSON returned by a REST API. Here is a short example, using the reason syntax and bs-fetch.</p><pre>let get = (url, decode) =&gt;<br>  Js.Promise.(<br>    Fetch.fetchWithInit(<br>      url,<br>      Fetch.RequestInit.make(~method_=Get, ()),<br>    )<br>    |&gt; then_(Fetch.Response.json)<br>    |&gt; then_(json =&gt; json |&gt; decode |&gt; resolve)<br>  );</pre><pre>let v: Meetup_t.events =<br>  get(<br>    &quot;<a href="http://localhost:8000/events">http://localhost:8000/events</a>&quot;,<br>    Atdgen_codec_runtime.Decode.decode(Meetup_bs.read_events),<br>  );</pre><h3>Read and write a JSON file</h3><p>Atdgen for bucklescript doesn’t take care of converting a string to a JSON object. Which allows us to use the performant json parser included in nodejs or the browser.</p><pre>let read_events filename =<br>  (* Read and parse the json file from disk, this doesn&#39;t involve atdgen. *)<br>  let json =<br>    Node_fs.readFileAsUtf8Sync filename<br>    |&gt; Js.Json.parseExn<br>  in<br>  (* Turn it into a proper record. The annotation is of course optional. *)<br>  let events: Meetup_t.events =<br>    Atdgen_codec_runtime.Decode.decode Meetup_bs.read_events json<br>  in<br>  events</pre><p>The reverse operation, converting a record to a JSON object and writing it in a file is also straightforward.</p><pre>let write_events filename events =<br>  Atdgen_codec_runtime.Encode.encode Meetup_bs.write_events events (* turn a list of records into json *)<br>  |. Js.Json.stringifyWithSpace 2   (* convert the json to a pretty string *)<br>  |&gt; Node_fs.writeFileAsUtf8Sync filename  (* write the json in our file *)</pre><h3>Full example</h3><p>Now that we have our functions to read and write events, we can build a small cli to pretty print the list of events and add new events.</p><p>The source code of the full example is available <a href="https://github.com/ahrefs/bs-atdgen-codec-runtime/tree/master/example">on github</a>.</p><p>You can run it like this:</p><pre>$ echo &quot;[]&quot; &gt; events.json<br>$ nodejs src/cli.bs.js add louis <a href="mailto:louis@nospam.com">louis@nospam.com</a><br>$ nodejs src/cli.bs.js add bob <a href="mailto:bob@nospam.com">bob@nospam.com</a><br>$ nodejs src/cli.bs.js print<br>=== OCaml/Reason Meetup! summary ===<br>date: Tue, 11 Sep 2018 15:04:16 GMT<br>access: public<br>host: bob &lt;<a href="mailto:bob@nospam.com">bob@nospam.com</a>&gt;<br>guests: 1<br>=== OCaml/Reason Meetup! summary ===<br>date: Tue, 11 Sep 2018 15:04:13 GMT<br>access: public<br>host: louis &lt;<a href="mailto:louis@nospam.com">louis@nospam.com</a>&gt;<br>guests: 1<br>$ cat events.json<br>[<br>  {<br>    &quot;guests&quot;: [<br>      {<br>        &quot;email&quot;: &quot;<a href="mailto:bob@nospam.com">bob@nospam.com</a>&quot;,<br>        &quot;name&quot;: &quot;bob&quot;<br>      }<br>    ],<br>    &quot;date&quot;: 1536678256177,<br>    &quot;host&quot;: {<br>      &quot;email&quot;: &quot;<a href="mailto:bob@nospam.com">bob@nospam.com</a>&quot;,<br>      &quot;name&quot;: &quot;bob&quot;<br>    },<br>    &quot;name&quot;: &quot;OCaml/Reason Meetup!&quot;,<br>    &quot;access&quot;: &quot;Public&quot;<br>  },<br>  {<br>    &quot;guests&quot;: [<br>      {<br>        &quot;email&quot;: &quot;<a href="mailto:louis@nospam.com">louis@nospam.com</a>&quot;,<br>        &quot;name&quot;: &quot;louis&quot;<br>      }<br>    ],<br>    &quot;date&quot;: 1536678253790,<br>    &quot;host&quot;: {<br>      &quot;email&quot;: &quot;<a href="mailto:louis@nospam.com">louis@nospam.com</a>&quot;,<br>      &quot;name&quot;: &quot;louis&quot;<br>    },<br>    &quot;name&quot;: &quot;OCaml/Reason Meetup!&quot;,<br>    &quot;access&quot;: &quot;Public&quot;<br>  }<br>]</pre><img src="https://medium.com/_/stat?event=post.clientViewed&referrerSource=full_rss&postId=1f3a14004081" width="1" height="1" alt=""><hr><p><a href="https://tech.ahrefs.com/getting-started-with-atdgen-and-bucklescript-1f3a14004081">Getting started with atdgen and bucklescript</a> was originally published in <a href="https://tech.ahrefs.com">ahrefs</a> on Medium, where people are continuing the conversation by highlighting and responding to this story.</p>|js}
  };
 
  { title = {js|How to write a library for BuckleScript and Native|js}
  ; slug = {js|how-to-write-a-library-for-bucklescript-and-native|js}
  ; description = Some {js|This blog post is an introduction on how to setup a library available for both BuckleScript and OCaml, sharing as much code as possible.|js}
  ; url = {js|https://tech.ahrefs.com/how-to-write-a-library-for-bucklescript-and-native-22f45e5e946d?source=rss----303662d88bae--ocaml|js}
  ; date = {js|2019-10-22T10:09:09-00:00|js}
  ; preview_image = None
  ; body_html = {js|<p><em>Written with </em><a href="https://twitter.com/javierwchavarri"><em>Javier Chávarri</em></a><em> and </em><a href="https://github.com/feihong/"><em>Feihong Hsu</em></a><em>.</em></p><p>The first <a href="https://www.reason-conf.us/">Reason Conf US</a> just ended. Many talks mentioned native compilation. Sharing code between BuckleScript and native artifacts is a use case which is more and more common. This blog post is an introduction on how to set up a library available for both worlds, sharing as much code as possible.</p><h3>The goal</h3><p>What we try to produce is a library with an identical interface for BuckleScript and native. But without duplicating code. It should also be possible to have some parts of the library that are a different implementation depending on the target, as we want to be able to leverage existing libraries that are working only in one of the worlds.</p><h3>The build systems</h3><p>For BuckleScript, there is only one build system: bsb. It is driven by a bsconfig.json file. And is installed as part of the bs-platform.</p><p>On the native side, there are a lot of different build systems that are available. But recently one of them became a de facto standard: dune. It works with a very minimal amount of configuration. And it supports the reason syntax by default.</p><p>These two tools are working in a way which is pretty similar. They share a lot of concepts. And it is easy to set them up so that both are working in the same codebase.</p><p>The main similarities that interest us are:</p><ul><li>The ability to work on specific source directories</li><li>Namespacing in bsb and wrapping in dune are both putting all the<br>files of the library under a single module name</li></ul><h3>The source code file tree</h3><p>The code of the library is split into 3 directories.</p><pre>├── js/<br>├── native/<br>└── shared/</pre><ul><li>shared is meant to host most of the code and all the code in this directory will be compiled in both modes.</li><li>js contains the parts that are specific to BuckleScript.</li><li>native contains the parts that are specific to native OCaml.</li></ul><h3>Set up the build systems</h3><p>Once we have our basic skeleton for the library, it is time to set up the build systems. We want to have two configurations as similar as possible to make them easier to understand. Once we are done, the tree will look like this:</p><pre>├── bsconfig.json<br>├── dune<br>├── dune-project<br>├── js/<br>├── native/<br>└── shared/</pre><h4>BuckleScript</h4><p>At the root of the library we need a bsconfig.json file to drive<br>bsb. The documentation is available at <a href="https://bucklescript.github.io/docs/en/build-configuration](https://bucklescript.github.io/docs/en/build-configuration).">https://bucklescript.github.io/docs/en/build-configuration</a>.</p><p>The main part for us is sources. We will use it to tell bsb to look at the js and shared folders. We also want to set namespace to true, which will wrap all your project’s files under a common module name.</p><pre>  &quot;namespace&quot;: true,<br>  &quot;sources&quot;: [<br>    {<br>      &quot;dir&quot;: &quot;js&quot;,<br>      &quot;subdirs&quot;: true<br>    }, {<br>      &quot;dir&quot;: &quot;shared&quot;,<br>      &quot;subdirs&quot;: true<br>    }<br>  ],</pre><p>The rest of the file is as usual.</p><pre>{<br>  &quot;name&quot;: &quot;sharedlib&quot;,<br>  &quot;namespace&quot;: true,<br>  &quot;sources&quot;: [<br>    {<br>      &quot;dir&quot;: &quot;js&quot;,<br>      &quot;subdirs&quot;: true<br>    }, {<br>      &quot;dir&quot;: &quot;shared&quot;,<br>      &quot;subdirs&quot;: true<br>    }<br>  ],<br>  &quot;package-specs&quot;: {<br>    &quot;module&quot;: &quot;es6&quot;,<br>    &quot;in-source&quot;: true<br>  },<br>  &quot;refmt&quot;: 3,<br>  &quot;suffix&quot;: &quot;.bs.js&quot;,<br>  &quot;generate-merlin&quot;: true,<br>}</pre><h4>Dune</h4><p>We must also add a dune file to the root of the library. For dune, we have different options — it is possible to ignore the js directory but read everything else. Or to check only shared and native. To make the configuration similar to BuckleScript, we will go with the second solution.</p><p>The dune directive to do that is dirs. By defaults it tells dune to explore every directory except the ones hidden (starting with a dot) or starting with an underscore. <a href="https://dune.readthedocs.io/en/stable/dune-files.html#dirs-since-1-6">More details in dune’s documentation</a>. To make it do what we want, the configuration should be:</p><pre>(dirs shared native)</pre><p>We also use another option of dune to tell it to include the content of those two directories as if it was at the root of the project. Without this stanza, dune would only use the source files at the root of the project and ignore everything in the sub directories.</p><pre>(include_subdirs unqualified)</pre><p>Then we need the usual library stanza to give a name to our library, state the dependencies, compilation flags, etc. In our simple case, the only information needed is the name. We can explicitly set wrapped to true, but this is already the default behavior. The <a href="https://dune.readthedocs.io/en/stable/dune-files.html#library">documentation for the whole library stanza</a> describes how to specify more details.</p><p>The final dune file looks like this:</p><pre>(dirs shared native)<br> (include_subdirs unqualified)<br> (library<br>  (name sharedlib))</pre><p>We also want a basic dune-project. If we don’t write it by hand, dune will generate it for us. I am using version 1.10 as an example. But it can be changed to whatever version suits your project.</p><pre>(lang dune 1.10)</pre><h3>Compilation</h3><p>With the setup described above, the compilation for BuckleScript and native is the same as in a setup with only one or the other.</p><ul><li>bsb -make-world for BuckleScript</li><li>dune build @all for dune</li></ul><p>The call to bsb is usally put in package.json in the scripts part, so that the usual yarn build can be used. For native, it depends if you rely on esy or opam.</p><h3>How to consume the library</h3><p>This is exactly the same setup that would be used in a pure BuckleScript or pure native library.</p><p>To use your library in BuckleScript:</p><ul><li>Add the name and version to package.json</li><li>Add the name to bsbconfig.json of consuming library/app</li></ul><p>To use your library in native OCaml, add the name of your library to the libraries part an executable or library stanza, e.g.</p><pre>(executable<br> (name main)<br> (libraries sharedlib))</pre><h3>Module naming</h3><p>If you want your module name to contain capital letters in the middle (e.g. TeenageMutantNinjaTurtles), then be aware that <a href="https://bucklescript.github.io/docs/en/build-configuration.html#name-namespace">name munging</a> works differently between bsbconfig.json and dune. For example, if you want to refer to your module as CoolSharedLib in your code, then the name in bsbconfig.json must be cool-shared-lib, and in dune it must be coolSharedLib.</p><h3>Platform specific code</h3><p>The whole library does not have to be exactly the same in the two platform. It is possible to add modules that are available only in one mode. Or to have modules with a different interface.</p><p>For example, by adding a file Foo.re in js but not in native, the library now has a module Foo available when compiled to javascript. But only when compiled to javascript.</p><h3>Downsides</h3><ul><li>Both bsb and dune generate .merlin files when they compile our library. They override each other. It might be troublesome if the version of ocaml used for native code is not 4.02.3. Simply recompile the library for your platform to solve the problem.</li><li>Out of the box, this approach doesn’t really allow us to share interface files between both platforms: native and BuckleScript. One workaround for that, if we wanted to share some module Foo, is to:<br>1. add Foo.mli or Foo.rei file in shared<br>2. add include FooImplementation in Foo.ml<br>3. add FooImplementation in both native and js folder</li><li>It’s not possible to be platform specific for just a few lines of code (e.g. if IS_NATIVE foo else bar), the minimal per-platform unit is a file/module.</li></ul><h3>Example project</h3><p>We have set up a simple library to showcase what a repository looks like once the whole configuration is in place. It is <a href="https://github.com/ahrefs/hello-native-bucklescript">available on github</a>.</p><p>For now the repository contains only a library. But with this setup, it is actually possible to build an executable too. It is also possible to enrich it, for example by adding <a href="https://tech.ahrefs.com/getting-started-with-atdgen-and-bucklescript-1f3a14004081">atdgen to communicate between both sides of the library</a>.</p><img src="https://medium.com/_/stat?event=post.clientViewed&referrerSource=full_rss&postId=22f45e5e946d" width="1" height="1" alt=""><hr><p><a href="https://tech.ahrefs.com/how-to-write-a-library-for-bucklescript-and-native-22f45e5e946d">How to write a library for BuckleScript and Native</a> was originally published in <a href="https://tech.ahrefs.com">ahrefs</a> on Medium, where people are continuing the conversation by highlighting and responding to this story.</p>|js}
  };
 
  { title = {js|One and a half years of ReasonML in production|js}
  ; slug = {js|one-and-a-half-years-of-reasonml-in-production|js}
  ; description = Some {js|The first Reason application at Ahrefs went online on January 31, 2019. Since then, many more applications have been either rewritten in…|js}
  ; url = {js|https://tech.ahrefs.com/one-and-a-half-years-of-reasonml-in-production-2250cf5ba63b?source=rss----303662d88bae--ocaml|js}
  ; date = {js|2020-07-26T15:19:31-00:00|js}
  ; preview_image = Some {js|https://miro.medium.com/max/1200/1*Nl5vYk_k-mC4j32XEjryHQ.jpeg|js}
  ; body_html = {js|<figure><img alt="" src="https://cdn-images-1.medium.com/max/1024/1*Nl5vYk_k-mC4j32XEjryHQ.jpeg" /><figcaption>Photo by <a href="https://unsplash.com/@willianjusten">https://unsplash.com/@willianjusten</a></figcaption></figure><p>The first <a href="https://reasonml.org/">Reason</a> application at <a href="https://ahrefs.com">Ahrefs</a> went online on January 31, 2019. Since then, many more applications have been either rewritten in Reason, are being slowly migrated from React to ReasonReact, or are conceived from the start as Reason projects. It is safe to say that the bet placed on Reason paid off big time. We will never go back to doing pure JavaScript again, with the possible exception of simple backend scripts.</p><p>In the past few years, it’s come to light that there are a number of other <a href="https://www.messenger.com/">large</a> <a href="https://www.onegraph.com/">Reason</a>/<a href="https://darklang.com/">BuckleScript</a> <a href="https://onivim.io/">codebases</a> in the wild, but there still isn’t a ton of information out there about what it’s really like to work with Reason in production. To help remedy that, we thought it would be instructive to ask each of our frontend team members what their Reason journey has been like so far.</p><p>We gave them the following questions as starting points (but they were free to talk about anything they wanted):</p><ul><li>How does Reason compare to other languages you’ve used in the past?</li><li>What’s your favorite thing about Reason?</li><li>What’s your least favorite thing about Reason?</li><li>How does ReasonReact compare to other frameworks you’ve used?</li><li>Was it easy to pick up Reason? Why or why not?</li></ul><h4>Javi</h4><ul><li>How does Reason compare to other languages you’ve used in the past?</li></ul><p>In the past I worked with languages like Java, C, or less known like Pascal or Prolog. But the languages I’ve spent more time with are Objective-C and JavaScript. The main difference between all those languages and Reason is the exhaustiveness that you get from OCaml type checker. This is maybe awkward, but it feels like you stop coding alone and suddenly you have a sidekick always sitting next to you, that is helping you notice the things you forgot about, or found new code that is not consistent with code you or someone else wrote before.</p><p>In a world that is moving towards remote work, where many of us spend hours every day coding physically far from our colleagues, it makes the experience much more delightful. Plus, it allows for teams working on different time zones to keep a healthier work-life balance, because there is less need to have synchronous communication than with more dynamic languages, as more assumptions and design decisions are “embedded” into the code.</p><ul><li>What’s your favorite thing about Reason?</li></ul><p>Can I pick two things? It’s hard to choose only one.</p><p>The first one is the exhaustiveness and quality of the type checker, as mentioned above. Sometimes it takes a bit longer to build a feature than what it would in other languages, until the types are figured out. But this is largely compensated by the confidence one has when shipping code to production, or diving into large refactors.</p><p>The second one is the speed of the BuckleScript build system, which is built on top of <a href="https://ninja-build.org/">ninja</a>. I had never worked with such fast build system. As an example, we have recently started to use remote machines to develop at Ahrefs. In one of these machines that has 72 cores, BuckleScript takes roughly 3 seconds to clean build <em>all</em> our Reason code: application, libs, decoders… everything. Many tens of thousand lines of code! We thought there were something wrong, but we realized the compiler is just So Blazing Fast™️.</p><ul><li>What’s your least favorite thing about Reason?</li></ul><p>I guess we’re going through a necessary stage until things stabilize in the future, but there is a lot of fragmentation at the moment between “Reason native”, which tries to stay closer to OCaml, and “Reason web”, which has a goal to become friendlier for JavaScript developers.</p><p>I am excited to see what <a href="https://reasonml.org/blog/bucklescript-8-1-new-syntax">BuckleScript new syntax</a> will lead to, but I would also love to see a “universal” solution that works for the main use cases out of the box, becoming sort of Rails for Ocaml or Reason. <a href="https://github.com/oxidizing/sihl/">sihl</a> is a project that seems to go in that direction and looks very promising.</p><ul><li>How does ReasonReact compare to other frameworks you’ve used?</li></ul><p>I consider ReasonReact mostly like React + types on top, because the bindings layer is very thin. The thing that I like most about React is that it follows the Unix philosophy: it does one thing and it does it really well. Maybe we have forgotten already today, but having to maintain and mutate UI based on data updates was one of the main sources of bugs in the past. The other nice thing is that there is so much good content about it: blog posts, documentation, etc.</p><ul><li>Was it easy to pick up Reason? Why or why not?</li></ul><p>It took some time, as with any other language. We have things like syntax or semantics much more ingrained into our brains than we think, so there is always some “rewiring” time that is needed to learn a new language, even if Reason makes an effort to stay close to JavaScript syntax. The most challenging part was probably the bindings one, because coming from JavaScript, there are no previous knowledge that one can use as foundation to build upon, it’s all “new knowledge”. glennsl <a href="https://github.com/glennsl/bucklescript-ffi-cheatsheet">BuckleScript ffi cheatsheet</a> was a huge help for me.</p><h4>Ze</h4><p>I really like working with Reason, and have wanted to do so for a while. I was quite happy to see that working with it matched my expectations.</p><p>You get so much support from the type system, and still have a lot of flexibility to represent your domain model. Coming from other languages or paradigms, you don’t feel limited at all in what you can achieve.</p><p>The language has such a strong type system that you feel much more comfortable with your coding.</p><p>The OCaml type system is there to make sure you code with assurance. This is especially true when refactoring code. You can be sure that everything will work fine after it compiles. If it compiles, it works :)</p><p>It’s also very helpful when working on a monorepo. You don’t have to keep reading the source code of everything you use to make sure you don’t have types mistakes. Changes in code in one lib reflect immediately in all the others. This makes the feedback loop much shorter and safer.</p><p>The editors integrations with the type system are quite good and help a lot to write code better and faster.</p><p>Also, compilation times are super fast.</p><p>Last, but not least, ReasonReact is, for me, the hidden gem of ReasonML. The newcomers that have some difficulty with the language should start with it. IMHO, ReasonReact is simpler and has a better developer experience than React itself. It should be the gateway drug frontend developers need to get started with Reason/OCaml 😄</p><h4>Liubomyr</h4><p>To me, all those language features boil down to one essential thing, and it’s the easiness of refactoring. New business requirements popups all the time, and often your initial code assumptions are no longer correct. It was such a pain to modify code in a large JS codebase, as you never know how many things you potentially break in the process. With Reason, it has never been easier. If you need to change your data shape or some component API, you just do it, and from there, the compiler will guide you through all the places you broke, and help to fix those.</p><p>Coming from the JS world, it feels like the initial development is slower, because of the learning curve, missing bindings, less StackOverflow answers, but in the end, you are getting a stable software which is way easier to maintain and add features to.</p><h4>Egor</h4><p>I switched to Reason when I joined Ahrefs team about a year ago, before that I worked mostly with Ruby language.</p><p>The first thing that impressed me in ReasonML was code refactoring. Refactoring in language with a strong type system, like ReasonML and OCaml, is much easier than what I am used to. If your program compiles after your refactoring — most likely you did everything right, if it doesn’t compile — you can immediately see what you forgot to change. This can be achieved in languages with a dynamic type system only with a huge amount of code tests (supporting big test suite is a time consuming process as well as code support).</p><p>The other thing that I really like about ReasonML codebase — how readable it is. When you just enter into ReasonML world — some things can be unfriendly from the first sight, for example, immutable let bindings, but in the end, you realize that these language decisions help you to write cleaner and simpler code.</p><h4>Seif</h4><p>The programming language I used the most in the past is JavaScript. I switched to Reason when I joined Ahrefs a few months ago. From the start, I worked mainly on the code shared by the majority of the tools and I don’t think I would have had the same confidence making changes if I was doing it with JavaScript. I love JavaScript’s developer experience and accessibility. Reason provided me predictability without hurting these very same things I like about JavaScript.</p><h4>Bryan</h4><p>Reason (and OCaml) is, by far, one of the easiest languages to work with. Easy in the sense that the compiler helps eliminate an entire class of errors so you don’t have to worry about them. Additionally, in most other web-centric languages, it’s a pain to add features to existing code that you’ve not touched for a long time. With strong static typing, I can usually add the feature I want in either the backend or frontend, and then let the compiler tell me what needs to be updated.</p><p>Pattern-matching is one of my favourite features in Reason. To me, it makes more sense to be able to explicitly specify conditions that I’m interested in a clear and concise manner, and let the compiler tell me if I missed out a particular condition. Records go hand-in-hand with this. As software programs are made up of data and instructions, records are the perfect data containers. They are quick to define and query, focusing on data rather than behaviour (think classes and instance methods).</p><p>It definitely took a while to pick up Reason mainly because it takes time to become familiar with idiomatic OCaml. But once I crested that learning curve, everything just made sense and all the features of the language that made Reason seemingly difficult to learn — strong typing, the functional paradigm, etc, became assistants that helped me to write better code.</p><h4>Feihong</h4><p><a href="https://reasonml.github.io/reason-react/en/">ReasonReact</a> is a great library for making complex UIs in a large codebase because you get the familiarity of React coupled with the type safety of OCaml. Having two well-established technologies in its foundation is a big advantage that ReasonReact has over other functional UI libraries/frameworks in the transpile-to-JS universe. I didn’t have any professional OCaml experience before joining, yet the ramp up was made much easier by my existing knowledge of React and the (somewhat superficial) similarity of the Reason syntax to JS. Oftentimes it was possible to correctly guess the intent of existing Reason code without knowing all the syntax, because most React concepts carry over pretty directly. And even though the documentation is incomplete and not perfect, it’s quite usable already and among conceptually-similar frameworks is second only to the Elm documentation.</p><p>The compiler errors were difficult to get used to at first. The compiler is fairly good at pointing out the location of the error, but not necessarily as good at explaining the nature or cause of the error. As such, having a REPL would be extremely useful. Actually, OCaml does have its own REPL, but BuckleScript (the compiler used by Reason to translate OCaml to JS) does not at the moment. Nonetheless, the <a href="https://reasonml.github.io/en/try">Try Reason</a> page is a really good tool to try out small snippets of code and is extremely useful while learning the language (we will still occasionally post Try Reason links in our slack channel).</p><h3>Summary</h3><p>The reality is that Ahrefs has always been an OCaml shop, but in the past OCaml was only used to build the backend. Now that we are also using it on the frontend, we get the benefits that our backend colleagues have enjoyed for many years: the expressiveness afforded by pattern matching, the ease of refactoring in large codebases, the stability of a mature programming language, and the confidence of “if it compiles, it works”. To make a shoddy nautical analogy, it is as if we had built a wooden ship powered by a turbo engine. But now the wooden parts are being replaced with steel and plastic, bringing the exterior of the ship up to modern standards as well. As a result, the ship runs faster and more reliably, making the passengers (our users) more satisfied. Also, pirates (bugs) have a harder time hijacking the ship because it’s sturdier and defended by well-disciplined camels. Because the ship keeps getting more and more passengers who want to experience a delightful ride and take pictures with enigmatic camels, we require a constant influx of willing and able boat engineers (who aren’t allergic to camels) to extend and maintain the ship. (Yes, that means that <a href="https://ahrefs.com/jobs">we are hiring</a>️.)</p><p><em>Thanks to Raman and Louis for fact checking this post.</em></p><img src="https://medium.com/_/stat?event=post.clientViewed&referrerSource=full_rss&postId=2250cf5ba63b" width="1" height="1" alt=""><hr><p><a href="https://tech.ahrefs.com/one-and-a-half-years-of-reasonml-in-production-2250cf5ba63b">One and a half years of ReasonML in production</a> was originally published in <a href="https://tech.ahrefs.com">ahrefs</a> on Medium, where people are continuing the conversation by highlighting and responding to this story.</p>|js}
  };
 
  { title = {js|Skylake bug: a detective story|js}
  ; slug = {js|skylake-bug-a-detective-story|js}
  ; description = Some {js|It was a dark and stormy night; the skylake CPU buzzed with excitement, and then, suddenly, the hyperthreads started to lock up..|js}
  ; url = {js|https://tech.ahrefs.com/skylake-bug-a-detective-story-ab1ad2beddcd?source=rss----303662d88bae--ocaml|js}
  ; date = {js|2017-06-28T18:34:51-00:00|js}
  ; preview_image = None
  ; body_html = {js|<blockquote>It was a dark and stormy night; the skylake CPU buzzed with excitement, and then, suddenly, the hyperthreads started to lock up..</blockquote><p>Or something like that.</p><p>This week a new erratum for the Intel Skylake and Kabylake processors families was brought to public attention on <a href="https://lists.debian.org/debian-devel/2017/06/msg00308.html">the Debian mailing list</a>, and then on <a href="https://news.ycombinator.com/item?id=14630183">various</a> <a href="https://www.reddit.com/r/programming/comments/6jfgfp/warning_intel_skylakekaby_lake_processors_broken/">social media</a> and <a href="http://www.theregister.co.uk/2017/06/25/intel_skylake_kaby_lake_hyperthreading/">news outlets</a>.</p><p>We have been investigating this issue since January with the core <a href="http://ocaml.org">OCaml</a> team, as we were struggling with a mysterious bug affecting our developers machines, and ultimately our production system, resulting in a corruption of important data in our databases.</p><p>At <a href="https://ahrefs.com">Ahrefs</a>, we operate a fleet of thousands of servers, running a wide variety of services (huge web crawler among others). At this scale, dealing with unexpected application behaviors is common. While we try to reduce the probability of the software not functioning as expected, bugs are sadly a real part of our everyday life. Even though we can assume the underlying hardware running any infrastructure can be thought of as more reliable and less prone to bugs than software components, issues can still arise in unexpected ways. When the number of servers increases, it is not unusual to observe faults in the hardware preventing the system from functioning as specified.</p><p>It is certainly not frequent to encounter such problems in CPUs but reading through <a href="https://www3.intel.com/content/dam/www/public/us/en/documents/specification-updates/desktop-6th-gen-core-family-spec-update.pdf">the list of errata published by any manufacturer,</a> each CPU model contains a fair amount of bugs. This story is about the bug in the microcode of Skylake processor leading to incorrect code execution under certain conditions. This is certainly scary at first sight: how can we trust our system if we cannot trust its main component ? Yet, like software bugs, processor defects can be identified, contained, and we can take actions to prevent them from impacting the operation of the infrastructure.</p><p>We do not know the full implications of this particular bug, especially security implications in case of untrusted code execution. But we’d like to tell the story of this erratum from our point of view, to provide some context, and show that dealing with it was not much different than dealing with any usual software flaw. While this post aims to cover our own perspective on this adventure, we would like to thank Mark Shinwell, Xavier Leroy, Frédéric Bour, everyone involved in the <a href="https://caml.inria.fr/mantis/view.php?id=7452">Mantis issue</a> and the OCaml IRC channel for their help and time spent investigating with us. Update: Xavier Leroy told his own side of the story in another <a href="http://gallium.inria.fr/blog/intel-skylake-bug/">blog post.</a></p><h3>Setting the scene</h3><p>Our story starts in late 2016 after some of our backend developers received new laptops to work on. After a few days Enguerrand Decorne noticed unusual crashes during compilation of our OCaml codebase.</p><p>This issue, considered mildly annoying at first, seemed to affect only Enguerrand’s machine. For a few days no other machine would exhibit the same behavior, so we figured this was a fault specific to his system configuration.</p><p>However, concerns were subsequently raised after witnessing the generation of invalid machine code and later on, after the deployment of a service on one of our new clusters composed of Skylake Xeon processors, leading to the insertion of corrupted data into our storage system. The priority raised from the annoying level, to potentially critical. Other developers started working together to obtain more information and assess the impact on our infrastructure. Soon after we were able to reproduce the issue on several machines.</p><p>The remainder of this post is a technical description of the steps taken to ensure that our systems were operating safely. It is intended to show that such low level CPU issues is not necessarily fatal — in less than two weeks, with the great help of core OCaml developers, we identified the conditions of the crash and set up a workaround.</p><h3>Tracking down crashes in OCaml</h3><p>Most of our backend code is written in <a href="https://ocaml.org">OCaml</a>, a high level and expressive language supporting functional programming style (among others), which allows us to develop robust systems with ease, thanks to its strong type system and mature legacy.</p><p>The compiler segfaults were definitely a surprise, since this shouldn’t happen for any program written in OCaml, as type system and other features (such as automatic bounds-checking) usually guard us from such errors. However, stack overflows can be possible sources of segfault (when a non-optimal recursion is running too deep), so our first intuition was to increase the stack size when running the compiler. This didn’t change anything, and the reported fault address wasn’t anywhere near the stack address bound.</p><p>Before witnessing the crash on other machines, we suspected a failure in the virtualization software used by our two developers that were able to reproduce the crash, who use VMware as a part of their development workflow. We tried early on to switch to Virtualbox, but the migration proved itself fruitless as the crashes kept appearing. After a short while we began encountering the same issue on physical machines, so we ruled out a possible virtualization software bug.</p><p>The usual debugging process for crashing OCaml code didn’t prove effective — we needed to narrow down our approach.</p><p>OCaml ships with <a href="https://realworldocaml.org/v1/en/html/the-compiler-backend-byte-code-and-native-code.html">two backend implementations</a>: a bytecode interpreter and a native compiler. We were able to reproduce the issue using both a native compiler and a compiler running on the bytecode interpreter. Consequently, this ruled out a miscompilation coming from the code <em>emitted</em> by the compiler, the OCaml runtime <em>itself</em> was misbehaving.</p><p>The runtime code is written in C, and implements low level functionalities, including the garbage collector used by both backends. After rebuilding the runtime with debug symbols, we were able to retrieve a proper stack trace and core dump. The stack trace pointed to the garbage collector’s mark phase. OCaml’s GC is a classic generational mark and sweep collector. The mark phase walks the heap starting from pointers on the stack and other registered root values, and marks every reachable block of memory.</p><p>Further inspection with <strong><em>gdb</em></strong> of the frame and address of crash revealed that the marking code encountered a corrupted block header with invalid size information, causing what looked like a buffer overrun error. Each memory block allocated in OCaml heap begins with a header word, storing metadata used by the GC, including a tag describing the kind of value present in this memory block. The header contains the size of the block, and the crash happened when the mark code was attempting to scan an array which was supposed to be more than 1TB large.</p><p>This was obviously not the cause of the problem but rather the consequence: something corrupted the header word after this block had been properly allocated, postponing the crash until the next GC cycle. It was the right time to escalate <a href="https://caml.inria.fr/mantis/view.php?id=7452">the issue to the OCaml bugtracker</a>, after isolating a proper test case to reproduce the issue.</p><h3>A set of strange leads</h3><p>Escalating the issue to Mantis made us to take a step back and gather our findings, and we quickly got great feedback from the OCaml core team.</p><p>At this point, what does the problem look like?</p><p>We only had sparse information, but <strong><em>dmesg</em></strong> gave us interesting data point. When a page fault occurs and the kernel detects an incorrect memory access, it logs a line in kernel log buffer containing the fault address, the instruction pointer and stack pointer.</p><p>[22985.879907] ocamlopt.opt[48221]: segfault at af8 ip 00005564455169bd sp 00007ffc9f36b130 error 4 in ocamlopt.opt[556445006000+613000]</p><p>Next to the 3 addresses, already available in the coredumps, an error code is reported. This number in decimal form is actually a bitset, and the flags are documented in the Linux kernel sources in <a href="https://github.com/torvalds/linux/blob/v4.11/arch/x86/mm/fault.c#L41">arch/x86/mm/fault.c</a>. Error 4 can thus be read as a read access page fault from user mode, trying to read memory which had not been previously mmap’ed.</p><p>Error codes reported following our crashes involved protection faults or access to unmapped addresses, which corroborated our earlier buffer overrun hypothesis. More interestingly we witnessed a crash with the PF_RSVD flag enabled. This left us puzzled, none of us had ever seen such fault before. Apparently it indicates that the the page table was somehow corrupted, with some entries having non-zero bits reserved by the x86 architecture specification.</p><p>It was scary that the corruption would escape the process address space, and to our limited knowledge, it could only have been caused by kernel issue or potentially hardware issues, like memory errors. Yet we were able to reproduce this on several machines with different kernel version, and different hardware. We blamed virtual machines earlier but this theory was debunked already. We still have no explanation at this time, and pursuit on this front would require intimate knowledge of virtual memory implementations that we didn’t have.</p><p>One developer wasn’t able to reproduce the problem at all on his machine after hours of testing, but something was fishy: it didn’t sound right that an OCaml runtime bug would be able to modify the page table. Maybe it was some corner case with reserved addresses, but this something was beyond our reach here. Out of ideas, it was time to get some assistance from tools intended to track memory corruptions, like <a href="https://github.com/google/sanitizers/wiki/AddressSanitizer">asan and ubsan</a>.</p><p>Running <strong><em>Asan</em></strong> didn’t yield any meaningful results. <strong><em>Valgrind</em></strong> was later tried, following advises from the OCaml team, but every tools were preventing the crash. Quickly reproducing the bug for testing required running code in a loop, keeping the CPU and memory fully busy.</p><p>This was harder to do on developers machines, due to limited resources and other processes running, and Address Sanitizer would only increase the resources usage. Dedicating a powerful server would make further investigations more comfortable, and increase the likeliness of reproducing with instrumented code.</p><p>But with great surprise, it was not possible to reproduce the problem on a server machine, with and without instrumented code. This is when we realised that all the machines exhibiting the crashes were running a processor of the Intel Skylake processors family, while the server and other developer machines had CPUs from the Broadwell family.</p><h3>The hardware, an unusual suspect</h3><p>In the meantime several core OCaml developers had been closely investigating the issue and started auditing recent changes in the runtime, and identified a few suspicious changes and known bugs.</p><p>Certainly they were more qualified for this task, but it acted as an incentive to examine the history of this bug from our angle. At first, we had assumed that the bug was specific to the new laptop with virtual machines. This could not explain why the crash never manifested on older workstations equipped with Skylake processors. Several other developers had been using them for a few months, and only noticed the crash after awareness of the issue had been raised by Enguerrand.</p><p>What had changed, besides Skylake? Only a few week before, an internal migration from OCaml version 4.02.3 to 4.03.0 was rolled out in our codebase. Intrigued, we went ahead and tested OCaml 4.02.3 again, which showed no memory corruptions after several tests. It was time to browse the <a href="https://raw.githubusercontent.com/ocaml/ocaml/trunk/Changes">OCaml changelog</a> for runtime related entries. The search stopped quickly on a promising item in the list: the OCaml C runtime build optimisation level had been increased to -O2 from -O1.</p><p>Could the optimizations dig out an undefined behavior in C code, leading to bad assumptions in the GC code corrupting the heap ? Rebuilding the runtime with -O1did not corrupt memory, so the source of the corruption was in the runtime <em>and</em> was triggered by some gcc specific optimization pass. This sounded like undefined behavior, although the information we had led us to some hardware bug.</p><p>The next day, Xavier Leroy commented on the bugreport reporting that the crash had been observed in the past. Another industrial OCaml user was affected, and they had discovered HyperThreading was part of the necessary conditions. After running the test case for several hours on several machines with HT disabled in the UEFI setup, it was clear we were facing a similar situation. This led to the hypothesis of a hardware bug:</p><blockquote><em>Is it crazy to imagine that gcc -O2 on the OCaml 4.03 runtime produces a specific instruction sequence that causes hardware issues in (some steppings of) Skylake processors with hyperthreading? Perhaps it is crazy.</em></blockquote><p>This possibility had struck us too, motivated by the HyperThreading, the page table corruption and the Skylake specific set of conditions.</p><p>This issue had certainly a strange profile. But nobody was ready to fully embrace the cpu bug hypothesis yet. We convinced ourselves that disabling HT could affect cache pressure and unfold some undefined behaviours.</p><p>HT could also explain the non-determinism, since cache pressure would depend on timings and scheduling. None of us had sufficient experience in this area to assess the strength of such hypothesis, and we did not quite buy it on a single threaded OCaml program. Our debugging motto claims that “assumptions are not facts”.</p><p>It was time to browse Intel errata list and attempt to update the CPU microcode. Although, the errata descriptions are formulated in vague terms, none of the issues disclosed at this time were looking similar to the situation under investigation. Unfortunately, CPUs microcode had no fix waiting for us either. OCaml developers investigated the errata list from their side but the lack of detailed information turned this into a fruitless and complex task.</p><p>In the absence of better alternative, we focused our work on pinpointing the exact source of the crash as if it was a software bug, in the hope of either finding a code issue or ruling out this hypothesis while getting more detailed data. We needed a way to identify the problematic code and find a workaround. From our side, it was not only a matter of finding whether or not there was a bug in OCaml code, but more crucially we needed a guarantee on the quality of our generated code running critical services in production.</p><h3>Identifying the offending code</h3><p>The other OCaml user affected by this issue reported that they had solved the problem by switching to another C compiler. Building the runtime with clang instead of GCC would prevent the GC from crashing. They also suggested to obtain a diff of the generated assembly. Indeed, once built with clang, the runtime would not crash. But clang generates widely different assembly from GCC and we did not have the resources to analyse several hundred thousand lines of changes.</p><p>If we could isolate the problematic C code, comparing the generated code would be easier. The problem had the form of a well known nail:</p><ul><li>Around 50 C files composing the OCaml runtime,</li><li>There is a good state (when built with gcc -O1)</li><li>And a bad state (when built with gcc -O2)</li></ul><p>This nail comes with a precious hammer: bisection.</p><p>The bisection approach had a downside in this occasion. Any state can be labeled bad with certainty as soon as the test crashes, but we would need to wait several hours to be confident enough to trust a non crashing test as good data-point. The reproducibility was not always consistent and a non-crashing state could be a false negative still waiting to trigger the conditions leading to the crash. A reduction of search space was necessary.</p><p>All the coredumps we had showed that the fault was caused by a corrupted heap block header, and our testcase involved the compiler. The OCaml compiler is not 100% deterministic, and IO/s primitives and unix environment in the runtime can affect timings and allocation patterns. But it sounded sensible to assume that the code corrupting a heap header block was also the code reading and writing those blocks: the major GC.</p><p>This hypothesis made bisecting fast: the first file we tried, <strong><em>major_gc.c</em></strong>, turned out to be the one. To make sure it was not a subtle issue in linker, reordering symbols or code blocks, we tried a few others files and confirmed changing the optimization level of some other files alone made no difference.</p><p>But the generated code difference was still way too large. Bringing this topic up on the <a href="http://webchat.freenode.net/?channels=#ocaml">OCaml IRC</a> discussion channel led to some useful inputs. We were taught that gcc supports an attribute to enable specific optimizations at the function level, using __attribute__((optimize(&quot;options,...&quot;))). Following the same strategy, it was easy to trace the source of the malfunctioning code to the <strong><em>sweep_slice</em></strong> function, which implements the sweeping phase of the classic mark and sweep garbage collector for the old generation.</p><p>Ignoring the subtle details of incremental GC, the <strong><em>sweep_slice</em></strong> function is the last pass of a normal major collection cycle. It is responsible for scanning all blocks in the major heap, and reclaiming unreachable blocks to the list of unallocated space.</p><p>The bulk of this function is a switch taking action for each block depending on its status :</p><iframe src="" width="0" height="0" frameborder="0" scrolling="no"><a href="https://medium.com/media/cfbc19fddccc5f2c1a76fcc802fae049/href">https://medium.com/media/cfbc19fddccc5f2c1a76fcc802fae049/href</a></iframe><p>This finding felt consistent with the information at hand. When the block is reachable, the color (describing the reachability status of the block) is reset. If the block became unreachable (<em>while color</em>) - it is reclaimed. In both cases, the block header is modified.</p><p>Getting back to the assembly diff.</p><p>Nobody in the team knows a great deal about assembly and we only have a really basic understanding of most of the instructions used in both versions. It quickly became obvious that the noise level in this diff, with thousands of lines of changed, was still too high for us to spot anything related to the problem. This problem was getting far beyond the common knowledge of everyone in the team.</p><p>But this was still sounding like your day to day bug tracking process. The less you know, the more careful you need to be, tackling the problem step by step. We stuck to what approach had served us well until now: bisecting.</p><p>We went through the list of optimisation passes enabled by GCC at -O2. This is a fair amount of optimisation passes and it would have been too time consuming to try them one by one, given the time needed to trigger the crash. Yet we had a hint: a memory corruption was happening semi randomly in the garbage collector. We were also keeping the undefined behaviour bug as a potential explanation. It was likely a pass which would change the structure of the code, reordering blocks and changing conditions.</p><p>After reading the description of all switches in the detailed gcc manual, the -ftree-* pass family looked promising. This set of transformations works on the <a href="https://en.wikipedia.org/wiki/Static_single_assignment_form">SSA form</a> internal representation, a widespread intermediate language representation which has the benefit of being easy to read. They seem to make a huge impact on the generated assembly code, moving code blocks around and making assumptions on code invariants in order to move around, simplify or eliminate conditional checks altogether.</p><p>By looking at output of those passes on the related source code, we narrowed down the list of transformations to a couple of interesting passes, one of them being -ftree-vrp, which stands for Value Range Propagation. This pass computes bounds for each name binding and propagates proofs that a value must lie in a given range.</p><p>It turned out most of the other passes depended on it for further optimisations. Even though the issue ended up not being a bad assumptions in the range values, checking this pass proved to be worthwhile: enabling -ftree-vrp on <strong><em>sweep_slice</em></strong> function while every thing else was built with -O1 was enough to trigger a crash.</p><p>GCC provides very good diagnostics output, and after reading the manual we found the -fdump-tree-* switch to dump the SSA form before and after specific pass. The output is designed to be read by a human and provides meaningful naming, with source code locations, alongside the ranges propagated by the VRP pass. We spent some time studying the output and matched the difference in SSA tree between the crashing and not crashing code.</p><p>Examining the bounds and invariants derived by gcc, it was clear that no wrong hypothesis was stated.</p><iframe src="" width="0" height="0" frameborder="0" scrolling="no"><a href="https://medium.com/media/a5a311d0b5a4f890f9541f0aed91e73e/href">https://medium.com/media/a5a311d0b5a4f890f9541f0aed91e73e/href</a></iframe><p>The only meaningful observable change involves the suppression of rechecking the loop condition in the else branch of the <strong><em>sweep_slice</em></strong> function, after Value Range Propagation proved that the condition was invariant in this branch.</p><p>Often, reading the code carefully is the fastest way to find a bug. But after spending hours staring at the major GC code, it was clear enough that this check removal should not cause any semantic changes.</p><p>In this process, we identified a suspicious bit of code, where a signed long variable was promoted to unsigned according to C standard rules, which was changing the bounds derived by gcc, assuming it was always positive. But after some thinking we realised it made no difference at assembly level and although wrong, this assumption was not used anywhere.</p><p>We were now ready to rule out the possibility of a bug in OCaml runtime. It was still possible that GCC backend had a bug and was miscompiling this particular shape of code. And we were back at the assembly level again. After writing some awk formatting script to cleanup assembly and minimise noise in the diff (by renaming labels, detecting spurious code move, etc), and preventing inlining, we found a minimal assembly patch causing the crash.</p><p>There were only cosmetic differences. The test removal was propagated down to assembly and caused gcc to reorganise the layout of each switch case block.</p><iframe src="" width="0" height="0" frameborder="0" scrolling="no"><a href="https://medium.com/media/532ab4896b11177a96203fd0c81eaa58/href">https://medium.com/media/532ab4896b11177a96203fd0c81eaa58/href</a></iframe><p>Among those minor differences and changes of layout, we noticed a particular change which impacted exactly the reachable block header updated which could have caused header corruption. In the unoptimised version, the updating code looked like this:</p><iframe src="" width="0" height="0" frameborder="0" scrolling="no"><a href="https://medium.com/media/38ca30a1decf86233084721c3803b1c4/href">https://medium.com/media/38ca30a1decf86233084721c3803b1c4/href</a></iframe><p>For some reason, the block pointer was spilled to the stack.</p><p>Perhaps naively, and because we had earlier emitted the hypothesis of HT impacting cache pressure, we spent a few hours staring at this code and check if we were missing something subtle which could affect the control flow of the whole function and the stack location from which it was reloaded could be corrupted.</p><p>Despite our lack of assembly knowledge, after spending several hours reading this tiny change, we got convinced that it made strictly no semantic difference. Reading the x86 manual carefully didn’t give any hint on any subtle behavior which would trigger. Executing any of those two sequence of instruction should give the exact same output.</p><h3>Mitigating the issue</h3><p>We were now quite certain it was a CPU bug.</p><p>The OCaml developers had reached the same conclusion, and were working on escalating the issue to Intel. After internal discussions we decided to keep this bug as low profile as possible since we were unsure about potential security implications, especially for JIT implementations.</p><p>Even if we had no confirmation at this point nor any explanations of the cause of this bug, which was beyond our reach, we could take actions.</p><p>The first step was to decide against getting any new Skylake based servers until further announcement. We were left with several Skylake machines but we refrained from deploying any OCaml code on them. OCaml comes with a great package manager, <a href="https://opam.ocaml.org/">opam</a>, which supports compiler switches. Switches allow to set up a clean and distinct environment with specific packages and compiler configuration.</p><p>We patched our internal opam repository to distribute unoptimised runtime to all developers and moved forward, waiting for further announcements.</p><p>This situation made us realise that microcode requires constant updates, just like any other software in the stack. We raised awareness on this topic in our devops team, and they took measure to ensure we could roll out updates to prod easily.</p><h3>Happy end</h3><p>In late May, devops team noticed a <a href="http://metadata.ftp-master.debian.org/changelogs/non-free/i/intel-microcode/intel-microcode_3.20170511.1_changelog">debian package update for intel-microcode</a> containing the following change:</p><pre>Likely fix nightmare-level Skylake erratum SKL150. Fortunately,<br>either this erratum is very-low-hitting, or gcc/clang/icc/msvc<br>won’t usually issue the affected opcode pattern and it ends up<br>being rare.<br>SKL150 — Short loops using both the AH/BH/CH/DH registers and<br>the corresponding wide register *may* result in unpredictable<br>system behavior. Requires both logical processors of the same<br>core (i.e. sibling hyperthreads) to be active to trigger, as<br>well as a “complex set of micro-architectural conditions”</pre><p>The erratum description immediately rang a bell as it matched the diff in the assembly we had observed. We tested the microcode update and confirmed it fixed the corruption.</p><p>Finally, our Skylake CPUs were feeling safe and OCaml compiler was happy.</p><p><a href="https://ahrefs.com"><em>Ahrefs</em></a><em> runs an internet-scale bot that crawls the whole Web 24/7. Our backend system is powered by a custom petabyte-scale distributed key-value storage implemented in OCaml (and some C++ and Rust). We are a small team and strongly believe in better technology leading to better solutions for real-world problems. We worship functional languages and static typing, extensively employ code generation and meta-programming, value code clarity and predictability, and are constantly seeking to automate repetitive tasks and eliminate boilerplate. And we are </em><a href="https://ahrefs.com/jobs"><em>hiring</em></a><em>!</em></p><img src="https://medium.com/_/stat?event=post.clientViewed&referrerSource=full_rss&postId=ab1ad2beddcd" width="1" height="1" alt=""><hr><p><a href="https://tech.ahrefs.com/skylake-bug-a-detective-story-ab1ad2beddcd">Skylake bug: a detective story</a> was originally published in <a href="https://tech.ahrefs.com">ahrefs</a> on Medium, where people are continuing the conversation by highlighting and responding to this story.</p>|js}
  };
 
  { title = {js|13 Virtues|js}
  ; slug = {js|13-virtues|js}
  ; description = Some {js|Very early on in his life, while on lengthy voyage from London to Philadelphia,Ben Franklin created a system of thirteen virtues to live his life by. He spen...|js}
  ; url = {js|https://blog.janestreet.com/13-virtues/|js}
  ; date = {js|2015-01-02T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p>Very early on in his life, while on lengthy voyage from London to Philadelphia,
Ben Franklin created a system of thirteen virtues to live his life by. He spent
the remainder of his days giving special focus to one virtue per week in a 13
week cycle, as well as noting the virtues he failed to live up to at the end of
each day.</p>|js}
  };
 
  { title = {js|A better inliner for OCaml, and why it matters|js}
  ; slug = {js|a-better-inliner-for-ocaml-and-why-it-matters|js}
  ; description = Some {js|OCaml 4.03 is branched and a first release candidate is imminent, so it seemslike a good time to take stock of what’s coming.|js}
  ; url = {js|https://blog.janestreet.com/flambda/|js}
  ; date = {js|2016-02-24T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p>OCaml 4.03 is branched and a first release candidate is imminent, so it seems
like a good time to take stock of what’s coming.</p>|js}
  };
 
  { title = {js|A brief trip through Spacetime|js}
  ; slug = {js|a-brief-trip-through-spacetime|js}
  ; description = Some {js|Spacetime is a new memory profiling facility for OCaml to help find space leaksand unwanted allocations. Whilst still a little rough around the edges, we’vef...|js}
  ; url = {js|https://blog.janestreet.com/a-brief-trip-through-spacetime/|js}
  ; date = {js|2017-01-09T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/a-brief-trip-through-spacetime/spacetime.jpg|js}
  ; body_html = {js|<p>Spacetime is a new memory profiling facility for OCaml to help find space leaks
and unwanted allocations. Whilst still a little rough around the edges, we’ve
found it to be a very useful tool. Since there’s not much documentation for
using spacetime beyond <a href="https://github.com/lpw25/prof_spacetime/blob/master/Readme.md">this
readme</a>, I’ve
written a little intro to give people an idea of how to use it.</p>|js}
  };
 
  { title = {js|A lighter Core|js}
  ; slug = {js|a-lighter-core|js}
  ; description = Some {js|We recently released a version of our open source libraries with a muchanticipatedchange– Async_kernel, the heart of the Async concurrent programming library...|js}
  ; url = {js|https://blog.janestreet.com/a-lighter-core/|js}
  ; date = {js|2015-03-21T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p>We recently released a version of our open source libraries with a much
anticipated
<a href="https://github.com/janestreet/async_kernel/commit/bf11c4211595b2589b6517aefafceb2ad3bdc0fd">change</a>
– Async_kernel, the heart of the Async concurrent programming library, now
depends only on Core_kernel rather than on Core.</p>|js}
  };
 
  { title = {js|A look at OCaml 4.08|js}
  ; slug = {js|a-look-at-ocaml-408|js}
  ; description = Some {js|Now that OCaml 4.08 has been released, let’s have a look at what wasaccomplished, with a particular focus on how our plans for4.08 fared. I’ll mostly focus o...|js}
  ; url = {js|https://blog.janestreet.com/a-look-at-ocaml-4.08/|js}
  ; date = {js|2019-07-12T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/a-look-at-ocaml-4.08/ocaml_release-2019.jpg|js}
  ; body_html = {js|<p>Now that OCaml 4.08 has been released, let’s have a look at what was
accomplished, with a particular focus on how <a href="../plans-for-ocaml-408/">our plans for
4.08</a> fared. I’ll mostly focus on work that we
in the Jane Street Tools &amp; Compilers team were involved with, but we are
just some of the contributors to the OCaml compiler, and I’ll have a
quick look at the end of the post at some of the other work that went
into 4.08.</p>|js}
  };
 
  { title = {js|A solution to the ppx versioning problem|js}
  ; slug = {js|a-solution-to-the-ppx-versioning-problem|js}
  ; description = Some {js|Ppx is a preprocessing system for OCaml where one maps over the OCaml abstractsyntax tree (AST) to interpret some special syntax fragments to generate code.|js}
  ; url = {js|https://blog.janestreet.com/an-solution-to-the-ppx-versioning-problem/|js}
  ; date = {js|2016-11-08T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p>Ppx is a preprocessing system for OCaml where one maps over the OCaml abstract
syntax tree (AST) to interpret some special syntax fragments to generate code.</p>|js}
  };
 
  { title = {js|A tutorial for building web applications with Incr_dom|js}
  ; slug = {js|a-tutorial-for-building-web-applications-with-incrdom|js}
  ; description = Some {js|At Jane Street, our web UIs are built on top of an in-house frameworkcalled Incr_dom, modeled inpart on React’s virtualDOM. Rendering differentviews efficien...|js}
  ; url = {js|https://blog.janestreet.com/a-tutorial-for-building-web-applications-with-incrdom/|js}
  ; date = {js|2019-01-15T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/a-tutorial-for-building-web-applications-with-incrdom/incr_dom.png|js}
  ; body_html = {js|<p>At Jane Street, our web UIs are built on top of an in-house framework
called <a href="https://github.com/janestreet/incr_dom">Incr_dom</a>, modeled in
part on <a href="https://reactjs.org/docs/faq-internals.html">React’s virtual
DOM</a>. Rendering different
views efficiently in response to changes made to a shared model is a
quintessentially incremental computation—so it should be no surprise
that Incr_dom is built on top of
<a href="https://blog.janestreet.com/introducing-incremental/">Incremental</a>.</p>|js}
  };
 
  { title = {js|Accelerating Self-Play Learning in Go|js}
  ; slug = {js|accelerating-self-play-learning-in-go|js}
  ; description = Some {js|At Jane Street, over the last few years, we’ve been increasingly exploring machine learning to improve our models. Many of us are fascinated by the rapid imp...|js}
  ; url = {js|https://blog.janestreet.com/accelerating-self-play-learning-in-go/|js}
  ; date = {js|2019-02-28T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/accelerating-self-play-learning-in-go/go.jpg|js}
  ; body_html = {js|<p>At Jane Street, over the last few years, we’ve been increasingly exploring machine learning to improve our models. Many of us are fascinated by the rapid improvement we see in a wide variety of applications due to developments in deep learning and reinforcement learning, both for its exciting potential for our own problems, and also on a personal level of pure interest and curiosity outside of work.</p>|js}
  };
 
  { title = {js|Announcing Our Market Prediction Kaggle Competition|js}
  ; slug = {js|announcing-our-market-prediction-kaggle-competition|js}
  ; description = Some {js|Jane Street is running a Kaggle contest based on a real problem withreal financial data. If you like ML projects, or think you might,head over and check itou...|js}
  ; url = {js|https://blog.janestreet.com/announcing-our-market-prediction-kaggle-competition-index/|js}
  ; date = {js|2020-11-24T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/announcing-our-market-prediction-kaggle-competition-index/kaggle_blogpost.jpg|js}
  ; body_html = {js|<p>Jane Street is running a Kaggle contest based on a real problem with
real financial data. If you like ML projects, or think you might,
<a href="https://www.kaggle.com/c/jane-street-market-prediction" target="_blank">head over and check it
out</a>.
We think it’s a pretty fun one. The prizes are pretty good too, with a
total $100K being paid out.</p>|js}
  };
 
  { title = {js|Announcing Signals and Threads, a new podcast from Jane Street|js}
  ; slug = {js|announcing-signals-and-threads-a-new-podcast-from-jane-street|js}
  ; description = Some {js|I’m excited (and slightly terrified) to announce that Jane Street isreleasing a new podcast, called Signals andThreads, and I’m going to be thehost.|js}
  ; url = {js|https://blog.janestreet.com/announcing-signals-and-threads-index/|js}
  ; date = {js|2020-08-31T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/announcing-signals-and-threads-index/./signals-and-threads.png|js}
  ; body_html = {js|<p>I’m excited (and slightly terrified) to announce that Jane Street is
releasing a new podcast, called <a href="https://signalsandthreads.com/">Signals and
Threads</a>, and I’m going to be the
host.</p>|js}
  };
 
  { title = {js|Building a lower-latency GC|js}
  ; slug = {js|building-a-lower-latency-gc|js}
  ; description = Some {js|We’ve been doing a bunch of work recently on improving the responsiveness ofOCaml’s garbage collector. I thought it would be worth discussing thesedevelopmen...|js}
  ; url = {js|https://blog.janestreet.com/building-a-lower-latency-gc/|js}
  ; date = {js|2015-04-10T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p>We’ve been doing a bunch of work recently on improving the responsiveness of
OCaml’s garbage collector. I thought it would be worth discussing these
developments publicly to see if there was any useful feedback to be had on the
ideas that we’re investigating.</p>|js}
  };
 
  { title = {js|Centralizing distributed version control, revisited|js}
  ; slug = {js|centralizing-distributed-version-control-revisited|js}
  ; description = Some {js|7 years ago, I wrote a blogpostabout how we at Jane Street were using our distributed version control system(hg, though the story would be the same for git) ...|js}
  ; url = {js|https://blog.janestreet.com/centralizing-distributed-version-control-revisited/|js}
  ; date = {js|2015-03-04T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p>7 years ago, I wrote a <a href="/centralizing-distributed-version-control/" title="Centralizing Distributed Version Control">blog
post</a>
about how we at Jane Street were using our distributed version control system
(<code class="highlighter-rouge">hg</code>, though the story would be the same for <code class="highlighter-rouge">git</code>) in a partially centralized
way. Essentially, we built a centralized repo and a continuous integration
system whose job was to merge in new changesets. The key responsibility of this
system was to make sure that a change was rejected unless it merged, compiled
and <a href="http://graydon2.dreamwidth.org/1597.html" title="The Not Rocket Science Rule">tested
cleanly</a>.</p>|js}
  };
 
  { title = {js|Chrome extensions: Finding the missing proof|js}
  ; slug = {js|chrome-extensions-finding-the-missing-proof|js}
  ; description = Some {js|Web browsers have supported customplug-ins andextensions sincethe 1990s, giving users the ability to add their own features andtools for improving workflow o...|js}
  ; url = {js|https://blog.janestreet.com/chrome-extensions-finding-the-missing-proof/|js}
  ; date = {js|2020-04-17T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/chrome-extensions-finding-the-missing-proof/magnifying-glass.png|js}
  ; body_html = {js|<p>Web browsers have supported custom
<a href="https://en.wikipedia.org/wiki/NPAPI">plug-ins</a> and
<a href="https://en.wikipedia.org/wiki/Browser_extension">extensions</a> since
the 1990s, giving users the ability to add their own features and
tools for improving workflow or building closer integration with
applications or databases running on back-end servers.</p>|js}
  };
 
  { title = {js|Clearly Failing|js}
  ; slug = {js|clearly-failing|js}
  ; description = Some {js|The Parable Of The Perfect Connection|js}
  ; url = {js|https://blog.janestreet.com/clearly-failing/|js}
  ; date = {js|2014-08-23T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<h1 id="the-parable-of-the-perfect-connection">The Parable Of The Perfect Connection</h1>|js}
  };
 
  { title = {js|Code review that isn't boring|js}
  ; slug = {js|code-review-that-isnt-boring|js}
  ; description = Some {js|At Jane Street, we care a lot about code review. We think that high qualitycode, and in particular, readable code, helps us maintain the safety of oursystems...|js}
  ; url = {js|https://blog.janestreet.com/code-review-that-isnt-boring/|js}
  ; date = {js|2014-06-12T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p>At Jane Street, we care a lot about code review. We think that high quality
code, and in particular, readable code, helps us maintain the safety of our
systems and keeps things simple and clean enough for us to stay nimble.</p>|js}
  };
 
  { title = {js|Commas in big numbers everywhere: An OpenType adventure|js}
  ; slug = {js|commas-in-big-numbers-everywhere-an-opentype-adventure|js}
  ; description = Some {js|My job involves a lot of staring at large numbers, mostly latencies innanoseconds, and picking out magnitudes like microseconds. I noticedmyself constantly c...|js}
  ; url = {js|https://blog.janestreet.com/commas-in-big-numbers-everywhere/|js}
  ; date = {js|2019-10-14T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/commas-in-big-numbers-everywhere/numderline_header2.png|js}
  ; body_html = {js|<p>My job involves a lot of staring at large numbers, mostly latencies in
nanoseconds, and picking out magnitudes like microseconds. I noticed
myself constantly counting digits in my text editor, in my terminal,
and in <a href="https://jupyter.org/">Jupyter</a> notebooks in my browser.</p>|js}
  };
 
  { title = {js|Converting a code base from camlp4 to ppx|js}
  ; slug = {js|converting-a-code-base-from-camlp4-to-ppx|js}
  ; description = Some {js|As with many projects in the OCaml world, at Jane Street we have been working onmigrating from camlp4 to ppx. After having developed equivalent ppx rewriters...|js}
  ; url = {js|https://blog.janestreet.com/converting-a-code-base-from-camlp4-to-ppx/|js}
  ; date = {js|2015-07-08T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p>As with many projects in the OCaml world, at Jane Street we have been working on
migrating from camlp4 to ppx. After having developed equivalent ppx rewriters
for our camlp4 syntax extensions, the last step is to actually translate the
code source of all our libraries and applications from the camlp4 syntax to the
standard OCaml syntax with extension points and attributes.</p>|js}
  };
 
  { title = {js|CPU Registers and OCaml|js}
  ; slug = {js|cpu-registers-and-ocaml|js}
  ; description = Some {js|Even though registers are a low-level CPU concept, having some knowledge aboutthem can help write faster code. Simply put, a CPU register is a storage for as...|js}
  ; url = {js|https://blog.janestreet.com/cpu-registers-and-ocaml-2/|js}
  ; date = {js|2015-05-05T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p>Even though registers are a low-level CPU concept, having some knowledge about
them can help write faster code. Simply put, a CPU register is a storage for a
single variable. CPU can keep data in memory or cache or in registers and
registers are often much faster. Furthermore, some operations are possible only
when the data is in registers. Hence, the OCaml compiler tries to keep as many
variables as it can in the registers.</p>|js}
  };
 
  { title = {js|Deep learning experiments in OCaml|js}
  ; slug = {js|deep-learning-experiments-in-ocaml|js}
  ; description = Some {js|Last year we held a machine learning seminar in our London office,which was an opportunity to reproduce some classical deep learningresults with a nice twist...|js}
  ; url = {js|https://blog.janestreet.com/deep-learning-experiments-in-ocaml/|js}
  ; date = {js|2018-09-20T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/deep-learning-experiments-in-ocaml/camel.jpg|js}
  ; body_html = {js|<p>Last year we held a machine learning seminar in our London office,
which was an opportunity to reproduce some classical deep learning
results with a nice twist: we used OCaml as a programming language
rather than Python. This allowed us to train models defined in a
functional way in OCaml on a GPU using TensorFlow.</p>|js}
  };
 
  { title = {js|Deep-Learning the Hardest Go Problem in the World|js}
  ; slug = {js|deep-learning-the-hardest-go-problem-in-the-world|js}
  ; description = Some {js|Updates and a New Run|js}
  ; url = {js|https://blog.janestreet.com/deep-learning-the-hardest-go-problem-in-the-world/|js}
  ; date = {js|2019-12-06T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/deep-learning-the-hardest-go-problem-in-the-world/goproblem.png|js}
  ; body_html = {js|<h2 id="updates-and-a-new-run">Updates and a New Run</h2>|js}
  };
 
  { title = {js|Do applied programming languages research at Jane Street!|js}
  ; slug = {js|do-applied-programming-languages-research-at-jane-street|js}
  ; description = Some {js|As our Tools & Compilers team has grown, the kinds of projects we workon has become more ambitious. Here are some of the major things we’recurrently work...|js}
  ; url = {js|https://blog.janestreet.com/applied-PL-research/|js}
  ; date = {js|2019-08-16T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/applied-PL-research/compiler3d.jpg|js}
  ; body_html = {js|<p>As our Tools &amp; Compilers team has grown, the kinds of projects we work
on has become more ambitious. Here are some of the major things we’re
currently working on:</p>|js}
  };
 
  { title = {js|Do you love dev tools? Come work at Jane Street.|js}
  ; slug = {js|do-you-love-dev-tools-come-work-at-jane-street|js}
  ; description = Some {js|In the last few years, we’ve spent more and more effort working on developertools, to the point where we now have a tools-and-compilers group devoted to thea...|js}
  ; url = {js|https://blog.janestreet.com/do-you-love-dev-tools-come-work-at-jane-street/|js}
  ; date = {js|2016-08-30T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p>In the last few years, we’ve spent more and more effort working on developer
tools, to the point where we now have a tools-and-compilers group devoted to the
area, for which we’re actively hiring.</p>|js}
  };
 
  { title = {js|Does batch size matter?|js}
  ; slug = {js|does-batch-size-matter|js}
  ; description = Some {js|This post is aimed at readers who are already familiar withstochastic gradient descent(SGD) and terms like “batch size”.  For an introduction to theseideas, ...|js}
  ; url = {js|https://blog.janestreet.com/does-batch-size-matter/|js}
  ; date = {js|2017-10-31T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/does-batch-size-matter/batch-01.png|js}
  ; body_html = {js|<p><i>This post is aimed at readers who are already familiar with
<a href="https://en.wikipedia.org/wiki/Stochastic_gradient_descent">stochastic gradient descent</a>
(SGD) and terms like “batch size”.  For an introduction to these
ideas, I recommend Goodfellow et al.’s
<a href="http://www.deeplearningbook.org/">Deep Learning</a>, in particular the
introduction and, for more about SGD, Chapter 8.  The relevance of SGD
is that it has made it feasible to work with much more complex models
than was formerly possible.</i></p>|js}
  };
 
  { title = {js|Faster OCaml to C calls|js}
  ; slug = {js|faster-ocaml-to-c-calls|js}
  ; description = Some {js|The official OCaml documentation “Interfacing C withOCaml” doesn’tdocument some interesting performance features.|js}
  ; url = {js|https://blog.janestreet.com/faster-ocaml-to-c-calls/|js}
  ; date = {js|2015-04-09T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p>The official OCaml documentation <a href="http://caml.inria.fr/pub/docs/manual-ocaml-4.01/intfc.html">“Interfacing C with
OCaml”</a> doesn’t
document some interesting performance features.</p>|js}
  };
 
  { title = {js|Finding memory leaks with Memtrace|js}
  ; slug = {js|finding-memory-leaks-with-memtrace|js}
  ; description = Some {js|Memory issues can be hard to track down. A function that onlyallocates a few small objects can cause a space leak if it’s calledoften enough and those object...|js}
  ; url = {js|https://blog.janestreet.com/finding-memory-leaks-with-memtrace/|js}
  ; date = {js|2020-10-06T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/finding-memory-leaks-with-memtrace/memory-leak.jpg|js}
  ; body_html = {js|<p>Memory issues can be hard to track down. A function that only
allocates a few small objects can cause a space leak if it’s called
often enough and those objects are never collected. Even then, many
objects are <em>supposed</em> to be long-lived. How can a tool, armed with data
on allocations and their lifetimes,
help sort out the expected from the suspicious?</p>|js}
  };
 
  { title = {js|Growing the Hardcaml toolset|js}
  ; slug = {js|growing-the-hardcaml-toolset|js}
  ; description = Some {js|I am pleased to announce that we have recently released a slew of newHardcaml libraries!|js}
  ; url = {js|https://blog.janestreet.com/growing-the-hardcaml-toolset-index/|js}
  ; date = {js|2020-12-01T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/growing-the-hardcaml-toolset-index/Hardcaml_blog_image_scaled.png|js}
  ; body_html = {js|<p>I am pleased to announce that we have recently released a slew of new
Hardcaml libraries!</p>|js}
  };
 
  { title = {js|Hiring an FPGA engineer|js}
  ; slug = {js|hiring-an-fpga-engineer|js}
  ; description = Some {js|Jane Street is looking to hire an engineer with experience in bothsoftware and hardware design to work on FPGA-based applications, andon tools for creating s...|js}
  ; url = {js|https://blog.janestreet.com/hiring-an-fpga-engineer/|js}
  ; date = {js|2017-08-16T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/hiring-an-fpga-engineer/fpga_hiring.jpg|js}
  ; body_html = {js|<p>Jane Street is looking to hire an engineer with experience in both
software and hardware design to work on FPGA-based applications, and
on tools for creating such applications.</p>|js}
  };
 
  { title = {js|How Jane Street Does Code Review (Jane Street Tech Talk)|js}
  ; slug = {js|how-jane-street-does-code-review-jane-street-tech-talk|js}
  ; description = Some {js|It’s time for our nextJane Street Tech Talk. Whenwe’ve solicited suggestions for topics, one common request has been totalk about our internal development pr...|js}
  ; url = {js|https://blog.janestreet.com/jane-street-tech-talk-how-jane-street-does-code-review/|js}
  ; date = {js|2017-10-29T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/jane-street-tech-talk-how-jane-street-does-code-review/image.png|js}
  ; body_html = {js|<p>It’s time for our next
<a href="https://www.janestreet.com/tech-talks/">Jane Street Tech Talk</a>. When
we’ve solicited suggestions for topics, one common request has been to
talk about our internal development process. Our next talk,
<a href="https://www.janestreet.com/tech-talks/code-review/">How Jane Street Does Code Review</a>,
should fit the bill. The talk is being given by our own Ian Henry, and
discusses how we approach code review, and in particular how Iron, the
code review system we’ve been using and improving for some years now,
fits in to that process.</p>|js}
  };
 
  { title = {js|How to Build an Exchange|js}
  ; slug = {js|how-to-build-an-exchange|js}
  ; description = Some {js|UPDATE: We are full up. Tons of people signed up for the talk, and we’renow at the limit of what we feel like we can support in the space. Thanks forall the ...|js}
  ; url = {js|https://blog.janestreet.com/how-to-build-an-exchange/|js}
  ; date = {js|2017-01-11T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/how-to-build-an-exchange/build_exchange.jpg|js}
  ; body_html = {js|<p><strong>UPDATE</strong>: <em>We are full up. Tons of people signed up for the talk, and we’re
now at the limit of what we feel like we can support in the space. Thanks for
all the interest, and if you didn’t get into this one, don’t worry, we have more
talks coming!</em></p>|js}
  };
 
  { title = {js|How to choose a teaching language|js}
  ; slug = {js|how-to-choose-a-teaching-language|js}
  ; description = Some {js|If you were teaching a programming course, what language would you teach it in?|js}
  ; url = {js|https://blog.janestreet.com/how-to-choose-a-teaching-language/|js}
  ; date = {js|2014-11-17T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p>If you were teaching a programming course, what language would you teach it in?</p>|js}
  };
 
  { title = {js|How to design a tree diffing algorithm|js}
  ; slug = {js|how-to-design-a-tree-diffing-algorithm|js}
  ; description = Some {js|For those of you interested in whatwhatinternsdo at Jane Street, here’s apost from former internTristan Hume, on his work developing tree-diffing algorithms ...|js}
  ; url = {js|https://blog.janestreet.com/how-to-design-a-tree-diffing-algorithm/|js}
  ; date = {js|2017-08-25T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p>For those of you interested in what
<a href="/what-the-interns-have-wrought-rpc_parallel-and-core_profiler">what</a>
<a href="/what-the-interns-have-wrought-2016">interns</a>
<a href="/what-the-interns-have-wrought-2017">do</a> at Jane Street, here’s a
<a href="http://thume.ca/2017/06/17/tree-diffing/">post</a> from former intern
Tristan Hume, on his work developing tree-diffing algorithms last
summer at Jane Street. It’s a fun (and very detailed!) read.</p>|js}
  };
 
  { title = {js|How to shuffle a big dataset|js}
  ; slug = {js|how-to-shuffle-a-big-dataset|js}
  ; description = Some {js|At Jane Street, we often work with data that has a very lowsignal-to-noise ratio, but fortunately we also have a lot of data.Where practitioners in many fiel...|js}
  ; url = {js|https://blog.janestreet.com/how-to-shuffle-a-big-dataset/|js}
  ; date = {js|2018-09-26T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/how-to-shuffle-a-big-dataset/shuffle_zoom.png|js}
  ; body_html = {js|<p>At Jane Street, we often work with data that has a very low
signal-to-noise ratio, but fortunately we also have a <em>lot</em> of data.
Where practitioners in many fields might be accustomed to
having tens or hundreds of thousands of correctly labeled
examples, some of our problems are more like having a billion training
examples whose labels have only a slight tendency to be correct.
These large datasets present a number of interesting engineering
challenges.  The one we address here: <em>How do you shuffle a really
large dataset?</em>  (If you’re not familiar with why one might need this,
jump to the section <a href="#whyshuffle">Why shuffle</a> below.)</p>|js}
  };
 
  { title = {js|Incremental computation and the web|js}
  ; slug = {js|incremental-computation-and-the-web|js}
  ; description = Some {js|I’ve recently been thinking about the world of JavaScript and web applications.That’s odd for me, since I know almost nothing about the web. Indeed, JaneStre...|js}
  ; url = {js|https://blog.janestreet.com/incrementality-and-the-web/|js}
  ; date = {js|2016-01-30T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p>I’ve recently been thinking about the world of JavaScript and web applications.
That’s odd for me, since I know almost nothing about the web. Indeed, Jane
Street’s use of web technologies is quite minimal – nearly all of our user
interfaces are text based, and all told we’ve been pretty happy with that.</p>|js}
  };
 
  { title = {js|Inspecting Internal TCP State on Linux|js}
  ; slug = {js|inspecting-internal-tcp-state-on-linux|js}
  ; description = Some {js|Sometimes it can be useful to inspect the state of a TCP endpoint. Things suchas the current congestion window, the retransmission timeout (RTO), duplicateac...|js}
  ; url = {js|https://blog.janestreet.com/inspecting-internal-tcp-state-on-linux/|js}
  ; date = {js|2014-07-09T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p>Sometimes it can be useful to inspect the state of a TCP endpoint. Things such
as the current congestion window, the retransmission timeout (RTO), duplicate
ack threshold, etc. are not reflected in the segments that flow over the wire.
Therefore, just looking at packet captures can leave you scratching your head as
to why a TCP connection is behaving a certain way.</p>|js}
  };
 
  { title = {js|Inspecting the Environment of a Running Process|js}
  ; slug = {js|inspecting-the-environment-of-a-running-process|js}
  ; description = Some {js|Sometimes its useful to be able see the values of environment variables inrunning processes. We can use the following test program to see how well we canacco...|js}
  ; url = {js|https://blog.janestreet.com/inspecting-the-environment-of-a-running-process/|js}
  ; date = {js|2014-12-01T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p>Sometimes its useful to be able see the values of environment variables in
running processes. We can use the following test program to see how well we can
accomplish this:</p>|js}
  };
 
  { title = {js|Interviewing At Jane Street|js}
  ; slug = {js|interviewing-at-jane-street|js}
  ; description = Some {js|Software Engineering Interviews at Jane Street|js}
  ; url = {js|https://blog.janestreet.com/interviewing-at-jane-street/|js}
  ; date = {js|2014-10-24T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<h1 id="software-engineering-interviews-at-jane-street">Software Engineering Interviews at Jane Street</h1>|js}
  };
 
  { title = {js|Introducing Incremental|js}
  ; slug = {js|introducing-incremental|js}
  ; description = Some {js|I’m pleased to announce the release ofIncremental (wellcommented mlihere),a powerful library for building self-adjusting computations, i.e.,computations that...|js}
  ; url = {js|https://blog.janestreet.com/introducing-incremental/|js}
  ; date = {js|2015-07-18T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/introducing-incremental/introducing_incremental.png|js}
  ; body_html = {js|<p>I’m pleased to announce the release of
<a href="https://github.com/janestreet/incremental">Incremental</a> (well
commented mli
<a href="https://github.com/janestreet/incremental/blob/master/src/incremental_intf.ml">here</a>),
a powerful library for building <em>self-adjusting computations</em>, <em>i.e.</em>,
computations that can be updated efficiently when their inputs change.</p>|js}
  };
 
  { title = {js|Iron out your release process|js}
  ; slug = {js|iron-out-your-release-process|js}
  ; description = Some {js|This is the third in a series of posts about the design of Iron, our new codereview and release management tool. The other two postsare hereand here.|js}
  ; url = {js|https://blog.janestreet.com/ironing-out-your-release-process/|js}
  ; date = {js|2014-06-24T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p><em>This is the third in a series of posts about the design of Iron, our new code
review and release management tool. The other two posts
are <a href="/code-review-that-isnt-boring/">here</a>
and <a href="/scrutinizing-your-code-in-style/">here</a>.</em></p>|js}
  };
 
  { title = {js|Ironing out your development style|js}
  ; slug = {js|ironing-out-your-development-style|js}
  ; description = Some {js|People seem to enjoy talking about programming methodologies. Theygive them cute names, likeeXtreme programming,Agile, andScrum; runconferences and buildcomm...|js}
  ; url = {js|https://blog.janestreet.com/ironing-out-your-development-style/|js}
  ; date = {js|2017-08-24T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/ironing-out-your-development-style/story.jpg|js}
  ; body_html = {js|<p>People seem to enjoy talking about programming methodologies. They
give them cute names, like
<a href="http://www.extremeprogramming.org/">eXtreme programming</a>,
<a href="https://www.agilealliance.org/">Agile</a>, and
<a href="https://www.scrum.org/resources/what-is-scrum">Scrum</a>; run
<a href="https://www.scrumalliance.org/sgcal">conferences</a> and build
<a href="https://www.scrumalliance.org/community">communities</a> around them;
write
<a href="https://www.amazon.com/Extreme-Programming-Explained-Embrace-Change/dp/0321278658/ref=sr_1_1?ie=UTF8&amp;qid=1503346126&amp;sr=8-1&amp;keywords=extreme+programming">books</a>
that describe how to use them in excruciating detail; and
<a href="http://agilemanifesto.org/">manifestos</a> that lay out their
philosophy.</p>|js}
  };
 
  { title = {js|Jane Street Tech Talk, Verifying Network Data Planes|js}
  ; slug = {js|jane-street-tech-talk-verifying-network-data-planes|js}
  ; description = Some {js|After a summer hiatus, the Jane Street Tech Talks series is back onfor the fall! Last we left it, our very own Dominick LoBraicopresented on the evolution of...|js}
  ; url = {js|https://blog.janestreet.com/jane-street-tech-talk-verifying-network-data-planes/|js}
  ; date = {js|2017-09-26T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/jane-street-tech-talk-verifying-network-data-planes/tech-talk-nate-foster.png|js}
  ; body_html = {js|<p>After a summer hiatus, the Jane Street Tech Talks series is back on
for the fall! Last we left it, our very own Dominick LoBraico
presented on the evolution of our internal configuration methodology
and the systems that support it. For anybody that missed it, you can
check out a recording of the talk <a href="https://www.youtube.com/watch?v=0pX7-AG52BU">on YouTube</a>.</p>|js}
  };
 
  { title = {js|Jane Street Tech Talks: Verifying Puppet Configs|js}
  ; slug = {js|jane-street-tech-talks-verifying-puppet-configs|js}
  ; description = Some {js|Our first Jane Street Tech Talk went really well!Thanks to everyone who came and made it a fun event.|js}
  ; url = {js|https://blog.janestreet.com/jane-street-tech-talks-verifying-puppet-configs/|js}
  ; date = {js|2017-02-16T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/jane-street-tech-talks-verifying-puppet-configs/untangling_puppet.jpg|js}
  ; body_html = {js|<p>Our first <a href="/how-to-build-an-exchange/">Jane Street Tech Talk</a> went really well!
Thanks to everyone who came and made it a fun event.</p>|js}
  };
 
  { title = {js|L2 Regularization and Batch Norm|js}
  ; slug = {js|l2-regularization-and-batch-norm|js}
  ; description = Some {js|This blog post is about an interesting detail about machine learningthat I came across as a researcher at Jane Street - that of the interaction between L2 re...|js}
  ; url = {js|https://blog.janestreet.com/l2-regularization-and-batch-norm/|js}
  ; date = {js|2019-01-29T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/l2-regularization-and-batch-norm/l2-batch-norm_19b.png|js}
  ; body_html = {js|<p>This blog post is about an interesting detail about machine learning
that I came across as a researcher at Jane Street - that of the 
interaction between L2 regularization, also known as
weight decay, and batch normalization.</p>|js}
  };
 
  { title = {js|Learn OCaml in NYC|js}
  ; slug = {js|learn-ocaml-in-nyc|js}
  ; description = Some {js|Interested in learning OCaml? In the NYC area? Then this mightbe for you!|js}
  ; url = {js|https://blog.janestreet.com/learn-ocaml-nyc/|js}
  ; date = {js|2018-02-16T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/learn-ocaml-nyc/ocaml_workshop.jpg|js}
  ; body_html = {js|<p>Interested in learning OCaml? In the NYC area? Then this might
be for you!</p>|js}
  };
 
  { title = {js|Learning ML Depth-First|js}
  ; slug = {js|learning-ml-depth-first|js}
  ; description = Some {js|If you haven’t heard of it, Depth FirstLearning is awonderful resource for learning about machine learning.|js}
  ; url = {js|https://blog.janestreet.com/learning-ml-depth-first/|js}
  ; date = {js|2019-04-17T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/learning-ml-depth-first/Depth_First_Realigned.svg|js}
  ; body_html = {js|<p>If you haven’t heard of it, <a href="https://www.depthfirstlearning.com/2018/DFL-Fellowship">Depth First
Learning</a> is a
wonderful resource for learning about machine learning.</p>|js}
  };
 
  { title = {js|Let syntax, and why you should use it|js}
  ; slug = {js|let-syntax-and-why-you-should-use-it|js}
  ; description = Some {js|Earlier this year, we createda ppx_let, a PPX rewriter thatintroduces a syntax for working with monadic and applicative libraries likeCommand, Async, Result ...|js}
  ; url = {js|https://blog.janestreet.com/let-syntax-and-why-you-should-use-it/|js}
  ; date = {js|2016-06-21T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p>Earlier this year, we created
a <a href="http://github.com/janestreet/ppx_let">ppx_let</a>, a PPX rewriter that
introduces a syntax for working with monadic and applicative libraries like
Command, Async, Result and Incremental. We’ve now amassed about six months of
experience with it, and we’ve now seen enough to recommend it to a wider
audience.</p>|js}
  };
 
  { title = {js|Looking for a technical writer|js}
  ; slug = {js|looking-for-a-technical-writer|js}
  ; description = Some {js|Update: I’m excited to say that we’ve now hired a (great!) technicalwriter, so the position is closed.|js}
  ; url = {js|https://blog.janestreet.com/looking-for-a-technical-writer/|js}
  ; date = {js|2017-05-01T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p><em>Update: I’m excited to say that we’ve now hired a (great!) technical
writer, so the position is closed.</em></p>|js}
  };
 
  { title = {js|Machining the ultimate hackathon prize|js}
  ; slug = {js|machining-the-ultimate-hackathon-prize|js}
  ; description = Some {js|Jane Street is sponsoring this year’s MakeMIThackathon, and we wanted to create a prize forthe winners that would do justice to the maker spirit of thecompet...|js}
  ; url = {js|https://blog.janestreet.com/hackathon-keyboards/|js}
  ; date = {js|2019-02-28T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/hackathon-keyboards/keyboard.jpg|js}
  ; body_html = {js|<p>Jane Street is sponsoring this year’s <a href="https://makemit.org">MakeMIT
hackathon</a>, and we wanted to create a prize for
the winners that would do justice to the maker spirit of the
competition. As makers ourselves – it’s not unusual to find a
“software” engineer here who hacks on FPGAs or who has a CNC machine
at home – it felt natural to get our hands dirty.</p>|js}
  };
 
  { title = {js|Making making better|js}
  ; slug = {js|making-making-better|js}
  ; description = Some {js|We spend a lot of time and effort on training new people, and it never stops forlong. Right now our winter-intern class is ending; in five months we’ll have ...|js}
  ; url = {js|https://blog.janestreet.com/making-making-better/|js}
  ; date = {js|2015-01-31T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p>We spend a lot of time and effort on training new people, and it never stops for
long. Right now our winter-intern class is ending; in five months we’ll have a
slew of new interns to get up to speed, and a few months after that we’ll have
an incoming class of new hires.</p>|js}
  };
 
  { title = {js|Making “never break the build” scale|js}
  ; slug = {js|making-never-break-the-build-scale|js}
  ; description = Some {js|I just stumbled across a post fromearlier this year by Graydon Hoare, of Rust fame.The post is about what he calls the “Not Rocket Science Rule”, which says ...|js}
  ; url = {js|https://blog.janestreet.com/making-never-break-the-build-scale/|js}
  ; date = {js|2014-07-06T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p>I just stumbled across a <a href="http://graydon2.dreamwidth.org/1597.html">post</a> from
earlier this year by Graydon Hoare, of <a href="http://www.rust-lang.org/">Rust</a> fame.
The post is about what he calls the “Not Rocket Science Rule”, which says that
you should automatically maintain a repository that never fails its tests. The
advantages of the NRS rule are pretty clear. By ensuring that you never break
the build, you shield people from having to deal with bugs that could easily
have been caught automatically.</p>|js}
  };
 
  { title = {js|Memory allocator showdown|js}
  ; slug = {js|memory-allocator-showdown|js}
  ; description = Some {js|Since version 4.10, OCaml offers a new best-fit memory allocatoralongside its existing default, the next-fit allocator. At JaneStreet, we’ve seen a big impro...|js}
  ; url = {js|https://blog.janestreet.com/memory-allocator-showdown/|js}
  ; date = {js|2020-09-15T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/memory-allocator-showdown/MemoryAllocator.jpg|js}
  ; body_html = {js|Since version 4.10, OCaml offers a new best-fit memory allocator
alongside its existing default, the next-fit allocator. At Jane
Street, we've seen a big improvement after switching over to the new
allocator.

This post isn't about how the new allocator works. For that, the best
source is these notes from a talk by its
author.  Instead, this post is about just how tricky it is to compare two
allocators in a reasonable way, especially for a garbage-collected
system.|js}
  };
 
  { title = {js|No (functional) experience required|js}
  ; slug = {js|no-functional-experience-required|js}
  ; description = Some {js|Jane Street is a serious functional programming shop. We use OCaml, a staticallytyped functional language for almost everything and have what is probably the...|js}
  ; url = {js|https://blog.janestreet.com/no-functional-experience-required/|js}
  ; date = {js|2015-08-19T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p>Jane Street is a serious functional programming shop. We use OCaml, a statically
typed functional language for almost everything and have what is probably the
largest OCaml codebase anywhere.</p>|js}
  };
 
  { title = {js|Notes on Naming|js}
  ; slug = {js|notes-on-naming|js}
  ; description = Some {js|I’ve been thinking about naming recently, specifically the naming of newsystems. It’s tempting to think of naming as trivial, but it really does matter.In a ...|js}
  ; url = {js|https://blog.janestreet.com/notes-on-naming/|js}
  ; date = {js|2014-06-29T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p>I’ve been thinking about naming recently, specifically the naming of new
systems. It’s tempting to think of naming as trivial, but it really does matter.
In a technology driven organization, names are part of how you communicate about
the purpose and nature of your systems. And that communication matters more as
the number of people and systems grows.</p>|js}
  };
 
  { title = {js|Observations of a functional programmer|js}
  ; slug = {js|observations-of-a-functional-programmer|js}
  ; description = Some {js|I was recently invited to do the keynote at the Commercial Users of FunctionalProgramming workshop, a 15-year-old gathering which isattached to ICFP, the pri...|js}
  ; url = {js|https://blog.janestreet.com/observations-of-a-functional-programmer/|js}
  ; date = {js|2016-10-27T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p>I was recently invited to do the keynote at the <a href="http://cufp.org/2016/">Commercial Users of Functional
Programming</a> workshop, a 15-year-old gathering which is
attached to ICFP, the primary academic functional programming conference.</p>|js}
  };
 
  { title = {js|OCaml 4.03: Everything else|js}
  ; slug = {js|ocaml-403-everything-else|js}
  ; description = Some {js|In my previous post I wrote about Flambda, which is the singlebiggest feature coming to OCaml in this release. In this post, I’ll review theother features of...|js}
  ; url = {js|https://blog.janestreet.com/ocaml-4-03-everything-else/|js}
  ; date = {js|2016-03-01T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p>In my <a href="/flambda">previous post</a> I wrote about Flambda, which is the single
biggest feature coming to OCaml in this release. In this post, I’ll review the
other features of 4.03 that caught my eye.</p>|js}
  };
 
  { title = {js|OCaml all the way down|js}
  ; slug = {js|ocaml-all-the-way-down|js}
  ; description = Some {js|One of the joys of working at Jane Street for the last 15 or so yearshas been seeing how our software stack has grown in scope. When Istarted, I was building...|js}
  ; url = {js|https://blog.janestreet.com/ocaml-all-the-way-down/|js}
  ; date = {js|2018-04-04T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/ocaml-all-the-way-down/fpga.jpg|js}
  ; body_html = {js|<p>One of the joys of working at Jane Street for the last 15 or so years
has been seeing how our software stack has grown in scope. When I
started, I was building pretty narrowly focused systems for doing
statistical research on trading strategies, and then building systems
for executing those same strategies.</p>|js}
  };
 
  { title = {js|Of Pythons and Camels|js}
  ; slug = {js|of-pythons-and-camels|js}
  ; description = Some {js|Welcome to another post in our series of how to use OCaml for machine learning.In previous posts we’ve discussed artistic style-transfer andreinforcement lea...|js}
  ; url = {js|https://blog.janestreet.com/of-pythons-and-camels/|js}
  ; date = {js|2019-07-09T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/of-pythons-and-camels/camel-identify.jpg|js}
  ; body_html = {js|<p>Welcome to another post in our series of how to use OCaml for machine learning.
In previous posts we’ve discussed <a href="https://blog.janestreet.com/deep-learning-experiments-in-ocaml/">artistic style-transfer</a> and
<a href="https://blog.janestreet.com/playing-atari-games-with-ocaml-and-deep-rl/">reinforcement learning</a>. If you haven’t read these feel
free to do so now, we’ll wait right here until you’re done. Ready? Ok, let’s
continue …</p>|js}
  };
 
  { title = {js|One more talk, two more videos|js}
  ; slug = {js|one-more-talk-two-more-videos|js}
  ; description = Some {js|I’m happy to announce our next public techtalk, called SevenImplementations of Incremental, on Wednesday, April 5th, presented by yourstruly. You can registe...|js}
  ; url = {js|https://blog.janestreet.com/one-more-talk-two-more-videos/|js}
  ; date = {js|2017-03-15T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p>I’m happy to announce our next <a href="https://events.janestreet.com/home/tech-talks/">public tech
talk</a>, called <strong>Seven
Implementations of Incremental</strong>, on Wednesday, April 5th, presented by yours
truly. You can register
<a href="https://docs.google.com/forms/d/e/1FAIpQLSdtly4y-jYcLUVH8BJS-uKoiaKrQlRXSIWZeczw3tgwTx_6HA/viewform?c=0&amp;w=1">here</a>.</p>|js}
  };
 
  { title = {js|Plans for OCaml 4.08|js}
  ; slug = {js|plans-for-ocaml-408|js}
  ; description = Some {js|With the external release of OCaml 4.07.0 imminent, we in Jane Street’sTools & Compilers group have been planning what we want to work on forinclusion in...|js}
  ; url = {js|https://blog.janestreet.com/plans-for-ocaml-408/|js}
  ; date = {js|2018-06-29T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/plans-for-ocaml-408/ocaml_release.jpg|js}
  ; body_html = {js|<p>With the external release of OCaml 4.07.0 imminent, we in Jane Street’s
Tools &amp; Compilers group have been planning what we want to work on for
inclusion in OCaml 4.08. These days OCaml uses (or at least attempts) a
time-based release process with releases scheduled every 6 months. We’re
trying to avoid rushing in changes at the last minute – as we’ve been
prone to do in the past – so this list is restricted to things we could
conceivably finish in the next 4-5 months.</p>|js}
  };
 
  { title = {js|Playing Atari Games with OCaml and Deep Reinforcement Learning|js}
  ; slug = {js|playing-atari-games-with-ocaml-and-deep-reinforcement-learning|js}
  ; description = Some {js|In a previous blog postwe detailed how we used OCaml to reproduce some classical deep-learning resultsthat would usually be implemented in Python. Here we wi...|js}
  ; url = {js|https://blog.janestreet.com/playing-atari-games-with-ocaml-and-deep-rl/|js}
  ; date = {js|2019-02-02T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/playing-atari-games-with-ocaml-and-deep-rl/atari.jpg|js}
  ; body_html = {js|<p>In a <a href="https://blog.janestreet.com/deep-learning-experiments-in-ocaml/">previous blog post</a>
we detailed how we used OCaml to reproduce some classical deep-learning results
that would usually be implemented in Python. Here we will do the same with
some Reinforcement Learning (RL) experiments.</p>|js}
  };
 
  { title = {js|Proofs (and Refutations) using Z3|js}
  ; slug = {js|proofs-and-refutations-using-z3|js}
  ; description = Some {js|People often think of formal methods and theorem provers as forbiddingtools, cool in theory but with a steep learning curve that makes themhard to use in rea...|js}
  ; url = {js|https://blog.janestreet.com/proofs-and-refutations-using-z3/|js}
  ; date = {js|2018-02-15T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/proofs-and-refutations-using-z3/proof.jpg|js}
  ; body_html = {js|<p>People often think of formal methods and theorem provers as forbidding
tools, cool in theory but with a steep learning curve that makes them
hard to use in real life. In this post, we’re going to describe a case
we ran into recently where we were able to leverage theorem proving
technology, Z3 in particular, to validate some real world engineering
we were doing on the OCaml compiler. This post is aimed at readers
interested in compilers, but assumes no familiarity with actual
compiler development.</p>|js}
  };
 
  { title = {js|Putting the I back in IDE: Towards a Github Explorer|js}
  ; slug = {js|putting-the-i-back-in-ide-towards-a-github-explorer|js}
  ; description = Some {js|Imagine a system for editing and reviewing code where:|js}
  ; url = {js|https://blog.janestreet.com/putting-the-i-back-in-ide-towards-a-github-explorer/|js}
  ; date = {js|2018-03-27T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/putting-the-i-back-in-ide-towards-a-github-explorer/postimage.jpg|js}
  ; body_html = {js|<p>Imagine a system for editing and reviewing code where:</p>|js}
  };
 
  { title = {js|Quickcheck for Core|js}
  ; slug = {js|quickcheck-for-core|js}
  ; description = Some {js|Automated testing is a powerful tool for finding bugs and specifying correctnessproperties of code. Haskell’s Quickcheck library is the most well-knownautoma...|js}
  ; url = {js|https://blog.janestreet.com/quickcheck-for-core/|js}
  ; date = {js|2015-10-26T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p>Automated testing is a powerful tool for finding bugs and specifying correctness
properties of code. Haskell’s Quickcheck library is the most well-known
automated testing library, based on over 15 years of research into how to write
property-base tests, generate useful sources of inputs, and report manageable
counterexamples. Jane Street’s Core library has not had anything comparable up
until now; version 113.00 of Core finally has a version of Quickcheck,
integrating automated testing with our other facilities like s-expression
reporting for counterexample values, and support for asynchronous tests using
Async.</p>|js}
  };
 
  { title = {js|Reading Lamport, again|js}
  ; slug = {js|reading-lamport-again|js}
  ; description = Some {js|We’ve just kicked off an internal distributed-systems seminar. Our inaugralpaper was Lamport’s classic “Time, Clocks and the Ordering of Events in aDistribut...|js}
  ; url = {js|https://blog.janestreet.com/reading-lamport-again/|js}
  ; date = {js|2014-06-26T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p>We’ve just kicked off an internal distributed-systems seminar. Our inaugral
paper was Lamport’s classic <a href="http://web.stanford.edu/class/cs240/readings/lamport.pdf">“Time, Clocks and the Ordering of Events in a
Distributed System”</a>.
I remembered the paper fondly, but hadn’t looked back it it for more than a
decade.</p>|js}
  };
 
  { title = {js|Real world machine learning (part 1)|js}
  ; slug = {js|real-world-machine-learning-part-1|js}
  ; description = Some {js|Trading is a competitive business. You need great people and greattechnology, of course, but also trading strategies that make money.Where do those strategie...|js}
  ; url = {js|https://blog.janestreet.com/real-world-machine-learning-part-1/|js}
  ; date = {js|2017-08-28T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/real-world-machine-learning-part-1/inverse_colors.gif|js}
  ; body_html = {js|<p>Trading is a competitive business. You need great people and great
technology, of course, but also trading strategies that make money.
Where do those strategies come from? In this post we’ll discuss how
the interplay of data, math and technology informs how we develop and
run strategies.</p>|js}
  };
 
  { title = {js|Really low latency multipliers and cryptographic puzzles|js}
  ; slug = {js|really-low-latency-multipliers-and-cryptographic-puzzles|js}
  ; description = Some {js|At Jane Street, we have some experience using FPGAs for low-latencysystems–FPGAs are programmable hardware where you get the speed of anapplication-specific ...|js}
  ; url = {js|https://blog.janestreet.com/really-low-latency-multipliers-and-cryptographic-puzzles/|js}
  ; date = {js|2020-06-22T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/really-low-latency-multipliers-and-cryptographic-puzzles/lock.png|js}
  ; body_html = {js|<p>At Jane Street, we have some experience using FPGAs for low-latency
systems–FPGAs are programmable hardware where you get the speed of an
application-specific integrated circuit (ASIC) but without being
committed to a design that’s burned into the chip. It wasn’t so long
ago that FPGAs were expensive and rare, but these days, you can rent a
$5,000 card on the Amazon AWS cloud for less than $3 an hour.</p>|js}
  };
 
  { title = {js|Repeatable exploratory programming|js}
  ; slug = {js|repeatable-exploratory-programming|js}
  ; description = Some {js|Expect tests are a technique I’ve written aboutbefore, but until recently, it’s been alittle on the theoretical side. That’s because it’s been hard to taketh...|js}
  ; url = {js|https://blog.janestreet.com/repeatable-exploratory-programming/|js}
  ; date = {js|2018-04-22T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/repeatable-exploratory-programming/lambdasoup.jpg|js}
  ; body_html = {js|<p>Expect tests are a technique I’ve written about
<a href="/testing-with-expectations">before</a>, but until recently, it’s been a
little on the theoretical side. That’s because it’s been hard to take
these ideas out for a spin due to lack of tooling outside of Jane
Street’s walls.</p>|js}
  };
 
  { title = {js|Reverse web proxy in ~50 lines of BASH|js}
  ; slug = {js|reverse-web-proxy-in-50-lines-of-bash|js}
  ; description = Some {js|In the spirit of reinventing the wheel for fun, I hacked this together as aquick challenge to myself last week. It’s a little rough around the edges, but Ith...|js}
  ; url = {js|https://blog.janestreet.com/reverse-web-proxy-in-50-lines-of-bash/|js}
  ; date = {js|2015-05-01T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p>In the spirit of reinventing the wheel for fun, I hacked this together as a
quick challenge to myself last week. It’s a little rough around the edges, but I
thought it was too cute not to share. If you have any bug fixes, please post
them in the comments.</p>|js}
  };
 
  { title = {js|rsync rounds timestamps to the nearest second|js}
  ; slug = {js|rsync-rounds-timestamps-to-the-nearest-second|js}
  ; description = Some {js|I’m not sure how I’ve managed to use rsync for so many years without evernoticing this, but hey, you learn something new every day!|js}
  ; url = {js|https://blog.janestreet.com/rsync-rounds-timestamps-to-the-nearest-second/|js}
  ; date = {js|2015-10-07T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p>I’m not sure how I’ve managed to use rsync for so many years without ever
noticing this, but hey, you learn something new every day!</p>|js}
  };
 
  { title = {js|Scrutinize your code in style|js}
  ; slug = {js|scrutinize-your-code-in-style|js}
  ; description = Some {js|This is the second in a series of posts about the design of Iron, our new codereview tool. You can read the first post here.Also, I should give credit where ...|js}
  ; url = {js|https://blog.janestreet.com/scrutinizing-your-code-in-style/|js}
  ; date = {js|2014-06-13T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p><em>This is the second in a series of posts about the design of Iron, our new code
review tool. You can read the first post <a href="/code-review-that-isnt-boring/">here</a>.
Also, I should give credit where credit is due. While I’ve been involved in some
of the design discussions, the real work has been done by Stephen Weeks,
Valentin Gatien Baron, Olin Shivers (yes, that Olin Shivers. He’s joining us for
part of his sabbatical) and Mathieu Barbin.</em></p>|js}
  };
 
  { title = {js|Self Adjusting DOM and Diffable Data|js}
  ; slug = {js|self-adjusting-dom-and-diffable-data|js}
  ; description = Some {js|In my last post, I gave some simple examples showing howyou could useself adjusting computations,or SAC, as embodied by our Incremental library, toincrementa...|js}
  ; url = {js|https://blog.janestreet.com/self-adjusting-dom-and-diffable-data/|js}
  ; date = {js|2016-02-10T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p>In my last <a href="/self-adjusting-dom/">post</a>, I gave some simple examples showing how
you could use
<a href="http://www.umut-acar.org/self-adjusting-computation">self adjusting computations</a>,
or SAC, as embodied by our <a href="/introducing-incremental/">Incremental</a> library, to
incrementalize the computation of virtual dom nodes. In this post, I’d like to
discuss how we can extend this approach to more realistic scales, and some of
the extensions to Incremental itself that are required to get there.</p>|js}
  };
 
  { title = {js|Self Adjusting DOM|js}
  ; slug = {js|self-adjusting-dom|js}
  ; description = Some {js|I’ve been thinking recently about how tostructure dynamic web applications, and in particular about the role thatincremental computation should play.|js}
  ; url = {js|https://blog.janestreet.com/self-adjusting-dom/|js}
  ; date = {js|2016-02-06T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p>I’ve been <a href="/incrementality-and-the-web/">thinking recently</a> about how to
structure dynamic web applications, and in particular about the role that
incremental computation should play.</p>|js}
  };
 
  { title = {js|Seven Implementations of Incremental|js}
  ; slug = {js|seven-implementations-of-incremental|js}
  ; description = Some {js|We finally got a decent recording of one of my favorite talks. This one is aboutour Incremental library (which Iwrote about here), and in particular about th...|js}
  ; url = {js|https://blog.janestreet.com/seven-implementations-of-incremental/|js}
  ; date = {js|2016-03-09T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/seven-implementations-of-incremental/ron-photo.jpg|js}
  ; body_html = {js|<p>We finally got a decent recording of one of my favorite talks. This one is about
our <a href="https://github.com/janestreet/incremental">Incremental</a> library (which I
wrote about <a href="/introducing-incremental/">here</a>), and in particular about the
story of how we got to the present, quite performant, implementation.</p>|js}
  };
 
  { title = {js|Simple top-down development in OCaml|js}
  ; slug = {js|simple-top-down-development-in-ocaml|js}
  ; description = Some {js|Often when writing a new module, I want to write the interface first and savethe implementation for later. This lets me use the module as a black box,extendi...|js}
  ; url = {js|https://blog.janestreet.com/simple-top-down-development-in-ocaml/|js}
  ; date = {js|2014-07-18T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p>Often when writing a new module, I want to write the interface first and save
the implementation for later. This lets me use the module as a black box,
extending the interface as needed to support the rest of the program. When
everything else is finished, I can fill in the implementation, knowing the full
interface I need to support. Of course sometimes the implementation needs to
push back on the interface – this pattern isn’t an absolute – but it’s certainly
a useful starting point. The trick is getting the program to compile at
intermediate stages when the implementation hasn’t been filled in.</p>|js}
  };
 
  { title = {js|Testing with expectations|js}
  ; slug = {js|testing-with-expectations|js}
  ; description = Some {js|Testing is important, and it’s hard to get people to do as much of it as theyshould. Testing tools matter because the smoother the process is, the more tests...|js}
  ; url = {js|https://blog.janestreet.com/testing-with-expectations/|js}
  ; date = {js|2015-12-02T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p>Testing is important, and it’s hard to get people to do as much of it as they
should. Testing tools matter because the smoother the process is, the more tests
people will write.</p>|js}
  };
 
  { title = {js|The Jane Street Interview Process &mdash; 2020 Edition|js}
  ; slug = {js|the-jane-street-interview-process-mdash-2020-edition|js}
  ; description = Some {js|We’re busy preparing for our software engineering fall hiringseason. Over the years we’vedone our best to make our interview process more transparent tocandi...|js}
  ; url = {js|https://blog.janestreet.com/jane-street-interview-process-2020/|js}
  ; date = {js|2020-07-24T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/jane-street-interview-process-2020/ocaml_code.png|js}
  ; body_html = {js|<p>We’re busy preparing for our software engineering <a href="https://blog.janestreet.com/unraveling/">fall hiring
season</a>. Over the years we’ve
done our best to make our interview process more transparent to
candidates. While many candidates show up knowing something about what
our interviews look like, much of the information floating around on
the internet is outdated or wrong. These past few months have also
changed a lot about the process as we’ve adapted to working from home
and other effects of COVID-19.</p>|js}
  };
 
  { title = {js|The ML Workshop looks fantastic|js}
  ; slug = {js|the-ml-workshop-looks-fantastic|js}
  ; description = Some {js|I’m a little biased, by being on the steering committee, but this year’s MLworkshop looks really interesting. Here’s a link to the program:|js}
  ; url = {js|https://blog.janestreet.com/the-ml-workshop-looks-fantastic/|js}
  ; date = {js|2014-07-31T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p>I’m a little biased, by being on the steering committee, but this year’s ML
workshop looks really interesting. Here’s a link to the program:</p>|js}
  };
 
  { title = {js|Thoughts from AAAI 2019|js}
  ; slug = {js|thoughts-from-aaai-2019|js}
  ; description = Some {js|At Jane Street, for the last several years, we have been increasingly interestedin machine learning and its many use cases. This is why it was exciting whene...|js}
  ; url = {js|https://blog.janestreet.com/thoughts-from-aaai-19/|js}
  ; date = {js|2019-05-13T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/thoughts-from-aaai-19/AAAI.jpg|js}
  ; body_html = {js|<p>At Jane Street, for the last several years, we have been increasingly interested
in machine learning and its many use cases. This is why it was exciting when
earlier this year myself and a few of my colleagues had the opportunity to
attend the AAAI 2019 conference. We’d like to take this space to share with you
some of the interesting projects and themes we saw at the conference.</p>|js}
  };
 
  { title = {js|Trivial meta-programming with cinaps|js}
  ; slug = {js|trivial-meta-programming-with-cinaps|js}
  ; description = Some {js|From now and then, I found myself having to write some mechanical and repetitivecode. The usual solution for this is to write a code generator; for instance ...|js}
  ; url = {js|https://blog.janestreet.com/trivial-meta-programming-with-cinaps/|js}
  ; date = {js|2017-03-20T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p>From now and then, I found myself having to write some mechanical and repetitive
code. The usual solution for this is to write a code generator; for instance in
the form of a ppx rewriter in the case of OCaml code. This however comes with a
cost: code generators are harder to review than plain code and it is a new
syntax to learn for other developers. So when the repetitive pattern is local to
a specific library or not widely used, it is often not worth the effort.
Especially if the code in question is meant to be reviewed and maintained by
several people.</p>|js}
  };
 
  { title = {js|Troubleshooting systemd with SystemTap|js}
  ; slug = {js|troubleshooting-systemd-with-systemtap|js}
  ; description = Some {js|When we set up a schedule on a computer, such as a list of commands torun every day at particular times via Linux cronjobs, weexpect that schedule to execute...|js}
  ; url = {js|https://blog.janestreet.com/troubleshooting-systemd-with-systemtap/|js}
  ; date = {js|2020-02-03T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/troubleshooting-systemd-with-systemtap/data-taps.jpg|js}
  ; body_html = {js|<p>When we set up a schedule on a computer, such as a list of commands to
run every day at particular times via Linux <a href="https://www.ostechnix.com/a-beginners-guide-to-cron-jobs">cron
jobs</a>, we
expect that schedule to execute reliably.  Of course we’ll check the
logs to see whether the job has failed, but we never question whether
the cron daemon itself will function.  We always assume that it will,
as it always has done; we are not expecting mutiny in the ranks of the
operating system.</p>|js}
  };
 
  { title = {js|Unraveling of the tech hiring market|js}
  ; slug = {js|unraveling-of-the-tech-hiring-market|js}
  ; description = Some {js|Recruiting talented people has always been challenging.|js}
  ; url = {js|https://blog.janestreet.com/unraveling/|js}
  ; date = {js|2016-08-31T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p>Recruiting talented people has always been challenging.</p>|js}
  };
 
  { title = {js|Using ASCII waveforms to test hardware designs|js}
  ; slug = {js|using-ascii-waveforms-to-test-hardware-designs|js}
  ; description = Some {js|At Jane Street, an “expecttest” is atest where you don’t manually write the output you’d like to checkyour code against – instead, this output is captured au...|js}
  ; url = {js|https://blog.janestreet.com/using-ascii-waveforms-to-test-hardware-designs/|js}
  ; date = {js|2020-06-01T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/using-ascii-waveforms-to-test-hardware-designs/scientist_testing.jpg|js}
  ; body_html = {js|<p>At Jane Street, an <a href="https://blog.janestreet.com/testing-with-expectations">“expect
test”</a> is a
test where you don’t manually write the output you’d like to check
your code against – instead, this output is captured automatically
and inserted by a tool into the testing code itself. If further runs
produce different output, the test fails, and you’re presented with
the diff.</p>|js}
  };
 
  { title = {js|Using OCaml to drive a Raspberry Pi robot car|js}
  ; slug = {js|using-ocaml-to-drive-a-raspberry-pi-robot-car|js}
  ; description = Some {js|Back when the Raspberry Pi was first released in 2012 Michael Bacarella wrotea blog poston using OCaml and Async on this little device.Since then installing ...|js}
  ; url = {js|https://blog.janestreet.com/using-ocaml-to-drive-a-raspberry-pi-robot-car/|js}
  ; date = {js|2019-08-19T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/using-ocaml-to-drive-a-raspberry-pi-robot-car/robot-pi.jpg|js}
  ; body_html = {js|<p>Back when the Raspberry Pi was first released in 2012 Michael Bacarella wrote
a <a href="https://blog.janestreet.com/bootstrapping-ocamlasync-on-the-raspberry-pi/">blog post</a>
on using OCaml and Async on this little device.
Since then installing OCaml via opam has become a pretty smooth experience
and everything works out of the box when using Raspbian – the default Raspberry Pi
distribution.</p>|js}
  };
 
  { title = {js|Using Python and OCaml in the same Jupyter notebook|js}
  ; slug = {js|using-python-and-ocaml-in-the-same-jupyter-notebook|js}
  ; description = Some {js|The cover image is based on Jupiter family by NASA/JPL.|js}
  ; url = {js|https://blog.janestreet.com/using-python-and-ocaml-in-the-same-jupyter-notebook/|js}
  ; date = {js|2019-12-16T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/using-python-and-ocaml-in-the-same-jupyter-notebook/python-ocaml.jpg|js}
  ; body_html = {js|<div style="width: 75%; margin: auto; text-align: center; font-style: italic; font-size: 75%">
The cover image is based on <a href="https://commons.wikimedia.org/wiki/File:Jupiter_family.jpg">Jupiter family</a> by NASA/JPL.
</div>|js}
  };
 
  { title = {js|Watch all of Jane Street's tech talks|js}
  ; slug = {js|watch-all-of-jane-streets-tech-talks|js}
  ; description = Some {js|Jane Street has been posting tech talks from internal speakers andinvited guests for years—and they’re all available on our YouTubechannel:|js}
  ; url = {js|https://blog.janestreet.com/watch-all-of-jane-streets-tech-talks/|js}
  ; date = {js|2020-02-20T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/watch-all-of-jane-streets-tech-talks/youtube-techtalks.jpg|js}
  ; body_html = {js|<p>Jane Street has been posting tech talks from internal speakers and
invited guests for years—and they’re all available on our YouTube
channel:</p>|js}
  };
 
  { title = {js|What a Jane Street software engineering interview is like|js}
  ; slug = {js|what-a-jane-street-software-engineering-interview-is-like|js}
  ; description = Some {js|Are you thinking aboutapplying to Jane Streetfor a software engineering role? Or already have a phone interview scheduled but unsurewhat to expect? Read on a...|js}
  ; url = {js|https://blog.janestreet.com/what-a-jane-street-dev-interview-is-like/|js}
  ; date = {js|2017-02-28T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p>Are you thinking about
<a href="https://www.janestreet.com/join-jane-street/apply/">applying</a> to Jane Street
for a software engineering role? Or already have a phone interview scheduled but unsure
what to expect? Read on as we walk through an example phone interview with you.</p>|js}
  };
 
  { title = {js|What is gained and lost with 63-bit integers?|js}
  ; slug = {js|what-is-gained-and-lost-with-63-bit-integers|js}
  ; description = Some {js|Almost every programming language uses 64-bit integers on typical modern Intelmachines. OCaml uses a special 63-bit representation. How does it affect OCaml?|js}
  ; url = {js|https://blog.janestreet.com/what-is-gained-and-lost-with-63-bit-integers/|js}
  ; date = {js|2014-09-29T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p>Almost every programming language uses 64-bit integers on typical modern Intel
machines. OCaml uses a special 63-bit representation. How does it affect OCaml?</p>|js}
  };
 
  { title = {js|What the interns have wrought, 2016|js}
  ; slug = {js|what-the-interns-have-wrought-2016|js}
  ; description = Some {js|Now that the interns have mostly gone back to school, it’s a good time to lookback at what they did while they were here. We had a bumper crop – more than 30...|js}
  ; url = {js|https://blog.janestreet.com/what-the-interns-have-wrought-2016/|js}
  ; date = {js|2016-09-13T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p>Now that the interns have mostly gone back to school, it’s a good time to look
back at what they did while they were here. We had a bumper crop – more than 30
dev interns between our London, New York and Hong Kong offices – and they
worked on just about every corner of our code-base.</p>|js}
  };
 
  { title = {js|What the interns have wrought, 2017 edition|js}
  ; slug = {js|what-the-interns-have-wrought-2017-edition|js}
  ; description = Some {js|Intern season is coming to a close, and it’s a nice time to look back(as I’ve done inpreviousyears) and review some of whatthe interns did while they were he...|js}
  ; url = {js|https://blog.janestreet.com/what-the-interns-have-wrought-2017/|js}
  ; date = {js|2017-08-14T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/what-the-interns-have-wrought-2017/what_interns_wrought.png|js}
  ; body_html = {js|<p>Intern season is coming to a close, and it’s a nice time to look back
(as I’ve done in
<a href="/what-the-interns-have-wrought-rpc_parallel-and-core_profiler">previous</a>
<a href="/what-the-interns-have-wrought-2016">years</a>) and review some of what
the interns did while they were here. The dev intern program has grown
considerably, with almost 40 dev interns between our NY, London, and
Hong Kong offices.</p>|js}
  };
 
  { title = {js|What the interns have wrought, 2018 edition|js}
  ; slug = {js|what-the-interns-have-wrought-2018-edition|js}
  ; description = Some {js|Yet again, intern season is coming to a close, and so it’s time tolook back at what the interns have achieved in their short time withus.  I’m always impress...|js}
  ; url = {js|https://blog.janestreet.com/what-the-interns-have-wrought-2018/|js}
  ; date = {js|2018-08-06T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/what-the-interns-have-wrought-2018/smelting.jpg|js}
  ; body_html = {js|<p>Yet again, intern season is coming to a close, and so it’s time to
look back at what the interns have achieved in their short time with
us.  I’m always impressed by what our interns manage to squeeze into
the summer, and this year is no different.</p>|js}
  };
 
  { title = {js|What the interns have wrought, 2019 edition|js}
  ; slug = {js|what-the-interns-have-wrought-2019-edition|js}
  ; description = Some {js|Jane Street’s intern program yet again is coming to an end, which is anice opportunity to look back over the summer and see what they’veaccomplished.|js}
  ; url = {js|https://blog.janestreet.com/what-the-interns-have-wrought-2019/|js}
  ; date = {js|2019-08-30T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/what-the-interns-have-wrought-2019/what_interns_wrought2019.jpg|js}
  ; body_html = {js|<p>Jane Street’s intern program yet again is coming to an end, which is a
nice opportunity to look back over the summer and see what they’ve
accomplished.</p>|js}
  };
 
  { title = {js|What the interns have wrought, 2020 edition|js}
  ; slug = {js|what-the-interns-have-wrought-2020-edition|js}
  ; description = Some {js|It’s been an unusual internship season.|js}
  ; url = {js|https://blog.janestreet.com/what-the-interns-have-wrought-2020/|js}
  ; date = {js|2020-08-17T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/what-the-interns-have-wrought-2020/./distributed-wrought.jpg|js}
  ; body_html = {js|<p>It’s been an unusual internship season.</p>|js}
  };
 
  { title = {js|What the interns have wrought: RPC_parallel and Core_profiler|js}
  ; slug = {js|what-the-interns-have-wrought-rpcparallel-and-coreprofiler|js}
  ; description = Some {js|We’re in the midst of intern hiring season, and so we get a lot of questionsabout what it’s like to be an intern at Jane Street. One of the things peoplemost...|js}
  ; url = {js|https://blog.janestreet.com/what-the-interns-have-wrought-rpc_parallel-and-core_profiler/|js}
  ; date = {js|2014-10-16T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p>We’re in the midst of intern hiring season, and so we get a lot of questions
about what it’s like to be an intern at Jane Street. One of the things people
most want to know is what kind of projects they might work on as an intern.</p>|js}
  };
 
  { title = {js|What's in a name?|js}
  ; slug = {js|whats-in-a-name|js}
  ; description = Some {js|In the once upon a time days of the First Age of Magic, the prudent sorcererregarded his own true name as his most valued possession but also the greatestt...|js}
  ; url = {js|https://blog.janestreet.com/whats-in-a-name/|js}
  ; date = {js|2014-07-10T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<blockquote>
  <p>In the once upon a time days of the First Age of Magic, the prudent sorcerer
regarded his own true name as his most valued possession but also the greatest
threat to his continued good health, for—the stories go—once an enemy, even a
weak unskilled enemy, learned the sorcerer’s true name, then routine and
widely known spells could destroy or enslave even the most powerful. As times
passed, and we graduated to the Age of Reason and thence to the first and
second industrial revolutions, such notions were discredited. Now it seems
that the Wheel has turned full circle (even if there never really was a First
Age) and we are back to worrying about true names again.</p>

  <p>– <em>True Names</em>, V. Vinge</p>
</blockquote>|js}
  };
 
  { title = {js|When Bash Scripts Bite|js}
  ; slug = {js|when-bash-scripts-bite|js}
  ; description = Some {js|There are abundant resources online trying to scare programmers away from usingshell scripts. Most of them, if anything, succeed in convincing the reader tob...|js}
  ; url = {js|https://blog.janestreet.com/when-bash-scripts-bite/|js}
  ; date = {js|2017-05-11T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p>There are abundant resources online trying to scare programmers away from using
shell scripts. Most of them, if anything, succeed in convincing the reader to
blindly put something that resembles</p>|js}
  };
 
  { title = {js|Why GADTs matter for performance|js}
  ; slug = {js|why-gadts-matter-for-performance|js}
  ; description = Some {js|When GADTs (Generalized Algebraic DataTypes) landed inOCaml, I wasn’t particularly happy about it. I assumed that it was the kind ofnonsense you get when you...|js}
  ; url = {js|https://blog.janestreet.com/why-gadts-matter-for-performance/|js}
  ; date = {js|2015-03-30T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<p>When GADTs (<a href="http://en.wikipedia.org/wiki/Generalized_algebraic_data_type">Generalized Algebraic Data
Types</a>) landed in
OCaml, I wasn’t particularly happy about it. I assumed that it was the kind of
nonsense you get when you let compiler writers design your programming language.</p>|js}
  };
 
  { title = {js|Why OCaml?|js}
  ; slug = {js|why-ocaml|js}
  ; description = None
  ; url = {js|https://blog.janestreet.com/why-ocaml/|js}
  ; date = {js|2016-01-25T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/static/img/header.png|js}
  ; body_html = {js|<div class="video-container">
  <iframe src="https://youtube.com/embed/v1CmGbOGb2I?rel=0" width="560" height="315" frameborder="0" allowfullscreen=""></iframe>
</div>|js}
  };
 
  { title = {js|Work on the OCaml compiler at Jane Street!|js}
  ; slug = {js|work-on-the-ocaml-compiler-at-jane-street|js}
  ; description = Some {js|As Jane Street grows, the quality of the development tools we usematters more and more.  We increasingly work on the OCaml compileritself: adding useful lang...|js}
  ; url = {js|https://blog.janestreet.com/work-on-the-ocaml-compiler-at-jane-street/|js}
  ; date = {js|2017-12-20T00:00:00-00:00|js}
  ; preview_image = Some {js|https://blog.janestreet.com/work-on-the-ocaml-compiler-at-jane-street/compiler3d.jpg|js}
  ; body_html = {js|<p>As Jane Street grows, the quality of the development tools we use
matters more and more.  We increasingly work on the OCaml compiler
itself: adding useful language features, fine-tuning the type system
and improving the performance of the generated code. Alongside this,
we also work on the surrounding toolchain, developing new tools for
profiling, debugging, documentation and build automation.</p>|js}
  };
 
  { title = {js|An Architecture for Interspatial Communication|js}
  ; slug = {js|an-architecture-for-interspatial-communication|js}
  ; description = None
  ; url = {js|http://kcsrk.info/papers/osmose_feb_18.pdf|js}
  ; date = {js|2018-02-14T00:00:00-00:00|js}
  ; preview_image = None
  ; body_html = {js|<p>Position paper on
<a href="http://kcsrk.info/papers/osmose_feb_18.pdf">“An Architecture for Interspatial Communication”</a>
accepted to <a href="http://hotpost18.weebly.com/">HotPOST’18</a>.</p>|js}
  };
 
  { title = {js|An introduction to fuzzing OCaml with AFL, Crowbar and Bun|js}
  ; slug = {js|an-introduction-to-fuzzing-ocaml-with-afl-crowbar-and-bun|js}
  ; description = Some {js|American Fuzzy Lop or AFL is a fuzzer: a program that tries to find bugs in
other programs by sending them various auto-generated inputs…|js}
  ; url = {js|https://tarides.com/blog/2019-09-04-an-introduction-to-fuzzing-ocaml-with-afl-crowbar-and-bun|js}
  ; date = {js|2019-09-04T00:00:00-00:00|js}
  ; preview_image = Some {js|https://tarides.com/static/4eed05522f6733d728f6dc01bbe33e09/2244e/feather.jpg|js}
  ; body_html = {js|<p><a href="http://lcamtuf.coredump.cx/afl/">American Fuzzy Lop</a> or AFL is a <em>fuzzer</em>: a program that tries to find bugs in
other programs by sending them various auto-generated inputs. This article covers the
basics of AFL and shows an example of fuzzing a parser written in OCaml. It also introduces two
extensions: the <a href="https://github.com/stedolan/crowbar/">Crowbar</a> library which can be used to fuzz any kind of OCaml program or
function and the <a href="https://github.com/yomimono/ocaml-bun/">Bun</a> tool for integrating fuzzing into your CI.</p>
<p>All of the examples given in this article are available on GitHub at
<a href="https://github.com/NathanReb/ocaml-afl-examples">ocaml-afl-examples</a>. The <code>README</code> contains all the information you need to understand,
build and fuzz them yourself.</p>
<h2 id="what-is-afl" style="position:relative;"><a href="#what-is-afl" aria-label="what is afl permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>What is AFL?</h2>
<p>AFL actually isn't <em>just</em> a fuzzer but a set of tools. What makes it so good is that it doesn't just
blindly send random input to your program hoping for it to crash; it inspects the execution paths
of the program and uses that information to figure out which mutations to apply to the previous
inputs to trigger new execution paths. This approach allows for much more efficient and reliable
fuzzing (as it will try to maximize coverage) but requires the binaries to be instrumented so the
execution can be monitored.</p>
<p>AFL provides wrappers for the common C compilers that you can use to produce the instrumented
binaries along with the CLI fuzzing client: <code>afl-fuzz</code>.</p>
<p><code>afl-fuzz</code> is straight-forward to use. It takes an input directory containing a few initial valid
inputs to your program, an output directory and the instrumented binary. It will then repeatedly
mutate the inputs and feed them to the program, registering the ones that lead to crashes or
hangs in the output directory.</p>
<p>Because it works in such a way, it makes it very easy to fuzz a parser.</p>
<p>To fuzz a <code>parse.exe</code> binary, that takes a file as its first command-line argument and parses it,
you can invoke <code>afl-fuzz</code> in the following way:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">$ afl-fuzz -i inputs/ -o findings/ /path/to/parse.exe @@</code></pre></div>
<p>The <code>findings/</code> directory is where <code>afl-fuzz</code> will write the crashes it finds, it will create it
for you if it doesn't exist.
The <code>inputs/</code> directory contains one or more valid input files for your
program. By valid we mean "that don't crash your program".
Finally the <code>@@</code> part tells <code>afl-fuzz</code> where on the command line the input file should be passed to
your program, in our case, as the first argument.</p>
<p>Note that it is possible to supply <code>afl-fuzz</code> with more detail about how to invoke your program. If
you need to pass it command-line options for instance, you can run it as:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">$ afl-fuzz -i inputs/ -o findings/ -- /path/to/parse.exe --option=value @@</code></pre></div>
<p>If you wish to fuzz a program that takes its input from standard input, you can also do that by removing the
<code>@@</code> from the <code>afl-fuzz</code> invocation.</p>
<p>Once <code>afl-fuzz</code> starts, it will draw a fancy looking table on the standard output to keep you
updated about its progress. From there, you'll mostly be interested in is the top right
corner which contains the number of crashes and hangs it has found so far:</p>
<p><span
      class="gatsby-resp-image-wrapper"
      style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; "
    >
      <a
    class="gatsby-resp-image-link"
    href="/static/893fd2c3d0dfbb1c576fd016b6963e96/f2793/afl_example_output.png"
    style="display: block"
    target="_blank"
    rel="noopener"
  >
    <span
    class="gatsby-resp-image-background-image"
    style="padding-bottom: 63.52941176470588%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAANCAYAAACpUE5eAAAACXBIWXMAAA7EAAAOxAGVKw4bAAACJklEQVQ4y2VT2ZKjMBAzGDBgcxsbch+bVO38//9p1UxSm519UBHibkktN0ophZ/oe4UQFIZBYRoV2j6BGkaigJpY0//f8xcFi+oaqqqgmgZplsPaDM7p7WmtRlVnyK2FrgpomyKpNBTfvyG9RJpCE8qQyHYdpnnGvK6wzuF++0WXI5ZlJXYIc8Qi5+O0uXBphoefcYsRlxBwtg0GUyHRJGzaFhP/9Dz0fDoSXi4XeO+x2+1I3G8iBacwMgkJuzzDV+vwNQ74PfZ4Fjl8nm8ulbhrSNbRXUs4CghZIPkwDBuBZnE5TXB02R72qI1FzAJW43E2OzjTQOkEOeNS7TjCkagnmmXZ3EQKCArmmyQJM6y/Bel45LOOrO88hSOC36F1LVLW5eKypwvJbqSjhuPdbzd4iiwkbOlWHFbMWWri4YCe7h2n2geP6xLRlMVWI8Jaa9mGcctvJoTweL2iEiLmIUVSXJYlIgUDRxbnDQX2rH1OHnuS/0NY8Oot1TuOayQ7Eg6nEwY2S4ajRMIYUlmLLEPGJm0MKpnofIahQM5oZGW2kQcqHZhNIFnLxsf9jkgyGf3EhjvfxeHn8krjKjmzp+fuGgpslycOG/6xknCWG+Soj+cTkW5ldVqeyXlGZ5+ENS/pcDxum9Bx5HkOSNRrZBlFGoTwvYOS00LS7pXPO6PPTGU/pV5qVvkgJn5J2YvwJ0RJIELv359nb2KB5R2YkiN3FE0T/AEuPil/sTnzzAAAAABJRU5ErkJggg=='); background-size: cover; display: block;"
  ></span>
  <img
        class="gatsby-resp-image-image"
        alt="Example output from afl-fuzz"
        title="Example output from afl-fuzz"
        src="/static/893fd2c3d0dfbb1c576fd016b6963e96/c5bb3/afl_example_output.png"
        srcset="/static/893fd2c3d0dfbb1c576fd016b6963e96/04472/afl_example_output.png 170w,
/static/893fd2c3d0dfbb1c576fd016b6963e96/9f933/afl_example_output.png 340w,
/static/893fd2c3d0dfbb1c576fd016b6963e96/c5bb3/afl_example_output.png 680w,
/static/893fd2c3d0dfbb1c576fd016b6963e96/f2793/afl_example_output.png 743w"
        sizes="(max-width: 680px) 100vw, 680px"
        style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;"
        loading="lazy"
      />
  </a>
    </span></p>
<p>You might need to change some of your CPU settings to achieve better performance while fuzzing.
<code>afl-fuzz</code>'s output will tell you if that's the case and guide you through the steps required to
make that happen.</p>
<h2 id="using-afl-to-fuzz-an-ocaml-parser" style="position:relative;"><a href="#using-afl-to-fuzz-an-ocaml-parser" aria-label="using afl to fuzz an ocaml parser permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Using AFL to fuzz an OCaml parser</h2>
<p>First of all, if you want to fuzz an OCaml program with AFL you'll need to produce an instrumented
binary. <code>afl-fuzz</code> has an option to work with regular binaries but you'd lose a lot of what makes it
efficient. To instrument your binary you can simply install a <code>+afl</code> opam switch and build your
executable from there. AFL compiler variants are available from OCaml <code>4.05.0</code> onwards. To install such
a switch you can run:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">$ opam switch create fuzzing-switch 4.07.1+afl</code></pre></div>
<p>If your program already parses the standard input or a file given to it via the command line, you
can simply build the executable from your <code>+afl</code> switch and adapt the above examples. If it doesn't,
it's still easy to fuzz any parsing function.</p>
<p>Imagine we have a <code>simple-parser</code> library which exposes the following <code>parse_int</code> function:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">val</span> parse_int<span class="token punctuation">:</span> string <span class="token operator">-></span> <span class="token punctuation">(</span>int<span class="token punctuation">,</span> <span class="token punctuation">[</span><span class="token operator">></span> <span class="token variant variable">`Msg</span> <span class="token keyword">of</span> string<span class="token punctuation">]</span><span class="token punctuation">)</span> result
<span class="token comment">(** Parse the given string as an int or return [Error (`Msg _)].
    Does not raise, usually... *)</span></code></pre></div>
<p>We want to use AFL to make sure our function is robust and won't crash when receiving unexpected
inputs. As you can see the function returns a result and isn't supposed to raise exceptions. We want
to make sure that's true.</p>
<p>To find crashes, AFL traps the signals sent by your program. That means that it will consider
uncaught OCaml exceptions as crashes. That's good because it makes it really simple to write a
<code>fuzz_me.ml</code> executable that fits what <code>afl-fuzz</code> expects:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">=</span>
  <span class="token keyword">let</span> file <span class="token operator">=</span> <span class="token module variable">Sys</span><span class="token punctuation">.</span>argv<span class="token punctuation">.</span><span class="token punctuation">(</span><span class="token number">1</span><span class="token punctuation">)</span> <span class="token keyword">in</span>
  <span class="token keyword">let</span> ic <span class="token operator">=</span> open_in file <span class="token keyword">in</span>
  <span class="token keyword">let</span> length <span class="token operator">=</span> in_channel_length ic <span class="token keyword">in</span>
  <span class="token keyword">let</span> content <span class="token operator">=</span> really_input_string ic length <span class="token keyword">in</span>
  close_in ic<span class="token punctuation">;</span>
  ignore <span class="token punctuation">(</span><span class="token module variable">Simple_parser</span><span class="token punctuation">.</span>parse_int content<span class="token punctuation">)</span></code></pre></div>
<p>We have to provide example inputs to AFL so we can write a <code>valid</code> file to the <code>inputs/</code> directory
containing <code>123</code> and an <code>invalid</code> file containing <code>not an int</code>. Both should parse without crashing
and make good starting point for AFL as they should trigger different execution paths.</p>
<p>Because we want to make sure AFL does find crashes we can try to hide a bug in our function:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> parse_int s <span class="token operator">=</span>
  <span class="token keyword">match</span> <span class="token module variable">List</span><span class="token punctuation">.</span>init <span class="token punctuation">(</span><span class="token module variable">String</span><span class="token punctuation">.</span>length s<span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token module variable">String</span><span class="token punctuation">.</span>get s<span class="token punctuation">)</span> <span class="token keyword">with</span>
  <span class="token operator">|</span> <span class="token punctuation">[</span><span class="token string">'a'</span><span class="token punctuation">;</span> <span class="token string">'b'</span><span class="token punctuation">;</span> <span class="token string">'c'</span><span class="token punctuation">]</span> <span class="token operator">-></span> failwith <span class="token string">"secret crash"</span>
  <span class="token operator">|</span> <span class="token punctuation">_</span> <span class="token operator">-></span> <span class="token punctuation">(</span>
      <span class="token keyword">match</span> int_of_string_opt s <span class="token keyword">with</span>
      <span class="token operator">|</span> <span class="token module variable">None</span> <span class="token operator">-></span> <span class="token module variable">Error</span> <span class="token punctuation">(</span><span class="token variant variable">`Msg</span> <span class="token punctuation">(</span><span class="token module variable">Printf</span><span class="token punctuation">.</span>sprintf <span class="token string">"Not an int: %S"</span> s<span class="token punctuation">)</span><span class="token punctuation">)</span>
      <span class="token operator">|</span> <span class="token module variable">Some</span> i <span class="token operator">-></span> <span class="token module variable">Ok</span> i<span class="token punctuation">)</span></code></pre></div>
<p>Now we just have to build our native binary from the right switch and let <code>afl-fuzz</code> do the rest:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">$ afl-fuzz -i inputs/ -o findings/ ./fuzz_me.exe @@</code></pre></div>
<p>It should find that the <code>abc</code> input leads to a crash rather quickly. Once it does, you'll see it in
the top right corner of its output as shown in the picture from the previous section.</p>
<p>At this point you can interrupt <code>afl-fuzz</code> and have a look at the content of the <code>findings/crashes</code>:</p>
<div class="gatsby-highlight" data-language="sh"><pre class="language-sh"><code class="language-sh">$ ls findings/crashes/
id:000000,sig:06,src:000111,op:havoc,rep:16  README.txt</code></pre></div>
<p>As you can see it contains a <code>README.txt</code> which will give you some details about the <code>afl-fuzz</code>
invocation used to find the crashes and how to reproduce them in the folder and a file of the form
<code>id:...,sig:...,src:...,op:...,rep:...</code> per crash it found. Here there's just one:</p>
<div class="gatsby-highlight" data-language="sh"><pre class="language-sh"><code class="language-sh">$ cat findings/crashes/id:000000,sig:06,src:000111,op:havoc,rep:16
abc</code></pre></div>
<p>As expected it contains our special input that triggers our secret crash. We can rerun the program
with that input ourselves to make sure it does trigger it:</p>
<div class="gatsby-highlight" data-language="sh"><pre class="language-sh"><code class="language-sh">$ ./fuzz_me.exe findings/crashes/id:000000,sig:06,src:000111,op:havoc,rep:16
Fatal error: exception Failure(&quot;secret crash&quot;)</code></pre></div>
<p>No surprise here, it does trigger our uncaught exception and crashes shamefully.</p>
<h2 id="using-crowbar-and-afl-for-property-based-testing" style="position:relative;"><a href="#using-crowbar-and-afl-for-property-based-testing" aria-label="using crowbar and afl for property based testing permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Using Crowbar and AFL for property-based testing</h2>
<p>This works well but only being able to fuzz parsers is quite a limitation. That's where <a href="https://github.com/stedolan/crowbar/">Crowbar</a>
comes into play.</p>
<p>Crowbar is a property-based testing framework. It's much like Haskell's <a href="http://hackage.haskell.org/package/QuickCheck">QuickCheck</a>.
To test a given function, you define how its arguments are shaped, a set of properties the result
should satisfy and it will make sure they hold with any combinations of randomly generated
arguments.
Let's clarify that with an example.</p>
<p>I wrote a library called <code>Awesome_list</code> and I want to test its <code>sort</code> function:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">val</span> sort<span class="token punctuation">:</span> int list <span class="token operator">-></span> int list
<span class="token comment">(** Sorts the given list of integers. Result list is sorted in increasing
    order, most of the time... *)</span></code></pre></div>
<p>I want to make sure it really works so I'm going to use Crowbar to generate a whole lot of
lists of integers and verify that when I sort them with <code>Awesome_list.sort</code> the result is, well...
sorted.</p>
<p>We'll write our tests in a <code>fuzz_me.ml</code> file.
First we need to tell Crowbar how to generate arguments for our function. It exposes some
combinators to help you do that:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> int_list <span class="token operator">=</span> <span class="token module variable">Crowbar</span><span class="token punctuation">.</span><span class="token punctuation">(</span>list <span class="token punctuation">(</span>range <span class="token number">10</span><span class="token punctuation">)</span><span class="token punctuation">)</span></code></pre></div>
<p>Here we're telling Crowbar to generate lists of any size, containing integers ranging from 0
to 10. Crowbar also exposes more complex and custom generator combinators so don't worry,
you can use it to build more complex arguments.</p>
<p>Now we need to define our property. Once again it's pretty simple, we just want the output to be
sorted:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> is_sorted l <span class="token operator">=</span>
  <span class="token keyword">let</span> <span class="token keyword">rec</span> is_sorted <span class="token operator">=</span> <span class="token keyword">function</span>
    <span class="token operator">|</span> <span class="token punctuation">[</span><span class="token punctuation">]</span> <span class="token operator">|</span> <span class="token punctuation">[</span><span class="token punctuation">_</span><span class="token punctuation">]</span> <span class="token operator">-></span> <span class="token boolean">true</span>
    <span class="token operator">|</span> hd<span class="token punctuation">:</span><span class="token punctuation">:</span><span class="token punctuation">(</span>hd'<span class="token punctuation">:</span><span class="token punctuation">:</span><span class="token punctuation">_</span> <span class="token keyword">as</span> tl<span class="token punctuation">)</span> <span class="token operator">-></span> hd <span class="token operator">&lt;=</span> hd' <span class="token operator">&amp;&amp;</span> is_sorted tl
  <span class="token keyword">in</span>
  <span class="token module variable">Crowbar</span><span class="token punctuation">.</span>check <span class="token punctuation">(</span>is_sorted l<span class="token punctuation">)</span></code></pre></div>
<p>All that's left to do now is to register our test:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">=</span>
  <span class="token module variable">Crowbar</span><span class="token punctuation">.</span>add_test <span class="token label function">~name</span><span class="token punctuation">:</span><span class="token string">"Awesome_list.sort"</span> <span class="token punctuation">[</span>int_list<span class="token punctuation">]</span>
      <span class="token punctuation">(</span><span class="token keyword">fun</span> l <span class="token operator">-></span> is_sorted <span class="token punctuation">(</span><span class="token module variable">Awesome_list</span><span class="token punctuation">.</span>sort l<span class="token punctuation">)</span><span class="token punctuation">)</span></code></pre></div>
<p>and to compile that <code>fuzz_me.ml</code> file to a binary. Crowbar will take care of the magic.</p>
<p>We can run that binary in "Quickcheck" mode where it will either try a certain amount of random
inputs or keep trying until one of the properties breaks depending on the command-line options
we pass it.
What we're interested in here is its less common "AFL" mode. Crowbar made it so our executable
can be used with <code>afl-fuzz</code> just like that:</p>
<div class="gatsby-highlight" data-language="sh"><pre class="language-sh"><code class="language-sh">$ afl-fuzz -i inputs -o findings -- ./fuzz_me.exe @@</code></pre></div>
<p>What will happen then is that our <code>fuzz_me.exe</code> binary will read the inputs provided by <code>afl-fuzz</code>
and use it to determine which test to run and how to generate the arguments to pass to our function.
If the properties are satisfied, the binary will exit normally; if they aren't, it will make sure
that <code>afl-fuzz</code> interprets that as a crash by raising an exception.</p>
<p>A nice side-effect of Crowbar's approach is that <code>afl-fuzz</code> will still be able to pick up
crashes. For instance, if we implement <code>Awesome_list.sort</code> as:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> sort <span class="token operator">=</span> <span class="token keyword">function</span>
  <span class="token operator">|</span> <span class="token punctuation">[</span><span class="token number">1</span><span class="token punctuation">;</span> <span class="token number">2</span><span class="token punctuation">;</span> <span class="token number">3</span><span class="token punctuation">]</span> <span class="token operator">-></span> failwith <span class="token string">"secret crash"</span>
  <span class="token operator">|</span> <span class="token punctuation">[</span><span class="token number">4</span><span class="token punctuation">;</span> <span class="token number">5</span><span class="token punctuation">;</span> <span class="token number">6</span><span class="token punctuation">]</span> <span class="token operator">-></span> <span class="token punctuation">[</span><span class="token number">6</span><span class="token punctuation">;</span> <span class="token number">5</span><span class="token punctuation">;</span> <span class="token number">4</span><span class="token punctuation">]</span>
  <span class="token operator">|</span> l <span class="token operator">-></span> <span class="token module variable">List</span><span class="token punctuation">.</span>sort <span class="token module variable">Pervasives</span><span class="token punctuation">.</span>compare l</code></pre></div>
<p>and use AFL and Crowbar to fuzz-test our function, it will find two crashes: one for the input
<code>[1; 2; 3]</code> which triggers a crash and one for <code>[4; 5; 6]</code> for which the <code>is_sorted</code>
property won't hold.</p>
<p>The content of the input files found by <code>afl-fuzz</code> itself won't be of much help as it needs to be
interpreted by Crowbar to build the arguments that were passed to the function to trigger the bug.
We can invoke the <code>fuzz_me.exe</code> binary ourselves on one of the files in <code>findings/crashes</code>
and the Crowbar binary will replay the test and give us some more helpful information about what
exactly is going on:</p>
<div class="gatsby-highlight" data-language="sh"><pre class="language-sh"><code class="language-sh">$ ./fuzz_me.exe findings/crashes/id\\:000000\\,sig\\:06\\,src\\:000011\\,op\\:flip1\\,pos\\:5 
Awesome_list.sort: ....
Awesome_list.sort: FAIL

When given the input:

    [1; 2; 3]
    
the test threw an exception:

    Failure(&quot;secret crash&quot;)
    Raised at file &quot;stdlib.ml&quot;, line 33, characters 17-33
    Called from file &quot;awesome-list/fuzz/fuzz_me.ml&quot;, line 11, characters 78-99
    Called from file &quot;src/crowbar.ml&quot;, line 264, characters 16-19
    
Fatal error: exception Crowbar.TestFailure
$ ./fuzz_me.exe findings/crashes/id\\:000001\\,sig\\:06\\,src\\:000027\\,op\\:arith16\\,pos\\:5\\,val\\:+7 
Awesome_list.sort: ....
Awesome_list.sort: FAIL

When given the input:

    [4; 5; 6]
    
the test failed:

    check false
    
Fatal error: exception Crowbar.TestFailure</code></pre></div>
<p>We can see the actual inputs as well as distinguish the one that broke the invariant from the one
that triggered a crash.</p>
<h2 id="using-bun-to-run-fuzz-testing-in-ci" style="position:relative;"><a href="#using-bun-to-run-fuzz-testing-in-ci" aria-label="using bun to run fuzz testing in ci permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Using <code>bun</code> to run fuzz testing in CI</h2>
<p>While AFL and Crowbar provide no guarantees they can give you confidence that your implementation
is not broken. Now that you know how to use them, a natural follow-up is to want to run fuzz tests
in your CI to enforce that level of confidence.</p>
<p>Problem is, AFL isn't very CI friendly. First it has this refreshing output that isn't going to look
great on your travis builds output and it doesn't tell you much besides that it could or couldn't find
crashes or invariant infrigements</p>
<p>Hopefully, like most problems, this one has a solution:
<a href="https://github.com/yomimono/ocaml-bun/"><code>bun</code></a>.
<code>bun</code> is a CLI wrapper around <code>afl-fuzz</code>, written in OCaml, that helps you get the best out of AFL
effortlessly. It mostly does two things:</p>
<p>The first is that it will run several <code>afl-fuzz</code> processes in parallel
(one per core by default). <code>afl-fuzz</code> starts with a bunch of deterministic steps. In my experience,
using parallel processes during this phase rarely proved very useful as they tend to find the same
bugs or slight variations of those bugs. It only achieves its full potential in the second phase of
fuzzing.</p>
<p>The second thing, which is the one we're the most interested in, is that <code>bun</code> provides a useful
and CI-friendly summary of what's going on with all the fuzzing processes so far. When one of them
finds a crash, it will stop all processes and pretty-print all of the bug-triggering inputs to help
you reproduce and debug them locally. See an example <code>bun</code> output after a crash was found:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">Crashes found! Take a look; copy/paste to save for reproduction:
1432	echo JXJpaWl0IA== | base64 -d &gt; crash_0.$(date -u +%s)
1433	echo NXJhkV8QAA== | base64 -d &gt; crash_1.$(date -u +%s)
1434	echo J3Jh//9qdGFiYmkg | base64 -d &gt; crash_2.$(date -u +%s)
1435	09:35.32:[ERROR]All fuzzers finished, but some crashes were found!</code></pre></div>
<p>Using <code>bun</code> is very similar to using <code>afl-fuzz</code>. Going back to our first parser example, we can
fuzz it with <code>bun</code> like this:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">$ bun --input inputs/ --output findings/ /path/to/parse.exe</code></pre></div>
<p>You'll note that you don't need to provide the <code>@@</code> anymore. <code>bun</code> assumes that it should pass the
input as the first argument of your to-be-fuzzed binary.</p>
<p><code>bun</code> also comes with an alternative <code>no-kill</code> mode which lets all the fuzzers run indefinitely
instead of terminating them whenever a crash is discovered. It will regularly keep you updated on
the number of crashes discovered so far and when terminated will pretty-print each of them just like
it does in regular mode.</p>
<p>This mode can be convenient if you suspect your implementation may contain a lot of bugs and
you don't want to go through the whole process of fuzz testing it to only find a single bug.</p>
<p>You can use it in CI by running <code>bun --no-kill</code> via <code>timeout</code>. For instance:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">timeout --preserve-status 60m bun --no-kill --input inputs --output findings ./fuzz_me.exe</code></pre></div>
<p>will fuzz <code>fuzz_me.exe</code> for an hour no matter what happens. When <code>timeout</code> terminates <code>bun</code>, it will
provide you with a handful of bugs to fix!</p>
<h2 id="final-words" style="position:relative;"><a href="#final-words" aria-label="final words permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Final words</h2>
<p>I really want to encourage you to use those tools and fuzzing in general.
Crowbar and <code>bun</code> are fairly new so you will probably encounter bugs or find that it lacks a feature
you want but combined with AFL they make for very nice tools to effectively test
critical components of your OCaml code base or infrastructure and detect newly-introduced bugs.
They are already used accross the MirageOS ecosystem where it has been used to fuzz the TCP/IP stack
<a href="https://github.com/mirage/mirage-tcpip">mirage-tcpip</a> and the DHCP implementation <a href="https://github.com/mirage/charrua">charrua</a> thanks to
<a href="https://github.com/yomimono/somerandompacket">somerandompacket</a>.
You can consult Crowbar's <a href="https://github.com/stedolan/crowbar/issues/2">hall of fame</a> to find out about bugs uncovered by this
approach.</p>
<p>I also encourage anyone interested to join us in using this promising toolchain, report those bugs,
contribute those extra features and help the community build more robust software.</p>
<p>Finally if you wish to learn more about how to efficienly use fuzzing for testing I recommend the
excellent <a href="https://blog.regehr.org/archives/1687">Write Fuzzable Code</a> article by John Regehr.</p>|js}
  };
 
  { title = {js|An introduction to OCaml PPX ecosystem|js}
  ; slug = {js|an-introduction-to-ocaml-ppx-ecosystem|js}
  ; description = Some {js|These last few months, I spent some time writing new OCaml PPX rewriters or contributing to existing
ones. It's a really fun experience…|js}
  ; url = {js|https://tarides.com/blog/2019-05-09-an-introduction-to-ocaml-ppx-ecosystem|js}
  ; date = {js|2019-05-09T00:00:00-00:00|js}
  ; preview_image = Some {js|https://tarides.com/static/0e8e776eb4ab9f596324bfe7e318b854/2244e/circuit_boards.jpg|js}
  ; body_html = {js|<p>These last few months, I spent some time writing new OCaml PPX rewriters or contributing to existing
ones. It's a really fun experience. Toying around with the AST taught me a lot about a language I
thought I knew really well. Turns out I actually had no idea what I was doing all these years.</p>
<p>All jokes aside, I was surprised that the most helpful tricks I learned while writing PPX rewriters
weren't properly documented. There already exist a few very good introduction articles on the
subject, like that
<a href="https://whitequark.org/blog/2014/04/16/a-guide-to-extension-points-in-ocaml/">2014's article from Whitequark</a>,
this <a href="http://rgrinberg.com/posts/extensions-points-update-1/">more recent one from Rudi Grinberg</a>
or even <a href="https://victor.darvariu.me/jekyll/update/2018/06/19/ppx-tutorial.html">this last one from Victor Darvariu</a>
I only discovered after I actually started writing my own. I still felt like they were slightly
outdated or weren't answering all the questions I had when I started playing with PPX and writing my
first rewriters.</p>
<p>I decided to share my PPX adventures in the hope that it can help others familiarize with this bit
of the OCaml ecosystem and eventually write their first rewriters. The scope of this article is not to
cover every single detail about the PPX internals but just to give a gentle introduction to
beginners to help them get settled. That also means I might omit things that I don't think are worth
mentioning or that might confuse the targetted audience but feel free to comment if you believe
this article missed an important point.</p>
<p>It's worth mentioning that a lot of the nice tricks mentioned in these lines were given to me by a
wonderful human being called Étienne Millon, thanks Étienne!</p>
<h2 id="what-is-a-ppx" style="position:relative;"><a href="#what-is-a-ppx" aria-label="what is a ppx permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>What is a PPX?</h2>
<p>PPX rewriters or PPX-es are preprocessors that are applied to your code before passing it on to the
compiler. They don't operate on your code directly but on the Abstract Syntax Tree or AST resulting
from its parsing. That means that they can only be applied to syntactically correct OCaml code. You
can think of them as functions that take an AST and return a new AST.</p>
<p>That means that in theory you can do a lot of things with a PPX, including pretty bad and cryptic
things. You could for example replace every instance of <code>true</code> by <code>false</code>, swap the branches of any
<code>if-then-else</code> or randomize the order of every pattern-matching case.
Obviously that's not the kind of behaviour that we want as it would make it impossible to
understand the code since it would be so far from the actual AST the compiler would get.
In practice PPX-es have a well defined scope and only transform parts you explicitly annotated.</p>
<h3 id="understanding-the-ocaml-ast" style="position:relative;"><a href="#understanding-the-ocaml-ast" aria-label="understanding the ocaml ast permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Understanding the OCaml AST</h3>
<p>First things first, what is an AST. An AST is an abstract representation of your code. As the name
suggests it has a tree-like structure where the root describes your entire file. It has children for
each bits such as a function declaration or a type definition, each of them having their own
children, for example for the function name, its argument and its body and that goes on until you
reach a leaf such as a literal <code>1</code>, <code>"abc"</code> or a variable for instance.
In the case of OCaml it's a set of recursive types allowing us to represent OCaml code as an OCaml
value. This value is what the parser passes to the compiler so it can type check and compile it to
native or byte code.
Those types are defined in OCaml's <code>Parsetree</code> module. The entry points there are the <code>structure</code>
type which describes the content of an <code>.ml</code> file and the <code>signature</code> type which describes the
content of an <code>.mli</code> file.</p>
<p>As mentionned above, a PPX can be seen as a function that transforms an AST. Writing a PPX thus
requires you to understand the AST, both to interpret the one you'll get as input and
to produce the right one as output. This is probably the trickiest part as unless you've already
worked on the OCaml compiler or written a PPX rewriter, that will probably be the first time you two
meet. Chances are also high that'll be a pretty bad first date and you will need some to time
to get to know each other.</p>
<p>The <code>Parsetree</code> module <a href="https://caml.inria.fr/pub/docs/manual-ocaml/compilerlibref/Parsetree.html">documentation</a>,
is a good place to start. The above mentioned <code>structure</code> and <code>signature</code> types are at the root of
the AST but some other useful types to look at at first are:</p>
<ul>
<li><code>expression</code> which describes anything in OCaml that evaluates to a value, the right hand side of a
<code>let</code> binding for instance.</li>
<li><code>pattern</code> which is what you use to deconstruct an OCaml value, the left hand side of a <code>let</code>
binding or a pattern-matching case for example.</li>
<li><code>core_type</code> which describes type expressions ie what you would find on the right hand side of a
value description in a <code>.mli</code>, ie <code>val f : &#x3C;what_goes_there></code>.</li>
<li><code>structure_item</code> and <code>signature_item</code> which describe the top level AST nodes you can find in a
<code>structure</code> or <code>signature</code> such as type definitions, value or module declarations.</li>
</ul>
<p>Thing is, it's a bit a rough and there's no detailed explanation about how a specific bit of code is
represented, just type definitions. Most of the time, the type, field, and variant names are
self-explanatory but it can get harder with some of the more advanced language features.
It turns out there are plenty of comments that are really helpful in the actual <code>parsetree.mli</code> file
and that aren't part of the generated documentation. You can find them on
<a href="https://github.com/ocaml/ocaml/blob/trunk/parsing/parsetree.mli">github</a> but I personally prefer to
have it opened in a VIM tab when I work on a PPX so I usually open
<code>~/.opam/&#x3C;current_working_switch>/lib/ocaml/compiler-libs/parsetree.mli</code>.</p>
<p>This works well while exploring but you might also want a more straightforward approach to
discovering what the AST representation is for some specific OCaml code. The
<a href="https://github.com/ocaml-ppx/ppx_tools"><code>ppx_tools</code></a> opam package comes with a <code>dumpast</code> binary
that pretty prints the AST for any given piece of valid OCaml code. You can install it using opam:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">$opam install ppx_tools</code></pre></div>
<p>and then run it using <code>ocamlfind</code>:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">$ocamlfind ppx_tools/dumpast some_file.ml</code></pre></div>
<p>You can use it on <code>.ml</code> and <code>.mli</code> files or to quickly get the AST for an expression with the <code>-e</code>
option:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">$ocamlfind ppx_tools/dumpast -e &quot;1 + 1&quot;</code></pre></div>
<p>Similarly, you can use the <code>-t</code> or <code>-p</code> options to respectively pretty print ASTs from type
expressions or patterns.</p>
<p>Using <code>dumpast</code> to get both the ASTs of a piece of code using your future PPX and the resulting
preprocessed code is a good way to start and will help you figure out what are the steps required to
get there.</p>
<p>Note that you can use the compiler or <code>utop</code> have a similar feature with the <code>-dparsetree</code> flag.
Running <code>ocamlc/ocamlopt -dparsetree file.ml</code> will pretty print the AST of the given file while
running <code>utop -dparsetree</code> will pretty print the AST of the evaluated code alongside it's
evaluation.
I tend to prefer the pretty printed AST from <code>dumpast</code> but any of these tools will prove helpful
in understanding the AST representation of a given piece of OCaml code.</p>
<h3 id="language-extensions-interpreted-by-ppx-es" style="position:relative;"><a href="#language-extensions-interpreted-by-ppx-es" aria-label="language extensions interpreted by ppx es permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Language extensions interpreted by PPX-es</h3>
<p>OCaml 4.02 introduced syntax extensions meant to be used by external tools such as PPX-es. Knowing
their syntax and meaning is important to understand how most of the existing rewriters
work because they usually look for those language extensions in the AST to know which part of it
they need to modify.</p>
<p>The two language extensions we're interested in here are extension nodes and attributes. They are
defined in detail in the OCaml manual (see the
<a href="https://caml.inria.fr/pub/docs/manual-ocaml/attributes.html">attributes</a> and
<a href="https://caml.inria.fr/pub/docs/manual-ocaml/extensionnodes.html">extension nodes</a> sections) but I'll
try to give a good summary here.</p>
<p>Extension nodes are used in place of expressions, module expressions, patterns, type expressions or
module type expressions. Their syntax is <code>[%extension_name payload]</code>. We'll come back to the payload
part a little later.
You can also find extension nodes at the top level of modules or module signatures with the syntax
<code>[%%extension_name payload]</code>.
Hopefully the following cheatsheet can help you remember the basics of how and where you can use
them:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">type</span> t <span class="token operator">=</span>
  <span class="token punctuation">{</span> a <span class="token punctuation">:</span> int
  <span class="token punctuation">;</span> b <span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token operator">%</span>ext pl<span class="token punctuation">]</span>
  <span class="token punctuation">}</span>

<span class="token keyword">let</span> x <span class="token operator">=</span>
  <span class="token keyword">match</span> <span class="token number">1</span> <span class="token keyword">with</span>
  <span class="token operator">|</span> <span class="token number">0</span> <span class="token operator">-></span> <span class="token punctuation">[</span><span class="token operator">%</span>ext pl<span class="token punctuation">]</span>
  <span class="token operator">|</span> <span class="token punctuation">[</span><span class="token operator">%</span>ext pl<span class="token punctuation">]</span> <span class="token operator">-></span> <span class="token boolean">true</span>

<span class="token punctuation">[</span><span class="token operator">%%</span>ext pl<span class="token punctuation">]</span></code></pre></div>
<p>Because extension nodes stand where regular AST nodes should, the compiler won't accept them and
will give you an <code>Uninterpreted extension</code> error. Extension nodes have to be expanded by a PPX for
your code to compile.</p>
<p>Attributes are slightly different although their syntax is very close to extensions. Attributes
are attached to existing AST nodes instead of replacing them. That means that they don't necessarily
need to be transformed and the compiler will ignore unknown attributes by default.
They can come with a payload just like extensions and use <code>@</code> instead of <code>%</code>. The number of <code>@</code>
preceding the attribute name specifies which kind of node they are attached to:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> a <span class="token operator">=</span> <span class="token number">12</span> <span class="token punctuation">[</span><span class="token operator">@</span>attr pl<span class="token punctuation">]</span>

<span class="token keyword">let</span> b <span class="token operator">=</span> <span class="token string">"some string"</span> <span class="token punctuation">[</span><span class="token operator">@@</span>attr pl<span class="token punctuation">]</span>

<span class="token punctuation">[</span><span class="token operator">@@@</span>attr pl<span class="token punctuation">]</span></code></pre></div>
<p>In the first example, the attribute is attached to the expression <code>12</code> while in the second example
it is attached to the whole <code>let b = "some string"</code> value binding. The third one is of a slightly
different nature as it is a floating attribute. It's not attached to anything per-se and just ends
up in the AST as a structure item.
Because there is a wide variety of nodes to which you can attach attributes, I won't go too far into
details here but a good rule of thumb is that you use <code>@@</code> attributes when you want them attached to
structure or signature items, for anything deeper within the AST structure such as patterns,
expressions or core types, use the single <code>@</code> syntax. Looking at the <code>Parsetree</code> documentation can
help you figure out where you can find attributes.</p>
<p>Now let's talk about those payloads I mentioned earlier. You can think of them as "arguments" to
the extension points and attributes. You can pass different kinds of arguments and the syntax varies
for each of them:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> a <span class="token operator">=</span> <span class="token punctuation">[</span><span class="token operator">%</span>ext expr_or_str_item<span class="token punctuation">]</span> 
<span class="token keyword">let</span> b <span class="token operator">=</span> <span class="token punctuation">[</span><span class="token operator">%</span>ext<span class="token punctuation">:</span> type_expr_or_sig_item<span class="token punctuation">]</span>
<span class="token keyword">let</span> c <span class="token operator">=</span> <span class="token punctuation">[</span><span class="token operator">%</span>ext<span class="token operator">?</span> pattern<span class="token punctuation">]</span></code></pre></div>
<p>As suggested in the examples, you can pass expressions or structure items using a space character,
type expressions or signature items (anything you'd find at the top level of a module signature)
using a <code>:</code> or a pattern using a <code>?</code>.</p>
<p>Attributes' payload use the same syntax:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> a <span class="token operator">=</span> <span class="token string">'a'</span> <span class="token punctuation">[</span><span class="token operator">@</span>attr expr_or_str_item<span class="token punctuation">]</span>
<span class="token keyword">let</span> b <span class="token operator">=</span> <span class="token string">'b'</span> <span class="token punctuation">[</span><span class="token operator">@</span>attr<span class="token punctuation">:</span> type_expr_or_sig_item<span class="token punctuation">]</span>
<span class="token keyword">let</span> a <span class="token operator">=</span> <span class="token string">'a'</span> <span class="token punctuation">[</span><span class="token operator">@</span>attr<span class="token operator">?</span> pattern<span class="token punctuation">]</span></code></pre></div>
<p>Some PPX-es rely on other language extensions such as the suffix character you can attach to <code>int</code>
and <code>float</code> literals (<code>10z</code> could be used by a PPX to turn it into <code>Z.of_string "10"</code> for instance)
or quoted strings with a specific identifier (<code>{ppx_name|some quoted string|ppx_name}</code> can be used
if you want your PPX to operate on arbitrary strings and not only syntactically correct OCaml) but
attributes and extensions are the most commonly used ones.</p>
<p>Attributes and extension points can be expressed using an infix syntax. The attribute version is
barely used but some forms of the infix syntax for extension points are used by popular PPX-es and
it is likely you will encounter some of the following:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> infix_let_extension <span class="token operator">=</span>
  <span class="token keyword">let</span><span class="token operator">%</span>ext x <span class="token operator">=</span> <span class="token number">2</span> <span class="token keyword">in</span>
  <span class="token punctuation">.</span><span class="token punctuation">.</span><span class="token punctuation">.</span>

<span class="token keyword">let</span> infix_match_extension <span class="token operator">=</span>
  <span class="token keyword">match</span><span class="token operator">%</span>ext y <span class="token keyword">with</span> <span class="token punctuation">.</span><span class="token punctuation">.</span><span class="token punctuation">.</span>

<span class="token keyword">let</span> infix_try_extension <span class="token operator">=</span>
  <span class="token keyword">try</span><span class="token operator">%</span>ext f z <span class="token keyword">with</span> <span class="token punctuation">_</span> <span class="token operator">-></span> <span class="token punctuation">.</span><span class="token punctuation">.</span><span class="token punctuation">.</span></code></pre></div>
<p>which are syntactic sugar for:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> infix_let_extension <span class="token operator">=</span>
  <span class="token punctuation">[</span><span class="token operator">%</span>ext <span class="token keyword">let</span> x <span class="token operator">=</span> <span class="token number">2</span> <span class="token keyword">in</span> <span class="token punctuation">.</span><span class="token punctuation">.</span><span class="token punctuation">.</span><span class="token punctuation">]</span>

<span class="token keyword">let</span> infix_match_extension <span class="token operator">=</span>
  <span class="token punctuation">[</span><span class="token operator">%</span>ext <span class="token keyword">match</span> y <span class="token keyword">with</span> <span class="token punctuation">.</span><span class="token punctuation">.</span><span class="token punctuation">.</span><span class="token punctuation">]</span>

<span class="token keyword">let</span> infix_try_extension <span class="token operator">=</span>
  <span class="token punctuation">[</span><span class="token operator">%</span>ext <span class="token keyword">try</span> f z <span class="token keyword">with</span> <span class="token punctuation">_</span> <span class="token operator">-></span> <span class="token punctuation">.</span><span class="token punctuation">.</span><span class="token punctuation">.</span><span class="token punctuation">]</span></code></pre></div>
<p>A good example of a PPX making heavy use of these if
<a href="http://ocsigen.org/lwt/4.1.0/api/Ppx_lwt"><code>lwt_ppx</code></a>. The OCaml manual also contains more examples
of the infix syntax in the Attributes and Extension points sections mentioned above.</p>
<h3 id="the-two-main-kind-of-ppx-es" style="position:relative;"><a href="#the-two-main-kind-of-ppx-es" aria-label="the two main kind of ppx es permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>The two main kind of PPX-es</h3>
<p>There is a wide variety of PPX rewriters but the ones you'll probably see the most are Extensions and
Derivers.</p>
<h4 id="extensions" style="position:relative;"><a href="#extensions" aria-label="extensions permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Extensions</h4>
<p>Extensions will rewrite tagged parts of the AST, usually extension nodes of the form
<code>[%&#x3C;extension_name> payload]</code>. They will replace them with a different AST node of the same nature ie
if the extension point was located where an expression should be, the rewriter will produce an
expression. Good examples of extensions are:</p>
<ul>
<li><a href="https://github.com/rgrinberg/ppx_getenv2"><code>ppx_getenv2</code></a> which replaces <code>[%getenv SOME_VAR]</code> with
the value of the environment variable <code>SOME_VAR</code> at compile time.</li>
<li><a href="https://github.com/NathanReb/ppx_yojson"><code>ppx_yojson</code></a> which allows you to write <code>Yojson</code> values
using OCaml syntax to mimic actual json. For instance you'd use <code>[%yojson {a = None; b = 1}]</code> to
represent <code>{"a": null, "b": 1}</code> instead of the <code>Yojson</code>'s notation:
<code>Assoc [("a", Null); ("b", Int 1)]</code>.</li>
</ul>
<h4 id="derivers" style="position:relative;"><a href="#derivers" aria-label="derivers permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Derivers</h4>
<p>Derivers or deriving plugins will "insert" new nodes derived from type definitions annotated with a
<code>[@@deriving &#x3C;deriver_name>]</code> attribute. They have various applications but are particularly useful
to derive functions that are tedious and error prone to write by hand such as comparison functions,
pretty printers or serializers. It's really convenient as you don't have to update those functions
every time you update your type definitions. They were inspired by Haskell Type classes. Good
examples of derivers are:</p>
<ul>
<li><a href="https://github.com/ocaml-ppx/ppx_deriving"><code>ppx_deriving</code></a> itself comes with a bunch of deriving
plugins such as <code>eq</code>, <code>ord</code> or <code>show</code> which respectively derives, as you might have guessed,
equality, comparison and pretty-printing functions.</li>
<li><a href="https://github.com/ocaml-ppx/ppx_deriving_yojson"><code>ppx_deriving_yojson</code></a> which derives JSON
serializers and deserializers.</li>
<li><a href="https://github.com/janestreet/ppx_sexp_conv"><code>ppx_sexp_conv</code></a> which derives s-expressions
converters.</li>
</ul>
<p>Derivers often let you attach attributes to specify how some parts of the AST should be handled. For
example when using <code>ppx_deriving_yojson</code> you can use <code>[@default some_val]</code> to make a field of an
object optional:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">type</span> t <span class="token operator">=</span>
  <span class="token punctuation">{</span> a<span class="token punctuation">:</span> int
  <span class="token punctuation">;</span> b<span class="token punctuation">:</span> string <span class="token punctuation">[</span><span class="token operator">@</span>default <span class="token string">""</span><span class="token punctuation">]</span>
  <span class="token punctuation">}</span>
<span class="token punctuation">[</span><span class="token operator">@@</span>deriving of_yojson<span class="token punctuation">]</span></code></pre></div>
<p>will derive a deserializer that will convert the JSON value <code>{"a": 1}</code> to the OCaml
<code>{a = 1; b = ""}</code></p>
<h2 id="how-to-write-a-ppx-using-ppxlib" style="position:relative;"><a href="#how-to-write-a-ppx-using-ppxlib" aria-label="how to write a ppx using ppxlib permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>How to write a PPX using <code>ppxlib</code></h2>
<p>Historically there was a few libraries used by PPX rewriter authors to write their PPX-es, including
<code>ppx_tools</code> and <code>ppx_deriving</code> but as the eco-system evolved, <code>ppxlib</code> emerged and is now the most
up-to-date and maintained library to write and handle PPX-es. It wraps the features of those
libraries in a single one.
I encourage you to use <code>ppxlib</code> to write new PPX-es as it is also easier to make various rewriters
work together if they are all registered through <code>ppxlib</code> and the PPX ecosystem would gain from
being unified around a single PPX library and driver.</p>
<p>It is also a great library and has some really powerful features to help you write your extensions
and derivers.</p>
<h3 id="writing-an-extension" style="position:relative;"><a href="#writing-an-extension" aria-label="writing an extension permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Writing an extension</h3>
<p>The entry point of <code>ppxlib</code> for extensions is <code>Ppxlib.Extension.declare</code>. You have to use that
function to build an <code>Extension.t</code>, from which you can then build a <code>Context_free.Rule.t</code> before
registering your transformation so it's actually applied.</p>
<p>The typical <code>my_ppx_extension.ml</code> will look like:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">open</span> <span class="token module variable">Ppxlib</span>

<span class="token keyword">let</span> extension <span class="token operator">=</span>
  <span class="token module variable">Extension</span><span class="token punctuation">.</span>declare
    <span class="token string">"my_extension"</span>
    some_context
    some_pattern
    expand_function

<span class="token keyword">let</span> rule <span class="token operator">=</span> <span class="token module variable">Context_free</span><span class="token punctuation">.</span><span class="token module variable">Rule</span><span class="token punctuation">.</span>extension extension

<span class="token keyword">let</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">=</span>
  <span class="token module variable">Driver</span><span class="token punctuation">.</span>register_transformation <span class="token label function">~rules</span><span class="token punctuation">:</span><span class="token punctuation">[</span>rule<span class="token punctuation">]</span> <span class="token string">"my_transformation"</span></code></pre></div>
<p>To compile it as PPX rewriter you'll need to put the following in your dune file:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">(library
 (public_name my_ppx)
 (kind ppx_rewriter)
 (libraries ppxlib))</code></pre></div>
<p>Now let's go back a little and look at the important part:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> extension <span class="token operator">=</span>
  <span class="token module variable">Extension</span><span class="token punctuation">.</span>declare
    <span class="token string">"my_extension"</span>
    some_context
    some_pattern
    expand_function</code></pre></div>
<p>Here <code>"my_extension"</code> is the name of your extension and that define how you're going to invoke it
in your extension point. In other words, to use this extension in our code we'll use a
<code>[%my_extension ...]</code> extension point.</p>
<p><code>some_context</code> is a <code>Ppxlib.Extension.Context.t</code> and describes where this extension can be found in
the AST, ie can you use <code>[%my_extension ...]</code> as an expression, a pattern, a core type. The
<code>Ppxlib.Extension.Context</code> module defines a constant for each possible extension context which you
can pass as <code>some_context</code>.
This obviously means that it also describes the type of AST node to which it must be converted and
this property is actually enforced by the <code>some_pattern</code> argument. But we'll come back to that
later.</p>
<p>Finally <code>expand_function</code> is our actual extension implementation, which basically takes the payload,
a <code>loc</code> argument which contains the location of the expanded extension point, a <code>path</code> argument
which is the fully qualified path to the expanded node (eg. <code>"file.ml.A.B"</code>) and returns the
generated code to replace the extension with.</p>
<h4 id="ast_pattern" style="position:relative;"><a href="#ast_pattern" aria-label="ast_pattern permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Ast_pattern</h4>
<p>Now let's get back to that <code>some_pattern</code> argument.</p>
<p>This is one of the trickiest parts of <code>ppxlib</code> to understand but it's also one its most
powerful features. The type for <code>Ast_pattern</code> is defined as <code>('a, 'b, 'c) t</code> where <code>'a</code> is
the type of AST nodes that are matched, <code>'b</code> is the type of the values you're extracting from the
node as a function type and <code>'c</code> is the return type of that last function. This sounded really
confusing to me at first and I'm guessing it might do to some of you too so let's give it a bit of
context.</p>
<p>Let's look at the type of <code>Extension.declare</code>:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">val</span> declare <span class="token punctuation">:</span>
  string <span class="token operator">-></span>
  <span class="token type-variable function">'context</span> <span class="token module variable">Context</span><span class="token punctuation">.</span>t <span class="token operator">-></span>
  <span class="token punctuation">(</span>payload<span class="token punctuation">,</span> <span class="token type-variable function">'a</span><span class="token punctuation">,</span> <span class="token type-variable function">'context</span><span class="token punctuation">)</span> <span class="token module variable">Ast_pattern</span><span class="token punctuation">.</span>t <span class="token operator">-></span>
  <span class="token punctuation">(</span>loc<span class="token punctuation">:</span><span class="token module variable">Location</span><span class="token punctuation">.</span>t <span class="token operator">-></span> path<span class="token punctuation">:</span>string <span class="token operator">-></span> <span class="token type-variable function">'a</span><span class="token punctuation">)</span> <span class="token operator">-></span>
  t</code></pre></div>
<p>Here, the expected pattern first type parameter is <code>payload</code> which means we want a pattern that
matches <code>payload</code> AST nodes. That makes perfect sense since it is used to describe what your
extension's payload should look like and what to do with it.
The last type parameter is <code>'context</code> which again seems logical. As I mentioned earlier our
<code>expand_function</code> should return the same kind of node as the one where the extension was found.
Now what about <code>'a</code>. As you can see, it describes what comes after the base <code>loc</code> and <code>path</code>
parameters of our <code>expand_function</code>. From the pattern point of view, <code>'a</code> describes the parts of the
matched AST node we wish to extract for later consumption, here by our expander.</p>
<p><code>Ast_pattern</code> contains a whole bunch of combinators to let you describe what your pattern should match
and a specific <code>__</code> pattern that you must use to capture the various parts of the matched nodes.
<code>__</code> has type <code>('a, 'a -> 'b, 'b) Ast_pattern.t</code> which means that whenever it's used it changes the
type of consumer function in the returned pattern.</p>
<p>Let's consider a few examples to try wrapping our heads around this. Say I want to write an
extension that takes an expression as a payload and I want to pass this expression to my expander so
I can generate code based on its value. I can declare the extension like this:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> extension <span class="token operator">=</span>
  <span class="token module variable">Extension</span><span class="token punctuation">.</span>declare
    <span class="token string">"my_extension"</span>
    <span class="token module variable">Extension</span><span class="token punctuation">.</span><span class="token module variable">Context</span><span class="token punctuation">.</span>expression
    <span class="token module variable">Ast_pattern</span><span class="token punctuation">.</span><span class="token punctuation">(</span>single_expr_payload __<span class="token punctuation">)</span>
    expand_function</code></pre></div>
<p>In this example, <code>Extension.Context.expression</code> has type <code>expression Extension.Context.t</code>, the
pattern has type <code>(payload, expression -> expression, expression) Ast_pattern.t</code>. The pattern says we
want to allow a single expression in the payload and capture it. If we decompose it a bit, we can
see that <code>single_expr_payload</code> has type
<code>(expression, 'a, 'b) Ast_pattern.t -> (payload, 'a, 'b) Ast_pattern.t</code> and is passed <code>__</code> which
makes it a <code>(expression, expression -> 'b, 'b) Ast_pattern.t</code> and that's exactly what we want here
as our expander will have type <code>loc: Location.t -> path: string -> expression -> expression</code>!</p>
<p>It works similarly to <code>Scanf.scanf</code> when you think about it. Changing the pattern changes the type of the
consumer function the same way changing the format string does for <code>Scanf</code> functions.</p>
<p>This was a bit easy since we had a custom combinator just for that purpose so let's take a few more
complex examples. Now say we want to only allow pairs of integer and string constants expressions in
our payload. Instead of just capturing any expression and dealing with the error cases in the
<code>expand_function</code> we can let <code>Ast_pattern</code> deal with that and pass an <code>int</code> and <code>string</code> along to
our expander:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token module variable">Ast_pattern</span><span class="token punctuation">.</span><span class="token punctuation">(</span>single_expr_payload <span class="token punctuation">(</span>pexp_tuple <span class="token punctuation">(</span><span class="token punctuation">(</span>eint __<span class="token punctuation">)</span><span class="token operator">^::</span><span class="token punctuation">(</span>estring __<span class="token punctuation">)</span><span class="token operator">^::</span>nil<span class="token punctuation">)</span><span class="token punctuation">)</span><span class="token punctuation">)</span></code></pre></div>
<p>This one's a bit more elaborate but the idea is the same, we use <code>__</code> to capture the int and string
from the expression and use combinators to specify that the payload should be made of a pair and
that gives us a: <code>(payload, int -> string -> 'a, 'a) Ast_pattern.t</code> which should be used with a
<code>loc: Location.t -> path: string -> int -> string -> expression</code> expander.</p>
<p>We can also specify that our extension should take something else than an expression as a payload,
say a pattern with no <code>when</code> clause so that it's applied as <code>[%my_ext? some_pattern_payload]</code>:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token module variable">Ast_pattern</span><span class="token punctuation">.</span><span class="token punctuation">(</span>ppat __ none<span class="token punctuation">)</span></code></pre></div>
<p>or no payload at all and it should just be invoked as <code>[%my_ext]</code>:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token module variable">Ast_pattern</span><span class="token punctuation">.</span><span class="token punctuation">(</span>pstr nil<span class="token punctuation">)</span></code></pre></div>
<p>You should play with <code>Ast_pattern</code> a bit if you need to express complex patterns as I think it's
the only way to get the hang of it.</p>
<h3 id="writing-a-deriver" style="position:relative;"><a href="#writing-a-deriver" aria-label="writing a deriver permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Writing a deriver</h3>
<p>Registering a deriver is slightly different from registering an extension but in the end it remains
relatively simple and you will still have to provide the actual implementation in the form of an
<code>expand</code> function.</p>
<p>The typical <code>my_ppx_deriver.ml</code> will look like:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">open</span> <span class="token module variable">Ppxlib</span>

<span class="token keyword">let</span> str_type_decl_generator <span class="token operator">=</span>
  <span class="token module variable">Deriving</span><span class="token punctuation">.</span><span class="token module variable">Generator</span><span class="token punctuation">.</span>make_no_arg
    <span class="token label function">~attributes</span>
    expand_str

<span class="token keyword">let</span> sig_type_decl_generator <span class="token operator">=</span>
  <span class="token module variable">Deriving</span><span class="token punctuation">.</span><span class="token module variable">Generator</span><span class="token punctuation">.</span>make_no_arg
    <span class="token label function">~attributes</span>
    expand_sig

<span class="token keyword">let</span> my_deriver <span class="token operator">=</span>
  <span class="token module variable">Deriving</span><span class="token punctuation">.</span>add
    <span class="token label function">~str_type_decl</span><span class="token punctuation">:</span>str_type_decl_generator
    <span class="token label function">~sig_type_decl</span><span class="token punctuation">:</span>sig_type_decl_generator
    <span class="token string">"my_deriver"</span></code></pre></div>
<p>Which you'll need to compile with the following <code>library</code> stanza:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">(library
 (public_name my_ppx)
 (kind ppx_deriver)
 (libraries ppxlib))</code></pre></div>
<p>The <code>Deriving.add</code> function is declared as:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">val</span> add
  <span class="token punctuation">:</span>  <span class="token operator">?</span>str_type_decl<span class="token punctuation">:</span><span class="token punctuation">(</span>structure<span class="token punctuation">,</span> rec_flag <span class="token operator">*</span> type_declaration list<span class="token punctuation">)</span> <span class="token module variable">Generator</span><span class="token punctuation">.</span>t
  <span class="token operator">-></span> <span class="token operator">?</span>str_type_ext <span class="token punctuation">:</span><span class="token punctuation">(</span>structure<span class="token punctuation">,</span> type_extension                  <span class="token punctuation">)</span> <span class="token module variable">Generator</span><span class="token punctuation">.</span>t
  <span class="token operator">-></span> <span class="token operator">?</span>str_exception<span class="token punctuation">:</span><span class="token punctuation">(</span>structure<span class="token punctuation">,</span> extension_constructor           <span class="token punctuation">)</span> <span class="token module variable">Generator</span><span class="token punctuation">.</span>t
  <span class="token operator">-></span> <span class="token operator">?</span>sig_type_decl<span class="token punctuation">:</span><span class="token punctuation">(</span>signature<span class="token punctuation">,</span> rec_flag <span class="token operator">*</span> type_declaration list<span class="token punctuation">)</span> <span class="token module variable">Generator</span><span class="token punctuation">.</span>t
  <span class="token operator">-></span> <span class="token operator">?</span>sig_type_ext <span class="token punctuation">:</span><span class="token punctuation">(</span>signature<span class="token punctuation">,</span> type_extension                  <span class="token punctuation">)</span> <span class="token module variable">Generator</span><span class="token punctuation">.</span>t
  <span class="token operator">-></span> <span class="token operator">?</span>sig_exception<span class="token punctuation">:</span><span class="token punctuation">(</span>signature<span class="token punctuation">,</span> extension_constructor           <span class="token punctuation">)</span> <span class="token module variable">Generator</span><span class="token punctuation">.</span>t
  <span class="token operator">-></span> <span class="token operator">?</span>extension<span class="token punctuation">:</span><span class="token punctuation">(</span>loc<span class="token punctuation">:</span><span class="token module variable">Location</span><span class="token punctuation">.</span>t <span class="token operator">-></span> path<span class="token punctuation">:</span>string <span class="token operator">-></span> core_type <span class="token operator">-></span> expression<span class="token punctuation">)</span>
  <span class="token operator">-></span> string
  <span class="token operator">-></span> t</code></pre></div>
<p>It takes a mandatory string argument, here <code>"my_deriver"</code>, which defines how
user are going to invoke your deriver. In this case we'd need to add a <code>[@@deriving my_deriver]</code> to
a type declaration in a structure or a signature to use it.
Then there's just one optional argument per kind of node to which you can attach a <code>[@@deriving ...]</code>
attribute. <code>type_decl</code> correspond to <code>type = ...</code>, <code>type_ext</code> to <code>type += ...</code> and <code>exception</code> to
<code>exception My_exc of ...</code>.
You need to provide generators for the ones you wish your deriver to handle, <code>ppxlib</code>
will make sure users get a compile error if they try to use it elsewhere.
We can ignore the <code>extension</code> as it's just here for compatibility with <code>ppx_deriving</code>.</p>
<p>Now let's take a look at <code>Generator</code>. Its type is defined as <code>('output_ast, 'input_ast) t</code> where
<code>'input_ast</code> is the type of the node to which the <code>[@@deriving ...]</code> is attached and <code>'output_ast</code>
the type of the nodes it should produce, ie either a <code>structure</code> or a <code>signature</code>. The type of a
generator depends on the expand function it's built from when you use the smart constructor
<code>make_no_arg</code> meaning the expand function should have type
<code>loc: Location.t -> path: string -> 'input_ast -> 'output_ast</code>. This function is the actual
implementation of your deriver and will generate the list of <code>structure_item</code> or <code>signature_item</code>
from the type declaration.</p>
<h4 id="compatibility-with-ppx_import" style="position:relative;"><a href="#compatibility-with-ppx_import" aria-label="compatibility with ppx_import permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Compatibility with <code>ppx_import</code></h4>
<p><a href="https://github.com/ocaml-ppx/ppx_import"><code>ppx_import</code></a> is a PPX rewriter that lets you import type
definitions and spares you the need to copy and update them every time they change upstream. The
main reason why you would want to do that is because you need to derive values from those types
using a deriver thus the importance of ensuring your deriving plugin is compatible.</p>
<p>Let's take an example to illustrate how <code>ppx_import</code> is used. I'm using a library called <code>blob</code>
which exposes a type <code>Blob.t</code>. For some reason I need to be able to serialize and deserialize
<code>Blob.t</code> values to JSON. I'd like to use a deriver to do that as I don't want to maintain that code
myself. Imagine <code>Blob.t</code> is defined as:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">type</span> t <span class="token operator">=</span>
  <span class="token punctuation">{</span> <span class="token keyword">value</span> <span class="token punctuation">:</span> string
  <span class="token punctuation">;</span> length <span class="token punctuation">:</span> int
  <span class="token punctuation">;</span> id <span class="token punctuation">:</span> int
  <span class="token punctuation">}</span></code></pre></div>
<p>Without <code>ppx_import</code> I would define somewhere a <code>serializable_blob</code> type as follows:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">type</span> serializable_blob <span class="token operator">=</span> <span class="token module variable">Blob</span><span class="token punctuation">.</span>t <span class="token operator">=</span>
  <span class="token punctuation">{</span> <span class="token keyword">value</span> <span class="token punctuation">:</span> string
  <span class="token punctuation">;</span> length <span class="token punctuation">:</span> int
  <span class="token punctuation">;</span> id <span class="token punctuation">:</span> int
  <span class="token punctuation">}</span>
<span class="token punctuation">[</span><span class="token operator">@@</span>deriving yojson<span class="token punctuation">]</span></code></pre></div>
<p>That works well especially because the type definition is simple but I don't really care about
having it here, what I really want is just the <code>to_yojson</code> and <code>of_yojson</code> functions. Also now, if
the type definition changes, I have to update it here manually. Maintaining many such imports can be
tedious and duplicates a lot of code unnecessarily.</p>
<p>What I can do instead, thanks to <code>ppx_import</code> is to write it like this:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">type</span> serializable_blob <span class="token operator">=</span> <span class="token punctuation">[</span><span class="token operator">%</span>import<span class="token punctuation">:</span> <span class="token module variable">Blob</span><span class="token punctuation">.</span>t<span class="token punctuation">]</span>
<span class="token punctuation">[</span><span class="token operator">@@</span>deriving yojson<span class="token punctuation">]</span></code></pre></div>
<p>which will ultimately be expanded into the above using <code>Blob</code>'s definition of the type <code>t</code>.</p>
<p>Now <code>ppx_import</code> works a bit differently from regular PPX rewriters as it needs a bit more information
than just the AST. We don't need to understand how it works but what it means is that if your
deriving plugin is used with <code>ppx_import</code>, it will be called twice:</p>
<ul>
<li>A first time with <code>ocamldep</code>. This is required to determine the dependencies of a module in terms
of other OCaml modules. PPX-es need to be applied here to find out about dependencies they may
introduce.</li>
<li>A second time before actually compiling the code.</li>
</ul>
<p>The issue here is that during the <code>ocamldep</code> pass, <code>ppx_import</code> doesn't have the information it
needs to import the type definition yet so it can't copy it and it expands:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">type</span> u <span class="token operator">=</span> <span class="token punctuation">[</span><span class="token operator">%</span>import A<span class="token punctuation">.</span>t<span class="token punctuation">]</span></code></pre></div>
<p>into:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">type</span> u <span class="token operator">=</span> A<span class="token punctuation">.</span>t</code></pre></div>
<p>Only during the second pass will it actually expand it to the copied type definition.</p>
<p>This may be a concern if your deriving plugin can't apply to abstract types because you will
probably raise an error when encountering one, meaning the first phase will fail and the whole
compilation will fail without giving your rewriter a chance to derive anything from the copied
type definition.</p>
<p>The right way to deal with this is to have different a behaviour in the context of <code>ocamldep</code>.
In this case you can ignore such type declaration or eventually, if you know you are going to
inject new dependencies in your generated code, to create dummy values referencing them and just
behave normally in any other context.</p>
<p><code>ppxlib</code> versions <code>0.6.0</code> and higher allow you to do so through the <code>Deriving.Generator.V2</code> API
which passes an abstract <code>ctxt</code> value to your <code>expand</code> function instead of a <code>loc</code> and a <code>path</code>.
You can tell whether it is the <code>ocamldep</code> pass from within the <code>expand</code> function like this:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">open</span> <span class="token module variable">Ppxlib</span>

<span class="token keyword">let</span> expand <span class="token label function">~ctxt</span> input_ast <span class="token operator">=</span>
  <span class="token keyword">let</span> omp_config <span class="token operator">=</span> <span class="token module variable">Expansion_context</span><span class="token punctuation">.</span><span class="token module variable">Deriver</span><span class="token punctuation">.</span>omp_config ctxt <span class="token keyword">in</span>
  <span class="token keyword">let</span> is_ocamldep_pass <span class="token operator">=</span> <span class="token module variable">String</span><span class="token punctuation">.</span>equal <span class="token string">"ocamldep"</span> omp_config<span class="token punctuation">.</span><span class="token module variable">Migrate_parsetree</span><span class="token punctuation">.</span><span class="token module variable">Driver</span><span class="token punctuation">.</span>tool_name <span class="token keyword">in</span>
  <span class="token punctuation">.</span><span class="token punctuation">.</span><span class="token punctuation">.</span></code></pre></div>
<h4 id="deriver-attributes" style="position:relative;"><a href="#deriver-attributes" aria-label="deriver attributes permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Deriver attributes</h4>
<p>You'll have noted the <code>attributes</code> parameter in the examples. It's an optional parameter that lets
you define which attributes your deriver allows the user to attach to various bits of the type,
type extension or exception declaration it is applied to.</p>
<p><code>ppxlib</code> comes with a <code>Attribute</code> module that lets you to properly declare the attributes you want
to allow and make sure they are properly used: correctly spelled, placed and with the right
payload attached. This is especially useful since attributes are by default ignored by the compiler
meaning without <code>ppxlib</code>'s care, plugin users wouldn't get any errors if they misused an attribute
and it might take them a while to figure out they got it wrong and the generated code wasn't
impacted as they hoped.
The <code>Attribute</code> module offers another great feature: <code>Attribute.t</code> values can be used to extract the
attribute payload from an AST node if it is present. That will spare you the need for
inspecting attributes yourself which can prove quite tedious.</p>
<p><code>Ppxlib.Attribute.t</code> is defined as <code>('context, 'payload) t</code> where <code>'context</code> describes to which node
the attribute can be attached and <code>'payload</code>, the type of its payload.
To build such an attribute you must use <code>Ppxlib.Attribute.declare</code>:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">val</span> declare
  <span class="token punctuation">:</span>  string
  <span class="token operator">-></span> <span class="token type-variable function">'a</span> <span class="token module variable">Context</span><span class="token punctuation">.</span>t
  <span class="token operator">-></span> <span class="token punctuation">(</span>payload<span class="token punctuation">,</span> <span class="token type-variable function">'b</span><span class="token punctuation">,</span> <span class="token type-variable function">'c</span><span class="token punctuation">)</span> <span class="token module variable">Ast_pattern</span><span class="token punctuation">.</span>t
  <span class="token operator">-></span> <span class="token type-variable function">'b</span>
  <span class="token operator">-></span> <span class="token punctuation">(</span><span class="token type-variable function">'a</span><span class="token punctuation">,</span> <span class="token type-variable function">'c</span><span class="token punctuation">)</span> t</code></pre></div>
<p>Let's try to declare the <code>default</code> argument from <code>ppx_deriving_yojson</code> I mentioned earlier.</p>
<p>The first <code>string</code> argument is the attribute name. <code>ppxlib</code> support namespaces for the attributes so
that users can avoid conflicting attributes between various derivers applied to the same type
definitions. For instance here we could use <code>"default"</code>. It can prove helpful to use more qualified
name such as <code>"ppx_deriving_yojson.of_yojson.default"</code>. That means that our attribute can be used as
<code>[@@default ...]</code>, <code>[@@of_yojson.default ...]</code> or <code>[@@ppx_deriving.of_yojson.default ...]</code>.
Now if another deriver uses a <code>[@@default ...]</code>, users can apply both derivers and provide different
<code>default</code> values to the different derivers by writing:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">type</span> t <span class="token operator">=</span>
  <span class="token punctuation">{</span> a <span class="token punctuation">:</span> int
  <span class="token punctuation">;</span> b <span class="token punctuation">:</span> string <span class="token punctuation">[</span><span class="token operator">@</span>make<span class="token punctuation">.</span>default <span class="token string">"abc"</span><span class="token punctuation">]</span> <span class="token punctuation">[</span><span class="token operator">@</span>of_yojson<span class="token punctuation">.</span>default <span class="token string">""</span><span class="token punctuation">]</span>
  <span class="token punctuation">}</span>
<span class="token punctuation">[</span><span class="token operator">@@</span>deriving make<span class="token punctuation">,</span>of_yojson<span class="token punctuation">]</span></code></pre></div>
<p>The context argument works very similarly to the one in <code>Extension.declare</code>. Here we want the
attribute to be attached to record field declarations so we'll use
<code>Attribute.Context.label_declaration</code> which has type <code>label_declaration Attribute.Context.t</code>.</p>
<p>The pattern argument is an <code>Ast_pattern.t</code>. Now that we know how to work with those this is pretty
easy. Here we need to accept any expression as a payload since we should be able to apply the
<code>default</code> attribute to any field, regardless of its type and we want to extract that expression from
the payload so we can use it in our deserializer so let's use
<code>Ast_pattern.(single_expr_payload __)</code>.</p>
<p>Finally the last <code>'b</code> argument has the same type as the pattern consumer function. We can use it to
transform what we extracted using the previous <code>Ast_pattern</code> but in this case we just want to
keep the expression as we got it so we'll just use the identity function here.</p>
<p>We end up with the following:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> default_attribute <span class="token operator">=</span>
  <span class="token module variable">Attribute</span><span class="token punctuation">.</span>declare
    <span class="token string">"ppx_deriving_yojson.of_yojson.default"</span>
    <span class="token module variable">Attribute</span><span class="token punctuation">.</span><span class="token module variable">Context</span><span class="token punctuation">.</span>label_declaration
    <span class="token module variable">Ast_pattern</span><span class="token punctuation">.</span><span class="token punctuation">(</span>single_expr_payload __<span class="token punctuation">)</span>
    <span class="token punctuation">(</span><span class="token keyword">fun</span> expr <span class="token operator">-></span> expr<span class="token punctuation">)</span></code></pre></div>
<p>and that gives us a <code>(label_declaration, expression) Attribute.t</code>.</p>
<p>You can then use it to collect the attribute payload from a label_declaration:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token module variable">Attribute</span><span class="token punctuation">.</span>get default_attribute label_decl</code></pre></div>
<p>which will return <code>Some expr</code> if the attribute was attached to <code>label_decl</code> or <code>None</code> otherwise.</p>
<p>Because of their polymorphic nature, attributes need to be packed, ie to be wrapped with a variant
to hide the type parameter, so if you want to pass it to <code>Generator.make_no_arg</code> you'll have to do
it like this:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> attributes <span class="token operator">=</span> <span class="token punctuation">[</span><span class="token module variable">Attribute</span><span class="token punctuation">.</span>T default_attribute<span class="token punctuation">]</span></code></pre></div>
<h3 id="writing-your-expand-functions" style="position:relative;"><a href="#writing-your-expand-functions" aria-label="writing your expand functions permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Writing your expand functions</h3>
<p>In the two last sections I mentioned <code>expand</code> functions that would contain the actual <code>deriver</code> or
<code>extension</code> implementation but didn't actually said anything about how to write those. It will
depend a lot on the purpose of your PPX rewriter and what you're trying to achieve.</p>
<p>Before writing your PPX you should clearly specify what it should be applied to and what code it
should produce. That will help you declaring the right deriving or extension rewriter and from there
you'll know the type of the <code>expand</code> functions you have to write which should help.</p>
<p>A good way to proceed is to use the <code>dumpast</code> tool to pretty print the AST fragments of both the
input of your expander and the output, ie the code it should generate. To take a concrete example,
say you want to write a deriving plugin that generates an <code>equal</code> function from a type definition.
You can start by running <code>dumpast</code> on the following file:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">type</span> some_record <span class="token operator">=</span>
  <span class="token punctuation">{</span> a <span class="token punctuation">:</span> int64
  <span class="token punctuation">;</span> b <span class="token punctuation">:</span> string
  <span class="token punctuation">}</span>

<span class="token keyword">let</span> equal_some_record r r' <span class="token operator">=</span> <span class="token module variable">Int64</span><span class="token punctuation">.</span>equal r<span class="token punctuation">.</span>a r'<span class="token punctuation">.</span>a <span class="token operator">&amp;&amp;</span> <span class="token module variable">String</span><span class="token punctuation">.</span>equal r<span class="token punctuation">.</span>b r'<span class="token punctuation">.</span>b</code></pre></div>
<p>That will give you the AST representation of a record type definition and the equal function you
want to write so you can figure out how to deconstruct your expander's input to be able to generate
the right output.</p>
<p><code>ppxlib</code> exposes smart constructors in <code>Ppxlib.Ast_builder.Default</code> to help you build AST fragments
without having to care too much attributes and such fields as well as some convenience constructors
to keep your code concise and readable.</p>
<p>Another convenience tool <code>ppxlib</code> exposes to help you build AST fragments is <code>metaquot</code>. I recently
wrote a bit of documentation about it
<a href="https://ppxlib.readthedocs.io/en/latest/ppx-for-plugin-authors.html#metaquot">here</a> which you
should take a look at but to sum it up <code>metaquot</code> is a PPX extension allowing you to write AST nodes
using the OCaml syntax they describe instead of the AST types.</p>
<h4 id="handling-code-locations-in-a-ppx-rewriter" style="position:relative;"><a href="#handling-code-locations-in-a-ppx-rewriter" aria-label="handling code locations in a ppx rewriter permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Handling code locations in a PPX rewriter</h4>
<p>When building AST fragments you should keep in mind that you have to set their <code>location</code>. Locations
are part of the AST values that describes the position of the corresponding node in your source
file, including the file name and the line number and offset of both the beginning and the end the
code bit they represent.</p>
<p>Because your code was generated after the file was parsed, it doesn't have a location so you need to
set it yourself. One could think that it doesn't matter and we could use a dummy location but
locations are used by the compiler to properly report errors and that's why a PPX rewriter should care
about how it locates the generated code as it will help the end user to understand whether the error
comes from their code or generated code and how to eventually fix it.</p>
<p>Both <code>Ast_builder</code> and <code>metaquot</code> expect a location. The first explicitly takes it as a labelled
<code>loc</code> argument while the second relies on a <code>loc</code> value being available in the scope. It is
important to set those with care as errors in the generated code doesn't necessarily mean that your
rewriter is bugged. There are valid cases where your rewriter functioned as intended but the generated
code triggers an error. PPX-es often work on the assumption that some values are available in the
scope, if the user doesn't properly provide those it's their responsibility to fix the error. To
help them do so, it is important to properly locate the generated code to guide them as much as
possible.</p>
<p>When writing extensions, using the whole extension point location for the generated code makes
perfect sense as that's where the code will sit. That's fairly easy as this what <code>ppxlib</code> passes
to the expand function through the <code>loc</code> labelled argument. For deriving plugins it's a bit different
as the generated code doesn't replace an existing part of the parsed AST but generate a new one to insert.
Currently <code>ppxlib</code> gives you the <code>loc</code> of the whole type declaration, extension or exception
declaration your deriving plugin is applied to. Ideally it would be nice to be able to locate the
generated code on the plugin name in the <code>deriving</code> attribute payload, ie here:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">[@@deriving my_plugin,another_plugin]
            ^^^^^^^^^</code></pre></div>
<p>I'm currently working on making that location available to the <code>expand</code> function. In the meantime,
you should choose a convention. I personally locate all the generated code on the
type declaration. Some choose to locate the generated code on the part of the input AST they're
handling when generating it.</p>
<h4 id="reporting-errors-to-your-rewriter-users" style="position:relative;"><a href="#reporting-errors-to-your-rewriter-users" aria-label="reporting errors to your rewriter users permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Reporting errors to your rewriter users</h4>
<p>You won't always be able to handle all the AST nodes passed to your expand functions, either because the
end user misused your rewriter or because there are some cases you simply can't deal with.</p>
<p>In those cases you can report the error to the user with <code>Ppxlib.Location.raise_errorf</code>. It works
similarly to <code>printf</code> and you can build your error message from a format string and extra
arguments. It will then raise an exception which will be caught and reported by the compiler.
A good practice is to prefix the error message with the name of your rewriter to help users understand
what's going on, especially with deriving plugin as they might use several of them on the same type
declaration.</p>
<p>Another point to take care of here is, again, locations. <code>raise_errorf</code> takes a labelled <code>loc</code>
arguments. It is used so that your error is reported as any compiler error. Having good locations in
those error messages is just as important as sending clear error messages. Keep in mind that both
the errors you report yourself or errors coming from your generated code will be highlighted by
merlin so when properly set they make it much easier to work with your PPX rewriter.</p>
<h3 id="testing-your-ppx" style="position:relative;"><a href="#testing-your-ppx" aria-label="testing your ppx permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Testing your PPX</h3>
<p>Just as most pieces of code do, a PPX deserves to be tested and it has become easier over the years to
test rewriters.</p>
<p>I personally tend to write as many unit test as possible for my PPX-es internal libraries. I try to
extract helper functions that can easily be unit-tested but I can't test it all that way.
Testing the <code>ast -> ast</code> functions would be tedious as <code>ppxlib</code> and <code>ocaml-migrate-parsetree</code>
don't provide comparison and pretty printing functions that you can use with <code>alcotest</code> or <code>oUnit</code>.
That means you'd have to import the AST types and derive them on your own. That would make a lot
of boiler plate and even if those functions were exposed, writing such tests would be really
tedious. There's a lot of things to take into account. How are you going to build the input AST values
for instance?  If you use <code>metaquot</code>, every node will share the same loc, making it hard to test
that your errors are properly located. If you don't, you will end up with insanely long and
unreadable test code or fixtures.
While that would allow extremely accurate testing for the generated code and errors, it will almost
certainly make your test code unmaintainable, at least given the current tooling.</p>
<p>Don't panic, there is a very good and simple alternative. <code>ppxlib</code> makes it very easy to build a
binary that will parse OCaml code, preprocess the AST with your rewriter and spit it out, formatted as
code again.</p>
<p>You just have to write the following <code>pp.ml</code>:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">=</span> <span class="token module variable">Ppxlib</span><span class="token punctuation">.</span><span class="token module variable">Driver</span><span class="token punctuation">.</span>standalone <span class="token punctuation">(</span><span class="token punctuation">)</span></code></pre></div>
<p>and build the binary with the following <code>dune</code> stanza, assuming your rewriter is called
<code>my_ppx_rewriter</code>:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">(executable
 (name pp)
 (modules pp)
 (libraries my_ppx_rewriter ppxlib))</code></pre></div>
<p>Because we're humans and the OCaml syntax is meant for us to write and read, it makes for much better
test input/output. You can now write your test input in a regular <code>.ml</code> file, use the <code>pp.exe</code>
binary to "apply" your preprocessor to it and compare the output with another <code>.ml</code> file containing
the code you expect it to generate. This kind of test pattern is really well supported by <code>dune</code>
thanks to the <code>diff</code> user action.</p>
<p>I usually have the following files in a <code>rewriter</code>/<code>deriver</code> folder within my test directory:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">test/rewriter/
├── dune
├── test.expected.ml
├── pp.ml
└── test.ml</code></pre></div>
<p>Where <code>pp.ml</code> is used to produce the rewriter binary, <code>test.ml</code> contains the input OCaml code and
<code>test.expected.ml</code> the result of preprocessing <code>test.ml</code>. The dune file content is generally similar
to this:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">(executable
 (name pp)
 (modules pp)
 (libraries my_ppx_rewriter ppxlib))

(rule
 (targets test.actual.ml)
 (deps (:pp pp.exe) (:input test.ml))
 (action (run ./%{pp} -deriving-keep-w32 both --impl %{input} -o %{targets})))

(alias
 (name runtest)
 (action (diff test.expected.ml test.actual.ml)))

(test
  (name test)
  (modules test)
  (preprocess (pps my_ppx_rewriter)))</code></pre></div>
<p>The first stanza is the one I already introduced above and specifies how to build the rewriter binary.</p>
<p>The <code>rule</code> stanza that comes after that indicates to <code>dune</code> how to produce the actual test output by
applying the rewriter binary to <code>test.ml</code>. You probably noticed the <code>-deriving-keep-w32 both</code> CLI
option passed to <code>pp.exe</code>. By default, <code>ppxlib</code> will generate values or add attributes so that your
generated code doesn't trigger a "Unused value" warning. This is useful in real life situation but
here it will just pollute the test output and make it harder to read so we disable that feature.</p>
<p>The following <code>alias</code> stanza is where all the magic happens. Running <code>dune runtest</code> will now
generate <code>test.actual.ml</code> and compare it to <code>test.expected.ml</code>. It will not only do that but show
you how they differ from each other in a diff format. You can then automatically update
<code>test.expected.ml</code> if you're happy with the results by running <code>dune promote</code>.</p>
<p>Finally the last <code>test</code> stanza is there to ensure that the generated code compiles without type
errors.</p>
<p>This makes a very convenient test setup to write your PPX-es TDD style. You can start by writing an
identity PPX, that will just return its input AST as it is. Then you add some OCaml code using your
soon to be PPX in <code>test.ml</code> and run <code>dune runtest --auto-promote</code> to prefill <code>test.expected.ml</code>.
From there you can start implementing your rewriter and run <code>dune runtest</code> to check on your progress
and update the expected result with <code>dune promote</code>.
Going pure TDD by writing the test works but it's tricky cause you'd have to format your code the
same way <code>pp.exe</code> will format the AST. It would be great to be able to specify how to format
the generated <code>test.actual.ml</code> so that this approach would be more viable and the diff more
readable. Being able to use ocamlformat with a very diff friendly configuration would be great
there. <code>pp.exe</code> seems to offer CLI options to change the code style such as <code>-styler</code> but I haven't
had the chance to experiment with those yet.</p>
<p>Now you can test successful rewriting this way but what about errors? There's a lot of value
ensuring you produce the right errors and on the right code location because that's the kind of
things you can get wrong when refactoring your rewriter code or when people try to contribute.
That isn't as likely to happen if your CI yells when you break the error reporting. So how do we do
that?</p>
<p>Well pretty much the exact same way! We write a file with an erroneous invocation of our rewriter,
run <code>pp.exe</code> on it and compare stderr with what we expect it to be.
There are two major differences here. First we want to collect the stderr output of the rewriter
binary instead of using it to generate a file. The second is that we cant write all of our test
cases in a single file since <code>pp.exe</code> will stop at the first error. That means we need one <code>.ml</code>
file per error test case.
Luckily for us, dune offers ways to do both.</p>
<p>For every error test file we will want to add the following stanzas:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">(rule
  (targets test_error.actual)
  (deps (:pp pp.exe) (:input test_error.ml)) 
  (action
    (with-stderr-to
      %{targets}
      (bash &quot;./%{pp} -no-color --impl %{input} || true&quot;)
    )
  )
)

(alias
  (name runtest)
  (action (diff test_error.expected test_error.actual))
)</code></pre></div>
<p>but obviously we don't want to do that by hand every time we add a new test case so we're gonna need
a script to generate those stanzas and then include them into our <code>dune</code> file using
<code>(include dune.inc)</code>.</p>
<p>To achieve that while keeping things as clean as possible I use the following directory structure:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">test/rewriter/
├── errors
│   ├── dune
│   ├── dune.inc
│   ├── gen_dune_rules.ml
│   ├── pp.ml
│   ├── test_some_error.expected
│   ├── test_some_error.ml
│   ├── test_some_other_error.expected
│   └── test_some_other_error.ml
├── dune
├── test.expected.ml
├── pp.ml
└── test.ml</code></pre></div>
<p>Compared to our previous setup, we only added the new <code>errors</code> folder. To keep things simple it has
its own <code>pp.ml</code> copy but in the future I'd like to improve it a bit and be able to use the same
<code>pp.exe</code> binary.</p>
<p>The most important files here are <code>gen_dune_rules.ml</code> and <code>dune.inc</code>. The first is just a simple
OCaml script to generate the above stanzas for each test cases in the <code>errors</code> directory. The second
is the file we'll include in the main <code>dune</code>. It's also the file to which we'll write the generated
stanza.</p>
<p>I personally use the following <code>gen_dune_rules.ml</code>:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> output_stanzas filename <span class="token operator">=</span>
  <span class="token keyword">let</span> base <span class="token operator">=</span> <span class="token module variable">Filename</span><span class="token punctuation">.</span>remove_extension filename <span class="token keyword">in</span>
  <span class="token module variable">Printf</span><span class="token punctuation">.</span>printf
    <span class="token punctuation">{</span><span class="token operator">|</span>
<span class="token punctuation">(</span>library
  <span class="token punctuation">(</span>name <span class="token operator">%</span>s<span class="token punctuation">)</span>
  <span class="token punctuation">(</span>modules <span class="token operator">%</span>s<span class="token punctuation">)</span>
  <span class="token punctuation">(</span>preprocess <span class="token punctuation">(</span>pps ppx_yojson<span class="token punctuation">)</span><span class="token punctuation">)</span>
<span class="token punctuation">)</span>

<span class="token punctuation">(</span>rule
  <span class="token punctuation">(</span>targets <span class="token operator">%</span>s<span class="token punctuation">.</span>actual<span class="token punctuation">)</span>
  <span class="token punctuation">(</span>deps <span class="token punctuation">(</span><span class="token punctuation">:</span>pp pp<span class="token punctuation">.</span>exe<span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token punctuation">:</span>input <span class="token operator">%</span>s<span class="token punctuation">.</span>ml<span class="token punctuation">)</span><span class="token punctuation">)</span>
  <span class="token punctuation">(</span>action
    <span class="token punctuation">(</span><span class="token keyword">with</span><span class="token operator">-</span>stderr<span class="token operator">-</span><span class="token keyword">to</span>
      <span class="token operator">%%</span><span class="token punctuation">{</span>targets<span class="token punctuation">}</span>
      <span class="token punctuation">(</span>bash <span class="token string">"./%%{pp} -no-color --impl %%{input} || true"</span><span class="token punctuation">)</span>
    <span class="token punctuation">)</span>
  <span class="token punctuation">)</span>
<span class="token punctuation">)</span>

<span class="token punctuation">(</span>alias
  <span class="token punctuation">(</span>name runtest<span class="token punctuation">)</span>
  <span class="token punctuation">(</span>action <span class="token punctuation">(</span>diff <span class="token operator">%</span>s<span class="token punctuation">.</span>expected <span class="token operator">%</span>s<span class="token punctuation">.</span>actual<span class="token punctuation">)</span><span class="token punctuation">)</span>
<span class="token punctuation">)</span>
<span class="token operator">|</span><span class="token punctuation">}</span>
    base
    base
    base
    base
    base
    base

<span class="token keyword">let</span> is_error_test <span class="token operator">=</span> <span class="token keyword">function</span>
  <span class="token operator">|</span> <span class="token string">"pp.ml"</span> <span class="token operator">-></span> <span class="token boolean">false</span>
  <span class="token operator">|</span> <span class="token string">"gen_dune_rules.ml"</span> <span class="token operator">-></span> <span class="token boolean">false</span>
  <span class="token operator">|</span> filename <span class="token operator">-></span> <span class="token module variable">Filename</span><span class="token punctuation">.</span>check_suffix filename <span class="token string">".ml"</span>

<span class="token keyword">let</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">=</span>
  <span class="token module variable">Sys</span><span class="token punctuation">.</span>readdir <span class="token string">"."</span>
  <span class="token operator">|></span> <span class="token module variable">Array</span><span class="token punctuation">.</span>to_list
  <span class="token operator">|></span> <span class="token module variable">List</span><span class="token punctuation">.</span>sort <span class="token module variable">String</span><span class="token punctuation">.</span>compare
  <span class="token operator">|></span> <span class="token module variable">List</span><span class="token punctuation">.</span>filter is_error_test
  <span class="token operator">|></span> <span class="token module variable">List</span><span class="token punctuation">.</span>iter output_stanzas</code></pre></div>
<p>Nothing spectacular here, we just build the list of all the <code>.ml</code> files in the directory except
<code>pp.ml</code> and <code>gen_dune_rules.ml</code> itself and then generate the right stanzas for each of them. You'll
note the extra <code>library</code> stanza which I add to get dune to generate the right <code>.merlin</code> so that I
can see the error highlights when I edit the files by hand.</p>
<p>With that we're almost good, add the following to the <code>dune</code> file and you're all set:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">(executable
  (name pp)
  (modules pp)
  (libraries
    ppx_yojson
    ppxlib
  )
)

(include dune.inc)

(executable
  (name gen_dune_rules)
  (modules gen_dune_rules)
)

(rule
  (targets dune.inc.gen)
  (deps
    (:gen gen_dune_rules.exe)
    (source_tree .)
  )
  (action
    (with-stdout-to
      %{targets}
      (run %{gen})
    ) 
  )
)

(alias
  (name runtest)
  (action (diff dune.inc dune.inc.gen))
)</code></pre></div>
<p>The first stanza is here to specify how to build the rewriter binary, same as before, while the
second stanza just tells dune to include the content of <code>dune.inc</code> within this <code>dune</code> file.</p>
<p>The interesting part comes next. As you can guess the <code>executable</code> stanza builds our little OCaml
script into a <code>.exe</code>. The <code>rule</code> that comes after that specifies how to generate the new stanzas
by running <code>gen_dune_rules</code> and capturing its standard output into a <code>dune.inc.gen</code> file.
The last rule allows you to review the changes to the generated stanza and use promotion to accept
them. Once this is done, the new stanzas will be included to the <code>dune</code> file and the test will be
run for every test cases.</p>
<p>Adding a new test case is then pretty easy, you can simply run:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">$ touch test/rewriter/errors/some_explicit_test_case_name.{ml,expected} &amp;&amp; dune runtest --auto-promote</code></pre></div>
<p>That will create the new empty test case and update the <code>dune.inc</code> with the corresponding rules.
From there you can proceed the same way as with the successful rewriting tests, update the <code>.ml</code>,
run <code>dune runtest</code> to take a sneak peek at the output and <code>dune promote</code> once you're satisfied with
the result.</p>
<p>I've been pretty happy with this setup so far although there's room for improvement. It would be
nice to avoid duplicating <code>pp.ml</code> for errors testing. This also involves
quite a bit of boilerplate that I have to copy into all my PPX rewriters repositories every time.
Hopefully <a href="https://github.com/ocaml/dune/issues/1855">dune plugins</a> should help with that and I
can't wait for a first version to be released so that I can write a plugin to make this test
pattern more accessible and easier to set up.</p>|js}
  };
 
  { title = {js|Building portable user interfaces with Nottui and Lwd|js}
  ; slug = {js|building-portable-user-interfaces-with-nottui-and-lwd|js}
  ; description = Some {js|At Tarides, we build many tools and writing UI is usually a tedious task. In this post we will see how to write functional UIs in OCaml…|js}
  ; url = {js|https://tarides.com/blog/2020-09-24-building-portable-user-interfaces-with-nottui-and-lwd|js}
  ; date = {js|2020-09-24T00:00:00-00:00|js}
  ; preview_image = Some {js|https://tarides.com/static/06fbdcdb40efa879b814b744c5ea3fbf/497c6/nottui-rain.png|js}
  ; body_html = {js|<p>At Tarides, we build many tools and writing UI is usually a tedious task. In this post we will see how to write functional UIs in OCaml using the <code>Nottui</code> &#x26; <code>Lwd</code> libraries.</p>
<p>These libraries were developed for <a href="https://github.com/ocurrent/citty">Citty</a>, a frontend to the <a href="https://github.com/ocurrent/ocaml-ci">Continuous Integration service</a> of OCaml Labs.</p>
<div>
  <video controls width="100%">
    <source src="./nottui-citty.mp4" type="video/mp4" />
    <source src="./nottui-citty.webm" type="video/webm;codecs=vp9" />
  </video>
</div>
<p>In this recording, you can see the lists of repositories, branches and jobs monitored by the CI service, as well as the result of job execution. Most of the logic is asynchronous, with all the contents being received from the network in a non-blocking way.</p>
<p><code>Nottui</code> extends <a href="https://github.com/pqwy/notty">Notty</a>, a library for declaring terminal images, to better suit the needs of UIs. <code>Lwd</code> (Lightweight Document) exposes a simple form of reactive computation (values that evolve over time). It can be thought of as an alternative to the DOM, suitable for building interactive documents.
They are used in tandem: <code>Nottui</code> for rendering the UI and <code>Lwd</code> for making it interactive.</p>
<h2 id="nottui--notty-with-layout-and-events" style="position:relative;"><a href="#nottui--notty-with-layout-and-events" aria-label="nottui  notty with layout and events permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Nottui = Notty with layout and events</h2>
<p>Notty exposes a nice way to display images in a terminal. A Notty image is matrix of characters with optional styling attributes (tweaking foreground and background colors, using <strong>bold</strong> glyphs...).</p>
<p>These images are pure values and can be composed (concatenated, cropped, ...) very efficiently, making them very convenient to manipulate in a functional way.</p>
<p>However these images are inert: their contents are fixed and their only purpose is to be displayed. Nottui reuses Notty images and exposes essentially the same interface but it adds two features: layout &#x26; event dispatch. UI elements now adapt to the space available and can react to keyboard and mouse actions.</p>
<p><strong>Layout DSL</strong>. Specifying a layout is done using "stretchable" dimensions, a concept loosely borrowed from TeX. Each UI element has a fixed size (expressed as a number of columns and rows) and a stretchable size (possibly empty). The stretchable part is interpreted as a strength that is used to determine how to share the space available among all UI elements.</p>
<p>This is a simple system amenable to an efficient implementation while being powerful enough to express common layout patterns.</p>
<p><strong>Event dispatch</strong>. Reacting to mouse and keyboard events is better done using local behaviors, specific to an element. In Nottui, images are augmented with handlers for common actions. There is also a global notion of focus to determine which element should consume input events.</p>
<h2 id="interactivity-with-lwd" style="position:relative;"><a href="#interactivity-with-lwd" aria-label="interactivity with lwd permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Interactivity with Lwd</h2>
<p>Nottui's additions are nice for resizing and attaching behaviors to images, but they are still static objects. In practice, user interfaces are very dynamic: parts can be independently updated to display new information.</p>
<p>This interactivity layer is brought by Lwd and is developed separately from the core UI library. It is built around a central type, <code>'a Lwd.t</code>, that represents a value of type <code>'a</code> that can change over time.</p>
<p><code>Lwd.t</code> is an <a href="https://en.wikipedia.org/wiki/Applicative_functor">applicative functor</a> (and even a monad), making it a highly composable abstraction.</p>
<p>Primitive changes are introduced by <code>Lwd.var</code>, which are OCaml references with an extra operation <code>val get : 'a Lwd.var -> 'a Lwd.t</code>. This operation turns a variable into a <em>changing value</em> that changes whenever the variable is set.</p>
<p>In practice this leads to a mostly declarative style of programming interactive documents (as opposed to the DOM that is deeply mutable). Most of the code is just function applications without spooky action at a distance! However, it is possible to opt-out of this pure style by introducing an <code>Lwd.var</code>, on a case-by-case basis.</p>
<h2 id="and-much-more" style="position:relative;"><a href="#and-much-more" aria-label="and much more permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>And much more...</h2>
<p>A few extra libraries are provided to target more specific problems.</p>
<p><code>Lwd_table</code> and <code>Lwd_seq</code> are two datastructures to manipulate dynamic collections. <code>Nottui_pretty</code> is an interactive pretty printing library that supports arbitrary Nottui layouts and widgets. Finally <code>Tyxml_lwd</code> is a strongly-typed abstraction of the DOM driven by Lwd.</p>
<p>Version 0.1 has just been released on OPAM.</p>
<h2 id="getting-started" style="position:relative;"><a href="#getting-started" aria-label="getting started permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Getting started!</h2>
<p>Here is a small example to start using the library. First, install the Nottui library:</p>
<div class="gatsby-highlight" data-language="sh"><pre class="language-sh"><code class="language-sh">$ opam install nottui</code></pre></div>
<p>Now we can play in the top-level. We will start with a simple button that counts the number of clicks:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token operator">$</span> utop
# <span class="token directive important">#require</span> <span class="token string">"nottui"</span><span class="token punctuation">;</span><span class="token punctuation">;</span>
# <span class="token keyword">open</span> <span class="token module variable">Nottui</span><span class="token punctuation">;</span><span class="token punctuation">;</span>
# <span class="token keyword">module</span> W <span class="token operator">=</span> <span class="token module variable">Nottui_widgets</span><span class="token punctuation">;</span><span class="token punctuation">;</span>
<span class="token comment">(* State for holding the number of clicks *)</span>
# <span class="token keyword">let</span> vcount <span class="token operator">=</span> <span class="token module variable">Lwd</span><span class="token punctuation">.</span>var <span class="token number">0</span><span class="token punctuation">;</span><span class="token punctuation">;</span>
<span class="token comment">(* Image of the button parametrized by the number of clicks *)</span>
# <span class="token keyword">let</span> button count <span class="token operator">=</span>
    W<span class="token punctuation">.</span>button <span class="token label function">~attr</span><span class="token punctuation">:</span><span class="token module variable">Notty</span><span class="token punctuation">.</span>A<span class="token punctuation">.</span><span class="token punctuation">(</span>bg green <span class="token operator">++</span> fg black<span class="token punctuation">)</span>
      <span class="token punctuation">(</span><span class="token module variable">Printf</span><span class="token punctuation">.</span>sprintf <span class="token string">"Clicked %d times!"</span> count<span class="token punctuation">)</span>
      <span class="token punctuation">(</span><span class="token keyword">fun</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">-></span> <span class="token module variable">Lwd</span><span class="token punctuation">.</span>set vcount <span class="token punctuation">(</span>count <span class="token operator">+</span> <span class="token number">1</span><span class="token punctuation">)</span><span class="token punctuation">)</span><span class="token punctuation">;</span><span class="token punctuation">;</span>
<span class="token comment">(* Run the UI! *)</span>
# <span class="token module variable">Ui_loop</span><span class="token punctuation">.</span>run <span class="token punctuation">(</span><span class="token module variable">Lwd</span><span class="token punctuation">.</span>map button <span class="token punctuation">(</span><span class="token module variable">Lwd</span><span class="token punctuation">.</span>get vcount<span class="token punctuation">)</span><span class="token punctuation">)</span><span class="token punctuation">;</span><span class="token punctuation">;</span></code></pre></div>
<p><strong>Note:</strong> to quit the example, you can press Ctrl-Q or Esc.</p>
<p>We will improve the example and turn it into a mini cookie clicker game.</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token comment">(* Achievements to unlock in the cookie clicker *)</span>
# <span class="token keyword">let</span> badges <span class="token operator">=</span> <span class="token punctuation">[</span><span class="token number">15</span><span class="token punctuation">,</span> <span class="token string">"Cursor"</span><span class="token punctuation">;</span> <span class="token number">50</span><span class="token punctuation">,</span> <span class="token string">"Grandma"</span><span class="token punctuation">;</span> <span class="token number">150</span><span class="token punctuation">,</span> <span class="token string">"Farm"</span><span class="token punctuation">;</span> <span class="token number">300</span><span class="token punctuation">,</span> <span class="token string">"Mine"</span><span class="token punctuation">]</span><span class="token punctuation">;</span><span class="token punctuation">;</span>
<span class="token comment">(* List the achievements unlocked by the player *)</span>
# <span class="token keyword">let</span> unlocked_ui count <span class="token operator">=</span>
    <span class="token comment">(* Filter the achievements *)</span>
    <span class="token keyword">let</span> predicate <span class="token punctuation">(</span>target<span class="token punctuation">,</span> text<span class="token punctuation">)</span> <span class="token operator">=</span>
      <span class="token keyword">if</span> count <span class="token operator">>=</span> target
      <span class="token keyword">then</span> <span class="token module variable">Some</span> <span class="token punctuation">(</span>W<span class="token punctuation">.</span>printf <span class="token string">"% 4d: %s"</span> target text<span class="token punctuation">)</span>
      <span class="token keyword">else</span> <span class="token module variable">None</span>
    <span class="token keyword">in</span>
    <span class="token comment">(* Concatenate the UI elements vertically *)</span>
    <span class="token module variable">Ui</span><span class="token punctuation">.</span>vcat <span class="token punctuation">(</span><span class="token module variable">List</span><span class="token punctuation">.</span>filter_map predicate badges<span class="token punctuation">)</span><span class="token punctuation">;</span><span class="token punctuation">;</span>
<span class="token comment">(* Display the next achievement to reach *)</span>
# <span class="token keyword">let</span> next_ui count <span class="token operator">=</span>
    <span class="token keyword">let</span> predicate <span class="token punctuation">(</span>target<span class="token punctuation">,</span> <span class="token punctuation">_</span><span class="token punctuation">)</span> <span class="token operator">=</span> target <span class="token operator">></span> ciybt <span class="token keyword">in</span>
    <span class="token keyword">match</span> <span class="token module variable">List</span><span class="token punctuation">.</span>find_opt predicate badges <span class="token keyword">with</span>
    <span class="token operator">|</span> <span class="token module variable">Some</span> <span class="token punctuation">(</span>target<span class="token punctuation">,</span> <span class="token punctuation">_</span><span class="token punctuation">)</span> <span class="token operator">-></span>
      W<span class="token punctuation">.</span>printf <span class="token label function">~attr</span><span class="token punctuation">:</span><span class="token module variable">Notty</span><span class="token punctuation">.</span>A<span class="token punctuation">.</span><span class="token punctuation">(</span>st bold<span class="token punctuation">)</span> <span class="token string">"% 4d: ???"</span> target
    <span class="token operator">|</span> <span class="token module variable">None</span> <span class="token operator">-></span> <span class="token module variable">Ui</span><span class="token punctuation">.</span>empty<span class="token punctuation">;</span><span class="token punctuation">;</span>
<span class="token comment">(* Let's make use of the fancy let-operators recently added to OCaml *)</span>
# <span class="token keyword">open</span> <span class="token module variable">Lwd_infix</span><span class="token punctuation">;</span><span class="token punctuation">;</span>
# <span class="token keyword">let</span> ui <span class="token operator">=</span>
    <span class="token keyword">let</span><span class="token operator">$</span> count <span class="token operator">=</span> <span class="token module variable">Lwd</span><span class="token punctuation">.</span>get vcount <span class="token keyword">in</span>
    <span class="token module variable">Ui</span><span class="token punctuation">.</span>vcat <span class="token punctuation">[</span>button count<span class="token punctuation">;</span> unlocked_ui count<span class="token punctuation">;</span> next_ui count<span class="token punctuation">]</span><span class="token punctuation">;</span><span class="token punctuation">;</span>
<span class="token comment">(* Launch the game! *)</span>
# <span class="token module variable">Ui_loop</span><span class="token punctuation">.</span>run ui<span class="token punctuation">;</span><span class="token punctuation">;</span></code></pre></div>
<div>
  <video controls>
    <source src="./nottui-cookie-clicker.mp4" type="video/mp4" />
    <source src="./nottui-cookie-clicker.webm" type="video/webm;codecs=vp9" />
  </video>
</div>
<p>Et voilà! We hope you enjoy experimenting with <code>Nottui</code> and <code>Lwd</code>. Check out the <a href="https://github.com/let-def/lwd/tree/master/lib/nottui">Nottui page</a> for more examples, and watch our recent presentation of these libraries at the 2020 ML Workshop here:</p>
<div style="position: relative; width: 100%; height: 0; padding-bottom: 56.25%">
  <iframe
    style="position: absolute; width: 100%; height: 100%; left: 0; right: 0"
    src="https://www.youtube-nocookie.com/embed/w7jc35kgBZE" frameborder="0"
    allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
    allowfullscreen>
  </iframe>
</div>|js}
  };
 
  { title = {js|Decompress: Experiences with OCaml optimization|js}
  ; slug = {js|decompress-experiences-with-ocaml-optimization|js}
  ; description = Some {js|In our first article we mostly discussed
the API design of decompress and did not talk too much about the issue of
optimizing performance…|js}
  ; url = {js|https://tarides.com/blog/2019-09-13-decompress-experiences-with-ocaml-optimization|js}
  ; date = {js|2019-09-13T00:00:00-00:00|js}
  ; preview_image = Some {js|https://tarides.com/static/fff1a2a9a2dbdd9ac7efd7c97ac5aa2a/2244e/camel_sunset.jpg|js}
  ; body_html = {js|<p>In our <a href="https://tarides.com/blog/2019-08-26-decompress-the-new-decompress-api.html">first article</a> we mostly discussed
the API design of <code>decompress</code> and did not talk too much about the issue of
optimizing performance. In this second article, we will relate our experiences
of optimizing <code>decompress</code>.</p>
<p>As you might suspect, <code>decompress</code> needs to be optimized a lot. It was used by
several projects as an underlying layer of some formats (like Git), so it can be
a real bottleneck in those projects. Of course, we start with a footgun by using
a garbage-collected language; comparing the performance of <code>decompress</code> with a C
implementation (like <a href="https://zlib.net/">zlib</a> or <a href="https://github.com/richgel999/miniz">miniz</a>) is obviously not very fair.</p>
<p>However, using something like <code>decompress</code> instead of C implementations can be
very interesting for many purposes, especially when thinking about <em>unikernels</em>.
As we said in the previous article, we can take the advantage of the <em>runtime</em>
and the type-system to provide something <em>safer</em> (of course, it's not really
true since zlib has received several security audits).</p>
<p>The main idea in this article is not to give snippets to copy/paste into your
codebase but to explain some behaviors of the compiler / runtime and hopefully
give you some ideas about how to optimize your own code. We'll discuss the
following optimizations:</p>
<ul>
<li>specialization</li>
<li>inlining</li>
<li>untagged integers</li>
<li>exceptions</li>
<li>unrolling</li>
<li>hot-loop</li>
<li>caml_modify</li>
<li>representation sizes</li>
</ul>
<h3 id="cautionary-advice" style="position:relative;"><a href="#cautionary-advice" aria-label="cautionary advice permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Cautionary advice</h3>
<p>Before we begin discussing optimization, keep this rule in mind:</p>
<blockquote>
<p>Only perform optimization at the <strong>end</strong> of the development process.</p>
</blockquote>
<p>An optimization pass
can change your code significantly, so you need to keep a state of your project
that can be trusted. This state will provide a comparison point for both
benchmarks and behaviors. In other words, your stable implementation will be the
oracle for your benchmarks. If you start with nothing, you'll achieve
arbitrarily-good performance at the cost of arbitrary behavior!</p>
<p>We optimized <code>decompress</code> because we are using it in bigger projects for a long
time (2 years). So we have an oracle (even if <code>zlib</code> can act as an oracle in
this special case).</p>
<h2 id="specialization" style="position:relative;"><a href="#specialization" aria-label="specialization permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Specialization</h2>
<p>One of the biggest specializations in <code>decompress</code> is regarding the <code>min</code>
function. If you don't know, in OCaml <code>min</code> is polymorphic; you can compare
anything. So you probably have some concerns about how <code>min</code> is implemented?</p>
<p>You are right to be concerned: if you examine the details, <code>min</code> calls the C
function <code>do_compare_val</code>, which traverses your structure and does a comparison
according the run-time representation of your structure. Of course, for integers, it
should be only a <code>cmpq</code> assembly instruction. However, some simple code like:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> x <span class="token operator">=</span> min <span class="token number">0</span> <span class="token number">1</span></code></pre></div>
<p>will produce this CMM and assembly code:</p>
<div class="gatsby-highlight" data-language="cmm"><pre class="language-cmm"><code class="language-cmm">(let x/1002 (app{main.ml:1,8-15} &quot;camlStdlib__min_1028&quot; 1 3 val)
   ...)</code></pre></div>
<div class="gatsby-highlight" data-language="asm"><pre class="language-asm"><code class="language-asm">.L101:
        movq    $3, %rbx
        movq    $1, %rax
        call    camlStdlib__min_1028@PLT</code></pre></div>
<p>Note that <em><a href="https://en.wikipedia.org/wiki/Lambda_calculus#Beta_reduction">beta-reduction</a></em>, <em><a href="https://en.wikipedia.org/wiki/Inline_expansion">inlining</a></em> and
specialization were not done in this code. OCaml does not optimize your code
very much – the good point is predictability of the produced assembly output.</p>
<p>If you help the compiler a little bit with:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">external</span> <span class="token punctuation">(</span> <span class="token operator">&lt;=</span> <span class="token punctuation">)</span> <span class="token punctuation">:</span> int <span class="token operator">-></span> int <span class="token operator">-></span> bool <span class="token operator">=</span> <span class="token string">"%lessequal"</span>
<span class="token keyword">let</span> min a b <span class="token operator">=</span> <span class="token keyword">if</span> a <span class="token operator">&lt;=</span> b <span class="token keyword">then</span> a <span class="token keyword">else</span> b <span class="token punctuation">[</span><span class="token operator">@@</span>inline<span class="token punctuation">]</span>

<span class="token keyword">let</span> x <span class="token operator">=</span> min <span class="token number">0</span> <span class="token number">1</span></code></pre></div>
<p>We have:</p>
<div class="gatsby-highlight" data-language="cmm"><pre class="language-cmm"><code class="language-cmm">(function{main.ml:2,8-43} camlMain__min_1003 (a/1004: val b/1005: val)
 (if (&lt;= a/1004 b/1005) a/1004 b/1005))

(function camlMain__entry ()
 (let x/1006 1 (store val(root-init) (+a &quot;camlMain&quot; 8) 1)) 1a)</code></pre></div>
<div class="gatsby-highlight" data-language="asm"><pre class="language-asm"><code class="language-asm">.L101:
        cmpq    %rbx, %rax
        jg      .L100
        ret</code></pre></div>
<p>So we have all optimizations, in this produced code, <code>x</code> was evaluated as <code>0</code>
(<code>let x/... (store ... 1)</code>) (beta-reduction and inlining) and <code>min</code> was
specialized to accept only integers – so we are able to emit <code>cmpq</code>.</p>
<h3 id="results" style="position:relative;"><a href="#results" aria-label="results permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Results</h3>
<p>With specialization, we won 10 Mb/s on decompression, where <code>min</code> is used
in several places. We completely avoid an indirection and a call to the slow
<code>do_compare_val</code> function.</p>
<p>This kind of specialization is already done by <a href="https://caml.inria.fr/pub/docs/manual-ocaml/flambda.html"><code>flambda</code></a>, however, we
currently use OCaml 4.07.1. So we decided to this kind of optimization by
ourselves.</p>
<h2 id="inlining" style="position:relative;"><a href="#inlining" aria-label="inlining permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Inlining</h2>
<p>In the first example, we showed code with the <code>[@@inline]</code> keyword which is
useful to force the compiler to inline a little function. We will go outside the
OCaml world and study C code (gcc 5.4.0) to really understand
<em>inlining</em>.</p>
<p>In fact, inlining is not necessarily the best optimization. Consider the
following (nonsensical) C program:</p>
<div class="gatsby-highlight" data-language="c"><pre class="language-c"><code class="language-c"><span class="token macro property"><span class="token directive-hash">#</span><span class="token directive keyword">include</span> <span class="token string">&lt;stdio.h></span></span>
<span class="token macro property"><span class="token directive-hash">#</span><span class="token directive keyword">include</span> <span class="token string">&lt;string.h></span></span>
<span class="token macro property"><span class="token directive-hash">#</span><span class="token directive keyword">include</span> <span class="token string">&lt;unistd.h></span></span>
<span class="token macro property"><span class="token directive-hash">#</span><span class="token directive keyword">include</span> <span class="token string">&lt;time.h></span></span>
<span class="token macro property"><span class="token directive-hash">#</span><span class="token directive keyword">include</span> <span class="token string">&lt;stdlib.h></span></span>

<span class="token macro property"><span class="token directive-hash">#</span><span class="token directive keyword">ifdef</span> <span class="token expression">HIDE_ALIGNEMENT</span></span>
<span class="token keyword">__attribute__</span><span class="token punctuation">(</span><span class="token punctuation">(</span>noinline<span class="token punctuation">,</span> noclone<span class="token punctuation">)</span><span class="token punctuation">)</span>
<span class="token macro property"><span class="token directive-hash">#</span><span class="token directive keyword">endif</span></span>
<span class="token keyword">void</span> <span class="token operator">*</span>
<span class="token function">hide</span><span class="token punctuation">(</span><span class="token keyword">void</span> <span class="token operator">*</span> p<span class="token punctuation">)</span> <span class="token punctuation">{</span> <span class="token keyword">return</span> p<span class="token punctuation">;</span> <span class="token punctuation">}</span>

<span class="token keyword">int</span> <span class="token function">main</span><span class="token punctuation">(</span><span class="token keyword">int</span> ac<span class="token punctuation">,</span> <span class="token keyword">const</span> <span class="token keyword">char</span> <span class="token operator">*</span>av<span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token punctuation">)</span>
<span class="token punctuation">{</span>
  <span class="token keyword">char</span> <span class="token operator">*</span>s <span class="token operator">=</span> <span class="token function">calloc</span><span class="token punctuation">(</span><span class="token number">1</span> <span class="token operator">&lt;&lt;</span> <span class="token number">20</span><span class="token punctuation">,</span> <span class="token number">1</span><span class="token punctuation">)</span><span class="token punctuation">;</span>
  s <span class="token operator">=</span> <span class="token function">hide</span><span class="token punctuation">(</span>s<span class="token punctuation">)</span><span class="token punctuation">;</span>

  <span class="token function">memset</span><span class="token punctuation">(</span>s<span class="token punctuation">,</span> <span class="token string">'B'</span><span class="token punctuation">,</span> <span class="token number">100000</span><span class="token punctuation">)</span><span class="token punctuation">;</span>

  <span class="token class-name">clock_t</span> start <span class="token operator">=</span> <span class="token function">clock</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">;</span>

  <span class="token keyword">for</span> <span class="token punctuation">(</span><span class="token keyword">int</span> i <span class="token operator">=</span> <span class="token number">0</span><span class="token punctuation">;</span> i <span class="token operator">&lt;</span> <span class="token number">1280000</span><span class="token punctuation">;</span> <span class="token operator">++</span>i<span class="token punctuation">)</span>
    s<span class="token punctuation">[</span><span class="token function">strlen</span><span class="token punctuation">(</span>s<span class="token punctuation">)</span><span class="token punctuation">]</span> <span class="token operator">=</span> <span class="token string">'A'</span><span class="token punctuation">;</span>

  <span class="token class-name">clock_t</span> end <span class="token operator">=</span> <span class="token function">clock</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">;</span>

  <span class="token function">printf</span><span class="token punctuation">(</span><span class="token string">"%lld\\n"</span><span class="token punctuation">,</span> <span class="token punctuation">(</span><span class="token keyword">long</span> <span class="token keyword">long</span><span class="token punctuation">)</span> <span class="token punctuation">(</span>end<span class="token operator">-</span>start<span class="token punctuation">)</span><span class="token punctuation">)</span><span class="token punctuation">;</span>

  <span class="token keyword">return</span> <span class="token number">0</span><span class="token punctuation">;</span>
<span class="token punctuation">}</span></code></pre></div>
<p>We will compile this code with <code>-O2</code> (the second level of optimization in C),
once with <code>-DHIDE_ALIGNEMENT</code> and once without. The assembly emitted differs:</p>
<div class="gatsby-highlight" data-language="asm"><pre class="language-asm"><code class="language-asm">.L3:
	movq	%rbp, %rdi
	call	strlen
	subl	$1, %ebx
	movb	$65, 0(%rbp,%rax)
	jne	.L3</code></pre></div>
<div class="gatsby-highlight" data-language="asm"><pre class="language-asm"><code class="language-asm">.L3:
	movl	(%rdx), %ecx
	addq	$4, %rdx
	leal	-16843009(%rcx), %eax
	notl	%ecx
	andl	%ecx, %eax
	andl	$-2139062144, %eax
	je	.L3</code></pre></div>
<p>In the first output (with <code>-DHIDE_ALIGNEMENT</code>), the optimization pass
decides to disable inlining of <code>strlen</code>; in the second output (without
<code>-DHIDEAlIGNEMENT</code>), it decides to inline <code>strlen</code> (and do some other clever
optimizations). The reason behind this complex behavior from the compiler is
clearly described <a href="https://stackoverflow.com/a/55589634">here</a>.</p>
<p>But what we want to say is that inlining is <strong>not</strong> an automatic optimization;
it might act as a <em>pessimization</em>. This is the goal of <code>flambda</code>: do the right
optimization under the right context. If you are really curious about what <code>gcc</code>
does and why, even if it's very interesting, the reverse engineering of the
optimization process and which information is relevant about the choice to
optimize or not is deep, long and surely too complicated.</p>
<p>A non-spontaneous optimization is to annotate some parts of your code with
<code>[@@inline never]</code> – so, explicitly say to the compiler to not inline the
function. This constraint is to help the compiler to generate a smaller code
which will have more chance to fit under the processor cache.</p>
<p>For all of these reasons, <code>[@@inline]</code> should be used sparingly and an oracle to
compare performances if you inline or not this or this function is necessary to
avoid a <em>pessimization</em>.</p>
<h3 id="in-decompress" style="position:relative;"><a href="#in-decompress" aria-label="in decompress permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>In <code>decompress</code></h3>
<p>Inlining in <code>decompress</code> was done on small functions which need to allocate
to return a value. If we inline them, we can take the opportunity to store
returned value in registers (of course, it depends how many registers are free).</p>
<p>As we said, the goal of the inflator is to translate a bit sequence to a byte.
The largest bit sequence possible according to RFC 1951 has length 15. So, when
we process an inputs flow, we eat it 15 bits per 15 bits. For each packet, we
want to recognize an existing associated bit sequence and then, binded values
will be the real length of the bit sequence and the byte:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">val</span> find <span class="token punctuation">:</span> bits<span class="token punctuation">:</span>int <span class="token operator">-></span> <span class="token punctuation">{</span> len<span class="token punctuation">:</span> int<span class="token punctuation">;</span> byte<span class="token punctuation">:</span> int<span class="token punctuation">;</span> <span class="token punctuation">}</span></code></pre></div>
<p>So for each call to this function, we need to allocate a record/tuple. It's
why we choose to inline this function. <code>min</code> was inlined too and some other
small functions. But as we said, the situation is complex; where we think that
<em>inlining</em> can help us, it's not systematically true.</p>
<p>NOTE: we can recognize bits sequence with, at most, 15 bits because a
<a href="https://zlib.net/feldspar.html">Huffman coding</a> is <a href="https://en.wikipedia.org/wiki/Prefix_code">prefix-free</a>.</p>
<h2 id="untagged-integers" style="position:relative;"><a href="#untagged-integers" aria-label="untagged integers permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Untagged integers</h2>
<p>When reading assembly, the integer <code>0</code> is written as <code>$1</code>.
It's because of the <a href="https://blog.janestreet.com/what-is-gained-and-lost-with-63-bit-integers/">GC bit</a> needed to differentiate a pointer
and an unboxed integer. This is why, in OCaml, we talk about a 31-bits integer
or a 63-bits integer (depending on your architecture).</p>
<p>We will not try to start a debate about this arbitrary choice on the
representation of an integer in OCaml. However, we can talk about some
operations which can have an impact on performances.</p>
<p>The biggest example is about the <code>mod</code> operation. Between OCaml and C, <code>%</code> or
<code>mod</code> should be the same:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> f a b <span class="token operator">=</span> a <span class="token operator">mod</span> b</code></pre></div>
<p>The output assembly is:</p>
<div class="gatsby-highlight" data-language="asm"><pre class="language-asm"><code class="language-asm">.L105:
        movq    %rdi, %rcx
        sarq    $1, %rcx     // b &gt;&gt; 1
        movq    (%rsp), %rax
        sarq    $1, %rax     // a &gt;&gt; 1
        testq   %rcx, %rcx   // b != 0
        je      .L107
        cqto
        idivq   %rcx         // a % b
        jmp     .L106
.L107:
        movq    caml_backtrace_pos@GOTPCREL(%rip), %rax
        xorq    %rbx, %rbx
        movl    %ebx, (%rax)
        movq    caml_exn_Division_by_zero@GOTPCREL(%rip), %rax
        call    caml_raise_exn@PLT
.L106:
        salq    $1, %rdx     // x &lt;&lt; 1
        incq    %rdx         // x + 1
        movq    %rbx, %rax</code></pre></div>
<p>where idiomatically the same C code produce:</p>
<div class="gatsby-highlight" data-language="asm"><pre class="language-asm"><code class="language-asm">.L2:
        movl    -12(%rbp), %eax
        cltd
        idivl   -8(%rbp)
        movl    %edx, -4(%rbp)</code></pre></div>
<p>Of course, we can notice firstly the exception in OCaml (<code>Divided_by_zero</code>) -
which is pretty good because it protects us against an interrupt from assembly
(and keep the trace). Then, we need to <em>untag</em> <code>a</code> and <code>b</code> with <code>sarq</code> assembly
operation. We do, as the C code, <code>idiv</code> and then we must <em>retag</em> returned value
<code>x</code> with <code>salq</code> and <code>incq</code>.</p>
<p>So in some parts, it should be more interesting to use <code>Nativeint</code>. However, by
default, a <code>nativeint</code> is boxed. <em>boxed</em> means that the value is allocated in
the OCaml heap alongside a header.</p>
<p>Of course, this is not what we want so, if our <code>nativeint ref</code> (to have
side-effect, like <code>x</code>) stay inside a function and then, you return the real
value with the deref <code>!</code> operator, OCaml, by a good planet alignment, can
directly use registers and real integers. So it should be possible to avoid
these needed conversions.</p>
<h3 id="readability-versus-performance" style="position:relative;"><a href="#readability-versus-performance" aria-label="readability versus performance permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Readability versus performance</h3>
<p>We use this optimization only in few parts of the code. In fact, switch
between <code>int</code> and <code>nativeint</code> is little bit noisy:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml">hold <span class="token operator">:=</span> <span class="token module variable">Nativeint</span><span class="token punctuation">.</span>logor <span class="token operator">!</span>hold <span class="token module variable">Nativeint</span><span class="token punctuation">.</span><span class="token punctuation">(</span>shift_left <span class="token punctuation">(</span>of_int <span class="token punctuation">(</span>unsafe_get_uint8 d<span class="token punctuation">.</span>i <span class="token operator">!</span>i_pos<span class="token punctuation">)</span><span class="token punctuation">)</span> <span class="token operator">!</span>bits<span class="token punctuation">)</span></code></pre></div>
<p>In the end, we only gained 0.5Mb/s of inflation rate, so it's not worthwhile
to do systematically this optimization. Especially that the gain is not very
big. But this case show a more troubling problem: loss of readability.</p>
<p>In fact, we can optimize more and more a code (OCaml or C) but we lost, step by
step, readability. You should be afraid by the implementation of <code>strlen</code> for
example. In the end, the loss of readability makes it harder to understand the purpose
of the code, leading to errors whenever some other person (or you in 10 years time)
tries to make a change.</p>
<p>And we think that this kind of optimization is not the way of OCaml in general
where we prefer to produce an understandable and abstracted code than a cryptic
and super fast one.</p>
<p>Again, <code>flambda</code> wants to fix this problem and let the compiler to do this
optimization. The goal is to be able to write a fast code without any pain.</p>
<h2 id="exceptions" style="position:relative;"><a href="#exceptions" aria-label="exceptions permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Exceptions</h2>
<p>If you remember our <a href="https://tarides.com/blog/2019-02-08-release-of-base64.html">article</a> about the release of <code>base64</code>, we talked a
bit about exceptions and used them as a <em>jump</em>. In fact, it's pretty
common for an OCaml developer to break the control-flow with an exception.
Behind this common design/optimization, it's about calling convention.</p>
<p>Indeed, choose the <em>jump</em> word to describe OCaml exception is not the best where
we don't use <code>setjmp</code>/<code>longjmp</code>.</p>
<p>In the details, when you start a code with a <code>try .. with</code>, OCaml saves a <em>trap</em>
in the stack which contains information about the <code>with</code>, the catcher. Then,
when you <code>raise</code>, you <em>jump</em> directly to this trap and can just discard several
stack frames (and, by this way, you did not check each return codes).</p>
<p>In several places and mostly in the <em>hot-loop</em>, we use this <em>pattern</em>. However,
it completely breaks the control flow and can be error-prone.</p>
<p>To limit errors and because this pattern is usual, we prefer to use a <em>local</em>
exception which will be used only inside the function. By this way, we enforce
the fact that exception should not (and can not) be caught by something else
than inside the function.</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml">    <span class="token keyword">let</span> <span class="token keyword">exception</span> <span class="token module variable">Break</span> <span class="token keyword">in</span>

    <span class="token punctuation">(</span> <span class="token keyword">try</span> <span class="token keyword">while</span> <span class="token operator">!</span>max <span class="token operator">>=</span> <span class="token number">1</span> <span class="token keyword">do</span>
          <span class="token keyword">if</span> bl_count<span class="token punctuation">.</span><span class="token punctuation">(</span><span class="token operator">!</span>max<span class="token punctuation">)</span> <span class="token operator">!=</span> <span class="token number">0</span> <span class="token keyword">then</span> raise_notrace <span class="token module variable">Break</span>
        <span class="token punctuation">;</span> decr max <span class="token keyword">done</span> <span class="token keyword">with</span> <span class="token module variable">Break</span> <span class="token operator">-></span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">)</span> <span class="token punctuation">;</span></code></pre></div>
<p>This code above produce this assembly code:</p>
<div class="gatsby-highlight" data-language="asm"><pre class="language-asm"><code class="language-asm">.L105:
        pushq   %r14
        movq    %rsp, %r14
.L103:
        cmpq    $3, %rdi              // while !max &gt;= 1
        jl      .L102
        movq    -4(%rbx,%rdi,4), %rsi // bl_count,(!max)
        cmpq    $1, %rsi              // bl_count.(!max) != 0
        je      .L104
        movq    %r14, %rsp
        popq    %r14
        ret                           // raise_notrace Break
.L104:
        addq    $-2, %rdi             // decr max
        movq    %rdi, 16(%rsp)
        jmp     .L103</code></pre></div>
<p>Where the <code>ret</code> is the <code>raise_notrace Break</code>. A <code>raise_notrace</code> is needed,
otherwise, you will see:</p>
<div class="gatsby-highlight" data-language="asm"><pre class="language-asm"><code class="language-asm">        movq    caml_backtrace_pos@GOTPCREL(%rip), %rbx
        xorq    %rdi, %rdi
        movl    %edi, (%rbx)
        call    caml_raise_exn@PLT</code></pre></div>
<p>Instead the <code>ret</code> assembly code. Indeed, in this case, we need to store where we
raised the exception.</p>
<h2 id="unrolling" style="position:relative;"><a href="#unrolling" aria-label="unrolling permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Unrolling</h2>
<p>When we showed the optimization done by <code>gcc</code> when the string is aligned, <code>gcc</code>
did another optimization. Instead of setting the string byte per byte, it decides to
update it 4 bytes per 4 bytes.</p>
<p>This kind of this optimization is an <em>unroll</em> and we did it in <code>decompress</code>.
Indeed, when we reach the <em>copy</em> <em>opcode</em> emitted by the <a href="https://en.wikipedia.org/wiki/LZ77_and_LZ78">lz77</a>
compressor, we want to <em>blit</em> <em>length</em> byte(s) from a source to the outputs
flow. It can appear that this <code>memcpy</code> can be optimized to copy 4 bytes per 4
bytes – 4 bytes is generally a good idea where it's the size of an <code>int32</code> and
should fit under any architectures.</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> blit src src_off dst dst_off <span class="token operator">=</span>
  <span class="token keyword">if</span> dst_off – src_off <span class="token operator">&lt;</span> <span class="token number">4</span>
  <span class="token keyword">then</span> slow_blit src src_off dst dst_off
  <span class="token keyword">else</span>
    <span class="token keyword">let</span> len0 <span class="token operator">=</span> len <span class="token operator">land</span> <span class="token number">3</span> <span class="token keyword">in</span>
    <span class="token keyword">let</span> len1 <span class="token operator">=</span> len <span class="token operator">asr</span> <span class="token number">2</span> <span class="token keyword">in</span>

    <span class="token keyword">for</span> i <span class="token operator">=</span> <span class="token number">0</span> <span class="token keyword">to</span> len1 – <span class="token number">1</span>
    <span class="token keyword">do</span>
      <span class="token keyword">let</span> i <span class="token operator">=</span> i <span class="token operator">*</span> <span class="token number">4</span> <span class="token keyword">in</span>
      <span class="token keyword">let</span> v <span class="token operator">=</span> unsafe_get_uint32 src <span class="token punctuation">(</span>src_off <span class="token operator">+</span> i<span class="token punctuation">)</span> <span class="token keyword">in</span>
      unsafe_set_uint32 dst <span class="token punctuation">(</span>dst_off <span class="token operator">+</span> i<span class="token punctuation">)</span> v <span class="token punctuation">;</span>
    <span class="token keyword">done</span> <span class="token punctuation">;</span>

    <span class="token keyword">for</span> i <span class="token operator">=</span> <span class="token number">0</span> <span class="token keyword">to</span> len0 – <span class="token number">1</span>
    <span class="token keyword">do</span>
      <span class="token keyword">let</span> i <span class="token operator">=</span> len1 <span class="token operator">*</span> <span class="token number">4</span> <span class="token operator">+</span> i <span class="token keyword">in</span>
      <span class="token keyword">let</span> v <span class="token operator">=</span> unsafe_get_uint8 src <span class="token punctuation">(</span>src_off <span class="token operator">+</span> i<span class="token punctuation">)</span> <span class="token keyword">in</span>
      unsafe_set_uint8 dst <span class="token punctuation">(</span>dst_off <span class="token operator">+</span> i<span class="token punctuation">)</span> v <span class="token punctuation">;</span>
    <span class="token keyword">done</span></code></pre></div>
<p>In this code, at the beginning, we copy 4 bytes per 4 bytes and if <code>len</code> is not
a multiple of 4, we start the <em>trailing</em> loop to copy byte per byte then. In
this context, OCaml can <em>unbox</em> <code>int32</code> and use registers. So this function does
not deal with the heap, and by this way, with the garbage collector.</p>
<h3 id="results-1" style="position:relative;"><a href="#results-1" aria-label="results 1 permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Results</h3>
<p>In the end, we gained an extra 10Mb/s of inflation rate. The <code>blit</code> function is the
most important function when it comes to inflating the window to an output flow.
As the specialization on the <code>min</code> function, this is one of the biggest optimization on
<code>decompress</code>.</p>
<h2 id="hot-loop" style="position:relative;"><a href="#hot-loop" aria-label="hot loop permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a><em>hot-loop</em></h2>
<p>A common design about decompression (but we can find it on hash implementation
too), is the <em>hot-loop</em>. An <em>hot-loop</em> is mainly a loop on the most common
operation in your process. In the context of <code>decompress</code>, the <em>hot-loop</em> is
about a repeated translation from bits-sequence to byte(s) from the inputs flow
to the outputs flow and the window.</p>
<p>The main idea behind the <em>hot-loop</em> is to initialize all information needed for
the translation before to start the <em>hot-loop</em>. Then, it's mostly an imperative
loop with a <em>pattern-matching</em> which corresponds to the current state of the
global computation.</p>
<p>In OCaml, we can take this opportunity to use <code>int ref</code> (or <code>nativeint ref</code>), and then, they will be translated into registers (which is the fastest
area to store something).</p>
<p>Another deal inside the <em>hot-loop</em> is to avoid any allocation – and it's why we
talk about <code>int</code> or <code>nativeint</code>. Indeed, a more complex structure like an option
will add a blocker to the garbage collection (a call to <code>caml_call_gc</code>).</p>
<p>Of course, this kind of design is completely wrong if we think in a functional
way. However, this is the (biggest?) advantage of OCaml: hide this ugly/hacky
part inside a functional interface.</p>
<p>In the API, we talked about a state which represents the <em>inflation</em> (or the
<em>deflation</em>). At the beginning, the goal is to store into some references
essentials values like the position into the inputs flow, bits available,
dictionary, etc. Then, we launch the <em>hot-loop</em> and only at the end, we update the state.</p>
<p>So we keep the optimal design about <em>inflation</em> and the functional way outside
the <em>hot-loop</em>.</p>
<h2 id="caml_modify" style="position:relative;"><a href="#caml_modify" aria-label="caml_modify permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>caml_modify</h2>
<p>One issue that we need to consider is the call to <code>caml_modify</code>. In
fact, for a complex data-structure like an <code>int array</code> or a <code>int option</code> (so,
other than an integer or a boolean or an <em>immediate</em> value), values can move to the
major heap.</p>
<p>In this context, <code>caml_modify</code> is used to assign a new value into your mutable
block. It is a bit slower than a simple assignment but needed to
ensure pointer correspondence between minor heap and major heap.</p>
<p>With this OCaml code for example:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">type</span> t <span class="token operator">=</span> <span class="token punctuation">{</span> <span class="token keyword">mutable</span> v <span class="token punctuation">:</span> int option <span class="token punctuation">}</span>

<span class="token keyword">let</span> f t v <span class="token operator">=</span> t<span class="token punctuation">.</span>v <span class="token operator">&lt;-</span> v</code></pre></div>
<p>We produce this assembly:</p>
<div class="gatsby-highlight" data-language="asm"><pre class="language-asm"><code class="language-asm">camlExample__f_1004:
        subq    $8, %rsp
        movq    %rax, %rdi
        movq    %rbx, %rsi
        call    caml_modify@PLT
        movq    $1, %rax
        addq    $8, %rsp
        ret</code></pre></div>
<p>Where we see the call to <code>caml_modify</code> which will be take care about the
assignment of <code>v</code> into <code>t.v</code>. This call is needed mostly because the type of <code>t.v</code> is not an <em>immediate</em> value like an integer. So, for many values in the
<em>inflator</em> and the <em>deflator</em>, we mostly use integers.</p>
<p>Of course, at some points, we use <code>int array</code> and set them at some specific
points of the <em>inflator</em> – where we inflated the dictionary. However, the impact
of <code>caml_modify</code> is not very clear where it is commonly pretty fast.</p>
<p>Sometimes, however, it can be a real bottleneck in your computation and
this depends on how long your values live in the heap. A little program (which is
not very reproducible) can show that:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> t <span class="token operator">=</span> <span class="token module variable">Array</span><span class="token punctuation">.</span>init <span class="token punctuation">(</span>int_of_string <span class="token module variable">Sys</span><span class="token punctuation">.</span>argv<span class="token punctuation">.</span><span class="token punctuation">(</span><span class="token number">1</span><span class="token punctuation">)</span><span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token keyword">fun</span> <span class="token punctuation">_</span> <span class="token operator">-></span> <span class="token module variable">Random</span><span class="token punctuation">.</span>int <span class="token number">256</span><span class="token punctuation">)</span>

<span class="token keyword">let</span> pr fmt <span class="token operator">=</span> <span class="token module variable">Format</span><span class="token punctuation">.</span>printf fmt

<span class="token keyword">type</span> t0 <span class="token operator">=</span> <span class="token punctuation">{</span> <span class="token keyword">mutable</span> v <span class="token punctuation">:</span> int option <span class="token punctuation">}</span>
<span class="token keyword">type</span> t1 <span class="token operator">=</span> <span class="token punctuation">{</span> v <span class="token punctuation">:</span> int option <span class="token punctuation">}</span>

<span class="token keyword">let</span> f0 <span class="token punctuation">(</span>t0 <span class="token punctuation">:</span> t0<span class="token punctuation">)</span> <span class="token operator">=</span>
  <span class="token keyword">for</span> i <span class="token operator">=</span> <span class="token number">0</span> <span class="token keyword">to</span> <span class="token module variable">Array</span><span class="token punctuation">.</span>length t – <span class="token number">1</span>
  <span class="token keyword">do</span> <span class="token keyword">let</span> v <span class="token operator">=</span> <span class="token keyword">match</span> t0<span class="token punctuation">.</span>v<span class="token punctuation">,</span> t<span class="token punctuation">.</span><span class="token punctuation">(</span>i<span class="token punctuation">)</span> <span class="token keyword">with</span>
             <span class="token operator">|</span> <span class="token module variable">Some</span> <span class="token punctuation">_</span> <span class="token keyword">as</span> v<span class="token punctuation">,</span> <span class="token punctuation">_</span> <span class="token operator">-></span> v
             <span class="token operator">|</span> <span class="token module variable">None</span><span class="token punctuation">,</span> <span class="token number">5</span> <span class="token operator">-></span> <span class="token module variable">Some</span> i
             <span class="token operator">|</span> <span class="token module variable">None</span><span class="token punctuation">,</span> <span class="token punctuation">_</span> <span class="token operator">-></span> <span class="token module variable">None</span> <span class="token keyword">in</span>
     t0<span class="token punctuation">.</span>v <span class="token operator">&lt;-</span> v
  <span class="token keyword">done</span><span class="token punctuation">;</span> t0

<span class="token keyword">let</span> f1 <span class="token punctuation">(</span>t1 <span class="token punctuation">:</span> t1<span class="token punctuation">)</span> <span class="token operator">=</span>
  <span class="token keyword">let</span> t1 <span class="token operator">=</span> ref t1 <span class="token keyword">in</span>
  <span class="token keyword">for</span> i <span class="token operator">=</span> <span class="token number">0</span> <span class="token keyword">to</span> <span class="token module variable">Array</span><span class="token punctuation">.</span>length t – <span class="token number">1</span>
  <span class="token keyword">do</span> <span class="token keyword">let</span> v <span class="token operator">=</span> <span class="token keyword">match</span> <span class="token operator">!</span>t1<span class="token punctuation">.</span>v<span class="token punctuation">,</span> t<span class="token punctuation">.</span><span class="token punctuation">(</span>i<span class="token punctuation">)</span> <span class="token keyword">with</span>
             <span class="token operator">|</span> <span class="token module variable">Some</span> <span class="token punctuation">_</span> <span class="token keyword">as</span> v<span class="token punctuation">,</span> <span class="token punctuation">_</span> <span class="token operator">-></span> v
             <span class="token operator">|</span> <span class="token module variable">None</span><span class="token punctuation">,</span> <span class="token number">5</span> <span class="token operator">-></span> <span class="token module variable">Some</span> i
             <span class="token operator">|</span> <span class="token module variable">None</span><span class="token punctuation">,</span> <span class="token punctuation">_</span> <span class="token operator">-></span> <span class="token module variable">None</span> <span class="token keyword">in</span>
     t1 <span class="token operator">:=</span> <span class="token punctuation">{</span> v <span class="token punctuation">}</span>
  <span class="token keyword">done</span><span class="token punctuation">;</span> <span class="token operator">!</span>t1

<span class="token keyword">let</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">=</span>
  <span class="token keyword">let</span> t0 <span class="token punctuation">:</span> t0 <span class="token operator">=</span> <span class="token punctuation">{</span> v<span class="token operator">=</span> <span class="token module variable">None</span> <span class="token punctuation">}</span> <span class="token keyword">in</span>
  <span class="token keyword">let</span> t1 <span class="token punctuation">:</span> t1 <span class="token operator">=</span> <span class="token punctuation">{</span> v<span class="token operator">=</span> <span class="token module variable">None</span> <span class="token punctuation">}</span> <span class="token keyword">in</span>
  <span class="token keyword">let</span> time0 <span class="token operator">=</span> <span class="token module variable">Unix</span><span class="token punctuation">.</span>gettimeofday <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token keyword">in</span>
  ignore <span class="token punctuation">(</span>f0 t0<span class="token punctuation">)</span> <span class="token punctuation">;</span>
  <span class="token keyword">let</span> time1 <span class="token operator">=</span> <span class="token module variable">Unix</span><span class="token punctuation">.</span>gettimeofday <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token keyword">in</span>
  ignore <span class="token punctuation">(</span>f1 t1<span class="token punctuation">)</span> <span class="token punctuation">;</span>
  <span class="token keyword">let</span> time2 <span class="token operator">=</span> <span class="token module variable">Unix</span><span class="token punctuation">.</span>gettimeofday <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token keyword">in</span>

  pr <span class="token string">"f0: %f ns\\n%!"</span> <span class="token punctuation">(</span>time1 <span class="token operator">-.</span> time0<span class="token punctuation">)</span> <span class="token punctuation">;</span>
  pr <span class="token string">"f1: %f ns\\n%!"</span> <span class="token punctuation">(</span>time2 <span class="token operator">-.</span> time1<span class="token punctuation">)</span> <span class="token punctuation">;</span>

  <span class="token punctuation">(</span><span class="token punctuation">)</span></code></pre></div>
<p>In our bare-metal server, if you launch the program with 1000, the <code>f0</code>
computation, even if it has <code>caml_modify</code> will be the fastest. However, if you
launch the program with 1000000000, <code>f1</code> will be the fastest.</p>
<div class="gatsby-highlight" data-language="sh"><pre class="language-sh"><code class="language-sh">$ ./a.out 1000
f0: 0.000006 ns
f1: 0.000015 ns
$ ./a.out 1000000000
f0: 7.931782 ns
f1: 5.719370 ns</code></pre></div>
<h3 id="about-decompress" style="position:relative;"><a href="#about-decompress" aria-label="about decompress permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>About <code>decompress</code></h3>
<p>At the beginning, our choice was made to have, as @dbuenzli does, mutable
structure to represent state. Then, @yallop did a big patch to update it to an
immutable state and we won 9Mb/s on <em>inflation</em>.</p>
<p>However, the new version is more focused on the <em>hot-loop</em> and it is 3
times faster than before.</p>
<p>As we said, the deal about <code>caml_modify</code> is not clear and depends a lot about
how long your data lives in the heap and how many times you want to update it.
If we localize <code>caml_modify</code> only on few places, it should be fine. But it still
is one of the most complex question about (macro?) optimization.</p>
<h2 id="smaller-representation" style="position:relative;"><a href="#smaller-representation" aria-label="smaller representation permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Smaller representation</h2>
<p>We've discussed the impact that integer types can have on the use of immediate
values. More generally, the choice of type to represent your values can have
significant performance implications.</p>
<p>For example, a dictionary which associates a bits-sequence (an integer) to the
length of it <strong>AND</strong> the byte, it can be represented by a: <code>(int * int) array</code>, or
more idiomatically <code>{ len: int; byte: int; } array</code> (which is structurally the
same).</p>
<p>However, that means an allocation for each bytes to represent every bytes.
Extraction of it will need an allocation if <code>find : bits:int -> { len: int; byte: int; }</code> is not inlined as we said. And about memory, the array can be
really <em>heavy</em> in your heap.</p>
<p>At this point, we used <code>spacetime</code> to show how many blocks we allocated for a
common <em>inflation</em> and we saw that we allocate a lot. The choice was made to use
a smaller representation. Where <code>len</code> can not be upper than 15 according RFC 1951
and when byte can represent only 256 possibilities (and should fit under one
byte), we can decide to merge them into one integer (which can have, at least,
31 bits).</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> static_literal_tree <span class="token operator">=</span> <span class="token punctuation">[</span><span class="token operator">|</span> <span class="token punctuation">(</span><span class="token number">8</span><span class="token punctuation">,</span> <span class="token number">12</span><span class="token punctuation">)</span><span class="token punctuation">;</span> <span class="token punctuation">(</span><span class="token number">8</span><span class="token punctuation">,</span> <span class="token number">140</span><span class="token punctuation">)</span><span class="token punctuation">;</span> <span class="token punctuation">(</span><span class="token number">8</span><span class="token punctuation">,</span> <span class="token number">76</span><span class="token punctuation">)</span><span class="token punctuation">;</span> <span class="token punctuation">.</span><span class="token punctuation">.</span><span class="token punctuation">.</span> <span class="token operator">|</span><span class="token punctuation">]</span>
<span class="token keyword">let</span> static_literal_tree <span class="token operator">=</span> <span class="token module variable">Array</span><span class="token punctuation">.</span>map <span class="token punctuation">(</span><span class="token keyword">fun</span> <span class="token punctuation">(</span>len<span class="token punctuation">,</span> byte<span class="token punctuation">)</span> <span class="token operator">-></span> <span class="token punctuation">(</span>len <span class="token operator">lsl</span> <span class="token number">8</span><span class="token punctuation">)</span> <span class="token operator">lor</span> byte<span class="token punctuation">)</span> static_literal_tree</code></pre></div>
<p>In the code above, we just translate the static dictionary (for a STATIC DEFLATE
block) to a smaller representation where <code>len</code> will be the left part of the
integer and <code>byte</code> will be the right part. Of course, it's depends on what you
want to store.</p>
<p>Another point is readability. <a href="https://github.com/mirage/ocaml-cstruct#ppx"><code>cstruct-ppx</code></a> and
<a href="https://bitbucket.org/thanatonauts/bitstring/src"><code>bitstring</code></a> can help you but <code>decompress</code>
wants to depend only on OCaml.</p>
<h2 id="conclusion" style="position:relative;"><a href="#conclusion" aria-label="conclusion permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Conclusion</h2>
<p>We conclude with some closing advice about optimising your OCaml programs:</p>
<ul>
<li><strong>Optimization is specific to your task</strong>. The points highlighted in this
article may not fit your particular problem, but they are intended to give you
ideas. Our optimizations were only possible because we completely assimilated
the ideas of <code>zlib</code> and had a clear vision of what we really needed to
optimize (like <code>blit</code>).
<br/><br/>
As your first project, this article can not help you a lot to optimize your
code where it's mostly about <em>micro</em>-optimization under a specific context
(<em>hot-loop</em>). But it helps you to understand what is really done by the
compiler – which is still really interesting.</li>
<li><strong>Optimise only with respect to an oracle</strong>. All optimizations were done
because we did a comparison point between the old implementation of
<code>decompress</code> and <code>zlib</code> as oracles. Optimizations can change the semantics of your
code and you should systematically take care at any step about expected
behaviors. So it's a long run.</li>
<li><strong>Use the predictability of the OCaml compiler to your advantage</strong>. For sure,
the compiler does not optimize a lot your code – but it sill produce realistic
programs if we think about performance. For many cases, <strong>you don't need</strong> to
optimize your OCaml code. And the good point is about expected behavior.
<br/><br/>
The mind-link between the OCaml and the assembly exists (much more than the C
and the assembly sometimes where we let the C compiler to optimize the code).
The cool fact is to keep a mental-model about what is going on on your code
easily without to be afraid by what the compiler can produce. And, in some
critical parts like <a href="https://github.com/mirage/eqaf">eqaf</a>, it's really needed.</li>
</ul>
<p>We have not discussed benchmarking, which is another hard issue: who should you
compare with? where? how? For example, a global comparison between <code>zlib</code> and
<code>decompress</code> is not very relevant in many ways – especially because of the
garbage collector. This could be another article!</p>
<p>Finally, all of these optimizations should be done by <code>flambda</code>; the difference
between compiling <code>decompress</code> with or without <code>flambda</code> is not very big. We
optimized <code>decompress</code> by hand mostly to keep compatibility with OCaml (since
<code>flambda</code> needs another switch) and, in this way, to gain an understanding of
<code>flambda</code> optimizations so that we can use it effectively!</p>|js}
  };
 
  { title = {js|Decompress: The New Decompress API|js}
  ; slug = {js|decompress-the-new-decompress-api|js}
  ; description = Some {js|RFC 1951 is one of the most used standards. Indeed,
when you launch your Linux kernel, it inflates itself according zlib
standard, a…|js}
  ; url = {js|https://tarides.com/blog/2019-08-26-decompress-the-new-decompress-api|js}
  ; date = {js|2019-08-26T00:00:00-00:00|js}
  ; preview_image = Some {js|https://tarides.com/static/eeb13afbb9190097a8d04be9e1361642/2244e/hammock.jpg|js}
  ; body_html = {js|<p><a href="https://tools.ietf.org/html/rfc1951">RFC 1951</a> is one of the most used standards. Indeed,
when you launch your Linux kernel, it inflates itself according <a href="https://zlib.net/">zlib</a>
standard, a superset of RFC 1951. Being a widely-used standard, we decided to
produce an OCaml implementation. In the process, we learned many lessons about
developing OCaml where we would normally use C. So, we are glad to present
<a href="https://github.com/mirage/decompress"><code>decompress</code></a>.</p>
<p>One of the many users of RFC 1951 is <a href="https://git-scm.com/">Git</a>, which uses it to pack data
objects into a <a href="https://git-scm.com/book/en/v2/Git-Internals-Packfiles">PACK file</a>. At the request of <a href="https://github.com/samoht">@samoht</a>,
<code>decompress</code> appeared some years ago as a Mirage-compatible replacement for zlib
to be used for compiling a <a href="https://mirage.io/">MirageOS</a> unikernel with
<a href="https://github.com/mirage/ocaml-git/">ocaml-git</a>. Today, this little project passes a major release with
substantial improvements in several domains.</p>
<p><code>decompress</code> provides an API for inflating and deflating <em>flows</em><code>[1]</code>. The main
goal is to provide a <em>platform-agnostic</em> library: one which may be compiled on
any platform, including JavaScript. We surely cannot be faster than C
implementations like <a href="https://github.com/facebook/zstd">zstd</a> or <a href="https://github.com/lz4/lz4">lz4</a>, but we can play some
optimisation tricks to help bridge the gap. Additionally, OCaml can protect the
user against lot of bugs via the type-system <em>and</em> the runtime too (e.g. using
array bounds checking). <a href="https://github.com/mirleft/ocaml-tls"><code>ocaml-tls</code></a> was implemented partly in
response to the famous <a href="https://en.wikipedia.org/wiki/Heartbleed">failure</a> of <code>openssl</code>; a vulnerability
which could not exist in OCaml.</p>
<p><code>[1]</code>: A <em>flow</em>, in MirageOS land, is an abstraction which wants to receive
and/or transmit something under a standard. So it's usual to say a <em>TLS-flow</em>
for example.</p>
<h2 id="api-design" style="position:relative;"><a href="#api-design" aria-label="api design permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>API design</h2>
<p>The API should be the most difficult part of designing a library - it reveals
what we can do and how we should do it. In this way, an API should:</p>
<ol>
<li><strong>constrain the user to avoid security issues</strong>; too much freedom can be a bad
thing. As an example, consider the <code>Hashtbl.create</code> function, which allows the
user to pass <code>~random:false</code> to select a fixed hash function. The resulting
hashtable suffers deterministic key collisions, which can be exploited by an
attacker.
<br/><br/>
An example of good security-awareness in API design can be seen in
<a href="https://github.com/mirage/digestif">digestif</a>, which provided an <code>unsafe_compare</code> instead of the common
<code>compare</code> function (before <code>eqaf.0.5</code>). In this way, it enforced the user to
create an alias of it if they want to use a hash in a <code>Map</code> – however, by this
action, they should know that they are not protected against a timing-attack.</li>
<li><strong>allow some degrees of freedom to fit within many environments</strong>; a
constrained API cannot support a hostile context. For example, when compiling
to an <a href="https://mirage.io/blog/2018-esp32-booting">ESP32</a> target, even small details such as the length of a stream
input buffer must be user-definable. When deploying to a server, memory
consumption should be deterministic.
<br/><br/>
Of course, this is made difficult when too much freedom will enable misuse of
the API – an example is <a href="https://github.com/ocaml/dune">dune</a> which wants consciously to limit the user
about what they can do with it.</li>
<li><strong>imply an optimal design of how to use it</strong>. Possibilities should serve the
user, but these can make the API harder to understand; this is why
documentation is important. Your API should tell your users how it wants to
be treated.</li>
</ol>
<h3 id="a-dbuenzli-api" style="position:relative;"><a href="#a-dbuenzli-api" aria-label="a dbuenzli api permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>A dbuenzli API</h3>
<p>From our experiences with protocol/format, one design stands out: the
<em><a href="https://github.com/dbuenzli/">dbuenzli</a> API</em>. If you look into some famous libraries in the OCaml
eco-system, you probably know <a href="https://github.com/dbuenzli/uutf">uutf</a>, <a href="https://github.com/dbuenzli/jsonm">jsonm</a> or <a href="https://github.com/dbuenzli/xmlm">xmlm</a>. All
of these libraries provide the same API for computing a Unicode/JSON/XML flow –
of course, the details are not the same.</p>
<p>From a MirageOS perspective, even if they use the <code>in_channel</code>/<code>out_channel</code>
abstraction rather than a <a href="https://github.com/mirage/mirage-flow">Mirage flow</a>, these libraries
are system-agnostic since they let the user to choose input and output buffers.
Most importantly, they don't use the standard OCaml <code>Unix</code> module, which cannot
be used in a unikernel.</p>
<p>The APIs are pretty consistent and try to do their <em>best-effort</em><code>[2]</code> of
decoding. The design has a type <em>state</em> which represents the current system
status; the user passes this to <code>decode</code>/<code>encode</code> to carry out the processing.
Of course, these functions have a side-effect on the state internally, but
this is hidden from the user. One advantage of including states in a design is
that the underlying implementation is very amenable to compiler optimisations (e.g.
tail-call optimisation). Internally, of course, we have a <em>porcelain</em><code>[3]</code>
implementation where any details can have an rational explanation.</p>
<p>In the beginning, <code>decompress</code> wanted to follow the same interface without the
mutability (a choice about performances) and it did. Then, the hard test was to
use it in a bigger project; in this case, <a href="https://github.com/mirage/ocaml-git/">ocaml-git</a>. An iterative
process was used to determine what was really needed, what we should not provide
(like special cases) and what we should provide to reach an uniform API that is
not too difficult to understand.</p>
<p>From this experience, we finalised the initial <code>decompress</code> API and it did not
change significantly for 4 versions (2 years).</p>
<p><code>[2]</code>: <em>best-effort</em> means an user control on the error branch where we don't
leak exception (or more generally, any interrupts)</p>
<p><code>[3]</code>: <em>porcelain</em> means implicit invariants held in the mind of the programmer
(or the assertions/comments).</p>
<h2 id="the-new-decompress-api" style="position:relative;"><a href="#the-new-decompress-api" aria-label="the new decompress api permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>The new <code>decompress</code> API</h2>
<p>The new <code>decompress</code> keeps the same inflation logic, but drastically changes the
deflator to make the <em>flush</em> operation clearer. For many purposes, people don't
want to hand-craft their compressed flows – they just want
<code>of_string</code>/<code>to_string</code> functions. However, in some contexts (like a PNG
encoder/decoder), the user should be able to play with <code>decompress</code> in detail
(OpenPGP needs this too in <a href="https://tools.ietf.org/html/rfc4880">RFC 4880</a>).</p>
<h3 id="the-zlib-format" style="position:relative;"><a href="#the-zlib-format" aria-label="the zlib format permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>The Zlib format</h3>
<p>Both <code>decompress</code> and zlib use <em><a href="https://zlib.net/feldspar.html">Huffman coding</a></em>, an algorithm
for building a dictionary of variable-length codewords for a given set of
symbols (in this case, bytes). The most common byte is assigned the shortest bit
sequence; less common bytes are assigned longer codewords. Using this
dictionary, we just translate each byte into its codeword and we should achieve
a good compression ratio. Of course, there are other details, such as the fact
that all Huffman codes are <a href="https://en.wikipedia.org/wiki/Prefix_code">prefix-free</a>. The compression can be
taken further with the <a href="https://en.wikipedia.org/wiki/LZ77_and_LZ78">LZ77</a> algorithm.</p>
<p>The <em><a href="https://zlib.net/">zlib</a></em> format, a superset of the <a href="https://tools.ietf.org/html/rfc1951">RFC 1951</a> format, is easy
to understand. We will only consider the RFC 1951 format, since zlib adds only
minor details (such as checksums). It consists of several blocks: DEFLATE
blocks, each with a little header, and the contents. There are 3 kinds of
DEFLATE blocks:</p>
<ul>
<li>a FLAT block; no compression, just a <em>blit</em> from inputs to the current block.</li>
<li>a FIXED block; compressed using a pre-computed Huffman code.</li>
<li>a DYNAMIC block; compressed using a user-specified Huffman code.</li>
</ul>
<p>The FIXED block uses a Huffman dictionary that is computed when the OCaml runtime
is initialised. DYNAMIC blocks use dictionaries specified by the user, and so
these must be transmitted alongside the data (<em>after being compressed with
another Huffman code!</em>). The inflator decompresses this DYNAMIC dictionary and uses
it to do the <em>reverse</em> translation from bit sequences to bytes.</p>
<h3 id="inflator" style="position:relative;"><a href="#inflator" aria-label="inflator permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Inflator</h3>
<p>The design of the inflator did not change a lot from the last version of
<code>decompress</code>. Indeed, it's about to take an input, compute it and return an
output like a flow. Of course, the error case can be reached.</p>
<p>So the API is pretty-easy:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">val</span> decode <span class="token punctuation">:</span> decoder <span class="token operator">-></span> <span class="token punctuation">[</span> <span class="token variant variable">`Await</span> <span class="token operator">|</span> <span class="token variant variable">`Flush</span> <span class="token operator">|</span> <span class="token variant variable">`End</span> <span class="token operator">|</span> <span class="token variant variable">`Malformed</span> <span class="token keyword">of</span> string <span class="token punctuation">]</span></code></pre></div>
<p>As you can see, we have 4 cases: one which expects more inputs (<code>Await</code>), the
second which asks to the user to flush internal buffer (<code>Flush</code>), the <code>End</code> case
when we reach the end of the flow and the <code>Malformed</code> case when we encounter an
error.</p>
<p>For each case, the user can do several operations. Of course, about the <code>Await</code>
case, they can refill the contents with an other inputs buffer with:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">val</span> src <span class="token punctuation">:</span> decoder <span class="token operator">-></span> bigstring <span class="token operator">-></span> off<span class="token punctuation">:</span>int <span class="token operator">-></span> len<span class="token punctuation">:</span>int <span class="token operator">-></span> unit</code></pre></div>
<p>This function provides the decoder a new input with <code>len</code> bytes to read
starting at <code>off</code> in the given <code>bigstring</code>.</p>
<p>In the <code>Flush</code> case, the user wants some information like how many bytes are
available in the current output buffer. Then, we should provide an action to
<em>flush</em> this output buffer. In the end, this output buffer should be given by
the user (how many bytes they want to allocate to store outputs flow).</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">type</span> src <span class="token operator">=</span> <span class="token punctuation">[</span> <span class="token variant variable">`Channel</span> <span class="token keyword">of</span> in_channel <span class="token operator">|</span> <span class="token variant variable">`Manual</span> <span class="token operator">|</span> <span class="token variant variable">`String</span> <span class="token keyword">of</span> string <span class="token punctuation">]</span>

<span class="token keyword">val</span> dst_rem <span class="token punctuation">:</span> decoder <span class="token operator">-></span> int
<span class="token keyword">val</span> flush <span class="token punctuation">:</span> decoder <span class="token operator">-></span> unit
<span class="token keyword">val</span> decoder <span class="token punctuation">:</span> src <span class="token operator">-></span> o<span class="token punctuation">:</span>bigstring <span class="token operator">-></span> w<span class="token punctuation">:</span>bigstring <span class="token operator">-></span> decoder</code></pre></div>
<p>The last function, <code>decoder</code>, is the most interesting. It lets the user, at the
beginning, choose the context in which they want to inflate inputs. So they
choose:</p>
<ul>
<li><code>src</code>, where come from inputs flow</li>
<li><code>o</code>, output buffer</li>
<li><code>w</code>, window buffer</li>
</ul>
<p><code>o</code> will be used to store inflated outputs, <code>dst_rem</code> will give to us how many
bytes inflator stored in <code>o</code> and <code>flush</code> will just set <code>decoder</code> to be able to
recompute the flow.</p>
<p><code>w</code> is needed for <a href="https://en.wikipedia.org/wiki/LZ77_and_LZ78">lz77</a> compression. However, as we said, we let
the user give us this intermediate buffer. The idea behind that is to let the
user prepare an <em>inflation</em>. For example, in <a href="https://github.com/mirage/ocaml-git/">ocaml-git</a>, instead of
allocating <code>w</code> systematically when we want to decompress a Git object, we
allocate <code>w</code> one time per threads and all are able to use it and <strong>re-use</strong> it.
In this way, we avoid systematic allocations (and allocate only once time) which
can have a serious impact about performances.</p>
<p>The design is pretty close to one idea, a <em>description</em> step by the <code>decoder</code>
function and a real computation loop with the <code>decode</code> function. The idea is to
prepare the inflation with some information (like <code>w</code> and <code>o</code>) before the main
(and the most expensive) computation. Internally we do that too (but it's mostly
about a macro-optimization).</p>
<p>It's the purpose of OCaml in general, be able to have a powerful way to describe
something (with constraints). In our case, we are very limited to what we need
to describe. But, in others libraries like <a href="https://github.com/inhabitedtype/angstrom">angstrom</a>, the description
step is huge (describe the parser according to the BNF) and then, we use it to
the main computation, in the case of angstrom, the parsing (another
example is [cmdliner][cmdliner]).</p>
<p>This is why <code>decoder</code> can be considered as the main function where <code>decode</code> can
be wrapped under a stream.</p>
<h3 id="deflator" style="position:relative;"><a href="#deflator" aria-label="deflator permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Deflator</h3>
<p>The deflator is a new (complex) deal. Indeed, behind it we have two concepts:</p>
<ul>
<li>the encoder (according to RFC 1951)</li>
<li>the compressor</li>
</ul>
<p>For this new version of <code>decompress</code>, we decide to separate these concepts where
one question leads all: how to put my compression algorithm? (instead to use
<a href="https://en.wikipedia.org/wiki/LZ77_and_LZ78">LZ77</a>).</p>
<p>In fact, if you are interested in compression, several algorithms exist and, in
some context, it's preferable to use <a href="https://en.wikipedia.org/wiki/Lempel%E2%80%93Ziv%E2%80%93Markov_chain_algorithm">lzwa</a> for example or rabin's
fingerprint (with <a href="https://github.com/mirage/duff">duff</a>), etc.</p>
<h4 id="functor" style="position:relative;"><a href="#functor" aria-label="functor permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Functor</h4>
<p>The first idea was to provide a <em>functor</em> which expects an implementation of the
compression algorithm. However, the indirection of a functor comes with (big)
performance cost. Consider the following functor example:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">module</span> <span class="token keyword">type</span> S <span class="token operator">=</span> <span class="token keyword">sig</span>
  <span class="token keyword">type</span> t
  <span class="token keyword">val</span> add <span class="token punctuation">:</span> t <span class="token operator">-></span> t <span class="token operator">-></span> t
  <span class="token keyword">val</span> one <span class="token punctuation">:</span> t
<span class="token keyword">end</span>

<span class="token keyword">module</span> <span class="token module variable">Make</span> <span class="token punctuation">(</span>S <span class="token punctuation">:</span> S<span class="token punctuation">)</span> <span class="token operator">=</span> <span class="token keyword">struct</span> <span class="token keyword">let</span> succ x <span class="token operator">=</span> S<span class="token punctuation">.</span>add x S<span class="token punctuation">.</span>one <span class="token keyword">end</span>

<span class="token keyword">include</span> <span class="token module variable">Make</span> <span class="token punctuation">(</span><span class="token keyword">struct</span>
  <span class="token keyword">type</span> t <span class="token operator">=</span> int
  <span class="token keyword">let</span> add a b <span class="token operator">=</span> a <span class="token operator">+</span> b
  <span class="token keyword">let</span> one <span class="token operator">=</span> <span class="token number">1</span>
<span class="token keyword">end</span><span class="token punctuation">)</span>

<span class="token keyword">let</span> f x <span class="token operator">=</span> succ x</code></pre></div>
<p>Currently, with OCaml 4.07.1, the <code>f</code> function will be a <code>caml_apply2</code>. We might
wish for a simple <a href="https://en.wikipedia.org/wiki/Inline_expansion"><em>inlining</em></a> optimisation, allowing <code>f</code> to become an
<code>addq</code> instruction (indeed, <a href="https://caml.inria.fr/pub/docs/manual-ocaml/flambda.html"><code>flambda</code></a> does this), but optimizing
functors is hard. As we learned from <a href="https://github.com/chambart">Pierre Chambart</a>, it is possible
for the OCaml compiler to optimize functors directly, but this requires
respecting several constraints that are difficult to respect in practice.</p>
<h4 id="split-encoder-and-compressor" style="position:relative;"><a href="#split-encoder-and-compressor" aria-label="split encoder and compressor permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Split encoder and compressor</h4>
<p>So, the choice was done to made the encoder which respects RFC 1951 and the
compressor under some constraints. However, this is not what <a href="https://zlib.net/">zlib</a> did
and, by this way, we decided to provide a new design/API which did not follow,
in first instance, zlib (or some others implementations like
<a href="https://github.com/richgel999/miniz">miniz</a>).</p>
<p>To be fair, the choice from zlib and miniz comes from the first
point about API and the context where they are used. The main problem is the
shared queue between the encoder and the compressor. In C code, it can be hard
for the user to deal with it (where they are liable for buffer overflows).</p>
<p>In OCaml and for <code>decompress</code>, the shared queue can be well-abstracted and API
can ensure assumptions (like bounds checking).</p>
<p>Even if this design is much more complex than before, coverage tests are better
where we can separately test the encoder and the compressor. It breaks down the
initial black-box where compression was intrinsec with encoding – which was
error-prone. Indeed, <code>decompress</code> had a bug about generation of
Huffman codes but we never reached it because the (bad)
compressor was not able to produce something (a specific lengh with a specific
distance) to get it.</p>
<p>NOTE: you have just read the main reason for the new version of <code>decompress</code>!</p>
<h4 id="the-compressor" style="position:relative;"><a href="#the-compressor" aria-label="the compressor permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>The compressor</h4>
<p>The compressor is the most easy part. The goal is to produce from an inputs
flow, an outputs flow which is an other (more compacted) representation. This
representation consists to:</p>
<ul>
<li>A <em>literal</em>, the byte as is</li>
<li>A <em>copy</em> code with an <em>offset</em> and a <em>length</em></li>
</ul>
<p>The last one say to copy <em>length</em> byte(s) from <em>offset</em>. For example, <code>aaaa</code> can
be compressed as <code>[ Literal 'a'; Copy (offset:1, len:3) ]</code>. By this way, instead
to have 4 bytes, we have only 2 elements which will be compressed then by an
<a href="https://zlib.net/feldspar.html">Huffman coding</a>. This is the main idea of the <a href="https://en.wikipedia.org/wiki/LZ77_and_LZ78">lz77</a>
compression.</p>
<p>However, the compressor should need to deal with the encoder. An easy interface,
<em>à la <a href="https://github.com/dbuenzli/uutf">uutf</a></em> should be:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">val</span> compress <span class="token punctuation">:</span> state <span class="token operator">-></span> <span class="token punctuation">[</span> <span class="token variant variable">`Literal</span> <span class="token keyword">of</span> char <span class="token operator">|</span> <span class="token variant variable">`Copy</span> <span class="token keyword">of</span> <span class="token punctuation">(</span>int <span class="token operator">*</span> int<span class="token punctuation">)</span> <span class="token operator">|</span> <span class="token variant variable">`End</span> <span class="token operator">|</span> <span class="token variant variable">`Await</span> <span class="token punctuation">]</span></code></pre></div>
<p>But as I said, we need to feed a queue instead.</p>
<hr>
<p>At this point, the purpose of the queue is not clear and not really explained.
The signature above still is a valid and understandable design. Then, we can
imagine passing <code>Literal</code> and <code>Copy</code> directly to the encoder. However, we should
(for performance purpose) use a delaying tactic between the compressor and the
deflator<sup id="fnref-4"><a href="#fn-4" class="footnote-ref">4</a></sup>.</p>
<p>Behind this idea, it's to be able to implement an <em>hot-loop</em> on the encoder
which will iter inside the shared queue and <em>transmit</em>/<em>encode</em> contents
directly to the outputs buffer.</p>
<hr>
<p>So, when we make a new <code>state</code>, we let the user supply their queue:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">val state : src -&gt; w:bistring -&gt; q:queue -&gt; state
val compress : state -&gt; [ `Flush | `Await | `End ]</code></pre></div>
<p>The <code>Flush</code> case appears when the queue is full. Then, we refind the <code>w</code> window
buffer which is needed to produce the <code>Copy</code> code. A <em>copy code</em> is limited
according RFC 1951 where <em>offset</em> can not be upper than the length of the window
(commonly 32ko). <em>length</em> is limited too to <code>258</code> (an arbitrary choice).</p>
<p>Of course, about the <code>Await</code> case, the compressor comes with a <code>src</code> function as
the inflator. Then, we added some accessors, <code>literals</code> and <code>distances</code>. The
compressor does not build the <a href="https://zlib.net/feldspar.html">Huffman coding</a> which needs
frequencies, so we need firstly to keep counters about that inside the state and
a way to get them (and pass them to the encoder).</p>
<p><code>[4]</code>: About that, you should be interesting by the reason of <a href="https://www.reddit.com/r/unix/comments/6gxduc/how_is_gnu_yes_so_fast/">why GNU yes is so
fast</a> where the secret is just about buffering.</p>
<h4 id="the-encoder" style="position:relative;"><a href="#the-encoder" aria-label="the encoder permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>The encoder</h4>
<p>Finally, we can talk about the encoder which will take the shared queue filled
by the compressor and provide an RFC 1951 compliant output flow.</p>
<p>However, we need to consider a special <em>detail</em>. When we want to make a
DYNAMIC block from frequencies and then encode the inputs flow, we can reach a
case where the shared queue contains an <em>opcode</em> (a <em>literal</em> or a <em>copy</em>) which
does not appear in our dictionary.</p>
<p>In fact, if we want to encode <code>[ Literal 'a'; Literal 'b' ]</code>, we will not try to
make a dictionary which will contains the 256 possibilities of a byte but we
will only make a dictionary from frequencies which contains only <code>'a'</code> and
<code>'b'</code>. By this way, we can reach a case where the queue contains an <em>opcode</em>
(like <code>Literal 'c'</code>) which can not be encoded by the <em>pre-determined</em>
Huffman coding – remember, the DYNAMIC block <strong>starts</strong> with
the dictionary.</p>
<p>Another point is about inputs. The encoder expects, of course, contents from
the shared queue but it wants from the user the way to encode contents: which
block we want to emit. So it has two entries:</p>
<ul>
<li>the shared queue</li>
<li>an <em>user-entry</em></li>
</ul>
<p>So for many real tests, we decided to provide this kind of API:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">type</span> dst <span class="token operator">=</span> <span class="token punctuation">[</span> <span class="token variant variable">`Channel</span> <span class="token keyword">of</span> out_channel <span class="token operator">|</span> <span class="token variant variable">`Buffer</span> <span class="token keyword">of</span> <span class="token module variable">Buffer</span><span class="token punctuation">.</span>t <span class="token operator">|</span> <span class="token variant variable">`Manual</span> <span class="token punctuation">]</span>

<span class="token keyword">val</span> encoder <span class="token punctuation">:</span> dst <span class="token operator">-></span> q<span class="token punctuation">:</span>queue <span class="token operator">-></span> encoder
<span class="token keyword">val</span> encode <span class="token punctuation">:</span> encoder <span class="token operator">-></span> <span class="token punctuation">[</span> <span class="token variant variable">`Block</span> <span class="token keyword">of</span> block <span class="token operator">|</span> <span class="token variant variable">`Flush</span> <span class="token operator">|</span> <span class="token variant variable">`Await</span> <span class="token punctuation">]</span> <span class="token operator">-></span> <span class="token punctuation">[</span> <span class="token variant variable">`Ok</span> <span class="token operator">|</span> <span class="token variant variable">`Partial</span> <span class="token operator">|</span> <span class="token variant variable">`Block</span> <span class="token punctuation">]</span>
<span class="token keyword">val</span> dst <span class="token punctuation">:</span> encoder <span class="token operator">-></span> bigstring <span class="token operator">-></span> off<span class="token punctuation">:</span>int <span class="token operator">-></span> len<span class="token punctuation">:</span>int <span class="token operator">-></span> unit</code></pre></div>
<p>As expected, we take the shared queue to make a new encoder. Then, we let the
user to specify which kind of block they want to encode by the <code>Block</code>
operation.</p>
<p>The <code>Flush</code> operation tries to encode all elements present inside the shared
queue according to the current block and feed the outputs buffer. From it, the
encoder can returns some values:</p>
<ul>
<li><code>Ok</code> and the encoder encoded all <em>opcode</em> from the shared queue</li>
<li><code>Partial</code>, the outputs buffer is not enough to encode all <em>opcode</em>, the user
should flush it and give to us a new empty buffer with <code>dst</code>. Then, they must
continue with the <code>Await</code> operation.</li>
<li><code>Block</code>, the encoder reachs an <em>opcode</em> which can not be encoded with the
current block (the current dictionary). Then, the user must continue with a new
<code>Block</code> operation.</li>
</ul>
<p>The hard part is about the <em>ping-pong</em> game between the user and the encoder
where a <code>Block</code> expects a <code>Block</code> response from the user and a <code>Partial</code> expects
an <code>Await</code> response. But this design reveals something higher about zlib
this time: the <em>flush</em> mode.</p>
<h4 id="the-flush-mode" style="position:relative;"><a href="#the-flush-mode" aria-label="the flush mode permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>The <em>flush</em> mode</h4>
<p>Firstly, we talk about <em>mode</em> because zlib does not allow the user to
decide what they want to do when we reach a <code>Block</code> or a <code>Ok</code> case. So, it
defines some <a href="https://www.bolet.org/~pornin/deflate-flush.html">under-specified <em>modes</em></a> to apply a policy of what
to do in this case.</p>
<p>In <code>decompress</code>, we followed the same design and see that it may be not a good
idea where the logic is not very clear and the user wants may be an another
behavior. It was like a <em>black-box</em> with a <em>black-magic</em>.</p>
<p>Because we decided to split encoder and compressor, the idea of the <em>flush mode</em>
does not exists anymore where the user explicitly needs to give to the encoder
what they want (make a new block? which block? keep frequencies?). So we broke
the <em>black-box</em>. But, as we said, it was possible mostly because we can abstract
safely the shared queue between the compressor and the encoder.</p>
<p>OCaml is an expressive language and we can really talk about a queue where, in
C, it will be just an other <em>array</em>. As we said, the deal is about performance,
but now, we allow the user the possibility to write their code in this corner-case
which is when they reachs <code>Block</code>. Behaviors depends only on them.</p>
<h2 id="apis-in-general" style="position:relative;"><a href="#apis-in-general" aria-label="apis in general permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>APIs in general</h2>
<p>The biggest challenge of building a library is defining the API - you must
strike a compromise between allowing the user the flexibility to express their
use-case and constraining the user to avoid API misuse. If at all possible,
provide an <em>intuitive</em> API: force the user not to need to think about security
issues, memory consumption or performance.</p>
<p>Avoid making your API so expressive that it becomes unusable, but beware that
this sets hard limits on your users: the current <code>decompress</code> API can be used to
build <code>of_string</code> / <code>to_string</code> functions, but the opposite is not true - you
definitely cannot build a stream API from <code>of_string</code> / <code>to_string</code>.</p>
<p>The best advice when designing a library is to keep in mind what you <strong>really</strong>
want and let the other details fall into place gradually. It is very important
to work in an iterative loop of repeatedly trying to use your library; only this
can highlight bad design, corner-cases and details.</p>
<p>Finally, use and re-use it on your tests (important!) and inside higher-level
projects to give you interesting questions about your design. The last version
of <code>decompress</code> was not used in <a href="https://github.com/mirage/ocaml-git/">ocaml-git</a> mostly because the flush
mode was unclear.</p>|js}
  };
 
  { title = {js|Dune 1.2.0|js}
  ; slug = {js|dune-120|js}
  ; description = Some {js|After a tiny but important patch release as 1.1.1, the dune team is thrilled to
announce the release of dune 1.2.0! Here are some highlights…|js}
  ; url = {js|https://tarides.com/blog/2018-09-06-dune-1-2-0|js}
  ; date = {js|2018-09-06T00:00:00-00:00|js}
  ; preview_image = Some {js|https://tarides.com/static/98e7b693b372846010bfcd8d54746146/2244e/sand_dune1.jpg|js}
  ; body_html = {js|<p>After a tiny but important patch release as 1.1.1, the dune team is thrilled to
announce the release of dune 1.2.0! Here are some highlights of the new
features in that version. The full list of changes can be found <a href="https://github.com/ocaml/dune/blob/e3af33b43a87d7fa2d15f7b41d8bd942302742ec/CHANGES.md#120-14092018">in the dune
repository</a>.</p>
<h1 id="watch-mode" style="position:relative;"><a href="#watch-mode" aria-label="watch mode permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Watch mode</h1>
<p>When developing, it is common to edit a file, run a build, read the error
message, and fix the error. Since this is a very tight loop and developers are
doing this hundreds or thousands times a day, it is crucial to have the
quickest feedback possible.</p>
<p><code>dune build</code> and <code>dune runtest</code> now accept <a href="https://dune.readthedocs.io/en/latest/usage.html#watch-mode">a <code>-w</code>
flag</a> that will
watch the filesystem for changes, and trigger a new build.</p>
<h1 id="better-error-messages" style="position:relative;"><a href="#better-error-messages" aria-label="better error messages permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Better error messages</h1>
<p>Inspired by the great work done in
<a href="http://elm-lang.org/blog/compiler-errors-for-humans">Elm</a> and
<a href="https://reasonml.github.io/blog/2017/08/25/way-nicer-error-messages.html">bucklescript</a>,
dune now displays the relevant file in error messages.</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text"> % cat dune
(executable
 (name my_program)
 (librarys cmdliner)
)
 % dune build
File &quot;dune&quot;, line 3, characters 2-10:
3 |  (librarys cmdliner)
      ^^^^^^^^
Error: Unknown field librarys
Hint: did you mean libraries?</code></pre></div>
<p>Many messages have also been improved, in particular to help users <a href="https://dune.readthedocs.io/en/latest/migration.html#check-list">switching
from the <code>jbuild</code> format to the <code>dune</code>
format</a>.</p>
<h1 id="dune-unstable-fmt" style="position:relative;"><a href="#dune-unstable-fmt" aria-label="dune unstable fmt permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>dune unstable-fmt</h1>
<p>Are you confused about how to format S-expressions? You are not alone.
That is why we are gradually introducing a formatter for <code>dune</code> files. It can
transform a valid but ugly <code>dune</code> into one that is consistently formatted.</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text"> % cat dune
(executable( name ls) (libraries cmdliner)
(preprocess (pps ppx_deriving.std)))
 % dune unstable-fmt dune
(executable
 (name ls)
 (libraries cmdliner)
 (preprocess
  (pps ppx_deriving.std)
 )
)</code></pre></div>
<p>This feature is not ready yet for the end user (hence the <code>unstable</code> part),
and in particular the concrete syntax is not stable yet.
But having it already in the code base will make it possible to build useful
integrations with <code>dune</code> itself (to automatically reformat all dune files in a
project, for example) and common editors, so that they format <code>dune</code> files on
save.</p>
<h1 id="first-class-support-of-findlib-plugins" style="position:relative;"><a href="#first-class-support-of-findlib-plugins" aria-label="first class support of findlib plugins permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>First class support of findlib plugins</h1>
<p>It is now easy to support findlib plugins by just adding the <code>findlib.dynload</code>
library dependency. Then you can use <code>Fl_dynload</code> module in your code which
will automatically do the right thing. <a href="https://dune.readthedocs.io/en/latest/advanced-topics.html#dynamic-loading-of-packages">A complete example can be found in the
dune manual</a>.</p>
<h1 id="promote-only-certain-files" style="position:relative;"><a href="#promote-only-certain-files" aria-label="promote only certain files permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Promote only certain files</h1>
<p>The <code>dune promote</code> command now accept a list of files. This is useful to
promote just the file that is opened in a text editor for example. Some emacs
bindings are provided to do this, which works particularly well with
<a href="https://dune.readthedocs.io/en/latest/tests.html#inline-expectation-tests">inline expectation tests</a>.</p>
<h1 id="deprecation-message-for-wrapped-modes" style="position:relative;"><a href="#deprecation-message-for-wrapped-modes" aria-label="deprecation message for wrapped modes permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Deprecation message for (wrapped) modes</h1>
<p>By default, libraries are <code>(wrapped true)</code>, which means that they expose a
single OCaml module (source files are exposed as submodules of this main
module). This is usually desired as it makes link-time name collisions less
likely. However, a lot of libraries are using <code>(wrapped false)</code> (expose all
source files as modules) to keep compatibility.</p>
<p>It can be challenging to transition from <code>(wrapped false)</code> to <code>(wrapped true)</code>
because it breaks compatibility. That is why we have added <code>(wrapped (transition "message"))</code> which will generate wrapped modules but keep unwrapped
modules with a deprecation message to help coordinate the change.</p>
<h1 id="credits" style="position:relative;"><a href="#credits" aria-label="credits permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Credits</h1>
<p>Special thanks to our contributors for this release: @aantron, @anuragsoni,
@bobot, @ddickstein, @dra27, @drjdn, @hongchangwu, @khady, @kodek16,
@prometheansacrifice and @ryyppy.</p>|js}
  };
 
  { title = {js|Dune 1.9.0|js}
  ; slug = {js|dune-190|js}
  ; description = Some {js|Tarides is pleased to have contributed to the dune 1.9.0 release which
introduces the concept of library variants. Thanks to this update…|js}
  ; url = {js|https://tarides.com/blog/2019-04-10-dune-1-9-0|js}
  ; date = {js|2019-04-10T00:00:00-00:00|js}
  ; preview_image = Some {js|https://tarides.com/static/a7294df7159db3785da6121fc6ecadf8/2244e/sand_dune2.jpg|js}
  ; body_html = {js|<p>Tarides is pleased to have contributed to the dune 1.9.0 release which
introduces the concept of library variants. Thanks to this update,
unikernels builds are becoming easier and faster in the MirageOS
universe! This also opens the door for a better cross-compilation
story, which will ease the addition of new MirageOS backends
(trustzone, ESP32, RISC-V, etc.)</p>
<p><em>This post has also been posted to the
<a href="https://dune.build/blog/dune-1-9-0/">Dune blog</a>.  See also the <a href="https://discuss.ocaml.org/t/ann-dune-1-9-0/3646">the discuss
forum</a> for more
details.</em></p>
<h1 id="dune-190" style="position:relative;"><a href="#dune-190" aria-label="dune 190 permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Dune 1.9.0</h1>
<p>Changes include:</p>
<ul>
<li>Coloring in the watch mode (<a href="https://github.com/ocaml/dune/pull/1956">#1956</a>)</li>
<li><code>$ dune init</code> command to create or update project boilerplate (<a href="https://github.com/ocaml/dune/pull/1448">#1448</a>)</li>
<li>Allow "." in c_names and cxx_names (<a href="https://github.com/ocaml/dune/pull/2036">#2036</a>)</li>
<li>Experimental Coq support</li>
<li>Support for library variants and default implementations (<a href="https://github.com/ocaml/dune/pull/1900">#1900</a>)</li>
</ul>
<h1 id="variants" style="position:relative;"><a href="#variants" aria-label="variants permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Variants</h1>
<p>In dune 1.7.0, the concept of virtual library was introduced:
<a href="https://dune.build/blog/virtual-libraries/">https://dune.build/blog/virtual-libraries/</a>. This feature allows to
mark some abstract library as virtual, and then have several
implementations for it. These implementations could be for multiple
targets (<code>unix</code>, <code>xen</code>, <code>js</code>), using different algorithms, using C
code or not. However each implementation in a project dependency tree
had to be manually selected. Dune 1.9.0 introduces features for
automatic selection of implementations.</p>
<h2 id="library-variants" style="position:relative;"><a href="#library-variants" aria-label="library variants permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Library variants</h2>
<p>Variants is a tagging mechanism to select implementations on the final
linking step. There's not much to add to make your implementation use
variants. For example, you could decide to design a <code>bar_js</code> library
which is the javascript implementation of <code>bar</code>, a virtual
library. All you need to do is specificy a <code>js</code> tag using the
<code>variant</code> option.</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">(library
 (name bar_js)
 (implements bar)
 (variant js)); &lt;-- variant specification</code></pre></div>
<p>Now any executable that depend on <code>bar</code> can automatically select the
<code>bar_js</code> library variant using the <code>variants</code> option in the dune file.</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">(executable
 (name foo)
 (libraries bar baz)
 (variants js)); &lt;-- variants selection</code></pre></div>
<h2 id="common-variants" style="position:relative;"><a href="#common-variants" aria-label="common variants permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Common variants</h2>
<h3 id="language-selection" style="position:relative;"><a href="#language-selection" aria-label="language selection permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Language selection</h3>
<p>In your projects you might want to trade off speed for portability:</p>
<ul>
<li><code>ocaml</code>: pure OCaml</li>
<li><code>c</code>: OCaml accelerated by C</li>
</ul>
<h3 id="javascript-backend" style="position:relative;"><a href="#javascript-backend" aria-label="javascript backend permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>JavaScript backend</h3>
<ul>
<li><code>js</code>: code aiming for a Node backend, using <code>Js_of_ocaml</code></li>
</ul>
<h2 id="mirage-backends" style="position:relative;"><a href="#mirage-backends" aria-label="mirage backends permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Mirage backends</h2>
<p>The Mirage project (<a href="https://mirage.io/">mirage.io</a>) will make
extensive use of this feature in order to select the appropriate
dependencies according to the selected backend.</p>
<ul>
<li><code>unix</code>: Unikernels as Unix applications, running on top of <code>mirage-unix</code></li>
<li><code>xen</code>: Xen backend, on top of <code>mirage-xen</code></li>
<li><code>freestanding</code>: Freestanding backend, on top of <code>mirage-solo5</code></li>
</ul>
<h2 id="default-implementation" style="position:relative;"><a href="#default-implementation" aria-label="default implementation permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Default implementation</h2>
<p>To facilitate the transition from normal libraries into virtuals ones,
it's possible to specify an implementation that is selected by
default. This default implementation is selected if no implementation
is chosen after variant resolution.</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">(library
 (name bar)
 (virtual_modules hello)
 (default_implementation bar_unix)); &lt;-- default implementation selection</code></pre></div>
<h2 id="selection-mechanism" style="position:relative;"><a href="#selection-mechanism" aria-label="selection mechanism permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Selection mechanism</h2>
<p>Implementation is done with respect to some priority rules:</p>
<ul>
<li>manual selection of an implementation overrides everything</li>
<li>after that comes selection by variants</li>
<li>finally unimplemented virtual libraries can select their default implementation</li>
</ul>
<p>Libraries may depend on specific implementations but this is not
recommended. In this case, several things can happen:</p>
<ul>
<li>the implementation conflicts with a manually selected implementation: resolution fails.</li>
<li>the implementation overrides variants and default implementations: a cycle check is done and this either resolves or fails.</li>
</ul>
<h2 id="conclusion" style="position:relative;"><a href="#conclusion" aria-label="conclusion permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Conclusion</h2>
<p>Variant libraries and default implementations are fully <a href="https://dune.readthedocs.io/en/latest/variants.html">documented
here</a>. This
feature improves the usability of virtual libraries.</p>
<p>This
<a href="https://github.com/dune-universe/mirage-entropy/commit/576d25d79e3117bba64355ae73597651cfd27631">commit</a>
shows the amount of changes needed to make a virtual library use
variants.</p>
<h1 id="coq-support" style="position:relative;"><a href="#coq-support" aria-label="coq support permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Coq support</h1>
<p>Dune now supports building Coq projects. To enable the experimental Coq
extension, add <code>(using coq 0.1)</code> to your <code>dune-project</code> file. Then,
you can use the <code>(coqlib ...)</code> stanza to declare Coq libraries.</p>
<p>A typical <code>dune</code> file for a Coq project will look like:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">(include_subdirs qualified) ; Use if your development is based on sub directories

(coqlib
  (name Equations)                  ; Name of wrapper module
  (public_name equations.Equations) ; Generate an .install file
  (synopsis &quot;Equations Plugin&quot;)     ; Synopsis
  (libraries equations.plugin)      ; ML dependencies (for plugins)
  (modules :standard \\ IdDec)       ; modules to build
  (flags -w -notation-override))    ; coqc flags</code></pre></div>
<p>See the <a href="https://github.com/ocaml/dune/blob/1.9/doc/coq.rst">documentation of the
extension</a> for more
details.</p>
<h1 id="credits" style="position:relative;"><a href="#credits" aria-label="credits permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Credits</h1>
<p>This release also contains many other changes and bug fixes that can
be found on the <a href="https://discuss.ocaml.org/t/ann-dune-1-9-0/3646">discuss
announce</a>.</p>
<p>Special thanks to dune maintainers and contributors for this release:
<a href="https://github.com/rgrinberg">@rgrinberg</a>,
<a href="https://github.com/emillon">@emillon</a>,
<a href="https://github.com/shonfeder">@shonfeder</a>
and <a href="https://github.com/ejgallego">@ejgallego</a>!</p>|js}
  };
 
  { title = {js|Florence and beyond: the future of Tezos storage|js}
  ; slug = {js|florence-and-beyond-the-future-of-tezos-storage|js}
  ; description = Some {js|In collaboration with Nomadic Labs, Marigold and DaiLambda, we're happy to
announce the completion of the next Tezos protocol proposal…|js}
  ; url = {js|https://tarides.com/blog/2021-03-04-florence-and-beyond-the-future-of-tezos-storage|js}
  ; date = {js|2021-03-04T00:00:00-00:00|js}
  ; preview_image = Some {js|https://tarides.com/static/d81c504dbb5172d29c2aa38512f1dfe3/2244e/florence.jpg|js}
  ; body_html = {js|<p>In collaboration with Nomadic Labs, Marigold and DaiLambda, we're happy to
announce the completion of the next Tezos protocol proposal:
<a href="http://doc.tzalpha.net/protocols/009_florence.html"><strong>Florence</strong></a>.</p>
<p><a href="https://tezos.com/">Tezos</a> is an open-source decentralised blockchain network providing a
platform for smart contracts and digital assets. A crucial feature of Tezos is
<a href="https://tezos.com/static/white_paper-2dc8c02267a8fb86bd67a108199441bf.pdf"><em>self-amendment</em></a>: the network protocol can be upgraded
dynamically by the network participants themselves. This amendment process is
initiated when a participant makes a <em>proposal</em>, which is then subject to a
vote. After several years working on the Tezos storage stack, this is our first
contribution to a proposal; we hope that it will be the first of many!</p>
<p>As detailed in today's <a href="https://blog.nomadic-labs.com/florence-our-next-protocol-upgrade-proposal.html">announcement from Nomadic Labs</a>,
the Florence proposal contains several important changes, from the introduction
of Baking Accounts to major quality-of-life improvements for smart contract
developers. Of all of these changes, we're especially excited about the
introduction of <em>sub-trees</em> to the blockchain context API. In this post, we'll
give a brief tour of what these sub-trees will bring for the future of Tezos.
But first, what <em>are</em> they?</p>
<h3 id="merkle-sub-trees" style="position:relative;"><a href="#merkle-sub-trees" aria-label="merkle sub trees permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Merkle sub-trees</h3>
<p>The Tezos protocol runs on top of a versioned tree called the “context”, which
holds the chain state (balances, contracts etc.). Ever since the pre-Alpha era,
the Tezos context has been implemented using <a href="https://github.com/mirage/irmin">Irmin</a> – an open-source
Merkle tree database originally written for use by MirageOS unikernels.</p>
<p>For MirageOS, Irmin’s key strength is flexibility: it can run over arbitrary
backends. This is a perfect fit for Tezos, which must be agile and
widely-deployable. Indeed, the Tezos shell has already leveraged this agility
many times, all the way from initial prototypes using a Git backend to the
optimised <a href="https://tarides.com/blog/2020-09-01-introducing-irmin-pack"><code>irmin-pack</code></a> implementation used today.</p>
<p>But Irmin can do more than just swapping backends! It also allows users to
manipulate the underlying Merkle tree structure of the store with a high-level
API. This “<a href="https://mirage.github.io/irmin/irmin/Irmin/module-type-S/Tree/">Tree</a>” API enables lots of interesting use-cases of
Irmin, from mergeable data types (<a href="https://kcsrk.info/papers/banyan_aplas20.pdf">MRDTs</a>) to zero-knowledge proofs.
Tezos doesn't use these more powerful features directly yet; that’s where Merkle
proofs come in!</p>
<h3 id="proofs-and-lightweight-tezos-clients" style="position:relative;"><a href="#proofs-and-lightweight-tezos-clients" aria-label="proofs and lightweight tezos clients permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Proofs and lightweight Tezos clients</h3>
<p>Since the Tezos context keeps track of the current "state" of the blockchain,
each participant needs their own copy of the tree to run transactions against.
This context can grow to be very large, so it's important that it be stored as
compactly as possible: this goal shaped the design of <code>irmin-pack</code>, our latest
Irmin backend.</p>
<p>However, it's possible to reduce the storage requirements even further via the
magic of Merkle trees: individuals only need to store a <em>fragment</em> of the root
tree, provided they can demonstrate that this fragment is valid by sending
“<a href="https://bentnib.org/posts/2016-04-12-authenticated-data-structures-as-a-library.html">proofs</a>” of its membership to the other participants.</p>
<p>This property can be used to support ultra-lightweight Tezos clients, a feature
<a href="https://gitlab.com/smelc/tezos/-/commits/tweag-client-light-mode">currently being developed</a> by TweagIO. To make this a reality,
the Tezos protocol needs fine-grained access to context sub-trees in order build
Merkle proofs out of them. Fortunately, Irmin already supports this! We
<a href="https://gitlab.com/tezos/tezos/-/merge_requests/2457">extended the protocol</a> to understand sub-trees, lifting the power
of Merkle trees to the user.</p>
<p>We’re excited to work with TweagIO and Nomadic Labs on lowering the barriers to
entering the Tezos ecosystem and look forward to seeing what they achieve with
sub-trees!</p>
<h3 id="efficient-merkle-proof-representations" style="position:relative;"><a href="#efficient-merkle-proof-representations" aria-label="efficient merkle proof representations permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Efficient Merkle proof representations</h3>
<p>Simply exposing sub-trees in the Tezos context API isn’t quite enough:
lightweight clients will also need to <em>serialize</em> them efficiently, since proofs
must be exchanged over the network to establish trust between collaborating
nodes. Enter <a href="https://dailambda.jp/blog/2020-05-11-plebeia/">Plebeia</a>.</p>
<p>Plebeia is an alternative Tezos storage layer – developed by DaiLambda – with
strengths that complement those of Irmin. In particular, Plebeia is capable of
generating very compact Merkle proofs. This is partly due to its specialized
store structure, and partly due to clever optimizations such as path compression
and inlining.</p>
<p>We’re working with the DaiLambda team to unite the strengths of Irmin and
Plebeia, which will bring built-in Merkle proof support to the Tezos storage
stack. The future is bright for Merkle proofs in Tezos!</p>
<h3 id="baking-account-migrations" style="position:relative;"><a href="#baking-account-migrations" aria-label="baking account migrations permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Baking account migrations</h3>
<p>Trees don’t just enable <em>new</em> features; they have a big impact on performance
too! Currently, indexing into the context always happens from its <em>root</em>, which
duplicates effort when accessing adjacent values deep in the tree. Fortunately,
the new sub-trees provide a natural representation for “cursors” into the
context, allowing the protocol to optimize its interactions with the storage
layer.</p>
<p>To take just one example, DaiLambda recently exploited this feature to reduce
the migration time necessary to introduce Baking Accounts to the network by a
factor of 15! We’ll be teaming up with Nomadic Labs and DaiLambda to ensure that
Tezos extracts every bit of performance from its storage.</p>
<p>It's especially exciting to have access to lightning-fast storage migrations,
since this enables Tezos to evolve rapidly even as the ecosystem expands.</p>
<h3 id="storage-in-other-languages" style="position:relative;"><a href="#storage-in-other-languages" aria-label="storage in other languages permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Storage in other languages</h3>
<p>Of course, Tezos isn’t just an OCaml project: the storage layer also has a
performant Rust implementation as part of <a href="https://github.com/simplestaking/tezedge">TezEdge</a>. We’re working with
<a href="https://github.com/simplestaking">Simple Staking</a> to bring Irmin to the Rust community via an
<a href="https://github.com/simplestaking/ocaml-interop">FFI toolchain</a>, enabling closer alignment between the different
Tezos shell implementations.</p>
<h3 id="conclusion" style="position:relative;"><a href="#conclusion" aria-label="conclusion permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Conclusion</h3>
<p>All in all, it’s an exciting time to work on Tezos storage, with many
open-source collaborators from around the world. We’re especially happy to see
Tezos taking greater advantage of Irmin’s features, which will strengthen both
projects and help them grow together.</p>
<p>If all of this sounds interesting, you can play with it yourself using the
recently-released <a href="https://github.com/mirage/irmin">Irmin 2.5.0</a>. Thanks for reading, and stay tuned for
future Tezos development updates!</p>|js}
  };
 
  { title = {js|Fuzzing OCamlFormat with AFL and Crowbar|js}
  ; slug = {js|fuzzing-ocamlformat-with-afl-and-crowbar|js}
  ; description = Some {js|AFL (and fuzzing in general) is often used
to find bugs in low-level code like parsers, but it also works very well to find
bugs in high…|js}
  ; url = {js|https://tarides.com/blog/2020-08-03-fuzzing-ocamlformat-with-afl-and-crowbar|js}
  ; date = {js|2020-08-03T00:00:00-00:00|js}
  ; preview_image = Some {js|https://tarides.com/static/e6219992a464284115d27348b49c3910/2244e/feather2.jpg|js}
  ; body_html = {js|<p><a href="https://lcamtuf.coredump.cx/afl/">AFL</a> (and fuzzing in general) is often used
to find bugs in low-level code like parsers, but it also works very well to find
bugs in high level code, provided the right ingredients. We applied this
technique to feed random programs to OCamlFormat and found many formatting bugs.</p>
<p>OCamlFormat is a tool to format source code. To do so, it parses the source code
to an Abstract Syntax Tree (AST) and then applies formatting rules to the AST.</p>
<p>It can be tricky to correctly format the output. For example, say we want to
format <code>(a+b)*c</code>. The corresponding AST will look like <code>Apply("*", Apply ("+", Var "a", Var "b"), Var "c")</code>. A naive formatter would look like this:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> <span class="token keyword">rec</span> format <span class="token operator">=</span> <span class="token keyword">function</span>
  <span class="token operator">|</span> <span class="token module variable">Var</span> s <span class="token operator">-></span> s
  <span class="token operator">|</span> <span class="token module variable">Apply</span> <span class="token punctuation">(</span>op<span class="token punctuation">,</span> e1<span class="token punctuation">,</span> e2<span class="token punctuation">)</span> <span class="token operator">-></span>
      <span class="token module variable">Printf</span><span class="token punctuation">.</span>sprintf <span class="token string">"%s %s %s"</span> <span class="token punctuation">(</span>format e1<span class="token punctuation">)</span> op <span class="token punctuation">(</span>format e2<span class="token punctuation">)</span></code></pre></div>
<p>But this is not correct, as it will print <code>(a+b)*c</code> as <code>a+b*c</code>, which is a
different program. In this particular case, the common solution would be to
track the relative precedence of the expressions and to emit only necessary
parentheses.</p>
<p>OCamlFormat has similar cases. To make sure we do not change a program when
formatting it, there is an extra check at the end to parse the output and
compare the output AST with the input AST. This ensures that, in case of bugs,
OCamlFormat exits with an error rather than changing the meaning of the input
program.</p>
<p>When we consider the whole OCaml language, the rules are complex and it is
difficult to make sure that we are correctly handling all programs. There are
two main failure modes: either we put too many parentheses, and the program does
not look good, or we do not put enough, and the AST changes (and OCamlFormat
exits with an error). We need a way to make sure that the latter does not
happen. Tests work to some extent, but some edge cases happen only when a
certain combination of language features is used. Because of this combinatorial
explosion, it is impossible to get good coverage using tests only.</p>
<p>Fortunately there is a technique we can use to automatically explore the program
space: fuzzing. For a primer on using this technique on OCaml programs, one can
refer to <a href="https://tarides.com/blog/2019-09-04-an-introduction-to-fuzzing-ocaml-with-afl-crowbar-and-bun">this article</a>.</p>
<p>To make this work we need two elements: a random program generator, and a
property to check. Here, we are interested in programs that are valid (in the
sense that they parse correctly) but do not format correctly. We can use the
OCamlFormat internals to do the following:</p>
<ol>
<li>try to parse input: in case of a parse error, just reject this input as
invalid.</li>
<li>otherwise, with have a valid program. try to format it. If this happens with
no error at all, reject this input as well.</li>
<li>otherwise, it means that the AST changed, comments moved, or something
similar, in a valid program. This is what we are after.</li>
</ol>
<p>Generating random programs is a bit more difficult. We can feed random strings
to AFL, but even with a corpus of existing valid code it will generate many
invalid programs. We are not interested in these for this project, we would
rather start from valid programs.</p>
<p>A good way to do that is to use Crowbar to directly generate AST values. Thanks
to <a href="https://github.com/yomimono/ppx_deriving_crowbar"><code>ppx_deriving_crowbar</code></a> and <a href="https://github.com/ocaml-ppx/ppx_import"><code>ppx_import</code></a>
it is possible to generate random values for an external type like
<code>Parsetree.structure</code> (the contents of <code>.ml</code> files). Even more fortunately
<a href="https://github.com/yomimono/ocaml-test-omp/blob/d086037027537ba4e23ce027766187979c85aa3d/test/parsetree_405.ml">somebody already did the work</a>. Thanks, Mindy!</p>
<p>This approach works really well: it generates 5k-10k programs per second, which
is very good performance (AFL starts complaining below 100/s).</p>
<p>Quickly, AFL was able to find crashes related to attributes. These are "labels"
attached to various nodes of the AST. For example the expression <code>(x || y) [@a]</code>
(logical or between <code>x</code> and <code>y</code>, attach attribute <code>a</code> to the "or" expression)
would get formatted as <code>x || y [@a]</code> (attribute <code>a</code> is attached to the <code>y</code>
variable). Once again, there is a check in place in OCamlFormat to make sure
that it does not save the file in this case, but it would exit with an error.</p>
<p>After the fuzzer has run for a bit longer, it found crashes where comments would
jump around in expressions like <code>f (*a*) (*bb*) x</code>. Wait, what? We never told
the program generator how to generate comments. Inspecting the intermediate AST,
the part in the middle is actually an integer literal with value <code>"(*a*) (*bb*)"</code> (integer literals are represented as strings so that <a href="https://github.com/Drup/Zarith-ppx">a third party
library could add literals for arbitrary precision numbers</a> for
example).</p>
<p>AFL comes with a program called <code>afl-tmin</code> that is used to minimize a crash. It
will try to find a smaller example of a program that crashes OCamlFormat. It
works well even with Crowbar in between. For example it is able to turn <code>(new aaaaaa &#x26; [0;0;0;0])[@aaaaaaaaaa]</code> into <code>(0&#x26;0)[@a]</code> (neither AFL nor OCamlFormat
knows about types, so they can operate on nonsensical programs. Finding a
well-typed version of a crash is usually not very difficult, but it has to be
done manually).</p>
<p>In total, letting AFL run overnight on a single core (that is relatively short
in terms of fuzzing) caused 453 crashes. After minimization and deduplication,
this corresponded to <a href="https://github.com/ocaml-ppx/ocamlformat/issues?q=label%3Afuzz">about 30 unique issues</a>.</p>
<p>Most of them are related to attributes that OCamlFormat did not try to include
in the output, or where it forgot to add parentheses. Fortunately, there are
safeguards in OCamlFormat: since it checks that the formatting preserves the AST
structure, it will exit with an error instead of outputting a different program.</p>
<p>Once again, fuzzing has proved itself as a powerful technique to find actual
bugs (including high-level ones). A possible approach for a next iteration is to
try to detect more problems during formatting, such as finding cases where lines
are longer than allowed. It is also possible to extend the random program
generator so that it tries to generate comments, and let OCamlFormat check that
they are all laid out correctly in the output. We look forward to employing
fuzzing more extensively for OCamlFormat development in future.</p>|js}
  };
 
  { title = {js|How configurator reads C constants|js}
  ; slug = {js|how-configurator-reads-c-constants|js}
  ; description = None
  ; url = {js|https://dune.build/blog/configurator-constants/|js}
  ; date = {js|2019-01-03T00:00:00-00:00|js}
  ; preview_image = None
  ; body_html = {js|<p>Dune comes with a library to query OS-specific information, called configurator.
It is able to evaluate C expressions and turn them into OCaml value.
Surprisingly, it even works when compiling for a different architecture. How can
it do that?</p>|js}
  };
 
  { title = {js|Introducing irmin-pack|js}
  ; slug = {js|introducing-irmin-pack|js}
  ; description = Some {js|irmin-pack is an Irmin storage backend
that we developed over the last year specifically to meet the
Tezos use-case. Tezos nodes were…|js}
  ; url = {js|https://tarides.com/blog/2020-09-01-introducing-irmin-pack|js}
  ; date = {js|2020-09-01T00:00:00-00:00|js}
  ; preview_image = Some {js|https://tarides.com/static/5dbd4ce5058bf6225c3a8ac98e4dda54/2244e/drawers.jpg|js}
  ; body_html = {js|<p><code>irmin-pack</code> is an Irmin <a href="https://irmin.org/tutorial/backend">storage backend</a>
that we developed over the last year specifically to meet the
<a href="https://tezos.gitlab.io/">Tezos</a> use-case. Tezos nodes were initially using an
LMDB-based backend for their storage, which after only a year of activity led to
<code>250 GB</code> disk space usage, with a monthly growth of <code>25 GB</code>. Our goal was to
dramatically reduce this disk space usage.</p>
<p>Part of the <a href="https://tarides.com/blog/2019-11-21-irmin-v2">Irmin.2.0.0 release</a>
and still under active development, it has been successfully integrated as the
storage layer of Tezos nodes and has been running in production for the last ten
months with great results. It reduces disk usage by a factor of 10, while still
ensuring similar performance and consistency guarantees in a memory-constrained
and concurrent environment.</p>
<p><code>irmin-pack</code> was presented along with Irmin v2 at the OCaml workshop 2020; you
can watch the presentation here:</p>
<div style="position: relative; width: 100%; height: 0; padding-bottom: 56.25%">
  <iframe 
    style="position: absolute; width: 100%; height: 100%; left: 0; right: 0"
    src="https://www.youtube-nocookie.com/embed/v1lfMUM332w" frameborder="0"
    allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
    allowfullscreen>
  </iframe>
</div>
<h2 id="general-structure" style="position:relative;"><a href="#general-structure" aria-label="general structure permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>General structure</h2>
<p><code>irmin-pack</code> exposes functors that allow the user to provide arbitrary low-level
modules for handling I/O, and provides a fast key-value store interface composed
of three components:</p>
<ul>
<li>The <code>pack</code> is used to store the data contained in the Irmin store, as blobs.</li>
<li>The <code>dict</code> stores the paths where these blobs should live.</li>
<li>The <code>index</code> keeps track of the blobs that are present in the repository by
containing location information in the <code>pack</code>.</li>
</ul>
<p>Each of these use both on-disk storage for persistence and concurrence and
various in-memory caches for speed.</p>
<h3 id="storing-the-data-in-the-pack-file" style="position:relative;"><a href="#storing-the-data-in-the-pack-file" aria-label="storing the data in the pack file permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Storing the data in the <code>pack</code> file</h3>
<p>The <code>pack</code> contains most of the data stored in this Irmin backend. It is an
append-only file containing the serialized data stored in the Irmin repository.
All three Irmin stores (see our <a href="https://irmin.org/tutorial/architecture">architecture
page</a> in the tutorial to learn more)
are contained in this single file.</p>
<p><code>Content</code> and <code>Commit</code> serialization is straightforward through
<a href="https://docs.mirage.io/irmin/Irmin/Type/index.html"><code>Irmin.Type</code></a>. They are written along with their length (to allow
correct reading) and hash (to enable integrity checks). The hash is used to
resolve internal links inside the pack when nodes are written.</p>
<p><span
      class="gatsby-resp-image-wrapper"
      style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; "
    >
      <a
    class="gatsby-resp-image-link"
    href="/static/65f80d5690bb49cd0ead891e2e7346c8/f989d/pack.png"
    style="display: block"
    target="_blank"
    rel="noopener"
  >
    <span
    class="gatsby-resp-image-background-image"
    style="padding-bottom: 16.470588235294116%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAADCAYAAACTWi8uAAAACXBIWXMACSfAAAknwAFlKNyIAAAAxElEQVQI1x2O206DQABE+f//MTE8mJhoL1mLSBM1SHEXXGDZbsrN0FaT48rDZOZk5mGCPvugrwx1Z7FTgx0NZjDkpkR3irrXi5pBUziNtKXva7RztGPDPDt+Lz2X+cTPuSOwtzck4T0P6QtPasvmsGKnYsIoIqmfEVKwztbsm5iV39wlAvG5JdxFnh852hijBDrfcB1TgnP6js0kh7bkyz8qTwrlClKtfZYLF17/XdZI3nSGdDmvpVx8mipm//h7qLjOLX+3ito8uSttdAAAAABJRU5ErkJggg=='); background-size: cover; display: block;"
  ></span>
  <img
        class="gatsby-resp-image-image"
        alt="The `pack` file"
        title="The `pack` file"
        src="/static/65f80d5690bb49cd0ead891e2e7346c8/c5bb3/pack.png"
        srcset="/static/65f80d5690bb49cd0ead891e2e7346c8/04472/pack.png 170w,
/static/65f80d5690bb49cd0ead891e2e7346c8/9f933/pack.png 340w,
/static/65f80d5690bb49cd0ead891e2e7346c8/c5bb3/pack.png 680w,
/static/65f80d5690bb49cd0ead891e2e7346c8/b12f7/pack.png 1020w,
/static/65f80d5690bb49cd0ead891e2e7346c8/b5a09/pack.png 1360w,
/static/65f80d5690bb49cd0ead891e2e7346c8/f989d/pack.png 5206w"
        sizes="(max-width: 680px) 100vw, 680px"
        style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;"
        loading="lazy"
      />
  </a>
    </span></p>
<h4 id="optimizing-large-nodes" style="position:relative;"><a href="#optimizing-large-nodes" aria-label="optimizing large nodes permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Optimizing large nodes</h4>
<p>Serializing nodes is not as simple as contents. In fact, nodes might contain an
arbitrarily large number of children, and serializing them as a long list of
references might harm performance, as that means loading and writing a large
amount of data for each modification, no matter how small this modification
might be. Similarly, browsing the tree means reading large blocks of data, even
though only one child is needed.</p>
<p>For this reason, we implemented a <a href="https://en.wikipedia.org/wiki/Radix_tree">Patricia Tree</a> representation of
internal nodes that allows us to split the child list into smaller parts that
can be accessed and modified independently, while still being quickly available
when needed. This reduces duplication of tree data in the Irmin store and
improves disk access times.</p>
<p>Of course, we provide a custom hashing mechanism, so that hashing the nodes
using this partitioning is still backwards-compatible for users who rely on hash
information regardless of whether the node is split or not.</p>
<h4 id="optimizing-internal-references" style="position:relative;"><a href="#optimizing-internal-references" aria-label="optimizing internal references permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Optimizing internal references</h4>
<p>In the Git model, all data are content-addressable (i.e. data are always
referenced by their hash). This naturally lends to indexing data by hashes on
the disk itself (i.e. the links from <code>commits</code> to <code>nodes</code> and from <code>nodes</code> to
<code>nodes</code> or <code>contents</code> are realized by hash).</p>
<p>We did not comply to this approach in <code>irmin-pack</code>, for at least two reasons:</p>
<ul>
<li>Referencing by hash does not allow fast recovery of the children, since
there is no way to find the relevant blob directly in the <code>pack</code> by providing
the hash. We will go into the details of this later in this post.</li>
<li>While hashes are being used as simple objects, their size is not negligible.
The default hashing function in Irmin is BLAKE2B, which provides 64-byte
digests.</li>
</ul>
<p>Instead, our internal links in the <code>pack</code> file are concretized by the offsets –
<code>int64</code> integers – of the children instead of their hash. Provided that the
trees are always written bottom-up (so that children already exist in the <code>pack</code>
when their parents are written), this solves both issues above. The data handled
by the backend is always immutable, and the file is append-only, ensuring that
the links can never be broken.</p>
<p>Of course, that encoding does not break the content-addressable property: one
can always retrieve an arbitrary piece of data through its hash, but it allows
internal links to avoid that indirection.</p>
<h3 id="deduplicating-the-path-names-through-the-dict" style="position:relative;"><a href="#deduplicating-the-path-names-through-the-dict" aria-label="deduplicating the path names through the dict permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Deduplicating the path names through the <code>dict</code></h3>
<p>In fact, the most common operations when using <code>irmin-pack</code> consist of modifying
the tree's leaves rather then its shape. This is similar to the way most of us
use Git: modifying the contents of files is very frequent, while renaming or
adding new files is rather rare. Even still, when writing a <code>node</code> in a new
commit, that node must contain the path names of its children, which end up
being duplicated a large number of times.</p>
<p>The <code>dict</code> is used for deduplication of path names so that the <code>pack</code> file can
uniquely reference them using shorter identifiers. It is composed of an
in-memory bidirectional hash table, allowing to query from path to identifier
when serializing and referencing, and from identifier to path when deserializing
and dereferencing.</p>
<p>To ensure persistence of the data across multiple runs and in case of crashes,
the small size of the <code>dict</code> – less than <code>15 Mb</code> in the Tezos use-case – allows
us to write the bindings to a write-only, append-only file that is fully read
and loaded on start-up.</p>
<p>We guarantee that the <code>dict</code> memory usage is bounded by providing a <code>capacity</code>
parameter. Adding a binding is guarded by this capacity, and will be inlined in
the <code>pack</code> file in case this limit has been reached. This scenario does not
happen during normal use of <code>irmin-pack</code>, but prevents attacks that would make
the memory grow in an unbounded way.</p>
<p><span
      class="gatsby-resp-image-wrapper"
      style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; "
    >
      <a
    class="gatsby-resp-image-link"
    href="/static/cec17f425cdf458a385babbac24c0c04/f7171/dict.png"
    style="display: block"
    target="_blank"
    rel="noopener"
  >
    <span
    class="gatsby-resp-image-background-image"
    style="padding-bottom: 46.470588235294116%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAJCAYAAAAywQxIAAAACXBIWXMACSfAAAknwAFlKNyIAAABxUlEQVQoz22RWXPaMBSF/f//T2danhoIBcJmNhunIbFZDQEbu94Xvl4b+pRq5o6ONNK5n44U0zDIfJ80Doiy8Gul4X/3syymyFOKIqUsslrnWYLitJ5IBwM28y4TW2W+n6BuB8xknu3VWs8PU6b7ca0XD312dFL/ndB943rSib0VeWiibL5/Y9dosOg0aBnPjKwhbaPJL6Nd66b+k+5rF3Wj0tQq3WFoDbi4c1wxX+ktPuTscT2EVAy9Tpt0NGKr9Zja0n03YrIb1lQVTUVZ6Rfzud5fHjXGQnonNAlqQoPE/xDCNUoeRVSVJRElBW54Ikg8irIgziO82OEaXTgHNk74SSz5OcGRWLKlvFHKuaqKPJMMUxQe43a7sdR1HNfDT1z82MULHVIJvyyK+nIuwQfyedfwysnfkeSx7GX13X9DqRbV+lbmnA86T+OlPHEuz+pjXzSId2ShRRqYkKw5Hne0ZjqT/RBNovjj/ZZmYvqAUngYIs8tozWN3oz++5DuW5fP60KCtsTIvFdhcjiY/OiPeVn1GMvnxIEhTtndozKsCbkbxv6apmqg2Roz6X4n3ErYFllg1YS2vRFCDf00R7dnXwj/AnWTnre1NW7QAAAAAElFTkSuQmCC'); background-size: cover; display: block;"
  ></span>
  <img
        class="gatsby-resp-image-image"
        alt="The `dict`"
        title="The `dict`"
        src="/static/cec17f425cdf458a385babbac24c0c04/c5bb3/dict.png"
        srcset="/static/cec17f425cdf458a385babbac24c0c04/04472/dict.png 170w,
/static/cec17f425cdf458a385babbac24c0c04/9f933/dict.png 340w,
/static/cec17f425cdf458a385babbac24c0c04/c5bb3/dict.png 680w,
/static/cec17f425cdf458a385babbac24c0c04/b12f7/dict.png 1020w,
/static/cec17f425cdf458a385babbac24c0c04/b5a09/dict.png 1360w,
/static/cec17f425cdf458a385babbac24c0c04/f7171/dict.png 3456w"
        sizes="(max-width: 680px) 100vw, 680px"
        style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;"
        loading="lazy"
      />
  </a>
    </span></p>
<h3 id="retrieve-the-data-in-the-pack-by-indexing" style="position:relative;"><a href="#retrieve-the-data-in-the-pack-by-indexing" aria-label="retrieve the data in the pack by indexing permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Retrieve the data in the <code>pack</code> by indexing</h3>
<p>Since the <code>pack</code> file is append-only, naively reading its data would require a
linear search through the whole file for each lookup. Instead, we provide an
index that maps hashes of data blocks to their location in the <code>pack</code> file,
along with their length. This module allows quick recovery of the values queried
by hash.</p>
<p>It provides a simple key-value interface, that actually hides the most complex
part of <code>irmin-pack</code>.</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">type</span> t
<span class="token keyword">val</span> v <span class="token punctuation">:</span> readonly<span class="token punctuation">:</span>bool <span class="token operator">-></span> path<span class="token punctuation">:</span>string <span class="token operator">-></span> t

<span class="token keyword">val</span> find    <span class="token punctuation">:</span> t <span class="token operator">-></span> <span class="token module variable">Key</span><span class="token punctuation">.</span>t <span class="token operator">-></span> <span class="token module variable">Value</span><span class="token punctuation">.</span>t
<span class="token keyword">val</span> replace <span class="token punctuation">:</span> t <span class="token operator">-></span> <span class="token module variable">Key</span><span class="token punctuation">.</span>t <span class="token operator">-></span> <span class="token module variable">Value</span><span class="token punctuation">.</span>t <span class="token operator">-></span> unit
<span class="token comment">(* ... *)</span></code></pre></div>
<p>It has lead most of our efforts in the development of <code>irmin-pack</code> and is now
available as a separate library, wisely named <code>index,</code> that you can checkout on
GitHub under <a href="https://github.com/mirage/index/">mirage/index</a> and via <code>opam</code> as
the <code>index</code> and <code>index-unix</code> packages.</p>
<p>When <code>index</code> is used inside <code>irmin-pack</code>, the keys are the hashes of the data
stored in the backend, and the values are the <code>(offset, length)</code> pair that
indicates the location in the <code>pack</code> file. From now on in this post, we will
stick to the <code>index</code> abstraction: <code>key</code> and <code>value</code> will refer to the keys and
values as viewed by the <code>index</code>.</p>
<p>Our index is split into two major parts. The <code>log</code> is relatively small, and most
importantly, bounded; it contains the recently-added bindings. The <code>data</code> is
much larger, and contains older bindings.</p>
<p>The <code>log</code> part consists of a hash table associating keys to values. In order to
ensure concurrent access, and to be able to recover on a crash, we also maintain
a write-only, append-only file with the same contents, such that both always
contain exactly the same data at any time.</p>
<p>When a new key-value binding is added index, the value is simply serialized
along with its key and added to the <code>log</code>.</p>
<p>An obvious caveat of this approach is that the in-memory representation of the
<code>log</code> (the hashtable) is unbounded. It also grows a lot, as the Tezos node
stores more that 400 million objects. Our memory constraint obviously does not
allow such unbounded structures. This is where the <code>data</code> part comes in.</p>
<p>When the <code>log</code> size reaches a – customizable – threshold, its bindings are
flushed into a <code>data</code> component, that may already contain flushed data from
former <code>log</code> overloads. We call this operation a <em>merge</em>.</p>
<p><span
      class="gatsby-resp-image-wrapper"
      style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; "
    >
      <a
    class="gatsby-resp-image-link"
    href="/static/7663e5dd55a9fa612393be5ae1952bf5/e9c53/merges.png"
    style="display: block"
    target="_blank"
    rel="noopener"
  >
    <span
    class="gatsby-resp-image-background-image"
    style="padding-bottom: 28.82352941176471%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAGCAYAAADDl76dAAAACXBIWXMAAC4jAAAuIwF4pT92AAABNUlEQVQY032PW1OCUBRG+f9/yrIMLwVdHDSVPAcU5CKXlCQMV3toemv6ZtasOfthn28b3sxh4c5YbV3CPCTIArIioiwSilxc5vymbS+0Xy3/xQiuezwvTUwtuAMGgh/aRJ5FqCfE4Yr3Y8XlAnkSMl1b6L2Ll7nilfite//OjEgpvECzTQOSMiEuYvZ5TJruSGRBlqfSrKWqTqjYxfJNHjxTPOReD7j37n6s77q54WgbS42Zbixe4ynz3QuzSBBPw0c2hQZpV5YHFsEM863HWN10TGTR02aC7Y+wvRGP/hjDlp/G+oaR6gvidb9jom4Zrq9YRg5Nc+5OrpoDQenhZwqVuBQfGe2l5fzVUH+ehBpjnS5ZJfMON3kVfrzYOTjbJ4Lcp64bDscj+yynOp74rM9d67/yDeIQult6YeS1AAAAAElFTkSuQmCC'); background-size: cover; display: block;"
  ></span>
  <img
        class="gatsby-resp-image-image"
        alt="Merging the index"
        title="Merging the index"
        src="/static/7663e5dd55a9fa612393be5ae1952bf5/c5bb3/merges.png"
        srcset="/static/7663e5dd55a9fa612393be5ae1952bf5/04472/merges.png 170w,
/static/7663e5dd55a9fa612393be5ae1952bf5/9f933/merges.png 340w,
/static/7663e5dd55a9fa612393be5ae1952bf5/c5bb3/merges.png 680w,
/static/7663e5dd55a9fa612393be5ae1952bf5/b12f7/merges.png 1020w,
/static/7663e5dd55a9fa612393be5ae1952bf5/b5a09/merges.png 1360w,
/static/7663e5dd55a9fa612393be5ae1952bf5/e9c53/merges.png 7470w"
        sizes="(max-width: 680px) 100vw, 680px"
        style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;"
        loading="lazy"
      />
  </a>
    </span></p>
<p>The important invariant maintained by the <code>merge</code> operation is that the <code>data</code>
file must remain sorted by the hash of the bindings. This will enable a fast
recovery of the data.</p>
<p>During this operation, both the <code>log</code> and the former <code>data</code> are read in sorted
order – <code>data</code> is already sorted, and <code>log</code> is small thus easy to sort in
memory – and merged into a <code>merging_data</code> file. This file is atomically renamed
at the end of the operation to replace the older <code>data</code> while still ensuring
correct concurrent accesses.</p>
<p>This operation obviously needs to re-write the whole index, so its execution
is very expensive. For this reason, it is performed by a separate thread in the
background to still allow regular use of the index and be transparent to the
user.</p>
<p>In the meantime, a <code>log_async</code> – similar to <code>log</code>, with a file and a hash table
– is used to hold new bindings and ensure the data being merged and the new data
are correctly separated. At the end of the merge, the <code>log_async</code> becomes the
new <code>log</code> and is cleared to be ready for the next merge.</p>
<h4 id="recovering-the-data" style="position:relative;"><a href="#recovering-the-data" aria-label="recovering the data permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Recovering the data</h4>
<p>This design allows us a fast lookup of the data present in the index. Whenever
<code>find</code> or <code>mem</code> is called, we first look into the <code>log</code>, which is simply a call
to the corresponding <code>Hashtbl</code> function, since this data is contained in memory.
If the data is not found in the <code>log</code>, the <code>data</code> file will be browsed. This
means access to recent values is generally faster, because it does not require
any access to the disk.</p>
<p>Searching in the <code>data</code> file is made efficient by the invariant that we kept
during the <code>merge</code>: the file is sorted by hash. The search algorithm consists in
an interpolation search, which is permitted by the even distribution of the
hashes that we store. The theoretical complexity of the interpolation search is
<code>O(log (log n))</code>, which is generally better than a binary search, provided that
the computation of the interpolant is cheaper than reads, which is the case
here.</p>
<p>This approach allows us to find the data using approximately 5-6 reading steps
in the file, which is good, but still a source of slowdowns. For this reason, we
use a fan-out module on top of the interpolation search, able to tell us the
exact page in which a given key is located, in constant time, for an additional
space cost of <code>~100 Mb</code>. We use this to find the correct page of the disk, then
run the interpolation search in that page only. That approach allows us to find
the correct value with a single read in the <code>data</code> file.</p>
<h2 id="conclusion" style="position:relative;"><a href="#conclusion" aria-label="conclusion permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Conclusion</h2>
<p>This new backend is now used byt the Tezos nodes in production, and manages to
reduce the storage size from <code>250 Gb</code> down to <code>25 Gb</code>, with a monthly growth
rate of <code>2 Gb</code> , achieving a tenfold reduction.</p>
<p>In the meantime, it provides and single writer, multiple readers access pattern
that enables bakers and clients to connect to the same storage while it is operated.</p>
<p>On the memory side, all our components are memory bounded, and the bound is
generally customizable, the largest source of memory usage being the <code>log</code> part
of the <code>index</code>. While it can be reduced to fit in <code>1 Gb</code> of memory and run on
small VPS or Raspberry Pi, one can easily set a higher memory limit on a more
powerful machine, and achieve even better time performance.</p>|js}
  };
 
  { title = {js|Introducing the GraphQL API for Irmin 2.0|js}
  ; slug = {js|introducing-the-graphql-api-for-irmin-20|js}
  ; description = Some {js|With the release of Irmin 2.0.0, we are happy to announce a new package - irmin-graphql, which can be used to serve data from Irmin over…|js}
  ; url = {js|https://tarides.com/blog/2019-11-27-introducing-the-graphql-api-for-irmin-2-0|js}
  ; date = {js|2019-11-27T00:00:00-00:00|js}
  ; preview_image = Some {js|https://tarides.com/static/774a33033c774c2c0c5b638f61694621/497c6/irmin-graphql.png|js}
  ; body_html = {js|<p>With the release of Irmin 2.0.0, we are happy to announce a new package - <code>irmin-graphql</code>, which can be used to serve data from Irmin over HTTP. This blog post will give you some examples to help you get started, there is also <a href="https://irmin.org/tutorial/graphql">a section in the <code>irmin-tutorial</code></a> with similar information. To avoid writing the same thing twice, this post will cover the basics of getting started, plus a few interesting ideas for queries.</p>
<p>Getting the <code>irmin-graphql</code> server running from the command-line is easy:</p>
<div class="gatsby-highlight" data-language="shell"><pre class="language-shell"><code class="language-shell">$ irmin graphql --root<span class="token operator">=</span>/tmp/irmin</code></pre></div>
<p>where <code>/tmp/irmin</code> is the actual path to your repository. This will start the server on <code>localhost:8080</code>, but it's possible to customize this using the <code>--address</code> and <code>--port</code> flags.</p>
<p>The new GraphQL API has been added to address some of the shortcomings that have been identified with the old HTTP API, as well as enable a number of new features and capabilities.</p>
<h1 id="graphql" style="position:relative;"><a href="#graphql" aria-label="graphql permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>GraphQL</h1>
<p><a href="https://graphql.org/">GraphQL</a> is a query language for exposing data as a graph via an API, typically using HTTP as a transport. The centerpiece of a GraphQL API is the <em>schema</em>, which describes the graph in terms of types and relationships between these types. The schema is accessible by the consumer, and acts as a contract between the API and the consumer, by clearly defining all API operations and fully assigning types to all interactions.</p>
<p>Viewing Irmin data as a graph turns out to be a natural and useful model. Concepts such as branches and commits fit in nicely, and the stored application data is organized as a tree. Such highly hierarchical data can be challenging to interact with using REST, but is easy to represent and navigate with GraphQL.</p>
<p><span
      class="gatsby-resp-image-wrapper"
      style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; "
    >
      <span
    class="gatsby-resp-image-background-image"
    style="padding-bottom: 74.11764705882352%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAPCAYAAADkmO9VAAAACXBIWXMAAAsTAAALEwEAmpwYAAADTElEQVQ4y5WSaWxMURTHz7TWqtbSqlRQPhAaRYmIICIiIXzkG4nlE59ok0pJ0Yits5XZLaFIELHWniCp0lCtmmn7Zp/hdWbem7d1ZlSn6cx17lCxfelN/jnn3nvu7953/g/grzFVZ4YCnVVVqLdCoc5SUqCz7MrXmLfnakzbMN+Na0sLcI+qSGeB/450Og0+jwt8bgbeOOywoeH6iBF1Rpiitx5BkZKz58lswwVCc7zoKdSqofLRs6za5ndACIFUKvUv0OPqBhfTCazXnSlad+EK5KqN1RO0ZjILYQssl8hEzPPVxoe77jRman7XH8OgPQ5eFwNuBNo/fhhjZ5iiwKtnRftu3lq78vL1ihUXr1Ust106sOrKzcptt+5t7vnQUtzDRwslRcmmMDtqnvYsFGhsAJIUUslyODsSDo50dXeBGOVW2zvaHO9a3jSJXORlUuAfsF2Oxm98pDEpRp8goIHjuBser+d1LyHTKXDn7QcjJ+mt2dhjFSCMQiGRECCZ7IWtm9ZPsBlM47Ewhx0ko6GVwI7qmrzaulMzSAnAgbccfVUOatSA/tBksN6FaRoDTKZGUZMQuBSBulg8eiIW47U+b+cNRYnUCEJwjCj2bMRcjVETCnltSi93UpJ69tBXjdOYj83Umdqnas3PJ+os99GsRwgspa87jYcIy3qIx+0ggsASvIQgpBzjE9wnwYCT+H3ddI3ElIisbmqagYfF4jPnyGJbAylFwxBIiutt2ymwigLCYT8e6iJR/vMQcA7GqzRnv7hJwI9AhCty2Fvf3JQLx+sbRtcZXXkaU0eO2tiuOnnGDkfVy+gn5yF00bd+pYyQgbJ4PLoQYaUDAzEVrhehygcHE7iXLMPaxbzAluAnj21jmMOP3783PG1tNb6wO/QtTqeJ4yKrfpnytU+EVPorYB8z874+KROp+tGswVQiUyvKHAiKnBcKBvYHmO4q56eOY6zHXaXwfI0kimuGDmXJciiLxiH9vEj1+14myrwqrvhVcjwyvz8VX9LW1rwlzAdWKAmuXFK+5MNwhiSFhy6aS3tLDQyFfITjgmk6pwYPG4gC2mP6ZyCIOJkO4kfD6ByBxmECf/QUXzMO416EVGGvK+MJoRLnB6lp3wHVMaPbwiwNvgAAAABJRU5ErkJggg=='); background-size: cover; display: block;"
  ></span>
  <img
        class="gatsby-resp-image-image"
        alt="Git data model"
        title="Git data model"
        src="/static/77be7ca8c9940e693b03660d2d5cee01/c5bb3/git-data-model.png"
        srcset="/static/77be7ca8c9940e693b03660d2d5cee01/04472/git-data-model.png 170w,
/static/77be7ca8c9940e693b03660d2d5cee01/9f933/git-data-model.png 340w,
/static/77be7ca8c9940e693b03660d2d5cee01/c5bb3/git-data-model.png 680w,
/static/77be7ca8c9940e693b03660d2d5cee01/5a190/git-data-model.png 800w"
        sizes="(max-width: 680px) 100vw, 680px"
        style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;"
        loading="lazy"
      />
    </span>
(image from <a href="https://git-scm.com/book/en/v2/Git-Internals-Git-Objects">Pro Git</a>)</p>
<p>As a consumer of an API, one of the biggest initial challenges is understanding what operations are exposed and how to use them. Conversely, as a developer of an API, keeping documentation up-to-date is challenging and time consuming. Though no substitute for more free-form documentation, a GraphQL schema provides an excellent base line for understanding a GraphQL API that is guaranteed to be accurate and up-to-date. This issue is definitely true of the old Irmin HTTP API, which was hard to approach for newcomers due to lack of documentation.</p>
<p>Being able to inspect the schema of a GraphQL API enables powerful tooling. A great example of this is <a href="graphiql">GraphiQL</a>, which is a browser-based IDE for GraphQL queries. GraphiQL can serve both as an interactive API explorer and query designer with intelligent autocompletion, formatting and more.</p>
<p><span
      class="gatsby-resp-image-wrapper"
      style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; "
    >
      <a
    class="gatsby-resp-image-link"
    href="/static/19632cbb13504bb32d6d6d285ec1f542/82e86/graphiql.png"
    style="display: block"
    target="_blank"
    rel="noopener"
  >
    <span
    class="gatsby-resp-image-background-image"
    style="padding-bottom: 48.23529411764706%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAKCAYAAAC0VX7mAAAACXBIWXMAABYlAAAWJQFJUiTwAAABe0lEQVQoz3WS6W6DMBCEef9XbP5ECkcAY3xiG5Pprk3SFqkrjbjszzO7NLfbDW3bouu6j4ZhgBCiaGbN8x/xe208rI94HQeUUkhpR4wRzSIVnN/Kw1spJVjnIEYBtSoYawlQxfdyXSEWiWkW8Fvdm3MualazYRAGwOtUrRADASW+7iOk0thChA+hXLU2WJalOI10+O9qGGJcgCHbOSrse12w0cl8ei80Hk8B5zwcxfSURhtDUI09HbT9hbwHcsfxMwNBkEzAFTk5/n46jBTbF/C4KOiV4g4SVpoS8bl6PNoRXt6RNokUFAETmoOayj3L+06wg1SJIVQg6ymojwS0o/oAJxUwjwN2NxYjOfmyv2EYQ991BfLAikMCmW6BVZb6GBDJQAwUN23UKo7P6SgyT4Yhv1WBoQJJEwGNYocrAV0ZznvdtRr8UzH+OJylrpFpQPzst1BSMfNqppmmCX3fl9/Ae3bkytXQJHkzayCHaiaXDwGrT4dnm65OvwHODwhMLGNqDQAAAABJRU5ErkJggg=='); background-size: cover; display: block;"
  ></span>
  <img
        class="gatsby-resp-image-image"
        alt="GraphiQL"
        title="GraphiQL"
        src="/static/19632cbb13504bb32d6d6d285ec1f542/c5bb3/graphiql.png"
        srcset="/static/19632cbb13504bb32d6d6d285ec1f542/04472/graphiql.png 170w,
/static/19632cbb13504bb32d6d6d285ec1f542/9f933/graphiql.png 340w,
/static/19632cbb13504bb32d6d6d285ec1f542/c5bb3/graphiql.png 680w,
/static/19632cbb13504bb32d6d6d285ec1f542/b12f7/graphiql.png 1020w,
/static/19632cbb13504bb32d6d6d285ec1f542/b5a09/graphiql.png 1360w,
/static/19632cbb13504bb32d6d6d285ec1f542/82e86/graphiql.png 1978w"
        sizes="(max-width: 680px) 100vw, 680px"
        style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;"
        loading="lazy"
      />
  </a>
    </span></p>
<p>The combination of introspection and a strongly typed schema also allows creating smart clients using code generation. This is already a quite wide-spread idea with <a href="apollo-swift">Apollo for iOS</a>, <a href="apollo-java">Apollo for Android</a> or <a href="graphql_ppx"><code>graphql_ppx</code></a> for OCaml/Reason. Though generic GraphQL client libraries will do a fine job interacting with the Irmin GraphQL API, these highlighted libraries will offer excellent ergonomics and type-safety out of the box.</p>
<p>One of the problems that GraphQL set out to solve is that of over- and underfetching. When designing REST API response payloads, there is always a tension between including too little data, which will require clients to make more network requests, and including too much data, which wastes resources for both client and server (serialization, network transfer, deserialization, etc).<br/>
The existing low-level Irmin HTTP API is a perfect example of this. Fetching the contents of a particular file on the master branch requires at least 4 HTTP requests (fetch the branch, fetch the commit, fetch the tree, fetch the blob), i.e. massive underfetching. By comparison, this is something easily solved with a single request to the new GraphQL API. More generally, the GraphQL API allows you to fetch <em>exactly</em> the data you need in a single request without making one-off endpoints.</p>
<p>For the curious, here's the GraphQL query to fetch the contents of <code>README.md</code> from the branch <code>master</code>:</p>
<div class="gatsby-highlight" data-language="graphql"><pre class="language-graphql"><code class="language-graphql"><span class="token keyword">query</span> <span class="token punctuation">{</span>
  master <span class="token punctuation">{</span>
    tree <span class="token punctuation">{</span>
      get<span class="token punctuation">(</span><span class="token attr-name">key</span><span class="token punctuation">:</span> <span class="token string">"README.md"</span><span class="token punctuation">)</span>
    <span class="token punctuation">}</span>
  <span class="token punctuation">}</span>
<span class="token punctuation">}</span></code></pre></div>
<p>The response will look something like this:</p>
<div class="gatsby-highlight" data-language="json"><pre class="language-json"><code class="language-json"><span class="token punctuation">{</span>
  <span class="token property">"data"</span><span class="token operator">:</span> <span class="token punctuation">{</span>
    <span class="token property">"master"</span><span class="token operator">:</span> <span class="token punctuation">{</span>
      <span class="token property">"tree"</span><span class="token operator">:</span> <span class="token punctuation">{</span>
        <span class="token property">"get"</span><span class="token operator">:</span> <span class="token string">"The contents of README.md"</span>
      <span class="token punctuation">}</span>
    <span class="token punctuation">}</span>
  <span class="token punctuation">}</span>
<span class="token punctuation">}</span></code></pre></div>
<p>The GraphQL API is not limited to only reading data, you can also write data to your Irmin store. Here's a simple example that will set the key <code>README.md</code> to <code>"foo"</code>, and return the hash of that commit:</p>
<div class="gatsby-highlight" data-language="graphql"><pre class="language-graphql"><code class="language-graphql"><span class="token keyword">mutation</span> <span class="token punctuation">{</span>
  set<span class="token punctuation">(</span><span class="token attr-name">key</span><span class="token punctuation">:</span> <span class="token string">"README.md"</span><span class="token punctuation">,</span> <span class="token attr-name">value</span><span class="token punctuation">:</span> <span class="token string">"foo"</span><span class="token punctuation">)</span> <span class="token punctuation">{</span>
    hash
  <span class="token punctuation">}</span>
<span class="token punctuation">}</span></code></pre></div>
<p>By default, GraphQL allows you to do multiple operations in a single query, so you get bulk operations for free. Here's a more complex example that modifies two different branches, <code>branch-a</code> and <code>branch-b</code>, and then merges <code>branch-b</code> into <code>branch-a</code> <em>all in a single query</em>:</p>
<div class="gatsby-highlight" data-language="graphql"><pre class="language-graphql"><code class="language-graphql"><span class="token keyword">mutation</span> <span class="token punctuation">{</span>
  <span class="token attr-name">branch_a</span><span class="token punctuation">:</span> set<span class="token punctuation">(</span><span class="token attr-name">branch</span><span class="token punctuation">:</span> <span class="token string">"branch-a"</span><span class="token punctuation">,</span> <span class="token attr-name">key</span><span class="token punctuation">:</span> <span class="token string">"foo"</span><span class="token punctuation">,</span> <span class="token attr-name">value</span><span class="token punctuation">:</span> <span class="token string">"bar"</span><span class="token punctuation">)</span> <span class="token punctuation">{</span>
    hash
  <span class="token punctuation">}</span>

  <span class="token attr-name">branch_b</span><span class="token punctuation">:</span> set<span class="token punctuation">(</span><span class="token attr-name">branch</span><span class="token punctuation">:</span> <span class="token string">"branch-a"</span><span class="token punctuation">,</span> <span class="token attr-name">key</span><span class="token punctuation">:</span> <span class="token string">"baz"</span><span class="token punctuation">,</span> <span class="token attr-name">value</span><span class="token punctuation">:</span> <span class="token string">"qux"</span><span class="token punctuation">)</span> <span class="token punctuation">{</span>
    hash
  <span class="token punctuation">}</span>

  merge_with_branch<span class="token punctuation">(</span><span class="token attr-name">branch</span><span class="token punctuation">:</span> <span class="token string">"branch-b"</span><span class="token punctuation">,</span> <span class="token attr-name">from</span><span class="token punctuation">:</span> <span class="token string">"branch-a"</span><span class="token punctuation">)</span> <span class="token punctuation">{</span>
    hash
    tree <span class="token punctuation">{</span>
      list_contents_recursively <span class="token punctuation">{</span>
        key
        value
      <span class="token punctuation">}</span>
    <span class="token punctuation">}</span>
  <span class="token punctuation">}</span>
<span class="token punctuation">}</span></code></pre></div>
<p>Here's what the response might look like:</p>
<div class="gatsby-highlight" data-language="json"><pre class="language-json"><code class="language-json"><span class="token punctuation">{</span>
  <span class="token property">"data"</span><span class="token operator">:</span> <span class="token punctuation">{</span>
    <span class="token property">"branch_a"</span><span class="token operator">:</span> <span class="token punctuation">{</span>
      <span class="token property">"hash"</span><span class="token operator">:</span> <span class="token string">"0a1313ae9dfe1d4339aee946dd76b383e02949b6"</span>
    <span class="token punctuation">}</span><span class="token punctuation">,</span>
    <span class="token property">"branch_b"</span><span class="token operator">:</span> <span class="token punctuation">{</span>
      <span class="token property">"hash"</span><span class="token operator">:</span> <span class="token string">"28855c277671ccc180c81058a28d3254f17d2f7b"</span>
    <span class="token punctuation">}</span><span class="token punctuation">,</span>
    <span class="token property">"merge_with_branch"</span><span class="token operator">:</span> <span class="token punctuation">{</span>
      <span class="token property">"hash"</span><span class="token operator">:</span> <span class="token string">"7b17437a16a858816d2710a94ccaa1b9c3506d1f"</span><span class="token punctuation">,</span>
      <span class="token property">"tree"</span><span class="token operator">:</span> <span class="token punctuation">{</span>
        <span class="token property">"list_contents_recursively"</span><span class="token operator">:</span> <span class="token punctuation">[</span>
          <span class="token punctuation">{</span>
            <span class="token property">"key"</span><span class="token operator">:</span> <span class="token string">"/foo"</span><span class="token punctuation">,</span>
            <span class="token property">"value"</span><span class="token operator">:</span> <span class="token string">"bar"</span>
          <span class="token punctuation">}</span><span class="token punctuation">,</span>
          <span class="token punctuation">{</span>
            <span class="token property">"key"</span><span class="token operator">:</span> <span class="token string">"/baz"</span><span class="token punctuation">,</span>
            <span class="token property">"value"</span><span class="token operator">:</span> <span class="token string">"qux"</span>
          <span class="token punctuation">}</span>
        <span class="token punctuation">]</span>
      <span class="token punctuation">}</span>
    <span class="token punctuation">}</span>
  <span class="token punctuation">}</span>
<span class="token punctuation">}</span></code></pre></div>
<p>Overall, the new GraphQL API operates at a much higher level than the old HTTP API, and offers a number of complex operations that were tricky to accomplish before.</p>
<h1 id="customizable" style="position:relative;"><a href="#customizable" aria-label="customizable permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Customizable</h1>
<p>With GraphQL, all request and response data is fully described by the schema. Because Irmin allows the user to have custom content types, this leaves the question of what type to assign to such values. By default, the GraphQL API will expose all values as strings, i.e. the serialized version of the data that your application stores. This works quite well when Irmin is used as a simple key-value store, but it can be very inconvenient scheme when storing more complex values. As an example, consider storing contacts (name, email, phone, tags, etc) in your Irmin store, where values have the following type:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token comment">(* Custom content type: a contact *)</span>
<span class="token keyword">type</span> contact <span class="token operator">=</span> <span class="token punctuation">{</span>
  name <span class="token punctuation">:</span> string<span class="token punctuation">;</span>
  email <span class="token punctuation">:</span> string<span class="token punctuation">;</span>
  <span class="token comment">(* ... *)</span>
<span class="token punctuation">}</span></code></pre></div>
<p>Fetching such a value will by default be returned to the client as the JSON encoded representation. Assume we're storing a contact under the key <code>john-doe</code>, which we fetch with the following query:</p>
<div class="gatsby-highlight" data-language="graphql"><pre class="language-graphql"><code class="language-graphql"><span class="token keyword">query</span> <span class="token punctuation">{</span>
  master <span class="token punctuation">{</span>
    tree <span class="token punctuation">{</span>
      get<span class="token punctuation">(</span><span class="token attr-name">key</span><span class="token punctuation">:</span> <span class="token string">"john-doe"</span><span class="token punctuation">)</span>
    <span class="token punctuation">}</span>
  <span class="token punctuation">}</span>
<span class="token punctuation">}</span></code></pre></div>
<p>The response would then look something like this:</p>
<div class="gatsby-highlight" data-language="json"><pre class="language-json"><code class="language-json"><span class="token punctuation">{</span>
  <span class="token property">"master"</span><span class="token operator">:</span> <span class="token punctuation">{</span>
    <span class="token property">"tree"</span><span class="token operator">:</span> <span class="token punctuation">{</span>
      <span class="token property">"get"</span><span class="token operator">:</span> <span class="token string">"{\\"name\\":\\"John Doe\\", \\"email\\": \\"john.doe@gmail.com/"</span><span class="token punctuation">,</span> ...<span class="token punctuation">}</span>"
    <span class="token punctuation">}</span>
  <span class="token punctuation">}</span>
<span class="token punctuation">}</span></code></pre></div>
<p>The client will have to parse this JSON string and cannot choose to only fetch parts of the value (say, only the email). Optimally we would want the client to get a structured response such as the following:</p>
<div class="gatsby-highlight" data-language="json"><pre class="language-json"><code class="language-json"><span class="token punctuation">{</span>
  <span class="token property">"master"</span><span class="token operator">:</span> <span class="token punctuation">{</span>
    <span class="token property">"tree"</span><span class="token operator">:</span> <span class="token punctuation">{</span>
      <span class="token property">"get"</span><span class="token operator">:</span> <span class="token punctuation">{</span>
        <span class="token property">"name"</span><span class="token operator">:</span> <span class="token string">"John Doe"</span><span class="token punctuation">,</span>
        <span class="token property">"email"</span><span class="token operator">:</span> <span class="token string">"john.doe@gmail.com"</span><span class="token punctuation">,</span>
        ...
      <span class="token punctuation">}</span>
    <span class="token punctuation">}</span>
  <span class="token punctuation">}</span>
<span class="token punctuation">}</span></code></pre></div>
<p>To achieve this, the new GraphQL API allows providing an "output type" and an "input type" for most of the configurable types in your store (<code>contents</code>, <code>key</code>, <code>metadata</code>, <code>hash</code>, <code>branch</code>). The output type specifies how data is presented to the client, while the input type controls how data can be provided by the client. Let's take a closer look at specifying a custom output type.</p>
<p>Essentially you have to construct a value of type <code>(unit, 'a option) Graphql_lwt.Schema.typ</code> (from the <a href="ocaml-graphql-server"><code>graphql-lwt</code></a> package), assuming your content type is <code>'a</code>. We could construct a GraphQL object type for our example content type <code>contact</code> as follows:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token comment">(* (unit, contact option) Graphql_lwt.Schema.typ *)</span>
<span class="token keyword">let</span> contact_schema_typ <span class="token operator">=</span> <span class="token module variable">Graphql_lwt</span><span class="token punctuation">.</span><span class="token module variable">Schema</span><span class="token punctuation">.</span><span class="token punctuation">(</span>obj <span class="token string">"Contact"</span>
  <span class="token label function">~fields</span><span class="token punctuation">:</span><span class="token punctuation">(</span><span class="token keyword">fun</span> <span class="token punctuation">_</span> <span class="token operator">-></span> <span class="token punctuation">[</span>
    field <span class="token string">"name"</span>
      <span class="token label function">~typ</span><span class="token punctuation">:</span><span class="token punctuation">(</span>non_null string<span class="token punctuation">)</span>
      <span class="token label function">~args</span><span class="token punctuation">:</span><span class="token punctuation">[</span><span class="token punctuation">]</span>
      <span class="token label function">~resolve</span><span class="token punctuation">:</span><span class="token punctuation">(</span><span class="token keyword">fun</span> <span class="token punctuation">_</span> contact <span class="token operator">-></span>
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
  master <span class="token punctuation">{</span>
    tree <span class="token punctuation">{</span>
      get<span class="token punctuation">(</span><span class="token attr-name">key</span><span class="token punctuation">:</span> <span class="token string">"john-doe"</span><span class="token punctuation">)</span> <span class="token punctuation">{</span>
        email
      <span class="token punctuation">}</span>
    <span class="token punctuation">}</span>
  <span class="token punctuation">}</span>
<span class="token punctuation">}</span></code></pre></div>
<p>... and get a nicely structured JSON response back:</p>
<div class="gatsby-highlight" data-language="json"><pre class="language-json"><code class="language-json"><span class="token punctuation">{</span>
  <span class="token property">"master"</span><span class="token operator">:</span> <span class="token punctuation">{</span>
    <span class="token property">"tree"</span><span class="token operator">:</span> <span class="token punctuation">{</span>
      <span class="token property">"get"</span><span class="token operator">:</span> <span class="token punctuation">{</span>
        <span class="token property">"email"</span><span class="token operator">:</span> <span class="token string">"john.doe@gmail.com"</span>
      <span class="token punctuation">}</span>
    <span class="token punctuation">}</span>
  <span class="token punctuation">}</span>
<span class="token punctuation">}</span></code></pre></div>
<p>The custom types is very powerful and opens up for transforming or enriching the data at query time, e.g. geocoding the address of a contact, or checking an on-line status.</p>
<h1 id="watches" style="position:relative;"><a href="#watches" aria-label="watches permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Watches</h1>
<p>A core feature of Irmin is the ability to <em>watch</em> for changes to the underlying data store in real-time. <code>irmin-graphql</code> takes advantage of GraphQL subscriptions to expose Irmin watches. Subscriptions are a relative recent addition to the GraphQL spec (<a href="graphql-spec-june-2018">June 2018</a>), which allows clients to <em>subscribe</em> to changes. These changes are pushed to the client over a suitable transport mechanism, e.g. websockets, Server-Sent Events, or a chunked HTTP response, as a regular GraphQL response.</p>
<p>As an example, the following query watches for all changes and returns the new hash:</p>
<div class="gatsby-highlight" data-language="graphql"><pre class="language-graphql"><code class="language-graphql"><span class="token keyword">subscription</span> <span class="token punctuation">{</span>
  watch <span class="token punctuation">{</span>
    commit <span class="token punctuation">{</span>
      hash
    <span class="token punctuation">}</span>
  <span class="token punctuation">}</span>
<span class="token punctuation">}</span></code></pre></div>
<p>For every change, a message like the following will be sent:</p>
<div class="gatsby-highlight" data-language="json"><pre class="language-json"><code class="language-json"><span class="token punctuation">{</span>
  <span class="token property">"watch"</span><span class="token operator">:</span> <span class="token punctuation">{</span>
    <span class="token property">"commit"</span><span class="token operator">:</span> <span class="token punctuation">{</span>
      <span class="token property">"hash"</span><span class="token operator">:</span> <span class="token string">"c01a59bacc16d89e9cdd344a969f494bb2698d8f"</span>
    <span class="token punctuation">}</span>
  <span class="token punctuation">}</span>
<span class="token punctuation">}</span></code></pre></div>
<p>Under the hood, subscriptions in <code>irmin-graphql</code> are implemented using Irmin watches, but this is opaque to the client -- this will work with any GraphQL spec compliant client!</p>
<p>Here's a video, which hows how the GraphQL response changes live as the Irmin store is being manipulated:</p>
<p><video controls width=680><source src="/blog/2019-11-27-introducing-irmin-graphql/irmin-subscriptions.mp4" type=video/mp4></video></p>
<p>Note that the current implementation only supports websockets with more transport options coming soon.</p>
<h1 id="wrap-up" style="position:relative;"><a href="#wrap-up" aria-label="wrap up permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Wrap-up</h1>
<p>Irmin 2.0 ships with a powerful new GraphQL API, that makes it much easier to interact with Irmin over the network. This makes Irmin available for many more languages and contexts, not just applications using OCaml (or Javascript). The new API operates at a much high level than the old API, and offers advanced features such as "bring your own GraphQL types", and watching for changes via GraphQL subscriptions.</p>
<p>We're looking forward to seeing what you'll build with it!</p>|js}
  };
 
  { title = {js|Irmin: September 2020 update|js}
  ; slug = {js|irmin-september-2020-update|js}
  ; description = Some {js|This post will survey the latest design decisions and performance improvements
made to irmin-pack, the Irmin storage backend used by
Tezos…|js}
  ; url = {js|https://tarides.com/blog/2020-09-08-irmin-september-2020-update|js}
  ; date = {js|2020-09-08T00:00:00-00:00|js}
  ; preview_image = Some {js|https://tarides.com/static/eb48bbf490e4011a9fa8806a56d4098b/2244e/tree_autumn.jpg|js}
  ; body_html = {js|<p>This post will survey the latest design decisions and performance improvements
made to <code>irmin-pack</code>, the <a href="https://irmin.org/">Irmin</a> storage backend used by
<a href="https://tezos.gitlab.io/">Tezos</a>. Tezos is an open-source blockchain technology,
written in OCaml, which uses many libraries from the MirageOS ecosystem. For
more context on the design of <code>irmin-pack</code> and how it is optimised for the Tezos
use-case, you can check out our <a href="https://tarides.com/blog/2020-09-01-introducing-irmin-pack">previous blog post</a>.</p>
<p>This post showcases the improvements to <code>irmin-pack</code> since its initial
deployment on Tezos:</p>
<ol>
<li><a href="#faster-read-only-store-instances">Faster read-only store instances</a></li>
<li><a href="#better-flushing-for-the-read-write-instance">Improved automatic flushing</a></li>
<li><a href="#faster-serialisation-for-irmintype">Staging generic serialisation operations</a></li>
<li><a href="#more-control-over-indexmerge">More control over <code>Index.merge</code></a></li>
<li><a href="#clearing-stores">Clearing stores</a></li>
</ol>
<h2 id="faster-read-only-store-instances" style="position:relative;"><a href="#faster-read-only-store-instances" aria-label="faster read only store instances permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Faster read-only store instances</h2>
<p>The Tezos use-case of Irmin requires both <em>read-only</em> and <em>read-write</em>
store handles, with multiple readers and a single writer all accessing the same
Irmin store concurrently. These store handles are held by different processes
(with disjoint memory spaces) so the instances must use files on disk to
synchronise, ensuring that the readers never miss updates from the writer. The
writer instance automatically flushes its internal buffers to disk at regular
intervals, allowing the readers to regularly pick up <code>replace</code> calls.</p>
<p>Until recently, each time a reader looked for a value – be it a commit, a node,
or a blob – it first checked if the writer had flushed new contents to disk. This
ensured that the readers always see the latest changes from the writer. However,
if the writer isn't actively modifying the regions being read, the readers make
one unnecessary system call per <code>find</code>. The higher the rate of reads, the more
time is lost to these synchronisation points. This is particularly problematic
in two use-cases:</p>
<ul>
<li><strong>Taking snapshots of the store</strong>. Tezos supports <a href="https://tezos.gitlab.io/user/snapshots.html">exporting portable
snapshots</a> of the store data. Since this operation only reads
<em>historic</em> data in the store (traversing backwards from a given block hash),
it's never necessary to synchronise with the writer.</li>
<li><strong>Bulk writes</strong>. It's sometimes necessary for the writer to dump lots of new
data to disk at once (for instance, when adding a commit to the history). In
these cases, any readers will repeatedly synchronise with the disk even though
they don't need to do so until the bulk operation is complete. More on this in
the coming months!</li>
</ul>
<p>To better support these use-cases, we dropped the requirement for readers to
maintain strict consistency with the writer instance. Instead, readers can call
an explicit <code>sync</code> function only when they <em>need</em> to see the latest concurrent
updates from the writer instance.</p>
<p>In our benchmarks, there is a clear speed-up for <code>find</code> operations from readers:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">[RO] Find in random order with implicit syncs
        Total time: 67.276527
        Operations per second: 148640.253086
        Mbytes per second: 6.378948
        Read amplification in syscalls: 3.919739
        Read amplification in bytes: 63.943734

[RO] Find in random order with only one call to sync
        Total time: 40.817458
        Operations per second: 244993.208543
        Mbytes per second: 10.513968
        Read amplification in syscalls: 0.919588
        Read amplification in bytes: 63.258072</code></pre></div>
<p>Not only it is faster, we can see also that fewer system calls are used in the
<code>Read amplification in syscalls</code> column. The benchmarks consists of reading
10,000,000 entries of 45 bytes each.</p>
<p>Relevant PRs: <a href="https://github.com/mirage/irmin/pull/1008">irmin #1008</a>,
<a href="https://github.com/mirage/index/pull/175">index #175</a>,
<a href="https://github.com/mirage/index/pull/198">index #198</a> and
<a href="https://github.com/mirage/index/pull/203">index #203</a>.</p>
<h2 id="better-flushing-for-the-read-write-instance" style="position:relative;"><a href="#better-flushing-for-the-read-write-instance" aria-label="better flushing for the read write instance permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Better flushing for the read-write instance</h2>
<p>Irmin-pack uses an <a href="https://github.com/mirage/index/">index</a> to speed up <code>find</code>
calls: a <code>pack</code> file is used to store pairs of <code>(key, value)</code> and an <code>index</code>
records the address in pack where a <code>key</code> is stored. A read-write instance has
to write both the <code>index</code> and the <code>pack</code> file, for a read-only instance to find
a value. Moreover, the order in which the data is flushed to disk for the two
files is important: the address for the pair <code>(key, value)</code> cannot be written
before the pair itself. Otherwise the read-only instance can read an address for
a non existing <code>(key, value)</code> pair. But both <code>pack</code> and <code>index</code> have internal
buffers that accumulate data, in order to reduce the number of system calls, and
both decide arbitrarily when to flush those buffers to disk.</p>
<p>We introduce a <code>flush_callback</code> argument in <code>index</code>, which registers a callback
for whenever the index decides to flush. <code>irmin-pack</code> uses this callback to flush
its pack file, resolving the issue of the dangling address.</p>
<p>Relevant PRs: <a href="https://github.com/mirage/index/pull/189">index #189</a>,
<a href="https://github.com/mirage/index/pull/216">index #216</a>,
<a href="https://github.com/mirage/irmin/pull/1051">irmin #1051</a>.</p>
<h2 id="faster-serialisation-for-irmintype" style="position:relative;"><a href="#faster-serialisation-for-irmintype" aria-label="faster serialisation for irmintype permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Faster serialisation for <code>Irmin.Type</code></h2>
<p>Irmin uses a library of <a href="http://ocamllabs.io/iocamljs/generic_programming.html"><em>generic</em></a> operations: functions
that take a runtime representation of a type and derive some operation on that
type. These are used in many places to automatically derive encoders and
decoders for our types, which are then used to move data to and from disk. For
instance:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">val</span> decode <span class="token punctuation">:</span> <span class="token type-variable function">'a</span> t <span class="token operator">-></span> string <span class="token operator">-></span> <span class="token type-variable function">'a</span>
<span class="token comment">(** [decode t] is the binary decoder of values represented by [t]. *)</span>

<span class="token comment">(** Read an integer from a binary-encoded file. *)</span>
<span class="token keyword">let</span> int_of_file <span class="token label function">~path</span> <span class="token operator">=</span> open_in_bin path <span class="token operator">|></span> input_line <span class="token operator">|></span> decode <span class="token module variable">Irmin</span><span class="token punctuation">.</span><span class="token module variable">Type</span><span class="token punctuation">.</span>int32</code></pre></div>
<p>The generic <code>decode</code> takes a <em>representation</em> of the type <code>int32</code> and uses
this to select the right binary decoder. Unfortunately, we pay the cost of this
runtime specialisation <em>every time</em> we call <code>int_of_file</code>. If we're invoking
the decoder for a particular type very often – such as when serialising store
values – it's more efficient to specialise <code>decode</code> once:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token comment">(** Specialised binary decoder for integers. *)</span>
<span class="token keyword">let</span> decode_int32 <span class="token operator">=</span> decode <span class="token module variable">Irmin</span><span class="token punctuation">.</span><span class="token module variable">Type</span><span class="token punctuation">.</span>int32

<span class="token keyword">let</span> int_of_file_fast <span class="token label function">~path</span> <span class="token operator">=</span> open_in_bin path <span class="token operator">|></span> input_line <span class="token operator">|></span> decode_int32 contents</code></pre></div>
<p>The question then becomes: how can we change <code>decode</code> to encourage it to be
used in this more-efficient way? We can add a type wrapper – called <code>staged</code> –
to prevent the user from passing two arguments to <code>decode</code> at once:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">module</span> <span class="token module variable">Staged</span> <span class="token punctuation">:</span> <span class="token keyword">sig</span>
  <span class="token keyword">type</span> <span class="token operator">+</span><span class="token type-variable function">'a</span> t
  <span class="token keyword">val</span>   stage <span class="token punctuation">:</span> <span class="token type-variable function">'a</span>   <span class="token operator">-></span> <span class="token type-variable function">'a</span> t
  <span class="token keyword">val</span> unstage <span class="token punctuation">:</span> <span class="token type-variable function">'a</span> t <span class="token operator">-></span> <span class="token type-variable function">'a</span>
<span class="token keyword">end</span>

<span class="token keyword">val</span> decode <span class="token punctuation">:</span> <span class="token type-variable function">'a</span> t <span class="token operator">-></span> <span class="token punctuation">(</span>string <span class="token operator">-></span> <span class="token type-variable function">'a</span><span class="token punctuation">)</span> <span class="token module variable">Staged</span><span class="token punctuation">.</span>t
<span class="token comment">(** [decode t] needs to be explicitly unstaged before being used. *)</span></code></pre></div>
<p>By forcing the user to add a <code>Staged.unstage</code> type coercion when using this
function, we're encouraging them to hoist such operations out of their
hot-loops:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token comment">(** The slow implementation no longer type-checks: *)</span>

<span class="token keyword">let</span> int_of_file <span class="token label function">~path</span> <span class="token operator">=</span> open_in_bin path <span class="token operator">|></span> input_line <span class="token operator">|></span> decode <span class="token module variable">Irmin</span><span class="token punctuation">.</span><span class="token module variable">Type</span><span class="token punctuation">.</span>int32
<span class="token comment">(* Error: This expression has type (string -> 'a) Staged.t
 *        but an expression was expected of type string -> 'a *)</span>

<span class="token comment">(* Instead, we know to pull [Staged.t] values out of hot-loops: *)</span>

<span class="token keyword">let</span> decode_int32 <span class="token operator">=</span> <span class="token module variable">Staged</span><span class="token punctuation">.</span>unstage <span class="token punctuation">(</span>decode <span class="token module variable">Irmin</span><span class="token punctuation">.</span><span class="token module variable">Type</span><span class="token punctuation">.</span>int32<span class="token punctuation">)</span>

<span class="token keyword">let</span> int_of_file_fast <span class="token label function">~path</span> <span class="token operator">=</span> open_in_bin path <span class="token operator">|></span> input_line <span class="token operator">|></span> decode_int32 contents</code></pre></div>
<p>We made similar changes to the performance-critical generic functions in
<a href="https://mirage.github.io/irmin/irmin/Irmin/Type/index.html"><code>Irmin.Type</code></a>, and observed significant performance improvements.
We also added benchmarks for serialising various types.</p>
<div style="text-align: center;">
  <img src="./staged-type.svg" style="height: 550px; max-width: 100%">
</div>
<p>Relevant PRs: <a href="https://github.com/mirage/irmin/pull/1030">irmin #1030</a> and
<a href="https://github.com/mirage/irmin/pull/1028">irmin #1028</a>.</p>
<p>There are other interesting factors at play, such as altering <code>decode</code> to
increase the efficiency of the specialised decoders; we leave this for a future
blog post.</p>
<h2 id="more-control-over-indexmerge" style="position:relative;"><a href="#more-control-over-indexmerge" aria-label="more control over indexmerge permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>More control over <code>Index.merge</code></h2>
<p>index regularly does a maintenance operation, called <code>merge</code>, to ensure fast
look-ups while having a small memory imprint. This operation is concurrent with
the most of other functions, it is however not concurrent with itself: a second
merge needs to wait for a previous one to finish. When writing big chunks of
data very often, <code>merge</code> operations become blocking. To help measuring and
detecting a blocking <code>merge</code>, we added in the <code>index</code> API calls to check whether
a merge is ongoing, and to time it.</p>
<p>We mentioned that <code>merge</code> is concurrent with most of the other function in
<code>index</code>. One notable exception was <code>close</code>, which had to wait for any ongoing
<code>merge</code> to finish, before closing the index. Now <code>close</code> interrupts an ongoing
merge, but still leaves the index in a clean state.</p>
<p>Relevant PRs: <a href="https://github.com/mirage/index/pull/185">index #185</a>,
<a href="https://github.com/mirage/irmin/pull/1049">irmin #1049</a> and
<a href="https://github.com/mirage/index/pull/215">index #215</a>.</p>
<h2 id="clearing-stores" style="position:relative;"><a href="#clearing-stores" aria-label="clearing stores permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Clearing stores</h2>
<p>Another feature we recently added is the possibility to <code>clear</code> the store. It is
implemented by removing the old files on disk and opening fresh ones. However
in <code>irmin-pack</code>, the read-only instance has to detect that a clear occurred. To
do this, we add a <code>generation</code> in the header of the files used by an
<code>irmin-pack</code> store, which is increased by the clear operation. A generation
change signals to the read-only instance that it needs to close the file and
open it again, to be able to read the latest values.</p>
<p>As the header of the files on disk changed with the addition of the clear
operation, the <code>irmin-pack</code> stores created previous to this change are no longer
supported. We added a migration function for stores created with the previous
version (version 1) to the new version (version 2) of the store. You can call
this migration function as follows:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"> <span class="token keyword">let</span> open_store <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">=</span>
    <span class="token module variable">Store</span><span class="token punctuation">.</span><span class="token module variable">Repo</span><span class="token punctuation">.</span>v config
  <span class="token keyword">in</span>
  <span class="token module variable">Lwt</span><span class="token punctuation">.</span>catch open_store <span class="token punctuation">(</span><span class="token keyword">function</span>
      <span class="token operator">|</span> <span class="token module variable">Irmin_pack</span><span class="token punctuation">.</span><span class="token module variable">Unsupported_version</span> <span class="token variant variable">`V1</span> <span class="token operator">-></span>
          <span class="token module variable">Logs</span><span class="token punctuation">.</span>app <span class="token punctuation">(</span><span class="token keyword">fun</span> l <span class="token operator">-></span> l <span class="token string">"migrating store to version 2"</span><span class="token punctuation">)</span> <span class="token punctuation">;</span>
          <span class="token module variable">Store</span><span class="token punctuation">.</span>migrate config <span class="token punctuation">;</span>
          <span class="token module variable">Logs</span><span class="token punctuation">.</span>app <span class="token punctuation">(</span><span class="token keyword">fun</span> l <span class="token operator">-></span> l <span class="token string">"migration ended, opening store"</span><span class="token punctuation">)</span> <span class="token punctuation">;</span>
          open_store <span class="token punctuation">(</span><span class="token punctuation">)</span>
      <span class="token operator">|</span> exn <span class="token operator">-></span>
          <span class="token module variable">Lwt</span><span class="token punctuation">.</span>fail exn<span class="token punctuation">)</span></code></pre></div>
<p>Relevant PRs: <a href="https://github.com/mirage/index/pull/211">index #211</a>,
<a href="https://github.com/mirage/irmin/pull/1047">irmin #1047</a>,
<a href="https://github.com/mirage/irmin/pull/1070">irmin #1070</a> and
<a href="https://github.com/mirage/irmin/pull/1071">irmin #1071</a>.</p>
<h2 id="conclusion" style="position:relative;"><a href="#conclusion" aria-label="conclusion permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Conclusion</h2>
<p>We hope you've enjoyed this discussion of our recent work. <a href="https://twitter.com/tarides_">Stay
tuned</a> for our next Tezos / MirageOS development update! Thanks
to our commercial customers, users and open-source contributors for making this
work possible.</p>|js}
  };
 
  { title = {js|Irmin usability enhancements|js}
  ; slug = {js|irmin-usability-enhancements|js}
  ; description = Some {js|For the next few months I will be working on Irmin, focusing on improving general usability. The goal of this effort is to make Irmin more accessible to potential users and clean up the rough edges for existing users.  One of the biggest problems I see right now is that the documentation is out of sync with the current implementation. I’ve just been getting starting refreshing the documentation and tutorials, however here are a few more projects that @samoht and I have discussed:   Better RPC AP...|js}
  ; url = {js|https://discuss.ocaml.org/t/irmin-usability-enhancements/2017|js}
  ; date = {js|2018-05-18T00:00:00-00:00|js}
  ; preview_image = Some {js|https://aws1.discourse-cdn.com/standard11/uploads/ocaml/original/2X/d/d4dc9fe40b17e2bcced034f9fe103917b7999275.svg|js}
  ; body_html = {js|<p>Zach Shipko is working on improving the UI/UX for Irmin.
He is looking for <a href="https://discuss.ocaml.org/t/irmin-usability-enhancements/2017">feedback</a>
to make Irmin more accessible to potential users and clean up the rough edges for existing users.</p>|js}
  };
 
  { title = {js|Irmin v2|js}
  ; slug = {js|irmin-v2|js}
  ; description = Some {js|We are pleased to announce Irmin
2.0.0, a major release of the
Git-like distributed branching and storage substrate that underpins
MirageOS…|js}
  ; url = {js|https://tarides.com/blog/2019-11-21-irmin-v2|js}
  ; date = {js|2019-11-21T00:00:00-00:00|js}
  ; preview_image = Some {js|https://tarides.com/static/d702f060cc02fbcb7329077e2d71741d/497c6/irmin2.png|js}
  ; body_html = {js|<p>We are pleased to announce <a href="https://github.com/mirage/irmin/releases">Irmin
2.0.0</a>, a major release of the
Git-like distributed branching and storage substrate that underpins
<a href="https://mirage.io">MirageOS</a>.  We began the release process for all the
components that make up Irmin <a href="https://tarides.com/blog/2019-05-13-on-the-road-to-irmin-v2">back in May
2019</a>, and there
have been close to 1000 commits since Irmin 1.4.0 released back in June 2018. To
celebrate this milestone, we have a new logo and opened a dedicated website:
<a href="https://irmin.org">irmin.org</a>.</p>
<p>Our focus this year has been on ensuring the production success of our
early adopters -- such as the
<a href="https://gitlab.com/tezos/tezos/tree/master/src/lib_storage">Tezos</a> blockchain
and the <a href="https://github.com/moby/datakit">Datakit 9P</a>
stack -- as well as spawning new research projects into the practical
application of distributed and mergeable data stores.  We are also
very pleased to welcome several new maintainers into the Mirage
project for their contributions to Irmin, namely
<a href="https://github.com/icristescu">Ioana Cristescu</a>,
<a href="https://github.com/CraigFe">Craig Ferguson</a>,
<a href="https://github.com/andreas">Andreas Garnaes</a>,
<a href="https://github.com/pascutto">Clément Pascutto</a> and
<a href="https://github.com/zshipko">Zach Shipko</a>.</p>
<h2 id="new-major-features" style="position:relative;"><a href="#new-major-features" aria-label="new major features permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>New Major Features</h2>
<h3 id="new-cli" style="position:relative;"><a href="#new-cli" aria-label="new cli permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>New CLI</h3>
<p>While Irmin is normally used as a library, it is obviously useful to
be able to interact with a data store from a shell.  The <code>irmin-unix</code>
opam package now provides an <code>irmin</code> binary that is configured via a
Yaml file and can perform queries and mutations against a Git store.</p>
<div class="gatsby-highlight" data-language="shell"><pre class="language-shell"><code class="language-shell">$ <span class="token builtin class-name">echo</span> <span class="token string">"root: ."</span> <span class="token operator">></span> irmin.yml
$ irmin init
$ irmin <span class="token builtin class-name">set</span> foo/bar <span class="token string">"testing 123"</span>
$ irmin get foo/bar</code></pre></div>
<p>Try <code>irmin --help</code> to see all the commands and options available.</p>
<h3 id="tezos-and-irmin-pack" style="position:relative;"><a href="#tezos-and-irmin-pack" aria-label="tezos and irmin pack permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Tezos and irmin-pack</h3>
<p>Another big user of Irmin is the <a href="https://tezos.com">Tezos blockchain</a>,
and we have been optimising the persistent space usage of Irmin as their
network grows.  Because Tezos doesn’t require full Git format support,
we created a hybrid backend that grabs the best bits of Git (e.g. the
packfile mechanism) and engineered a domain-specific backend tailored
for Tezos usage. Crucially, because of the way Irmin is split into
clean libraries and OCaml modules, we only had to modify a small part
of the codebase and could also reuse elements of our
<a href="https://github.com/mirage/ocaml-git">OCaml-git</a> codebase as well.</p>
<p>The <a href="https://github.com/mirage/irmin/pull/615">irmin-pack backend</a> is available
for <a href="https://github.com/mirage/irmin/pull/888">use in the CLI</a> and provides a
significant improvement in disk usage.  There is a corresponding <a href="https://gitlab.com/tezos/tezos/merge_requests/1268">Tezos merge
request</a> using the Irmin
2.0 code that has been integrated downstream and will become available via
their release process in due course.</p>
<p>As part of this development process, we also released an efficient multi-level
index implementation (imaginatively dubbed
<a href="https://github.com/mirage/index">index</a> in opam). Our implementation takes an
arbitrary IO implementation and user-supplied content types and supplies a
standard key-value interface for persistent storage. Index provides instance
sharing by default, so each OCaml runtime shares a common singleton instance.</p>
<h3 id="irmin-graphql-and-browser-irmin" style="position:relative;"><a href="#irmin-graphql-and-browser-irmin" aria-label="irmin graphql and browser irmin permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Irmin-GraphQL and “browser Irmin”</h3>
<p>Another new area of huge interest to us is
<a href="https://graphql.org">GraphQL</a> in order to provide frontends with a rich
query language for Irmin-hosted applications.  Irmin 2.0 includes a
built-in GraphQL server so you can <a href="https://twitter.com/cuvius/status/1017136581755457539">manipulate your Git repo via
GraphQL</a>.</p>
<p>If you are interested in (for example) compiling elements of Irmin to
JavaScript or wasm, for usage in frontends, then the Irmin 2.0 release
makes it significantly easier to support this architecture.  We’ve
already seen some exploratory efforts <a href="https://github.com/mirage/irmin/issues/681">report issues</a>
when doing this, and we’ve had it working ourselves in <a href="http://roscidus.com/blog/blog/2015/04/28/cuekeeper-gitting-things-done-in-the-browser/">Irmin 1.0 Cuekeeper</a>
so we are excited by the potential power of applications built using
this model.  If you have ideas/questions, please get in touch on the
<a href="https://github.com/mirage/irmin/issues">issue tracker</a> with your
usecase.</p>
<h3 id="wodan" style="position:relative;"><a href="#wodan" aria-label="wodan permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Wodan</h3>
<p>Irmin’s storage layer is also well abstracted, so backends other than
a Unix filesystem or Git are supported.  Irmin can run in highly
diverse and OS-free environments, and so we began engineering the
<a href="https://github.com/mirage/wodan">Wodan filesystem</a> as a
domain-specific filesystem designed for MirageOS, Irmin and modern
flash drives.  See <a href="https://g2p.github.io/research/wodan.pdf">the OCaml Workshop 2017 abstract on
it</a> for more design
rationale.</p>
<p>As part of the Irmin 2.0 release, Wodan is also being prepared for a
release, and you can find <a href="https://github.com/mirage/wodan/tree/master/src/wodan-irmin">Irmin 2.0
support</a>
in the source.  If you’d like a standalone block-device based
persistence environment for Irmin, please try this out.  This is the
preferred backend for using Irmin storage in a unikernel.</p>
<h3 id="versioned-caldav" style="position:relative;"><a href="#versioned-caldav" aria-label="versioned caldav permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a> Versioned CalDAV</h3>
<p>An application pulling all these pieces together is being developed
by our friends at <a href="https://robur.io/About%20Us/Team">Robur</a>: an Irmin-based
<a href="https://github.com/roburio/caldav">CalDAV calendaring server</a>
that even hosts its DNS server using a versioned Irmin store.  We'll
blog more about this as the components get released and stabilised, but
the unikernel enthusiasts among you may want to browse the
<a href="https://github.com/roburio/unikernels/tree/future">Robur unikernels future branch</a>
to see how they are deploying them today.</p>
<p>A huge thank you to all our commercial customers, end users and open-source
developers who have contributed their time, expertise and
financial support to help us achieve our goal of delivering a modern
storage stack in the spirit of Git.  Our next steps for Irmin are to
continue to increase the performance and optimise the storage,
and to build more end-to-end applications using the application core
on top of MirageOS.</p>|js}
  };
 
  { title = {js|MirageOS, towards a smaller and safer OS|js}
  ; slug = {js|mirageos-towards-a-smaller-and-safer-os|js}
  ; description = Some {js|This presentation by Romain Calascibetta took place at Lambda World Cádiz on October 26th, 2018 at the Palacio de Congresos in Cádiz, Spain.MirageOS, towards...|js}
  ; url = {js|https://www.youtube.com/watch?v=urG5BjvjW18|js}
  ; date = {js|2018-12-06T00:00:00-00:00|js}
  ; preview_image = Some {js|https://i.ytimg.com/vi/urG5BjvjW18/maxresdefault.jpg|js}
  ; body_html = {js|<p>Presentation about MirageOS in Lambda World Cadìz on October 26th</p>|js}
  };
 
  { title = {js|Mr. MIME - Parse and generate emails|js}
  ; slug = {js|mr-mime---parse-and-generate-emails|js}
  ; description = Some {js|We're glad to announce the first release of mrmime, a parser and a
generator of emails. This library provides an OCaml way to analyze and…|js}
  ; url = {js|https://tarides.com/blog/2019-09-25-mr-mime-parse-and-generate-emails|js}
  ; date = {js|2019-09-25T00:00:00-00:00|js}
  ; preview_image = Some {js|https://tarides.com/static/14bcc335478eae1bbad1c2f4cdd244af/2244e/mailboxes2.jpg|js}
  ; body_html = {js|<p>We're glad to announce the first release of <a href="https://github.com/mirage/mrmime.git"><code>mrmime</code></a>, a parser and a
generator of emails. This library provides an <em>OCaml way</em> to analyze and craft
an email. The eventual goal is to build an entire <em>unikernel-compatible</em> stack
for email (such as SMTP or IMAP).</p>
<p>In this article, we will show what is currently possible with <code>mrmime</code> and
present a few of the useful libraries that we developed along the way.</p>
<h2 id="an-email-parser" style="position:relative;"><a href="#an-email-parser" aria-label="an email parser permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>An email parser</h2>
<p>Some years ago, Romain gave <a href="https://www.youtube.com/watch?v=kQkRsNEo25k">a talk</a> about what an email really <em>is</em>.
Behind the human-comprehensible format (or <em>rich-document</em> as we said a
long time ago), there are several details of emails which complicate the process of
analyzing them (and can be prone to security lapses). These details are mostly described
by three RFCs:</p>
<ul>
<li><a href="https://tools.ietf.org/html/rfc822">RFC822</a></li>
<li><a href="https://tools.ietf.org/html/rfc2822">RFC2822</a></li>
<li><a href="https://tools.ietf.org/html/rfc5322">RFC5322</a></li>
</ul>
<p>Even though they are cross-compatible, providing full legacy email parsing is an
archaeological exercise: each RFC retains support for the older design decisions
(which were not recognized as bad or ugly in 1970 when they were first standardized).</p>
<p>The latest email-related RFC (RFC5322) tried to fix the issue and provide a better
<a href="https://tools.ietf.org/html/rfc5234">formal specification</a> of the email format – but of course, it comes with plenty of
<em>obsolete</em> rules which need to be implemented. In the standard, you find
both the current grammar rule and its obsolete equivalent.</p>
<h3 id="an-extended-email-parser" style="position:relative;"><a href="#an-extended-email-parser" aria-label="an extended email parser permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>An extended email parser</h3>
<p>Even if the email format can defined by "only" 3 RFCs, you will
miss email internationalization (<a href="https://tools.ietf.org/html/rfc6532">RFC6532</a>), the MIME format
(<a href="https://tools.ietf.org/html/rfc2045">RFC2045</a>, <a href="https://tools.ietf.org/html/rfc2046">RFC2046</a>, <a href="https://tools.ietf.org/html/rfc2047">RFC2047</a>,
<a href="https://tools.ietf.org/html/rfc2049">RFC2049</a>), or certain details needed to be interoperable with SMTP
(<a href="https://tools.ietf.org/html/rfc5321">RFC5321</a>). There are still more RFCs which add extra features
to the email format such as S/MIME or the Content-Disposition field.</p>
<p>Given this complexity, we took the most general RFCs and tried to provide an easy way to deal
with them. The main difficulty is the <em>multipart</em> parser, which deals with email
attachments (anyone who has tried to make an HTTP 1.1 parser knows about this).</p>
<h3 id="a-realistic-email-parser" style="position:relative;"><a href="#a-realistic-email-parser" aria-label="a realistic email parser permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>A realistic email parser</h3>
<p>Respecting the rules described by RFCs is not enough to be able to analyze any
email from the real world: existing email generators can, and do, produce
<em>non-compliant</em> email. We stress-tested <code>mrmime</code> by feeding it a batch of 2
billion emails taken from the wild, to see if it could parse everything (even if
it does not produce the expected result). Whenever we noticed a recurring
formatting mistake, we updated the details of the <a href="https://tools.ietf.org/html/rfc5234">ABNF</a> to enable
<code>mrmime</code> to parse it anyway.</p>
<h3 id="a-parser-usable-by-others" style="position:relative;"><a href="#a-parser-usable-by-others" aria-label="a parser usable by others permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>A parser usable by others</h3>
<p>One demonstration of the usability of <code>mrmime</code> is <a href="https://github.com/dinosaure/ocaml-dkim.git"><code>ocaml-dkim</code></a>, which wants to
extract a specific field from your mail and then verify that the hash and signature
are as expected.</p>
<p><code>ocaml-dkim</code> is used by the latest implementation of <a href="https://github.com/mirage/ocaml-dns.git"><code>ocaml-dns</code></a> to request
public keys in order to verify email.</p>
<p>The most important question about <code>ocaml-dkim</code> is: is it able to
verify your email in one pass? Indeed, currently some implementations of DKIM
need 2 passes to verify your email (one to extract the DKIM signature, the other
to digest some fields and bodies). We focused on verifying in a <em>single</em> pass in
order to provide a unikernel SMTP <em>relay</em> with no need to store your email between
verification passes.</p>
<h2 id="an-email-generator" style="position:relative;"><a href="#an-email-generator" aria-label="an email generator permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>An email generator</h2>
<p>OCaml is a good language for making little DSLs for specialized use-cases. In this
case, we took advantage of OCaml to allow the user to easily craft an email from
nothing.</p>
<p>The idea is to build an OCaml value describing the desired email header, and
then let the Mr. MIME generator transform this into a stream of characters that
can be consumed by, for example, an SMTP implementation. The description step
is quite simple:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token directive important">#require</span> <span class="token string">"mrmime"</span> <span class="token punctuation">;</span><span class="token punctuation">;</span>
<span class="token directive important">#require</span> <span class="token string">"ptime.clock.os"</span> <span class="token punctuation">;</span><span class="token punctuation">;</span>

<span class="token keyword">open</span> <span class="token module variable">Mrmime</span>

<span class="token keyword">let</span> romain_calascibetta <span class="token operator">=</span>
  <span class="token keyword">let</span> <span class="token keyword">open</span> <span class="token module variable">Mailbox</span> <span class="token keyword">in</span>
  <span class="token module variable">Local</span><span class="token punctuation">.</span><span class="token punctuation">[</span> w <span class="token string">"romain"</span><span class="token punctuation">;</span> w <span class="token string">"calascibetta"</span> <span class="token punctuation">]</span> <span class="token operator">@</span> <span class="token module variable">Domain</span><span class="token punctuation">.</span><span class="token punctuation">(</span>domain<span class="token punctuation">,</span> <span class="token punctuation">[</span> a <span class="token string">"gmail"</span><span class="token punctuation">;</span> a <span class="token string">"com"</span> <span class="token punctuation">]</span><span class="token punctuation">)</span>

<span class="token keyword">let</span> john_doe <span class="token operator">=</span>
  <span class="token keyword">let</span> <span class="token keyword">open</span> <span class="token module variable">Mailbox</span> <span class="token keyword">in</span>
  <span class="token module variable">Local</span><span class="token punctuation">.</span><span class="token punctuation">[</span> w <span class="token string">"john"</span> <span class="token punctuation">]</span> <span class="token operator">@</span> <span class="token module variable">Domain</span><span class="token punctuation">.</span><span class="token punctuation">(</span>domain<span class="token punctuation">,</span> <span class="token punctuation">[</span> a <span class="token string">"doe"</span><span class="token punctuation">;</span> a <span class="token string">"org"</span> <span class="token punctuation">]</span><span class="token punctuation">)</span>
  <span class="token operator">|></span> with_name <span class="token module variable">Phrase</span><span class="token punctuation">.</span><span class="token punctuation">(</span>v <span class="token punctuation">[</span> w <span class="token string">"John"</span><span class="token punctuation">;</span> w <span class="token string">"D."</span> <span class="token punctuation">]</span><span class="token punctuation">)</span>

<span class="token keyword">let</span> now <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">=</span>
  <span class="token keyword">let</span> <span class="token keyword">open</span> <span class="token module variable">Date</span> <span class="token keyword">in</span>
  of_ptime <span class="token label function">~zone</span><span class="token punctuation">:</span><span class="token module variable">Zone</span><span class="token punctuation">.</span><span class="token module variable">GMT</span> <span class="token punctuation">(</span><span class="token module variable">Ptime_clock</span><span class="token punctuation">.</span>now <span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">)</span>

<span class="token keyword">let</span> subject <span class="token operator">=</span>
  <span class="token module variable">Unstructured</span><span class="token punctuation">.</span><span class="token punctuation">[</span> v <span class="token string">"A"</span><span class="token punctuation">;</span> sp <span class="token number">1</span><span class="token punctuation">;</span> v <span class="token string">"Simple"</span><span class="token punctuation">;</span> sp <span class="token number">1</span><span class="token punctuation">;</span> v <span class="token string">"Mail"</span> <span class="token punctuation">]</span>

<span class="token keyword">let</span> header <span class="token operator">=</span>
  <span class="token keyword">let</span> <span class="token keyword">open</span> <span class="token module variable">Header</span> <span class="token keyword">in</span>
  <span class="token module variable">Field</span><span class="token punctuation">.</span><span class="token punctuation">(</span><span class="token module variable">Subject</span> <span class="token operator">$</span> subject<span class="token punctuation">)</span>
  <span class="token operator">&amp;</span> <span class="token module variable">Field</span><span class="token punctuation">.</span><span class="token punctuation">(</span><span class="token module variable">Sender</span> <span class="token operator">$</span> romain_calascibetta<span class="token punctuation">)</span>
  <span class="token operator">&amp;</span> <span class="token module variable">Field</span><span class="token punctuation">.</span><span class="token punctuation">(</span><span class="token module variable">To</span> <span class="token operator">$</span> <span class="token module variable">Address</span><span class="token punctuation">.</span><span class="token punctuation">[</span> mailbox john_doe <span class="token punctuation">]</span><span class="token punctuation">)</span>
  <span class="token operator">&amp;</span> <span class="token module variable">Field</span><span class="token punctuation">.</span><span class="token punctuation">(</span><span class="token module variable">Date</span> <span class="token operator">$</span> now <span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">)</span>
  <span class="token operator">&amp;</span> empty

<span class="token keyword">let</span> stream <span class="token operator">=</span> <span class="token module variable">Header</span><span class="token punctuation">.</span>to_stream header

<span class="token keyword">let</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">=</span>
  <span class="token keyword">let</span> <span class="token keyword">rec</span> go <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">=</span>
    <span class="token keyword">match</span> stream <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token keyword">with</span>
    <span class="token operator">|</span> <span class="token module variable">Some</span> buf <span class="token operator">-></span> print_string buf<span class="token punctuation">;</span> go <span class="token punctuation">(</span><span class="token punctuation">)</span>
    <span class="token operator">|</span> <span class="token module variable">None</span> <span class="token operator">-></span> <span class="token punctuation">(</span><span class="token punctuation">)</span>
  <span class="token keyword">in</span>
  go <span class="token punctuation">(</span><span class="token punctuation">)</span></code></pre></div>
<p>This code produces the following header:</p>
<div class="gatsby-highlight" data-language="mail"><pre class="language-mail"><code class="language-mail">Date: 2 Aug 2019 14:10:10 GMT
To: John &quot;D.&quot; &lt;john@doe.org&gt;
Sender: romain.calascibetta@gmail.com
Subject: A Simple Mail</code></pre></div>
<h3 id="78-character-rule" style="position:relative;"><a href="#78-character-rule" aria-label="78 character rule permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>78-character rule</h3>
<p>One aspect about email and SMTP is about some historical rules of how to
generate them. One of them is about the limitation of bytes per line. Indeed, a
generator of mail should emit at most 80 bytes per line - and, of course, it
should emits entirely the email line per line.</p>
<p>So <code>mrmime</code> has his own encoder which tries to wrap your mail into this limit.
It was mostly inspired by <a href="https://github.com/inhabitedtype/faraday">Faraday</a> and <a href="https://caml.inria.fr/pub/docs/manual-ocaml/libref/Format.html">Format</a> powered with
GADT to easily describe how to encode/generate parts of an email.</p>
<h3 id="a-multipart-email-generator" style="position:relative;"><a href="#a-multipart-email-generator" aria-label="a multipart email generator permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>A multipart email generator</h3>
<p>Of course, the main point about email is to be able to generate a multipart
email - just to be able to send file attachments. And, of course, a deep work
was done about that to make parts, compose them into specific <code>Content-Type</code>
fields and merge them into one email.</p>
<p>Eventually, you can easily make a stream from it, which respects rules (78 bytes
per line, stream line per line) and use it directly into an SMTP implementation.</p>
<p>This is what we did with the project <a href="https://github.com/dinosaure/facteur"><code>facteur</code></a>. It's a little
command-line tool to send with file attachement mails in pure OCaml - but it
works only on an UNIX operating system for instance.</p>
<h2 id="behind-the-forest" style="position:relative;"><a href="#behind-the-forest" aria-label="behind the forest permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Behind the forest</h2>
<p>Even if you are able to parse and generate an email, more work is needed to get the expected results.</p>
<p>Indeed, email is a exchange unit between people and the biggest deal on that is
to find a common way to ensure a understable communication each others. About
that, encoding is probably the most important piece and when a French person wants
to communicate with a <em>latin1</em> encoding, an American person can still use ASCII.</p>
<h3 id="rosetta" style="position:relative;"><a href="#rosetta" aria-label="rosetta permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Rosetta</h3>
<p>So about this problem, the choice was made to unify any contents to UTF-8 as the
most general encoding of the world. So, we did some libraries which map an encoding flow
to Unicode code-point, and we use <code>uutf</code> (thanks to <a href="https://github.com/dbuenzli">dbuenzli</a>) to normalize it to UTF-8.</p>
<p>The main goal is to avoid a headache to the user about that and even if
contents of the mail is encoded with <em>latin1</em> we ensure to translate it
correctly (and according RFCs) to UTF-8.</p>
<p>This project is <a href="https://github.com/mirage/rosetta"><code>rosetta</code></a> and it comes with:</p>
<ul>
<li><a href="https://github.com/mirage/uuuu"><code>uuuu</code></a> for ISO-8859 encoding</li>
<li><a href="https://github.com/mirage/coin"><code>coin</code></a> for KOI8-{R,U} encoding</li>
<li><a href="https://github.com/mirage/yuscii"><code>yuscii</code></a> for UTF-7 encoding</li>
</ul>
<h3 id="pecu-and-base64" style="position:relative;"><a href="#pecu-and-base64" aria-label="pecu and base64 permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Pecu and Base64</h3>
<p>Then, bodies can be encoded in some ways, 2 precisely (if we took the main
standard):</p>
<ul>
<li>A base64 encoding, used to store your file</li>
<li>A quoted-printable encoding</li>
</ul>
<p>So, about the <code>base64</code> package, it comes with a sub-package <code>base64.rfc2045</code>
which respects the special case to encode a body according RFC2045 and SMTP
limitation.</p>
<p>Then, <code>pecu</code> was made to encode and decode <em>quoted-printable</em> contents. It was
tested and fuzzed of course like any others MirageOS's libraries.</p>
<p>These libraries are needed for an other historical reason which is: bytes used
to store mail should use only 7 bits instead of 8 bits. This is the purpose of
the base64 and the <em>quoted-printable</em> encoding which uses only 127 possibilities
of a byte. Again, this limitation comes with SMTP protocol.</p>
<h2 id="conclusion" style="position:relative;"><a href="#conclusion" aria-label="conclusion permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Conclusion</h2>
<p><code>mrmime</code> is tackling the difficult task to parse and generate emails according to 50 years of usability, several RFCs and legacy rules.
So, it
still is an experimental project. We reach the first version of it because we
are currently able to parse many mails and then generate them correctly.</p>
<p>Of course, a <em>bug</em> (a malformed mail, a server which does not respect standards
or a bad use of our API) can appear easily where we did not test everything. But
we have the feeling it was the time to release it and let people to use
it.</p>
<p>The best feedback about <code>mrmime</code> and the best improvement is yours. So don't be
afraid to use it and start to hack your emails with it.</p>|js}
  };
 
  { title = {js|ocaml-git 2.0|js}
  ; slug = {js|ocaml-git-20|js}
  ; description = Some {js|I'm very happy to announce a new major release of ocaml-git (2.0).
This release is a 2-year effort to get a revamped
streaming API offering…|js}
  ; url = {js|https://tarides.com/blog/2018-10-19-ocaml-git-2-0|js}
  ; date = {js|2018-10-19T00:00:00-00:00|js}
  ; preview_image = Some {js|https://tarides.com/static/1d805022c72839f1abe63b28f225fd32/2244e/mesh.jpg|js}
  ; body_html = {js|<p>I'm very happy to announce a new major release of <code>ocaml-git</code> (2.0).
This release is a 2-year effort to get a revamped
streaming API offering a full control over memory
allocation. This new version also adds production-ready implementations of
the wire protocol: <code>git push</code> and <code>git pull</code> now work very reliably
using the raw Git and smart HTTP protocol (SSH support will come
soon). <code>git gc</code> is also implemented, and all of the basic bricks are
now available to create Git servers. MirageOS support is available
out-of-the-box.</p>
<p>Two years ago, we decided to rewrite <code>ocaml-git</code> and split it into
standalone libraries. More details about these new libraries are also
given below.</p>
<p>But first, let's focus on <code>ocaml-git</code>'s new design. The primary goal was
to fix memory consumption issues that our users noticed with the previous version,
and to make <code>git push</code> work reliably. We also took care about
not breaking the API too much, to ease the transition for current users.</p>
<h2 id="controlled-allocations" style="position:relative;"><a href="#controlled-allocations" aria-label="controlled allocations permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Controlled allocations</h2>
<p>There is a big difference in the way <code>ocaml-git</code> and <code>git</code>
are designed: <code>git</code> is a short-lived command-line tool which does not
care that much about allocation policies, whereas we wanted to build a
library that can be linked with long-lived Git client and/or server
applications. We had to make some (performance) compromises to support
that use-case, at the benefit of tighter allocation policies — and hence
more predictable memory consumption patterns.
Other Git libraries such as <a href="https://libgit2.org/">libgit2</a>
also have to <a href="https://libgit2.org/security/">deal</a> with similar concerns.</p>
<p>In order to keep a tight control on the allocated memory, we decided to
use <a href="https://github.com/mirage/decompress">decompress</a> instead of
<code>camlzip</code>. <code>decompress</code> allows the users to provide their own buffer
instead of allocating dynamically. This allowed us to keep a better
control on memory consumption. See below for more details on <code>decompress</code>.</p>
<p>We also used <a href="https://github.com/inhabitedtype/angstrom">angstrom</a> and
<a href="https://github.com/mirage/encore">encore</a> to provide a streaming interface
to encode and decode Git objects. The streaming API is currently hidden
to the end-user, but it helped us a lot to build abstraction and, again, on
managing the allocation policy of the library.</p>
<h2 id="complete-pack-file-support-including-gc" style="position:relative;"><a href="#complete-pack-file-support-including-gc" aria-label="complete pack file support including gc permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Complete PACK file support (including GC)</h2>
<p>In order to find the right abstraction for manipulating pack files in
a long-lived application, we experimented with
<a href="https://github.com/dinosaure/sirodepac">various</a>
<a href="https://github.com/dinosaure/carton">prototypes</a>. We haven't found the
right abstractions just yet, but we believe the PACK format could be useful
to store any kind of data in the future (and not especially Git objects).</p>
<p>We implemented <code>git gc</code> by following the same heuristics as
<a href="https://github.com/git/git/blob/master/Documentation/technical/pack-heuristics.txt">Git</a>
to compress pack files and
we produce something similar in size — <code>decompress</code> has a good ratio about
compression — and we are using <code>duff</code>, our own implementation of <code>xdiff</code>, the
binary diff algorithm used by Git (more details on <code>duff</code> below).
We also had to re-implement the streaming algorithm to reconstruct <code>idx</code> files on
the fly, when receiving pack file on the network.</p>
<p>One notable feature of our compression algorithms is they work without
the assumption that the underlying system implements POSIX: hence,
they can work fully in-memory, in a browser using web storage or
inside a MirageOS unikernel with <a href="https://github.com/mirage/wodan">wodan</a>.</p>
<h2 id="production-ready-push-and-pull" style="position:relative;"><a href="#production-ready-push-and-pull" aria-label="production ready push and pull permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Production-ready push and pull</h2>
<p>We re-implemented and abstracted the <a href="https://github.com/git/git/blob/master/Documentation/technical/http-protocol.txt">Git Smart protocol</a>, and used that
abstraction to make <code>git push</code> and <code>git pull</code> work over HTTP.  By
default we provide a <a href="https://github.com/mirage/cohttp">cohttp</a>
implementation but users can use their own — for instance based on
<a href="https://github.com/inhabitedtype/httpaf">httpaf</a>.
As proof-of-concept, the <a href="https://github.com/mirage/ocaml-git/pull/227">initial
pull-request</a> of <code>ocaml-git</code> 2.0 was
created using this new implementation; moreover, we wrote a
prototype of a Git client compiled with <code>js_of_ocaml</code>, which was able
to run <code>git pull</code> over HTTP inside a browser!</p>
<p>Finally, that implementation will allow MirageOS unikernels to synchronize their
internal state with external Git stores (hosted for instance on GitHub)
using push/pull mechanisms. We also expect to release a server-side implementation
of the smart HTTP protocol, so that the state of any unikernel can be inspected
via <code>git pull</code>. Stay tuned for more updates on that topic!</p>
<h2 id="standalone-dependencies" style="position:relative;"><a href="#standalone-dependencies" aria-label="standalone dependencies permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Standalone Dependencies</h2>
<p>Below you can find the details of the new stable releases of libraries that are
used by <code>ocaml-git</code> 2.0.</p>
<h3 id="optint-and-checkseum" style="position:relative;"><a href="#optint-and-checkseum" aria-label="optint and checkseum permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a><code>optint</code> and <code>checkseum</code></h3>
<p>In some parts of <code>ocaml-git</code>, we need to compute a Circular
Redundancy Check value. It is 32-bit integer value. <code>optint</code> provides
an abstraction of it but structurally uses an unboxed integer or a
boxed <code>int32</code> value depending on target (32 bit or 64 bit architecture).</p>
<p><code>checkseum</code> relies on <code>optint</code> and provides 3 implementations of CRC:</p>
<ul>
<li>Adler32 (used by <code>zlib</code> format)</li>
<li>CRC32 (used by <code>gzip</code> format and <code>git</code>)</li>
<li>CRC32-C (used by <code>wodan</code>)</li>
</ul>
<p><code>checkseum</code> uses the <em>linking trick</em>: this means that users of the
library program against an abstract API (only the <code>cmi</code> is provided);
at link-time, users have to select which implementation to use:
<code>checkseum.c</code> (the C implementation) or <code>checkseum.ocaml</code> (the OCaml
implementation). The process is currently a bit cumbersome but upcoming
<code>dune</code> release will make that process much more transparent to the users.</p>
<h3 id="encore-angkor" style="position:relative;"><a href="#encore-angkor" aria-label="encore angkor permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a><code>encore</code> (/<em>angkor</em>/)</h3>
<p>In <code>git</code>, we work with Git <em>objects</em> (<em>tree</em>, <em>blob</em> or
<em>commit</em>). These objects are encoded in a specific format. Then,
the hash of these objects are computed from the encoded
result to get a unique identifier. For example, the hash of your last commit is:
<code>sha1(encode(commit))</code>.</p>
<p>A common operation in <code>git</code> is to decode Git objects from an encoded
representation of them (especially in <code>.git/objects/*</code> as a <em>loose</em>
file) and restore them in another part of your Git repository (like in a
PACK file or on the command-line).</p>
<p>Hence, we need to ensure that encoding is always deterministic, and
that decoding an encoded Git object is always the identity, e.g. there is
an <em>isomorphism</em> between the decoder and the encoder.</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> decoder <span class="token operator">&lt;.></span> encoder <span class="token punctuation">:</span> <span class="token keyword">value</span> <span class="token operator">-></span> <span class="token keyword">value</span> <span class="token operator">=</span> id
<span class="token keyword">let</span> encoder <span class="token operator">&lt;.></span> decoder <span class="token punctuation">:</span> string <span class="token operator">-></span> string <span class="token operator">=</span> id</code></pre></div>
<p><a href="https://github.com/mirage/encore">encore</a> is a library in which you
can describe a format (like Git format) and from it, we can derive a
streaming decoder <strong>and</strong> encoder that are isomorphic by
construction.</p>
<h3 id="duff" style="position:relative;"><a href="#duff" aria-label="duff permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a><code>duff</code></h3>
<p><a href="https://github.com/mirage/duff">duff</a> is a pure implementation in
OCaml of the <code>xdiff</code> algorithm.
Git has an optimized representation of your Git repository. It's a
PACK file. This format uses a binary diff algorithm called <code>xdiff</code>
to compress binary data. <code>xdiff</code> takes a source A and a target B and try
to find common sub-strings between A and B.</p>
<p>This is done by a Rabin's fingerprint of the source A applied to the
target B. The fingerprint can then be used to produce a lightweight
representation of B in terms of sub-strings of A.</p>
<p><code>duff</code> implements this algorithm (with additional Git's constraints,
regarding the size of the sliding windows) in OCaml. It provides a
small binary <code>xduff</code> that complies with the format of Git without the <code>zlib</code>
layer.</p>
<div class="gatsby-highlight" data-language="sh"><pre class="language-sh"><code class="language-sh">$ xduff diff source target &gt; target.xduff
$ xduff patch source &lt; target.xduff &gt; target.new
$ diff target target.new
$ echo $?
0</code></pre></div>
<h3 id="decompress" style="position:relative;"><a href="#decompress" aria-label="decompress permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a><code>decompress</code></h3>
<p><a href="https://github.com/mirage/decompress">decompress</a>
is a pure implementation in OCaml of <code>zlib</code> and
<code>rfc1951</code>. You can compress and decompress data flows and, obviously,
Git does this compression in <em>loose</em> files and PACK files.</p>
<p>It provides a non-blocking interface and is easily usable in a server
context. Indeed, the implementation never allocates and only relies on
what the user provides (<code>window</code>, input and output buffer). Then, the
distribution provides an easy example of how to use <code>decompress</code>:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">val</span> inflate<span class="token punctuation">:</span> <span class="token operator">?</span>level<span class="token punctuation">:</span>int <span class="token operator">-></span> string <span class="token operator">-></span> string
<span class="token keyword">val</span> deflate<span class="token punctuation">:</span> string <span class="token operator">-></span> string</code></pre></div>
<h3 id="digestif" style="position:relative;"><a href="#digestif" aria-label="digestif permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a><code>digestif</code></h3>
<p><a href="https://github.com/mirage/digestif">digestif</a> is a toolbox providing
many implementations of hash algorithms such as:</p>
<ul>
<li>MD5</li>
<li>SHA1</li>
<li>SHA224</li>
<li>SHA256</li>
<li>SHA384</li>
<li>SHA512</li>
<li>BLAKE2B</li>
<li>BLAKE2S</li>
<li>RIPEMD160</li>
</ul>
<p>Like <code>checkseum</code>, <code>digestif</code> uses the linking trick too: from a
shared interface, it provides 2 implementations, in C (<code>digestif.c</code>)
and OCaml (<code>digestif.ocaml</code>).</p>
<p>Regarding Git, we use the SHA1 implementation and we are ready to
migrate <code>ocaml-git</code> to BLAKE2{B,S} as the Git core team expects - and,
in the OCaml world, it is just a <em>functor</em> application with
another implementation.</p>
<h3 id="eqaf" style="position:relative;"><a href="#eqaf" aria-label="eqaf permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a><code>eqaf</code></h3>
<p>Some applications require that secret values are compared in constant
time. Functions like <code>String.equal</code> do not have this property, so we
have decided to provide a small package — <a href="https://github.com/mirage/eqaf">eqaf</a> —
providing a <em>constant-time</em> <code>equal</code> function.
<code>digestif</code> uses it to check equality of hashes — it also exposes
<code>unsafe_compare</code> if you don't care about timing attacks in your application.</p>
<p>Of course, the biggest work on this package is not about the
implementation of the <code>equal</code> function but a way to check the
constant-time assumption on this function. Using this, we did a
<a href="https://github.com/mirage/eqaf/tree/master/test">benchmark</a> on Linux,
Windows and Mac to check it.</p>
<p>An interesting fact is that after various experiments, we replaced the
initial implementation in C (extracted from OpenBSD's <a href="https://man.openbsd.org/timingsafe_bcmp.3">timingsafe_memcmp</a>) with an OCaml
implementation behaving in a much more predictable way on all the
tested platforms.</p>
<h2 id="conclusion" style="position:relative;"><a href="#conclusion" aria-label="conclusion permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Conclusion</h2>
<p>The upcoming version 2.0 of <a href="https://irmin.org">Irmin</a> is using ocaml-git
to create small applications that <a href="https://github.com/mirage/irmin/blob/master/examples/push.ml">push and pull their state
to GitHub</a>.
We think that Git offers a very nice model to persist data for distributed
applications and we hope that more people will use ocaml-git to experiment
and manipulate application data in Git. Please
<a href="https://github.com/mirage/ocaml-git/issues">send us</a> your feedback!</p>|js}
  };
 
  { title = {js|OCamlFormat 0.8|js}
  ; slug = {js|ocamlformat-08|js}
  ; description = Some {js|We are proud to announce the release of OCamlFormat 0.8 (available on opam). To ease the transition from the previous 0.7 release here are…|js}
  ; url = {js|https://tarides.com/blog/2018-10-17-ocamlformat-0-8|js}
  ; date = {js|2018-10-17T00:00:00-00:00|js}
  ; preview_image = Some {js|https://tarides.com/static/9b70dfbba6abba837b47f644a75b33dc/2244e/code_black1.jpg|js}
  ; body_html = {js|<p>We are proud to announce the release of OCamlFormat 0.8 (available on opam). To ease the transition from the previous 0.7 release here are some highlights of the new features of this release. The <a href="https://github.com/ocaml-ppx/ocamlformat/blob/v0.8/CHANGES.md#08-2018-10-09">full changelog</a> is available on the project repository.</p>
<h1 id="precedence-of-options" style="position:relative;"><a href="#precedence-of-options" aria-label="precedence of options permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Precedence of options</h1>
<p>In the previous version you could override command line options with <code>.ocamlformat</code> files configuration. 0.8 fixed this so that the OCamlFormat configuration is first established by reading <code>.ocamlformat</code> and <code>.ocp-indent</code> files:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">margin = 77
wrap-comments = true</code></pre></div>
<p>By default, these files in current and all ancestor directories for each input file are used, as well as the global configuration defined in <code>$XDG_CONFIG_HOME/ocamlformat</code>. The global <code>$XDG_CONFIG_HOME/ocamlformat</code> configuration has the lowest priority, then the closer the directory is to the processed file, the higher the priority. In each directory, both <code>.ocamlformat</code> and <code>.ocp-indent</code> files are read, with <code>.ocamlformat</code> files having the higher priority.</p>
<p>For now <code>ocp-indent</code> options support is very partial and is expected to be extended in the future.</p>
<p>Then the parameters can be overriden with the <code>OCAMLFORMAT</code> environment variable:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">OCAMLFORMAT=field-space=tight,type-decl=compact</code></pre></div>
<p>and finally the parameters can be overriden again with the command lines parameters.</p>
<h1 id="reading-input-from-stdin" style="position:relative;"><a href="#reading-input-from-stdin" aria-label="reading input from stdin permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Reading input from stdin</h1>
<p>It is now possible to read the input from stdin instead of OCaml files. The following command invokes OCamlFormat that reads its input from the pipe:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">echo &quot;let f x = x + 1&quot; | ocamlformat --name a.ml -</code></pre></div>
<p>The <code>-</code> on the command line indicates that <code>ocamlformat</code> should read from stdin instead of expecting input files. It is then necessary to use the <code>--name</code> option to designate the input (<code>a.ml</code> here).</p>
<h1 id="preset-profiles" style="position:relative;"><a href="#preset-profiles" aria-label="preset profiles permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Preset profiles</h1>
<p>Preset profiles allow you to have a consistent configuration without needing to tune every option.</p>
<p>Preset profiles set all options, overriding lower priority configuration. A preset profile can be set using the <code>--profile</code> (or <code>-p</code>) option. You can pass the option <code>--profile=&#x3C;name></code> on the command line or add <code>profile = &#x3C;name></code> in an <code>.ocamlformat</code> configuration file.</p>
<p>The available profiles are:</p>
<ul>
<li><code>default</code> sets each option to its default value</li>
<li><code>compact</code> sets options for a generally compact code style</li>
<li><code>sparse</code> sets options for a generally sparse code style</li>
<li><code>janestreet</code> is the profile used at JaneStreet</li>
</ul>
<p>To get a better feel of it, here is the formatting of the <a href="https://github.com/ocaml/ocaml/blob/trunk/typing/env.ml#L227-L234"><code>mk_callback</code></a> function from the OCaml compiler with the <code>compact</code> profile:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">let mk_callback rest name desc = function
  | None -&gt; nothing
  | Some f -&gt; (
      fun () -&gt;
        match rest with
        | [] -&gt; f name None
        | (hidden, _) :: _ -&gt; f name (Some (desc, hidden)) )</code></pre></div>
<p>then the same function formatted with the <code>sparse</code> profile:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">let mk_callback rest name desc = function
  | None -&gt;
      nothing
  | Some f -&gt;
      fun () -&gt;
        ( match rest with
        | [] -&gt;
            f name None
        | (hidden, _) :: _ -&gt;
            f name (Some (desc, hidden)) )</code></pre></div>
<h1 id="project-root" style="position:relative;"><a href="#project-root" aria-label="project root permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Project root</h1>
<p>The project root of an input file is taken to be the nearest ancestor directory that contains a <code>.git</code> or <code>.hg</code> or <code>dune-project</code> file.
If the new option <code>--disable-outside-detected-project</code> is set, <code>.ocamlformat</code> configuration files are not read outside of the current project. If no configuration file is found, formatting is disabled.</p>
<p>A new option, <code>--root</code> allows to specify the root directory for a project. If specified, OCamlFormat only takes into account <code>.ocamlformat</code> configuration files inside the root directory and its subdirectories.</p>
<h1 id="credits" style="position:relative;"><a href="#credits" aria-label="credits permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Credits</h1>
<p>This release also contains many other changes and bug fixes that we cannot detail here. Check out the <a href="https://github.com/ocaml-ppx/ocamlformat/blob/v0.8/CHANGES.md#08-2018-10-09">full changelog</a>.</p>
<p>Special thanks to our maintainers and contributors for this release: David Allsopp, Josh Berdine, Hugo Heuzard, Brandon Kase, Anil Madhavapeddy and Guillaume Petiot.</p>|js}
  };
 
  { title = {js|On the road to Irmin v2|js}
  ; slug = {js|on-the-road-to-irmin-v2|js}
  ; description = Some {js|Over the past few months, we have been heavily engaged in release
engineering the Irmin 2.0 release,
which covers multiple years of work on…|js}
  ; url = {js|https://tarides.com/blog/2019-05-13-on-the-road-to-irmin-v2|js}
  ; date = {js|2019-05-13T00:00:00-00:00|js}
  ; preview_image = Some {js|https://tarides.com/static/76876b69b77bdec1f25009b2ef2a6d33/2244e/tree_canopy2.jpg|js}
  ; body_html = {js|<p>Over the past few months, we have been heavily engaged in release
engineering the <a href="https://github.com/mirage/irmin/issues/658">Irmin 2.0 release</a>,
which covers multiple years of work on all of its constituent
elements. We first began Irmin in late 2013 to act as a
<a href="https://mirage.io/blog/introducing-irmin">Git-like distributed and branchable storage substrate</a>
that would let us escape the <a href="https://www.cl.cam.ac.uk/~pes20/SOSP15-paper102-submitted.pdf">perils of POSIX filesystems</a>.</p>
<p>The Irmin libraries provide snapshotting, branching and merging
operations over storage and can communicate via Git both on-disk and
remotely. Irmin today therefore consists of many discrete OCaml
libraries that compose together to form a set of <a href="https://blog.acolyer.org/2015/01/14/mergeable-persistent-data-structures/">mergeable data structures</a>
that can be used in MirageOS unikernels and normal OCaml daemons such
as <a href="http://tezos.com">Tezos</a>.</p>
<p>In this blog post, we wanted to explain some of the release
engineering ongoing, and to highlight some areas where we could use
help from the community to test out pieces (and hopefully find your
own uses in your own infrastructure for it).  The overall effort is
tracked in <a href="https://github.com/mirage/irmin/issues/658">mirage/irmin#658</a>, so
feel free to comment on there as well.</p>
<h3 id="ocaml-git" style="position:relative;"><a href="#ocaml-git" aria-label="ocaml git permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>ocaml-git</h3>
<p>Irmin is parameterised over the exact communication mechanisms it uses
between nodes, both as an on-disk format and also the remoting
protocol.  The most important concrete implementation is Git, which
has turned into the world’s most popular version control system.  In
order to seamlessly integrate with Irmin, we embarked on an effort to
build a complete re-implementation of
<a href="https://github.com/mirage/ocaml-git">Git from scratch in pure OCaml</a>.</p>
<p>You can read <a href="https://tarides.com/blog/2018-10-19-ocaml-git-2-0.html">details of the git 2.0 release</a>
on this blog, but from a release engineering perspective we have steadily
been fixing corner cases in this implementation.  The development
ocaml-git trees feature <a href="https://github.com/mirage/ocaml-git/pull/348">fixes to https+git</a>,
for <a href="https://github.com/mirage/ocaml-git/pull/351">listing remotes</a>, supporting
<a href="https://github.com/mirage/ocaml-git/pull/341">authenticated URIs</a> and
more.</p>
<p>These fixes are possible because users tried end-to-end usecases that
found these corner cases, so we’d really like to see more.  For
example, our friends at <a href="https://robur.io">Robur</a> have submitted fixes
from their integration of it into their upcoming <a href="https://github.com/roburio/caldav">CalDAV engine</a>.
The Mirage <a href="https://github.com/Engil/Canopy">canopy</a> blog engine can now also
push/pull reliably from pure MirageOS unikernels between nodes, which
is a huge step.</p>
<p>If you get a chance to try ocaml-git in your infrastructure, please
let us know how you get along as we prepare a release of the git
libraries with all these fixes (which will be used in Irmin 2.0).</p>
<h3 id="wodan" style="position:relative;"><a href="#wodan" aria-label="wodan permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Wodan</h3>
<p>Irmin’s storage layer is also well abstracted, so backends other than
a Unix filesystem or Git are supported.  Irmin can run in highly
diverse and OS-free environments, and so we began engineering the
<a href="https://github.com/mirage/wodan">Wodan filesystem</a> as a
domain-specific filesystem designed for MirageOS, Irmin and modern
flash drives.  See <a href="https://g2p.github.io/research/wodan.pdf">the OCaml Workshop 2017 abstract on
it</a> for more design
rationale)</p>
<p>As part of the Irmin 2.0 release, Wodan is also being prepared for a
release, and you can find <a href="https://github.com/mirage/wodan/tree/master/src/wodan-irmin">Irmin 2.0
support</a>
in the source.  If you’d like a standalone block-device based
persistence environment for Irmin, please try this out.  This is the
preferred backend for using Irmin storage in a unikernel.</p>
<h3 id="tezos-and-irmin-pack" style="position:relative;"><a href="#tezos-and-irmin-pack" aria-label="tezos and irmin pack permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Tezos and irmin-pack</h3>
<p>Another big user of Irmin is the <a href="https://tezos.com">Tezos blockchain</a>,
and we have been optimising the persistent space usage of Irmin as their
network grows.  Because Tezos doesn’t require full Git format support,
we created a hybrid backend that grabs the best bits of Git (e.g. the
packfile mechanism) and engineered a domain-specific backend tailored
for Tezos usage. Crucially, because of the way Irmin is split into
clean libraries and OCaml modules, we only had to modify a small part
of the codebase and could also re-use elements of the Git 2.0
engineering effort we described above.</p>
<p>The <a href="https://github.com/mirage/irmin/pull/615">irmin-pack backend</a> is
currently being reviewed and integrated ahead of Irmin 2.0 to provide
a significant improvement in disk usage -- more information to come soon.
There is a corresponding <a href="https://gitlab.com/samoht/tezos/tree/snapshot-irmin-pack">Tezos branch</a>
using the Irmin 2.0 code that will be integrated downstream in Tezos
once we complete the Irmin 2.0 tests.</p>
<h3 id="irmin-graphql-and-browser-irmin" style="position:relative;"><a href="#irmin-graphql-and-browser-irmin" aria-label="irmin graphql and browser irmin permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Irmin-GraphQL and “browser Irmin”</h3>
<p>Another new area of huge interest to us is
<a href="https://graphql.org">GraphQL</a> in order to provide frontends a rich
query language for Irmin hosted applications.  Irmin 2.0 includes a
builtin GraphQL server so you can <a href="https://twitter.com/cuvius/status/1017136581755457539">manipulate your Git repo via
GraphQL</a>.</p>
<p>If you are interested in (for example) compiling elements of Irmin to
JavaScript or wasm, for usage in frontends, then the Irmin 2.0 release
makes it significantly easier to support this architecture.  We’ve
already seen some exploratory efforts <a href="https://github.com/mirage/irmin/issues/681">report issues</a>
when doing this, and we’ve had it working ourselves in <a href="http://roscidus.com/blog/blog/2015/04/28/cuekeeper-gitting-things-done-in-the-browser/">Irmin 1.0 Cuekeeper</a>
so we are excited by the potential power of applications built using
this model.  If you have ideas/questions, please get in touch on the
<a href="https://github.com/mirage/irmin/issues">issue tracker</a> with your
usecase.</p>
<p>This post is just the precursor to the Irmin 2.0 release, so expect to
hear more about it in the coming weeks and months.  This is primarily
a call for help from early adopters interested in helping the project
out.  All of our code is liberally licensed open source, and so this
is a good time to tie together end-to-end usecases and help ensure we
don’t make any decisions in Irmin 2.0 that go counter to some product
you’d like to build. That’s only possible with your feedback, so
either get in touch via the <a href="https://github.com/mirage/irmin/issues">issue tracker</a>, on
<a href="https://discuss.ocaml.org">discuss.ocaml.org</a> via the <code>mirageos</code> tag,
or just <a href="mailto:mirageos-devel@lists.xenproject.org">email us</a>.</p>
<p>A huge thank you to all our commercial customers, end users and open
source developers who have contributed their time, expertise and
financial support to help us achieve our goal of delivering a modern
storage stack in the spirit of Git. We look forward to getting Irmin
2.0 into your hands very soon!</p>|js}
  };
 
  { title = {js|Recent and upcoming changes to Merlin|js}
  ; slug = {js|recent-and-upcoming-changes-to-merlin|js}
  ; description = Some {js|Merlin is a language server for the OCaml programming language; that is, a daemon
that connects to your favourite text editor and provides…|js}
  ; url = {js|https://tarides.com/blog/2021-01-26-recent-and-upcoming-changes-to-merlin|js}
  ; date = {js|2021-01-26T00:00:00-00:00|js}
  ; preview_image = Some {js|https://tarides.com/static/1d86af9747be51519d2c89b476b5b306/2244e/camelgicien.jpg|js}
  ; body_html = {js|<p>Merlin is a language server for the OCaml programming language; that is, a daemon
that connects to your favourite text editor and provides the usual services of
an IDE: instant feedback on warnings and errors, autocompletion, "type of the
code under the cursor", "go to definition", etc. As we (Frédéric Bour, Ulysse
Gérard and I) are about to do a new major release, we thought now would be a
good time to talk a bit about some of the changes that are going into this
release.</p>
<h2 id="project-configuration" style="position:relative;"><a href="#project-configuration" aria-label="project configuration permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Project configuration</h2>
<p>Since its very first release, merlin has been getting information about the
project being worked on through a <code>.merlin</code> file, which used to be written by
the user, but is now often generated by build systems.</p>
<p>This had the advantage of being fairly simple: Merlin would just look in the
current directory if such a file existed, otherwise it would look in the parent
directories until it found one; and then read it. But there were also some
sore points: the granularity of the configuration is the directory not the file,
and this information is duplicated from the build system configuration (be it
dune, Makefiles, or, back in the days, ocamlbuild).</p>
<p>After years of thinking about it, we've finally decided to make some light
changes to this process. Since version 3.4, when it scans the filesystem Merlin
is now looking for either a <code>.merlin</code> file or a dune (or dune-project) file. And
when it finds one of those, it starts an external process in the directory where
that file lives, and asks that process for the configuration of the ml(i) file
being edited.</p>
<p>The process in charge of communicating the configuration to Merlin will either
be a specific dune subcommand (when a dune file is found), or a dedicated
<code>.merlin</code> reader program.</p>
<p>We see several advantages in doing things this way (rather than, for instance,
changing the format of <code>.merlin</code> files):</p>
<ol>
<li>this change is entirely backward compatible, and indeed the transition has
already happened silently; although dune is still emitting <code>.merlin</code> files,
this will only stop with dune 2.8.</li>
<li>externalizing the reading of <code>.merlin</code> files and simply requiring a
"normalized" version of the config (i.e. with no mention of packages, just of
flags and paths) allowed us to simplify the internals of Merlin.</li>
<li>talking to the build system directly not only gets us a much finer grained
configuration (which is important when you build different executables with
different flags in the same directory, or if you apply different ppxes to
different files of a library), it opens the door to getting a nicer behavior
of Merlin in some circumstances. For instance, the build system can (and
does) tell Merlin when the project isn't built. Currently we only report that
information to the user when he asks for errors, alongside all the other
(mostly rubbish) errors. Which is already helpful in itself. But in the
future we can start filtering the other errors to only report those that
would remain even after building the project (e.g. parse errors).</li>
</ol>
<p>There are however some changes to look out for:</p>
<ul>
<li>people who still use <code>.merlin</code> files but do not install Merlin using opam need
to make sure to also have the <code>dot-merlin-reader</code> binary in their PATH (it is
available as an opam package, but is also buildable from Merlin's git
repository)</li>
<li>vim and emacs users who could previously load packages interactively (by
calling <code>M-x merlin-use</code> or <code>:MerlinUse</code>) cannot do that anymore, since Merlin
itself stopped linking with findlib. They'll have to write a <code>.merlin</code> file.</li>
</ul>
<h2 id="dropping-support-for-old-versions-of-ocaml" style="position:relative;"><a href="#dropping-support-for-old-versions-of-ocaml" aria-label="dropping support for old versions of ocaml permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Dropping support for old versions of OCaml</h2>
<p>Until now, every release of Merlin has kept support from OCaml 4.02 to the
latest version of OCaml available at the time of that release.</p>
<p>We have done this by having one version of "<em>the frontend</em>" (i.e. handling of
buffer state, project configuration; analyses like <em>jump-to-definition</em>,
<em>prefix-completion</em>, etc.), but several versions of "<em>the backend</em>" (OCaml's
ASTs, parser and typechecker), and choosing at build time which one to use.
The reason for doing this instead of having, for instance, one branch of Merlin
per version of OCaml, is that while the backends are fairly stable once
released, Merlin's frontend keeps evolving. Having just one version of it makes
it easier to add features and fix bugs (patches don't need to be duplicated),
whilst ensuring that Merlin's behavior is consistent across every version of
OCaml that we support.</p>
<p>For this to work however, one needs a well defined API between the frontend and
all the versions of the backend. This implies mapping every versions of OCaml's
internal ASTs (which receive modifications from one version to the next), to a
unified one, so as to keep Merlin's various features version agnostic. But it
also means being resilient to OCaml's internal API changes. For instance between
4.02 and 4.11 there were big refactorings impacting: the way one accesses the
typing environment, the way one accesses the "load path" (the part of the file
system the compiler/Merlin is aware of), the way error message are produced, ...</p>
<p>The rate of changes on the compiler is a lot higher than what it was when we
first started Merlin (7 years ago now!) which doesn't just mean that we have to
spend more and more time on updating the common interface, but also that the
interface is getting harder to define. Recently (with the 4.11 release) some of
the changes were significant enough that for some parts of the backend we just
didn't manage to produce a single interface to access old and new versions, so
instead we had to start duplicating and specializing parts of the frontend.
And we don't expect things to get much better in the near future.</p>
<p>Furthermore, Merlin's backends are patched to be more resilient to parsing and
typing errors in the user's code. Those patches also need to be evolved at each
new release of the compiler.
The work required to keep the "unified interface" working was taking time away
from updating our patches properly, and our support of user errors has slowly
been getting worse over the past few years, resulting in less precise type
information when asked, incomplete results when asking for auto-completion, etc.</p>
<p>Therefore we have decided to stop dragging older versions of OCaml along. We
plan to switch to a system where we have one branch of Merlin per version of
OCaml, and each opam release of Merlin will only be buildable with one version
of OCaml. We will keep maintaining all the relatively recent branches (that is:
4.02 definitely will not get fixes, but 4.06 is still in the clear). However,
all the new features will be developed against the latest version of OCaml and
cherry-picked to older branches if, and only if, there are no merge conflicts
and they work as expected without changes.</p>
<p>We hope that this will make it easier for us to update to new versions of OCaml
(actually, we already know it does, working on adding support for 4.12 was
easier than for any of the other recent versions), will allow us to clean up
Merlin's codebase (let's call that a work in progress), and will free some time
to work on new features.</p>
<p>You might wonder what all this changes for you, as a user, in practice. Well, it
depends:</p>
<ul>
<li>if you install Merlin from opam: nothing, or almost nothing. Everything that
you currently do with Merlin will keep working. In the future, perhaps some
new feature will appear that won't work on all versions. But that day hasn't
come yet.</li>
<li>if you install Merlin some other way (manually?): you can't just fetch master
and build it anymore. You have to pick the appropriate branch for your
version of OCaml.</li>
<li>if you're reusing Merlin's codebase as part of another project and (even
worse) have patches on it: come and talk to us if you haven't done so already!
We can try and integrate your patches, so that you only need to worry about
vendoring the right version(s) for your needs.</li>
</ul>
<hr>
<p>Over the years, Merlin has received bugfixes and improvements from a long list of
people, but for the upcoming release Frédéric and I are particularly grateful to
Rudi Grinberg, a long time and regular contributor who also maintains the OCaml
LSP project, as well as Ulysse Gérard, who joined our team a year ago now. They
are in particular the main authors of the work to improve the handling of
projects' configuration.</p>
<p>We hope you'll be as excited as us by all these changes!</p>|js}
  };
 
  { title = {js|Release of Base64|js}
  ; slug = {js|release-of-base64|js}
  ; description = Some {js|MirageOS is a library operating system written from the ground up in OCaml.
It has an impossible and incredibly huge goal to re-implement…|js}
  ; url = {js|https://tarides.com/blog/2019-02-08-release-of-base64|js}
  ; date = {js|2019-02-08T00:00:00-00:00|js}
  ; preview_image = Some {js|https://tarides.com/static/50a0344945c9df2a67b60ef32ee43a0f/2244e/mailboxes.jpg|js}
  ; body_html = {js|<p>MirageOS is a library operating system written from the ground up in OCaml.
It has an impossible and incredibly huge goal to re-implement all of the
world! Looking back at the work accomplished by the MirageOS team, it appears that's
what happened for several years. Re-implementing the entire stack, in particular
the lower layers that we often take for granted, requires a great attention to
detail. While it may seem reasonably easy to implement a given RFC, a huge
amount of work is often hidden under the surface.</p>
<p>In this article, we will explain the development process we went through, as we
updated a small part of the MirageOS stack: the library <code>ocaml-base64</code>. It's a
suitable example as the library is small (few hundreds lines of code), but it
needs ongoing development to ensure good quality and to be able to trust it for
higher level libraries (like <a href="https://github.com/mirage/mrmime">mrmime</a>).</p>
<p>Updating the library was instigated by a problem I ran into with the existing
base64 implementation while working on the e-mail stack. Indeed, we got some
errors when we tried to compute an <em>encoded-word</em> according to the <a href="https://www.ietf.org/rfc/rfc2047.txt">RFC
2047</a>. So after several years of not being touched, we decided to
update <a href="https://github.com/mirage/ocaml-base64"><code>ocaml-base64</code></a>.</p>
<h1 id="the-critique-of-pure-reason" style="position:relative;"><a href="#the-critique-of-pure-reason" aria-label="the critique of pure reason permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>The Critique of Pure Reason</h1>
<h2 id="the-first-problem" style="position:relative;"><a href="#the-first-problem" aria-label="the first problem permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>The first problem</h2>
<p>We started by attempting to use <code>ocaml-base64</code> on some examples extracted from
actual e-mails, and we quickly ran into cases where the library failed. This
highlighted that reality is much more complex than you can imagine from reading
an RFC. In this situation, what do you do: try to implement a best-effort
strategy and continue parsing? Or stick to the letter of the RFC and fail? In
the context of e-mails, which has accumulated a lot of baggage over time, you
cannot get around implementing a best-effort strategy.</p>
<p>The particular error we were seeing was a <code>Not_found</code> exception when decoding an
<em>encoded-word</em>. This exception appeared because the implementation relied on
<code>String.contains</code>, and the input contained a character which was not part of the
base64 alphabet.</p>
<p>This was the first reason why we thought it necessary to rewrite <code>ocaml-base64</code>.
Of course, we could just catch the exception and continue the initial
computation, but then another reason appeared.</p>
<h2 id="the-second-problem" style="position:relative;"><a href="#the-second-problem" aria-label="the second problem permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>The second problem</h2>
<p>As <a href="https://github.com/clecat">@clecat</a> and I reviewed RFC 2045, we noticed the
following requirement:</p>
<blockquote>
<p>The encoded output stream must be represented in lines of no more than 76
characters each.</p>
<p>See RFC 2045, section 6.8</p>
</blockquote>
<p>Pretty specific, but general to e-mails, we should never have more than 78
characters per line according to <a href="https://www.ietf.org/rfc/rfc822.txt">RFC 822</a>, nor more than 998 characters
according to <a href="https://www.ietf.org/rfc/rfc2822.txt">RFC 2822</a>.</p>
<p>Having a decoder that abided RFC 2045 more closely, including the requirement
above, further spurred us to implement a new decoder.</p>
<p>As part of the new implementation, we decided to implement tests and fuzzers to
ensure correctness. This also had the benefit, that we could run the fuzzer on
the existing codebase. When fuzzing an encoder/decoder pair, an excellent check
is whether the following isomorphism holds:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> iso0 input <span class="token operator">=</span> <span class="token keyword">assert</span> <span class="token punctuation">(</span>decode <span class="token punctuation">(</span>encode input<span class="token punctuation">)</span> <span class="token operator">=</span> input<span class="token punctuation">)</span>
<span class="token keyword">let</span> iso1 input <span class="token operator">=</span> <span class="token keyword">assert</span> <span class="token punctuation">(</span>encode <span class="token punctuation">(</span>decode input<span class="token punctuation">)</span> <span class="token operator">=</span> input<span class="token punctuation">)</span></code></pre></div>
<p>However, at this point <a href="https://github.com/hannesm">@hannesm</a> ran into another error (see
<a href="https://github.com/mirage/ocaml-base64/issues/20">#20</a>).</p>
<h2 id="the-third-problem" style="position:relative;"><a href="#the-third-problem" aria-label="the third problem permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>The third problem</h2>
<p>We started to review the <a href="https://github.com/mirleft/ocaml-nocrypto"><code>nocrypto</code></a> implementation of base64, which
respects our requirements. We had some concerns about the performance of the
implementation though, so we decided to see if we would get a performance
regression by switching to this implementation.</p>
<p>A quick benchmark based on random input revealed the opposite, however!
<code>nocrypto</code>'s implementation was faster than <code>ocaml-base64</code>:</p>
<div class="gatsby-highlight" data-language="sh"><pre class="language-sh"><code class="language-sh">ocaml-base64&#39;s implementation on bytes (length: 5000): 466 272.34ns
nocrypto&#39;s implementation on bytes (length: 5000): 137 406.04ns</code></pre></div>
<p>Based on all these observations, we thought there was sufficient reason to
reconsider the <code>ocaml-base64</code> implementation. It's also worth mentioning that
the last real release (excluding <code>dune</code>/<code>jbuilder</code>/<code>topkg</code> updates) is from Dec.
24 2014. So, it's pretty old code and the OCaml eco-system has improved a lot
since 2014.</p>
<h1 id="implementation--review" style="position:relative;"><a href="#implementation--review" aria-label="implementation  review permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Implementation &#x26; review</h1>
<p>We started integrating the <code>nocrypto</code> implementation. Of course, implementing
<a href="https://www.ietf.org/rfc/rfc4648.txt">RFC 4648</a> is not as easy as just reading examples and trying to do
something which works. The devil is in the detail.</p>
<p>@hannesm and <a href="https://github.com/cfcs">@cfcs</a> decided to do a big review of expected behavior
according to the RFC, and another about implementation and security issues.</p>
<h2 id="canonicalization" style="position:relative;"><a href="#canonicalization" aria-label="canonicalization permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Canonicalization</h2>
<p>The biggest problem about RFC 4648 is regarding canonical inputs. Indeed, there
are cases where two different inputs are associated with the same value:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> a <span class="token operator">=</span> <span class="token module variable">Base64</span><span class="token punctuation">.</span>decode <span class="token string">"Zm9vCg=="</span> <span class="token punctuation">;</span><span class="token punctuation">;</span>
<span class="token operator">-</span> <span class="token punctuation">:</span> string <span class="token operator">=</span> <span class="token string">"foo\\n"</span>
<span class="token keyword">let</span> b <span class="token operator">=</span> <span class="token module variable">Base64</span><span class="token punctuation">.</span>decode <span class="token string">"Zm9vCh=="</span> <span class="token punctuation">;</span><span class="token punctuation">;</span>
<span class="token operator">-</span> <span class="token punctuation">:</span> string <span class="token operator">=</span> <span class="token string">"foo\\n"</span></code></pre></div>
<p>This is mostly because the base64 format encodes the input 6 bits at a time. The
result is that 4 base64 encoded bytes are equal to 3 decoded bytes (<code>6 * 4 = 8 * 3</code>). Because of this, 2 base64 encoded bytes provide 1 byte plus 4 bits. What do
we need to do with these 4 bits? Nothing.</p>
<p>That's why the last character in our example can be something else than <code>g</code>. <code>g</code>
is the canonical byte to indicate using the 2 bits afterward the 6 bits
delivered by <code>C</code> (and make a byte - 8 bits). But <code>h</code> can be used where we just
need 2 bits at the end.</p>
<p>Due to this behavior, the check used for fuzzing changes: from a canonical
input, we should check isomorphism.</p>
<h2 id="invalid-character" style="position:relative;"><a href="#invalid-character" aria-label="invalid character permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Invalid character</h2>
<p>As mentioned above ("The first problem"), how should invalid characters be
handled? This happens when decoding a byte which is not a part of the base64
alphabet. In the old version, <code>ocaml-base64</code> would simply leak a <code>Not_found</code>
exception from <code>String.contains</code>.</p>
<p>The MirageOS team has taken <a href="https://mirage.io/wiki/mirage-3.0-errors">a stance on exceptions</a>, which is
to "use exceptions for exceptional conditions" - invalid input is hardly one of
those. This is to avoid any exception leaks, as it can be really hard to track
the origin of an exception in a unikernel. Because of this, several packages
have been updated to return a <code>result</code> type instead, and we wanted the new
implementation to follow suit.</p>
<p>On the other hand, exceptions can be useful when considered as a more
constrained form of assembly jump. Of course, they break the control flow, but
from a performance point of view, it's interesting to use this trick:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">exception</span> <span class="token module variable">Found</span>

<span class="token keyword">let</span> contains str chr <span class="token operator">=</span>
  <span class="token keyword">let</span> idx <span class="token operator">=</span> ref <span class="token number">0</span> <span class="token keyword">in</span>
  <span class="token keyword">let</span> len <span class="token operator">=</span> <span class="token module variable">String</span><span class="token punctuation">.</span>length str <span class="token keyword">in</span>
  <span class="token keyword">try</span> <span class="token keyword">while</span> <span class="token operator">!</span>idx <span class="token operator">&lt;</span> len
      <span class="token keyword">do</span> <span class="token keyword">if</span> <span class="token module variable">String</span><span class="token punctuation">.</span>unsafe_get str <span class="token operator">!</span>idx <span class="token operator">=</span> chr <span class="token keyword">then</span> raise <span class="token module variable">Found</span> <span class="token punctuation">;</span> incr idx <span class="token keyword">done</span> <span class="token punctuation">;</span>
      <span class="token module variable">None</span>
  <span class="token keyword">with</span> <span class="token module variable">Found</span> <span class="token operator">-></span> <span class="token module variable">Some</span> <span class="token operator">!</span>idx</code></pre></div>
<p>This kind of code for example is ~20% faster than <code>String.contains</code>.</p>
<p>As such, exceptions can be a useful tool for performance optimizations, but we
need to be extra careful not to expose them to the users of the library. This
code needs to be hidden behind a fancy functional interface. With this in mind,
we should assert that our <code>decode</code> function never leaks an exception. We'll
describe how we've adressed this problem later.</p>
<h2 id="special-cases" style="position:relative;"><a href="#special-cases" aria-label="special cases permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Special cases</h2>
<p>RFC 4648 has some detailed cases and while we would sometimes like to work in a
perfect world where we will never need to deal with such errors, from our
experience, we cannot imagine what the end-user will do to formats, protocols
and such.</p>
<p>Even though the RFC has detailed examples, we have to read between lines to know
special cases and how to deal with them.</p>
<p>@hannesm noticed one of these cases, where padding (<code>=</code> sign at the end of
input) is not mandatory:</p>
<blockquote>
<p>The pad character "=" is typically percent-encoded when used in an URI [9],
but if the data length is known implicitly, this can be avoided by skipping
the padding; see section 3.2.</p>
<p>See RFC 4648, section 5</p>
</blockquote>
<p>That mostly means that the following kind of input can be valid:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> a <span class="token operator">=</span> <span class="token module variable">Base64</span><span class="token punctuation">.</span>decode <span class="token label function">~pad</span><span class="token punctuation">:</span><span class="token boolean">false</span> <span class="token string">"Zm9vCg"</span>
<span class="token operator">-</span> <span class="token punctuation">:</span> string <span class="token operator">=</span> <span class="token string">"foo\\n"</span></code></pre></div>
<p>It's only valid in a specific context though: when <em>length is known implicitly</em>.
Only the caller of <code>decode</code> can determine whether the length is implicitly known
such that padding can be omitted. To that end, we've added a new optional
argument <code>?pad</code> to the function <code>Base64.decode</code>.</p>
<h2 id="allocation-sub-off-and-len" style="position:relative;"><a href="#allocation-sub-off-and-len" aria-label="allocation sub off and len permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Allocation, <code>sub</code>, <code>?off</code> and <code>?len</code></h2>
<p>Xavier Leroy has described the garbage collector in the following way:</p>
<blockquote>
<p>You see, the Caml garbage collector is like a god from ancient mythology:
mighty, but very irritable. If you mess with it, it'll make you suffer in
surprising ways.</p>
</blockquote>
<p>That's probably why my experience with improving the allocation policy of
(<code>ocaml-git</code>)<a href="https://github.com/mirage/ocaml-git">ocaml-git</a> was quite a nightmare. Allowing the user to control
allocation is important for efficiency, and we wanted to <code>ocaml-base64</code> to be a
good citizen.</p>
<p>At the beginning, <code>ocaml-base64</code> had a very simple API:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">val</span> decode <span class="token punctuation">:</span> string <span class="token operator">-></span> string
<span class="token keyword">val</span> encode <span class="token punctuation">:</span> string <span class="token operator">-></span> string</code></pre></div>
<p>This API forces allocations in two ways.</p>
<p>Firstly, if the caller needs to encode a part of a string, this part needs to be
extracted, e.g. using <code>String.sub</code>, which will allocate a new string. To avoid
this, two new optional arguments have been added to <code>encode</code>: <code>?off</code> and <code>?len</code>,
which specifies the substring to encode. Here's an example:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token comment">(* We want to encode the part 'foo' without prefix or suffix *)</span>

<span class="token comment">(* Old API -- forces allocation *)</span>
<span class="token module variable">Base64</span><span class="token punctuation">.</span>encode <span class="token punctuation">(</span><span class="token module variable">String</span><span class="token punctuation">.</span>sub <span class="token string">"prefix foo suffix"</span> <span class="token number">7</span> <span class="token number">3</span><span class="token punctuation">)</span> <span class="token punctuation">;</span><span class="token punctuation">;</span>
<span class="token operator">-</span> <span class="token punctuation">:</span> string <span class="token operator">=</span> <span class="token string">"Zm9v"</span>

<span class="token comment">(* New API -- avoids allocation *)</span>
<span class="token module variable">Base64</span><span class="token punctuation">.</span>encode <span class="token label function">~off</span><span class="token punctuation">:</span><span class="token number">7</span> <span class="token label function">~len</span><span class="token punctuation">:</span><span class="token number">3</span> <span class="token string">"prefix foo suffix"</span> <span class="token punctuation">;</span><span class="token punctuation">;</span>
<span class="token operator">-</span> <span class="token punctuation">:</span> string <span class="token operator">=</span> <span class="token string">"Zm9v"</span></code></pre></div>
<p>Secondly, a new string is allocated to hold the resulting string. We can
calculate a bound on the length of this string in the following manner:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> <span class="token punctuation">(</span><span class="token operator">//</span><span class="token punctuation">)</span> x y <span class="token operator">=</span>
  <span class="token keyword">if</span> y <span class="token operator">&lt;</span> <span class="token number">1</span> <span class="token keyword">then</span> raise <span class="token module variable">Division_by_zero</span> <span class="token punctuation">;</span>
  <span class="token keyword">if</span> x <span class="token operator">></span> <span class="token number">0</span> <span class="token keyword">then</span> <span class="token number">1</span> <span class="token operator">+</span> <span class="token punctuation">(</span><span class="token punctuation">(</span>x <span class="token operator">-</span> <span class="token number">1</span><span class="token punctuation">)</span> <span class="token operator">/</span> y<span class="token punctuation">)</span> <span class="token keyword">else</span> <span class="token number">0</span>

<span class="token keyword">let</span> encode input <span class="token operator">=</span>
  <span class="token keyword">let</span> res <span class="token operator">=</span> <span class="token module variable">Bytes</span><span class="token punctuation">.</span>create <span class="token punctuation">(</span><span class="token module variable">String</span><span class="token punctuation">.</span>length input <span class="token operator">//</span> <span class="token number">3</span> <span class="token operator">*</span> <span class="token number">4</span><span class="token punctuation">)</span> <span class="token keyword">in</span>
  <span class="token punctuation">.</span><span class="token punctuation">.</span><span class="token punctuation">.</span>

<span class="token keyword">let</span> decode input <span class="token operator">=</span>
  <span class="token keyword">let</span> res <span class="token operator">=</span> <span class="token module variable">Bytes</span><span class="token punctuation">.</span>create <span class="token punctuation">(</span><span class="token module variable">String</span><span class="token punctuation">.</span>length input <span class="token operator">//</span> <span class="token number">4</span> <span class="token operator">*</span> <span class="token number">3</span><span class="token punctuation">)</span> <span class="token keyword">in</span>
  <span class="token punctuation">.</span><span class="token punctuation">.</span><span class="token punctuation">.</span></code></pre></div>
<p>Unfortunately we cannot know the exact length of the result prior to computing
it. This forces a call to <code>String.sub</code> at the end of the computation to return a
string of the correct length. This means we have two allocations rather than
one. To avoid the additional allocation, [@avsm][avsm] proposed to provide a new
type <code>sub = string * int * int</code>. This lets the user call <code>String.sub</code> if
required (and allocate a new string), or use simply use the returned <code>sub</code> for
<em>blit</em>ting to another buffer or similar.</p>
<h1 id="fuzz-everything" style="position:relative;"><a href="#fuzz-everything" aria-label="fuzz everything permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Fuzz everything!</h1>
<p>There's a strong trend of fuzzing libraries for MirageOS, which is quite easy
thanks to the brilliant work by <a href="https://github.com/yomimono">@yomimono</a> and <a href="https://github.com/stedolan">@stedolan</a>!
The integrated fuzzing in OCaml builds on <a href="http://lcamtuf.coredump.cx/afl/">American fuzzy lop</a>, which is
very smart about discarding paths of execution that have already been tested and
generating unseen inputs which break your assumptions. My first experience with
fuzzing was with the library <a href="https://github.com/mirage/decompress"><code>decompress</code></a>, and I was impressed by
<a href="https://github.com/mirage/decompress/pull/34">precise error</a> it found about a name clash.</p>
<p>Earlier in this article, I listed some properties we wanted to check for
<code>ocaml-base64</code>:</p>
<ul>
<li>The functions <code>encode</code> and <code>decode</code> should be be isomorphic taking
canonicalization into account:</li>
</ul>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> iso0 input <span class="token operator">=</span>
  <span class="token keyword">match</span> <span class="token module variable">Base64</span><span class="token punctuation">.</span>decode <span class="token label function">~pad</span><span class="token punctuation">:</span><span class="token boolean">false</span> input <span class="token keyword">with</span>
  <span class="token operator">|</span> <span class="token module variable">Error</span> <span class="token punctuation">_</span> <span class="token operator">-></span> fail <span class="token punctuation">(</span><span class="token punctuation">)</span>
  <span class="token operator">|</span> <span class="token module variable">Ok</span> result0 <span class="token operator">-></span>
    <span class="token keyword">let</span> result1 <span class="token operator">=</span> <span class="token module variable">Base64</span><span class="token punctuation">.</span>encode_exn result0 <span class="token keyword">in</span>
    <span class="token keyword">match</span> <span class="token module variable">Base64</span><span class="token punctuation">.</span>decode <span class="token label function">~pad</span><span class="token punctuation">:</span><span class="token boolean">true</span> result1 <span class="token keyword">with</span>
    <span class="token operator">|</span> <span class="token module variable">Error</span> <span class="token punctuation">_</span> <span class="token operator">-></span> fail <span class="token punctuation">(</span><span class="token punctuation">)</span>
    <span class="token operator">|</span> <span class="token module variable">Ok</span> result2 <span class="token operator">-></span> check_eq result0 result2

<span class="token keyword">let</span> iso1 input <span class="token operator">=</span>
  <span class="token keyword">let</span> result <span class="token operator">=</span> <span class="token module variable">Base64</span><span class="token punctuation">.</span>encode_exn input <span class="token keyword">in</span>
  <span class="token keyword">match</span> <span class="token module variable">Base64</span><span class="token punctuation">.</span>decode <span class="token label function">~pad</span><span class="token punctuation">:</span><span class="token boolean">true</span> result0 <span class="token keyword">with</span>
  <span class="token operator">|</span> <span class="token module variable">Error</span> <span class="token punctuation">_</span> <span class="token operator">-></span> fail <span class="token punctuation">(</span><span class="token punctuation">)</span>
  <span class="token operator">|</span> <span class="token module variable">Ok</span> result1 <span class="token operator">-></span>
    <span class="token keyword">let</span> result2 <span class="token operator">=</span> <span class="token module variable">Base64</span><span class="token punctuation">.</span>encode_exn result1 <span class="token keyword">in</span>
    check_eq result0 result2</code></pre></div>
<ul>
<li>The function <code>decode</code> should <em>never</em> raise an exception, but rather return a
result type:</li>
</ul>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> no_exn input <span class="token operator">=</span>
  <span class="token keyword">try</span> ignore <span class="token operator">@@</span> <span class="token module variable">Base64</span><span class="token punctuation">.</span>decode input <span class="token keyword">with</span> <span class="token punctuation">_</span> <span class="token operator">-></span> fail <span class="token punctuation">(</span><span class="token punctuation">)</span></code></pre></div>
<ul>
<li>And finally, we should randomize <code>?off</code> and <code>?len</code> arguments to ensure that we
don't get an <code>Out_of_bounds</code> exception when accessing input.</li>
</ul>
<p>Just because we've applied fuzzing to the new implementation for a long time, it
doesn't mean that the code is completely infallible. People can use our library
in an unimaginable way (and it's mostly what happens in the real world) and get
an unknowable error.</p>
<p>But, with the fuzzer, we've managed to test some properties across a very wide
range of input instead of unit testing with random (or not so random) inputs
from our brains. This development process allows <em>fixing the semantics</em> of
implementations (even if it's <strong>not</strong> a formal definition of semantics), but
it's better than nothing or outdated documentation.</p>
<h1 id="conclusion" style="position:relative;"><a href="#conclusion" aria-label="conclusion permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Conclusion</h1>
<p>Based on our recent update to <code>ocaml-base64</code>, this blog post explains our
development process as go about rewriting the world to MirageOS, one bit at a
time. There's an important point to be made though:</p>
<p><code>ocaml-base64</code> is a small project. Currently, the implementation is about 250
lines of code. So it's a really small project. But as stated in the
introduction, we are fortunate enough to push the restart button of the computer
world - yes, we want to make a new operating system.</p>
<p>That's a massive task, and we shouldn't make it any harder on ourselves than
necessary. As such, we need to justify any step, any line of code, and why we
decided to spend our time on any change (why we decided to re-implement <code>git</code>
for example). So before committing any time to projects, we try to do a deep
analysis of the problem, get feedback from others, and find a consensus between
what we already know, what we want and what we should have (in the case of
<code>ocaml-base64</code>, @hannesm did a look on the PHP implementation and the Go
implementation).</p>
<p>Indeed, this is a hard question which nobody can answer perfectly in isolation.
So, the story of this update to <code>ocaml-base64</code> is an invitation for you to enter
the arcanas of the computer world through MirageOS :) ! Don't be afraid!</p>|js}
  };
 
  { title = {js|Release of OCamlFormat 0.10|js}
  ; slug = {js|release-of-ocamlformat-010|js}
  ; description = Some {js|We are pleased to announce the release of OCamlFormat 0.10 (available on opam). There have been numerous changes since the last release, so…|js}
  ; url = {js|https://tarides.com/blog/2019-06-27-release-of-ocamlformat-0-10|js}
  ; date = {js|2019-06-27T00:00:00-00:00|js}
  ; preview_image = Some {js|https://tarides.com/static/dd98e4198ca9305bbbd638c382587e5b/2244e/keyboard.jpg|js}
  ; body_html = {js|<p>We are pleased to announce the release of OCamlFormat 0.10 (available on opam).</p>
<p>There have been numerous changes since the last release, so here is a comprehensive list of the new features and breaking changes to help the transition from OCamlFormat 0.9.</p>
<p><code>ocamlformat-0.10</code> now works on the 4.08 AST, although the formatting should not differ greatly from the one of <code>ocamlformat-0.9</code> in this regard.
Please note that it is necessary to build <code>ocamlformat</code> with 4.08 to be able to parse new features like <code>let*</code>.</p>
<p>Upgrading from <code>ocamlformat-0.9</code> requires to install the following dependencies:</p>
<ul>
<li>ocaml-migrate-parsetree >= 1.3.1 (upgrade)</li>
<li>uuseg >= 10.0.0 (new)</li>
<li>uutf >= 1.0.1 (upgrade)</li>
</ul>
<p>This release focuses on preserving the style of the original source and on handling more <code>ocp-indent</code> options.</p>
<h2 id="style-preservation" style="position:relative;"><a href="#style-preservation" aria-label="style preservation permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Style preservation</h2>
<h3 id="expression-grouping" style="position:relative;"><a href="#expression-grouping" aria-label="expression grouping permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Expression grouping</h3>
<p>The new option <code>exp-grouping</code> has been added to preserve the keywords <code>begin</code>/<code>end</code> that are used to delimit expressions instead of parentheses. <code>exp-grouping=parens</code> always uses parentheses to delimit expressions. <code>exp-grouping=preserve</code> preserves the original grouping syntax (parentheses or <code>begin</code>/<code>end</code>).</p>
<h3 id="horizontal-alignment" style="position:relative;"><a href="#horizontal-alignment" aria-label="horizontal alignment permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Horizontal alignment</h3>
<p>Horizontal alignment is something that users often use to make pattern-matching or type declarations easier to read, and it is a feature that has been requested many times. Three new options have been added to horizontally align the lines.</p>
<p><code>align-cases</code> horizontally aligns the match/try cases:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> fooooooooooo <span class="token operator">=</span>
  <span class="token keyword">match</span> foooooooooooooooooooooooo <span class="token keyword">with</span>
  <span class="token operator">|</span> <span class="token module variable">Bfooooooooooooooooo</span> <span class="token operator">-></span> foooooooooooo
  <span class="token operator">|</span> C <span class="token punctuation">(</span>a<span class="token punctuation">,</span> b<span class="token punctuation">,</span> c<span class="token punctuation">,</span> d<span class="token punctuation">)</span>      <span class="token operator">-></span> fooooooooooooooooooo
  <span class="token operator">|</span> <span class="token punctuation">_</span>                   <span class="token operator">-></span> fooooooooooooooooooo</code></pre></div>
<p><code>align-constructors-decl</code> horizontally aligns type declarations:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">type</span> t <span class="token operator">=</span>
  <span class="token operator">|</span> <span class="token punctuation">(</span> <span class="token punctuation">:</span><span class="token punctuation">:</span> <span class="token punctuation">)</span> <span class="token keyword">of</span> a <span class="token operator">*</span> b
  <span class="token operator">|</span> <span class="token punctuation">[</span><span class="token punctuation">]</span>     <span class="token keyword">of</span> looooooooooooooooooooooooooooooooooooooong_break</code></pre></div>
<p><code>align-variants-decl</code> horizontally aligns variants type declarations:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">type</span> x <span class="token operator">=</span>
  <span class="token punctuation">[</span> <span class="token variant variable">`Foooooooo</span>      <span class="token keyword">of</span> int
  <span class="token operator">|</span> <span class="token variant variable">`Fooooooooooooo</span> <span class="token keyword">of</span> int <span class="token punctuation">]</span></code></pre></div>
<h3 id="preserve-blank-lines-in-sequences" style="position:relative;"><a href="#preserve-blank-lines-in-sequences" aria-label="preserve blank lines in sequences permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Preserve blank lines in sequences</h3>
<p>The new option <code>sequence-blank-line</code> decides whether a blank line is preserved between expressions of a sequence. <code>sequence-blank-line=compact</code> will not keep any blank line between expressions of a sequence, this is still the default behavior. <code>sequence-blank-line=preserve</code> will keep a blank line between two expressions of a sequence if the input contains at least one.</p>
<p>This option can help preserving the readability of the code in this situation:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> foo x y <span class="token operator">=</span>
  do_some_setup y <span class="token punctuation">;</span>

  important_function x</code></pre></div>
<h2 id="supporting-more-ocp-indent-options" style="position:relative;"><a href="#supporting-more-ocp-indent-options" aria-label="supporting more ocp indent options permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Supporting more <code>ocp-indent</code> options</h2>
<p>The long term goal of <code>ocamlformat</code> is to handle every <code>ocp-indent</code> option, this release got closer to this goal as the following <code>ocp-indent</code> options are now supported by <code>ocamlformat</code>:</p>
<ul>
<li>max_indent</li>
<li>with</li>
<li>strict_with</li>
<li>ppx_stritem_ext</li>
<li>base</li>
<li>in</li>
<li>type</li>
</ul>
<h3 id="offset-added-to-a-new-line" style="position:relative;"><a href="#offset-added-to-a-new-line" aria-label="offset added to a new line permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Offset added to a new line</h3>
<p>The new option <code>max-indent</code> sets the maximum offset (number of columns) added to a new line in addition to the offset of the previous line. If this offset is set to 2 columns, then each new line can only be indented by 2 columns more in addition to the previous line, for example:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">=</span>
  fooooo
  <span class="token operator">|></span> <span class="token module variable">List</span><span class="token punctuation">.</span>iter <span class="token punctuation">(</span><span class="token keyword">fun</span> x <span class="token operator">-></span>
    <span class="token keyword">let</span> x <span class="token operator">=</span> x <span class="token operator">$</span> y <span class="token keyword">in</span>
    fooooooooooo x<span class="token punctuation">)</span></code></pre></div>
<p>This option is equivalent to the <code>max_indent</code> option of <code>ocp-indent</code>, and it will be set if <code>max_indent</code> is set in an <code>.ocp-indent</code> configuration file.</p>
<h3 id="indentation-of-pattern-matching-cases" style="position:relative;"><a href="#indentation-of-pattern-matching-cases" aria-label="indentation of pattern matching cases permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Indentation of pattern matching cases</h3>
<p>The new options <code>funtion-indent</code> and <code>match-indent</code> respectively decide the indentation of function cases and the indentation of match/try cases.
These options are equivalent to the <code>with</code> option of <code>ocp-indent</code>, and they will be set if <code>with</code> is set in an <code>ocp-indent</code> configuration file.
If the indentation is set to 4 columns, cases are formatted like this:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> foooooooo <span class="token operator">=</span> <span class="token keyword">function</span>
    <span class="token operator">|</span> fooooooooooooooooooooooo <span class="token operator">-></span> foooooooooooooooooooooooooo

<span class="token keyword">let</span> foooooooo <span class="token operator">=</span>
  <span class="token keyword">match</span> fooooooooooooooooooooooo <span class="token keyword">with</span>
      <span class="token operator">|</span> fooooooooooooooooooooooo <span class="token operator">-></span> foooooooooooooooooooooooooo</code></pre></div>
<p>The new options <code>function-indent-nested</code> and <code>match-indent-nested</code> respectively decide whether the <code>function-indent</code> and the <code>match-indent</code> parameters should be applied even when in a sub-block. If these options are set to <code>never</code>, it only applies <code>function-indent</code> or <code>match-indent</code> if the function or match block starts a line. If these options are set to <code>always</code>, then the indent parameters are always applied. The <code>auto</code> value applies the indentation parameter when seen fit.</p>
<p>These options are equivalent to the <code>strict_with</code> option of <code>ocp-indent</code>, and they will be set if <code>strict_with</code> is set in an <code>ocp-indent</code> configuration file.</p>
<h3 id="indentation-inside-extension-nodes" style="position:relative;"><a href="#indentation-inside-extension-nodes" aria-label="indentation inside extension nodes permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Indentation inside extension nodes</h3>
<p>The new option <code>extension-indent</code> sets the indentation of items (that are not at structure level) inside extension nodes.
The new option <code>stritem-extension-indent</code> sets the indentation of structure items inside extension nodes. This option is equivalent to the <code>ppx_stritem_ext</code> option of <code>ocp-indent</code>, and it will be set if <code>ppx_stritem_ext</code> is set in an <code>.ocp-indent</code> configuration file.</p>
<p>For example if <code>extension-indent</code> is set to 5 and <code>stritem-extension-indent</code> is set to 3:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> foo <span class="token operator">=</span>
  <span class="token punctuation">[</span><span class="token operator">%</span>foooooooooo
       fooooooooooooooooooooooooooo foooooooooooooooooooooooooooooooooo
         foooooooooooooooooooooooooooo<span class="token punctuation">]</span>
  <span class="token punctuation">[</span><span class="token operator">@@</span>foooooooooo
       fooooooooooooooooooooooooooo foooooooooooooooooooooooooooooooooo
         foooooooooooooooooooooooooooo<span class="token punctuation">]</span>

<span class="token punctuation">[</span><span class="token operator">@@@</span>foooooooooo
   fooooooooooooooooooooooooooo foooooooooooooooooooooooooooooooooo
     foooooooooooooooooooooooooooo<span class="token punctuation">]</span></code></pre></div>
<h3 id="let-binding-indentation" style="position:relative;"><a href="#let-binding-indentation" aria-label="let binding indentation permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Let-binding indentation</h3>
<p>The new option <code>let-binding-indent</code> sets the indentation of let binding expressions if they do not fit on a single line. This option is equivalent to the <code>base</code> option of <code>ocp-indent</code>.
The new option <code>indent-after-in</code> sets the indentation after <code>let ... in</code>, unless followed by another <code>let</code>. This option is equivalent to the <code>in</code> option of <code>ocp-indent</code>.
The new option <code>type-decl-indent</code> sets the indentation of type declarations if they do not fit on a single line. This option is equivalent to the <code>type</code> option of <code>ocp-indent</code>.</p>
<p>These options will be set if their <code>ocp-indent</code> counterparts are set in an <code>.ocp-indent</code> configuration file.</p>
<h2 id="miscellaneous-features" style="position:relative;"><a href="#miscellaneous-features" aria-label="miscellaneous features permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Miscellaneous features</h2>
<p>This release also brings some new options, new values for existing features, or corrects erroneous behaviours.</p>
<h3 id="indicate-multiline-delimiters" style="position:relative;"><a href="#indicate-multiline-delimiters" aria-label="indicate multiline delimiters permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Indicate multiline delimiters</h3>
<p>The former <code>indicate-multiline-delimiters</code> boolean option is now a 3-valued option:</p>
<ul>
<li><code>indicate-multiline-delimiters=space</code> (was equivalent to <code>true</code>) prints a space inside the delimiter to indicate the matching one is on a different line.</li>
<li><code>indicate-multiline-delimiters=no</code> (was equivalent to <code>false</code>) doesn't do anything special to indicate the closing delimiter.</li>
<li><code>indicate-multiline-delimiters=closing-on-separate-line</code> is the new feature of this option, it makes sure that the closing delimiter is on its own line.</li>
</ul>
<p>On this example we can see the closing parenthesis delimiting the nested pattern-matchings are on their own line and are aligned with the matching opening parenthesis:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">=</span>
   <span class="token keyword">match</span> v <span class="token keyword">with</span>
   <span class="token operator">|</span> <span class="token module variable">None</span> <span class="token operator">-></span> <span class="token module variable">None</span>
   <span class="token operator">|</span> <span class="token module variable">Some</span> x <span class="token operator">-></span>
       <span class="token punctuation">(</span> <span class="token keyword">match</span> x <span class="token keyword">with</span>
       <span class="token operator">|</span> <span class="token module variable">None</span> <span class="token operator">-></span> <span class="token module variable">None</span>
       <span class="token operator">|</span> <span class="token module variable">Some</span> x <span class="token operator">-></span>
           <span class="token punctuation">(</span> <span class="token keyword">match</span> x <span class="token keyword">with</span>
           <span class="token operator">|</span> <span class="token module variable">None</span> <span class="token operator">-></span> <span class="token module variable">None</span>
           <span class="token operator">|</span> <span class="token module variable">Some</span> x <span class="token operator">-></span> x
           <span class="token punctuation">)</span>
       <span class="token punctuation">)</span></code></pre></div>
<h3 id="formatting-of-literal-strings" style="position:relative;"><a href="#formatting-of-literal-strings" aria-label="formatting of literal strings permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Formatting of literal strings</h3>
<p><code>break-string-literals=newlines</code> now takes into account pretty-printing commands like <code>@,</code>, <code>@;</code> and <code>@\\n</code> to produce more readable strings. A new value for this option has been added, <code>break-string-literals=newlines-and-wrap</code>, to break lines at newlines delimiters (including pretty-printing commands) and also wrap the string literals at the margin.</p>
<p>Here is how <code>break-string-literals=newlines-and-wrap</code> formats a string:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> fooooooooooo <span class="token operator">=</span>
  "<span class="token module variable">Lorem</span> ipsum dolor sit amet<span class="token punctuation">,</span> consectetur adipiscing elit<span class="token punctuation">,</span> sed <span class="token keyword">do</span> eiusmod \\
   tempor incididunt ut labore et dolore magna aliqua<span class="token punctuation">.</span><span class="token operator">@</span><span class="token punctuation">;</span>\\
   <span class="token module variable">Ut</span> enim ad minim veniam<span class="token punctuation">,</span> quis nostrud exercitation ullamco laboris nisi \\
   ut aliquip ex ea commodo consequat<span class="token punctuation">.</span><span class="token operator">@</span><span class="token punctuation">;</span>\\
   <span class="token module variable">Duis</span> aute irure dolor <span class="token keyword">in</span> reprehenderit <span class="token keyword">in</span> voluptate velit esse cillum \\
   dolore eu fugiat nulla pariatur<span class="token punctuation">.</span><span class="token operator">@</span><span class="token punctuation">;</span>\\
   <span class="token module variable">Excepteur</span> sint occaecat cupidatat non proident<span class="token punctuation">,</span> sunt <span class="token keyword">in</span> culpa qui \\
   officia deserunt mollit anim id est laborum<span class="token punctuation">.</span>"</code></pre></div>
<p><strong>Warning:</strong> the <code>break-string-literals</code> will likely be removed in the next release and the default behavior would be <code>newlines-and-wrap</code>.</p>
<h3 id="break-before-the-in-keyword" style="position:relative;"><a href="#break-before-the-in-keyword" aria-label="break before the in keyword permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Break before the <code>in</code> keyword</h3>
<p>The new option <code>break-before-in</code> has been added to decide whether the line should break before the <code>in</code> keyword of a <code>let</code> binding. <code>break-before-in=fit-or-vertical</code> will always break the line before the <code>in</code> keyword if the whole <code>let</code> binding does not fit on a single line, it is still the default behavior. <code>break-before-in=auto</code> will only break the line if the <code>in</code> keyword does not fit on the previous line.</p>
<p>For example:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> <span class="token punctuation">_</span> <span class="token operator">=</span>
  <span class="token keyword">let</span> short <span class="token operator">=</span> this is short <span class="token keyword">in</span>
  <span class="token keyword">let</span> fooo <span class="token operator">=</span>
    <span class="token punctuation">(</span>this is very long<span class="token punctuation">)</span> but <span class="token punctuation">(</span>the <span class="token keyword">in</span> keyword can fit<span class="token punctuation">)</span> on the same line <span class="token keyword">in</span>
  foooooo</code></pre></div>
<h3 id="indentation-of-nested-pattern-matching" style="position:relative;"><a href="#indentation-of-nested-pattern-matching" aria-label="indentation of nested pattern matching permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Indentation of nested pattern-matching</h3>
<p>The new option <code>nested-match</code> defines the style of pattern-matchings nested in the last case of another pattern-matching. <code>nested-match=wrap</code> wraps the nested pattern-matching with parentheses and adds indentation, this is still the default behavior. <code>nested-match=align</code> vertically aligns the nested pattern-matching under the encompassing pattern-matching, for example:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">=</span>
  <span class="token keyword">match</span> v <span class="token keyword">with</span>
  <span class="token operator">|</span> <span class="token module variable">None</span> <span class="token operator">-></span> <span class="token module variable">None</span>
  <span class="token operator">|</span> <span class="token module variable">Some</span> x <span class="token operator">-></span>
  <span class="token keyword">match</span> x <span class="token keyword">with</span>
  <span class="token operator">|</span> <span class="token module variable">None</span> <span class="token operator">-></span> <span class="token module variable">None</span>
  <span class="token operator">|</span> <span class="token module variable">Some</span> x <span class="token operator">-></span> x</code></pre></div>
<p>The new option <code>cases-matching-exp-indent</code> decides the indentation of cases right-hand sides which are <code>match</code> or <code>try</code> expressions. <code>cases-matching-exp-indent=compact</code> forces an indentation of 2, unless <code>nested-match</code> is set to <code>align</code> and this is the last case of the pattern matching. <code>compact</code> is the default behavior. <code>cases-matching-exp-indent=normal</code> indents as it would any other expression.</p>
<h3 id="whitelist-of-files-to-format" style="position:relative;"><a href="#whitelist-of-files-to-format" aria-label="whitelist of files to format permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Whitelist of files to format</h3>
<p>A new kind of configuration files is now handled by <code>ocamlformat</code>: <code>.ocamlformat-enable</code> files.
If the <code>disable</code> option is set, an <code>.ocamlformat-enable</code> file can list the files that <code>ocamlformat</code> should format even when the <code>disable</code> option is set. Each line in an <code>.ocamlformat-enable</code> file specifies a filename relative to the directory containing the <code>.ocamlformat-enable</code> file.</p>
<p>The <code>.ocamlformat-enable</code> files are using the same syntax as the <code>.ocamlformat-ignore</code> files: lines starting with <code>#</code> are ignored and can be used as comments.</p>
<p>These new configuration files do not contradict the existing <code>.ocamlformat-ignore</code> files, as <code>.ocamlformat-enable</code> are only considered when <code>disable</code> is set, and <code>.ocamlformat-ignore</code> are only considered when <code>disable</code> is not set.</p>
<h3 id="disable-outside-detected-project" style="position:relative;"><a href="#disable-outside-detected-project" aria-label="disable outside detected project permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Disable outside detected project</h3>
<p>The <code>disable-outside-detected-project</code> option is now set by default.</p>
<p>When the option <code>--enable-outside-detected-project</code> is not set, <code>.ocamlformat</code> files outside of the project (including the one in <code>XDG_CONFIG_HOME</code>) are not read. The project root of an input file is taken to be the nearest ancestor directory that contains a .git or .hg or dune-project file. If no config file is found, formatting is disabled.</p>
<h3 id="space-around-collection-expressions" style="position:relative;"><a href="#space-around-collection-expressions" aria-label="space around collection expressions permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Space around collection-expressions</h3>
<p>The former option <code>space-around-collection-expressions</code> that was deciding whether a space should be added inside the delimiters of collection expressions (lists, arrays, records, variants) has been replaced by 4 new options: <code>space-around-arrays</code>, <code>space-around-lists</code>, <code>space-around-records</code> and <code>space-around-variants</code>, to allow a finer grain customization.</p>
<h3 id="fit-or-vertical-mode-for-pattern-matching" style="position:relative;"><a href="#fit-or-vertical-mode-for-pattern-matching" aria-label="fit or vertical mode for pattern matching permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Fit-or-vertical mode for pattern matching</h3>
<p>The <code>break-cases</code> option that decides the shape of pattern matching has a new value <code>fit-or-vertical</code>. <code>break-cases=fit-or-vertical</code> tries to fit all or-patterns on the same line, otherwise breaks each or-pattern (they are wrapped in other modes).
For example if this set of or-patterns does not fit on a single line, we get the following output:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> ffffff <span class="token operator">=</span>
  <span class="token keyword">match</span> foooooooooooo <span class="token keyword">with</span>
  <span class="token operator">|</span> <span class="token module variable">Aaaaaaaaaaaaaaaaa</span>
  <span class="token operator">|</span> <span class="token module variable">Bbbbbbbbbbbbbbbbb</span>
  <span class="token operator">|</span> <span class="token module variable">Ccccccccccccccccc</span>
  <span class="token operator">|</span> <span class="token module variable">Ddddddddddddddddd</span>
  <span class="token operator">|</span> <span class="token module variable">Eeeeeeeeeeeeeeeee</span> <span class="token operator">-></span> foooooooooooooooooooo
  <span class="token operator">|</span> <span class="token module variable">Fffffffffffffffff</span> <span class="token operator">-></span> fooooooooooooooooo</code></pre></div>
<h3 id="kr-style-for-if-then-else" style="position:relative;"><a href="#kr-style-for-if-then-else" aria-label="kr style for if then else permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>K&#x26;R style for if-then-else</h3>
<p>The <code>if-then-else</code> option now has a new value <code>k-r</code> that uses parentheses (when necessary) to reproduce a formatting close to the K&#x26;R style. For example:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> <span class="token punctuation">_</span> <span class="token operator">=</span>
  <span class="token keyword">if</span> b <span class="token keyword">then</span> <span class="token punctuation">(</span>
    something loooooooooooooooooooooooooooooooong enough to_trigger a break <span class="token punctuation">;</span>
    this is more
  <span class="token punctuation">)</span> <span class="token keyword">else</span> <span class="token keyword">if</span> b1 <span class="token keyword">then</span> <span class="token punctuation">(</span>
    something loooooooooooooooooooooooooooooooong enough to_trigger a break <span class="token punctuation">;</span>
    this is more
  <span class="token punctuation">)</span> <span class="token keyword">else</span>
    e</code></pre></div>
<h2 id="breaking-changes" style="position:relative;"><a href="#breaking-changes" aria-label="breaking changes permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Breaking changes</h2>
<ul>
<li>the <code>indicate-multiline-delimiters</code> option is no longer a boolean option but now has 3 values: <code>space</code>, <code>no</code> and <code>closing-on-separate-line</code> that are detailed in this patch note.</li>
<li>the <code>disable-outside-detected-project</code> option is now set by default.</li>
<li>the <code>default</code> preset profile has been removed (it was equivalent to the <code>ocamlformat</code> profile with <code>break-cases=fit</code>).</li>
<li>the <code>space-around-collection-expressions</code> option has been replaced by 4 new options: <code>space-around-arrays</code>, <code>space-around-lists</code>, <code>space-around-records</code> and <code>space-around-variants</code>.</li>
</ul>
<h2 id="whats-next" style="position:relative;"><a href="#whats-next" aria-label="whats next permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>What's next?</h2>
<p>We strongly encourage our users to try out the <code>conventional</code> preset profile, as we plan to make it the default profile in a future release. This profile's purpose is to reproduce the most commonly encountered styles, and it may be more pleasing to the eye than the current default options.</p>
<p>As stated previously, the <code>break-string-literals</code> will likely be removed in the next release and the default behavior would be <code>newlines-and-wrap</code>.</p>
<h2 id="credits" style="position:relative;"><a href="#credits" aria-label="credits permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Credits</h2>
<p>This release also contains many other changes and bug fixes that we cannot detail here.</p>
<p>We would like to thank our maintainers and contributors for this release: Jules Aguillon, Josh Berdine, Hugo Heuzard, Guillaume Petiot and Thomas Refis, and especially our industrial users Jane Street, Ahrefs and Nomadic Labs that made this work possible by funding this project and providing helpful contributions and feedback.</p>
<p>We would be happy to provide support for more customers, please contact us at contact@tarides.com</p>
<p>If you wish to get involved with OCamlFormat development or file an issue, please read the <a href="https://github.com/ocaml-ppx/ocamlformat/blob/master/CONTRIBUTING.md">contributing guide</a>, any contribution is welcomed.</p>|js}
  };
 
  { title = {js|Release of OCamlFormat 0.9|js}
  ; slug = {js|release-of-ocamlformat-09|js}
  ; description = Some {js|We are pleased to announce the release of OCamlFormat (available on opam).
There have been numerous changes since the last release,
so here…|js}
  ; url = {js|https://tarides.com/blog/2019-03-29-release-of-ocamlformat-0-9|js}
  ; date = {js|2019-03-29T00:00:00-00:00|js}
  ; preview_image = Some {js|https://tarides.com/static/b0a6eda566f64c66aa1761737cf3ea4a/2244e/ceiling-arches.jpg|js}
  ; body_html = {js|<p>We are pleased to announce the release of OCamlFormat (available on opam).
There have been numerous changes since the last release,
so here is a comprehensive list of the new features and breaking changes to help the transition from OCamlFormat 0.8.</p>
<h1 id="additional-dependencies" style="position:relative;"><a href="#additional-dependencies" aria-label="additional dependencies permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Additional dependencies</h1>
<p>OCamlFormat now requires:</p>
<ul>
<li>ocaml >= 4.06 (up from 4.04.1)</li>
<li>dune >= 1.1.1</li>
<li>octavius >= 1.2.0</li>
<li>uutf</li>
</ul>
<p>OCamlFormat_Reason now requires:</p>
<ul>
<li>ocaml >= 4.06</li>
<li>dune >= 1.1.1</li>
<li>ocaml-migrate-parsetree >= 1.0.10 (up from 1.0.6)</li>
<li>octavius >= 1.2.0</li>
<li>uutf</li>
<li>reason >= 3.2.0 (up from 1.13.4)</li>
</ul>
<h1 id="new-preset-profiles" style="position:relative;"><a href="#new-preset-profiles" aria-label="new preset profiles permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>New preset profiles</h1>
<p>The <code>ocamlformat</code> profile aims to take advantage of the strengths of a parsetree-based auto-formatter,
and to limit the consequences of the weaknesses imposed by the current implementation.
This is a style which optimizes for what the formatter can do best, rather than to match the style of any existing code.
General guidelines that have directed the design include:</p>
<ul>
<li>Legibility, in the sense of making it as hard as possible for quick visual parsing to give the wrong interpretation,
is of highest priority;</li>
<li>Whenever possible the high-level structure of the code should be obvious by looking only at the left margin,
in particular, it should not be necessary to visually jump from left to right hunting for critical keywords, tokens, etc;</li>
<li>All else equal compact code is preferred as reading without scrolling is easier,
so indentation or white space is avoided unless it helps legibility;</li>
<li>Attention has been given to making some syntactic gotchas visually obvious.
<code>ocamlformat</code> is the new default profile.</li>
</ul>
<p>The <code>conventional</code> profile aims to be as familiar and "conventional" appearing as the available options allow.</p>
<p>The <code>default</code> profile is <code>ocamlformat</code> with <code>break-cases=fit</code>.
<code>default</code> is deprecated and will be removed in version 0.10.</p>
<h1 id="ocamlformat-diff-tool" style="position:relative;"><a href="#ocamlformat-diff-tool" aria-label="ocamlformat diff tool permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>OCamlFormat diff tool</h1>
<p><code>ocamlformat-diff</code> is a tool that uses OCamlFormat to apply the same formatting to compared OCaml files,
so that the formatting differences between the two files are not displayed.
Note that <code>ocamlformat-diff</code> comes in a separate opam package and is not included in the <code>ocamlformat</code> package.</p>
<p>The file comparison is then performed by any diff backend.</p>
<p>The options' documentation is available through <code>ocamlformat-diff --help</code>.</p>
<p>The option <code>--diff</code> allows you to configure the diff command that is used to compare the formatted files.
The default value is the vanilla <code>diff</code>, but you can also use <code>patdiff</code> or any other similar comparison tool.</p>
<p><code>ocamlformat-diff</code> can be integrated with <code>git diff</code>,
as explained in the <a href="https://github.com/ocaml-ppx/ocamlformat/blob/0.9/tools/ocamlformat-diff/README.md">online documentation</a>.</p>
<h1 id="formatting-docstrings" style="position:relative;"><a href="#formatting-docstrings" aria-label="formatting docstrings permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Formatting docstrings</h1>
<p>Previously, the docstrings <code>(** This is a docstring *)</code> could only be formatted like regular comments,
a new option <code>--parse-docstrings</code> has been added so that docstrings can be nicely formatted.</p>
<p>Here is a small example:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token comment">(** {1 Printers and escapes used by Cmdliner module} *)</span>

<span class="token keyword">val</span> subst_vars <span class="token punctuation">:</span> subst<span class="token punctuation">:</span><span class="token punctuation">(</span>string <span class="token operator">-></span> string option<span class="token punctuation">)</span> <span class="token operator">-></span> <span class="token module variable">Buffer</span><span class="token punctuation">.</span>t <span class="token operator">-></span> string <span class="token operator">-></span> string
<span class="token comment">(** [subst b ~subst s], using [b], substitutes in [s] variables of the form
    "$(doc)" by their [subst] definition. This leaves escapes and markup
    directives $(markup,...) intact.
    @raise Invalid_argument in case of illegal syntax. *)</span></code></pre></div>
<p>Note that this option is disabled by default and you have to set it manually by adding <code>--parse-docstrings</code> to your command line
or <code>parse-docstrings=true</code> to your <code>.ocamlformat</code> file.
If you get the following error message:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">Error: Formatting of (** ... *) is unstable (e.g. parses as a list or not depending on the margin), please tighten up this comment in the source or disable the formatting using the option --no-parse-docstrings.</code></pre></div>
<p>It means the original docstring cannot be formatted (e.g. because it does not comply with the odoc syntax)
and you have to edit it or disable the formatting of docstrings.</p>
<p>Of course if you think your docstring complies with the odoc syntax and there might be a bug in OCamlFormat,
<a href="https://github.com/ocaml-ppx/ocamlformat/issues">feel free to file an issue on github</a>.</p>
<h1 id="print-the-configuration" style="position:relative;"><a href="#print-the-configuration" aria-label="print the configuration permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Print the configuration</h1>
<p>The new <code>--print-config</code> flag prints the configuration determined by the environment variable,
the configuration files, preset profiles and command line. Attributes are not considered.</p>
<p>It provides the full list of options with the values they are set to, and the source of this value.
For example <code>ocamlformat --print-config</code> prints:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">profile=ocamlformat (file .ocamlformat:1)
quiet=false (profile ocamlformat (file .ocamlformat:1))
max-iters=10 (profile ocamlformat (file .ocamlformat:1))
comment-check=true (profile ocamlformat (file .ocamlformat:1))
wrap-fun-args=true (profile ocamlformat (file .ocamlformat:1))
wrap-comments=true (file .ocamlformat:5)
type-decl=compact (profile ocamlformat (file .ocamlformat:1))
space-around-collection-expressions=false (profile ocamlformat (file .ocamlformat:1))
single-case=compact (profile ocamlformat (file .ocamlformat:1))
sequence-style=separator (profile ocamlformat (file .ocamlformat:1))
parse-docstrings=true (file .ocamlformat:4)
parens-tuple-patterns=multi-line-only (profile ocamlformat (file .ocamlformat:1))
parens-tuple=always (profile ocamlformat (file .ocamlformat:1))
parens-ite=false (profile ocamlformat (file .ocamlformat:1))
ocp-indent-compat=false (profile ocamlformat (file .ocamlformat:1))
module-item-spacing=sparse (profile ocamlformat (file .ocamlformat:1))
margin=77 (file .ocamlformat:3)
let-open=preserve (profile ocamlformat (file .ocamlformat:1))
let-binding-spacing=compact (profile ocamlformat (file .ocamlformat:1))
let-and=compact (profile ocamlformat (file .ocamlformat:1))
leading-nested-match-parens=false (profile ocamlformat (file .ocamlformat:1))
infix-precedence=indent (profile ocamlformat (file .ocamlformat:1))
indicate-nested-or-patterns=space (profile ocamlformat (file .ocamlformat:1))
indicate-multiline-delimiters=true (profile ocamlformat (file .ocamlformat:1))
if-then-else=compact (profile ocamlformat (file .ocamlformat:1))
field-space=tight (profile ocamlformat (file .ocamlformat:1))
extension-sugar=preserve (profile ocamlformat (file .ocamlformat:1))
escape-strings=preserve (profile ocamlformat (file .ocamlformat:1))
escape-chars=preserve (profile ocamlformat (file .ocamlformat:1))
doc-comments-tag-only=default (profile ocamlformat (file .ocamlformat:1))
doc-comments-padding=2 (profile ocamlformat (file .ocamlformat:1))
doc-comments=after (profile ocamlformat (file .ocamlformat:1))
disable=false (profile ocamlformat (file .ocamlformat:1))
cases-exp-indent=4 (profile ocamlformat (file .ocamlformat:1))
break-struct=force (profile ocamlformat (file .ocamlformat:1))
break-string-literals=wrap (profile ocamlformat (file .ocamlformat:1))
break-sequences=false (profile ocamlformat (file .ocamlformat:1))
break-separators=before (profile ocamlformat (file .ocamlformat:1))
break-infix-before-func=true (profile ocamlformat (file .ocamlformat:1))
break-infix=wrap (profile ocamlformat (file .ocamlformat:1))
break-fun-decl=wrap (profile ocamlformat (file .ocamlformat:1))
break-collection-expressions=fit-or-vertical (profile ocamlformat (file .ocamlformat:1))
break-cases=fit (file .ocamlformat:2)</code></pre></div>
<p>If many input files are specified, only print the configuration for the first file.
If no input file is specified, print the configuration for the root directory if specified,
or for the current working directory otherwise.</p>
<h1 id="parentheses-around-if-then-else-branches" style="position:relative;"><a href="#parentheses-around-if-then-else-branches" aria-label="parentheses around if then else branches permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Parentheses around if-then-else branches</h1>
<p>A new option <code>parens-ite</code> has been added to decide whether to use parentheses
around if-then-else branches that spread across multiple lines.</p>
<p>If this option is set, the following function:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> <span class="token keyword">rec</span> loop count a <span class="token operator">=</span>
  <span class="token keyword">if</span> count <span class="token operator">>=</span> self#len
  <span class="token keyword">then</span> a
  <span class="token keyword">else</span>
    <span class="token keyword">let</span> a' <span class="token operator">=</span> f cur#get count a <span class="token keyword">in</span>
    cur#incr <span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">;</span>
    loop <span class="token punctuation">(</span>count <span class="token operator">+</span> <span class="token number">1</span><span class="token punctuation">)</span> a'</code></pre></div>
<p>will be formatted as:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> <span class="token keyword">rec</span> loop count a <span class="token operator">=</span>
  <span class="token keyword">if</span> count <span class="token operator">>=</span> self#len
  <span class="token keyword">then</span> a
  <span class="token keyword">else</span> <span class="token punctuation">(</span>
    <span class="token keyword">let</span> a' <span class="token operator">=</span> f cur#get count a <span class="token keyword">in</span>
    cur#incr <span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">;</span>
    loop <span class="token punctuation">(</span>count <span class="token operator">+</span> <span class="token number">1</span><span class="token punctuation">)</span> a' <span class="token punctuation">)</span></code></pre></div>
<h1 id="parentheses-around-tuple-patterns" style="position:relative;"><a href="#parentheses-around-tuple-patterns" aria-label="parentheses around tuple patterns permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Parentheses around tuple patterns</h1>
<p>A new option <code>parens-tuple-patterns</code> has been added, that mimics <code>parens-tuple</code> but only applies to patterns,
whereas <code>parens-tuples</code> only applies to expressions.
<code>parens-tuple-patterns=multi-line-only</code> mode will try to skip parentheses for single-line tuple patterns,
this is the default value.
<code>parens-tuple-patterns=always</code> always uses parentheses around tuples patterns.</p>
<p>For example:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token comment">(* with parens-tuple-patterns=always *)</span>
<span class="token keyword">let</span> <span class="token punctuation">(</span>a<span class="token punctuation">,</span> b<span class="token punctuation">)</span> <span class="token operator">=</span> <span class="token punctuation">(</span><span class="token number">1</span><span class="token punctuation">,</span> <span class="token number">2</span><span class="token punctuation">)</span>

<span class="token comment">(* with parens-tuple-patterns=multi-line-only *)</span>
<span class="token keyword">let</span> a<span class="token punctuation">,</span> b <span class="token operator">=</span> <span class="token punctuation">(</span><span class="token number">1</span><span class="token punctuation">,</span> <span class="token number">2</span><span class="token punctuation">)</span></code></pre></div>
<h1 id="single-case-pattern-matching-expressions" style="position:relative;"><a href="#single-case-pattern-matching-expressions" aria-label="single case pattern matching expressions permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Single-case pattern-matching expressions</h1>
<p>The new option <code>single-case</code> defines the style of pattern-matching expressions with only a single case.
<code>single-case=compact</code> will try to format a single case on a single line, this is the default value.
<code>single-case=sparse</code> will always break the line before a single case.</p>
<p>For example:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token comment">(* with single-case=compact *)</span>
<span class="token keyword">try</span> some_irrelevant_expression
<span class="token keyword">with</span> <span class="token module variable">Undefined_recursive_module</span> <span class="token punctuation">_</span> <span class="token operator">-></span> <span class="token boolean">true</span>

<span class="token comment">(* with single-case=sparse *)</span>
<span class="token keyword">try</span> some_irrelevant_expression
<span class="token keyword">with</span>
<span class="token operator">|</span> <span class="token module variable">Undefined_recursive_module</span> <span class="token punctuation">_</span> <span class="token operator">-></span> <span class="token boolean">true</span></code></pre></div>
<h1 id="space-around-collection-expressions" style="position:relative;"><a href="#space-around-collection-expressions" aria-label="space around collection expressions permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Space around collection expressions</h1>
<p>The new option <code>space-around-collection-expressions</code> decides whether to add a space
inside the delimiters of collection expressions (lists, arrays, records).</p>
<p>For example:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token comment">(* by default *)</span>
<span class="token keyword">type</span> wkind <span class="token operator">=</span> <span class="token punctuation">{</span>f <span class="token punctuation">:</span> <span class="token type-variable function">'a</span><span class="token punctuation">.</span> <span class="token type-variable function">'a</span> tag <span class="token operator">-></span> <span class="token type-variable function">'a</span> kind<span class="token punctuation">}</span>
<span class="token keyword">let</span> l <span class="token operator">=</span> <span class="token punctuation">[</span><span class="token string">"Nil"</span><span class="token punctuation">,</span> <span class="token module variable">TCnoarg</span> <span class="token module variable">Thd</span><span class="token punctuation">;</span> <span class="token string">"Cons"</span><span class="token punctuation">,</span> <span class="token module variable">TCarg</span> <span class="token punctuation">(</span><span class="token module variable">Ttl</span> <span class="token module variable">Thd</span><span class="token punctuation">,</span> tcons<span class="token punctuation">)</span><span class="token punctuation">]</span>

<span class="token comment">(* with space-around-collection-expressions *)</span>
<span class="token keyword">type</span> wkind <span class="token operator">=</span> <span class="token punctuation">{</span> f <span class="token punctuation">:</span> <span class="token type-variable function">'a</span><span class="token punctuation">.</span> <span class="token type-variable function">'a</span> tag <span class="token operator">-></span> <span class="token type-variable function">'a</span> kind <span class="token punctuation">}</span>
<span class="token keyword">let</span> l <span class="token operator">=</span> <span class="token punctuation">[</span> <span class="token string">"Nil"</span><span class="token punctuation">,</span> <span class="token module variable">TCnoarg</span> <span class="token module variable">Thd</span><span class="token punctuation">;</span> <span class="token string">"Cons"</span><span class="token punctuation">,</span> <span class="token module variable">TCarg</span> <span class="token punctuation">(</span><span class="token module variable">Ttl</span> <span class="token module variable">Thd</span><span class="token punctuation">,</span> tcons<span class="token punctuation">)</span> <span class="token punctuation">]</span></code></pre></div>
<h1 id="break-separators" style="position:relative;"><a href="#break-separators" aria-label="break separators permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Break separators</h1>
<p>The new option <code>break-separators</code> decides whether to break before or after separators such as <code>;</code> in list or record expressions,
<code>*</code> in tuples or <code>-></code> in arrow types.
<code>break-separators=before</code> breaks the expressions before the separator, this is the default value.
<code>break-separators=after</code> breaks the expressions after the separator.
<code>break-separators=after-and-docked</code> breaks the expressions after the separator and docks the brackets for records.</p>
<p>For example:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token comment">(* with break-separators=before *)</span>
<span class="token keyword">type</span> t <span class="token operator">=</span>
  <span class="token punctuation">{</span> foooooooooooooooooooooooo<span class="token punctuation">:</span> foooooooooooooooooooooooooooooooooooooooo
  <span class="token punctuation">;</span> fooooooooooooooooooooooooooooo<span class="token punctuation">:</span> fooooooooooooooooooooooooooo <span class="token punctuation">}</span>

<span class="token comment">(* with break-separators=after *)</span>
<span class="token keyword">type</span> t <span class="token operator">=</span>
  <span class="token punctuation">{</span> foooooooooooooooooooooooo<span class="token punctuation">:</span> foooooooooooooooooooooooooooooooooooooooo<span class="token punctuation">;</span>
    fooooooooooooooooooooooooooooo<span class="token punctuation">:</span> fooooooooooooooooooooooooooo <span class="token punctuation">}</span>

<span class="token comment">(* with break-separators=after-and-docked *)</span>
<span class="token keyword">type</span> t <span class="token operator">=</span> <span class="token punctuation">{</span>
  foooooooooooooooooooooooo<span class="token punctuation">:</span> foooooooooooooooooooooooooooooooooooooooo<span class="token punctuation">;</span>
  fooooooooooooooooooooooooooooo<span class="token punctuation">:</span> fooooooooooooooooooooooooooo
<span class="token punctuation">}</span></code></pre></div>
<h1 id="not-breaking-before-bindmap-operators" style="position:relative;"><a href="#not-breaking-before-bindmap-operators" aria-label="not breaking before bindmap operators permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Not breaking before bind/map operators</h1>
<p>The new option <code>break-infix-before-func</code> decides whether to break infix operators
whose right arguments are anonymous functions specially.
This option is set by default, if you disable it with <code>--no-break-infix-before-func</code>,
it will not break before the operator so that the first line of the function appears docked at the end of line after the operator.</p>
<p>For example:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token comment">(* by default *)</span>
f x
<span class="token operator">>>=</span> <span class="token keyword">fun</span> y <span class="token operator">-></span>
g y
<span class="token operator">>>=</span> <span class="token keyword">fun</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">-></span>
f x <span class="token operator">>>=</span> <span class="token keyword">fun</span> y <span class="token operator">-></span> g y <span class="token operator">>>=</span> <span class="token keyword">fun</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">-></span> f x <span class="token operator">>>=</span> <span class="token keyword">fun</span> y <span class="token operator">-></span> g y <span class="token operator">>>=</span> <span class="token keyword">fun</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">-></span> y <span class="token punctuation">(</span><span class="token punctuation">)</span>

<span class="token comment">(* with break-infix-before-func = false *)</span>
f x <span class="token operator">>>=</span> <span class="token keyword">fun</span> y <span class="token operator">-></span>
g y <span class="token operator">>>=</span> <span class="token keyword">fun</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">-></span>
f x <span class="token operator">>>=</span> <span class="token keyword">fun</span> y <span class="token operator">-></span> g y <span class="token operator">>>=</span> <span class="token keyword">fun</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">-></span> f x <span class="token operator">>>=</span> <span class="token keyword">fun</span> y <span class="token operator">-></span> g y <span class="token operator">>>=</span> <span class="token keyword">fun</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">-></span> y <span class="token punctuation">(</span><span class="token punctuation">)</span></code></pre></div>
<h1 id="break-toplevel-cases" style="position:relative;"><a href="#break-toplevel-cases" aria-label="break toplevel cases permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Break toplevel cases</h1>
<p>There is a new value for the <code>break-cases</code> option: <code>toplevel</code>,
that forces top-level cases (i.e. not nested or-patterns) to break across lines,
otherwise breaks naturally at the margin.</p>
<p>For example:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> f <span class="token operator">=</span>
  <span class="token keyword">let</span> g <span class="token operator">=</span> <span class="token keyword">function</span>
    <span class="token operator">|</span> H <span class="token keyword">when</span> x y <span class="token operator">&lt;></span> k <span class="token operator">-></span> <span class="token number">2</span>
    <span class="token operator">|</span> T <span class="token operator">|</span> P <span class="token operator">|</span> U <span class="token operator">-></span> <span class="token number">3</span>
  <span class="token keyword">in</span>
  <span class="token keyword">fun</span> x g t h y u <span class="token operator">-></span>
    <span class="token keyword">match</span> x <span class="token keyword">with</span>
    <span class="token operator">|</span> E <span class="token operator">-></span> <span class="token number">4</span>
    <span class="token operator">|</span> Z <span class="token operator">|</span> P <span class="token operator">|</span> M <span class="token operator">-></span> <span class="token punctuation">(</span>
      <span class="token keyword">match</span> y <span class="token keyword">with</span>
      <span class="token operator">|</span> O <span class="token operator">-></span> <span class="token number">5</span>
      <span class="token operator">|</span> P <span class="token keyword">when</span> h x <span class="token operator">-></span> <span class="token punctuation">(</span>
          <span class="token keyword">function</span>
          <span class="token operator">|</span> A <span class="token operator">-></span> <span class="token number">6</span> <span class="token punctuation">)</span> <span class="token punctuation">)</span></code></pre></div>
<h1 id="number-of-spaces-before-docstrings" style="position:relative;"><a href="#number-of-spaces-before-docstrings" aria-label="number of spaces before docstrings permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Number of spaces before docstrings</h1>
<p>The new option <code>doc-comments-padding</code> controls how many spaces are printed before doc comments in type declarations.
The default value is 2.</p>
<p>For example:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token comment">(* with doc-comments-padding = 2 *)</span>
<span class="token keyword">type</span> t <span class="token operator">=</span> <span class="token punctuation">{</span>a<span class="token punctuation">:</span> int  <span class="token comment">(** a *)</span><span class="token punctuation">;</span> b<span class="token punctuation">:</span> int  <span class="token comment">(** b *)</span><span class="token punctuation">}</span>

<span class="token comment">(* with doc-comments-padding = 1 *)</span>
<span class="token keyword">type</span> t <span class="token operator">=</span> <span class="token punctuation">{</span>a<span class="token punctuation">:</span> int <span class="token comment">(** a *)</span><span class="token punctuation">;</span> b<span class="token punctuation">:</span> int <span class="token comment">(** b *)</span><span class="token punctuation">}</span></code></pre></div>
<h1 id="ignore-files" style="position:relative;"><a href="#ignore-files" aria-label="ignore files permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Ignore files</h1>
<p>An <code>.ocamlformat-ignore</code> file specifies files that OCamlFormat should ignore.
Each line in an <code>.ocamlformat-ignore</code> file specifies a filename relative to the directory containing the <code>.ocamlformat-ignore</code> file.
Lines starting with <code>#</code> are ignored and can be used as comments.</p>
<p>Here is an example of such <code>.ocamlformat-ignore</code> file:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">#This is a comment
dir2/ignore_1.ml</code></pre></div>
<h1 id="tag-only-docstrings" style="position:relative;"><a href="#tag-only-docstrings" aria-label="tag only docstrings permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Tag-only docstrings</h1>
<p>The new option <code>doc-comments-tag-only</code> controls the position of doc comments only containing tags.
<code>doc-comments-tag-only=default</code> means no special treatment is done, this is the default value.
<code>doc-comments-tag-only=fit</code> puts doc comments on the same line if it fits.</p>
<p>For example:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token comment">(* with doc-comments-tag-only = default *)</span>

<span class="token comment">(** @deprecated  *)</span>
<span class="token keyword">open</span> <span class="token module variable">Module</span>

<span class="token comment">(* with doc-comments-tag-only = fit *)</span>

<span class="token keyword">open</span> <span class="token module variable">Module</span> <span class="token comment">(** @deprecated  *)</span></code></pre></div>
<h1 id="fit-or-vertical-mode-for-if-then-else" style="position:relative;"><a href="#fit-or-vertical-mode-for-if-then-else" aria-label="fit or vertical mode for if then else permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Fit or vertical mode for if-then-else</h1>
<p>There is a new value for the option <code>if-then-else</code>: <code>fit-or-vertical</code>.
<code>fit-or-vertical</code> vertically breaks all branches if they do not fit on a single line.
Compared to the <code>compact</code> (default) value, it breaks all branches if at least one of them does not fit on a single line.</p>
<p>For example:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token comment">(* with if-then-else = compact *)</span>
<span class="token keyword">let</span> <span class="token punctuation">_</span> <span class="token operator">=</span>
  <span class="token keyword">if</span> foo <span class="token keyword">then</span>
    <span class="token keyword">let</span> a <span class="token operator">=</span> <span class="token number">1</span> <span class="token keyword">in</span>
    <span class="token keyword">let</span> b <span class="token operator">=</span> <span class="token number">2</span> <span class="token keyword">in</span>
    a <span class="token operator">+</span> b
  <span class="token keyword">else</span> <span class="token keyword">if</span> foo <span class="token keyword">then</span> <span class="token number">12</span>
  <span class="token keyword">else</span> <span class="token number">0</span>

<span class="token comment">(* with if-then-else = fit-or-vertical *)</span>
<span class="token keyword">let</span> <span class="token punctuation">_</span> <span class="token operator">=</span>
  <span class="token keyword">if</span> foo <span class="token keyword">then</span>
    <span class="token keyword">let</span> a <span class="token operator">=</span> <span class="token number">1</span> <span class="token keyword">in</span>
    <span class="token keyword">let</span> b <span class="token operator">=</span> <span class="token number">2</span> <span class="token keyword">in</span>
    a <span class="token operator">+</span> b
  <span class="token keyword">else</span> <span class="token keyword">if</span> foo <span class="token keyword">then</span>
    <span class="token number">12</span>
  <span class="token keyword">else</span>
    <span class="token number">0</span></code></pre></div>
<h1 id="check-mode" style="position:relative;"><a href="#check-mode" aria-label="check mode permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Check mode</h1>
<p>A new <code>--check</code> flag has been added.
It checks whether the input files already are formatted.
This flag is mutually exclusive with <code>--inplace</code> and <code>--output</code>.
It returns <code>0</code> if the input files are indeed already formatted, or <code>1</code> otherwise.</p>
<h1 id="break-function-declarations" style="position:relative;"><a href="#break-function-declarations" aria-label="break function declarations permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Break function declarations</h1>
<p>The new option <code>break-fun-decl</code> controls the style for function declarations and types.
<code>break-fun-decl=wrap</code> breaks only if necessary, this is the default value.
<code>break-fun-decl=fit-or-vertical</code> vertically breaks arguments if they do not fit on a single line.
<code>break-fun-decl=smart</code> is like <code>fit-or-vertical</code> but try to fit arguments on their line if they fit.
The <code>wrap-fun-args</code> option now only controls the style for function calls, and no more for function declarations.</p>
<p>For example:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token comment">(* with break-fun-decl = wrap *)</span>
<span class="token keyword">let</span> ffffffffffffffffffff aaaaaaaaaaaaaaaaaaaaaa bbbbbbbbbbbbbbbbbbbbbb
    cccccccccccccccccccccc <span class="token operator">=</span>
  g

<span class="token comment">(* with break-fun-decl = fit-or-vertical *)</span>
<span class="token keyword">let</span> ffffffffffffffffffff
    aaaaaaaaaaaaaaaaaaaaaa
    bbbbbbbbbbbbbbbbbbbbbb
    cccccccccccccccccccccc <span class="token operator">=</span>
  g

<span class="token comment">(* with break-fun-decl = smart *)</span>
<span class="token keyword">let</span> ffffffffffffffffffff
    aaaaaaaaaaaaaaaaaaaaaa bbbbbbbbbbbbbbbbbbbbbb cccccccccccccccccccccc <span class="token operator">=</span>
  g</code></pre></div>
<h1 id="disable-configuration-in-files-and-attributes" style="position:relative;"><a href="#disable-configuration-in-files-and-attributes" aria-label="disable configuration in files and attributes permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Disable configuration in files and attributes</h1>
<p>Two new options have been added so that <code>.ocamlformat</code> configuration files and attributes in OCaml files do not change the
configuration.
These options can be useful if you use some preset profile
and you do not want attributes and <code>.ocamlformat</code> files to interfere with your preset configuration.
<code>--disable-conf-attrs</code> disables the configuration in attributes,
and <code>--disable-conf-files</code> disables <code>.ocamlformat</code> configuration files.</p>
<h1 id="preserve-module-items-spacing" style="position:relative;"><a href="#preserve-module-items-spacing" aria-label="preserve module items spacing permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Preserve module items spacing</h1>
<p>There is a new value for the option <code>module-item-spacing</code>: <code>preserve</code>,
that will not leave open lines between one-liners of similar sorts unless there is an open line in the input.</p>
<p>For example the line breaks are preserved in the following code:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> cmos_rtc_seconds <span class="token operator">=</span> <span class="token number">0x00</span>
<span class="token keyword">let</span> cmos_rtc_seconds_alarm <span class="token operator">=</span> <span class="token number">0x01</span>
<span class="token keyword">let</span> cmos_rtc_minutes <span class="token operator">=</span> <span class="token number">0x02</span>

<span class="token keyword">let</span> x <span class="token operator">=</span> o

<span class="token keyword">let</span> log_other <span class="token operator">=</span> <span class="token number">0x000001</span>
<span class="token keyword">let</span> log_cpu <span class="token operator">=</span> <span class="token number">0x000002</span>
<span class="token keyword">let</span> log_fpu <span class="token operator">=</span> <span class="token number">0x000004</span></code></pre></div>
<h1 id="breaking-changes" style="position:relative;"><a href="#breaking-changes" aria-label="breaking changes permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Breaking changes</h1>
<ul>
<li>When <code>--disable-outside-detected-project</code> is set, disable ocamlformat when no <code>.ocamlformat</code> file is found.</li>
<li>Files are not parsed when ocamlformat is disabled.</li>
<li>Disallow <code>-</code> with other input files.</li>
<li>The <code>wrap-fun-args</code> option now only controls the style for function calls, and no more for function declarations.</li>
<li>The default profile is now named <code>ocamlformat</code>.</li>
<li>The deprecated syntax for <code>.ocamlformat</code> files: <code>option value</code> is no more supported anymore and you should use the <code>option = value</code> syntax instead.</li>
</ul>
<h1 id="miscellaneous-bugfixes" style="position:relative;"><a href="#miscellaneous-bugfixes" aria-label="miscellaneous bugfixes permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Miscellaneous bugfixes</h1>
<ul>
<li>Preserve shebang (e.g. <code>#!/usr/bin/env ocaml</code>) at the beginning of a file.</li>
<li>Improve the formatting when <code>ocp-indent-compat</code> is set.</li>
<li>UTF8 characters are now correctly printed in comments.</li>
<li>Add parentheses around a constrained any-pattern (e.g. <code>let (_ : int) = x1</code>).</li>
<li>Emacs: the temporary buffer is now killed.</li>
<li>Emacs: add the keybinding in tuareg's map instead of merlin's.</li>
<li>Lots of improvements on the comments, docstrings, attributes formatting.</li>
<li>Lots of improvements on the formatting of modules.</li>
<li>Lots of improvements in the Reason support.</li>
<li>Do not rely on the file-system to format sources.</li>
<li>The <code>--debug</code> mode is more user-friendly.</li>
</ul>
<h1 id="credits" style="position:relative;"><a href="#credits" aria-label="credits permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Credits</h1>
<p>This release also contains many other changes and bug fixes that we cannot detail here.</p>
<p>Special thanks to our maintainers and contributors for this release: Jules Aguillon, Mathieu Barbin, Josh Berdine, Jérémie Dimino, Hugo Heuzard, Ludwig Pacifici, Guillaume Petiot, Nathan Rebours and Louis Roché.</p>
<p>If you wish to get involved with OCamlFormat development or file an issue,
please read the <a href="https://github.com/ocaml-ppx/ocamlformat/blob/master/CONTRIBUTING.md">contributing guide</a>,
any contribution is welcomed.</p>|js}
  };
 
  { title = {js|Tarides is now a sponsor of the OCaml Software Foundation|js}
  ; slug = {js|tarides-is-now-a-sponsor-of-the-ocaml-software-foundation|js}
  ; description = Some {js|Tarides is pleased to provide support for the OCaml Software
Foundation, a non-profit foundation hosted by
the Inria Foundation. The OCaml…|js}
  ; url = {js|https://tarides.com/blog/2020-09-17-tarides-is-now-a-sponsor-of-the-ocaml-software-foundation|js}
  ; date = {js|2020-09-17T00:00:00-00:00|js}
  ; preview_image = Some {js|https://tarides.com/static/305bd3e2ab2e164e61b7781d183976fd/497c6/ocaml-software-foundation.png|js}
  ; body_html = {js|<p>Tarides is pleased to provide support for the <a href="https://ocaml-sf.org">OCaml Software
Foundation</a>, a non-profit foundation hosted by
the Inria Foundation. The OCaml Software Foundation's mission is to
promote the OCaml programming language and its ecosystem by
supporting the growth of a diverse and international community of
OCaml users.</p>
<p>Tarides develops secure-by-design solutions in which OCaml's memory and
type-safety guarantees play a major role. Hence, most of the software
development that is done at Tarides is in OCaml: for instance,
<a href="https://mirage.io">MirageOS</a>, a library operating system that
constructs unikernels for secure, high-performance network
applications; and <a href="https://irmin.org">Irmin</a>, a library for building
mergeable, branchable distributed data stores, with built-in
snapshotting and support for a wide variety of storage backends.</p>
<p>Tarides is also very involved in the OCaml compiler development and
OCaml developer tooling ecosystem: as active maintainers of the <a href="https://www.youtube.com/watch?v=E8T_4zqWmq8&#x26;list=PLKO_ZowsIOu5fHjRj0ua7_QWE_L789K_f&#x26;ab_channel=ocaml2020">OCaml
platform</a>, Tarides is involved with most of the major
OCaml developer tools, including <a href="https://github.com/ocaml/ocaml">opam</a>, <a href="https://github.com/ocaml/dune">dune</a> and <a href="https://github.com/ocaml/merlin">merlin</a>.</p>|js}
  };
 
  { title = {js|The future of Tezos on MirageOS|js}
  ; slug = {js|the-future-of-tezos-on-mirageos|js}
  ; description = Some {js|We are very glad to announce that Tarides has been awarded two new grants from
the Tezos Foundation. Thanks to these new grants, Tarides…|js}
  ; url = {js|https://tarides.com/blog/2020-04-20-the-future-of-tezos-on-mirageos|js}
  ; date = {js|2020-04-20T00:00:00-00:00|js}
  ; preview_image = Some {js|https://tarides.com/static/bb44e4615f4730d8692d1214f5b238a3/497c6/tezosgrants.png|js}
  ; body_html = {js|<p>We are very glad to announce that Tarides has been awarded two new grants from
the Tezos Foundation.</p>
<p>Thanks to these new grants, Tarides will continue to work on the integration
between Tezos and MirageOS. We believe that the secure deployment of blockchains
is still a major challenge today, and that deploying Tezos as a unikernel will
have a big impact in term of safety and security. It will be a key
differentiator that will separate Tezos from other blockchains.</p>
<p>The Tezos codebase is written in OCaml and is currently using more than 100
external packages, among which one third comes from the MirageOS project.
However, it still heavily depends on non-compatible Unix libraries. Making the
Tezos codebase fully compatible with MirageOS will help Tezos with: distribution
and packaging, portability, secure deployment and operational safety.</p>
<p>We’ll regularly publish development progress updates, so stay tuned!</p>|js}
  }]

