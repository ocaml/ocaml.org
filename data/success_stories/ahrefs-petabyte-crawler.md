---
title: Petabyte-Scale Web Crawling and Data Processing
logo: success-stories/ahrefs.svg
card_logo: success-stories/white/ahrefs.svg
background: /success-stories/ahrefs-bg.jpg
theme: blue
synopsis: "Ahrefs built the world's third-largest web crawler using OCaml, indexing petabytes of web data with a lean, efficient team."
url: https://ahrefs.com/
priority: 2
why_ocaml_reasons:
- Performance
- Reliability
- Expressiveness
- Scalability
- Maintainability
---

## Challenge

[Ahrefs](https://ahrefs.com/) is a Singapore-based SaaS company that provides comprehensive SEO tools and marketing intelligence powered by big data. Since 2011, they've been crawling the entire web daily to maintain extensive databases of backlinks, keywords, and website analytics that help businesses with SEO strategy, competitor analysis, and content optimization. Today, they're trusted by 44% of Fortune 500 companies.

Building and operating a web crawler at internet scale presents extraordinary challenges. Ahrefs needs to index billions of web pages continuously, process petabytes of data in real-time, and turn this massive dataset into actionable insights for thousands of customers worldwide. The technical demands are staggering: their systems must handle **500 billion backend requests per day** while maintaining **over 100PB of storage**.

As a self-funded company, Ahrefs couldn't solve these challenges by throwing unlimited resources at the problem. They needed maximum efficiency from a small team — systems that could run reliably for months without intervention, code that could be understood and maintained by a lean engineering organization, and performance that could compete with tech giants despite having a fraction of their headcount.

The question wasn't just whether they could build a web-scale crawler, but whether they could do it sustainably with the constraints of a bootstrapped company.

## Result

Over a decade later, Ahrefs operates one of the world's most sophisticated web crawling operations. Their OCaml-powered systems maintains an index of **492.7 billion pages** across **500.4 million domains**.

This technical achievement translates directly to business success. Ahrefs has grown into a **$100M+ ARR company** with **150 employees** managing **4000+ servers**—all while maintaining their original philosophy of operational efficiency. They've become the sector leader in SEO tools, proving that the right technology choices can create sustainable competitive advantages.

The reliability of their OCaml systems is perhaps most impressive: programs written years ago continue running without surprises, requiring minimal maintenance from their engineering team. This "boring" reliability has allowed Ahrefs to focus engineering effort on building new features and capabilities rather than fighting infrastructure fires.

Their success demonstrates that OCaml can power not just technical excellence at massive scale, but sustainable business growth in highly competitive markets.

## Why OCaml
Ahrefs chose OCaml because it solved their constraint: building world-class infrastructure with limited resources.

* **Expressiveness reduces team requirements** - OCaml allowed their small team to develop crawling and data processing systems with few lines of code.
* **Reliability minimizes operational overhead** - Systems run for months without surprises.
* **Native performance handles web scale** - Compilation to native code provided the performance needed for processing billions requests daily.
* **Type safety prevents data disasters** - When processing petabytes of evolving web data, catching format issues at compile time rather than in production saves hours of debugging and prevents costly system failures.
* **Language philosophy matches business model** - OCaml's expressiveness made it economical to create specialized, efficient systems tailored to their exact requirements. The maintainers of the compiler put on a strong emphasis on making a language matching needs of industrial users.

## Solution

Ahrefs built their crawling infrastructure around OCaml's strengths, creating a distributed system that balances performance, reliability, and maintainability. **[OCaml](https://ocaml.org/)** serves as the primary language for all crawling and data processing systems, compiled natively for maximum performance across their **4000+ servers**.

Their architecture treats data consistency as paramount. Defining shared data structures (using **[ATD (Adjustable Type Definitions)](https://github.com/ahrefs/atd)**, and now moving to [melange-json](https://github.com/melange-community/melange-json)), they ensure type safety throughout their processing pipeline — from initial web crawling to final data storage. This approach catches schema mismatches at compile time rather than at runtime, crucial when processing billions of pages daily.

Their storage layer combines **[ClickHouse](https://clickhouse.com/)**, **[MySQL](https://www.mysql.com/)**, **[Elasticsearch](https://www.elastic.co/)**. The key insight was designing these systems to work together seamlessly through shared OCaml types rather than complex API layers.

Ahrefs maintains their own libraries and frameworks rather than relying on generic solutions. This "build it ourselves" philosophy requires more initial investment but delivers systems perfectly tailored to web crawling demands. Their **1.5 million lines of OCaml code** represent years of accumulated domain expertise encoded in reliable, maintainable software.

The result is a unified system where improvements to crawling algorithms, data processing pipelines, or storage efficiency can be implemented quickly and deployed confidently across their entire infrastructure.

## Lessons Learned

Ahrefs' experience building web-scale infrastructure in OCaml offers valuable insights:

* **Reliability pays compound interest**: OCaml's "boring" stability means systems built years ago still run without surprises, freeing engineering time for new capabilities rather than maintenance.
* **Types scale better than tests**: At petabyte scale, compile-time guarantees about data consistency prevent entire classes of runtime failures that would be catastrophic at this volume.
* **Expressiveness enables specialization**: OCaml's high-level abstractions made it economical to build highly specialized systems rather than adapting generic frameworks to their unique requirements.
* **Small teams can compete with giants**: The right language choice allowed Ahrefs to build infrastructure that competes with tech giants despite having a fraction of their resources.
* **Performance and maintainability aren't mutually exclusive**: OCaml's combination of native compilation and high-level abstractions delivered both the performance needed for web scale and the clarity needed for long-term maintenance.

## Open Source

Ahrefs supports the OCaml ecosystem through contributions that benefit infrastructure and data processing applications:

- **[Ahrefs DevKit](https://github.com/ahrefs/devkit):** Tools and utilities for building distributed applications.
- **[OCaml Community Tools](https://github.com/ocaml-community):** Contributions to widely used infrastructure tools like `ocurl` and `ocaml-mariadb`.
- **[ATD](https://github.com/ahrefs/atd):** Schema definition language for cross-platform data serialization.
