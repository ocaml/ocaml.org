---
title: L'analyseur statique ASTRÉE
image: astree-thumb.gif
---

*[David Monniaux](http://www-verimag.imag.fr/~monniaux/) (CNRS), membre du projet ASTRÉE :* « [ASTRÉE](http://www.astree.ens.fr/) est un analyseur statique basé sur [l'interprétation abstraite](http://www.di.ens.fr/~cousot/aiintro.shtml) et qui vise à établir l'absence d'erreurs d'exécution dans des logiciels critiques écrits dans un sous-ensemble du langage C. »

« Une analyse automatique et exacte visant à vérifier des propriétés telles que l'absence d'erreurs d'exécution est impossible en général, pour des raisons mathématiques. L'analyse statique par interprétation abstraite contourne cette impossibilité, et permet de prouver des propriétés de programmes, en sur-estimant l'ensemble des comportements possibles d'un programme. Il est possible de concevoir des approximations pessimistes qui, en pratique, permettent d'établir la propriété souhaitée pour une large gamme de logiciels. »

« À ce jour, ASTRÉE a prouvé l'absence d'erreurs d'exécution dans le logiciel de contrôle primaire de la [famille Airbus A340](http://www.airbus.com/product/a330_a340_backgrounder.asp). Cela serait impossible par de simples tests, car le test ne considère qu'un *sous-ensemble* limité des cas, tandis que l'interprétation abstraite considère un *sur-ensemble* de tous les comportements possibles du système. »

« [ASTRÉE](http://www.astree.ens.fr/) est écrit en OCaml et mesure environ 44000 lignes (plus des librairies externes). Nous avions besoin d'un langage doté d'une bonne performance (en termes de vitesse et d'occupation mémoire) sur un matériel raisonnable, favorisant l'emploi de structures de données avancées, et garantissant la sûreté mémoire. OCaml permet également d'organiser le code source de façon modulaire, claire et compacte, et facilite la gestion de structures de données récursives comme les arbres de syntaxe abstraite. »
