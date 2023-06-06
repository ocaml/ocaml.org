---
title: Irmin 0.12 with portable filesystem watching released
description:
url: https://mirage.io/blog/irmin-0.12
date: 2016-11-17T00:00:00-00:00
preview_image:
featured:
authors:
- Thomas Gazagnaire
---


        <p>Development of the <a href="https://github.com/mirage/irmin">Irmin</a> Git-like data store continues (see <a href="https://mirage.io/blog/introducing-irmin">here</a> for an introduction). We are releasing <a href="https://github.com/mirage/irmin/releases/tag/0.12.0">Irmin 0.12.0</a> which brings support for native file-system watchers to greatly improve the performance of watches on the datastore.</p>
<p>Previously, an Irmin application that wanted to use watches would setup file-system scanning/polling by doing:</p>
<pre><code class="language-ocaml">  let () = Irmin_unix.install_dir_polling_listener 1.0
</code></pre>
<p>which would scan the <code>.git/refs</code> directory every second. This worked in practice but was unpredictably latent (if unlucky you might wait for a full second for the watch callbacks to trigger), and disk/CPU intensive as we were scanning the full storage directory every second to detect file changes.  In the cases where the store had 1000s of tags, this could easily saturate the CPU. And in case you were wondering, there are increasing number of applications (such as <a href="https://github.com/docker/datakit">DataKit</a>) that do create thousands of tags regularly, and <a href="https://github.com/engil/Canopy">Canopy</a> that need low latency for interactive development.</p>
<p>In the new 0.12.0 release, you need to use:</p>
<pre><code class="language-ocaml">   let () = Irmin_unix.set_listen_dir_hook ()
</code></pre>
<p>and the Irmin storage will do &quot;the right thing&quot;. If you are on Linux, and have the <a href="https://opam.ocaml.org/packages/inotify/">inotify OPAM package</a> installed, it will use libinotify to get notified by the kernel on every change and re-scan the whole directory. On OSX, if you have the <a href="https://opam.ocaml.org/packages/osx-fsevents/">osx-fsevents OPAM package</a> installed, it will do the same thing using the OSX <a href="https://en.wikipedia.org/wiki/FSEvents">FSEvents.framework</a>. The portable compatibility layer between inotify and fsevents comes via the new <a href="https://github.com/samoht/irmin-watcher/releases/tag/0.2.0">irmin-watcher</a> package that has been released recently as well.  This may also come in useful for other tools that require portable OCaml access to filesystem hierarchies.</p>
<p>If you are using Irmin, please do let us know how you are getting on via the
<a href="https://lists.xenproject.org/cgi-bin/mailman/listinfo/mirageos-devel">mailing list</a>
and report any bugs on the <a href="https://github.com/mirage/irmin/issues">issue tracker</a>.</p>

      
