# How to Write Documentation

This document explains how to write documentation such as tutorials, guides, or recommendations to be hosted in OCaml.org. It's also meant to be used as a style guide to ensure consistency in things like grammar, formatting, capitalisation, and spelling across all OCaml.org documentation.

Apply the [*Spiral Learning*](https://en.wikipedia.org/wiki/Spiral_approach) approach in tutorials. This teaching method first creates a solid foundation of a topic. By starting with an overview, it gives the reader the context and general information. Subsequent sections and tutorials review the important foundational information and expands, going into more detail and giving examples.

## Materials

- References, e.g.:
  - [OCaml Language Manual](https://ocaml.org/releases/latest/manual.html). You can contribute to [its source on GitHub](https://github.com/ocaml/ocaml/tree/trunk/manual).
  - [opam manual](https://opam.ocaml.org/). You can contribute to [its repository](https://github.com/ocaml/opam).
  - [Dune's documentation](https://dune.readthedocs.io/en/stable/). You can contribute to [its docs folder](https://github.com/ocaml/dune/tree/main/doc).
- Tutorials
- Guides
- Recommended practices

## Audience

Anytime one contributes to the OCaml.org documentation, it's important to keep the target audience in mind. For example, if writing a tutorial for programmers new to OCaml, you want to ensure the examples are simple and straightforward so as not to overwhelm them with too much detail while starting their learning journey. For more advanced users, adjust the tone and examples accordingly.

**Our audience:**
- Self-directed learners without a tutor
- Already know some programming basics (one other programming language)
- Likely a majority of consumers of libraries, hopefully some authors or people who turn into it
- English level B2 ideally

**Not our audience:**
- University students
- New to programming. We do not teach programming basics.

## Goals

Especially since the release of OCaml 5.0 with Multicore support, perhaps our biggest goal is to increase the adoption of OCaml. In order to reach this goal, it's essential to have current, consistent, and comprehensive documentation.

1. Enable people to use OCaml for real projects / at the job / side projects
1. Get people who want to build and contribute to the ecosystem up to speed and building something good quickly
1. **Oddly Specific**: Enable people to do Advent of Code in OCaml.

## Our Key Values / Constraints

- **Goals and Prerequisites**. Each tutorial begins with its objectives, so that people know what they will learn about.
- **Avoid Overwhelming Choices**. Tutorials should guide learners on a straightforward path, avoiding multiple options. This makes the learning process smoother. Detailed choices can be included in additional references and guides.
- **Highlight Important Computer Science Terms**. Use italics for well-known terms, providing a visual hint that these are important concepts. Linking to Wikipedia for further explanation is an option.
- **Be Entertaining in Examples, Accurate in Text**. While it's essential to be clear and precise in the main text, using engaging and fun examples can make the material more appealing. This approach helps cater to different learning styles.
- **Start with Examples**. Present examples first, then explain them. This helps in understanding the application before the theory.
- **Clear Section Headings**. Make sure section titles clearly indicate their content. Just like a candy store displays its products openly, avoid vague titles and opt for ones that clearly reveal the content. This is also helpful for better display of search results. Use title case (see General Formatting section below).
- **Use B2 Level English**. This ensures the material is comprehensible to those who are not native English speakers.

## Common Phrases

- "Binding a value to a name" = declaring a variable
- `'a` is a type parameter called "alpha." It is not a *type variable* (because the term *variable* is a forbidden word).
- Pass a function as a value to another function as a parameter - not a "function value"
  
## Things to Avoid

1. Don't use the same letter for different things, i.e., when talking about a type parameter `'a`, don't have a name `a` nearby. In fact, since `a` can easily be confused with `'a` (alpha), start with `f` when using letters as parameters.
1. Never use the term "variable," instead
    a. Names and values (binding = a value is bound to a name)
    b. Type parameter
1. Use “parameter” and “argument” appropriately. Parameters occur in function declarations. Arguments are values that functions are applied to.
1. Don't use math, computer science, or programming language theory terminology without reason and explanation.

## Writing, Grammar, and Spelling

Please don't worry about this too much, as a technical writer will review any new documentation or changes to catch these types of things. It's included here for reference, if interested.

### Tone & POV

We're aiming for a relatively casual tone in these tutorials and other documentation. This means that it should read like you're speaking directly to the reader rather than an academic tone. To this end, it is acceptable to use second person (you), sparingly.

It's also okay to use first person plural (we, us), sparingly, but don't use the first person singular (I, me), as there isn't an author byline for the reader to know who "I" is. Using "we" can be helpful to write active sentences (more below).

### Active Voice & Unnecessary Words

Active sentences employ a clear subject that performs an action with a robust verb (e.g., Mary baked the cake.), as opposed to weak verbs such as *occur* and *happen.* Passive sentences typically incorporate '***to be'*** verbs (is, are, were, was, etc.), where the subject undergoes the action (e.g., he cake was baked by Mary). Although it's not possible to avoid all **to be** verbs, try to minimise them when possible.

The sentences below highlight issues and provide suggestions for improvement:

- Read-only access is provided by MutableInput. [Passive voice] Improved: **MutableInput provides read-only access.**
- Compiler errors occur when you leave off a semicolon at the end of a statement. [Weak verbs *occur* with extraneous words*.*] Improved: **Compilers return errors when you omit a semicolon at the end of a statement.**
- There is a variable called `met-trick` that stores the current accuracy. [Extraneous words “there is” and “that” clause.] Improved: **The `met-trick` variable stores the current accuracy.**
- Caml was invented by Guy Cousineau in the twentieth century. [Passive voice] Improved: **Guy Cousineau invented Caml in the twentieth century.**
- The exception occurs when dividing by zero. [Weak verb *occurs]* Improved: **Dividing by zero raises the exception.**

It's best to eliminate unnecessary prepositional phrases, especially when using with the possessive. Avoid phrases like "the car of Susan." Instead, write "Susan's car." When prepositional phrases (e.g., those starting with by, for, in, of, on, etc.) are strung together, it makes for clumsy and awkward sentences. For example: "She went *on* a road trip *across* the mountains *to* take pictures." This sentence has three prepositional phrases back to back. You can improve it by removing at least one prepositional phrase, like this: "She took pictures on her roadtrip across the mountains."

Following these guidelines makes for more enjoyable reading experience.

### Spelling & Grammar

- [Grammar Help at Grammarly](https://www.grammarly.com/blog/category/handbook/)
- **Punctuation Preferences:**
  - Oxford (serial) comma [We bought bread, milk, and peanut butter], so there is a final comma before the conjunction.
  - Single space after a `.` period (full stop).
  - Always use `'` for singular names/nouns ending in `s` and for plural nouns ending in `s` (e.g., Thomas’ and Companies’). Although the grammatically correct way to say and spell singular nouns ending in `s` is “Thomas’s”, it does look weird. It’s the consensus to treat every `s` as if it were a plural possessive, so instead write "Thomas'." Whenever possible, rephrase the sentence to avoid it completely.
  - Place punctuation inside of quotation marks: OCaml is an "industrial-strength functional programming language with an emphasis on expressiveness and safety." (not "...safety".)
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
