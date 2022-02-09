
type t =
  { date : string
  ; body_html : string
  }
  
let all = [
  { date = {js|2022-02-08|js}
  ; body_html = {js|<p>Hello,</p>
<p>Here is the latest OCaml Weekly News, for the week of February 01 to 08, 2022.</p>
<h2>Table of Contents</h2>
<ul>
<li><a href="#1">Functori is hiring full-time engineers and Interns</a>
</li>
<li><a href="#2">Permanent position for Computer Scientist in cybersecurity verification at CEA List, France</a>
</li>
<li><a href="#3">pyml_bindgen: a CLI app to generate Python bindings directly from OCaml value specifications</a>
</li>
</ul>
<h2>Functori is hiring full-time engineers and Interns</h2>
<p>Archive: <a href="https://discuss.ocaml.org/t/functori-is-hiring-full-time-engineers-interns/9266/1">https://discuss.ocaml.org/t/functori-is-hiring-full-time-engineers-interns/9266/1</a></p>
<h3>Mohamed Iguernlala announced</h3>
<p>Functori, a young and dynamic company based in Paris, is hiring talented engineers/PhDs to expand its team. Please find more details in the announcement (in French): <a href="https://functori.com/annonce-recrutement.pdf">https://functori.com/annonce-recrutement.pdf</a></p>
<p>We are also looking for interns in the fields of programming languages, formal methods, and blockchains (details available on request).</p>
<p>Feel free to share with anyone who may be interested.</p>
<h2>Permanent position for Computer Scientist in cybersecurity verification at CEA List, France</h2>
<p>Archive: <a href="https://sympa.inria.fr/sympa/arc/caml-list/2022-02/msg00004.html">https://sympa.inria.fr/sympa/arc/caml-list/2022-02/msg00004.html</a></p>
<h3>ANTIGNAC Thibaud announced</h3>
<p>We would like to share with you an exciting opportunity to join the Frama-C team at CEA List (a French public research institute). We are opening a permanent computer scientist position to work on formal verification of cybersecurity properties. More details about the position and the qualifications expected are available here: <a href="https://frama-c.com/jobs/2022-02-01-permanent-computer-scientist-cyber-security-verification.html">https://frama-c.com/jobs/2022-02-01-permanent-computer-scientist-cyber-security-verification.html</a></p>
<p>Please do not hesitate to reach out or to share with potentially interested people!</p>
<h2>pyml_bindgen: a CLI app to generate Python bindings directly from OCaml value specifications</h2>
<p>Archive: <a href="https://discuss.ocaml.org/t/ann-pyml-bindgen-a-cli-app-to-generate-python-bindings-directly-from-ocaml-value-specifications/8786/5">https://discuss.ocaml.org/t/ann-pyml-bindgen-a-cli-app-to-generate-python-bindings-directly-from-ocaml-value-specifications/8786/5</a></p>
<h3>Ryan Moore announced</h3>
<h4>New version</h4>
<p>I wanted to announce a new version of <code>pyml_bindgen</code> has been merged into the opam repository, version 0.2.0. Whenever it hits, feel free to try it out!</p>
<p>The main addition is now you can embed Python files directly into the generated OCaml module and it will be evaluated at run time. In this way, you don't need your users to mess with the <code>PYTHONPATH</code> environment variable or need them to install a particular Python module when using the generated OCaml code. (Another thanks to UnixJunkie and Thierry Martinez for their help with this!)</p>
<p>There were also a few bugfixes and some nice new <a href="https://github.com/mooreryan/ocaml_python_bindgen/tree/main/examples">examples</a> added to the GitHub repository. One cool thing about the examples is that they show you how to set up your project to use Dune rules to automatically generate Python bindings whenever the value specification files change!</p>
|js}
  }]

