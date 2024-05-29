---
title: Tutoriel Format
description: "Article \xE9crit par Mattias. Le module Format d\u2019OCaml est un module
  extr\xEAmement puissant mais malheureusement tr\xE8s mal utilis\xE9. Il combine
  notamment deux \xE9l\xE9ments distincts : les bo\xEEtes d\u2019impression \xE9l\xE9gante\nles
  tags s\xE9mantiques Le pr\xE9sent article vise \xE0 d\xE9mystifier une grande partie
  ..."
url: https://ocamlpro.com/blog/2020_06_01_fr_tutoriel_format
date: 2020-06-01T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    OCamlPro\n  "
source:
---

<p><em>Article &eacute;crit par Mattias.</em></p>
<p>Le module <a href="http://caml.inria.fr/pub/docs/manual-ocaml/libref/Format.html">Format</a> d&rsquo;OCaml est un module extr&ecirc;mement puissant mais malheureusement tr&egrave;s mal utilis&eacute;. Il combine notamment deux &eacute;l&eacute;ments distincts :</p>
<ul>
<li>les bo&icirc;tes d&rsquo;impression &eacute;l&eacute;gante
</li>
<li>les tags s&eacute;mantiques
</li>
</ul>
<p>Le pr&eacute;sent article vise &agrave; d&eacute;mystifier une grande partie de ce module afin de d&eacute;couvrir l&rsquo;ensemble des choses qu&rsquo;il est possible de faire avec.</p>
<p>Si tout va bien vous devriez passer de</p>
<p><img src="https://ocamlpro.com/blog/assets/img/error1-output.png" alt="sortie triviale"/></p>
<p>&agrave;</p>
<p><img src="https://ocamlpro.com/blog/assets/img/ocaml-output.png" alt="sortie OCaml"/></p>
<p>(En r&eacute;alit&eacute; nous arriverons &agrave; un r&eacute;sultat l&eacute;g&egrave;rement diff&eacute;rent car l&rsquo;auteur de ce tutoriel n&rsquo;aime pas tous les choix faits pour afficher les messages d&rsquo;erreur en OCaml mais les diff&eacute;rences n&rsquo;auront pas de grande importance)</p>
<h2>I. Introduction g&eacute;n&eacute;rale : <code>fprintf fmt &quot;%a&quot; pp_error e</code></h2>
<p>Si vous ne comprenez pas ce que le code dans le titre doit faire, je
vous invite &agrave; lire attentivement ce qui va suivre. Sinon vous pouvez
directement sauter &agrave; la deuxi&egrave;me partie.</p>
<h3>I.1. Rappels sur <code>printf</code></h3>
<p>Pour rappel, la fonction <code>printf</code> est une fonction variadique (c&rsquo;est-&agrave;-dire qu&rsquo;elle peut prendre un nombre variable de param&egrave;tres).</p>
<ul>
<li>
<p>Le premier param&egrave;tre est une cha&icirc;ne de formattage compos&eacute;e de caract&egrave;res et de sp&eacute;cificateurs de format.</p>
<ul>
<li>Les <strong>caract&egrave;res</strong> sont affich&eacute;s tels quels. <code>printf &quot;abc&quot;</code> affichera <code>abc</code>.
</li>
<li>Les <strong>sp&eacute;cificateurs de caract&egrave;re</strong> sont des caract&egrave;res pr&eacute;c&eacute;d&eacute;s du caract&egrave;re <code>% </code>(syntaxe h&eacute;rit&eacute;e du C). Ils sont remplac&eacute;s &agrave; l&rsquo;ex&eacute;cution par un des param&egrave;tres fournis apr&egrave;s la cha&icirc;ne de formattage &agrave; la fonction et servent &agrave; indiquer de quel type doit &ecirc;tre la valeur qui sera affich&eacute;e (ainsi que d&rsquo;autres informations dont les d&eacute;tails peuvent &ecirc;tre trouv&eacute;s dans la documentation du module <a href="https://caml.inria.fr/pub/docs/manual-ocaml/libref/Printf.html">Printf</a>. <code>printf &quot;Test: %d&quot;</code> attend un entier sign&eacute; et affichera <code>Test: &lt;d&gt;</code> avec <code>&lt;d&gt;</code> remplac&eacute; par l&rsquo;entier fourni.
</li>
</ul>
</li>
<li>
<p>Les param&egrave;tres suivants sont les valeurs fournies &agrave; <code>printf</code> pour remplacer les sp&eacute;cificateurs de format</p>
<ul>
<li><code>printf &quot;%d %s %c&quot; 3 s 'a'</code> affichera l&rsquo;entier sign&eacute; 3, une espace ins&eacute;cable, le contenu de la variable <code>s</code> qui doit &ecirc;tre une cha&icirc;ne de caract&egrave;res, une autre espace ins&eacute;cable et finalement le caract&egrave;re &lsquo;a&rsquo;.
</li>
<li>On remarque aussi qu&rsquo;ici le nombre de param&egrave;tres suppl&eacute;mentaires fournis en plus de la cha&icirc;ne de formattage correspond au nombre de sp&eacute;cificateurs et que ceux-ci ne peuvent &ecirc;tre intervertis. <code>printf &quot;%d %c&quot; 'a' 3</code> ne pourra pas &ecirc;tre compil&eacute;/ex&eacute;cut&eacute; car <code>%d</code> attend un entier sign&eacute; et le premier param&egrave;tre est un caract&egrave;re. Les sp&eacute;cificateurs qui n&rsquo;attendent qu&rsquo;un argument sont des sp&eacute;cificateurs que j&rsquo;appelle <strong>unaires</strong> et sont extr&ecirc;mement faciles &agrave; utiliser, il faut seulement savoir quel caract&egrave;re correspond &agrave; quel type et les donner dans le bon ordre comme
illustr&eacute; dans la figure ci-dessous (le chevron repr&eacute;sentant la sortie standard)
</li>
</ul>
</li>
</ul>
<p><img src="https://ocamlpro.com/blog/assets/img/printf-base-out-dark.png" alt="Fonctionnement basique de printf"/></p>
<h3>I.2. Afficher un type d&eacute;fini par l&rsquo;utilisateur</h3>
<p>Arrive alors ce moment o&ugrave; vous commencez &agrave; d&eacute;finir vos propres structures de donn&eacute;es et, malheureusement, il n&rsquo;y a aucun moyen d&rsquo;afficher votre expression avec les sp&eacute;cificateurs par d&eacute;faut (ce qui semble normal). D&eacute;finissons donc notre propre type et affichons-le avec les techniques d&eacute;j&agrave; vues :</p>
<pre><code class="language-OCaml">type error =
  | Type_Error of string * string
  | Apply_Non_Function of string

let pp_error = function
  | Type_Error (s1, s2) -&gt; printf &quot;Type is %s instead of %s&quot; s1 s2
  | Apply_Non_Function s -&gt; printf &quot;Type is %s, this is not a function&quot; s
</code></pre>
<p>Supposons maintenant que nous ayons une liste d&rsquo;erreurs et que nous souhaitions les afficher en les s&eacute;parant par une ligne horizontale. Une premi&egrave;re solution serait la suivante :</p>
<pre><code class="language-OCaml">let pp_list l =
  List.iter (fun e -&gt;
      pp_error e;
      printf &quot;\n&quot;
    ) l
</code></pre>
<p>Cette fa&ccedil;on de faire a plusieurs inconv&eacute;nients (qui vont &ecirc;tre magiquement r&eacute;gl&eacute;s par la fonction du titre).</p>
<h3>I.3. Afficher sur un <code>formatter</code> abstrait</h3>
<p>Le premier inconv&eacute;nient est que <code>printf</code> envoie son r&eacute;sultat vers la sortie standard alors qu&rsquo;on peut vouloir l&rsquo;envoyer vers un fichier ou vers la sortie d&rsquo;erreur, par exemple.</p>
<p>La solution est <code>fprintf</code> (il serait de bon ton de feindre la surprise ici).</p>
<p><code>fprintf</code> prend un param&egrave;tre suppl&eacute;mentaire avant la cha&icirc;ne de formattage appel&eacute; <strong><code>formatter</code> abstrait</strong>. Ce param&egrave;tre est du type <code>formatter</code> et repr&eacute;sente un imprimeur &eacute;l&eacute;gant (ou <em>pretty-printer</em>)</p>
<p>c&rsquo;est-&agrave;-dire l&rsquo;objet vers lequel le r&eacute;sultat devra &ecirc;tre envoy&eacute;. L&rsquo;&eacute;norme avantage qui en d&eacute;coule est qu&rsquo;on peut transformer beaucoup de choses en <code>formatter</code>. Un fichier, un buffer, la sortie standard etc. &Agrave; vrai dire, <code>printf</code> est impl&eacute;ment&eacute; comme <code>let printf = fprintf std_formatter</code></p>
<p>Pour l&rsquo;utiliser on va donc modifier <code>pp_error</code> et lui donner un param&egrave;tre suppl&eacute;mentaire :</p>
<pre><code class="language-OCaml">let pp_error fmt = function
  | Type_Error (s1, s2) -&gt; fprintf fmt &quot;Type is %s instead of %s&quot; s1 s2
  | Apply_Non_Function s -&gt; fprintf fmt &quot;Type is %s, this is not a function&quot; s
</code></pre>
<p>Puis on r&eacute;&eacute;crit <code>pp_list</code> pour prendre cela en compte :</p>
<pre><code class="language-OCaml">let pp_list fmt l =
  List.iter (fun e -&gt;
      pp_error fmt e;
      fprintf fmt &quot;\n&quot;
    ) l
</code></pre>
<p>Comme on peut le voir dans la figure ci-dessous, <code>fprintf</code> imprime dans le <code>formatter</code> qui lui est fourni en param&egrave;tre et non plus sur la sortie standard.</p>
<p><img src="https://ocamlpro.com/blog/assets/img/fprintf-base-out-dark.png" alt="Fontionnement basique de fprintf"/></p>
<p>Si on veut maintenant afficher le r&eacute;sultat sur la sortie standard il suffira simplement de donner <code>pp_list std_formatter</code> comme <code>formatter</code> &agrave; <code>fprintf</code>. Cette fa&ccedil;on de faire n&rsquo;a, en r&eacute;alit&eacute;, que des avantages, puisqu&rsquo;elle permet d&rsquo;&ecirc;tre beaucoup plus fexible quant au <code>formatter</code> qui sera utilis&eacute; &agrave; l&rsquo;ex&eacute;cution du programme.</p>
<h3>I.4. Afficher des types complexes avec <code>%a</code></h3>
<p>Le deuxi&egrave;me probl&egrave;me arrivera bien assez vite si nous continuons avec cette m&eacute;thode. Pour bien le comprendre, reprenons <code>pp_error</code>. Dans le cas de <code>Type_error of string * string</code> on veut &eacute;crire <code>Type is s1 instead of s2</code> et on fournit donc &agrave; <code>fprintf</code> la cha&icirc;ne de formattage <code>&quot;Type is %s instead of %s&quot;</code> avec <code>s1</code> et <code>s2</code> en param&egrave;tres suppl&eacute;mentaires. Comment devrions-nous faire si <code>s1</code> et <code>s2</code> &eacute;taient des types d&eacute;finis par l&rsquo;utilisateur avec chacun leur fonction d&rsquo;affichage <code>pp_s1`` : formatter -&gt; s1 -&gt; unit</code> et <code>pp_s2 : formatter -&gt; s2 -&gt; unit</code> ? En suivant la logique de notre solution jusqu&rsquo;ici, nous &eacute;cririons le code suivant :</p>
<pre><code class="language-OCaml">let pp_error fmt = function
  | Type_Error (s1, s2) -&gt;
    fprintf fmt &quot;Type is &quot;;
    pp_s1 fmt s1;
    fprintf fmt &quot;instead of &quot;;
    pp_s2 fmt s2
  | Apply_non_function s -&gt; fprintf fmt &quot;Type is %s, this is not a function&quot; s
</code></pre>
<p>Il est assez facile de se rendre compte rapidement que plus nous devrons manipuler des types complexes, plus cette syntaxe s&rsquo;alourdira. Tout cela parce que les sp&eacute;cificateurs de caract&egrave;re unaires ne permettent de manipuler que les types de base d&rsquo;OCaml.</p>
<p>C&rsquo;est l&agrave; qu&rsquo;entre en jeu <code>%a</code>. Ce sp&eacute;cificateur de caract&egrave;re est, lui, binaire (ternaire en r&eacute;alit&eacute; mais un de ses param&egrave;tres est d&eacute;j&agrave; fourni). Ses param&egrave;tres sont :</p>
<ul>
<li>Une fonction d&rsquo;affichage de type <code>formatter -&gt; 'a -&gt; unit</code> (premier param&egrave;tre devant &ecirc;tre fourni)
</li>
<li>Le <code>formatter</code> dans lequel il doit afficher son r&eacute;sultat (qui ne doit pas &ecirc;tre fourni en plus)
</li>
<li>La valeur qu&rsquo;on souhaite afficher
</li>
</ul>
<p>Il appliquera ensuite le <code>formatter</code> et la valeur &agrave; la fonction fournie comme premier argument et lui donner la main pour qu&rsquo;elle affiche ce qu&rsquo;elle doit dans le <code>formatter</code> qui lui a &eacute;t&eacute; fourni en param&egrave;tre. Lorsqu&rsquo;elle aura termin&eacute;, l&rsquo;impression continuera. L&rsquo;exemple suivant montre le fonctionnement (avec une impression sur la sortie standard, <code>fmt</code> ayant &eacute;t&eacute; remplac&eacute; par <code>std-formatter</code></p>
<p><img src="https://ocamlpro.com/blog/assets/img/fprintfpa-base-out-dark.png" alt=""/></p>
<p>Dans notre cas nous avions d&eacute;j&agrave; transform&eacute; nos fonctions d&rsquo;affichage pour qu&rsquo;elles prennent un <code>formatter</code> abstrait et nous n&rsquo;avons donc presque rien &agrave; modifier :</p>
<pre><code class="language-OCaml">let pp_error fmt = function
  | Type_Error (s1, s2) -&gt; fprintf fmt &quot;Type is %s instead of %s&quot; s1 s2
  | Apply_Non_Function s -&gt; fprintf fmt &quot;Type is %s, this is not a function&quot; s

let pp_list fmt l =
  List.iter (fun e -&gt;
      fprintf fmt &quot;%a\n&quot; pp_error e;
    ) l
</code></pre>
<p>Et, bien s&ucirc;r, si <code>s1</code> et <code>s2</code> avaient eu leurs propres fonctions d&rsquo;affichage :</p>
<pre><code class="language-ocaml">let pp_error fmt = function
  | Type_Error (s1, s2) -&gt; fprintf fmt &quot;Type is %a instead of %a&quot; pp_s1 s1 pp_s2 s2
  | Apply_Non_Function s -&gt; fprintf fmt &quot;Type is %s, this is not a function&quot; s
</code></pre>
<p>Arriv&eacute;-e-s ici vous devriez &ecirc;tre &agrave; l&rsquo;aise avec les notions de <code>formatter</code> abstrait et de sp&eacute;cificateur de caract&egrave;re binaire et vous devriez donc pouvoir afficher n&rsquo;importe quelle structure de donn&eacute;e, m&ecirc;me r&eacute;cursive, sans aucun soucis. Je recommande vivement cette fa&ccedil;on de faire afin que tout changement qui devrait succ&eacute;der ne n&eacute;cessite pas de changer l&rsquo;int&eacute;gralit&eacute; du code.</p>
<h2>II. Les bo&icirc;tes d&rsquo;impression &eacute;l&eacute;gante</h2>
<p>Et pour justement avoir des changements qui ne n&eacute;cessitent pas de tout modifier, il va falloir s&rsquo;int&eacute;resser un minimum aux bo&icirc;tes d&rsquo;impression &eacute;l&eacute;gante.</p>
<p>Aussi appel&eacute;es <em>pretty-print boxes</em>, je les appellerai &ldquo;bo&icirc;tes&rdquo; dor&eacute;navant, un <a href="https://ocaml.org/learn/tutorials/format.fr.html">tutoriel</a> existe d&eacute;j&agrave;, fait par l&rsquo;&eacute;quipe de la biblioth&egrave;que standard.</p>
<p>L'id&eacute;e derri&egrave;re les bo&icirc;tes est tout simple :</p>
<blockquote>
<p>&Agrave; mon niveau je m&rsquo;occupe correctement de comment afficher mes &eacute;l&eacute;ments et je n&rsquo;impose rien au-dessus.</p>
</blockquote>
<p>Reprenons, par exemple, la fonction permettant d&rsquo;afficher les <code>error</code>:</p>
<pre><code class="language-ocaml">let pp_error fmt = function
  | Type_Error (s1, s2) -&gt; fprintf fmt &quot;Type is %s instead of %s&quot; s1 s2
  | Apply_Non_Function s -&gt; fprintf fmt &quot;Type is %s, this is not a function&quot; s
</code></pre>
<p>Si on ajoutait un retour &agrave; la ligne on imposerait &agrave; toute fonction nous appelant ce saut de ligne or ce n&rsquo;est pas &agrave; nous d&rsquo;en d&eacute;cider. Cette fonction, en l&rsquo;&eacute;tat, fait parfaitement ce qu&rsquo;elle doit faire.</p>
<p>Regardons, par contre, la fonction affichant une liste d&rsquo;erreur :</p>
<pre><code class="language-ocaml">let pp_list fmt l =
  List.iter (fun e -&gt;
      fprintf fmt &quot;%a\n&quot; pp_error e;
    ) l
</code></pre>
<p>A l&rsquo;issue de celle-ci un saut &agrave; ligne provenant du dernier &eacute;l&eacute;ment est forc&eacute;. Non seulement il n&rsquo;est pas recommand&eacute; d&rsquo;utiliser <code>n</code> (ou <code>@n</code> ou m&ecirc;me <code>@.</code>) car ce ne sont pas &agrave; proprement parler des directives de <code>Format</code> mais des directives syst&egrave;mes qui vont donc chambouler le reste de l&rsquo;impression.</p>
<blockquote>
<p>Malheureusement bien trop de d&eacute;veloppeurs et d&eacute;veloppeuses ont d&eacute;couvert <code>@.</code> en m&ecirc;me temps que <code>Format</code> et s&rsquo;en servent sans restriction. Au risque de me r&eacute;p&eacute;ter souvent : n&rsquo;utilisez pas <code>@.</code> !</p>
</blockquote>
<h3>II.1. Le sp&eacute;cificateur <code>@</code></h3>
<p>On l&rsquo;avait vu, une cha&icirc;ne de formattage est compos&eacute;e de caract&egrave;res et de sp&eacute;cificateurs de caract&egrave;res commen&ccedil;ant par <code>%</code> Les sp&eacute;cificateurs sont des caract&egrave;res qui ne sont pas affich&eacute;s et qui seront remplac&eacute;s avant l&rsquo;affichage final.</p>
<p><code>Format</code> ajoute son propre sp&eacute;cificateur de caract&egrave;re : <code>@</code>.</p>
<h4>II.1.a. Le vidage (<em>flush</em>)</h4>
<p>La premi&egrave;re sp&eacute;cification qu&rsquo;on a vue est donc celle qu&rsquo;il ne faut  presque jamais utiliser (ce qui pose la question de l&rsquo;avoir mentionn&eacute;e en premier lieu) : <code>@.</code>. Cette sp&eacute;cification indique seulement au moteur d&rsquo;impression qu&rsquo;&agrave; ce niveau l&agrave; il faut sauter une ligne et vider l&rsquo;imprimeur. Les deux autres sp&eacute;cifications semblables sont <code>@n</code> qui n&rsquo;indique que le saut de ligne et <code>@?</code> qui n&rsquo;indique que le vidage de l&rsquo;imprimeur. L&rsquo;inconv&eacute;nient de ces trois sp&eacute;cificateurs est qu&rsquo;ils sont trop puissants et chamboulent donc le bon fonctionnement du reste de l&rsquo;impression. Je n&rsquo;ai personnellement jamais utilis&eacute; <code>@n</code> (autant utiliser une bo&icirc;te avec un sp&eacute;cificateur de coupure comme nous le verrons imm&eacute;diatement apr&egrave;s) et n&rsquo;utilise <code>@. </code>que lorsque je sais qu&rsquo;il ne reste rien &agrave; imprimer.</p>
<h4>II.1.b. Les indications de coupure ou d&rsquo;espace</h4>
<p>Important :</p>
<ul>
<li>Une indication de coupure saute &agrave; la ligne s&rsquo;il le faut sinon elle ne fait rien
</li>
<li>Une indication d&rsquo;espace s&eacute;cable saute &agrave; la ligne s&rsquo;il le faut, sinon elle affiche une espace
</li>
</ul>
<p>Les deux sont donc des indications de saut de ligne si n&eacute;cessaire, il
n&rsquo;existe pas d&rsquo;indication d&rsquo;espace par d&eacute;faut ou rien s&rsquo;il n&rsquo;y a pas
assez d&rsquo;espace (utiliser <code> </code> affichera toujours une espace).</p>
<p>Les indications sont au nombre de trois (et leur fonctionnement sera bien plus clair lorsque vous verrez les bo&icirc;tes) :</p>
<ul>
<li><code>@,</code> : indication de coupure (c&rsquo;est-&agrave;-dire rien prioritairement ou un saut &agrave; la ligne s&rsquo;il le faut)
</li>
<li><code>@&#9141;</code> : indique une espace s&eacute;cable (c&rsquo;est-&agrave;-dire une espace prioritairement
ou un saut &agrave; la ligne s&rsquo;il le faut) (Il faut bien &eacute;videmment comprendre
le caract&egrave;re <code>&#9141;</code> comme l&rsquo;espace blanc habituel)
</li>
<li><code>@;&lt;n o&gt;</code> : indique <code>n</code> espaces s&eacute;cables ou une coupure indent&eacute;e de <code>o</code> (c&rsquo;est-&agrave;-dire <code>n</code> espaces s&eacute;cables prioritairement ou un saut &agrave; la ligne <strong>avec une indentation suppl&eacute;mentaire de <code>o</code></strong> s&rsquo;il le faut)
</li>
</ul>
<p>D&rsquo;apr&egrave;s ce que je viens d&rsquo;&eacute;crire il devrait &ecirc;tre &eacute;vident maintenant que le caract&egrave;re est une espace ins&eacute;cable qui ne provoquera donc pas de saut &agrave; la ligne quand bien m&ecirc;me on d&eacute;passerait les limites de celle-ci. Contrairement &agrave; nos espaces de traitement de texte habituel qui sont des espaces s&eacute;cables (pouvant provoquer des sauts de ligne), il faut sp&eacute;cifier quels espaces sont s&eacute;cables lorsqu&rsquo;on utilise Format.</p>
<p>On &eacute;crira par exemple <code>fprintf fmt &quot;let rec f =@ %a&quot; pp_expr e</code> car on ne veut pas que <code>let rec f =</code> soit s&eacute;par&eacute; en plusieurs lignes mais on met bien <code>@&#9141;</code> avant <code>%a</code> car l&rsquo;expression sera soit sur la m&ecirc;me ligne si suffisament petite soit &agrave; la ligne suivante si trop grande (on devrait m&ecirc;me &eacute;crire <code>@;&lt;1 2&gt;</code> pour que l&rsquo;expression soit indent&eacute;e si on saute &agrave; la ligne suivante mais, on va le voir imm&eacute;diatement, c&rsquo;est l&agrave; que les bo&icirc;tes nous permettent d&rsquo;automatiser ce genre de comportement)</p>
<h4>II.1.c. Les bo&icirc;tes</h4>
<p>La deuxi&egrave;me sp&eacute;cification est celle permettant d&rsquo;ouvrir et de fermer des bo&icirc;tes.</p>
<p>Une bo&icirc;te se commence par <code>@[</code> et se termine par <code>@]</code>. Entre ces deux bornes, on fait ce qu&rsquo;on veut (<strong>sauf utiliser <code>@.</code>, <code>@?</code> ou <code>@\n</code> !</strong>). Tout ce qui se passe &agrave; l&rsquo;int&eacute;rieur de la bo&icirc;te reste (et doit rester) &agrave; l&rsquo;int&eacute;rieur de celle-ci. Indentation, coupures, bo&icirc;tes verticales, horizontales, les deux, l&rsquo;une ou l&rsquo;autre, toutes ces options sont accessibles une fois qu&rsquo;une bo&icirc;te a &eacute;t&eacute; ouverte. Voyons-les rapidement (pour rappel, la version d&eacute;taill&eacute;e est disponible dans le <a href="https://ocaml.org/learn/tutorials/format.fr.html">tutoriel</a>.</p>
<p>Une fois qu&rsquo;une bo&icirc;te a &eacute;t&eacute; ouverte on peut pr&eacute;ciser entre deux chevrons le comportement qu&rsquo;on veut qu&rsquo;elle ait en cas d&rsquo;indication de coupure, en voici un rapide aper&ccedil;u :</p>
<ul>
<li><code>&lt;v&gt;</code> : Toute indication de coupure entra&icirc;ne un saut &agrave; la ligne
</li>
<li><code>&lt;h&gt;</code> : Toute indication d&rsquo;espace entra&icirc;ne une espace, les indications de coupure n&rsquo;ont aucun effet
</li>
<li><code>&lt;hv&gt;</code>: Si toute la bo&icirc;te peut &ecirc;tre imprim&eacute;e sur la m&ecirc;me ligne alors seules les indications d&rsquo;espace sont prises en compte sinon seules les indications de coupure le sont et chaque &eacute;l&eacute;ment est imprim&eacute; sur sa propre ligne
</li>
<li><code>&lt;hov&gt;</code> : Tant que des &eacute;l&eacute;ments peuvent &ecirc;tre imprim&eacute;s sur une ligne ils le sont avec leurs indications d&rsquo;espace. Les indications de coupure sont utilis&eacute;es lorsqu&rsquo;il faut sauter une ligne.
</li>
</ul>
<p>Chacun de ces comportements peut se voir attribuer une valeur suppl&eacute;mentaire, sa valeur d&rsquo;indentation, qui indique l&rsquo;indentation par rapport au d&eacute;but de la bo&icirc;te qui devra &ecirc;tre ajout&eacute;e &agrave; chaque saut de ligne.</p>
<p>Soit le code suivant permettant d&rsquo;afficher une liste d&rsquo;items s&eacute;par&eacute;s soit par une indication de coupure <code>@,</code>, soit par une indication d&rsquo;espace <code>@&#9141;</code> soit par une indication d&rsquo;espace ou de coupure indent&eacute;e <code>@;&lt;2 3&gt;</code> (2 espaces ou une coupure indent&eacute;e de trois espaces) :</p>
<pre><code class="language-ocaml">open Format

let l = [&quot;toto&quot;; &quot;tata&quot;; &quot;titi&quot;]

let pp_item fmt s = fprintf fmt &quot;%s&quot; s

let pp_cut fmt () = fprintf fmt &quot;@,&quot;
let pp_spc fmt () = fprintf fmt &quot;@ &quot;
let pp_brk fmt () = fprintf fmt &quot;@;&lt;2 3&gt;&quot;


let pp_list pp_sep fmt l =
  pp_print_list pp_item ~pp_sep fmt l
</code></pre>
<p>Voici un r&eacute;capitulatif des diff&eacute;rents comportements de bo&icirc;tes en fonction des indications de coupure/espace rencontr&eacute;es :</p>
<pre><code class="language-ocaml">(* Boite verticale (tout est coupure) *)
printf &quot;------------@.&quot;;
printf &quot;v@.&quot;;
printf &quot;------------@.&quot;;
printf &quot;@[&lt;v 2&gt;[%a]@]@.&quot; (pp_list pp_cut) l;
printf &quot;@[&lt;v 2&gt;[%a]@]@.&quot; (pp_list pp_spc) l;
printf &quot;@[&lt;v 2&gt;[%a]@]@.&quot; (pp_list pp_brk) l;
(* Sortie attendue:
------------
v
------------
[toto
  tata
  titi]
[toto
  tata
  titi]
[toto
     tata
     titi]
*)


(* Bo&icirc;te horizontale (pas de coupure) *)
printf &quot;------------@.&quot;;
printf &quot;h@.&quot;;
printf &quot;------------@.&quot;;
printf &quot;@[&lt;h 2&gt;[%a]@]@.&quot; (pp_list pp_cut) l;
printf &quot;@[&lt;h 2&gt;[%a]@]@.&quot; (pp_list pp_spc) l;
printf &quot;@[&lt;h 2&gt;[%a]@]@.&quot; (pp_list pp_brk) l;
(* Sortie attendue:
------------
h
------------
[tototatatiti]
[toto tata titi]
[toto  tata  titi]
*)


(* Bo&icirc;te horizontale-verticale
  (Affiche tout sur une ligne si possible sinon bo&icirc;te verticale) *)
printf &quot;------------@.&quot;;
printf &quot;hv@.&quot;;
printf &quot;------------@.&quot;;
printf &quot;@[&lt;hv 2&gt;[%a]@]@.&quot; (pp_list pp_cut) l;
printf &quot;@[&lt;hv 2&gt;[%a]@]@.&quot; (pp_list pp_spc) l;
printf &quot;@[&lt;hv 2&gt;[%a]@]@.&quot; (pp_list pp_brk) l;
(* Sortie attendue:
------------
hv
------------
[toto
  tata
  titi]
[toto
  tata
  titi]
[toto
     tata
     titi]
*)


(* Bo&icirc;te horizontale ou verticale tassante
  (Affiche le maximum possible sur une ligne avant de sauter &agrave; la
   ligne suivante et recommencer) *)
printf &quot;------------@.&quot;;
printf &quot;hov@.&quot;;
printf &quot;------------@.&quot;;
printf &quot;@[&lt;hov 2&gt;[%a]@]@.&quot; (pp_list pp_cut) l;
printf &quot;@[&lt;hov 2&gt;[%a]@]@.&quot; (pp_list pp_spc) l;
printf &quot;@[&lt;hov 2&gt;[%a]@]@.&quot; (pp_list pp_brk) l;
(* Sortie attendue:
------------
hov
------------
[tototata
  titi]
[toto tata
  titi]
[toto
     tata
     titi]
*)

(*  Bo&icirc;te horizontale ou verticale structurelle
   (M&ecirc;me fonctionnement que la bo&icirc;te tassante sauf pour le dernier
    retour &agrave; la ligne qui tente de favoriser une indentation de
    niveau 0) *)
printf &quot;------------@.&quot;;
printf &quot;b@.&quot;;
printf &quot;------------@.&quot;;
printf &quot;@[&lt;b 2&gt;[%a]@]@.&quot; (pp_list pp_cut) l;
printf &quot;@[&lt;b 2&gt;[%a]@]@.&quot; (pp_list pp_spc) l;
printf &quot;@[&lt;b 2&gt;[%a]@]@.&quot; (pp_list pp_brk) l
(* Sortie attendue:
------------
b
------------
[tototata
  titi]
[toto tata
  titi]
[toto
     tata
     titi]
*)
</code></pre>
<p>Petite pr&eacute;cision sur l&rsquo;utilisation ici des <code>@.</code> alors qu&rsquo;il est recommand&eacute; de ne jamais les utiliser. Il ne faut en r&eacute;alit&eacute; pas <strong>jamais</strong> les utiliser, il faut seulement les utiliser lorsqu&rsquo;on est s&ucirc;r de n&rsquo;&ecirc;tre dans aucune bo&icirc;te. Ici, par exemple, on souhaite marquer distinctement les diff&eacute;rentes impressions de bo&icirc;tes, il est donc tout &agrave; fait correct d&rsquo;utiliser <code>@.</code> &eacute;tant donn&eacute; qu&rsquo;on est s&ucirc;r d&rsquo;&ecirc;tre au dernier niveau d&rsquo;impression (rien au-dessus) et de ne pas casser une passe d&rsquo;impression &eacute;l&eacute;gante. Il serait donc bien plus pr&eacute;cis de dire</p>
<blockquote>
<p>Il ne faut pas utiliser <code>@.</code>, <code>@n</code> et <code>@?</code> dans des impressions qui sont ou seront potentiellement imbriqu&eacute;es</p>
</blockquote>
<p>Mais il est bien plus simple pour commencer de ne jamais les utiliser quitte &agrave; les rajouter apr&egrave;s.</p>
<p>Le comportement de la bo&icirc;te <code>b</code> (bo&icirc;te structurelle) semble &ecirc;tre le m&ecirc;me que celui de la bo&icirc;te <code>hov</code> (bo&icirc;te tassante) mais il se trouve des cas o&ugrave; les deux diff&egrave;rent (g&eacute;n&eacute;ralement lorsqu&rsquo;un saut de ligne r&eacute;duit l&rsquo;indentation courante, la bo&icirc;te structurelle saute &agrave; la ligne m&ecirc;me s&rsquo;il reste de la place sur la ligne courante). Je vous invite &agrave; consulter le <a href="https://ocaml.org/learn/tutorials/format.fr.html">tutoriel</a> pour plus de pr&eacute;cisions (je dois aussi avouer que leur fonctionnement est tr&egrave;s proche de ce qu&rsquo;on pourrait appeler &ldquo;opaque&rdquo; &eacute;tant donn&eacute; qu&rsquo;en fonction de la taille de marge le comportement attendu aura lieu ou non. L&rsquo;auteur de ce tutoriel tient &agrave; pr&eacute;ciser qu&rsquo;il utilise plut&ocirc;t des bo&icirc;tes verticales avec une indentation nulle s&rsquo;il lui arrive de vouloir obtenir le comportement des bo&icirc;tes structurelles, un exemple est fourni lors de l&rsquo;affichage en HTML &agrave; la fin de ce document).</p>
<h3>II.2. R&eacute;capitulatif</h3>
<ul>
<li>Il faut utiliser des bo&icirc;tes
</li>
<li>Les indications de vidage fermant toutes les bo&icirc;tes, il ne faut surtout pas les utiliser dans des fonctions d&rsquo;affichage internes, il faut se limiter aux indications de
coupure et d&rsquo;espace
</li>
<li>Il faut vraiment utiliser des bo&icirc;tes
</li>
</ul>
<p>Vous voil&agrave; arm&eacute;-e-s pour utiliser Format dans sa version la plus simple, avec des bo&icirc;tes, de l&rsquo;indentation, des indications de coupure et d&rsquo;espace.</p>
<p>Reprenons notre affichage d&rsquo;erreur :</p>
<pre><code class="language-ocaml">let pp_error fmt = function
  | Type_Error (s1, s2) -&gt; fprintf fmt &quot;@[&lt;hov 2&gt;Type is %s@ instead of %s@]&quot; s1 s2
  | Apply_non_function s -&gt; fprintf fmt &quot;@[&lt;hov 2&gt;Type is %s,@ this is not a function@]&quot; s

let pp_list fmt l =
  pp_print_list pp_error fmt l
</code></pre>
<p>On a encapsul&eacute; l&rsquo;affichage des deux erreurs dans des bo&icirc;tes <code>hov</code> avec une indication d&rsquo;espace s&eacute;cable au milieu et utilis&eacute; la fonction <code>pp_print_list</code> du module <a href="https://caml.inria.fr/pub/docs/manual-ocaml/libref/Format.html">Format</a></p>
<p>Si je tente maintenant d&rsquo;afficher une liste d&rsquo;erreurs dans deux environnements, un de 50 colonnes et l&rsquo;autre de 25 colonnes de largeur avec le code suivant :</p>
<pre><code class="language-ocaml">let () =
  let e1 = Type_Error (&quot;int&quot;, &quot;bool&quot;) in
  let e2 = Apply_non_function (&quot;int&quot;) in
  let e3 = Type_Error (&quot;int&quot;, &quot;float&quot;) in
  let e4 = Apply_non_function (&quot;bool&quot;) in

  let el = [e1; e2; e3; e4] in
  pp_set_margin std_formatter 50;
  fprintf std_formatter &quot;--------------------------------------------------@.&quot;;
  fprintf std_formatter &quot;@[&lt;v 0&gt;%a@]@.&quot; pp_list el;
  pp_set_margin std_formatter 25;
  fprintf std_formatter &quot;-------------------------@.&quot;;
  fprintf std_formatter &quot;@[&lt;v 0&gt;%a@]@.&quot; pp_list el;
</code></pre>
<p>J&rsquo;obtiens le r&eacute;sultat suivant :</p>
<pre><code class="language-ocaml">--------------------------------------------------
Type is int instead of bool
Type is int, this is not a function
Type is int instead of float
Type is bool, this is not a function
-------------------------
Type is int
  instead of bool
Type is int,
  this is not a function
Type is int
  instead of float
Type is bool,
  this is not a function
</code></pre>
<p>Ce qu&rsquo;on rajoute en verbosit&eacute; on le gagne en &eacute;l&eacute;gance. Et en parlant d&rsquo;&eacute;l&eacute;gance, &ccedil;a manque de couleurs.</p>
<h2>III. Les tags s&eacute;mantiques</h2>
<p>Cette partie n&rsquo;est pas pr&eacute;sente dans le tutoriel mais dans un <a href="https://hal.archives-ouvertes.fr/hal-01503081/file/format-unraveled.pdf">article tutoriel</a> qui l&rsquo;explique assez rapidement.</p>
<p>La troisi&egrave;me sp&eacute;cification, donc (apr&egrave;s celles de coupure et de bo&icirc;tes), est la sp&eacute;cification de tag s&eacute;mantique : <code>@{</code> pour en ouvrir un et <code>@}</code> pour le fermer.</p>
<h3>III.1. Marquer son texte</h3>
<p>Mais avant de comprendre leur fonctionnement, cherchons &agrave; comprendre leur int&eacute;r&ecirc;t. Que vous souhaitiez afficher dans un terminal, dans une page html ou autre, il y a de fortes chances que cette sortie accepte les marques de texte comme l&rsquo;italique, la coloration etc. Utilisateur d&rsquo;emacs et d&rsquo;un <a href="https://en.wikipedia.org/wiki/ANSI_escape_code">terminal ANSI</a> je peux modifier l&rsquo;apparence de mon texte gr&acirc;ce aux codes ANSI :</p>
<p><img src="https://ocamlpro.com/blog/assets/img/exemple-ansiterm.png" alt="Exemple de marquage de texte dans un terminal ANSI"/></p>
<p>Si je cr&eacute;e un programme OCaml qui affiche cette cha&icirc;ne de charact&egrave;re et que je l&rsquo;ex&eacute;cute directement dans mon terminal je devrais obtenir le m&ecirc;me r&eacute;sultat :</p>
<p><img src="https://ocamlpro.com/blog/assets/img/exemple-ansiocaml-bad.png" alt="Exemple de marquage de texte dans un terminal ANSI depuis un programme OCaml qui se passe mal"/></p>
<p>Naturellement, &ccedil;a ne fonctionne pas, si l&rsquo;informatique &eacute;tait standardis&eacute;e et si tout le monde savait communiquer &ccedil;a se saurait. Il s&rsquo;av&egrave;re que le caract&egrave;re <code>033</code> est interpr&eacute;t&eacute; en octal par les terminaux ANSI mais en d&eacute;cimal par OCaml (ce qui semble &ecirc;tre l&rsquo;interpr&eacute;tation normale). OCaml permet de repr&eacute;senter un <a href="https://caml.inria.fr/pub/docs/manual-ocaml/lex.html#sss:character-literals">caract&egrave;re</a> selon plusieurs s&eacute;quences d&rsquo;&eacute;chappement diff&eacute;rentes :</p>
<table><thead><tr><th>S&eacute;quence</th><th>Caract&egrave;re r&eacute;sultant</th></tr></thead><tbody><tr><td><code>DDD</code></td><td>le caract&egrave;re correspondant au code ASCII <code>DDD</code> en d&eacute;cimal</td></tr><tr><td><code>xHH</code></td><td>le caract&egrave;re correspondant au code ASCII <code>HH</code> en hexad&eacute;cimal</td></tr><tr><td><code>oOOO</code></td><td>le caract&egrave;re correspondant au code ASCII <code>OOO</code> en octal</td></tr></tbody></table>
<p>On peut donc &eacute;crire au choix</p>
<pre><code class="language-ocaml">let () = Format.printf &quot;\027[36mBlue Text \027[0;3;30;47mItalic WhiteBG Black Text&quot;
let () = Format.printf &quot;\x1B[36mBlue Text \x1B[0;3;30;47mItalic WhiteBG Black Text&quot;
let () = Format.printf &quot;\o033[36mBlue Text \o033[0;3;30;47mItalic WhiteBG Black Text&quot;
</code></pre>
<p>Dans tous les cas, on obtient le r&eacute;sultat suivant :</p>
<p><img src="https://ocamlpro.com/blog/assets/img/exemple-ansiocaml-good.png" alt="Exemple de marquage de texte dans un terminal ANSI depuis un programme OCaml qui se passe bien"/></p>
<p>Que se passe-t-il, par contre, si j&rsquo;ex&eacute;cute une de ces lignes dans un terminal non ANSI ? En testant sur <a href="https://try.ocamlpro.com/">TryOCaml</a>:</p>
<p><img src="https://ocamlpro.com/blog/assets/img/tryocaml-ansi.png" alt="Exemple de marquage de texte dans un navigateur depuis TryOCaml"/></p>
<p>On ne veut surtout pas que ce genre d&rsquo;affichage puisse arriver. Il faudrait donc pouvoir s&rsquo;assurer que le marquage du texte soit actif uniquement quand on le d&eacute;cide. L&rsquo;id&eacute;e de cr&eacute;er deux cha&icirc;nes de formattage en fonction de notre capacit&eacute; ou non &agrave; afficher du texte marqu&eacute; n&rsquo;est clairement pas une bonne pratique de programmation (changer
une formulation demande de changer deux cha&icirc;nes de formattage, le code est difficilement maintenable). Il faudrait donc un outil qui puisse faire un pr&eacute;-traitement de notre cha&icirc;ne de formattage pour lui ajouter des d&eacute;corations.</p>
<p>Cet outil est d&eacute;j&agrave; fourni par Format, ce sont les tags s&eacute;mantiques.</p>
<h3>III.2 Les tags s&eacute;mantiques</h3>
<p>Introduits par <code>@{</code> et ferm&eacute;s par <code>@}</code>, comme les bo&icirc;tes ils sont param&eacute;tr&eacute;s par la construction <code>&lt;t&gt;</code> pour indiquer l&rsquo;ouverture (et la fermeture) du tag <code>t</code>. Contrairement aux bo&icirc;tes, les tags n&rsquo;ont aucune signification pour l&rsquo;imprimeur (on peut faire l&rsquo;analogie avec les types de base d&rsquo;OCaml que sont <code>int</code>, <code>bool</code>, <code>float</code> etc et les types d&eacute;finis par le programmeur ou la programmeuse (<code>type t = A | B</code>, par exemple. Les types de base ont d&eacute;j&agrave; une quantit&eacute; de fonctions qui leurs sont associ&eacute;s alors que les types d&eacute;finis ne signifient rien tant qu&rsquo;on n&rsquo;&eacute;crit pas les fonctions qui les manipuleront). L&rsquo;avantage premier de ces tags est donc que, n&rsquo;ayant aucune signification, ils sont tout simplement ignor&eacute;s par l&rsquo;imprimeur lors de l&rsquo;affichage de notre cha&icirc;ne de caract&egrave;re finale:</p>
<p><img src="https://ocamlpro.com/blog/assets/img/exemple-stag-tryocaml.png" alt="Exemple de marquage avec un tag s&eacute;mantique de texte dans un navigateur depuis TryOCaml"/></p>
<p>Par d&eacute;faut, l&rsquo;imprimeur ne traite pas les tags s&eacute;mantiques (ce qui
permet d&rsquo;avoir un comportement d&rsquo;affichage aussi simple que possible par
d&eacute;faut). Le traitement des tags s&eacute;mantiques peut &ecirc;tre activ&eacute; pour
chaque <code>formatter</code> ind&eacute;pendamment avec les fonctions <code>val pp_set_tags : formatter -&gt; bool -&gt; unit</code>, <code>val pp_set_print_tags : formatter -&gt; bool -&gt; unit</code> et <code>val pp_set_mark_tags : formatter -&gt; bool -&gt; unit</code> dont on verra les effets imm&eacute;diatement. Voyons d&eacute;j&agrave; ce qui se passe avec la fonction g&eacute;n&eacute;rale <code>pp_set_tags</code> qui combine les deux suivantes :</p>
<p><img src="https://ocamlpro.com/blog/assets/img/exemple-stag-actif-tryocaml.png" alt="Exemple de traitement du marquage avec un tag s&eacute;mantique de texte dans un navigateur depuis TryOCaml"/></p>
<p>Que s&rsquo;est-il pass&eacute; ?</p>
<p>Une fois que le traitement des tags s&eacute;mantiques est activ&eacute;, quatre
op&eacute;rations vont &ecirc;tre effectu&eacute;es &agrave; chaque ouverture et fermeture de tag :</p>
<ul>
<li><code>print_open_stag</code> suivie de <code>mark_open_stag</code> pour chaque tag <code>t</code> ouvert avec <code>@{&lt;t&gt;</code>
</li>
<li><code>mark_close_stag</code> suivie de <code>print_close_stag</code> pour chaque tag <code>t</code> ferm&eacute; avec <code>@}</code> correspondant &agrave; la derni&egrave;re ouverture <code>@{&lt;t&gt;</code>
</li>
</ul>
<p>Regardons les signatures de ces quatre op&eacute;rations :</p>
<pre><code class="language-ocaml">type formatter_stag_functions = {
    mark_open_stag : stag -&gt; string;
       mark_close_stag : stag -&gt; string;
       print_open_stag : stag -&gt; unit;
       print_close_stag : stag -&gt; unit;
}
</code></pre>
<p>Les fonctions <code>mark_*_stag</code> prennent un tag s&eacute;mantique en param&egrave;tre et renvoie une cha&icirc;ne de caract&egrave;res quand les fonctions <code>print_*_stag</code> prennent le m&ecirc;me param&egrave;tre mais ne renvoient rien. La raison derri&egrave;re est en r&eacute;alit&eacute; toute simple :</p>
<ul>
<li>Les fonctions de marquage &eacute;crivent directement dans la cible d&rsquo;affichage (le terminal, le fichier ou autre)
</li>
<li>Les fonctions d&rsquo;affichage &eacute;crivent dans le <code>formatter</code> qui les traite comme des cha&icirc;nes de caract&egrave;res normales qui peuvent donc entra&icirc;ner des sauts de ligne, des coupures, de nouvelles bo&icirc;tes etc
</li>
</ul>
<p>Une indication de couleur pour un terminal ANSI n&rsquo;appara&icirc;t pas &agrave; l&rsquo;affichage, le texte se retrouve color&eacute;, il semble donc naturel de ne pas vouloir que cette indication ait un effet sur l&rsquo;impression &eacute;l&eacute;gante. En revanche, si on voulait avoir une sortie vers un fichier LaTeX ou HTML, cette indication de couleur appara&icirc;tra&icirc;t et devrait donc avoir une influence sur l&rsquo;impression &eacute;l&eacute;gante.</p>
<p>Il est donc assez simple de savoir dans quel cas on veut utiliser <code>print_*_stag</code> ou <code>mark_*_stag</code> :</p>
<ul>
<li>Si le tag doit avoir un impact imm&eacute;diat sur l&rsquo;apparence du texte affich&eacute; (couleur, taille, d&eacute;corations&hellip;) et non pas son contenu, il faut utiliser <code>mark_*_stag</code>
</li>
<li>Si le tag doit avoir un impact sur le contenu du texte affich&eacute; et non pas sur son apparence, il faut utiliser <code>print_*_stag</code>
</li>
<li>Si le tag doit avoir un impact &agrave; la fois sur le contenu et l&rsquo;apparence du texte affich&eacute; alors il faut utiliser les deux en s&eacute;parant bien entre contenu g&eacute;r&eacute; par <code>print_*_stag</code> et apparence g&eacute;r&eacute;e par <code>mark_*_stag</code>
</li>
</ul>
<p>Ces quatres fonctions ont chacune un comportement par d&eacute;faut que voici :</p>
<pre><code class="language-ocaml">let mark_open_stag = function
  | String_tag s -&gt; &quot;&lt;&quot; ^ s ^ &quot;&gt;&quot;
  | _ -&gt; &quot;&quot;
let mark_close_stag = function
  | String_tag s -&gt; &quot;&lt;/&quot; ^ s ^ &quot;&gt;&quot;
  
let print_open_stag = ignore
let print_close_stag = ignore
</code></pre>
<p>Le type <code>stag</code> est un type somme extensible (introduits dans <a href="https://ocaml.org/releases/4.02.html">OCaml 4.02.0</a>) c&rsquo;est-&agrave;-dire qu&rsquo;il est d&eacute;fini de la sorte</p>
<pre><code class="language-ocaml">type stag = ..

type stag += String_tag of string
</code></pre>
<p>Par d&eacute;faut seuls les <code>String_tag of string</code> sont donc reconnus comme des tags s&eacute;mantiques (ce sont aussi les seuls qui peuvent &ecirc;tre obtenus par la construction <code>@{&lt;t&gt; ... @}</code>, ici <code>t</code> sera trait&eacute; comme <code>String_tag t</code>) ce qui est illustr&eacute; par le comportement par d&eacute;faut de <code>mark_open_tag</code> et <code>mark_close_tag</code>. Ce comportement par d&eacute;faut nous permet aussi de comprendre ce qui est arriv&eacute; ici :</p>
<p><img src="https://ocamlpro.com/blog/assets/img/exemple-stag-actif-tryocaml_002.png" alt="Exemple de traitement du marquage avec un tag s&eacute;mantique de texte dans un navigateur depuis TryOCaml"/></p>
<p>N&rsquo;ayant pas personnalis&eacute; les op&eacute;rations de manipulation des tags, leur comportement par d&eacute;faut a &eacute;t&eacute; ex&eacute;cut&eacute;, ce qui revient &agrave; afficher directement le tag entre chevrons sans passer par le <code>formatter</code>. Il faut donc d&eacute;finir les comportements voulus pour nos tags (attention, ne manipulant que des cha&icirc;nes de caract&egrave;re, toute erreur est cons&eacute;quemment difficile &agrave; identifier et corriger, il vaut mieux donc &eacute;viter les c&eacute;l&egrave;bres <code>| _ -&gt; ()</code> &mdash; il faudrait en r&eacute;alit&eacute; les &eacute;viter tout le temps si possible mais c&rsquo;est une autre histoire).</p>
<p>Commen&ccedil;ons donc par d&eacute;finir nos tags et ce &agrave; quoi on veut qu&rsquo;ils correspondent :</p>
<pre><code class="language-ocaml">open Format

type style =
  | Normal

  | Italic
  | Italic_off

  | FG_Black
  | FG_Blue
  | FG_Default

  | BG_White
  | BG_Default

let close_tag = function
  | Italic -&gt; Italic_off
  | FG_Black | FG_Blue | FG_Default -&gt; FG_Default

  | BG_White | BG_Default -&gt; BG_Default

  | _ -&gt; Normal

let style_of_tag = function
  | String_tag s -&gt; begin match s with
      | &quot;n&quot; -&gt; Normal
      | &quot;italic&quot; -&gt; Italic
      | &quot;/italic&quot; -&gt; Italic_off

      | &quot;fg_black&quot; -&gt; FG_Black
      | &quot;fg_blue&quot; -&gt; FG_Blue
      | &quot;fg_default&quot; -&gt; FG_Default

      | &quot;bg_white&quot; -&gt; BG_White
      | &quot;bg_default&quot; -&gt; BG_Default

      | _ -&gt; raise Not_found
    end
  | _ -&gt; raise Not_found
</code></pre>
<p>Maintenant que chaque tag possible est g&eacute;r&eacute;, il nous faut les associer &agrave; leur valeur (ANSI dans ce cas) et impl&eacute;menter nos propres fonctions de marquages (et pas d&rsquo;affichage car a priori ces tags n&rsquo;ont aucun effet sur le contenu du texte affich&eacute;) :</p>
<pre><code class="language-ocaml">(* See https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_parameters for some values *)
let to_ansi_value = function
  | Normal -&gt; &quot;0&quot;

  | Italic -&gt; &quot;3&quot;
  | Italic_off -&gt; &quot;23&quot;

  | FG_Black -&gt; &quot;30&quot;
  | FG_Blue -&gt; &quot;34&quot;
  | FG_Default -&gt; &quot;39&quot;

  | BG_White -&gt; &quot;47&quot;
  | BG_Default -&gt; &quot;49&quot;

let ansi_tag = Printf.sprintf &quot;\x1B[%sm&quot;

let start_mark_ansi_stag t = ansi_tag @@ to_ansi_value @@ style_of_tag t

let stop_mark_ansi_stag t = ansi_tag @@ to_ansi_value @@ close_tag @@ style_of_tag t
</code></pre>
<p>On se le rappelle, l&rsquo;ouverture d&rsquo;un tag ANSI se fait avec la s&eacute;quence d&rsquo;&eacute;chappement <code>x1B</code> suivie de une ou plusieurs valeurs de tags s&eacute;par&eacute;es par <code>;</code> entre <code>[</code> et <code>m</code>. Dans notre cas chaque tag n&rsquo;est associ&eacute; qu&rsquo;&agrave; une valeur mais il serait tout &agrave; fait possible d&rsquo;avoir un <code>Error -&gt; &quot;1;4;31&quot;</code> qui imposerait un affichage gras, soulign&eacute; et en rouge. Tant que la cha&icirc;ne de caract&egrave;re renvoy&eacute;e au terminal correspond bien &agrave; une s&eacute;quence de marquage ANSI tout est possible.</p>
<p>Il faut ensuite faire en sorte que ces fonctions soient celles utilis&eacute;es par le <code>formatter</code> lors de leur traitement :</p>
<pre><code class="language-ocaml">let add_ansi_marking formatter =
  let open Format in
  pp_set_mark_tags formatter true;
  let old_fs = pp_get_formatter_stag_functions formatter () in
  pp_set_formatter_stag_functions formatter
    { old_fs with
      mark_open_stag = start_mark_ansi_stag;
      mark_close_stag = stop_mark_ansi_stag }
</code></pre>
<p>On utilise la fonction <code>pp_set_mark_tags</code> (au lieu de <code>pp_set_tags</code>) car on ne se sert pas de <code>print_*_stags</code> et on associe aux fonctions <code>mark_*_stag</code> les fonctions <code>*_ansi_stag</code>.</p>
<p>Il ne nous reste plus qu&rsquo;&agrave; faire en sorte que les tags s&eacute;mantiques soient trait&eacute;s et avec nos fonctions avant d&rsquo;afficher notre cha&icirc;ne de caract&egrave;res :</p>
<pre><code class="language-ocaml">let () =
  add_ansi_marking std_formatter;
  Format.printf &quot;@{&lt;fg_blue&gt;Blue Text @}@{&lt;italic&gt;@{&lt;bg_white&gt;@{&lt;fg_black&gt;Italic WhiteBG BlackFG Text@}@}@}&quot;
</code></pre>
<p>Et l&rsquo;affichage dans le terminal sera bien celui voulu :</p>
<p><img src="https://ocamlpro.com/blog/assets/img/ansi-color-term-stag.png" alt="Exemple de marquage avec la gestion des tags s&eacute;mantiques par Format dans un terminal ANSI"/></p>
<p>Si le programme doit &ecirc;tre affich&eacute; dans un terminal non ANSI il suffit simplement d&rsquo;enlever la ligne <code>add_ansi_marking std_formatter;</code> :</p>
<p><img src="https://ocamlpro.com/blog/assets/img/ansi-color-try-stag.png" alt="Exemple de marquage avec la gestion des tags s&eacute;mantiques par Format dans un terminal ANSI"/></p>
<p>On pourrait aussi faire en sorte que notre texte puisse &ecirc;tre envoy&eacute; vers un document HTML.</p>
<p>Il faut d&eacute;j&agrave; changer les valeurs associ&eacute;es aux tags (on voit ici l&rsquo;utilisation de bo&icirc;tes verticales &agrave; indentation nulle mentionn&eacute;e lors du paragraphe sur les bo&icirc;tes structurelles) :</p>
<pre><code class="language-ocaml">let to_html_value fmt =
  let fg_color c = Format.fprintf fmt {|@[&lt;v 0&gt;@[&lt;v 2&gt;&lt;span style=&quot;color:%s;&quot;&gt;@,|} c in
  let bg_color c = Format.fprintf fmt {|@[&lt;v 0&gt;@[&lt;v 2&gt;&lt;span style=&quot;background-color:%s;&quot;&gt;@,|} c in
  let close_span () = Format.fprintf fmt &quot;@]@,&lt;/span&gt;@]&quot; in
  let default = Format.fprintf fmt in
  fun t -&gt; match t with
    | Normal -&gt; ()

    | Italic -&gt; default &quot;&lt;i&gt;&quot;
    | Italic_off -&gt; default &quot;&lt;/i&gt;&quot;

    | FG_Black -&gt; fg_color &quot;black&quot;
    | FG_Blue -&gt; fg_color &quot;blue&quot;
    | FG_Default -&gt; close_span ()

    | BG_White -&gt; bg_color &quot;white&quot;
    | BG_Default -&gt; close_span ()
</code></pre>
<p>La construction <code>{| ... |}</code> permet d&rsquo;avoir des cha&icirc;nes de caract&egrave;res sans les caract&egrave;res sp&eacute;ciaux <code>&quot;</code> et `` ce qui permet d&rsquo;&eacute;crire <code>{|&quot;This is a nice &quot;|}</code> sans espacer ces caract&egrave;res.</p>
<p>De m&ecirc;me, la construction</p>
<pre><code class="language-ocaml">let fonction arg1 ... argn =
  let expr1 = ... in
  ...
  let exprn = ... in
fun argn1 ... argnm -&gt;
</code></pre>
<p>Permet de d&eacute;finir des expressions internes &agrave; une fonction qui
d&eacute;pendent des arguments fournis avant et donc, dans le cas d&rsquo;une
application partielle, de calculer cet environnement une seule fois.
Dans le cas de la fonction <code>to_html_value</code> je pourrai donc cr&eacute;er la nouvelle application partielle <code>let to_html_value_std = to_html_value std_formatter</code> qui contiendra donc directment les impl&eacute;mentations de <code>fg_color</code>, <code>bg_color</code>, <code>close_span</code> et <code>default</code> pour <code>std_formatter</code>.</p>
<p>Contrairement au cas du terminal ANSI, ce qui changera sera le
contenu et non pas l&rsquo;apparence du texte, nous utiliserons donc les
fonctions <code>print_*_stag</code>. C&rsquo;est pourquoi nos fonctions doivent directement &eacute;crire dans le <code>formatter</code> et non pas renvoyer une cha&icirc;ne de caract&egrave;res.</p>
<p>Les fonctions d&rsquo;ouverture et de fermeture ne changent pas &eacute;norm&eacute;ment :</p>
<pre><code class="language-ocaml">let start_print_html_stag fmt t =
  to_html_value fmt @@ style_of_tag t

let stop_print_html_stag fmt t =
  to_html_value fmt @@ close_tag @@ style_of_tag t
</code></pre>
<p>On associe ensuite ces fonctions aux fonctions <code>print_*_stag</code> :</p>
<pre><code class="language-ocaml">let add_html_printings formatter =
  let open Format in
  pp_set_mark_tags formatter false;
  pp_set_print_tags formatter true;
  let old_fs = pp_get_formatter_stag_functions formatter () in
  pp_set_formatter_stag_functions formatter
    { old_fs with
      print_open_stag = start_print_html_stag formatter;
      print_close_stag = stop_print_html_stag formatter}
</code></pre>
<p>On en profite pour d&eacute;sactiver le marquage sur le formatter pass&eacute; en
param&egrave;tre. Cela &eacute;vite d&rsquo;avoir de mauvaises surprises au cas o&ugrave; il aurait
&eacute;t&eacute; activ&eacute; pr&eacute;c&eacute;demment (il aurait fallu faire de m&ecirc;me lors du marquage
pour le terminal ANSI).</p>
<p>Finalement, l&rsquo;appel &agrave; :</p>
<pre><code class="language-ocaml">let () =
  add_html_printings std_formatter;
  Format.printf &quot;@[&lt;v 0&gt;@{&lt;fg_blue&gt;Blue Text @}@,@{&lt;italic&gt;@{&lt;bg_white&gt;@{&lt;fg_black&gt;Italic WhiteBG BlackFG Text@}@}@}@]@.&quot;
</code></pre>
<p>Nous donne le r&eacute;sultat attendu :</p>
<pre><code class="language-html">&lt;span style=&quot;color:blue;&quot;&gt;
  Blue Text
&lt;/span&gt;
&lt;i&gt;
  &lt;span style=&quot;background-color:white;&quot;&gt;
     &lt;span style=&quot;color:black;&quot;&gt;
       Italic WhiteBG BlackFG Text
     &lt;/span&gt;
   &lt;/span&gt;
&lt;/i&gt;
</code></pre>
<h2>Conclusion</h2>
<p>Nous voici arriv&eacute;s &agrave; la fin de ce tutoriel qui, je l&rsquo;esp&egrave;re, vous
permettra d&rsquo;appr&eacute;hender le module Format avec bien plus de s&eacute;r&eacute;nit&eacute;.</p>
<p>Dans les possibilit&eacute;s non pr&eacute;sent&eacute;es ici mais qu&rsquo;il est int&eacute;ressant d&rsquo;avoir en m&eacute;moire :</p>
<ul>
<li>Possibilit&eacute; de red&eacute;finir int&eacute;gralement toutes les fonctions d&rsquo;affichage d&eacute;finies dans l&rsquo;enregistrement :
</li>
</ul>
<pre><code class="language-html">&lt;span class=&quot;hljs-keyword&quot;&gt;type&lt;/span&gt;
formatter_out_functions = {
    out_string :
    &lt;span class=&quot;hljs-built_in&quot;&gt;string&lt;/span&gt; -&gt; &lt;span class=&quot;hljs-built_in&quot;&gt;int&lt;/span&gt; -&gt; &lt;span class=&quot;hljs-built_in&quot;&gt;int&lt;/span&gt; -&gt; &lt;span class=&quot;hljs-built_in&quot;&gt;unit&lt;/span&gt;;
    out_flush :
    &lt;span class=&quot;hljs-built_in&quot;&gt;unit&lt;/span&gt; -&gt; &lt;span class=&quot;hljs-built_in&quot;&gt;unit&lt;/span&gt;;
    out_newline :
    &lt;span class=&quot;hljs-built_in&quot;&gt;unit&lt;/span&gt; -&gt; &lt;span class=&quot;hljs-built_in&quot;&gt;unit&lt;/span&gt;;
    out_spaces :
    &lt;span class=&quot;hljs-built_in&quot;&gt;int&lt;/span&gt; -&gt; &lt;span class=&quot;hljs-built_in&quot;&gt;unit&lt;/span&gt;;
    out_indent :
    &lt;span class=&quot;hljs-built_in&quot;&gt;int&lt;/span&gt; -&gt; &lt;span class=&quot;hljs-built_in&quot;&gt;unit&lt;/span&gt;;
}
</code></pre>
<ul>
<li>Possibilit&eacute; de transformer n&rsquo;importe quel sortie en un formatter pour &eacute;crire directement dedans sans avoir &agrave; passer par des cha&icirc;nes de caract&egrave;re interm&eacute;diaire (notamment la fonction <code>val formatter_of_buffer : Buffer.t -&gt; formatter</code> qui permet directement d&rsquo;&eacute;crire dans un buffer
</li>
<li>L&rsquo;impression &eacute;l&eacute;gante symbolique qui imprime de fa&ccedil;on symbolique donc permet de voir directement quelles directives seront envoy&eacute;es au <code>formatter</code> &agrave; l&rsquo;impression. Tr&egrave;s utile pour d&eacute;buguer en cas d&rsquo;impression cacophonique mais aussi extr&ecirc;mement puissant pour effectuer une phase de post-traitement (par exemple si on veut ajouter un symbole &agrave; chaque d&eacute;but de ligne)
</li>
<li>Les fonctions utiles qu&rsquo;il ne faut pas oublier d&rsquo;utiliser (je sais que les devs OCaml aiment r&eacute;inventer la roue mais il existe d&eacute;j&agrave; des fonctions pour afficher des listes, des options et les r&eacute;sultats <code>Ok _ | Error _</code>) :
</li>
</ul>
<pre><code class="language-ocaml">val pp_print_list : ?pp_sep:(formatter -&gt; unit -&gt; unit) -&gt; (formatter -&gt; 'a -&gt; unit) -&gt; formatter -&gt; 'a list -&gt; unit

(* Affiche une liste dont chaque &eacute;l&eacute;ment est s&eacute;par&eacute; par le s&eacute;parateur par d&eacute;faut `@,` ou celui fourni *)

val pp_print_option : ?none:(formatter -&gt; unit -&gt; unit) -&gt; (formatter -&gt; &lsquo;a -&gt; unit) -&gt; formatter -&gt; &lsquo;a option -&gt; unit

(* Affiche le contenu d&rsquo;une option en cas de Some contenu et rien par d&eacute;faut si None ou l&rsquo;affichage fourni *)&lt;/p&gt;

val pp_print result : ok:(formatter -&gt; &lsquo;a -&gt; unit) -&gt; error:(formatter -&gt; &lsquo;e -&gt; unit) -&gt; formatter -&gt; (&lsquo;a, &lsquo;e) result -&gt; unit

(* Affiche le contenu d&rsquo;un result. Les arguments ne sont ici pas optionnels et conditionnent l&rsquo;affichage en cas de Ok &lt;/em&gt; et de Error _ *)
</code></pre>
<ul>
<li>Enfin, une pellet&eacute;e de fonctions &agrave; la <code>printf</code> telles que, donc :
</li>
<li><code>fprintf</code> que nous avons d&eacute;j&agrave; vue
</li>
<li><code>dprintf</code> qui permet de retarder l'&eacute;valuation de l'impression et donc de ne pas calculer des impressions qui ne seront jamais faites
</li>
<li><code>ifprintf</code> qui n'affiche rien (utile lorsqu'on veut avoir la m&ecirc;me signature que <code>fprintf</code> mais en &eacute;tant s&ucirc;r que rien ne sera fait)
</li>
</ul>
<p>Sources :</p>
<ul>
<li>
<p>Tutoriel du site OCaml</p>
</li>
<li>
<p>Richard Bonichon, Pierre Weis. Format Unraveled. 28i&egrave;mes Journ&eacute;es Francophones des LangagesApplicatifs, Jan 2017, Gourette, France. hal-01503081</p>
</li>
</ul>
<p>Codes sources :</p>
<p>Code LaTeX correspondant &agrave; <code>printf</code></p>
<pre><code class="language-latex">\documentclass[tikz,border=10pt]{standalone}

\usepackage{tikz}
\usetikzlibrary{math}
\usetikzlibrary{tikzmark}

\usepackage{xcolor}

\pagecolor[rgb]{0,0,0}
\color[rgb]{1,1,1}

\colorlet{color1}{blue!50!white}
\colorlet{color2}{red!50!white}
\colorlet{color3}{green!50!black}

\begin{document}

\begin{tikzpicture}[remember picture]
\node [align=left,font=\ttfamily] at (0,0) {
    let s = &quot;toto&quot; in\[2em]
    printf &quot;{color{color1}\tikzmarknode{scd}{\%d}}
        {color{color2}\tikzmarknode{scc}{\%c}}
        {color{color3}\tikzmarknode{scs}{\%s}}&quot;
    {\color{color1}\tikzmarknode{d}{3}}
    {\color{color2}\tikzmarknode{c}{'c'}}
    {\color{color3}\tikzmarknode{s}{s}}\\[2em]
    &gt; &quot;3 c toto&quot;
};
\draw[&lt;-, color1] (scd.north) -- ++(0,0.5) -| (d);
\draw[&lt;-, color2] (scc.south) -- ++(0,-0.4) -| (c);
\draw[&lt;-, color3] (scs.north) -- ++(0,0.4) -| (s);
\end{tikzpicture}

end{document}
</code></pre>
<p>Code LaTeX correspondant &agrave; <code>fprintf</code>:</p>
<pre><code class="language-latex">\documentclass[tikz,border=10pt]{standalone}

\usepackage{tikz}
\usetikzlibrary{math}
\usetikzlibrary{decorations.pathreplacing,tikzmark}

\usepackage{xcolor}

\pagecolor[rgb]{0,0,0}
\color[rgb]{1,1,1}

\colorlet{color1}{blue!50!white}
\colorlet{color2}{red!50!white}
\colorlet{color3}{green!50!black}

\begin{document}

\begin{tikzpicture}[remember picture]
\node [align=left,font=\ttfamily] at (0,0) {
    let s = &quot;toto&quot; in\\[2em]
    fprintf \tikzmarknode{fmt}{fmt} \tikzmarknode{str}{&quot;{\color{color1}\tikzmarknode{scd}{\%d}}
        {\color{color2}\tikzmarknode{scc}{\%c}}
        {\color{color3}\tikzmarknode{scs}{\%s}}&quot;}
    {\color{color1}\tikzmarknode{d}{3}}
    {\color{color2}\tikzmarknode{c}{'c'}}
    {\color{color3}\tikzmarknode{s}{s}}\\[2em]
    &gt; \\
    (* fmt &lt;- &quot;3 c toto&quot; *)
};
\draw[&lt;-, color1] (scd.north) -- ++(0,0.5) -| (d);
\draw[&lt;-, color2] (scc.south) -- ++(0,-0.3) -| (c);
\draw[&lt;-, color3] (scs.north) -- ++(0,0.4) -| (s);
\draw[decorate,decoration={brace, amplitude=5pt, raise=10pt},yshift=-2cm] (str.south east) -- (str.south west) node[midway, yshift=-13pt](a){} ;

\draw[-&gt;, white] (a.south) -- ++(0,-0.1) -| (fmt);
\end{tikzpicture}

\end{document}
</code></pre>
<p>Code LaTeX correspondant &agrave; <code>fprintf</code> avec utilisation de <code>%a</code></p>
<pre><code class="language-latex">\documentclass[tikz,border=10pt]{standalone}

\usepackage{tikz}
\usetikzlibrary{math}
\usetikzlibrary{decorations.pathreplacing,tikzmark}

\usepackage{xcolor}

\pagecolor[rgb]{0,0,0}
\color[rgb]{1,1,1}

\colorlet{color1}{blue!50!white}
\colorlet{color2}{red!50!white}
\colorlet{color3}{green!50!black}

\begin{document}

\begin{tikzpicture}[remember picture]
\node [align=left,font=\ttfamily] at (0,0) {
    let s = &quot;toto&quot; in\\[2em]
    type expr = \{i: int; j: int\}\\
    let pp\_expr fmt {i; j} = fprintf fmt &quot;&lt;\%d, \%d&gt; i j&quot; in\\[2em]
    fprintf \tikzmarknode{fmt}{std\_formatter} \tikzmarknode{str}{&quot;{\color{color1}\tikzmarknode{scd}{\%d}}
        {\color{color2}\tikzmarknode{sca}{\%a}}
        {\color{color3}\tikzmarknode{scs}{\%s}}&quot;}
    {\color{color1}\tikzmarknode{d}{3}}
    {\color{color2}\tikzmarknode{ppe}{pp\_expr}}
    {\color{color2}\tikzmarknode{e}{\{i=1; j=2\}}}
    {\color{color3}\tikzmarknode{s}{s}}\\[2em]
    &gt; &quot;3 &lt;1, 2&gt; toto&quot;
};
\draw[&lt;-, color1] (scd.north) -- ++(0,0.5) -| (d);
\draw[&lt;-, color2] (sca.south) -- ++(0,-0.3) -| (ppe);
\draw[&lt;-, color2] (sca.65) -- ++(0,0.3) -| (e);
\draw[-&gt;, color2] (fmt.north) -- ++(0,0.2) -| (sca.115);
\draw[&lt;-, color3] (scs.south) -- ++(0,-0.4) -| (s);
\draw[decorate,decoration={brace, amplitude=5pt, raise=12pt},yshift=-2cm]  (str.south east) -- (str.south west) node[midway, yshift=-13pt](a){} ;

\draw[-&gt;, white] (a.south) -- ++(0,-0.1) -| (fmt);
\end{tikzpicture}

\end{document}
</code></pre>

