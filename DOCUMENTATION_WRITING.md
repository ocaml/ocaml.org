# How to Write Documentation

This document explains how to write documentation such as tutorials, guides, or recommendations to be hosted in OCaml.org. It's also meant to be used as a style guide to ensure consistency in things like grammar, formatting, capitalisation, and spelling across all OCaml.org documentation. 

In order to ensure consistency across documentation, a style guide like this is beneficial.

Use the [Diátaxis](https://diataxis.fr/) approach to documentation: Tutorials for learning, How-To Guides for goals, Explanation for understanding, and Reference for information. 

Apply the [*Spiral Learning*](https://en.wikipedia.org/wiki/Spiral_approach) approach in tutorials. This teaching method first creates a solid foundation of a topic. By starting with an overview, it gives the reader the context and general information. Subsequent sections and tutorials review the important foundational information and expands, going into more detail and giving examples. 

## Materials

- Reference. This includes the [OCaml Manual](https://ocaml.org/releases/latest/manual.html), the [opam manual](https://opam.ocaml.org/), and [Dune's documentation](https://dune.readthedocs.io/en/stable/). This is considered upstream material. Refer to the corresponding projects to propose changes in them.
- Tutorials
- Guides
- Recommended practices

## Audience

Our audience:
* Self-directed learners without a tutor
* Already know some programming basics (one other programming language)
* People who want to learn untainted functional programming (have seen functional patterns in other languages and are curious about “the real thing”)
* Likely a majority of consumers of libraries, hopefully some authors or people who turn into it
* English level B2 ideally

Not our audience:
* University students
* New to programming. We do not teach programming basics.

## Goals

1. Enable people to use OCaml for real projects / at the job / side projects
1. Get people who want to build and contribute to the ecosystem up to speed and building something good quickly
1. Help people learn untainted FP through learning a language
1. **Oddly Specific**: Enable people to do Advent of Code in OCaml.

## Our Key Values / Constraints:
- **Goals and Prerequisites**. Each tutorial begins with its objectives and ends with a section listing necessary prior knowledge, marked as "**Prerequisites:**". This part doesn't use section headings.
- **Avoid Overwhelming Choices**. Tutorials should guide learners on a straightforward path, avoiding multiple options. This makes the learning process smoother. Detailed choices can be included in additional references and guides.
- **Highlight Important Computer Science Terms**. Use italics for well-known terms, providing a visual hint that these are important concepts. Linking to Wikipedia for further explanation is an option.
- **Be Entertaining in Examples, Accurate in Text**. While it's essential to be clear and precise in the main text, using engaging and fun examples can make the material more appealing. This approach helps cater to different learning styles.
- **Start with Examples**. Present examples first, then explain them. This helps in understanding the application before the theory.
- **Clear Section Headings**. Make sure section titles clearly indicate their content. Just like a candy store displays its products openly, avoid vague titles and opt for ones that clearly reveal the content. This is also helpful for better display of search results.
- **Use B2 Level English**. This ensures the material is comprehensible to those who are not native English speakers.

## Common Phrases

- "Binding a value to a name" = declaring a variable
- `'a` is a type parameter called "alpha." It is not a _type variable_ (because the term _variable_ is a forbidden word).
- Pass a function as a value to another function as a parameter - not a "function value"
  

## Things to Avoid

1. Don't use the same letter for different things, i.e., when talking about a type parameter `'a`, don't have a name `a` nearby. In fact, since `a` can easily be confused with `'a` (alpha), start with `f` when using letters as parameters. 
1. Never use the term "variable," instead
    a. Names and values (binding = a value is bound to a name)
    b. Type parameter
1. Use “parameter” and “argument” appropriately.
1. Don't use math, computer science, or programming language theory terminology without reason and explanation.

## Formatting Technical Language
### OCaml Projects, Libraries, and Code

In an attempt to create consistent formatting across projects and their commands, please consider the following when using OCaml-specific names:

**NOTE:** All commands and libraries should be wrapped in `monospace`, formatted in Markdown by wrapping the command in backticks, aka a grave accent ( ` ), even when used in titles and headers.

**NOTE:** Although, we strive to capitalise proper nouns that refer to the program, service, or product itself, sometimes the creators/maintainers of the product prefers it written another way. Their preferred format is documented in this Style Guide below. 

**NOTE:** It’s important to follow the formatting below to ensure our documentation looks professional and consistent. Even though it isn’t aesthetically pleasing or grammatically correct, ***when the official name of a project is in all lowercase or*** `monospace`, ***they must be so everywhere, even at the beginning of sentences, in headers, and in titles***. 

1. **OCaml** is always written with the two first letters capitalised as shown. The only exceptions are for operators / libraries that are wrapped in `monospace` / code formatting. ****
    1. **OCamlFormat** also has the first two capitalised, as well as the F, unless it’s the command, in which case it would be wrapped in `monospace` in Markdown)**.**
    2. **OCamlFind**, same as ^^
    3. **OCaml Platform** as the proper name, and `ocaml-format` as the command
    4. **OCaml community**, with lowercase `c` for community.
2. **`odoc`**
    1. The proper way to write the name of this process is written as above, in all lowercase and wrapped in `monospace`.
    2. For the `odoc` command, it’s also written in all lower case: `odoc`. As in all commands, it should be wrapped in `monospace`, formatted in Markdown by wrapping the command in backticks, aka grave accent ( ` ).
    3. If you see it written odoc, ODOC, Odoc, or ODoc, please correct it.
    4. Replaces **OCamldoc**, always written as shown
3. **opam**
    1. The proper way to write the name of this compiler is as above in all lower case, without monospace, as confirmed by Thomas in March 2022 on Slack. The only exception is at the beginning of a sentence, which should be capitalised as Opam. In titles, all lower case: opam.
    2. If you see the name of the compiler written OPAM or Opam, please correct it.
    3. For the opam command, it’s also in all lower case: `opam`, and as in all commands, it should be wrapped in a code span, or *monospace*, formatted in Markdown by wrapping the command in backticks, aka grave accent (`), so it will look like this: `opam`
    4. Other package managers: **esy** (not Esy, unless at the beginning of sentence) and **Nix** (not nix). Both in monospace when talking about the command: `esy` and `nix`, all lower case.
    5. `opam-repository` is always in monospace.
    6. `opam-monorepo` is always in monospace.
4. **Dune**
    1. The preferred way to write the name of this system (not the command) as above with a capitalised first letter like in normal proper nouns: Dune.
    2. If you see it written dune or DUNE, please correct it.
    3. For the `dune` command, as in all commands, it should be wrapped in `monospace` (code block), format in Markdown by wrapping the command in backticks, aka grave accent (`)
    4. `duniverse` wrapped in monospace as shown. If you see duniverse, please correct it.
    5. `dune-project` should always be written in monospace like this.
    6. Dune documentation uses American spelling.
5. **Osmose**
    1. The preferred way to write the name is capitalised: Osmose
    2. You will often see it as OSMOSE, so please correct it when you do.
    3. This **Osmose** capitalisation preference was confirmed by Anil & Thomas in July 2021 via Slack DM
6. **Irmin** is always capitalised.
    1. **The** **Irmin** **`Index`** is written in monospace (surrounded by backticks) with a capital letter, so please correct it if you see Index or index or `index`.
    2. **Merkle proofs** or **Merkle trees**, Merkle is a proper noun, so it’s always capitalised, but proofs and trees are only capitalised in titles / headings / subheadings
7. **MirageOS** is always capitalised **with the OS** (not just Mirage), also capitalised as shown, no spaces.
    1. **Mr. MIME** should be written like this (as MIME is an acronym) when talking about the program and in monospace `mrmime` (all lower case) when talking about the library
    2. **SCoP** should be capitalised as shown here, as it’s an acronym.
    3. **DAPSI** in all caps, as it’s an acronym, too.
    4. **Unikernels**, capitalised only in titles and the beginnings of sentences (sentence case). 
8. **OCurrent**, **OCluster**, and **OBuilder,** rather than ocurrent or Ocurrent.
9. **OCaml LSP** is the name of the project, `ocaml-lsp` is the name of the repository on GitHub, and `ocamllsp` is the name of the CLI tool
10. **Jane Street** when talking about the company, but it’s “`janestreet` profile,” in monospace
11. **Js_of_ocaml** (abbr. **JSOO**), uses Sentence Case (capitalised at beginning of sentences, but not in the middle of sentences, like **js_of_ocaml**)) and **OCaml-Java**, capitalised as shown here, regardless of location in the sentence.
12.  Some other examples are below, always format as shown:
    1. **Algebraic effects,** takes sentence case: algebraic effects in the middle, capitalised only at the beginning of sentences and in titles.
    2. **Gospel,** rather than gospel
    3. **MDX**, rather than mdx or Mdx
    4. **Multicore**, rather than multicore, when talking about Multicore OCaml; but when talking about multicore in general, it’s follows sentence case.
    5. `ocaml-matrix` for the libraries working with the OCaml Matrix protocols, but **OCaml’s Matrix** when talking about the protocols themselves.
    6. **PPX,** rather than ppx or Ppx, unless talking about Ppxlib or the command/CLI result: `Ppxlib`, which should be in monospace.
    7. **Shared-memory parallelism and concurrency**, use sentence case
    8. **UTop,** rather than utop or Utop.
    9. (….list alphabetical & incomplete)
13. Although not aesthetically pleasing, when using code as headers, they should appear as they do in the code/command/library—usually all lowercase—and in `monospace`.

### Proper Nouns & Acronyms in Technology

The following are proper nouns or acronyms, so they’re always capitalised as shown, regardless of place in the sentence. 

- **AST**, as it stands for Abstract Syntax Tree
- **CLI,** stands for command line interface, so it should be in all caps; but when it’s written out, it’s **command line interface—**no hyphens, sentence case
- **Concurrency,** sentence case
- **Coq,** not coq or COQ. If talking about a library, command, or file, it will be monospace, possibly lowercase like `coq`
- **Cram tests**, not cram or CRAM
- **CST,** as it stands for ****Concrete Syntax Tree
- **Eio,** not eio, `Eio`, or EIO, as this isn’t the same EIO that stands for Enhanced Input/Output. If you see it written any way other than Eio, please correct it. Even when talking about a command, directory, library, etc., it still won’t be in monospace as libraries usually are. The official name of the library is **Eio.** No monospace. Same for **Meio**.
- **Effect handlers,** sentence case. Not Effect Handlers, unless emphasising it for OCaml 5, for example.
- **Emacs**, not emacs
- **`Findlib`** should be capitalised and in monospace since it’s the name of an OCaml library manager
- **Flambda**, not flambda.
- **GC** is always capitalised like this, as it’s an abbreviation for “garbage collection,” although when writing out the words, it uses sentence case.
- **Git** is always capitalised, except when writing Git commands (like, git commit).
- **GitHub** is capitalised like this, as that’s how the company writes it. GitHub repos are formatted in monospace, like `tezos-storage-bench`
- **GitLab**, capitalised like this.
- **Hangzhou** is a proper noun, so it’s always capitalised. It’s spelled with an ‘ou’ at the end instead of just an ‘o’ or just a ‘u’, which you’ll sometimes see.
- **HVT,** stands for hardware virtualised tender
- **Internet,** capitalised when a proper noun, the official thing itself, but lowercase when referring to a general internet or using as an adjective, like “my internet connection.”
- **Jbuilder,** not jbuilder, unless wrapping in `monospace` for library/tool/command
- **Linux, Unix,** as they’re proper nouns
- **Lwt,** not LWT or lwt, even though it stands for Light Weight Threads. Even when talking about the library, it’s Lwt, not `Lwt`.
- **LSP**, as it stands for Language Server Protocol
- **Merkle,** as in **Merkle tree** or **Merkle proof,** should be capitalised, as it’s a proper noun. When talking about the Merkle Proof API, it follows title case, as it’s a proper noun.
- **META files**, rather than metafiles, since it’s a file format generated by **Findlib**
- **Monolith,** proper noun
- **NGINX,** not Nginx or nginx
- **Open source** is two words (sentence case) when used as a concept (no hyphen), and **open-source** when used as an adjective, like ****open-source software.****
- **Parallelism,** sentence case
- **POSIX threads or Pthreads,** as formatted by Unix.
- **UID,** all caps as it stands for unique identifier.
- **YAML,** all caps since it’s an acronym
- (….list alphabetical & incomplete)

### Other Technical Language

There are several ways of writing these types of technical terms, but it’s good to establish some consistency across our documentation. The following shows the formatting usually used across the web, so in public-facing documentation, please strive to consistently use these words formatted as below (**use Sentence Case**, i.e., lowercase when not at the beginning of a sentence or in a title/header):

- **ARM64**, not arm64 or Arm64
- **B-tree,** rather than btree, hyphenated
- **Big-endian** and **little-endian systems**, hyphenated
- **Bytecode** is written as one word, rather than byte code.
- **Bytestream** is written as one word, rather than byte stream or byte-stream
- **Changelog** is written as one word, rather than change log.
- **Codebase** will be written as one word for consistency. If you see ‘code base’, please change it.
- **Cross-compatibility**, hyphenated in sentence case. If you see it as **cross compatibility**, please change it.
- **Cyber security**, as two words (British preference), whereas American English tends toward one word: cybersecurity. Since our documentation defaults to British spelling, we’ll use ****cyber security,**** sentence case.
- **Data types,** as two words. If you see datatypes, please correct it. Sentence case.
- **Filename,** instead of file name, when talking about a particular filename, like "this filename and that filename". Split them into two words (**file name**) when discussing different types of names, like "file names and directory names"). It would always be two words in cases like “a file named *dune-file”.*
- **File system** is two words, however.
- **Frontend** and **backend,** rather than separate words when used as a noun. As an adjective, it’s hyphenated, like **front-end developer.**
- **I/O,** stands for input/output, so should be capitalised with a slash in between. If you see io or IO, please correct, unless part of a link or wrapped in monospace
- **Lock file,** two words rather than lockfile.
- **Man pages**, rather than manpages. Depending on sentence structure, this can be awkward. Consider wrapping it in italics, bold, or monospace for it to stand out as a singular thing.
- **Memoization**, rather than the usual `s` used in British English, as it’s the spelling of a particular function.
- **Metadata,** one word rather than meta data.
- **MinGW-64,** not mingw-64 or Mingw-64
- **Multi-user***rather than multiuser as an adjective. **Multiuser** as a noun.
- **Nameserver,** rather than name server.
- **Pattern matching** is written as two words****,**** but it’s **pattern-matching** when used as an adjective. If you see it hyphenated outside this exception, please correct it.
- **Prestate, precondition, postcondition—**without hyphens like pre-state, etc., even when the next letter is also an `e`, like preemptive.
- **Rerun(ning), rereleasing,** and **redeploying,** no hyphen needed, even in cases when the next letter is an `e`, like reemerge, reenforce, etc.
- **Runtime,** one word when describing the final step in a program’s execution, but it is written as two words (****run time****) when describing the actual time it took to run.
- **S-expression**, capitalised rather than s-expression.
- **Source tree —** instead of sourcetree or Sourcetree, like the app, similarly, it’s **source code** rather than sourcecode.
- **Startup,** rather than start-up
- **Subdirectory** — no hyphen (as in sub-directory), same for **subtree** and other **sub** prefixes. When in doubt, check with Google.
- **Thread-safe,** rather than threadsafe or thread safe
- **Toolsuite**, one word, rather than tool suite
- **Toplevel(s),** one word rather than top level, when talking about OCaml toplevel; however, when talking about the global environment, it’s hyphenated like ****top-level.****
- ****Type checking**** is written as two words, unless it’s used as an adjective, like **type-checking issues**. If you see it hyphenated outside this exception, please correct it.
- **Type-safe language** (as adjective, hyphenated), not typesafe or type safe. **Type safe or type safety** (two words) when talking about the concept/feature. Sentence case.
- **VSCode,** instead of VS Code or Vscode. Short for Visual Studio Code.
- **Web Server**, two words. If you see webserver or web-server, please change it. Sentence case.
- (….list alphabetical & incomplete)


## General Formatting 

Please don't worry about this too much, as a technical write will review any new documentation or changes to catch these types of things. It's included here for reference, if interested. 

### Active & Unnecessary Words
Active sentences employ a clear subject that performs an action with a robust verb (e.g., Mary baked the cake.), as opposed to weak verbs such as *occur* and *happen.* Passive sentences typically incorporate '***to be'*** verbs (is, are, were, was, etc.), where the subject undergoes the action (e.g., he cake was baked by Mary). Although it's not possible to avoid all **to be** verbs, try to minimise them when possible. 

The sentences below highlight issues and provide suggestions for improvement:

- Read-only access is provided by MutableInput. [Passive voice] Improved: **MutableInput provides read-only access.**
- Compiler errors occur when you leave off a semicolon at the end of a statement. [Weak verbs *occur* with extraneous words*.*] Improved: **Compilers return errors when you omit a semicolon at the end of a statement.**
- There is a variable called `met-trick` that stores the current accuracy. [Extraneous words “there is” and “that” clause.] Improved: **The `met-trick` variable stores the current accuracy.**
- Python was invented by Guido van Rossum in the twentieth century. [Passive voice] Improved: **Guido van Rossum invented Python in the twentieth century.**
- The exception occurs when dividing by zero. [Weak verb *occurs]* Improved: **Dividing by zero raises the exception.**

One of the biggest challenges for native French speakers is to eliminate unnecessary prepositional phrases, especially when using with the possessive. In French, the syntax is "the car of Susan," whereas in English, it would be Susan's car. When prepositional phrases (e.g. those starting with by, for, in, of, on, etc.) are strung together, it makes for clumsy and awkward sentences. For example: "She went *on* a road trip *across* the mountains *to* take pictures." This sentence has three prepositional phrases back to back. You can tighten the syntax by removing at least one prepositional phrase, like this: "She took pictures on her roadtrip across the mountains."

Although a writer's adherence to these principles and utilisation of correct punctuation may not always be consciously noticed by readers, such awareness can enhance clarity and contribute to a more enjoyable reading experience. 

### Spelling & Grammar

- [Grammar Help at Grammarly](https://www.grammarly.com/blog/category/handbook/)
- **Punctuation Preferences:**
    - Oxford (serial) comma [We bought bread, milk, and peanut butter], so there is a final comma before the conjunction.
    - Single space after a `.` period (full stop).
    - Always use `'` for singular names/nouns ending in `s` and for plural nouns ending in `s` (e.g., Thomas’ and Companies’). Although the grammatically correct way to say and spell singular nouns ending in `s` is “Thomas’s”, it does look weird. It’s the consensus to treat every `s` as if it were a plural possessive, so instead write "Thomas'." **Whenever possible, rephrase the sentence to avoid it completely. Instead of “Tarides’ engineers” write “the Tarides engineers” or “the engineers at Tarides.”**
    - Place punctuation inside of quotation marks: Irmin is a “OCaml library for building mergeable, branchable distributed data stores.” (not...stores”.)
    - Use **en dashes `–`** surrounded by spaces for 'asides' (as an alternative, you can use parentheses). Example: OCaml Multicore is – as my grandmother would say – an excellent upgrade.
    - [Cambridge Dictionary: Punctuation](https://dictionary.cambridge.org/grammar/british-grammar/punctuation)
    - [Differences in British & American](https://www.unr.edu/writing-speaking-center/student-resources/writing-speaking-resources/british-american-english), please use the British spelling. See below.
    - [Another ^^](https://www.thepunctuationguide.com/british-versus-american-style.html)
- **Spelling**
    - [British spelling](http://www.tysto.com/uk-us-spelling-list.html)
        - ise rather than -ize (organise vs organize)
        - our, not or (flavour vs flavor)
        - yse, not yze (analyse vs analyze)
        - Double L : travelling vs traveling
        - ae/oe vs e (manoeuvre vs maneuver)
        - ence, not -ense (licence vs license)
        - ogue, not og (catalogue vs catalog)
        - learnt, not learned
        - focussed / focusses (instead of the single s: focused / focuses)
        - vs, not vs. as in American English. Same with Dr, Mr, Ms, Mrs instead of Dr., Mr., Ms., Mrs.
        - Although programme is traditionally the UK spelling, **program** is more common.
    
- **Capitalisation**
    - Capitalise every word (except “little words” like of, and, or, etc.) in titles, aka “[Title Case](https://apastyle.apa.org/style-grammar-guidelines/capitalization/title-case).” Strangely, it is correct to capitalise “with” in a title.
    - Use Title Case in headings / subheadings. Try to keep them under 7 words.
    - Capitalise the first letter of bullet points, aka “[Sentence Case](https://apastyle.apa.org/style-grammar-guidelines/capitalization/sentence-case).” However, if it’s not a complete sentence in the bullet point, don’t use a period (full stop) unless it’s followed by other sentences. 


