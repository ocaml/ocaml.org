---
title: Towards Minimal Disk-Usage for Tezos Bakers
description: "Over the last few months, Tarides has focused on designing,\nprototyping,
  and integrating a new feature for Tezos bakers: automatic\ncontext\u2026"
url: https://tarides.com/blog/2022-11-10-towards-minimal-disk-usage-for-tezos-bakers
date: 2022-11-10T00:00:00-00:00
preview_image: https://tarides.com/static/f40f61613e381ebad045c51adb0241ed/18869/context-pruning-minimal.jpg
featured:
---

<p>Over the last few months, Tarides has focused on designing,
prototyping, and integrating a new feature for Tezos bakers: automatic
context pruning for rolling and full nodes. This feature will allow
bakers to run Tezos with minimal disk usage while continuing to enjoy
<a href="https://tarides.com/blog/2022-04-26-lightning-fast-with-irmin-tezos-storage-is-6x-faster-with-1000-tps-surpassed">12x more responsive operations</a>. The first version has been
released with <a href="https://forum.tezosagora.org/t/octez-v15-0-has-been-released">Octez v15</a>. The complete, more optimised context pruning
feature will come with Octez v16. We encourage every Tezos baker to
upgrade and give feedback.</p>
<p><em>We have implemented context pruning for rolling and full nodes, which
requires ~35GB of disk for storing 6 cycles in the upper layer. In
Octez v15, each subsequent pruning run needs an additional 40GB, but
that space is recovered when the operation finishes. We plan to remove
that extra requirement in Octez v16.</em></p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#improve-space-usage-with-context-pruning" aria-label="improve space usage with context pruning permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Improve Space Usage with Context Pruning</h2>
<p>The <a href="https://tarides.com/feed.xml">Tezos context</a> is a versioned key/value store that associates for
each block a view of its ledger state. The versioning uses concepts
similar to Git. The current implementation is using <a href="https://tarides.com/feed.xml">irmin</a> as
backend and abstracted by the <a href="https://tarides.com/feed.xml">lib_context</a> library.</p>
<p>We have been designing, prototyping, and integrating a new structure
for Irmin storage. It is now reorganised into two
layers: one upper layer that contains the latest cycles of the
blockchain, which are still in use, and a lower layer containing
older, frozen data. A new garbage collection feature (GC) periodically
restructures the Tezos context by removing unused data in the oldest
cycles from the upper layer, where only the data still accessible from
the currently live cycles are preserved. The first version of the GC,
available in Octez-v15, is optimised for rolling and full nodes and
thus does not contain a lower layer. We plan to extend this feature in
Octez-v17 to dramatically improve the archive nodes' performance by
moving the unused data to the lower layer (more on this below).</p>
<p>Garbage collection and subsequent compression of live data improves
disk and kernel cache performance, which enhances overall node
performance. Currently, rolling nodes operators must apply a
manual cleanup process to release space on the disk by discarding
unused data. The manual cleanup is tedious and error-prone. Operators
could discard valuable data, have to stop their baker, or try to devise
semi-automatic procedures and run multiple bakers to avoid
downtime. The GC feature provides rolling nodes operators
a fully automated method to clean up the unused data and guarantees
that only the unused data is discarded, i.e., <em>all</em> currently used data
is preserved.</p>
<p>The GC operation is performed asynchronously with minimal impact on
the Tezos node. In the rolling node's case, a GC'd context uses less
disk space and has more stable performance throughout the node's run,
as the protocol operations (such as executing smart contracts or
computing baking rewards) only need data from the upper layer. As
such, the nodes that benefit from the store's layered structure don't
need to use the manual snapshot export/import&mdash;previously necessary when
the disk&rsquo;s context got too big. In the future, archive nodes&rsquo;
performance will improve because only the upper layer is needed to
validate recent blocks. <em>This means archive nodes can bake as reliably
as rolling nodes.</em></p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#tezos-storage-in-a-nutshell" aria-label="tezos storage in a nutshell permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Tezos Storage, in a Nutshell</h2>
<p>The Tezos blockchain uses <a href="https://tarides.com/feed.xml">Irmin</a> as the main storage component. Irmin
is a library to design Git-like storage systems. It has many backends,
and one of them is <a href="https://tarides.com/feed.xml"><code>irmin-pack</code></a>, which is optimised for the Tezos use
case. In the followings, we focus on the main file used to store
object data: the store <code>pack</code> file.</p>
<p><strong>Pack file:</strong> Tezos state is serialised as immutable functional objects.
These objects are marshalled in a append-only <code>pack</code> file, one after the
other. An object can contain pointers to the file's earlier (but not
later!) objects. Pointers to an earlier object are typically
represented by the offset (position) of the earlier object in the
<code>pack</code> file. The <code>pack</code> file is append-only: existing objects are
never updated.</p>
<p><span class="gatsby-resp-image-wrapper" style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; ">
      <a href="https://tarides.com/static/3f9db58c8c913ffba792f0457ff4845e/d3deb/J7N0pil.png" class="gatsby-resp-image-link" style="display: block" target="_blank" rel="noopener">
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 15.294117647058824%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAADCAYAAACTWi8uAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAXklEQVQI162KOwrAIBBEvf/x7PzBGu1jFTFxnbBCLNKkycKwb5inxhhg5s+I93al9+tE2ze0ksHcofDDcS1APyarGCOccwghzO+9nxE2xix+Yq1druzStdZIKYOIcAOJpOXUa05DkQAAAABJRU5ErkJggg=='); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/3f9db58c8c913ffba792f0457ff4845e/c5bb3/J7N0pil.png" class="gatsby-resp-image-image" alt="J7N0pil" title="J7N0pil" srcset="/static/3f9db58c8c913ffba792f0457ff4845e/04472/J7N0pil.png 170w,
/static/3f9db58c8c913ffba792f0457ff4845e/9f933/J7N0pil.png 340w,
/static/3f9db58c8c913ffba792f0457ff4845e/c5bb3/J7N0pil.png 680w,
/static/3f9db58c8c913ffba792f0457ff4845e/b12f7/J7N0pil.png 1020w,
/static/3f9db58c8c913ffba792f0457ff4845e/b5a09/J7N0pil.png 1360w,
/static/3f9db58c8c913ffba792f0457ff4845e/d3deb/J7N0pil.png 1758w" sizes="(max-width: 680px) 100vw, 680px" style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;" loading="lazy" decoding="async"/>
  </a>
    </span></p>
