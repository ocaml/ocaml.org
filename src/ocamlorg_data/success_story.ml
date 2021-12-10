
type t =
  { title : string
  ; slug : string
  ; logo : string
  ; background : string
  ; theme : string
  ; synopsis : string
  ; url : string
  ; body_md : string
  ; body_html : string
  }
  
let all_en = 
[
  { title = {js|Jane Street|js}
  ; slug = {js|jane-street|js}
  ; logo = {js|/success-stories/jane-street-thumb.jpg|js}
  ; background = {js|/success-stories/jane-street-bg.jpg|js}
  ; theme = {js|cyan|js}
  ; synopsis = {js|Jane Street is a quantitative trading firm and liquidity provider with a unique focus on technology and collaborative problem solving.|js}
  ; url = {js|https://janestreet.com/technology/|js}
  ; body_md = {js|
Jane Street is a proprietary trading firm that uses OCaml as its primary
development platform.  Our operation runs at a large scale,
generating billions of dollars of transactions every day from our offices
in Hong Kong, London and New York, with strategies that span many asset classes,
time-zones and regulatory regimes.

Almost all of our software is written in OCaml, from statistical
research code to systems-administration tools to our real-time trading
infrastructure.  OCaml’s type system acts as a rich and
well-integrated set of static analysis tools that help improve the
quality of our code, catching bugs at the earliest possible stage.
Billions of dollars of transactions flow through our systems every day,
so getting it right matters.  At the same time, OCaml is highly productive,
helping us quickly adapt to changing market conditions.

Jane Street has been contributing open-source libraries back to the wider
community for many years, including Core, our alternative standard
library, Async, a cooperative concurrency library,
and several syntax extensions like binprot and sexplib.  All of these can
be found at [https://janestreet.github.io](https://janestreet.github.io).  All in, we've open-sourced
more than 200k lines of code.
|js}
  ; body_html = {js|<p>Jane Street is a proprietary trading firm that uses OCaml as its primary
development platform.  Our operation runs at a large scale,
generating billions of dollars of transactions every day from our offices
in Hong Kong, London and New York, with strategies that span many asset classes,
time-zones and regulatory regimes.</p>
<p>Almost all of our software is written in OCaml, from statistical
research code to systems-administration tools to our real-time trading
infrastructure.  OCaml’s type system acts as a rich and
well-integrated set of static analysis tools that help improve the
quality of our code, catching bugs at the earliest possible stage.
Billions of dollars of transactions flow through our systems every day,
so getting it right matters.  At the same time, OCaml is highly productive,
helping us quickly adapt to changing market conditions.</p>
<p>Jane Street has been contributing open-source libraries back to the wider
community for many years, including Core, our alternative standard
library, Async, a cooperative concurrency library,
and several syntax extensions like binprot and sexplib.  All of these can
be found at <a href="https://janestreet.github.io">https://janestreet.github.io</a>.  All in, we've open-sourced
more than 200k lines of code.</p>
|js}
  };
 
  { title = {js|LexiFi's Modeling Language for Finance|js}
  ; slug = {js|lexifis-modeling-language-for-finance|js}
  ; logo = {js|/success-stories/lexifi-thumb.jpg|js}
  ; background = {js|/success-stories/lexifi-bg.jpg|js}
  ; theme = {js|orange|js}
  ; synopsis = {js|Integrated end-user software solution to efficiently manage all types of structured investment products and provide superior client services.|js}
  ; url = {js|https://www.lexifi.com/|js}
  ; body_md = {js|
Developed by the company [LexiFi](https://www.lexifi.com/), the Modeling
Language for Finance (MLFi) is the first formal language that accurately
describes the most sophisticated capital market, credit, and investment
products. MLFi is implemented as an extension of OCaml.

MLFi users derive two important benefits from a functional programming
approach. First, the declarative formalism of functional programming
languages is well suited for *specifying* complex data structures and
algorithms. Second, functional programming languages have strong *list
processing* capabilities. Lists play a central role in finance where
they are used extensively to define contract event and payment
schedules.

In addition, MLFi provides crucial business integration capabilities
inherited from OCaml and related tools and libraries. This enables
users, for example, to interoperate with C and Java programs, manipulate
XML schemas and documents, and interface with SQL databases.

Data models and object models aiming to encapsulate the definitions and
behavior of financial instruments were developed by the banking industry
over the past two decades, but face inherent limitations that OCaml
helped overcome.

LexiFi's approach to modeling complex financial contracts received an
academic award in 2000, and the MLFi implementation was elected
“Software Product of the Year 2001” by the magazine *Risk*, the leading
financial trading and risk management publication. MLFi-based solutions
are gaining growing acceptance throughout Europe and are contributing to
spread the use of OCaml in the financial services industry.
|js}
  ; body_html = {js|<p>Developed by the company <a href="https://www.lexifi.com/">LexiFi</a>, the Modeling
Language for Finance (MLFi) is the first formal language that accurately
describes the most sophisticated capital market, credit, and investment
products. MLFi is implemented as an extension of OCaml.</p>
<p>MLFi users derive two important benefits from a functional programming
approach. First, the declarative formalism of functional programming
languages is well suited for <em>specifying</em> complex data structures and
algorithms. Second, functional programming languages have strong <em>list
processing</em> capabilities. Lists play a central role in finance where
they are used extensively to define contract event and payment
schedules.</p>
<p>In addition, MLFi provides crucial business integration capabilities
inherited from OCaml and related tools and libraries. This enables
users, for example, to interoperate with C and Java programs, manipulate
XML schemas and documents, and interface with SQL databases.</p>
<p>Data models and object models aiming to encapsulate the definitions and
behavior of financial instruments were developed by the banking industry
over the past two decades, but face inherent limitations that OCaml
helped overcome.</p>
<p>LexiFi's approach to modeling complex financial contracts received an
academic award in 2000, and the MLFi implementation was elected
“Software Product of the Year 2001” by the magazine <em>Risk</em>, the leading
financial trading and risk management publication. MLFi-based solutions
are gaining growing acceptance throughout Europe and are contributing to
spread the use of OCaml in the financial services industry.</p>
|js}
  }]

let all_fr = 
[
  { title = {js|Jane Street|js}
  ; slug = {js|jane-street|js}
  ; logo = {js|/success-stories/jane-street-thumb.jpg|js}
  ; background = {js|/success-stories/jane-street-bg.jpg|js}
  ; theme = {js|cyan|js}
  ; synopsis = {js|Jane Street is a quantitative trading firm and liquidity provider with a unique focus on technology and collaborative problem solving.|js}
  ; url = {js|https://janestreet.com/technology/|js}
  ; body_md = {js|
Jane Street est une société de négoce propriétaire qui utilise OCaml comme sa 
plate-forme de développement primaire. Notre exploitation fonctionne à grande 
échelle, générant des milliards de dollars de transactions chaque jour à partir 
de nos bureaux de Hong Kong,Londres et New York, avec des stratégies qui couvrent 
de nombreuses classes d’actifs, fuseaux horaires et régimes réglementaires.

Presque tous nos logiciels sont écrits dans OCaml, du code de recherche statistique 
aux outils d’administration des systèmes en retour de notre infrastructure de trading 
en temps réel. Le système de type d’OCaml agit comme un ensemble riche et bien intégré 
d’outils d’analyse statique qui aident à améliorer la qualité de notre code, en 
attrapant les bogues le plus tôt possible. Chaque jour, des milliards de dollars de 
transactions passent par nos systèmes, ce qui fait en sorte que les choses se passent 
bien. Dans le même temps, OCaml est très productif, nous aidant à nous adapter rapidement 
à l’évolution des conditions du marché.

Jane Street contribue aux bibliothèques open-source à l’ensemble de la communauté depuis 
de nombreuses années, y compris Core, notre bibliothèque standard alternative, Async, une 
bibliothèque coopérative de concurrence, et plusieurs extensions syntaxiques comme binprot 
et sexplib.Tous ces éléments peuvent être trouvés à 
[https://janestreet.github.io](https://janestreet.github.io). Au total, nous avons ouvert
plus de 200k lignes de code.
|js}
  ; body_html = {js|<p>Jane Street est une société de négoce propriétaire qui utilise OCaml comme sa
plate-forme de développement primaire. Notre exploitation fonctionne à grande
échelle, générant des milliards de dollars de transactions chaque jour à partir
de nos bureaux de Hong Kong,Londres et New York, avec des stratégies qui couvrent
de nombreuses classes d’actifs, fuseaux horaires et régimes réglementaires.</p>
<p>Presque tous nos logiciels sont écrits dans OCaml, du code de recherche statistique
aux outils d’administration des systèmes en retour de notre infrastructure de trading
en temps réel. Le système de type d’OCaml agit comme un ensemble riche et bien intégré
d’outils d’analyse statique qui aident à améliorer la qualité de notre code, en
attrapant les bogues le plus tôt possible. Chaque jour, des milliards de dollars de
transactions passent par nos systèmes, ce qui fait en sorte que les choses se passent
bien. Dans le même temps, OCaml est très productif, nous aidant à nous adapter rapidement
à l’évolution des conditions du marché.</p>
<p>Jane Street contribue aux bibliothèques open-source à l’ensemble de la communauté depuis
de nombreuses années, y compris Core, notre bibliothèque standard alternative, Async, une
bibliothèque coopérative de concurrence, et plusieurs extensions syntaxiques comme binprot
et sexplib.Tous ces éléments peuvent être trouvés à
<a href="https://janestreet.github.io">https://janestreet.github.io</a>. Au total, nous avons ouvert
plus de 200k lignes de code.</p>
|js}
  };
 
  { title = {js|Le Langage de Modélisation Financière de LexiFi|js}
  ; slug = {js|le-langage-de-modlisation-financire-de-lexifi|js}
  ; logo = {js|/success-stories/lexifi-thumb.jpg|js}
  ; background = {js|/success-stories/lexifi-bg.jpg|js}
  ; theme = {js|orange|js}
  ; synopsis = {js|Integrated end-user software solution to efficiently manage all types of structured investment products and provide superior client services.|js}
  ; url = {js|https://www.lexifi.com/|js}
  ; body_md = {js|
Développé par la société [LexiFi](https://www.lexifi.com/), le Langage de
Modélisation Financière (MLFi) est le premier langage formel capable de
décrire les produits d'investissement, de crédit et de marché de
capitaux les plus sophistiqués. MLFi est implanté comme une extension
d'OCaml.

Les utilisateurs de MLFi retirent deux importants bénéfices de
l'approche par programmation fonctionnelle. D'abord, le formalisme
déclaratif des langages de programmation fonctionnels est adapté à la
*spécification* de structures de données et d'algorithmes complexes.
Ensuite, ces langages offrent de nombreuses facilités pour la
manipulation des listes. Or, les listes jouent un rôle central en
finance, où elles sont utilisées de façon intensive pour définir des
agendas d'événements de contrats et de paiements.

De plus, MLFi est doté de capacités d'intégration cruciales, héritées
d'OCaml et des outils et librairies qui l'accompagnent, Cela permet aux
utilisateurs, par exemple, d'interopérer avec des programmes C et Java,
de manipuler des schémas et documents XML, et de s'interfacer avec des
bases de données SQL.

Des modèles de données et modèles objets visant à encapsuler les
définitions et le comportement des instruments financiers ont été
développés par l'industrie bancaire depuis deux décennies, mais font
face à des limitations inhérentes qu'OCaml a aidé à surpasser.

L'approche de LexiFi pour la modélisation de contrats financiers
complexes a reçu une récompense académique en 2000, et l'implantation de
MLFi a été nommée « Produit Logiciel de l'Année 2001 » par le magazine
*Risk*, la principale publication dans le domaine des échanges
financiers et de la gestion des risques. Les solutions basées sur MLFi
gagnent en reconnaissance à travers l'Europe et contribuent à répandre
l'utilisation d'OCaml dans l'industrie des services financiers.
|js}
  ; body_html = {js|<p>Développé par la société <a href="https://www.lexifi.com/">LexiFi</a>, le Langage de
Modélisation Financière (MLFi) est le premier langage formel capable de
décrire les produits d'investissement, de crédit et de marché de
capitaux les plus sophistiqués. MLFi est implanté comme une extension
d'OCaml.</p>
<p>Les utilisateurs de MLFi retirent deux importants bénéfices de
l'approche par programmation fonctionnelle. D'abord, le formalisme
déclaratif des langages de programmation fonctionnels est adapté à la
<em>spécification</em> de structures de données et d'algorithmes complexes.
Ensuite, ces langages offrent de nombreuses facilités pour la
manipulation des listes. Or, les listes jouent un rôle central en
finance, où elles sont utilisées de façon intensive pour définir des
agendas d'événements de contrats et de paiements.</p>
<p>De plus, MLFi est doté de capacités d'intégration cruciales, héritées
d'OCaml et des outils et librairies qui l'accompagnent, Cela permet aux
utilisateurs, par exemple, d'interopérer avec des programmes C et Java,
de manipuler des schémas et documents XML, et de s'interfacer avec des
bases de données SQL.</p>
<p>Des modèles de données et modèles objets visant à encapsuler les
définitions et le comportement des instruments financiers ont été
développés par l'industrie bancaire depuis deux décennies, mais font
face à des limitations inhérentes qu'OCaml a aidé à surpasser.</p>
<p>L'approche de LexiFi pour la modélisation de contrats financiers
complexes a reçu une récompense académique en 2000, et l'implantation de
MLFi a été nommée « Produit Logiciel de l'Année 2001 » par le magazine
<em>Risk</em>, la principale publication dans le domaine des échanges
financiers et de la gestion des risques. Les solutions basées sur MLFi
gagnent en reconnaissance à travers l'Europe et contribuent à répandre
l'utilisation d'OCaml dans l'industrie des services financiers.</p>
|js}
  }]

