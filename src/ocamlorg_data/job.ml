
type t =
  { id : int
  ; title : string
  ; link : string
  ; description_html : string
  ; location : string
  ; company : string
  ; company_logo : string
  ; fullfilled : bool
  }
  
let all = 
[
  { id = 1
  ; title = {js|Multicore Application Engineer|js}
  ; link = {js|https://tarides.com/jobs/multicore-application-engineer|js}
  ; description_html = {js|<h2>Work</h2>
<p>The Multicore OCaml project aims to add native support for scalable concurrency and shared memory parallelism to the OCaml programming language. At its core, Multicore OCaml extends OCaml with effect handlers for expressing scalable concurrency, and a high-performance concurrent garbage collector aimed at responsive networked applications. Multicore OCaml is also the first industrial-strength language to be equipped with an efficient yet modular memory model, allowing high-level local program reasoning while retaining performance.</p>
<p>Multicore OCaml is actively being developed and core features are being upstreamed to OCaml. The multicore project at Tarides is a close collaboration with our industrial partners OCaml Labs and Segfault Systems.</p>
<p>As OCaml 5.0 with shared-memory parallelism support is on the horizon, we are ready to build full-fledged OCaml applications that take advantage of the parallelism opportunities. Specifically, the focus is on the Tezos blockchain to improve the transaction throughput, utilising the parallelism support. We believe that adding parallelism support to a complex project such as the Tezos shell would set a precedent for how other projects should utilise parallelism support and help identify pain points that the Multicore OCaml team and the wider community can address.</p>
<p>We are looking for an experienced engineer (3y+) to build parallel applications using the Multicore OCaml compiler.</p>
<h2>Responsibilities</h2>
<ul>
<li>Ecosystem Engineering
<ul>
<li>Build and maintain Tezos node using the Multicore OCaml compiler.
</li>
<li>Add Tezos-related packages to the OCaml CI.
</li>
<li>Investigate CI failures and report issues to appropriate teams.
</li>
</ul>
</li>
<li>Parallelising
<ul>
<li>Work with the Tezos developers to identify the opportunities for parallelism in the Tezos shell.
</li>
<li>Utilise Multicore OCaml parallelism support (such as the Lwt offloading mechanism) to offload compute-intensive tasks such as crypto and serialisation to spare cores.
</li>
<li>Work with the Irmin/Tezos storage team to add parallelism to storage tasks.
</li>
</ul>
</li>
<li>Benchmarking
<ul>
<li>Work with the Tezos developers and Irmin team to identify relevant benchmarks.
</li>
<li>Implement those benchmarks for Tezos, and work with the benchmarking team to include them in sandmark and continuous benchmarking infrastructures.
</li>
</ul>
</li>
<li>Research
<ul>
<li>Build a direct-style Tezos shell using the eio, next-generation effect-based direct-style IO library.
</li>
<li>Collaborate with researchers to implement deterministic parallelism support in the Tezos protocol core.
</li>
</ul>
</li>
</ul>
<h2>Qualifications &amp; Experience</h2>
<p><em>(You don’t have to fill 100% of the qualifications to apply.)</em></p>
<ul>
<li>Excellent knowledge and hands-on experience developing parallel programs in any language. - Experience with the OCaml language, or other functional programming languages. - Experience in analysing benchmarks and application performance. - Track record of building production quality software. - Demonstrable open source contributions are a plus, but not required. - Good communication skills in English; English is the corporate language. - Experience of working in multidisciplinary teams.
</li>
</ul>
<h2>What we offer</h2>
<p>Nice office in Paris (Place de la Contrescarpe, Paris 5)</p>
<ul>
<li>Flexible working hours and possibility to work remotely - Supportive team environment with experienced Technical and Team Leads - Amazing health insurance for you and your family (Alan Blue) and paid parental leave - A “ticket restaurant” card and 50% of public transportation pass reimbursed
</li>
</ul>
<h2>Process</h2>
<p>Please send your CV and cover letter to apply@tarides.com. If shortlisted, you will have three online interviews starting with a general interview, followed by a technical interview, and finally an interview with the team.</p>
<p>We welcome applications from people of all backgrounds. We strive to create a representative, inclusive and friendly team, because we know that different experiences, perspectives and backgrounds make for a better workplace.</p>
|js}
  ; location = {js|Remote|js}
  ; company = {js|Tarides|js}
  ; company_logo = {js|https://tarides.com/static/logo_tarides-9616f2c71e224598e23ace051d0fab52.png|js}
  ; fullfilled = false
  };
 
  { id = 0
  ; title = {js|Quant Developer, Enterprise Products|js}
  ; link = {js|https://careers.bloomberg.com/job/detail/93825|js}
  ; description_html = {js|<p>Bloomberg's Quantitative Derivatives Library Architecture team is responsible for the infrastructure behind Bloomberg's derivatives pricing models, and supporting its risk management and derivatives valuation services. A large part of this infrastructure is written in OCaml, notably the BLAN language, a client-facing DSL for describing derivative contracts.</p>
<p>The team is looking for a developer with interest and experience in compiler design and implementation, especially in the context of functional programming languages. In this role, you will have the opportunity to participate in the development of BLAN, as well as the tooling and libraries around it. This could include implementing language features, such as gradual types or a new backend; developing tooling, such as a Jupyter kernel or a debugger; and writing a new library in BLAN, such as a lens library. Experience with quantitative analysis is not required.</p>
<h2>We'll trust you to:</h2>
<ul>
<li>Come up to speed on BLAN and the tooling around it - Design and implement new language features, tools or libraries - Pitch your own ideas for features, tools or libraries - Work independently and in collaboration with your team members
</li>
</ul>
<h2>You’ll need to:</h2>
<ul>
<li>Have 3+ years of academic or professional experience programming in a functional language, especially a statically typed one. - Have 1-2 years of academic or professional experience designing and implementing compilers or interpreters. - Have a MS or PhD in Computer Science, Computer Engineering, Math, or related field, or equivalent experience. - Have genuine enthusiasm for programming languages and functional programming! - Be able to come to the office for at least three days per week
</li>
</ul>
<h2>We'd love to see:</h2>
<ul>
<li>Extensive experience with OCaml, Haskell, F# or SML, and especially familiarity with their implementations. - Experience implementing static types systems, and especially type inference. - Familiarity with derivatives pricing models. - Experience with C++ or JavaScript.
</li>
</ul>
<h2>If this sounds like you:</h2>
<p>Apply if you think we're a good match and we'll get in touch with you to let you know next steps. In the meantime, check out http://www.bloomberg.com/professional.</p>
<p>We are an equal opportunity employer and value diversity at our company. We do not discriminate on the basis of race, religion, color, national origin, gender, sexual orientation, age, marital status, veteran status, or disability status.</p>
|js}
  ; location = {js|New York, NY|js}
  ; company = {js|Bloomberg|js}
  ; company_logo = {js|https://upload.wikimedia.org/wikipedia/commons/thumb/5/5d/New_Bloomberg_Logo.svg/1024px-New_Bloomberg_Logo.svg.png|js}
  ; fullfilled = false
  }]