<blockquote>
<p>An Irmin <code>pack</code> file as a sequence of objects: | obj | obj | obj | ...</p>
</blockquote>
<p><strong>Commit objects:</strong> Some of the objects in the <code>pack</code> file are commit
objects. A commit, together with the objects reachable from that
commit, represents the state associated to a Tezos' block.  The
Tezos node only needs the last commit to process new blocks, but
bakers will need a lot more comits to compute baking rewards.
Objects not reachable from these commits can are unreachable or dead
objects.</p>
<p><span class="gatsby-resp-image-wrapper" style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; ">
      <a href="https://tarides.com/static/ecda34b084e8e0384500bf41aaf273f3/bdcd6/DQJJLll.jpg" class="gatsby-resp-image-link" style="display: block" target="_blank" rel="noopener">
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 95.29411764705883%; position: relative; bottom: 0; left: 0; background-image: url('data:image/jpeg;base64,/9j/2wBDABALDA4MChAODQ4SERATGCgaGBYWGDEjJR0oOjM9PDkzODdASFxOQERXRTc4UG1RV19iZ2hnPk1xeXBkeFxlZ2P/2wBDARESEhgVGC8aGi9jQjhCY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2P/wgARCAATABQDASIAAhEBAxEB/8QAGAABAAMBAAAAAAAAAAAAAAAAAAECAwX/xAAVAQEBAAAAAAAAAAAAAAAAAAAAAf/aAAwDAQACEAMQAAAB7qINAUFWEf/EABkQAAIDAQAAAAAAAAAAAAAAAAAQAREhQf/aAAgBAQABBQIp4QuH/8QAFBEBAAAAAAAAAAAAAAAAAAAAIP/aAAgBAwEBPwEf/8QAFBEBAAAAAAAAAAAAAAAAAAAAIP/aAAgBAgEBPwEf/8QAFBABAAAAAAAAAAAAAAAAAAAAMP/aAAgBAQAGPwIf/8QAHBAAAgICAwAAAAAAAAAAAAAAAAERMUFRECFx/9oACAEBAAE/IXZLYqHE5PDKdCpm2eP/2gAMAwEAAgADAAAAENAIPv/EABQRAQAAAAAAAAAAAAAAAAAAACD/2gAIAQMBAT8QH//EABQRAQAAAAAAAAAAAAAAAAAAACD/2gAIAQIBAT8QH//EAB4QAQACAQQDAAAAAAAAAAAAAAEAESExQXGRUWHh/9oACAEBAAE/EAIBrhmTC7YUA683N0Wvyy/sZStEPcNpbdu8QrlgZuBz3P/Z'); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/ecda34b084e8e0384500bf41aaf273f3/7bf67/DQJJLll.jpg" class="gatsby-resp-image-image" alt="DQJJLll" title="DQJJLll" srcset="/static/ecda34b084e8e0384500bf41aaf273f3/651be/DQJJLll.jpg 170w,
/static/ecda34b084e8e0384500bf41aaf273f3/d30a3/DQJJLll.jpg 340w,
/static/ecda34b084e8e0384500bf41aaf273f3/7bf67/DQJJLll.jpg 680w,
/static/ecda34b084e8e0384500bf41aaf273f3/990cb/DQJJLll.jpg 1020w,
/static/ecda34b084e8e0384500bf41aaf273f3/c44b8/DQJJLll.jpg 1360w,
/static/ecda34b084e8e0384500bf41aaf273f3/bdcd6/DQJJLll.jpg 1662w" sizes="(max-width: 680px) 100vw, 680px" style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;" loading="lazy" decoding="async"/>
  </a>
    </span></p>
