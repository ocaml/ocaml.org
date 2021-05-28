---
title: The ASTRÉE Static Analyzer
image: astree-thumb.gif
---

*[David Monniaux](http://www-verimag.imag.fr/~monniaux/) (CNRS), member of the ASTRÉE project, says:* “[ASTRÉE](http://www.astree.ens.fr/) is a *static analyzer* based on *[abstract interpretation](http://www.di.ens.fr/~cousot/aiintro.shtml)* that aims at proving the absence of runtime errors in safety-critical software written in a subset of the C programming language.”

“Automatically analyzing programs for exactly checking properties such as the absence of runtime errors is impossible in general, for mathematical reasons. Static analysis by abstract interpretation works around this impossibility and proves program properties by over-approximating the possible behaviors of the program: it is possible to design pessimistic approximations that, in practice, allow proving the desired property on a wide range of software.”

“So far, ASTRÉE has proved the absence of runtime errors in the primary control software of the [Airbus A340 family](https://www.airbus.com/aircraft/previous-generation-aircraft/a340-family.html). This would be impossible by *software testing*, for testing only considers a limited *subset* of the test cases, while abstract interpretation considers a *superset* of all possible outcomes of the system.”

“[ASTRÉE](http://www.astree.ens.fr/) is written in OCaml and is about 44000 lines long (plus external libraries). We needed a language with good performance (speed and memory usage) on reasonable equipment, easy support for advanced data structures, and type and memory safety. OCaml also allows for modular, clear and compact source code and makes it easy to work with recursive structures such as syntax trees.”
