---
title: "D\xE9tection de fonctions d\u2019identit\xE9 dans Flambda"
description: "Au cours de discussions parmi les d\xE9veloppeurs OCaml sur le type
  vide (PR#9459), certains caressaient l\u2019id\xE9e d\u2019annoter des fonctions
  avec un attribut indiquant au compilateur que la fonction devrait \xEAtre triviale,
  et toujours renvoyer une valeur strictement \xE9quivalente \xE0 son argument. Nous
  ..."
url: https://ocamlpro.com/blog/2021_07_15_fr_detection_de_fonctions_didentite_dans_flambda
date: 2021-07-15T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    Leo Boitel\n  "
source:
---

<blockquote>
<p>Au cours de discussions parmi les d&eacute;veloppeurs OCaml sur le type vide (<a href="https://github.com/ocaml/ocaml/issues/9459">PR#9459</a>), certains caressaient l&rsquo;id&eacute;e d&rsquo;annoter des fonctions avec un attribut indiquant au compilateur que la fonction devrait &ecirc;tre triviale, et toujours renvoyer une valeur strictement &eacute;quivalente &agrave; son argument.
Nous &eacute;tions curieux de voir si l&rsquo;impl&eacute;mentation d&rsquo;une telle fonctionnalit&eacute; serait possible et nous avons publi&eacute; une offre de stage pour explorer ce sujet.
L&rsquo;&eacute;quipe Compilation d&rsquo;OCamlPro a ainsi accueilli L&eacute;o Boitel durant trois mois pour se consacrer &agrave; ce sujet, avec Vincent Laviron pour encadrant. Nous sommes fiers des r&eacute;sultats auxquels L&eacute;o a abouti !</p>
<p>Voici ce que L&eacute;o en a &eacute;crit &#128578;</p>
</blockquote>
<h3>Description du probl&egrave;me</h3>
<p>Le typage fort d&rsquo;OCaml est un de ses grands avantages : il permet d&rsquo;&eacute;crire du code plus s&ucirc;r gr&acirc;ce &agrave; la capacit&eacute; d&rsquo;abstraction qu&rsquo;il offre. La plupart des erreurs de conception se traduiront directement en erreur de typage, et l&rsquo;utilisateur ne peut pas faire d&rsquo;erreur avec la manipulation de la m&eacute;moire puisqu&rsquo;elle est enti&egrave;rement g&eacute;r&eacute;e par le compilateur.</p>
<p>Cependant, ces avantages emp&ecirc;chent l&rsquo;utilisateur de faire certaines optimisations lui-m&ecirc;me, en particulier celles li&eacute;es aux repr&eacute;sentations m&eacute;moires puisqu&rsquo;il n&rsquo;y acc&egrave;de pas directement.</p>
<p>Un cas classique serait le suivant :</p>
<pre><code class="language-Ocaml">type return = Ok of int | Failure
let id = function
| Some x -&gt; Ok x
| None -&gt; Failure
</code></pre>
<p>Cette fonction est une identit&eacute;, car la repr&eacute;sentation m&eacute;moire de <code>Some x</code> et de <code>Ok x</code> est la m&ecirc;me (idem pour <code>None</code> et <code>Failure</code>). Cependant, l&rsquo;utilisateur ne le voit pas, et m&ecirc;me s&rsquo;il le voyait, il aurait besoin de cette fonction pour conserver un typage correct.</p>
<p>Un autre exemple serait le suivant:
Another good example would be this one:</p>
<pre><code class="language-Ocaml">type record = { a:int; b:int }
let id (x,y) = { a = x; b = y }
</code></pre>
<p>M&ecirc;me si ces fonctions sont des identit&eacute;s, elles ont un co&ucirc;t : en plus de nous co&ucirc;ter un appel, elles r&eacute;allouent le r&eacute;sultat au lieu de nous retourner leur argument directement. C&rsquo;est pourquoi leur d&eacute;tection permettrait des optimisations int&eacute;ressantes.</p>
<h3>Difficult&eacute;s</h3>
<p>Si on veut pouvoir d&eacute;tecter les identit&eacute;s, on se heurte rapidement au probl&egrave;me des fonctions r&eacute;cursives : comment d&eacute;finir l&rsquo;identit&eacute; pour ces derni&egrave;res ? Est-ce qu&rsquo;une fonction peut-&ecirc;tre l&rsquo;identit&eacute; si elle ne termine pas toujours, voire jamais ?</p>
<p>Une fois qu&rsquo;on a d&eacute;fini l&rsquo;identit&eacute;, le probl&egrave;me est la preuve qu&rsquo;une fonction est bien l&rsquo;identit&eacute;. En effet, on veut garantir &agrave; l&rsquo;utilisateur que cette optimisation ne changera pas le comportement observable du programme.</p>
<p>On veut aussi &eacute;viter d&rsquo;ajouter des failles de s&ucirc;ret&eacute; au typage. Par exemple, si on a une fonction de la forme suivante:</p>
<pre><code class="language-Ocaml">let rec fake_id = function
| [] -&gt; 0
| t::q -&gt; fake_id (t::q)
</code></pre>
<p>Une preuve na&iuml;ve par induction nous ferait remplacer cette fonction par l&rsquo;identit&eacute;, car <code>[]</code> et <code>0</code> ont la m&ecirc;me repr&eacute;sentation m&eacute;moire. C&rsquo;est dangereux car le r&eacute;sultat d&rsquo;une application &agrave; une liste non-vide sera une liste alors qu&rsquo;il est typ&eacute; comme un entier (voir exemples plus bas).</p>
<p>Pour r&eacute;soudre ces probl&egrave;mes, nous avons commenc&eacute; par une partie th&eacute;orique qui a occup&eacute; les trois quarts du stage, pour finir par une partie pratique d&rsquo;impl&eacute;mentation dans Flambda.</p>
<h3>R&eacute;sultats th&eacute;oriques</h3>
<p>Pour cette partie, nous avons travaill&eacute; sur des extensions de lambda-calcul, impl&eacute;ment&eacute;es en OCaml, pour pouvoir tester nos id&eacute;es au fur et &agrave; mesure dans un cadre plus simple que Flambda.</p>
<h4>Paires</h4>
<p>Nous avons commenc&eacute; par un lambda calcul auquel on ajoute seulement des paires. Pour effectuer nos preuves, on annote toutes les fonctions comme des identit&eacute;s ou non. On prouve ensuite ces annotations en &beta;-r&eacute;duisant le corps des fonctions. Apr&egrave;s chaque r&eacute;duction r&eacute;cursive, on applique une r&egrave;gle qui dit qu&rsquo;une paire compos&eacute;e des deux projections d&rsquo;une variable est &eacute;gale &agrave; la variable. On ne r&eacute;duit pas les applications, mais on les remplace par l&rsquo;argument si la fonction est annot&eacute;e comme une identit&eacute;.</p>
<p>On garde ainsi une complexit&eacute; raisonnable par rapport &agrave; une &beta;-r&eacute;duction compl&egrave;te qui serait &eacute;videmment irr&eacute;aliste pour de gros programmes.</p>
<p>On passe ensuite &agrave; l&rsquo;ordre sup&eacute;rieur en permettant des annotations de la forme <code>Annotation &rarr; Annotation</code>. Les fonctions comme <code>List.map</code> peuvent donc &ecirc;tre repr&eacute;sent&eacute;es comme <code>Id &rarr; Id</code>. Bien que cette solution ne soit pas compl&egrave;te, elle couvre la grande majorit&eacute; des cas d&rsquo;utilisation.</p>
<h4>Reconstruction de tuples</h4>
<p>On passe ensuite des paires aux tuples de taille arbitraire. Cela complexifie le probl&egrave;me : si on construit une paire &agrave; partir des projections des deux premiers champs d&rsquo;une variable, ce n&rsquo;est pas forc&eacute;ment la variable, puisqu&rsquo;elle peut avoir plus de champs.</p>
<p>On a alors deux solutions : tout d&rsquo;abord, on peut annoter les projections avec la taille du tuple pour savoir si on reconstruit la variable en entier. Par exemple, si on reconstruit une paire avec deux projections d&rsquo;un triplet, on sait qu&rsquo;on ne peut pas simplifier cette reconstruction.</p>
<p>L&rsquo;autre solution, plus ambitieuse, est d&rsquo;adopter une d&eacute;finition moins stricte de l&rsquo;&eacute;galit&eacute;, et de dire qu&rsquo;on peut remplacer, par exemple, <code>(x,y)</code> par <code>(x,y,z)</code>. En effet, si la variable a &eacute;t&eacute; typ&eacute;e comme une paire, on a la garantie qu&rsquo;on acc&eacute;dera jamais au champ <code>z</code> de toute fa&ccedil;on. Le comportement du programme sera donc le m&ecirc;me si on &eacute;tend la variable avec des champs suppl&eacute;mentaires.</p>
<p>Utiliser l&rsquo;&eacute;galit&eacute; observationnelle permet d&rsquo;&eacute;viter beaucoup d&rsquo;allocations, mais elle peut utiliser plus de m&eacute;moire dans certains cas : si le triplet cesse d&rsquo;&ecirc;tre utilis&eacute;, il ne sera pas d&eacute;sallou&eacute; par le Garbage Collector (GC), et le champ <code>z</code> restera donc en m&eacute;moire pour rien tant que <code>(x,y)</code> est utilis&eacute;.</p>
<p>Cette approche reste int&eacute;ressante, au moins si on donne la possibilit&eacute; &agrave; l&rsquo;utilisateur de l&rsquo;activer manuellement pour certains blocs.</p>
<h4>R&eacute;cursion</h4>
<p>On ajoute maintenant les d&eacute;finitions r&eacute;cursives &agrave; notre langage, par le biais d&rsquo;un op&eacute;rateur de point fixe.</p>
<p>Pour prouver qu&rsquo;une fonction r&eacute;cursive est l&rsquo;identit&eacute;, on doit proc&eacute;der par induction. La difficult&eacute; est alors de prouver que la fonction termine, pour que l&rsquo;induction soit correcte.</p>
<p>On peut distinguer trois niveaux de preuve : la premi&egrave;re option est de ne pas prouver la terminaison, et de laisser l&rsquo;utilisateur choisir les fonctions dont il est s&ucirc;r qu&rsquo;elles terminent. On suppose donc que la fonction est l&rsquo;identit&eacute;, et on simplifie son corps avec cette hypoth&egrave;se. Cette approche est suffisante pour la plupart des cas pratiques, mais son probl&egrave;me principal est qu&rsquo;elle autorise &agrave; &eacute;crire du code qui casse la s&ucirc;ret&eacute; du typage, comme discut&eacute; ci-dessus.</p>
<p>La seconde option est de faire notre hypoth&egrave;se d&rsquo;induction uniquement sur des applications de la fonction sur des &eacute;l&eacute;ments plus &ldquo;petits&rdquo; que l&rsquo;argument. Un &eacute;l&eacute;ment est d&eacute;fini comme tel s&rsquo;il est une projection de l&rsquo;argument, ou une projection d&rsquo;un &eacute;l&eacute;ment plus petit. Cela n&rsquo;est pas suffisant pour prouver que la fonction termine (par exemple si l&rsquo;argument est cyclique), mais c&rsquo;est assez pour avoir un typage s&ucirc;r. En effet, cela implique que toutes les valeurs de retour possibles de la fonction sont construites (puisqu&rsquo;elles ne peuvent provenir directement d&rsquo;un appel r&eacute;cursif), et ont donc un type d&eacute;fini. Le typage &eacute;chouerait donc si la fonction pouvait renvoyer une valeur qui n&rsquo;est pas identifiable &agrave; son argument.</p>
<p>Finalement, on peut vouloir une &eacute;quivalence observationnelle parfaite entre la fonction et l&rsquo;identit&eacute; pour la simplifier. Dans ce cas, la solution que nous proposons est de cr&eacute;er une annotation sp&eacute;ciale pour les fonctions qui sont l&rsquo;identit&eacute; quand elles sont appliqu&eacute;es &agrave; un objet non cyclique. On peut prouver qu&rsquo;elles ont cette propri&eacute;t&eacute; avec l&rsquo;induction d&eacute;crite ci-dessus. La difficult&eacute; est ensuite de faire la simplification sur les bonnes applications : si un objet est immutable, n&rsquo;est pas d&eacute;fini r&eacute;cursivement, et que tous ses sous-objets satisfont cette propri&eacute;t&eacute;, on le dit inductif et on peut simplifier les applications sur lui. On propage le statut inductif des objets lors de notre passe r&eacute;cursive d&rsquo;optimisation.</p>
<p>###Reconstruction de blocs</p>
<p>La repr&eacute;sentation des blocs dans Flambda pose des probl&egrave;mes int&eacute;ressants pour d&eacute;tecter leur &eacute;galit&eacute;, ce qui est souvent n&eacute;cessaire pour prouver une identit&eacute;. En effet, il est difficile de d&eacute;tecter la reconstruction d&rsquo;un bloc &agrave; l&rsquo;identique.</p>
<h4>Blocs dans Flambda</h4>
<h5>Variants</h5>
<p>The blocks in Flambda come from the existence of variants in OCaml: one type may have several different constructors, as we can see in</p>
<pre><code class="language-Ocaml">type choice = A of int | B of int
</code></pre>
<p>Quand OCaml est compil&eacute; vers Flambda, l&rsquo;information du constructeur utilis&eacute; par un objet est perdue, et est remplac&eacute;e par un tag. Le tag est un nombre contenu dans un ent&ecirc;te de la repr&eacute;sentation m&eacute;moire de l&rsquo;objet, et est un nombre entre <code>0</code> et <code>255</code> repr&eacute;sentant le constructeur de l&rsquo;objet. Par exemple, un objet de type choice aurait le tag <code>0</code> si c&rsquo;est un <code>A</code> et <code>1</code> si c&rsquo;est un <code>B</code>.</p>
<p>Le tag est ainsi pr&eacute;sent dans la m&eacute;moire &agrave; l&rsquo;ex&eacute;cution, ce qui permet par exemple d&rsquo;impl&eacute;menter le pattern matching de OCaml comme un switch en Flambda, qui fait de simples comparaisons sur le tag pour d&eacute;cider quelle branche prendre.</p>
<p>Ce syst&egrave;me nous complique la t&acirc;che puisque le typage de Flambda ne nous dit pas quel type de constructeur contient un variant, et emp&ecirc;che donc de d&eacute;cider facilement si deux variants sont &eacute;gaux.</p>
<h5>G&eacute;n&eacute;ralisation des tags</h5>
<p>Pour plus de complexit&eacute;, les tags sont en faits utilis&eacute;s pour tous les blocs, c&rsquo;est &agrave; dire les tuples, les modules, les fonctions (en fait presque toutes les valeurs sauf les entiers et les constructeurs constants). Quand l&rsquo;objet n&rsquo;est pas un variant, on lui donne g&eacute;n&eacute;ralement un tag 0. Ce tag n&rsquo;est donc jamais lu par la suite (puisqu&rsquo;on ne fait pas de match sur l&rsquo;objet), mais nous emp&ecirc;che de comparer simplement deux tuples, puisqu&rsquo;on verra simplement deux objets de tag inconnu en Flambda.</p>
<h5>Inlining</h5>
<p>Enfin, on optimise ce syst&egrave;me en inlinant les tuples : si on a un variant de type <code>Pair of int*int</code>, au lieu d&rsquo;&ecirc;tre repr&eacute;sent&eacute; comme le tag de Pair et une adresse m&eacute;moire pointant vers un couple (donc un tag 0 et les deux entiers), le couple est inlin&eacute; et l&rsquo;objet est de la forme <code>(tag Pair, entier, entier)</code>.</p>
<p>Cela implique que les variants sont de taille arbitraire, qui est aussi inconnue dans Flambda.</p>
<h4>Approche existante</h4>
<p>Une solution partielle au probl&egrave;me existait d&eacute;j&agrave; dans une Pull Request (PR) disponible <a href="https://github.com/ocaml/ocaml/pull/8958">ici</a>.</p>
<p>L&rsquo;approche qui y est adopt&eacute;e est naturelle : on y utilise les switchs pour gagner de l&rsquo;information sur le tag d&rsquo;un bloc, en fonction de la branche prise. La PR permet aussi de conna&icirc;tre la mutabilit&eacute; et la taille du bloc dans chaque branche, en partant de OCaml (o&ugrave; l&rsquo;information est connue puisque le constructeur est explicite dans le match), et propageant l&rsquo;information jusqu&rsquo;&agrave; Flambda.</p>
<p>Cela permet d&rsquo;enregistrer tous les blocs sur lesquels on a fait un switch dans l&rsquo;environnement, avec leur tag, taille et mutabilit&eacute;. On peut ensuite d&eacute;tecter si on reconstruit l&rsquo;un d&rsquo;entre eux avec la primitive <code>Pmakeblock</code>.</p>
<p>Cette approche est malheureusement limit&eacute;e puisqu&rsquo;ils existe de nombreux cas o&ugrave; on pourrait conna&icirc;tre le tag et la taille du bloc sans faire de switch dessus. Par exemple, on ne pourra jamais simplifier une reconstruction de tuple avec cette solution.</p>
<h4>Nouvelle approche</h4>
<p>Notre nouvelle approche commence donc par propager plus d&rsquo;information depuis OCaml. La propagation est fond&eacute;e sur deux PR qui existaient sur Flambda 2, et qui annotent dans lambda chaque projection (<code>Pfiel</code>) avec des informations d&eacute;riv&eacute;es du typage OCaml. Une ajoute la <a href="https://github.com/ocaml-flambda/ocaml/commit/fa5de9e64ff1ef04b596270a8107d1f9dac9fb2d">mutabilit&eacute; du bloc</a> et l&rsquo;autre <a href="https://github.com/ocaml-flambda/ocaml/pull/53">son tag et enfin sa taille</a>.</p>
<p>Notre premi&egrave;re contribution a &eacute;t&eacute; d&rsquo;adapter ces PRs &agrave; Flambda 1 et de les propager de lambda &agrave; Flambda correctement.</p>
<p>Nous avons ensuite les informations n&eacute;cessaires pour d&eacute;tecter les reconstructions de blocs : en plus d&rsquo;avoir une liste de blocs sur lesquels on a switch&eacute;, on cr&eacute;e une liste de blocs partiellement immutables, c&rsquo;est &agrave; dire dont on sait que certains champs sont immutables.</p>
<p>On l&rsquo;utilise ainsi :</p>
<h6>D&eacute;couverte de blocs</h6>
<p>D&egrave;s qu&rsquo;on voit une projection, on regarde si elle est faite sur un bloc immutable de taille connue. Si c&rsquo;est le cas, on ajoute le bloc correspondant aux blocs partiels. On v&eacute;rifie que l&rsquo;information qu&rsquo;on a sur le tag et la taille est compatible avec celle des projections de ce bloc vues pr&eacute;c&eacute;demment. Si on conna&icirc;t maintenant tous les champs du bloc, on l&rsquo;ajoute &agrave; notre liste de blocs connus sur lesquels on peut faire des simplifications.</p>
<p>On garde aussi les informations sur les blocs qu&rsquo;on conna&icirc;t gr&acirc;ce aux switchs.</p>
<h6>Simplification</h6>
<p>Cette partie est similaire &agrave; celle de la PR originale : quand on construit un bloc immutable, on v&eacute;rifie si on le conna&icirc;t, et le cas &eacute;ch&eacute;ant on ne le r&eacute;alloue pas.</p>
<p>Par rapport &agrave; l&rsquo;approche originale, nous avons aussi r&eacute;duit la complexit&eacute; de la PR originale (de quadratique &agrave; lin&eacute;aire), en enregistrant l&rsquo;association de chaque variable de projection &agrave; son index et bloc original. Nous avons aussi modifi&eacute; des d&eacute;tails de l&rsquo;impl&eacute;mentation originale qui auraient pu cr&eacute;er un bug lorsque associ&eacute;s &agrave; notre PR.</p>
<h4>Exemple</h4>
<p>Consid&eacute;rons cette fonction:</p>
<pre><code class="language-Ocaml">type typ1 = A of int | B of int * int
type typ2 = C of int | D of {x:int; y:int}
let id = function
  | A n -&gt; C n
  | B (x,y) -&gt; D {x; y}
</code></pre>
<p>Le compilateur actuel produirait le Flambda suivant:</p>
<pre><code>End of middle end:
let_symbol
  (camlTest__id_21
    (Set_of_closures (
      (set_of_closures id=Test.8
        (id/5 = fun param/7 -&gt;
          (switch*(0,2) param/7
           case tag 0:
            (let
              (Pmakeblock_arg/11 (field 0&lt;{../../test.ml:4,4-7}&gt; param/7)
               Pmakeblock/12
                 (makeblock 0 (int)&lt;{../../test.ml:4,11-14}&gt;
                   Pmakeblock_arg/11))
              Pmakeblock/12)
           case tag 1:
            (let
              (Pmakeblock_arg/15 (field 1&lt;{../../test.ml:5,4-11}&gt; param/7)
               Pmakeblock_arg/16 (field 0&lt;{../../test.ml:5,4-11}&gt; param/7)
               Pmakeblock/17
                 (makeblock 1 (int,int)&lt;{../../test.ml:5,17-23}&gt;
                   Pmakeblock_arg/16 Pmakeblock_arg/15))
              Pmakeblock/17)))
         free_vars={ } specialised_args={}) direct_call_surrogates={ }
        set_of_closures_origin=Test.1])))
  (camlTest__id_5_closure (Project_closure (camlTest__id_21, id/5)))
  (camlTest (Block (tag 0,  camlTest__id_5_closure)))
End camlTest
</code></pre>
<p>Notre am&eacute;lioration permet de d&eacute;tecter que cette fonction reconstruit des blocs similaires et donc la simplifie:</p>
<pre><code>End of middle end:
let_symbol
  (camlTest__id_21
    (Set_of_closures (
      (set_of_closures id=Test.7
        (id/5 = fun param/7 -&gt;
          (switch*(0,2) param/7
           case tag 0 (1): param/7
           case tag 1 (2): param/7))
         free_vars={ } specialised_args={}) direct_call_surrogates={ }
        set_of_closures_origin=Test.1])))
  (camlTest__id_5_closure (Project_closure (camlTest__id_21, id/5)))
  (camlTest (Block (tag 0,  camlTest__id_5_closure)))