<blockquote>
<p>The data-structure (mental model) representation of the <code>pack</code> file vs. its physical representation.</p>
</blockquote>
<p><strong>Archive nodes and rolling nodes:</strong> There are different types of
Tezos nodes. An archive node stores the complete blockchain
history from the genesis block. Currently, this is over <em>2 million</em>
blocks. Roughly speaking, a block corresponds to a commit. A
rolling node stores only the last <em>n</em> blocks, where <em>n</em> is chosen
to keep the total disk usage within some bound. This may be as small
as 5 (or even less) or as large as 40,000 or more. Another type of
node is the &quot;full node,&quot; which is between an archive node and a
rolling node.</p>
<p><strong>Rolling nodes, disk space usage:</strong> The purpose of the rolling node
is to keep resource usage, particularly disk space, bounded by only
storing the last blocks. However, the current implementation does
not achieve this aim. As rolling nodes execute, the <code>pack</code> file
grows larger and larger, and no old data is discarded. To get around
this problem, node operators periodically export snapshots of the
current blockchain state from the node, delete the old data,
and then import the snapshot state back.</p>
<p><strong>Problem summary:</strong> The main problem we want to avoid is Tezos users
having to periodically export and import the blockchain state to
keep the disk usage of the Tezos node bounded. Instead, we want to
perform context pruning via automatic garbage collection of unreachable
objects. Periodically, a commit should be chosen as the GC
root, and objects constructed before the commit that are not
reachable from the commit should be considered dead branches, removed from
the <code>pack</code> store, and the disk space reclaimed. The problem is that
with the current implementation of the <code>pack</code> file, which is just an
ordinary file, it is impossible to &quot;delete&quot; regions corresponding to
dead objects and reclaim the space.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#automatised-garbage-collection-solution" aria-label="automatised garbage collection solution permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Automatised Garbage Collection Solution</h2>
<p>Consider the following <code>pack</code> file, where the <code>GC-commit</code> object has
been selected as the commit root for garbage collection:</p>
<p><span class="gatsby-resp-image-wrapper" style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; ">
      <a href="https://tarides.com/static/6ec700aa3bc32bb9faa417d7c414e6e4/668c6/ySiXa1r.png" class="gatsby-resp-image-link" style="display: block" target="_blank" rel="noopener">
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 28.235294117647058%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAGCAYAAADDl76dAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAsklEQVQY05VO7QqDMBDz/R9RqP4Q+8EcfrVeq7UZV3FsCBsehDTJXWgBACkl/BrOz53ez6hHBbfSkQHYaIbvBMLQovg8+Ace2gIetkfiqtNPO/xkEIO9XxhjBC10+XkIK/Y9HYV3hs/J08WPq89pQURYlgXMJ1hbazMzpml66+7ZQSqV95xzOZtnC6MlxnFAIaWE1voL7DVNA2NMfgshoJTKKMsSVVXljDXnzG3boq5rvAChG9MYCfH87gAAAABJRU5ErkJggg=='); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/6ec700aa3bc32bb9faa417d7c414e6e4/c5bb3/ySiXa1r.png" class="gatsby-resp-image-image" alt="ySiXa1r" title="ySiXa1r" srcset="/static/6ec700aa3bc32bb9faa417d7c414e6e4/04472/ySiXa1r.png 170w,
/static/6ec700aa3bc32bb9faa417d7c414e6e4/9f933/ySiXa1r.png 340w,
/static/6ec700aa3bc32bb9faa417d7c414e6e4/c5bb3/ySiXa1r.png 680w,
/static/6ec700aa3bc32bb9faa417d7c414e6e4/b12f7/ySiXa1r.png 1020w,
/static/6ec700aa3bc32bb9faa417d7c414e6e4/b5a09/ySiXa1r.png 1360w,
/static/6ec700aa3bc32bb9faa417d7c414e6e4/668c6/ySiXa1r.png 1692w" sizes="(max-width: 680px) 100vw, 680px" style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;" loading="lazy" decoding="async"/>
  </a>
    </span></p>
