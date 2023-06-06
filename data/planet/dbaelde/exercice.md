---
title: Exercice
description:
url: https://misterpingouin.blogspot.com/2008/10/exercice.html
date: 2008-10-13T13:15:00-00:00
preview_image:
featured:
authors:
- mrpingouin
---

Il me reste treize jours pour finir de r&eacute;diger ma th&egrave;se. Pendant ce temps l&agrave;, pour que je ne sois pas le seul &agrave; bosser, voici un petit exercice de prog qui m'est pass&eacute; par la t&ecirc;te. On peut repr&eacute;senter du texte par le type <code>string</code> en Caml. On veut ensuite repr&eacute;senter du texte annot&eacute;, quand les annotations forment un arbre: soit deux annotations sont disjointes, soit l'une est incluse dans l'autre. Pensez par exemple &agrave; la grammaire au coll&egrave;ge, &quot;sujet&quot; , &quot;verbe&quot;, &quot;compl&eacute;ment&quot; sont regroup&eacute;s pour former une &quot;phrase&quot;:<br/><br/><div class="code">type annot =<br/>  (* Par exemple.. *)<br/>  | Sujet | Verbe | Compl&eacute;ment | Phrase<br/>type t =<br/>  | Text of string<br/>  | Annot of string * t<br/>  | Concat of t list<br/></div><br/>Il est ais&eacute; de travailler avec ce type. Et il repr&eacute;sente exactement ce qu'on veut, il y a bijection. Maintenant, je veux une solution aussi satisfaisante quand les annotations ne forment plus un arbre mais peuvent se recouvrir partiellement. Pensez par exemple &agrave; du HTML mal form&eacute;: <code>&lt;red&gt;b&lt;b&gt;a&lt;/red&gt;b&lt;/b&gt;i</code>. Sauf que moi j'ai une utilisation moins crade en t&ecirc;te, mais c'est une autre histoire. Vos id&eacute;es sont bienvenues, sinon je posterai peut &ecirc;tre une solution plus tard...
