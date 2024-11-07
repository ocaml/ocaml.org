---
title: "Arch\xE9ologie de la G\xE9n\xE9alogie: prise en main et optimisation d\u2019un
  logiciel vieux de 30 ans"
description: "L\u2019\xE9quipe d\u2019OCamlPro a r\xE9cemment \xE9t\xE9 sollicit\xE9e
  par l\u2019association Roglo, une association fran\xE7aise de g\xE9n\xE9alogie qui
  g\xE8re une base de plus de 10 millions de personnes connect\xE9es dans une m\xEAme
  arbre g\xE9n\xE9alogique, et dont la base s'accro\xEEt d\u2019environ 500 000 nouvelles
  contributions..."
url: https://ocamlpro.com/blog/2024_11_06_short_news_archeologie_de_la_genealogie
date: 2024-09-30T15:20:07-00:00
preview_image: https://ocamlpro.com/blog/assets/img/og_genealogy_tree.png
authors:
- "\n    Fabrice Le Fessant\n  "
source:
---

<p></p>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/figure_genealogy_tree.jpeg">
      <img src="https://ocamlpro.com/blog/assets/img/figure_genealogy_tree.jpeg" alt="C'est en modernisant les solutions d'hier qu'on protège la généalogie d'aujourd'hui.">
    </a>
    </p><div class="caption">
      C'est en modernisant les solutions d'hier qu'on protège la généalogie d'aujourd'hui.
    </div>
  <p></p>
</div>
<p></p>
<p>L’équipe d’OCamlPro a récemment été sollicitée par l’association Roglo, une
association française de généalogie qui gère une base de plus de 10 millions de
personnes connectées dans une même arbre généalogique, et dont la base
s'accroît d’environ 500 000 nouvelles contributions tous les ans. L’association
s’appuie sur le logiciel open-source Geneweb, l’un des plus puissants logiciels
du domaine, créé en 1997 à l’Inria, permettant de partager sur le web des
arbres généalogiques, et utilisé aussi bien par des particuliers que par des
leaders du secteur, comme la société française Geneanet, acquise en 2021 par
l’américain Ancestry.</p>
<p>Notre mission s’est d’abord concentrée sur l'optimisation des performances,
pour ramener le traitement de certaines requêtes sur la base gargantuesque de
Roglo à des temps raisonnables. Après avoir rapidement survolé le code de plus
de 80 000 lignes et profilé les requêtes les plus coûteuses, nous avons pu
proposer une solution, l’implanter et l’intégrer dans la branche principale.
Pour l’une des requêtes, le temps passe ainsi de 77s à 4s, soit 18 fois plus
rapide ! Nous travaillons maintenant à enrichir Geneweb de nouvelles
fonctionnalités pour ces utilisateurs, mais aussi pour ses contributeurs et les
mainteneurs de la plateforme !</p>
<p>Cette mission, fragmentée en sprints de développement, s'inscrit dans une
démarche continue visant à faire évoluer Geneweb pour qu'il puisse gérer des
volumes de données encore plus importants.
Nous sommes ravis de contribuer à cette évolution, en apportant notre expertise
en optimisation et en développement logiciel pour faire grandir cette
plateforme de référence.</p>