<p>Objects that precede the commit root are either reachable from the
commit (by following object references from it) or not. For the
unreachable objects, we want to reclaim the disk space. For reachable
objects, we need to be able to continue to access them via their
offset in the <code>pack</code> file.</p>
<p>The straightforward solution is to implement the <code>pack</code> file using two
other data structures: the <code>suffix</code> and the <code>prefix</code>. The <code>suffix</code>
file contains the root commit object (<code>GC-commit</code>) and the live
objects represented by <em>all</em> bytes following the offset of <code>GC-commit</code>
in the <code>pack</code> file. The <code>prefix</code> file contains all the objects
reachable from the root commit, indexed by their offset. Note that the
reachable objects appear earlier in the <code>pack</code> file than the root
commit.</p>
<p><span class="gatsby-resp-image-wrapper" style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; ">
      <a href="https://tarides.com/static/5ae9c879daf866bfd4791176a2e9e4d5/09262/QVeXtOB.png" class="gatsby-resp-image-link" style="display: block" target="_blank" rel="noopener">
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 37.05882352941176%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAHCAYAAAAIy204AAAACXBIWXMAAAsTAAALEwEAmpwYAAABHklEQVQoz5WQPUvDYBSF83fFxV/h0lVQ3Is4OIiLiKAguFgppqYfUZM3bZOYNG2S1iakSd5HjKQoitILD2e4h8O5V2GDkVJWGq9iemEfkQisQjAOn0iWSyQSZZOwOtBbeWjpI720h5Z2eU77SMpqp9TG2lzrX4H63OBu1kaNHlBjlU7YZhEZFEn0veHX0N9AQlHmqJM2968amv/C40RH9QYEgQWrBCUrMoJFQJql/zas/pclnA9bNO09Tp0GZ+N9joe7XDoHnyfP4hnm1GSZvv1oVxQFeZ6vmccRbhhx49gc+Q1ORjsctrZomttcBQ1kWaL4vo/e1/E9H8/zKmzbrnBdd82Hz7IshGliDAaY3RFG1+H64ha9M8QRU4QQvAMN/hMukTamUwAAAABJRU5ErkJggg=='); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/5ae9c879daf866bfd4791176a2e9e4d5/c5bb3/QVeXtOB.png" class="gatsby-resp-image-image" alt="QVeXtOB" title="QVeXtOB" srcset="/static/5ae9c879daf866bfd4791176a2e9e4d5/04472/QVeXtOB.png 170w,
/static/5ae9c879daf866bfd4791176a2e9e4d5/9f933/QVeXtOB.png 340w,
/static/5ae9c879daf866bfd4791176a2e9e4d5/c5bb3/QVeXtOB.png 680w,
/static/5ae9c879daf866bfd4791176a2e9e4d5/b12f7/QVeXtOB.png 1020w,
/static/5ae9c879daf866bfd4791176a2e9e4d5/b5a09/QVeXtOB.png 1360w,
/static/5ae9c879daf866bfd4791176a2e9e4d5/09262/QVeXtOB.png 1896w" sizes="(max-width: 680px) 100vw, 680px" style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;" loading="lazy" decoding="async"/>
  </a>
    </span></p>