End camlTest
</code></pre>
<h4>Pistes d&rsquo;am&eacute;lioration</h4>
<h5>Rel&acirc;chement de l&rsquo;&eacute;galit&eacute;</h5>
<p>On peut utiliser l&rsquo;&eacute;galit&eacute; observationnelle &eacute;tudi&eacute;e dans la partie th&eacute;orique pour l&rsquo;&eacute;galit&eacute; de blocs, afin d&rsquo;&eacute;viter plus d&rsquo;allocations. L&rsquo;impl&eacute;mentation est simple :</p>
<p>Quand on cr&eacute;e un bloc, pour voir si il est allou&eacute;, l&rsquo;approche normale est de regarder si chacun de ses champs est une projection connue d&rsquo;un autre bloc, a le m&ecirc;me index et si les deux blocs sont de m&ecirc;me taille. On peut simplement supprimer la derni&egrave;re v&eacute;rification.</p>
<p>L&rsquo;impl&eacute;mentation a &eacute;t&eacute; un peu plus difficile que pr&eacute;vu &agrave; cause de d&eacute;tails pratiques. Tout d&rsquo;abord, on veut appliquer cette optimisation uniquement sur certains blocs annot&eacute;s par l&rsquo;utilisateur. Il faut donc propager l&rsquo;annotation jusqu&rsquo;&agrave; Flambda.</p>
<p>De plus, si on se contente d&rsquo;impl&eacute;menter l&rsquo;optimisation, beaucoup de cas seront ignor&eacute;s car les variables inutilis&eacute;es sont simplifi&eacute;es avant notre passe. Par exemple, prenons une fonction de la forme suivante :</p>
<pre><code class="language-Ocaml">let loose_id (a,b,c) = (a,b)
</code></pre>
<p>La variable <code>c</code> sera simplifi&eacute;e avant d&rsquo;atteindre Flambda, et on ne pourra donc plus prouver que <code>(a,b,c)</code> est immutable car son troisi&egrave;me champ pourrait ne pas l&rsquo;&ecirc;tre. Ce probl&egrave;me est en passe d&rsquo;&ecirc;tre r&eacute;solu sur Flambda 2 gr&acirc;ce &agrave; une PR qui propage l&rsquo;information de mutabilit&eacute; pour tous les blocs, mais nous n&rsquo;avons pas eu le temps n&eacute;cessaire pour l&rsquo;adapter &agrave; Flambda 1.</p>
<h3>D&eacute;tection d&rsquo;identit&eacute;s r&eacute;cursives</h3>
<p>Maintenant que nous pouvons d&eacute;tecter les reconstructions de blocs, reste &agrave; r&eacute;soudre le probl&egrave;me des fonctions r&eacute;cursives.</p>
<h4>Approche sans garanties</h4>
<p>Nous avons commenc&eacute; par impl&eacute;menter une approche qui ne comporte pas de preuve de terminaison. L&rsquo;id&eacute;e est de rajouter la preuve ensuite, ou d&rsquo;autoriser les fonctions qui ne terminent pas toujours &agrave; &ecirc;tre simplifi&eacute;es &agrave; condition qu&rsquo;elles soient correctes au niveau du typage (voir section 7 dans la partie th&eacute;orique).</p>
<p>Ici, on fait confiance &agrave; l&rsquo;utilisateur pour v&eacute;rifier ces propri&eacute;t&eacute;s manuellement.</p>
<p>Nous avons donc modifi&eacute; la simplification de fonction : quand on simplifie une fonction &agrave; un seul argument, on commence par supposer que cette fonction est l&rsquo;identit&eacute; avant de simplifier son corps. On v&eacute;rifie ensuite si le r&eacute;sultat est &eacute;quivalent &agrave; une identit&eacute; en le parcourant r&eacute;cursivement, pour couvrir le plus de cas possible (par exemple les branchements conditionnels). Si c&rsquo;est le cas, la fonction est remplac&eacute;e par l&rsquo;identit&eacute; ; sinon, on revient &agrave; une simplification classique, sans hypoth&egrave;se d&rsquo;induction.</p>
<h4>Propagation de constantes</h4>
<p>Nous avons ensuite am&eacute;lior&eacute; notre fonction qui d&eacute;termine si le corps d&rsquo;une fonction est une identit&eacute; ou non, pour g&eacute;rer les constantes. Il propage les informations d&rsquo;&eacute;galit&eacute; qu&rsquo;on gagne sur l&rsquo;argument lors des branchements conditionnels.</p>
<p>Ainsi, si on a une fonction de la forme</p>
<pre><code class="language-Ocaml">type truc = A | B | C
let id = function
  | A -&gt; A
  | B -&gt; B
  | C -&gt; C
