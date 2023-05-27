---
title: Application
description:
url: https://misterpingouin.blogspot.com/2007/07/application.html
date: 2007-07-18T10:21:00-00:00
preview_image:
featured:
authors:
- mrpingouin
---

Je suis en conf&eacute;rence, ce qui me laisse plein de temps pour bosser pendant la plupart des expos&eacute;s... Bremen est plut&ocirc;t une jolie ville, le campus est super agr&eacute;able et il fait beau. Blogger s'est mis &agrave; me parler en Allemand. Ici j'ai vu Al. Bundy, pour ceux qui connaissent...<br/><br/>Bon sinon, un petit exemple simple m'est venu pour montrer que l'application en Caml n'est pas aussi simple qu'on le pense en pr&eacute;sence d'arguments optionels. L'&eacute;quation <code>f x y</code> = <code>(f x) y</code>, n'est pas toujours v&eacute;rifi&eacute;e. En fait, on n'a pas seulement une notion d'application mais bien une multi-application. Si je parle de &ccedil;a c'est pour mettre au clair l'origine de la multi-abstraction du langage de script de liquidsoap.<br/><br/><pre># let f ?(a=false) () = a ;;<br/>val f : ?a:bool -&gt; unit -&gt; bool = <fun><br/># f () ~a:true ;;<br/>- : bool = true<br/># (f ()) ~a:true ;;<br/>This expression is not a function, it cannot be applied<br/># f () ;;<br/>- : bool = false</fun></pre>
