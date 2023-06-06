---
title: Mini Cloud/Cluster v2.0
description: "Last year I wrote and rewrote a little command line tool for managing
  my virtualization cluster. Of course I could use OpenStack RDO but OpenStack is
  a vast box of somewhat working bits and pieces.\u2026"
url: https://rwmj.wordpress.com/2015/03/23/mini-cloudcluster-v2-0/
date: 2015-03-23T14:26:06-00:00
preview_image: https://s0.wp.com/i/blank.jpg
featured:
authors:
- rjones
---

<p><a href="https://rwmj.wordpress.com/2014/05/09/mini-cluster-mclu-command-line-tool/#content">Last year</a> I wrote and <a href="https://rwmj.wordpress.com/2014/05/12/mini-cluster-mclu-rewritten-to-use-ansible/#content">rewrote</a> a little command line tool for managing my <a href="https://rwmj.wordpress.com/2014/04/28/caseless-virtualization-cluster-part-5/#content">virtualization cluster</a>.</p>
<p>Of course I could use <a href="https://www.rdoproject.org/">OpenStack RDO</a> but OpenStack is a vast box of somewhat working bits and pieces. I think for a small cluster like mine you can get the essential functionality of OpenStack a lot more simply &mdash; in 1300 lines of code as it turns out.</p>
<p>The first thing that small cluster management software <b>doesn&rsquo;t</b> need is any permanent daemon running on the nodes. The reason is that we already have <a href="https://en.wikipedia.org/wiki/Secure_Shell">sshd</a> (for secure management access) and <a href="https://libvirt.org/remote.html">libvirtd</a> (to manage the guests) out of the box.  That&rsquo;s quite sufficient to manage all the state we care about. <a href="http://git.annexia.org/?p=mclu.git%3Ba=summary">My Mini Cloud/Cluster</a> software just goes out and queries each node for that information whenever it needs it (in parallel of course).  Nodes that are switched off are handled by ignoring them.</p>
<p>The second thing is that for a small cloud we can toss features that aren&rsquo;t needed at all: multi-user/multi-tenant, failover, VLANs, a nice GUI.</p>
<p>The <a href="http://git.annexia.org/?p=mclu.git%3Ba=summary">old mclu (Mini Cluster) v1.0</a> was written in Python and used <a href="https://rwmj.wordpress.com/2014/05/12/mini-cluster-mclu-rewritten-to-use-ansible/#content">Ansible</a> to query nodes. If you&rsquo;re not familiar with Ansible, it&rsquo;s basically parallel ssh on steroids. This was convenient to get the implementation working, but I ended up <a href="http://git.annexia.org/?p=mclu.git%3Ba=blob%3Bf=parallel.ml%3Bhb=HEAD">rewriting this essential feature of Ansible in ~ 60 lines of code</a>.</p>
<p>The huge down-side of Python is that even such a small program has loads of hidden bugs, because there&rsquo;s no safety at all. The rewrite (in OCaml) is 1,300 lines of code, so a fraction larger, but I have a far higher confidence that it is mostly bug free.</p>
<p>I also changed around the way the software works to make it more &ldquo;cloud like&rdquo; (and hence the name change from &ldquo;Mini Cluster&rdquo; to &ldquo;Mini Cloud&rdquo;). Guests are now created from templates <a href="http://libguestfs.org/virt-builder.1.html">using virt-builder</a>, and are stateless &ldquo;cattle&rdquo; (although you can mix in &ldquo;pets&rdquo; and mclu will manage those perfectly well because all it&rsquo;s doing is remote libvirt-over-ssh commands).</p>
<pre>
$ <b>mclu status</b>
ham0                     on
                           total: 8pcpus 15.2G
                            used: 8vcpus 8.0G by 2 guest(s)
                            free: 6.2G
ham1                     on
                           total: 8pcpus 15.2G
                            free: 14.2G
ham2                     on
                           total: 8pcpus 30.9G
                            free: 29.9G
ham3                     off
</pre>
<p>You can grab <a href="http://git.annexia.org/?p=mclu.git%3Ba=summary">mclu v2.0 from the git repository</a>.</p>