<blockquote>
<p>The layered structure of the <code>pack</code> file with <code>prefix</code>+<code>suffix</code> as the upper layer.</p>
</blockquote>
<p>Reading from the <code>pack</code> file is then simulated in an obvious way: if
the offset is for the <code>GC-commit</code>, or later, we read from the <code>suffix</code>
file, and otherwise, we lookup the offset in the <code>prefix</code> and return
the appropriate object. We only access the reachable objects in the
<code>prefix</code> via their offset.  We replace the Irmin <code>pack</code> file with
these two data structures. Every time we perform garbage collection
from a given <code>GC-commit</code>, we create the next versions of the <code>prefix</code>
and <code>suffix</code> data-structures and <em>switch</em> from the current version to the next
version by deleting the old <code>prefix</code> and <code>suffix</code> to reclaim
disk space. Creating the next versions of the <code>prefix</code> and <code>suffix</code>
data-structures is potentially expensive. Hence, we implement these steps in a
separate process, the <em>GC worker</em>, with minimal impact on the running
Tezos node.</p>
<p><strong>Caveat:</strong> Following Git, a commit will typically reference its
parent commit, which will then reference its parent, and so
on. Clearly, if we used these references to calculate object
reachability, all objects would remain reachable forever. However,
this is not what we want, so when calculating the set of reachable
objects for a given commit, we ignore the references from a commit
to its parent commit.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#the-prefix-data-structure" aria-label="the prefix data structure permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>The <code>prefix</code> Data-Structure</h2>
<p>The <code>prefix</code> is a persistent data-structure that implements a map from
the offsets in <code>pack</code> file to objects (the marshalled bytes
representing an object). In our scenario, the GC worker creates the
<code>prefix</code>, which is then read-only for the main process. Objects are
never mutated or deleted from the <code>prefix</code> file. In this setting, a
straightforward implementation of an object store suffices: we store
reachable objects in a data file and maintain a persistent <code>(int &rarr; int)</code> map from &quot;offset in the original <code>pack</code> file&quot; to &quot;offset in the
<code>prefix</code> file.&quot;</p>
<p><strong>Terminology:</strong> We introduce the term &quot;virtual offset&quot; for &quot;offset in
the original <code>pack</code> file&quot; and the term &quot;real offset&quot; for &quot;offset in
the <code>prefix</code> file.&quot; Thus, the map outlining virtual offset to real
offset is made persistent as the <code>mapping</code> file.</p>
<p><strong>Example:</strong> Consider the following, where the <code>pack</code> file contains
reachable objects <code>o1</code> .. <code>o10</code>, (with virtual offsets <em>v1 .. v10</em>, respectively):</p>
<p><span class="gatsby-resp-image-wrapper" style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; ">
      <a href="https://tarides.com/static/b1a2c914473284ac9bb2b688a1852562/cb88c/JKWA4ff.png" class="gatsby-resp-image-link" style="display: block" target="_blank" rel="noopener">
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 54.70588235294118%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAALCAYAAAB/Ca1DAAAACXBIWXMAAAsTAAALEwEAmpwYAAABe0lEQVQoz6WPf2ubUBSG/f6fY+yvpIGQNUhSzPLbqMU4Ggcz2oJzWQxVF1OTVn2Gt01ZW7rR9eW+3MO95304R+KNKstSuNLNPiPOtmwPO3Ef7m6R3gMMfoWYiYe99bHiS6I0eRvwCBJQSqrDIedq853dIRV/0v/AeKjviWBvvuLeGX8HPpnmTxiQA1FREBc5aQHe9YJV/kXwpX+BnrvSbr9nnabE2Q3X2z3ezwt+lPP7CV8Llo9rPVWe50w0DbnXQ52byMoA2Whh3dbwszlSURQc/RxShbMsI0kS1us1vu/jOA6fVZWeaXLuLjGWVyjOGXr6gVn88eXKR0gcx0RRxGq1IggCYc/zcF2XTRiSJonoz9KUMAgf85Jt2ywWCzRNo9vtMp1OMQwDXdexLAvTNGk2m8iyTL/fFx4MBkwmExRF4dPpKSeNE/RzDWf5Dal6rED1el0EZ7MZnU6H4XAoQq1Wi0ajId5VVaXdbjMajURdueqt1WpigPF4zG+ssj5O9J+i7wAAAABJRU5ErkJggg=='); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/b1a2c914473284ac9bb2b688a1852562/c5bb3/JKWA4ff.png" class="gatsby-resp-image-image" alt="JKWA4ff" title="JKWA4ff" srcset="/static/b1a2c914473284ac9bb2b688a1852562/04472/JKWA4ff.png 170w,
/static/b1a2c914473284ac9bb2b688a1852562/9f933/JKWA4ff.png 340w,
/static/b1a2c914473284ac9bb2b688a1852562/c5bb3/JKWA4ff.png 680w,
/static/b1a2c914473284ac9bb2b688a1852562/b12f7/JKWA4ff.png 1020w,
/static/b1a2c914473284ac9bb2b688a1852562/b5a09/JKWA4ff.png 1360w,
/static/b1a2c914473284ac9bb2b688a1852562/cb88c/JKWA4ff.png 2728w" sizes="(max-width: 680px) 100vw, 680px" style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;" loading="lazy" decoding="async"/>
  </a>
    </span></p>
