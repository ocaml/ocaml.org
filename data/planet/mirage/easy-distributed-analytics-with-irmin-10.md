---
title: Easy distributed analytics with Irmin 1.0
description:
url: https://mirage.io/blog/irmin-1.0
date: 2017-03-06T00:00:00-00:00
preview_image:
featured:
authors:
- Thomas Gazagnaire
---


        <p>I am really happy to announce the release of Irmin 1.0, which fully
supports MirageOS 3.0 and which brings a simpler and yet more
expressive API. Irmin is a library for designing Git-like distributed
databases, with built-in branching, snapshoting, reverting and
auditing capabilities. With Irmin, applications can create tailored
mergeable datastructures to scale seamlessly. Applications built on
top of Irmin include <a href="https://tezos.com/">Tezos</a>, a distributed ledger,
<a href="https://github.com/docker/datakit">Datakit</a>, a distributed and reactive key-value store, and
<a href="https://github.com/talex5/cuekeeper">cuekeeper</a>, a web-based GTD system. Read <a href="https://mirage.io/blog/introducing-irmin">&quot;Introducing
Irmin: Git-like distributed, branchable storage&quot;</a> for a
description of the concepts and high-level architecture of the system.</p>
<p>To install Irmin 1.0:</p>
<pre><code>opam install irmin
</code></pre>
<p>The running example in this post will be an imaginary model for
collecting distributed metrics (for instance to count network
packets). In this model, every node has a unique ID, and uses Irmin to
store metrics names and counters. Every node is also a distributed
collector and can sync with the metrics of other nodes at various
points in time. Users of the application can read metrics for the
network from any node. We want the metrics to be eventually
consistent.</p>
<p>This post will describe:</p>
<ul>
<li>how to define the metrics as a mergeable data-structures;
</li>
<li>how to create a new Irmin store with the metrics, the basic
operations that are available and how to define atomic operations; and
</li>
<li>how to create and merge branches.
</li>
</ul>
<h3>Mergeable Contents</h3>
<p>Irmin now exposes <code>Irmin.Type</code> to create new mergeable contents more
easily. For instance, the following type defines the property of
simple metrics, where <code>name</code> is a human-readable name and <code>gauge</code> is a
metric counting the number of occurences for some kind of event:</p>
<pre><code class="language-ocaml">type metric = {
  name : string;
  gauge: int64;
}
</code></pre>
<p>First of all, we need to reflect the structure of the type, to
automatically derive serialization (to and from JSON, binary encoding,
etc) functions:</p>
<pre><code class="language-ocaml">let metric_t =
  let open Irmin.Type in
  record &quot;metric&quot; (fun name gauge -&gt; { name; gauge })
  |+ field &quot;name&quot;  string (fun t -&gt; t.name)
  |+ field &quot;gauge&quot; int64    (fun t -&gt; t.gauge)
  |&gt; sealr
</code></pre>
<p><code>record</code> is used to describe a new (empty) record with a name and a
constructor; <code>field</code> describes record fields with a name a type and an
accessor function while <code>|+</code> is used to stack fields into the
record. Finally <code>|&gt; sealr</code> seals the record, e.g. once applied no more
fields can be added to it.</p>
<p>All of the types in Irmin have such a description, so they can be
easily and efficiently serialized (to disk and/or over the
network). For instance, to print a value of type <code>metric</code> as a JSON object,
one can do:</p>
<pre><code class="language-ocaml">let print m = Fmt.pr &quot;%a\\n%!&quot; (Irmin.Type.pp_json metric_t) m
</code></pre>
<p>Once this is defined, we now need to write the merge function. The
consistency model that we want to define is the following:</p>
<ul>
<li>
<p><code>name</code> : can change if there is no conflicts between branches.</p>
</li>
<li>
<p><code>gauge</code>: the number of events seen on a branch. Can be updated
either by incrementing the number (because events occured) or by
syncing with other nodes partial knowledge. This is very similar to
<a href="https://en.wikipedia.org/wiki/Conflict-free_replicated_data_type">conflict-free replicated datatypes</a> and related
<a href="https://en.wikipedia.org/wiki/Vector_clock">vector-clock</a> based algorithms. However, in Irmin we keep the
actual state as simple as possible: for counters, it is a single
integer -- but the user needs to provide an external 3-way merge
function to be used during merges.</p>
</li>
</ul>
<p>Similarly to the type definitions, the 3-way merge functions can
defined using &quot;merge&quot; combinators. Merge combinators for records are
not yet available (but they are planned on the roadmap), so we need to
use <code>Irmin.Merge.like</code> to map the record definition to a pair:</p>
<pre><code class="language-ocaml">let merge =
  let open Irmin.Merge in
  like metric_t (pair string counter)
    (fun x -&gt; x.name, x.gauge)
    (fun (name, gauge) -&gt; {name; gauge })
  |&gt; option
