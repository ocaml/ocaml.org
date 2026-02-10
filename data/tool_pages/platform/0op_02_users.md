---
id: "platform-users"
title: "User Personas of the OCaml Platform"
short_title: "User Personas"
description: The principles that guide the development of the OCaml Platform.
category: "OCaml Platform"
---

This section presents an overview of different user personas within the OCaml
ecosystem, highlighting their unique goals, motivations, and challenges.

The aim of defining these personas is to establish a framework that can guide
the roadmap for the OCaml Platform, ensuring that it addresses the unique
requirements of each archetype. By understanding and catering to the specific
characteristics of each persona, we can contribute to the success of the OCaml
ecosystem while empowering users to achieve their individual goals.

## (U1) Application Developer

_Builds OCaml applications to solve real-world problems_

Application developers using OCaml are focused on building solutions to
real-world problems. They care deeply about application stability, reliability,
performance, and scalability. Some applications examples include building web
applications for the browser with Js_of_ocaml, unikernels with MirageOS, and
image classifiers using Owl.

1. **Application Stability and Reliability**: Application Developers care about
   their end-users' experience. Releasing stable and reliable applications to
   their users is essential to provide a positive user experience and minimize
   failures or downtime. Stability also allows developers to reduce maintenance
   costs and focus on improvements instead of bug fixes or technical debt.
   Following today's best practices involves reproducible builds to avoid
   impacts from moving dependencies, maintaining tight control over dependencies
   to stay aware of potential security risks, and using tools to implement
   tests, enforce best practices, or run continuous integrations.
1. **Performance and Scalability**: Most applications have performance
   constraints they need to respect, for scalability or to provide a good user
   experience. Scalability is also a common concern for application developers
   who need to anticipate a growing user base or data sets. To improve
   applications performance, developers rely on instrumentation tools, profilers
   or benchmarks. Another common way to optimise applications' performance is to
   support parallel processing of performance-intensive parts of their code.
1. **Distribution and Deployment**: A simple distribution or deployment process
   is crucial for Application Developers to continuously deliver their
   applications to their users. Things that can help developers to simplify
   their distribution workflows include cross-platform builds; CI/CD pipelines;
   automatic generation of installers; integration with distributions platforms
   across operating systems (Apple Store, Windows Store, Docker Hub, etc.);
   tooling to generate assets for the target Platform (e.g. JavaScript, iOS,
   Android, etc.); and integration with third-party systems that offer a
   streamlined deployment story like Docker or Nix.
1. **Security and Compliance**: Application developers prioritize security to
   protect sensitive data and maintain user trust. They may have to comply with
   industry security standards, such as maintaining a Software Bill of Material,
   and follow regulations. Companies often organize security audits to
   proactively identify and address potential issues. Individual developers
   typically follow less rigorous processes, relying on security features from
   their package manager or vulnerability scanners. To further control
   dependencies and enhance security, developers may fork and vendor libraries,
   allowing them to respond quickly to security issues and customize
   dependencies to fit their specific needs.
1. **Comprehensive Documentation and Resources**: Access to documentation and
   learning resources is essential for developers of all experience levels.
   Encouraging engagement with community-driven resources, such as forums and
   knowledge bases also fosters a supportive ecosystem where developers can both
   consume and contribute knowledge.

## (U2) Library Author

_Builds re-usable OCaml components, not directly executable_

Library authors write code consumed by other developers while using other
people's libraries to build their own. They focus on ensuring that their
libraries are well-designed, well-documented, and easy to use. Library authors
often have to manage dependencies, versioning, publishing, and testing. They may
create libraries for a wide range of purposes, such as web development, data
processing, or machine learning, and contribute them to the opam repository for
the OCaml community to use.

1. **Package Publication**: Publishing packages on package repositories is the
   primary means through which Library Authors can share their work. They want
   this process to be as intuitive and frictionless as possible so they can
   focus on building their library, writing documentation and engaging the
   community.
1. **Code Reusability and Modularity**: Library Authors care about composability
   they design APIs that are easy to use and work well with other libraries.
   They focus on creating simple APIs and follow common practices to ensure
   their libraries feel familiar to developers. They also pay attention to
   compatibility, carefully choosing APIs from other dependencies and weighing
   the pros and cons of using different packages.
1. **Interoperability and Portability**: In some cases, libraries support
   specific target Platforms (operating systems, architecture, etc.), but in
   most cases, Library Authors want to make their libraries available to as many
   users as possible. To do this, they rely on tooling to test their libraries
   on different Platforms. Tools to support Library Authors include CI systems
   and cross-platform build systems.