<p>Note that the objects <code>o1</code> .. <code>o10</code> are scattered throughout the
<code>pack</code> file where they appear in ascending order (i.e., <em>v1 &lt; .. &lt;
v10</em>). The <code>prefix</code> file contains the same objects but with different
&quot;real&quot; offsets <em>r1..r10</em>, as now the objects <code>o1 .. o10</code> appear one
after the other. The <code>mapping</code> needs to contain an entry <em>(v1 &rarr; r1)</em>
for object <code>o1</code> (and similarly for the other objects) to relate the
virtual offset in the <code>pack</code> file with the real offset in the <code>prefix</code>
file.</p>
<p>To read from &quot;virtual offset <em>v3</em>&quot; (say), we use the map to retrieve
the real offset in the <code>prefix</code> file (i.e., <em>r3</em>) and then read the object
data from that position.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#asynchronous-implementation" aria-label="asynchronous implementation permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Asynchronous Implementation</h2>
<p>Tezos Context pruning is performed periodically. We want each round of
context pruning to take place asynchronously with minimal impact
on the main Tezos node. For this reason, when a commit is chosen as
the GC root, we fork a worker process to construct the next <code>prefix</code>
and <code>suffix</code> data structures. When the GC worker terminates, the <code>main</code> process
handles worker termination. It switches from the current
<code>prefix</code>+<code>suffix</code> to the next and continues operation. This
switch takes place almost instantaneously. The hard work is done in
the worker process as depicted next:</p>
<p><span class="gatsby-resp-image-wrapper" style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; ">
      <a href="https://tarides.com/static/34188b669c6289bf79a8b2582e07c9b9/e4900/lob23OH.png" class="gatsby-resp-image-link" style="display: block" target="_blank" rel="noopener">
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 106.47058823529412%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAVCAYAAABG1c6oAAAACXBIWXMAAAsTAAALEwEAmpwYAAADE0lEQVQ4y5WU+2/TZhSG/eful0lIqwZtRRsGBZSqWwaaigYFBpVWcb9VamlLb0lamjbkJpr7pY1zwU5IEyeLiZ1nsmmMQzNGX+mTE/t8j79z3uMjAHS7XXMZys7dxz0yxMbYMIvDP/Hkxx8oRvfNZ7quY48ftAT7H73bpRwJcbDtJbD0mrhnk8jya+qybAHNWOM6aBlABqjVbhPyelBkidNKaLVaVKtVPqkqtXqdjRfPqT2YxXvZgXjrDyqbq9QUhaNajY/VKh/rdQ5CQfZckyxdGmdlwsHixTFeDQ/he/oYIZ/PI8syWqfDP6pKxOshOTNN2OUk4nKSW1qg2W6jNBrU63UazSaFZIL9pw8JPppja/Yv3PfvsjnzJ1GvG6FUKqGqat+xm4pC1O9HKhboHJv1X0omEmj6lxihUChgpN1zT+t2OSoV2Zl/SS2TMm7StTt77HStIBK+N4Nn6iqBG9eRAn4TLIiiaAENFd9H2HVeYu3CKG7HCPFnj9A+v60PKIYCrI+dY9UxwsLPZ/Ddu2PGCYeHhzSbTQtYymTYvPYrwetTrFy+QGBh/kTvGepoGmI8RmrtDemdbdM0M+VcLoeiKNYmqzaxmPWir2F27YfDZs17cUI2m7WARlqarlOMx5i/fYuM7y1oWh/AaK9PmkblIMf7uzfZmbpqdkXF7zMN7AcChVCA5O+TbE+ME526Qmxullg6jSxJlMtlpA8fzL7M+nfxTIyzcfE8q+fPEn44NxhYEUW2bk4Tmr6G2zVJ+M2y2Z/q8erJSL6UTlHa85EPBVGOy9MHtNcoGovRsLlvgXq1HFBPs4aZTKYPaMQdFUSCr55Ti0fRO52BxtiHRG9omCe0Aw2pmkb471nWRodYn3BQOTz4DLBtOgG2/T5xQnPaKArJd34kMW+6/vXGb06bVCpFo9H4ssk4ZatJZMtLyza+vgdmAY0p0pOUTLDrmmTFMcrWlV/IrSyi2z69/wWm02na7bZ1o5xMsP2bk4DLyfL4CHuPH5w+ZaOOkiRhjLKyLJOMRgltrCPnsuZXcZqU/wWSoRyNG4AD7AAAAABJRU5ErkJggg=='); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/34188b669c6289bf79a8b2582e07c9b9/c5bb3/lob23OH.png" class="gatsby-resp-image-image" alt="lob23OH" title="lob23OH" srcset="/static/34188b669c6289bf79a8b2582e07c9b9/04472/lob23OH.png 170w,
/static/34188b669c6289bf79a8b2582e07c9b9/9f933/lob23OH.png 340w,
/static/34188b669c6289bf79a8b2582e07c9b9/c5bb3/lob23OH.png 680w,
/static/34188b669c6289bf79a8b2582e07c9b9/e4900/lob23OH.png 988w" sizes="(max-width: 680px) 100vw, 680px" style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;" loading="lazy" decoding="async"/>
  </a>
    </span></p>