</code></pre>
<p>ou m&ecirc;me</p>
<pre><code class="language-Ocaml">let id x = if x=0 then 0 else x
</code></pre>
<p>on d&eacute;tectera bien que c&rsquo;est l&rsquo;identit&eacute;.</p>
<h4>Exemples</h4>
<h5>Fonctions r&eacute;cursives</h5>
<p>Nous pouvons maintenant d&eacute;tecter les identit&eacute;s r&eacute;cursives :</p>
<pre><code class="language-Ocaml">let rec listid = function
  | t::q -&gt; t::(listid q)
  | [] -&gt; []
</code></pre>
<p>compilait avant ainsi:</p>
<pre><code>End of middle end:
let_rec_symbol
  (camlTest__listid_5_closure
    (Project_closure (camlTest__set_of_closures_20, listid/5)))
  (camlTest__set_of_closures_20
    (Set_of_closures (
      (set_of_closures id=Test.11
        (listid/5 = fun param/7 -&gt;
          (if param/7 then begin
            (let
              (apply_arg/13 (field 1&lt;{../../test.ml:9,4-8}&gt; param/7)
               apply_funct/14 camlTest__listid_5_closure
               Pmakeblock_arg/15
                 *(apply*&amp;#091;listid/5]&lt;{../../test.ml:9,15-25}&gt; apply_funct/14
                    apply_arg/13)
               Pmakeblock_arg/16 (field 0&lt;{../../test.ml:9,4-8}&gt; param/7)
               Pmakeblock/17
                 (makeblock 0&lt;{../../test.ml:9,12-25}&gt; Pmakeblock_arg/16
                   Pmakeblock_arg/15))
              Pmakeblock/17)
            end else begin
            (let (const_ptr_zero/27 Const(0a)) const_ptr_zero/27) end))
         free_vars={ } specialised_args={}) direct_call_surrogates={ }
        set_of_closures_origin=Test.1])))