1. **Code Quality and Maintainability**: When they have released a library,
   Library Authors accept a maintenance cost due to the evolving language and
   ecosystem. Every breaking change in the language or in the library
   dependencies will incur friction. They want this workload to remain as
   minimal as possible, ideally to remain unimpacted by any changes to the
   ecosystem, only accepting maintenance costs for updating their libraries when
   needed. Conversely, they want to know the impact a release will have on their
   users: applications or other libraries that depend on theirs.
1. **Documentation and Examples**: An important aspect of sharing their work
   involves making sure users can use their libraries easily. To that end,
   Library Authors care about providing their users with good documentation and
   other resources to reduce the learning curve, like code examples. This
   documentation and resources need to stay up-to-date with library changes and
   improvements so they don't become a burden for the author or irrelevant to
   the users.
1. **Community Engagement and Support**: Library Authors make the effort of
   sharing their work with the rest of the community. They care about the health
   and growth of the ecosystem. They also value connection with the community by
   announcing their packages on forums and social media, gathering feedback from
   their users, or even promoting contributions to their libraries.
1. **Support Application Developers**: Ultimately, Library Authors want to help
   Application Developers (U1) succeed. They care about aspects like
   performance, security, and maintainability to ensure their libraries provide
   a solid foundation for building applications. By focusing on these areas,
   they empower developers to create robust and efficient real-world solutions
   using their libraries.

## (U3) Distribution Manager

_Works on maintaining a Linux distro like Debian or RedHat_

Distribution managers work on maintaining Unix distributions, such as BSD,
Debian or Red Hat, and ensuring that OCaml applications, libraries, and tools
are compatible with their distribution policies. They care about package
management, co-installability, and tight integration with external (non-OCaml)
dependencies. Distribution managers often have to decide which OCaml components
to include in their distributions and ensure they are well-supported and secure.

1. **Package Selection and Inclusion**: Distribution managers are responsible
   for choosing the right OCaml libraries and tools for their distribution. They
   need to consider factors like long-term support, stability, compatibility,
   and feature availability. They also need to ensure a consistent set of
   co-installable packages and manage any dependency conflicts that arise. By
   minimizing the risk of package incompatibilities and breaking changes,
   distribution managers create a reliable and user-friendly environment for
   developers. As such, seamless integration with external (non-OCaml) packages
   is a priority for distribution managers.
1. **Security and Long-term Support**: Distribution managers need to stay
   informed about potential security issues in the packages they include in
   their distributions as they are responsible for releasing hotfixes and
   security updates in a timely manner. They also provide long-term support for
   the chosen OCaml libraries and tools, like Debian's 5-year LTS support, so
   they need to be confident the inclusion of a library will not create an
   additional maintenance burden for the distribution.
1. **Package Management and Tooling**: Instead of relying on language-specific
   tooling, Distribution Managers use their distribution's existing package
   management infrastructure. To streamline the release process of their
   distributions, Distribution Managers care about having a simple way to port
   language-specific packages to their distribution package managers easily.

## (U4) Newcomer

_Learn the syntax and language features_

Newcomers are individuals who are new to OCaml or interested in learning the
language for personal or educational purposes. They are often drawn to OCaml
because of its strong type system, functional programming paradigm, and rich
ecosystem of tools and libraries. Newcomers often care most about easily setting
up a development environment, having accessible learning resources, and
receiving guidance from the OCaml community.

Newcomers come in all shapes and colours; some might have experimented with
other languages, and for others, this might be their first introduction to CS.
How one learns OCaml depends on one's affinities and previous experience. What
they often care most about is easily setting up a development environment, having
accessible learning resources, and receiving guidance from the OCaml community.
They might start by experimenting with simple OCaml programs, like a
command-line calculator, or building basic web applications using a lightweight
framework.

1. **Setup an OCaml Environment**: Setting up their environment is the first
   step Newcomers undertake in their journey to learn OCaml. They need to have
   comprehensive documentation that guides them through a straightforward
   installation workflow. They also need to easily understand what went wrong if
   they have an error at any point during their onboarding. It's also important
   that the installation time remains minimal: by minimizing the time it takes
   to start working with OCaml, Newcomers can focus on learning and
   experimenting with the language. Not all of them will need to install OCaml
   on their systems: using online IDEs, Playground, or Docker containers can
   simplify the setup for users who want to get started with writing OCaml as
   quickly as possible.
