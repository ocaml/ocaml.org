---
title: SLAM
url: http://research.microsoft.com/en-us/projects/slam/
---

Le projet [SLAM](http://research.microsoft.com/en-us/projects/slam/) a
débuté à Microsoft Research début 2000. Son but était de vérifier
automatiquement qu'un programme C utilise correctement l'interface d'une
bibliothèque extérieure. Pour répondre à cette question, SLAM utilise de
manière novatrice des idées provenant de la vérification symbolique de
modèles, de l'analyse statique de programmes et de la démonstration
automatique. Le moteur d'analyse SLAM est au coeur d'un nouvel outil
appelé SDV (Vérification Statique de Drivers) qui analyse
systématiquement le code source des drivers (pilotes de périphériques)
Windows et vérifie leur conformité vis-à-vis d'un ensemble de règles qui
caractérisent les interactions correctes entre un driver et le noyau du
système d'exploitation Windows.

*Dans le rapport technique
[MSR-TR-2004-08](http://research.microsoft.com/apps/pubs/default.aspx?id=70038),
T.Ball, B.Cook, V.Levin and S.K.Rajamani, les auteurs de SLAM,
écrivent:* “The Right Tools for the Job: We developed SLAM using Inria's
OCaml functional programming language. The expressiveness of this
language and robustness of its implementation provided a great
productivity boost.”
