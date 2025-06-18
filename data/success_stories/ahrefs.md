---
title: Marketing Intelligence Tools Powered by Big Data
logo: success-stories/ahrefs.svg
card_logo: success-stories/white/ahrefs.svg
background: /success-stories/ahrefs-bg.jpg
theme: blue
synopsis: "Ahrefs leverages full-stack OCaml to achieve massive scalability, processing billions of daily requests, running the third biggest web crawler in the world, while maintaining a lean, efficient team."
url: https://ahrefs.com/
priority: 2
why_ocaml_reasons:
- Type Safety
- Expressiveness and Reliability
- Unified Technology Stack
- Integration with JavaScript Ecosystem
- Customizability
- Scalability
- Performance
---

## Challenge

Ahrefs is a Singapore-based SaaS company that provides comprehensive SEO tools and marketing intelligence powered by big data. Founded in 2011, they crawl the entire web daily to maintain extensive databases of backlinks, keywords, and website analytics that help businesses with SEO strategy, competitor analysis, and content optimization. Trusted by 44% of Fortune 500 companies, Ahrefs serves digital marketing agencies, content creators, and businesses looking to improve their organic search presence.

Ahrefs has been built around OCaml from the beginning—not as an experiment, but as a core business strategy. As a self-funded company, efficiency isn't just nice to have; it's essential. The founders wanted to maximize output with a small team rather than building the biggest company with the biggest headcount. OCaml was chosen early for backend systems and crawling because of its expressiveness—you could develop features fast with very 
few lines of code, write small programs that run reliably for months or years without surprises.

In a world where competitors burn through venture capital and hire hundreds of engineers, Ahrefs has consistently chosen to do more with less, trusting that OCaml's expressiveness and reliability would let them punch above their weight. The question was whether this philosophy could sustain them not just as a scrappy startup, but as a dominant force in a competitive market.

By 2017, Ahrefs faced a frontend bottleneck. Their frontend was built with PHP and jQuery, while their massive datasets lived in OCaml on the backend. Every time frontend developers needed data, backend engineers had to create APIs. With JavaScript tooling still poor in 2017 (before TypeScript matured), and limited interaction between teams, they saw an opportunity: what if they could extend their OCaml advantage to the entire stack?

## Result

Over a decade later, Ahrefs stands as one of the OCaml community's most enduring success stories—a company that didn't just survive betting on OCaml, but thrived because of it. What started as a small team writing crawlers in OCaml has evolved into a **$100M+ ARR company** with **150 employees** and **4000+ servers**, all while maintaining their original philosophy of doing more with less.

Around 2017-2020, Ahrefs' frontend lead investigated new technologies like Reason/BuckleScript and created demo applications, which ultimately led to the company transitioning their web frontend to [BuckleScript](https://discuss.ocaml.org/t/a-short-history-of-rescript-bucklescript/7222). BuckleScript later [rebranded as ReScript](https://rescript-lang.org/blog/bucklescript-is-rebranding) and decided to take a different direction from its OCaml roots to enable evolution of ReScript as a separate language.

