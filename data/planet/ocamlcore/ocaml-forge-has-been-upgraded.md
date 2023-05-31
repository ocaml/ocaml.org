---
title: OCaml Forge has been upgraded
description:
url: http://www.ocamlcore.com/wp/2010/12/ocaml-forge-has-been-upgraded/
date: 2010-12-29T12:02:39-00:00
preview_image:
featured:
authors:
- ocamlcore
---

<p>Since 2 weeks, I have been busy working on the <a href="http://forge.ocamlcore.org">forge</a>. I have decided that the <a href="http://fusionforge.org">FusionForge</a> migration should be done before the end of the year and this is now a reality. The OCaml Forge is now running using FusionForge, not yet stable, 5.1 branch.</p>
<p style="text-align: center;"><img src="http://www.ocamlcore.com/wp/wp-content/uploads/pow-fusionforge.png" width="166" height="37" alt=""/></p>
<p>I have changed my mind concerning the forge. Rather than sticking to Debian stable GForge packages, we will use an half customized forge.</p>
<h3>What&rsquo;s new in OCaml Forge ?</h3>
<p>The forge now officialy supports more version control systems:</p>
<ul>
<li>darcs, see the project <a href="https://forge.ocamlcore.org/scm/?group_id=54">OASIS</a></li>
<li>git, see the project <a href="https://forge.ocamlcore.org/scm/?group_id=175">Extunix</a></li>
<li>bzr, see the project <a href="https://forge.ocamlcore.org/scm/?group_id=40">Delimited Overloading</a></li>
</ul>
<p style="text-align: center;"><img src="http://www.ocamlcore.com/wp/wp-content/uploads/bzr.jpeg" width="400" height="173" alt=""/></p>
<p>You can also request to create a personal git repository for project using git.</p>
<p style="text-align: center;"><img src="http://www.ocamlcore.com/wp/wp-content/uploads/git-personal.png" width="400" height="118" alt=""/></p>
<p>It is now possible to customize your personal page and each project page. You can drag and drop boxes and even remove them.</p>
<p style="text-align: center;"><img src="http://www.ocamlcore.com/wp/wp-content/uploads/customize-link.jpeg" width="309" height="209" alt=""/></p>
<p style="text-align: center;"><img src="http://www.ocamlcore.com/wp/wp-content/uploads/customize-move.jpeg" width="309" height="148" alt=""/></p>
<p>The overall style of the forge should be better. It uses more CSS and more compatible CSS compatible HTML elements. This is something to test on the long run. We now use an unified theme for OCamlCore.org websites, contributed by Florent Monnier a long time ago <em>(</em><em>volunteers/ideas welcome to improve this visual theme)</em>.</p>
<p style="text-align: left;"><img src="http://www.ocamlcore.com/wp/wp-content/uploads/poweredby_mediawiki_88x31.png" align="right" width="88" height="31" alt=""/>It is now possible to use a wiki for your projects, you just have to activate it in the <em>Administration panel -&gt; Tools</em>. It uses MediaWiki and the role of the wiki are synchronized with the forge accounts.</p>
<p style="text-align: center;">&nbsp;</p>
<p>In order to make the forge a little more &quot;Web 2.0&quot;, I have activated the <strong>Gravatar</strong> plugin. This means that you can get a personal picture in front of your name in your projects, like in the screenshot. If you get the &quot;G&quot; picture, it means that you don&rsquo;t have an account on gravatar or that the email associated with this account is not set. The email used here is the one you define in your forge settings. Visit the <a href="http://gravatar.com/">Gravatar website</a> to create an account or update your old one. Note that this is not mandatory, you can just keep the default icon.</p>
<p style="text-align: center;"><img src="http://www.ocamlcore.com/wp/wp-content/uploads/gravatar.png" width="175" height="118" alt=""/>&nbsp;</p>
<p>FusionForge now offer an integration with Hudson. The extunix project administrator (ygrek) has helped me to see if it is working. Here is a &quot;weather report&quot; for the extunix project. You can browse the various build run on the Hudson tab. If someone want to contribute the setup of Hudson on the forge, contact me (gildor @antispam@ ocamlcore.org).</p>
<p style="text-align: center;">&nbsp;<img src="http://www.ocamlcore.com/wp/wp-content/uploads/hudson.png" width="358" height="120" alt=""/></p>
<p>FusionForge now uses tags to sort project. The former trove map is still here but tags are now the default. They are freeform, so you can just use whatever you want.</p>
<p style="text-align: center;">&nbsp;<img src="http://www.ocamlcore.com/wp/wp-content/uploads/tag.png" width="316" height="270" alt=""/></p>
<p>There was a lot of bug fixing. For example, the tracker is now really better. You can create complex searches and save them. For example, see the <a href="https://forge.ocamlcore.org/tracker/index.php?group_id=54&amp;atid=291&amp;power_query=1&amp;query_id=8&amp;run=Ex%C3%A9cuter">&quot;due in 0.2.1&quot; search</a> for OASIS bugs. You will probably find additional bugs. Don&rsquo;t hesitate to report them to the Site admin bug tracking (see below).</p>
<h3>Why use a customized version?</h3>
<p>Because it is part of the Open Source ecosystem. The OCaml Forge should help the FusionForge community. The best we can do is to try and provide back patches. This is exactly what we have done with some enhancements to the plugin scmdarcs:</p>
<ul>
<li>Multi repositories support</li>
</ul>
<p style="text-align: center;"><img src="http://www.ocamlcore.com/wp/wp-content/uploads/scmdarcs-browse.png" width="300" height="184" alt=""/></p>
<ul>
<li>Scheduling of extra repository creation</li>
</ul>
<p style="text-align: center;"><img src="http://www.ocamlcore.com/wp/wp-content/uploads/scmdarcs-create.png" width="300" height="198" alt=""/></p>
<p>The customized version will also allow us to quickly solve bugs discovered through the OCaml Forge.</p>
<p>We will try to do our best to provide back the improvements we will make on the OCaml Forge to the FusionForge community.</p>
<h3>Checklist for hosted projects</h3>
<ul>
<li>Tag your projects, for example if you are using &quot;_oasis&quot; in your project, you can tag it &quot;oasis&quot;</li>
<li>Check that everything is still accessible, the upgrade can have created broken links, report them to us</li>
<li>Check that you use the correct SCM plugin, maybe you were using SVN or CVS because you don&rsquo;t have Hg or Bzr option before, you can now switch back to display the SCM tab with a browser link in it</li>
<li>Activate the wiki if you need one</li>
</ul>
<h3>OCaml Forge in general</h3>
<p>If you want to make some advertising around for the OCamlCore.org website:</p>
<ul>
<li>Display this logo on your project page or your personal page (see <a href="http://www.ocamlcore.org/spread-the-word/">here</a> for up-to-date instructions)</li>
</ul>
<p style="text-align: center;"><img src="http://www.ocamlcore.com/wp/wp-content/uploads/logo-forge.png" width="128" height="26" alt=""/></p>
<ul>
<li>Add this text to your mail signature (see <a href="http://www.ocamlcore.org/spread-the-word/">here</a> for up-to-date instructions)</li>
</ul>
<p><code>Want to start an OCaml project: http://forge.ocamlcore.org <br/>
OCaml blogs:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; http://planet.ocamlcore.org  <br/>
</code></p>
<ul>
<li>Add your blog to the <a href="http://www.ocamlcore.org/planet/">Planet</a></li>
</ul>
<p>The OCaml Forge is now serving 190 projects for 300 users. We reach our initial goals and have enough data to show that OCaml community is working. We will continue to serve the OCaml community and to give more visibility to OCaml projects.</p>
<p>If you want to help, you can open feature request or bugs against the <a href="https://forge.ocamlchttps//forge.ocamlcore.org/tracker/?group_id=1ore.org/tracker/?group_id=1">Site Admin</a> project. This is a place where we can coordinate for site wide changes. For examples, here is a non-exhaustive list of how you can help us:</p>
<ul>
<li>Fill bugs concerning *.ocamlcore.org websites</li>
<li>Discuss how to spread the word: explain how you think we can make the OCaml community more visible</li>
<li>Start or move your project on the forge, even if you host your source code elsewhere (Github), don&rsquo;t hesitate to use the OCaml Forge as a distribution or backup website</li>
<li>Checkout the FusionForge <a href="http://git.ocamlcore.org/cgi-bin/gitweb.cgi?p=siteadmin/fusionforge.git%3Ba=summary">sources</a> of forge.ocamlcore.org and help us to maintain them</li>
</ul>
<p>Merry Christmas and Happy New Year</p>
<p>Sylvain Le Gall, on behalf of OCamlCore.org administration team</p>
<p>&nbsp;</p>