1. **Learn OCaml**: Some Newcomers have experienced developers in other
   programming languages, and some are learning OCaml as their first language.
   Given the huge range of learning needs, Newcomers need to have access to an
   exhaustive library of documentation and resources to learn OCaml, including
   Guides, Tutorials, Language Manual, Package documentation. All of these need
   to cater for the needs of inexperienced developers, as well as provide
   comprehensive information for experienced ones. Newcomers also want their
   learning experience to be enjoyable, by using playgrounds, interactive
   exercises, or beginner-friendly content.
1. **Discover the Ecosystem**: Once Newcomers have set up their environment and
   start learning the language, they will need to interact with the ecosystem,
   either by using OCaml packages, asking questions on forums, reading
   documentation, etc. It's crucial to provide newcomers with a good
   understanding of how the ecosystem is organised: how to find answers to
   questions, what are the best practices, what are the pros and cons of two
   alternative packages, etc. Newcomers want to have examples they can reuse to
   perform specific tasks, such as creating a web server, or a command line
   interface.
1. **Community Support and Mentorship**: A welcoming and supportive community is
   vital for Newcomers learning OCaml. Learning a new language and discovering
   an ecosystem can feel daunting and Newcomers may reach out to the community
   for support. More experienced developers in the community can help create a
   positive learning environment by answering questions on forums, chats,
   GitHub, and other Platforms.

## (U5) Teacher

_Teaching the OCaml syntax and language features or using OCaml to teach other
CS principles._

Teachers are individuals who are responsible for teaching the OCaml programming
language to students. This can include teaching the syntax and language features
of OCaml or using OCaml as a tool to teach other computer science principles.
Teachers typically have to support multiple operating systems (such as Mac,
Unix, and Windows) to provide a smooth onboarding experience for their students.
Teachers care about creating engaging educational content, ensuring a smooth
onboarding experience for their students, and integrating OCaml with educational
tools like Jupyter Notebooks.

1. **Offer Frictionless Setup Experience for Students**: Teachers need to
   support a variety of environments across multiple operating systems that
   their students use. They want to simplify and unify the process of setting up
   a development environment for their students as much as possible. To do this,
   they want to be able to point students to a single platform that provides a
   simplified installation experience, such as a VSCode extension, an online
   editor, etc. They also work on step-by-step guides and tutorials for their
   students, both for configuring their environment, but also installing and
   using libraries.
1. **Engage Students**: Teachers try to accommodate different learning styles
   and student backgrounds. They create engaging materials and use tools like
   Jupyter Notebooks to support interactive learning experiences. They listen to
   feedback from their students, experiment with different teaching approaches
   and continuously improve their learning materials based on this.
1. **Alignment with Curriculum and Learning Objectives**: In addition to
   teaching OCaml, Teachers also need to align with relevant curricula (such as
   computer science, algorithms, system programming, etc.). Teachers design
   lessons and projects that demonstrate the practical application of OCaml on
   these topics.

## (U6) Data Scientist

_Uses OCaml for short-term projects, often in scientific modeling or data
analysis_

Researchers use OCaml for scientific modeling, data analysis, and other
short-term projects. They may be academics, researchers, or professionals
working in various industries, including government and corporate sectors.

Unlike Application Developers, they are not necessarily focused on long-term
software stability and deployment. They may develop code for one-off analyses or
rapidly-evolving models, where flexibility, iteration speed, and expressiveness
are paramount. However, like Application Developers, they care about having an
efficient working environment and access to resources to solve their unique
problems.

1. **Rapid Prototyping and Flexibility**: Researchers often work on projects
   that require rapid prototyping and constant iteration. They value a
   programming environment that allows for quick changes and easy testing.
1. **Rich Scientific Libraries and Tools**: Access to libraries that support
   scientific computation and data analysis is vital for Researchers. Similarly,
   the ability to visualize data and analysis results is often crucial in their
   work. Researchers typically work with large datasets, so they need efficient
   tools for data manipulation, cleaning, and processing. They also often
   require support for various data formats and databases.
1. **Interoperability with Other Languages and Tools**: Since they often work
   within a larger ecosystem of data science tools, interoperability with other
   languages (like Python or R) and tools (like Jupyter notebooks or TensorFlow)
   can be important. This might involve calling OCaml from these languages, or
   vice versa, as well as integrating with other data science tools.
1. **Reproducibility**: Ensuring that others can reproduce their work is often
   crucial, particularly in an academic or research context. This involves
   keeping track of dependencies, versions, and environments, as well as
   documenting their work so that others can understand and replicate it.
