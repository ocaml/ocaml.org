---
title: Modeling Language for Finance
logo: success-stories/lexifi.png
background: /success-stories/lexifi-bg.jpg
theme: orange
synopsis: "Integrated end-user software solution to efficiently manage all types of structured investment products and provide superior client services."
url: https://www.lexifi.com/
---

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

One of the challenges LexiFi had to solve was how to make it as easy as possible for its users to enter new contracts into the system. This means developing solutions to *import* contracts described in other formats and used by existing platforms, such as SIX's [IBT](https://www.finextra.com/pressarticle/24905/six-swiss-exchange-introduces-universal-data-interface), Barclays's [COMET](https://barxis.barcap.com - [1 Client error: Failure when receiving data from the peer]), or plain PDF [termsheets](https://en.wikipedia.org/wiki/Term_sheet), the *lingua franca* of the financial industry.

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