<p><strong>Read-only Tezos nodes:</strong> In addition to the main Tezos read/write
node that accesses the <code>pack</code> store, several read-only nodes also
access the <code>pack</code> store (and other Irmin data files) in read-only
mode. These must be synchronised when the switch is made from the
current <code>prefix</code>+<code>suffix</code> to the next <code>prefix</code>+<code>suffix</code>. This
synchronisation makes use of a (new) single control file.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#further-optimisations-in-the-octez-storage-layer" aria-label="further optimisations in the octez storage layer permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Further Optimisations in the Octez Storage Layer</h2>
<p>The context pruning via automatic garbage collection performs well and
within the required constraints. However, it is possible to make
further efficiency improvements. We next describe some potential
optimisations we plan to work on over the next months.</p>
<p><strong>Resource-aware garbage collection:</strong></p>
<p>The GC worker intensively uses disk, memory, and OS resources. For
example, the disk and memory are doubled in size during the
asynchronous execution of the GC worker. We plan to improve on this by
more intelligent use of resources. For example, computing the
reachable objects during the GC involves accessing earlier objects,
using a lot of random-access reads, with unpredictable latency. A more
resource-aware usage of the file system ensures that the objects are
visited (as much as possible) in the order of increased offset on
disk. This takes advantage of the fact that sequential file access is
much quicker and predictable than accessing the file randomly. The work on
context pruning via a resource-aware garbage collection is planned to
be included in Octez v16.</p>
<p><strong>Retaining older objects for archive nodes:</strong></p>
<p>Archive nodes contain the complete blockchain history, starting from
the genesis block. This results in a huge store <code>pack</code> file, many
times larger than the kernel&rsquo;s page cache. Furthermore, live objects
are distributed throughout this huge file, which makes it difficult
for OS caching to work effectively. As a result, as the store becomes
larger, the archive node becomes slower.</p>
<p>In previous prototypes of the layered store, the design also included a
&quot;lower&quot; layer. For archive nodes, the lower layer contained all the
objects before the most recent <code>GC-commit</code>, whether they were reachable
or not. The lower layer was effectively the full segment of the
<code>pack</code> file before the GC commit root.</p>
<p>One possibility with the new layout introduced by the GC is to retain the
lower layer whilst still sticking with the <code>prefix</code> and <code>mapping</code> files
approach and preferentially reading from the <code>prefix</code> where
possible. The advantage (compared with just keeping the full <code>pack</code>
file) is that the <code>prefix</code> is a dense store of reachable objects,
improving OS disk caching and the snapshot export performance for
recent commits. In addition, the OS can preferentially cache the
<code>prefix</code>&amp;<code>mapping</code>, which enhances general archive node performance
compared with trying to cache the huge <code>pack</code> file. As baking
operations only need to access these cached objects, their performance
will be more reliable and thus will reduce endorsement misses
drastically. However, some uses of the archive node, such as
responding to RPC requests concerning arbitrary blocks, would still
access the lower layer, so they will not benefit from this
optimisation. The work on improving performance for archive nodes is
planned for Octez v17.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#conclusion" aria-label="conclusion permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Conclusion</h2>
<p>With the context pruning feature integrated, Tezos rolling and full nodes
accurately maintain all and only used storage data in a performant,
compact, and efficient manner. Bakers will benefit from these changes in
Octez v15, while the feature will be included in archive nodes in
Octez v17.</p>