</code></pre>
<p>The final step to define a mergeable data-structure is to wrap
everything into a module satisfying the <a href="http://mirage.github.io/irmin/Irmin.Contents.S.html">Irmin.Contents.S</a>
signature:</p>
<pre><code class="language-ocaml">module Metric: Irmin.Contents.S with type t = metric = struct
  type t = metric
  let t = metric_t
  let merge = merge
  let pp = Irmin.Type.pp_json metric_t
  let of_string s =
    Irmin.Type.decode_json metric_t (Jsonm.decoder (`String s))
end
</code></pre>
<h3>Creating an Irmin Store</h3>
<p>To create a key/value store to store metrics, using the on-disk Git
format:</p>
<pre><code class="language-ocaml">module Store = Irmin_unix.Git.FS.KV(Metric)
let config = Irmin_git.config &quot;/tmp/irmin&quot;
let info fmt = Irmin_unix.info ~author:&quot;Thomas&quot; fmt
</code></pre>
<p><code>Store</code> <a href="http://mirage.github.io/irmin/Irmin.S.html">exposes</a> various functions to create and manipulate
Irmin stores. <code>config</code> is used to configure Irmin repositories based
on <code>Store</code>. In that example we decided to keep the store state in
<code>&quot;/tmp/irmin&quot;</code> (which can be inspected using the usual Git
tools). <code>info</code> is the function used to create new commit information:
<code>Irmin_unix.info</code> use the usual POSIX clock for timestamps, and can
also be tweaked to specify the author name.</p>
<p>The most common functions to create an Irmin store are
<code>Store.Repo.create</code> to create an Irmin repository and <code>Store.master</code>
to get a handler on the <code>master</code> branch in that repository. For
instance, using the OCaml toplevel:</p>
<pre><code class="language-ocaml"># open Lwt.Infix;;

# let repo = Store.Repo.v config;;
val repo : Store.Repo.t Lwt.t = &lt;abstr&gt;
# let master = repo &gt;&gt;= fun repo -&gt; Store.master repo;;
val master : Store.t Lwt.t = &lt;abstr&gt;
</code></pre>
<p><code>Store</code> also exposes the usual key/value base operations using
<a href="http://mirage.github.io/irmin/Irmin.S.html#VALfind">find</a> and
<a href="http://mirage.github.io/irmin/Irmin.S.html#VALset">set</a>. All the
operations are reflected as Git state.</p>
<pre><code class="language-ocaml">  Lwt_main.run begin
      Store.Repo.v config &gt;&gt;= Store.master &gt;&gt;= fun master -&gt;
      Store.set master
        ~info:(info &quot;Creating a new metric&quot;)
        [&quot;vm&quot;; &quot;writes&quot;] { name = &quot;write Kb/s&quot;; gauge = 0L }
      &gt;&gt;= fun () -&gt;
      Store.get master [&quot;vm&quot;; &quot;writes&quot;] &gt;|= fun m -&gt;
      assert (m.gauge = 0L);
    end
</code></pre>
<p>Note that <code>Store.set</code> is atomic: the implementation ensures that no
data is ever lost, and if someone else is writing on the same path at
the same, the operation is retried until it succeeds (see <a href="https://en.wikipedia.org/wiki/Optimistic_concurrency_control">optimistic
transaction control</a>). More complex atomic operations are also
possible: the API also exposes function to read and write subtrees
(simply called trees) instead of single values. Trees are very
efficient: they are immutable so all the reads are cached in memory
and done only when really needed; and write on disk are only done the
final transaction is commited. Trees are also stored very efficiently
in memory and on-disk as they are deduplicated. For users of previous
releases of Irmin: trees replaces the concept of views, but have a
very implementation and usage.</p>
<p>An example of a tree transaction is a custom-defined move function:</p>
<pre><code class="language-ocaml">let move t src dst =
  Store.with_tree t
    ~info:(info &quot;Moving %a to %a&quot; Store.Key.pp src Store.Key.pp dst)
    [] (fun tree -&gt;
          let tree = match tree with
            | None -&gt; Store.Tree.empty
            | Some tree -&gt; tree
          in
          Store.Tree.get_tree tree src &gt;&gt;= fun v -&gt;
          Store.Tree.remove tree src &gt;&gt;= fun _ -&gt;
          Store.Tree.add_tree tree dst v &gt;&gt;= Lwt.return_some
    )
</code></pre>
<h3>Creating and Merging Branches</h3>
<p>They are two kinds of stores in Irmin: permanent and temporary
ones. In Git-speak, these are &quot;branches&quot; and &quot;detached
heads&quot;. Permanent stores are created from branch names using
<code>Store.of_branch</code> (<code>Store.master</code> being an alias to <code>Store.of_branch Store.Branch.master</code>) while temporary stores are created from commit
using <code>Store.of_commit</code>.</p>
<p>The following example show how to clone the master branch, how to make
concurrent update to both branches, and how to merge them back.</p>
<p>First, let's define an helper function to increment the <code>/vm/writes</code>
gauge in a store <code>t</code>, using a transaction:</p>
<pre><code class="language-ocaml">let incr t =
  let path = [&quot;vm&quot;; &quot;writes&quot;] in
  Store.with_tree ~info:(info &quot;New write event&quot;) t path (fun tree -&gt;
      let tree = match tree with
        | None -&gt; Store.Tree.empty
        | Some tree -&gt; tree
      in
      (Store.Tree.find tree [] &gt;|= function
        | None   -&gt; { name = &quot;writes in kb/s&quot;; gauge = 0L }
        | Some x -&gt; { x with gauge = Int64.succ x.gauge })
      &gt;&gt;= fun m -&gt;
      Store.Tree.add tree [] m
      &gt;&gt;= Lwt.return_some
    )
</code></pre>
<p>Then, the following program create an empty gauge on <code>master</code>,
increment the metrics, then create a <code>tmp</code> branch by cloning
<code>master</code>. It then performs two increments in parallel in both
branches, and finally merge <code>tmp</code> back into <code>master</code>. The result is a
gauge which have been incremented three times in total: the &quot;counter&quot;
merge function ensures that the result counter is consistent: see
<a href="http://kcsrk.info/ocaml/irmin/crdt/2017/02/15/an-easy-interface-to-irmin-library/">KC's blog post</a> for more details about the semantic of recursive
merges.</p>
<pre><code class="language-ocaml">let () =
  Lwt_main.run begin
    Store.Repo.v config &gt;&gt;= Store.master &gt;&gt;= fun master -&gt; (* guage 0 *)
    incr master &gt;&gt;= fun () -&gt; (* gauge = 1 *)
    Store.clone ~src:master ~dst:&quot;tmp&quot; &gt;&gt;= fun tmp -&gt;
    incr master &gt;&gt;= fun () -&gt; (* gauge = 2 on master *)
    incr tmp    &gt;&gt;= fun () -&gt; (* gauge = 2 on tmp *)
    Store.merge ~info:(info &quot;Merge tmp into master&quot;) tmp ~into:master
    &gt;&gt;= function
    | Error (`Conflict e) -&gt; failwith e
    | Ok () -&gt;
      Store.get master [&quot;vm&quot;; &quot;writes&quot;] &gt;|= fun m -&gt;
      Fmt.pr &quot;Gauge is %Ld\\n%!&quot; m.gauge
  end
</code></pre>
<h3>Conclusion</h3>
<p>Irmin 1.0 is out. Defining new mergeable contents is now simpler. The
Irmin API to create stores as also been simplified, as well as
operations to read and write atomically. Finally, flexible first-class
support for immutable trees has also been added.</p>
<p>Send us feedback on the <a href="https://lists.xenproject.org/cgi-bin/mailman/listinfo/mirageos-devel">MirageOS mailing-list</a> or on the <a href="https://github.com/mirage/irmin">Irmin
issue tracker on GitHub</a>.</p>

      
