---
id: "platform-principles"
title: "Guiding Principles"
description: The principles that guide the development of the OCaml Platform.
category: "OCaml Platform"
---

# Guiding Principles

The OCaml Platform is driven by a set of guiding principles, designed to serve
the community and advance the state of OCaml tooling.

## (P1) Tools have good defaults, yet are customisable

The OCaml Platform aims to lower entry barriers for newcomers.
[Convention over configuration](https://en.wikipedia.org/wiki/Convention_over_configuration)
reduces the number of decisions that developers are required to make. By having
as few steps as possible to start coding, we ease the onboarding experience.

While prioritising ease of use and an out-of-the-box experience, tools should
allow customisation for power users, understanding that projects differ in their
requirements and that the Platform should be flexible enough to accommodate
these varying needs.

## (P2) The experience is versatile, yet seamless

The OCaml Platform aims to support every important development workflow. Despite
the inherent complexity induced by this objective, the final user experience
should be seamless.

We envision that the development workflows should be automated where possible,
creating an experience where disruptions are the exception. When complete
automation isn't practical, the end-to-end workflows should minimise user
interactions.

## (P3) Workflows are simple, yet scalable

The OCaml Platform aims to offer a great user experience. A key part of this is
the adherence to the
[principle of least astonishment](https://en.wikipedia.org/wiki/Principle_of_least_astonishment).
The tools should behave in the way that most people expect, and users should be
able to form simple mental models of the workflows.

Stateful tools are inherently more complex than stateless ones. Whenever
possible, the tools should be stateless and use "configuration over commands,"
which suggests replacing states with a configuration-based approach.

While prioritising simplicity, the workflows should nonetheless scale to
large-scale codebases. The same workflows should be usable in single-developer
projects and industrial OCaml codebases. Performance is crucial for
scalability. As the codebase grows, the tools should still maintain their
performance.

## (P4) Tools evolve rapidly, yet don't break projects

The OCaml Platform has served as the backbone of OCaml developer experience for
over a decade. It intends to continue doing so for many more decades. The
OCaml Platform is designed as a collection of tools that follow a lifecycle.
This design stems from the acknowledgment that there is a dual need for strong
backward compatibility and the flexibility to rapidly evolve.

We acknowledge that tools will emerge and become obsolete over time;
therefore, we place significant emphasis on designing metadata files independent
from the tools, which will persist for a long time. These files should be
versioned and the tools should aim to support as many versions as possible.

Incubated tools are only promoted to Active when they are mature, stable, and
ready for mass adoption, aiming to foster a healthy competitive environment
without risking community split. However, whenever disruption is inevitable,
either in the interest of a tool's improvement or the replacement of a
tool by another, the Platform should offer a smooth migration path for users.

## (P5) Tools are independent, yet unified

Following on P4, we underline the critical importance of permitting tools to
flourish independently: the OCaml Platform exists and will continue to exist as
a collection of tools that can be used independently.

Yet, in the interest of creating a great user experience, the Platform offers a
unified experience and strives to ensure cross-compatibility among tools.

This unified experience implies the existence of a single CLI that serves as a
frontend for the Platform tools. On the editor, the implication is that
development workflows should be available directly from within the editor,
avoiding the need for users to resort to the command line.

Amidst this integration, we firmly commit to ensuring that tools retain their
independence and continue to be accessible through their own CLIs.

## (P6) The Platform is cohesive, yet extensible

While striving for a unified experience (P5), we aim to support users who want
to use tools that don't belong to the Platform.

Users who want to use other tools in their workflows should be able to do so
without feeling like second-class citizens.

This can be achieved through plugin systems or implementations that stay
general enough to support different tools.


****

**Version 1.0.0 - August 21st 2023**

The first version of the OCaml Platform's Guiding Principles was adopted in
August 2023. You can look back at the
[discussion](https://discuss.ocaml.org/t/a-roadmap-for-the-ocaml-platform-seeking-your-feedback/12238).

***Version 1.0.1 — September 19th 2022***

- Commit in stronger terms to keeping Platform tools independent and retain the
  possibility to use their CLIs directly.
