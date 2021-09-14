---
title: Le synchroniseur de fichiers Unison
image: /success-stories/unison-thumb.jpg
url: https://www.cis.upenn.edu/%7Ebcpierce/unison/
---

[Unison](https://www.cis.upenn.edu/%7Ebcpierce/unison/) est un outil de
synchronisation de fichiers populaire, qui fonctionne sous Windows et
sous la plupart des variantes d'Unix. Il permet de stocker deux
répliques d'une collection de fichiers et de répertoires sur deux
machines différentes, ou bien sur deux disques différents d'une même
machine, et de les mettre à jour en propageant les changements de
chacune des répliques vers l'autre. À la différence d'un simple outil de
sauvegarde ou de maintien d'une image miroir, Unison est capable de
gérer la situation où les deux répliques ont été modifiées : les
changements qui n'entrent pas en conflit sont propagés automatiquement,
tandis que les changements incompatibles sont détectés et signalés.
Unison est également résistant aux échecs : il prend soin de laisser les
deux répliques, ainsi que ses propres structures privées, dans un état
cohérent à tout instant, même en cas d'arrêt abrupt ou de panne de
communication.

*[Benjamin C. Pierce](https://www.cis.upenn.edu/%7Ebcpierce/) (University
of Pennsylvania), chef du projet Unison :* « Je pense qu'Unison est un
succès très clair pour OCaml – en particulier, grâce à l'extrême
portabilité et l'excellente conception générale du compilateur et de
l'environnement d'exécution. Le typage statique fort d'OCaml, ainsi que
son puissant système de modules, nous ont aidés à organiser un logiciel
complexe et de grande taille avec un haut degré d'encapsulation. Ceci
nous a permis de préserver un haut niveau de robustesse, au cours de
plusieurs années de travail, et avec la participation de nombreux
programmeurs. En fait, Unison présente la caractéristique, peut-être
unique parmi les projets de grande taille écrits en OCaml, d'avoir été
*traduit* de Java vers OCaml à mi-chemin au cours de son développement.
L'adoption d'OCaml a été comme une bouffée d'air pur. »
