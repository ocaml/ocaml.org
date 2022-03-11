
type t =
  { title : string
  ; slug : string
  ; logo : string
  ; background : string
  ; theme : string
  ; synopsis : string
  ; url : string
  ; body_md : string
  ; body_html : string
  }
  
let all = 
[
  { title = {js|Peta-byte scale web crawler|js}
  ; slug = {js|peta-byte-scale-web-crawler|js}
  ; logo = {js|/success-stories/ahrefs.svg|js}
  ; background = {js|/success-stories/ahrefs-bg.jpg|js}
  ; theme = {js|blue|js}
  ; synopsis = {js|Ahrefs crawls the entire internet constantly to collect, process, and store data to build an all-in-one SEO toolkit.|js}
  ; url = {js|https://ahrefs.com/|js}
  ; body_md = {js|
Ahrefs develops custom distributed petabyte-scale storage and runs an internet-wide crawler to index the entire Web. The company also builds various analytical services for end users. Ahrefs’s data processing system uses OCaml as its primary language, which currently processes up to 6 billion pages a day, and they also use OCaml for their website’s backend. Ahrefs has a multinational team with roots in the Ukraine, an office in Singapore, and remote collaborators all around the world.

## Challenge

Ahrefs runs with a relatively small team compared to the size of the task at hand. Indexing the web is very expensive and requires considerable resources, both humans and machines. Turning petabytes of data into something intelligible on the fly is also a big challenge. It’s necessary to build processes running fast, 24/7, with as little maintenance as possible and scarce human resources.

## Solution

Ahrefs went with OCaml for data processing at the scale of the Web. The company was in its infancy with a limited number of employees and little financial resources. The language provided a combination of qualities hard to find elsewhere:
- Native compilation
- High-level types for clear expression and compact code
- Solid and stable compiler
- Empathy for industrial users

As the company grew and expanded its service offerings, they took the opportunity to write its website in OCaml (native OCaml for the backend, ReasonML for the frontend). This bold choice gave them a unique advantage. Thanks to the types shared across the entire stack, they can safely reason about data, from creation to final consumption.

## Results

Ahrefs turns billions of websites into data, first stored into over 100PB of storage and then into valuable information for tens of thousands of customers worldwide. As the internet is becoming an increasingly competitive place, Ahrefs provides a vital service for companies running a business on the web. Ahrefs managed to face this challenge while keeping the company lean and efficient.
|js}
  ; body_html = {js|<p>Ahrefs develops custom distributed petabyte-scale storage and runs an internet-wide crawler to index the entire Web. The company also builds various analytical services for end users. Ahrefs’s data processing system uses OCaml as its primary language, which currently processes up to 6 billion pages a day, and they also use OCaml for their website’s backend. Ahrefs has a multinational team with roots in the Ukraine, an office in Singapore, and remote collaborators all around the world.</p>
<h2>Challenge</h2>
<p>Ahrefs runs with a relatively small team compared to the size of the task at hand. Indexing the web is very expensive and requires considerable resources, both humans and machines. Turning petabytes of data into something intelligible on the fly is also a big challenge. It’s necessary to build processes running fast, 24/7, with as little maintenance as possible and scarce human resources.</p>
<h2>Solution</h2>
<p>Ahrefs went with OCaml for data processing at the scale of the Web. The company was in its infancy with a limited number of employees and little financial resources. The language provided a combination of qualities hard to find elsewhere:</p>
<ul>
<li>Native compilation
</li>
<li>High-level types for clear expression and compact code
</li>
<li>Solid and stable compiler
</li>
<li>Empathy for industrial users
</li>
</ul>
<p>As the company grew and expanded its service offerings, they took the opportunity to write its website in OCaml (native OCaml for the backend, ReasonML for the frontend). This bold choice gave them a unique advantage. Thanks to the types shared across the entire stack, they can safely reason about data, from creation to final consumption.</p>
<h2>Results</h2>
<p>Ahrefs turns billions of websites into data, first stored into over 100PB of storage and then into valuable information for tens of thousands of customers worldwide. As the internet is becoming an increasingly competitive place, Ahrefs provides a vital service for companies running a business on the web. Ahrefs managed to face this challenge while keeping the company lean and efficient.</p>
|js}
  };
 
  { title = {js|Sensor analytics and automation platform for sustainable agriculture|js}
  ; slug = {js|sensor-analytics-and-automation-platform-for-sustainable-agriculture|js}
  ; logo = {js|/success-stories/hyper.png|js}
  ; background = {js|/success-stories/hyper-bg.jpg|js}
  ; theme = {js|green|js}
  ; synopsis = {js|Hyper Uses OCaml to Build an IoT System for High-Performing Farms.|js}
  ; url = {js|https://www.hyper.ag/|js}
  ; body_md = {js|
Hyper.ag provides a scalable sensor analytics and automation infrastructure for indoor and vertical farming. With their product, farmers continuously optimise the crop quality and reduce operational costs by getting access to actionable growth insights and climate control profiles without a dedicated engineering team.

## Challenge

Since the inception of the company, Hyper has had very unique product requirements to support deployments that manage thousands of low-power network devices and compute real-time metrics across a distributed server infrastructure:

1. Reliable implementation – customers expect the system to work without failures, as any interruptions to the service may have a direct impact on their business operations.
2. Controlled resource usage – deploying software on devices with constrained resources, where low memory profile and computation efficiency are important to support more advanced capabilities.
3. Offline-first deployments – the architecture of the distributed analytics and automation system requires precise state replication to support offline deployments for customers with farms in remote locations. It’s critical that this software operates reliably without any external services.
4. Developer productivity – most importantly, Hyper is a startup and needs to continuously iterate on product features with fast time-to-market and maintain a high degree of confidence in their work.


## Solution

While not being commonly regarded as a language or platform for IoT and embedded programming, OCaml has helped satisfy Hyper’s requirements in a way that’s unique to the strongly-typed functional paradigm, as it offers strong abstraction boundaries with declarative interfaces and numerous opportunities for optimisation.

Hyper leverages OCaml to design a product that is both extremely adaptable and offers a high degree of safety. While iterating their system design, they were able to rewrite several critical components numerous times with remarkable speed and without compromising reliability.


## Results

OCaml’s type system proved to be an excellent tool to express invariants and characteristics of every sensor and actuators that belongs to their IoT platform. This allows them to perform code generation for devices with constrained resources to achieve maximum performance, low network overhead and a high degree of flexibility when making changes to the system.

In addition to the robust language and a growing ecosystem of high-quality libraries, Hyper deeply values the commitment to backwards compatibility and long-term support promised by OCaml on their journey to build a lasting and impactful product.
|js}
  ; body_html = {js|<p>Hyper.ag provides a scalable sensor analytics and automation infrastructure for indoor and vertical farming. With their product, farmers continuously optimise the crop quality and reduce operational costs by getting access to actionable growth insights and climate control profiles without a dedicated engineering team.</p>
<h2>Challenge</h2>
<p>Since the inception of the company, Hyper has had very unique product requirements to support deployments that manage thousands of low-power network devices and compute real-time metrics across a distributed server infrastructure:</p>
<ol>
<li>Reliable implementation – customers expect the system to work without failures, as any interruptions to the service may have a direct impact on their business operations.
</li>
<li>Controlled resource usage – deploying software on devices with constrained resources, where low memory profile and computation efficiency are important to support more advanced capabilities.
</li>
<li>Offline-first deployments – the architecture of the distributed analytics and automation system requires precise state replication to support offline deployments for customers with farms in remote locations. It’s critical that this software operates reliably without any external services.
</li>
<li>Developer productivity – most importantly, Hyper is a startup and needs to continuously iterate on product features with fast time-to-market and maintain a high degree of confidence in their work.
</li>
</ol>
<h2>Solution</h2>
<p>While not being commonly regarded as a language or platform for IoT and embedded programming, OCaml has helped satisfy Hyper’s requirements in a way that’s unique to the strongly-typed functional paradigm, as it offers strong abstraction boundaries with declarative interfaces and numerous opportunities for optimisation.</p>
<p>Hyper leverages OCaml to design a product that is both extremely adaptable and offers a high degree of safety. While iterating their system design, they were able to rewrite several critical components numerous times with remarkable speed and without compromising reliability.</p>
<h2>Results</h2>
<p>OCaml’s type system proved to be an excellent tool to express invariants and characteristics of every sensor and actuators that belongs to their IoT platform. This allows them to perform code generation for devices with constrained resources to achieve maximum performance, low network overhead and a high degree of flexibility when making changes to the system.</p>
<p>In addition to the robust language and a growing ecosystem of high-quality libraries, Hyper deeply values the commitment to backwards compatibility and long-term support promised by OCaml on their journey to build a lasting and impactful product.</p>
|js}
  };
 
  { title = {js|Large scale trading system|js}
  ; slug = {js|large-scale-trading-system|js}
  ; logo = {js|/success-stories/janestreet.png|js}
  ; background = {js|/success-stories/janestreet-bg.jpg|js}
  ; theme = {js|cyan|js}
  ; synopsis = {js|Jane Street is a quantitative trading firm and liquidity provider with a unique focus on technology and collaborative problem solving.|js}
  ; url = {js|https://janestreet.com/technology/|js}
  ; body_md = {js|
Jane Street, a quantitative trading firm with offices in London, New York, Hong Kong, and Amsterdam, chose OCaml because its rich type system improves the quality of their code and catches bugs early.

Jane Street is the largest commercial user of OCaml, using it for everything from research tools to trading systems to systems infrastructure to accounting systems. Software built in OCaml helps them safely trade billions of dollars each day. OCaml's powerful static analysis tools help enforce important invariants so that their programmers can focus on quickly adapting to ever-changing market conditions.

Jane Street has over five hundred OCaml programmers and over 30 million lines of OCaml. Nearly a million lines of their code are open source, and they've created key parts of the open-source OCaml ecosystem, like Dune, the community's de facto build system; Core, an alternative standard library; and Async, a cooperative concurrency library. You can learn more by checking out their [tech blog](https://blog.janestreet.com).

## Challenge

For the past 20+ years, Jane Street has used OCaml as their single-tool solution. When deciding on a programming language, they wanted something that was fast yet efficient, caught bugs early, and that they could use both in critical trading systems and in everyday utilities.

## Solution

Jane Street found that OCaml gave them the best of compiled and dynamic languages. Thanks to an expressive type system with powerful inference, it's concise, safe, and performant. Large codebases built in dynamic languages can quickly become unmanageable; OCaml's type system, deeply integrated into the editor, makes Jane Street's large software systems more legible and easier to maintain. As an added bonus, OCaml tends to attract some of the best programmers, and leads interns to want to join the company full time; using OCaml has been a boon for tech recruiting.

In short, OCaml helps Jane Street quickly adapt to changing market conditions, and move smoothly from prototypes to production systems.
|js}
  ; body_html = {js|<p>Jane Street, a quantitative trading firm with offices in London, New York, Hong Kong, and Amsterdam, chose OCaml because its rich type system improves the quality of their code and catches bugs early.</p>
<p>Jane Street is the largest commercial user of OCaml, using it for everything from research tools to trading systems to systems infrastructure to accounting systems. Software built in OCaml helps them safely trade billions of dollars each day. OCaml's powerful static analysis tools help enforce important invariants so that their programmers can focus on quickly adapting to ever-changing market conditions.</p>
<p>Jane Street has over five hundred OCaml programmers and over 30 million lines of OCaml. Nearly a million lines of their code are open source, and they've created key parts of the open-source OCaml ecosystem, like Dune, the community's de facto build system; Core, an alternative standard library; and Async, a cooperative concurrency library. You can learn more by checking out their <a href="https://blog.janestreet.com">tech blog</a>.</p>
<h2>Challenge</h2>
<p>For the past 20+ years, Jane Street has used OCaml as their single-tool solution. When deciding on a programming language, they wanted something that was fast yet efficient, caught bugs early, and that they could use both in critical trading systems and in everyday utilities.</p>
<h2>Solution</h2>
<p>Jane Street found that OCaml gave them the best of compiled and dynamic languages. Thanks to an expressive type system with powerful inference, it's concise, safe, and performant. Large codebases built in dynamic languages can quickly become unmanageable; OCaml's type system, deeply integrated into the editor, makes Jane Street's large software systems more legible and easier to maintain. As an added bonus, OCaml tends to attract some of the best programmers, and leads interns to want to join the company full time; using OCaml has been a boon for tech recruiting.</p>
<p>In short, OCaml helps Jane Street quickly adapt to changing market conditions, and move smoothly from prototypes to production systems.</p>
|js}
  };
 
  { title = {js|Modeling Language for Finance|js}
  ; slug = {js|modeling-language-for-finance|js}
  ; logo = {js|/success-stories/lexifi.png|js}
  ; background = {js|/success-stories/lexifi-bg.jpg|js}
  ; theme = {js|orange|js}
  ; synopsis = {js|Integrated end-user software solution to efficiently manage all types of structured investment products and provide superior client services.|js}
  ; url = {js|https://www.lexifi.com/|js}
  ; body_md = {js|
[LexiFi](https://www.lexifi.com/) was founded in the 2000s, taking the ideas of [this paper](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/07/contracts-icfp.pdf) and developing them into an industrial-strength offer. Today, [LexiFi](https://www.lexifi.com/) is a leading provider of software solutions used to manage derivative contracts.

Since its inception, [LexiFi's](https://www.lexifi.com/) software has been written in OCaml. Originally SML/NJ had also been considered as a potential choice, but OCaml was selected mainly due to the quality of its FFI (enabling easy access to existing C libraries) and the possibility of using standard build tools such as `make`.

In hindsight, the bet on OCaml turned out to be an excellent one. It has allowed [LexiFi](https://www.lexifi.com/) to develop software with unsurpassed agility and robustness. OCaml enabled a small group of developers to drive a large codebase over two decades of evolutions while keeping code simple and easy-to-read. It also efficiently solves an ever-growing set of problems for our clients.

Lastly, excellent cross-system support of the OCaml toolchain has been a key advantage in simplifying software development and deployment across Unix, Windows, and the Web (thanks to the excellent [`js_of_ocaml`](https://github.com/ocsigen/js_of_ocaml)).

All in all, OCaml is a beautiful marriage of pragmatism, efficiency, and solid theoretical foundations, and this combination fits perfectly with the needs and vision of [LexiFi](https://www.lexifi.com/).

## Case Study: Contract Algebra

### Challenge

One of the key technical building blocks of [LexiFi's](https://www.lexifi.com/) software stack is its **contract algebra**. This is a domain-specific language (DSL) with formal semantics used to describe complex derivative contracts.

### Solution

As an outgrowth of the combinator language described in the [paper](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/07/contracts-icfp.pdf), this language plays a key role throughout. Once a contract is entered into the system, it is represented by an algebraic term. This term can then be stored, converted, translated, communicated, and transformed across a variety of formats and for any number of purposes.

Just as a single example among many, one way the contract algebra is transformed is by **compiling** its terms to a low-level **bytecode** representation for very fast Monte Carlo simulations that calculate contract prices and other quantities of interest.

### Results

OCaml shines at these kinds of tasks, which are its bread and butter. The resulting code is not only efficient, but also robust, clear, and simple.

## Case Study: Contract Import and Exchange

### Challenge

One of the challenges LexiFi had to solve was how to make it as easy as possible for its users to enter new contracts into the system. This means developing solutions to *import* contracts described in other formats and used by existing platforms, such as SIX's [IBT](https://www.finextra.com/pressarticle/24905/six-swiss-exchange-introduces-universal-data-interface), Barclays's [COMET](https://barxis.barcap.com/CH/2/en/static/cometintro.app), or plain PDF [termsheets](https://en.wikipedia.org/wiki/Term_sheet), the *lingua franca* of the financial industry.

### Solution

In each one of these cases, LexiFi has developed small **combinator** libraries to parse, analyze, and convert these imported documents into LexiFi's internal representation based on the **contract algebra**. They do this by leveraging the existing mature libraries from the OCaml ecosystem, such as [`camlpdf`](https://github.com/johnwhitington/camlpdf) to parse PDF documents, [`xmlm`](https://erratique.ch/software/xmlm) to parse XML, and others.

### Results

Once again, OCaml's excellent facilities for symbolic processing has made developing these connectors a rather enjoyable enterprise, resulting in code that is easy to maintain and evolve over time.

## Case Study: UI Construction

### Challenge
Since LexiFi's end users are mostly financial operatives without special programming experience, it's crucial to offer simple and clear user interfaces to our software.

### Solution

LexiFi uses the **meta-programming** facilities of OCaml to automatically derive user interfaces directly from OCaml code declarations, making it seamless for developers to write code and its associated user interface at the same time. This allows an extremely agile development style where the user interface can evolve in tandem with the code. This ability to "tie" the user interface to the code means that the two never get out of sync, and a whole class of bugs are just ruled out by construction.

Furthermore, having described the user interface in terms of OCaml code means that LexiFi can retarget this description to different **backends**, producing Web and native versions of the same UI from a single description.

### Results

This approach greatly increases the capacity to quickly develop new features to the point that a single developer can over the course of a day set the foundations of a new feature, together with a corresponding user interface, both on the Desktop and the Web, while never taking their eyes off the key business logic. Not a mean feat!
|js}
  ; body_html = {js|<p><a href="https://www.lexifi.com/">LexiFi</a> was founded in the 2000s, taking the ideas of <a href="https://www.microsoft.com/en-us/research/wp-content/uploads/2016/07/contracts-icfp.pdf">this paper</a> and developing them into an industrial-strength offer. Today, <a href="https://www.lexifi.com/">LexiFi</a> is a leading provider of software solutions used to manage derivative contracts.</p>
<p>Since its inception, <a href="https://www.lexifi.com/">LexiFi's</a> software has been written in OCaml. Originally SML/NJ had also been considered as a potential choice, but OCaml was selected mainly due to the quality of its FFI (enabling easy access to existing C libraries) and the possibility of using standard build tools such as <code>make</code>.</p>
<p>In hindsight, the bet on OCaml turned out to be an excellent one. It has allowed <a href="https://www.lexifi.com/">LexiFi</a> to develop software with unsurpassed agility and robustness. OCaml enabled a small group of developers to drive a large codebase over two decades of evolutions while keeping code simple and easy-to-read. It also efficiently solves an ever-growing set of problems for our clients.</p>
<p>Lastly, excellent cross-system support of the OCaml toolchain has been a key advantage in simplifying software development and deployment across Unix, Windows, and the Web (thanks to the excellent <a href="https://github.com/ocsigen/js_of_ocaml"><code>js_of_ocaml</code></a>).</p>
<p>All in all, OCaml is a beautiful marriage of pragmatism, efficiency, and solid theoretical foundations, and this combination fits perfectly with the needs and vision of <a href="https://www.lexifi.com/">LexiFi</a>.</p>
<h2>Case Study: Contract Algebra</h2>
<h3>Challenge</h3>
<p>One of the key technical building blocks of <a href="https://www.lexifi.com/">LexiFi's</a> software stack is its <strong>contract algebra</strong>. This is a domain-specific language (DSL) with formal semantics used to describe complex derivative contracts.</p>
<h3>Solution</h3>
<p>As an outgrowth of the combinator language described in the <a href="https://www.microsoft.com/en-us/research/wp-content/uploads/2016/07/contracts-icfp.pdf">paper</a>, this language plays a key role throughout. Once a contract is entered into the system, it is represented by an algebraic term. This term can then be stored, converted, translated, communicated, and transformed across a variety of formats and for any number of purposes.</p>
<p>Just as a single example among many, one way the contract algebra is transformed is by <strong>compiling</strong> its terms to a low-level <strong>bytecode</strong> representation for very fast Monte Carlo simulations that calculate contract prices and other quantities of interest.</p>
<h3>Results</h3>
<p>OCaml shines at these kinds of tasks, which are its bread and butter. The resulting code is not only efficient, but also robust, clear, and simple.</p>
<h2>Case Study: Contract Import and Exchange</h2>
<h3>Challenge</h3>
<p>One of the challenges LexiFi had to solve was how to make it as easy as possible for its users to enter new contracts into the system. This means developing solutions to <em>import</em> contracts described in other formats and used by existing platforms, such as SIX's <a href="https://www.finextra.com/pressarticle/24905/six-swiss-exchange-introduces-universal-data-interface">IBT</a>, Barclays's <a href="https://barxis.barcap.com/CH/2/en/static/cometintro.app">COMET</a>, or plain PDF <a href="https://en.wikipedia.org/wiki/Term_sheet">termsheets</a>, the <em>lingua franca</em> of the financial industry.</p>
<h3>Solution</h3>
<p>In each one of these cases, LexiFi has developed small <strong>combinator</strong> libraries to parse, analyze, and convert these imported documents into LexiFi's internal representation based on the <strong>contract algebra</strong>. They do this by leveraging the existing mature libraries from the OCaml ecosystem, such as <a href="https://github.com/johnwhitington/camlpdf"><code>camlpdf</code></a> to parse PDF documents, <a href="https://erratique.ch/software/xmlm"><code>xmlm</code></a> to parse XML, and others.</p>
<h3>Results</h3>
<p>Once again, OCaml's excellent facilities for symbolic processing has made developing these connectors a rather enjoyable enterprise, resulting in code that is easy to maintain and evolve over time.</p>
<h2>Case Study: UI Construction</h2>
<h3>Challenge</h3>
<p>Since LexiFi's end users are mostly financial operatives without special programming experience, it's crucial to offer simple and clear user interfaces to our software.</p>
<h3>Solution</h3>
<p>LexiFi uses the <strong>meta-programming</strong> facilities of OCaml to automatically derive user interfaces directly from OCaml code declarations, making it seamless for developers to write code and its associated user interface at the same time. This allows an extremely agile development style where the user interface can evolve in tandem with the code. This ability to &quot;tie&quot; the user interface to the code means that the two never get out of sync, and a whole class of bugs are just ruled out by construction.</p>
<p>Furthermore, having described the user interface in terms of OCaml code means that LexiFi can retarget this description to different <strong>backends</strong>, producing Web and native versions of the same UI from a single description.</p>
<h3>Results</h3>
<p>This approach greatly increases the capacity to quickly develop new features to the point that a single developer can over the course of a day set the foundations of a new feature, together with a corresponding user interface, both on the Desktop and the Web, while never taking their eyes off the key business logic. Not a mean feat!</p>
|js}
  }]

