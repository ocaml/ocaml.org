---
title: Full-Stack OCaml Web Application
logo: success-stories/ahrefs.svg
card_logo: success-stories/white/ahrefs.svg
background: /success-stories/ahrefs-bg.jpg
theme: blue
synopsis: "Ahrefs transitioned from PHP/jQuery to full-stack OCaml using Melange and React, eliminating team silos and enabling any engineer to contribute across their entire web application stack."
url: https://ahrefs.com/
priority: 2
why_ocaml_reasons:
- Type Safety
- Unified Technology Stack
- Team Efficiency
- Integration with JavaScript Ecosystem
- Shared Data Types
- Developer Productivity
- Code Reliability
---

## Challenge

Ahrefs is a Singapore-based SaaS company that provides SEO tools and marketing intelligence powered by big data. Since 2011, they've built their business around OCaml, using it for web crawling and data processing to serve thousands of customers worldwide. Today, they're trusted by 44% of Fortune 500 companies and operate as a lean, self-funded organization focused on efficiency.

By 2017, Ahrefs had built a successful SEO tools business powered by OCaml on the backend, but they faced a bottleneck in web application development. Their frontend was built with PHP and jQuery while their data processing lived in OCaml. Every time frontend developers needed backend data, they had to coordinate with backend engineers to update the APIs.

Ahrefs wanted engineers to be productive across the entire stack, but the technology divide made this unnecessarily difficult. The JavaScript tooling used in 2017 for the frontend of the web application was lacking compared to today's TypeScript ecosystem. Ahrefs had already built years of expertise in OCaml. The question became: could they extend OCaml's benefits to the frontend?

The challenge was both technical and cultural. Could they transition the entire frontend team to a OCaml? Even when some of the engineers hadn't used a functional programming language before? Would the benefits of a unified stack outweigh the costs?

## Result

After adopting Reason/BuckleScript around 2017-2020 and migrating to **[Melange](https://melange.re/)** in 2023, Ahrefs has achieved a full stack web development setup around OCaml.

Now, any engineer in the company can contribute across the entire web application. Thanks to shared types between backend and frontend, coordination overhead is greatly reduced. 

Frontend and backend stay in sync: When data structures change, type errors guide developers to update all affected code.

Today, their **5 billion daily frontend requests** are handled by the same OCaml codebase that powers their backend systems. The web application serving **44% of Fortune 500 companies** is built from **1.5 million lines of OCaml code** spanning both frontend and backend.

## Why OCaml

For Ahrefs, extending OCaml to the frontend wasn't about technological purity—it was about simplifying their business.

* **Shared types eliminate coordination overhead** - Using OCaml to express the shape of data exchanged between frontend and backend increases maintainability and simplifies development.
* **Faster iteration cycles** - Type safety meant changes to data structures propagated safely throughout the entire application without runtime surprises, enabling rapid feature development.
* **Melange bridges ecosystems** - Access to the JavaScript ecosystem (React components, npm packages) while maintaining OCaml's compile-time guarantees meant they didn't have to choose between type safety and ecosystem richness.

## Solution

Ahrefs built their full-stack solution around **[OCaml](https://ocaml.org/)** compiled to JavaScript via **[Melange](https://melange.re/)**, paired with **[React](https://react.dev/)** for the user interface.

The cornerstone of their architecture is **[ATD (Adjustable Type Definitions)](https://github.com/ahrefs/atd)**. Ahrefs developed ATD to generate shared types for their frontend and backend -- initially in BuckleScript.

Their frontend follows React patterns. Components are written in OCaml and compiled to JavaScript, with state management and data flow handled through React paradigms. Expressing all of this through OCaml ensures that data shapes match across the entire application.

Integration with their existing data infrastructure (**[ClickHouse](https://clickhouse.com/)**, **[MySQL](https://www.mysql.com/)**, **[Elasticsearch](https://www.elastic.co/)** on **[AWS](https://aws.amazon.com/)**) is seamless with frontend and backend sharing the same type definitions. Rather than maintaining separate API contracts, the database serves as the source of truth and data shapes are automatically reflected throughout the application.

## Lessons Learned

* **Shared types eliminate entire bug categories**: Automatic synchronization between frontend and backend data structures prevents integration issues that commonly plague web applications.
* **Team learning pays off**: Transitioning frontend developers to OCaml requires investment, but tools like the **[Melange playground](https://melange.re/v5.0.0/playground)** make onboarding approachable. Productivity gains compound over time.
* **Writing bindings is manageable with good resources**: Interfacing with the existing JavaScript ecosystem initially seemed daunting, but the **[official Melange documentation](https://melange.re/)** and **[community resources](https://github.com/melange-community/bindings)** provide clear guidance for common patterns.
* **Gradual migration reduces risk**: Starting with small components or isolated features allows teams to build confidence before transitioning entire applications.

## Open Source

Ahrefs contributes actively to the full-stack OCaml ecosystem, sharing tools that benefit the broader community:

- **[Melange Recharts](https://github.com/ahrefs/melange-recharts):** Production-ready charting components for data visualization applications.
- **[Melange Bindings](https://github.com/melange-community/bindings):** Community-driven repository of JavaScript library bindings.
- **[Melange JSON PPX](https://github.com/ahrefs/melange-json-ppx):** Streamlined JSON handling for frontend applications.
- **[Ahrefs DevKit](https://github.com/ahrefs/devkit):** Utilities and tools for building OCaml applications.
