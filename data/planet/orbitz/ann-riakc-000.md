---
title: '[ANN] Riakc 0.0.0'
description: Note, since writing this post, Riakc 1.0.0 has already been released
  and merged into opam.  It fixes the below issue of Links (there is a t...
url: http://functional-orbitz.blogspot.com/2013/03/ann-riakc-000.html
date: 2013-03-17T14:42:00-00:00
preview_image:
featured:
authors:
- orbitz
---

<p><i>
Note, since writing this post, Riakc 1.0.0 has already been released and merged into opam.  It fixes the below issue of Links (there is a typo in the release notes, 'not' should be 'now'.  The source code can be found <a href="https://github.com/orbitz/ocaml-riakc/tree/1.0.0">here</a>.  The 1.0.0 version number does not imply any stability or completeness of the library, just that it is not backwards compatible with 0.0.0.
</i></p>

<p>
Riakc is a Riak Protobuf client for Ocaml.  Riakc uses Jane St Core/Async for concurrency.  Riakc is in early development and so far supports a subset of the Riak API.  The supported methods are:
</p>

<p>
</p><ul>
<li>ping</li>
<li>client_id</li>
<li>server_info</li>
<li>list_buckets</li>
<li>list_keys</li>
<li>bucket_props</li>
<li>get</li>
<li>put</li>
<li>delete</li>
</ul>


<h2>A note on GET</h2>
<p>
Links are currently dropped all together in the implementation, so if you read a value with links and write it back, you will have lost them.  This will be fixed in the very near future.
</p>

<p>
As with anything, please feel free to submit issues and pull requests.
</p>

<p>
The source code can be found <a href="https://github.com/orbitz/ocaml-riakc/tree/0.0.0">here</a>.  Riakc is in opam and you can install it by doing <code>opam install riakc</code>.
</p>

<h1>Usage</h1>
<p>
There are two API modules in Riakc.  Examples of all existing API functions can be found <a href="https://github.com/orbitz/ocaml-riakc/tree/0.0.0/examples">here</a>.
</p>

<h2>Riakc.Conn</h2>
<p>
<code>Riakc.Conn</code> provides the API for performing actions on the database.  The module interface can be read <a href="https://github.com/orbitz/ocaml-riakc/blob/0.0.0/lib/riakc/conn.mli">here</a>.  
</p>

<h2>Riakc.Robj</h2>
<p>
<code>Riakc.Robj</code> provides the API for objects stored in Riak.  The module interface can be read <a href="https://github.com/orbitz/ocaml-riakc/blob/0.0.0/lib/riakc/robj.mli">here</a>.  <code>Riakc.Conn.get</code> returns a <code>Riakc.Robj.t</code> and <code>Riakc.Conn.put</code> takes one.  <code>Robj.t</code> supports representing siblings, however <code>Riakc.Conn.put</code> cannot PUT objects with siblings, this is enforced using phantom types.  A value of <code>Riakc.Robj.t</code> that might have siblings is converted to one that doesn't using <code>Riakc.Robj.set_content</code>.
</p>