Ultimately, in 2023, the full-stack OCaml vision became reality when [Ahrefs successfully transitioned from ReScript to OCaml using Melange](https://tech.ahrefs.com/ahrefs-is-now-built-with-melange-b14f5ec56df4) and [React](https://tech.ahrefs.com/building-react-server-components-in-ocaml-81c276713f19). This eliminated the API bottleneck between teams—frontend developers could now work directly with backend data types, and everyone in the company could contribute across the entire stack. The result was a unified codebase of **1.5 million lines of OCaml** powering systems that handle **5 billion frontend requests** and **500 billion backend requests per day**. For more up-to-date statistics, see [Ahrefs' statistics and metrics page](https://ahrefs.com/big-data).

But the real victory isn't just the scale—it's the sustainability. Ahrefs proved that OCaml's "boring" reliability and expressiveness could power not just technical excellence, but business excellence. They've maintained their position as an industry leader trusted by **44% of Fortune 500 companies** while staying true to their original vision: a lean, efficient team empowered by a technology stack that amplifies rather than constrains their capabilities.

## Why OCaml

OCaml was the obvious choice for Ahrefs because it directly solved their core business constraint: how to build industry-leading software with a small, efficient team. OCaml's unique ability to combine expressiveness and reliability allowed developers to write concise, efficient code that remained stable over the long term, with systems often running for years without surprises. 

For data-intensive businesses like Ahrefs, OCaml's type system provides unmatched confidence when dealing with evolving data formats and billions of daily requests. The native compilation delivers the performance needed for web-scale crawling and processing, while the high-level abstractions keep the codebase manageable and comprehensible. This isn't just about avoiding bugs—it's about enabling a small team to reason confidently about complex systems.

OCaml's ecosystem philosophy also aligns perfectly with lean teams: when you need something specific, you build it yourself rather than wrestling with heavyweight, one-size-fits-all frameworks. This approach requires more ownership but delivers exactly what your business needs—no more, no less.

## Solution

Ahrefs built their full-stack OCaml solution around a carefully chosen tech stack that maximizes both performance and developer productivity. At the core is **[OCaml](https://ocaml.org/)** for all backend systems and data processing, compiled natively for the performance needed to handle 500 billion backend requests per day. For the frontend, they use **[Melange](https://melange.re/)** (formerly BuckleScript) to compile OCaml to JavaScript, paired with **[React](https://react.dev/)** for the user interface.

A key part of their stack is the **[ATD (Adjustable Type Definitions) Syntax](https://github.com/ahrefs/atd)**, which they use to generate shared types between frontend and backend automatically. When Ahrefs switched to BuckleScript, they developed their own ATD runtime since none existed, ensuring type safety across the entire stack. This means data structure changes propagate safely from the crawling systems through to the user interface without manual coordination between teams.

Their data infrastructure combines **[ClickHouse](https://clickhouse.com/)** for analytics workloads, **[MySQL](https://www.mysql.com/)** for transactional data, and **[Elasticsearch](https://www.elastic.co/)** for search functionality, all orchestrated on **[AWS](https://aws.amazon.com/)**. The key insight was treating the database as the synchronization point between tools rather than building extensive APIs—with shared OCaml types, different parts of the system can work with the same data structures directly.

Ahrefs maintains their own standard libraries for both frontend and backend, following the philosophy of "we treat dependencies as if we implemented them." When something doesn't exist or doesn't fit their needs exactly, they build it themselves. This approach requires more ownership but delivers precisely tailored solutions that perform better and integrate more seamlessly than generic frameworks.

The result is a unified codebase where any engineer can contribute across domains, eliminating the traditional silos between frontend and backend teams.

## Lessons Learned

Ahrefs' decade-plus journey with OCaml offers practical insights for companies considering a similar path:

* **Start with the fundamentals**: OCaml's type system is beautifully simple with just records, algebraic data types, and tuples, making errors obvious and easy to fix without fighting the type checker.
* **Invest in team learning**: Training the team in OCaml is essential but rewarding. Tools like the [Melange playground](https://melange.re/v5.0.0/playground) make onboarding smoother and more approachable.
* **Embrace "build it yourself"**: OCaml's expressiveness makes it cheap to create tailored solutions rather than wrestling with heavyweight frameworks, requiring more ownership but delivering exactly what your business needs.
* **Writing bindings is learnable**: Yes, you'll need JavaScript bindings for frontend work, but [the official Melange documentation](https://melange.re/) and [community resources](https://github.com/melange-community/bindings) makes this much more approachable than it seems.
* **Cultural shift matters most**: The biggest challenge isn't OCaml's technical complexity, but explaining the value to developers from mainstream ecosystems — though productivity gains from shared types become self-evident once experienced.

## Open Source

Ahrefs is proud to support the OCaml ecosystem by contributing tools and libraries that benefit the broader community. These contributions include:

- **[Melange Recharts](https://github.com/ahrefs/melange-recharts):** Recharts bindings for Melange.
- **[Ahrefs DevKit](https://github.com/ahrefs/devkit):** Tools and utilities for writing applications.
- **[Melange Bindings](https://github.com/melange-community/bindings):** A community-driven resource for bindings.
- **[Melange JSON PPX](https://github.com/ahrefs/melange-json-ppx):** A replacement for the ATD runtime in BuckleScript.
- **[OCaml Community Tools](https://github.com/ocaml-community):** Contributions to widely used tools like `ocurl` and `ocaml-mariadb`.