let_symbol (camlTest (Block (tag 0,  camlTest__listid_5_closure)))
End camlTest
</code></pre>
<p>On d&eacute;tecte maintenant que c&rsquo;est l&rsquo;identit&eacute; :</p>
<pre><code>End of middle end:
let_symbol
  (camlTest__set_of_closures_20
    (Set_of_closures (
      (set_of_closures id=Test.13 (listid/5 = fun param/7 -&gt; param/7)
        free_vars={ } specialised_args={}) direct_call_surrogates={ }
        set_of_closures_origin=Test.1])))
  (camlTest__listid_5_closure
    (Project_closure (camlTest__set_of_closures_20, listid/5)))
  (camlTest (Block (tag 0,  camlTest__listid_5_closure)))
End camlTest
</code></pre>
<h5>Exemple non s&ucirc;r</h5>
<p>En revanche, on peut profiter de l&rsquo;absence de garanties pour contourner le typage, et acc&eacute;der &agrave; une adresse m&eacute;moire comme &agrave; un entier :</p>
<pre><code class="language-Ocaml">type bugg = A of int*int | B of int
let rec bug = function
  | A (a,b) -&gt; (a,b)
  | B x -&gt; bug (B x)
  
let (a,b) = (bug (B 42))
let _ = print_int b
</code></pre>
<p>Cette fonction va &ecirc;tre simplifi&eacute;e vers l&rsquo;identit&eacute; alors que le type <code>bugg</code> n&rsquo;est pas compatible avec le type tuple ; quand on essaie de projeter sur le second champ du variant <code>b</code>, on acc&egrave;de &agrave; une partie de la m&eacute;moire ind&eacute;finie :</p>
<pre><code>$ ./unsafe.out
47423997875612
</code></pre>
<h4>Pistes d&rsquo;am&eacute;liorations &ndash; court terme</h4>
<h5>Annotation des fonctions</h5>
<p>Une am&eacute;lioration simple en th&eacute;orie, serait de laisser le choix &agrave; l&rsquo;utilisateur des fonctions sur lesquelles il veut appliquer ces optimisations qui ne sont pas toujours correctes. Nous n&rsquo;avons pas eu le temps de faire le travail de propagation de l&rsquo;information jusqu&rsquo;&agrave; Flambda, mais il ne devrait pas y avoir de difficult&eacute;s d&rsquo;impl&eacute;mentation.</p>
<h5>Ordre sur les arguments</h5>
<p>Pour avoir une optimisation plus s&ucirc;re, on voudrait pouvoir utiliser l&rsquo;id&eacute;e d&eacute;velopp&eacute;e dans la partie th&eacute;orique, qui rend l&rsquo;optimisation correcte sur les objets non cycliques, et surtout qui nous redonne les garanties du typage pour &eacute;viter le probl&egrave;me vu dans l&rsquo;exemple ci-dessus.</p>
<p>Afin d&rsquo;avoir cette garantie, on veut changer la passe de simplification pour que son environnement contienne une option de couple fonction &ndash; argument. Quand cette option existe, le couple indique que nous sommes dans le corps d&rsquo;une fonction, en train de la simplifier, et donc que les applications de la fonction sur des &eacute;l&eacute;ments plus petits que l&rsquo;argument peuvent &ecirc;tre simplifi&eacute;s en une identit&eacute;. Bien s&ucirc;r, on devrait aussi modifier la passe pour se rappeler des &eacute;l&eacute;ments qui ne sont pas plus petits que l&rsquo;argument.</p>
<h4>Pistes d&rsquo;am&eacute;liorations &ndash; long terme</h4>
<h5>Exclusion des objets cycliques</h5>
<p>Comme d&eacute;crit dans la partie th&eacute;orique, on pourrait d&eacute;duire r&eacute;cursivement quels objets sont cycliques et tenter de les exclure de notre optimisation. Le probl&egrave;me est alors qu&rsquo;au lieu de remplacer les fonctions par l&rsquo;identit&eacute;, on doit avoir une annotation sp&eacute;ciale qui repr&eacute;sente <code>IdRec</code>.</p>
<p>Cela devient bien plus complexe &agrave; impl&eacute;menter quand on compile entre plusieurs fichiers, puisqu&rsquo;on doit alors avoir cette information dans l&rsquo;interface des fichiers d&eacute;j&agrave; compil&eacute;s pour pouvoir faire l&rsquo;optimisation quand c&rsquo;est n&eacute;cessaire.</p>
<p>Une piste serait d&rsquo;utiliser les fichiers .cmx pour enregistrer cette information quand on compile un fichier, mais ce genre d&rsquo;impl&eacute;mentation &eacute;tait trop longue pour &ecirc;tre r&eacute;alis&eacute;e pendant le stage. De plus, il n&rsquo;est m&ecirc;me pas &eacute;vident qu&rsquo;elle soit un bon choix pratique : elle complexifierait beaucoup l&rsquo;optimisation pour un avantage faible par rapport &agrave; une version correcte sur les objets non cycliques et activ&eacute;e par une annotation de l&rsquo;utilisateur.</p>

