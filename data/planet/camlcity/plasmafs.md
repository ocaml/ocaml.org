---
title: PlasmaFS
description:
url: http://blog.camlcity.org/blog/plasma4.html
date: 2011-10-18T00:00:00-00:00
preview_image:
featured:
authors:
- camlcity
---



<div>
  <b>A serious distributed filesystem</b><br/>&nbsp;
</div>

<div>
  
<p>
A few days ago, I
released <a href="http://plasma.camlcity.org">Plasma-0.4.1</a>.  This
article gives an overview over the filesystem subsystem of it, which
is actually the more important part. PlasmaFS differs in many points
from popular distributed filesystems like HDFS. This starts from the
beginning with the requirements analysis.

<cc-field name="maintext">
<p>
A distributed filesystem (DFS) allows it to store giant amounts of
data.  A high number of data nodes (computers with hard disks) can be
attached to a DFS cluster, and usually a second kind of node, called
name node, is used to store metadata, i.e. which files are stored and
where. The point is now that the volume of metadata can be very low
compared to the payload data (the ratios are somewhere between
1:10,000 to 1:1,000,000), so a single name node can manage a quite
large cluster. Also, the clients can contact the data nodes
directly to access payload data - the traffic is not routed via
the name node like in &quot;normal&quot; network filesystems. This allows
enormous bandwidths.

</p><p>
The motivation for developing another DFS was that existing
implementations, and especially the popular HDFS, make (in my opinion)
unfortunate compromises to gain speed:

</p><ul>
  <li>The metadata is not well protected. Although the metadata is
   saved to disk and usually also replicated to another computer, these 
   &quot;safety copies&quot; lag behind. In the case of an outage, data loss
   is common (HDFS even fails fatally when the disk fills up).
   Given the amount of data, this is not acceptable. It's like a
   local filesystem without journaling.<br/>&nbsp;
  </li><li>The name node protocol is too simplistic, and because of this,
   DFS implementations need ultra-high-speed name node implementations
   (at least several 10000 operations per second) to manage larger clusters.
   Another consequence is that only large block sizes (several megabytes)
   promise decent access speeds, because this is the only implemented
   strategy to reduce the frequency of name node operations.<br/>&nbsp;
  </li><li>Unless you can physically separate the cluster from the rest
    of the network, security is a requirement. It is difficult to provide,
    however, mainly because the data nodes are independently accessed, and you
    want to avoid that data nodes have to continuously check for
    access permissions. So the compromise is to leave this out in the
    DFS, and rely on complicated and error-prone configurations in
    network hardware (routers and gateways).
</li></ul>

<p>
I'm not saying that HDFS is a bad implementation. My point is only that
there is an alternative where safety and security are taken more
seriously, and that there are other ways to get high speed than those
that are implemented in HDFS.

</p><h2>Using SSDs for transacted metadata stores</h2>

PlasmaFS starts at a different point. It uses a data store with full
transactional support (right now this is PostgreSQL, just for
development simplicity, but other, and more light-weight systems could
also fill out this role). This includes:

<ul>
  <li>Data are made persistent in a way so that full ACID support
    is guaranteed (remember, the ACID properties are atomicity,
    consistency, isolation, and durability).
  </li><li>For keeping replicas synchronized, we demand support for
    two-phase commit, i.e. that transactions can be prepared before
    the actual commit with the guarantee that the commit is fail-safe
    after preparation. (Essentially, two-phase commit is a protocol
    between two database systems keeping them always consistent.)
</li></ul>

This is, by the way, the established prime-standard way of ensuring
data safety for databases.  It comes with its own problems, and the
most challenging is that commits are relatively slow. The reason for this
is the storage hardware - for normal hard disks the maximum frequency
of commits is a function of the rotation speed. Fortunately, there is
now an alternative: SSDs allow at present several 10000 syncs per
second, which is two orders of magnitude more than classic hard disks
provide. Good SSDs are still expensive, but luckily moderate disk
sizes are already sufficient (with only a 100G database you can
already manage a really giant filesystem).

<p>Still, writing each modification directly to the SSD limits the
speed compared to what systems like HDFS can do (because HDFS keeps
the data in RAM, and only writes now and then a copy to disk).  We need
more techniques to address the potential bottleneck name node:

</p><ul>
  <li>PlasmaFS provides a transactional view to users. This works
    very much like the transactions in SQL. The performance advantage is here that
    several write operations can be carried out with only one commit.
    PlasmaFS takes it that far that unlimited numbers of metadata
    operations can be put into a transaction, such as creating and
    deleting files, allocating blocks for the files, and retrieving
    block lists. It is possible to write terabytes of data to files with
    <i>only a single commit</i>! Applications accessing large files
    sequentially (as, e.g., in the map/reduce framework) can especially
    profit from this scheme.<br/>&nbsp;
  </li><li>PlasmaFS addresses blocks linearly: for each data node the blocks
    are identified by numbers from 0 to n-1. This is safe, because we
    manage the consistency globally (basically, there is a kind of
    join between the table managing which blocks are used or free, and
    the table managing the block lists per file, and our safety
    measures allow it to keep this join consistent). In contrast,
    other DFS use GUIDs to identify blocks. The linear scheme,
    however, allow it to transmit and store block lists in a
    compressed way (extent-based). For example, if a file uses the
    blocks 10 to 14 on a data nodes, this is stored as &quot;10-14&quot;, and not
    as &quot;10,11,12,13,14&quot;. Also, block allocations are always done
    for ranges of blocks. This greatly reduces the number
    of name node operations while only moderately increasing their
    complexity.<br/>&nbsp;
  </li><li>A version number is maintained per file that is
    increased whenever data or metadata are modified. This allows it
    to keep external caches up to date with only low overhead: A quick
    check whether the version number has changed is sufficient to
    decide whether the cache needs to be refreshed. This is reliable,
    in contrast to cache consistency schemes that base only on the
    last modification time. Currently this is used to keep the
    caches of the NFS bridge synchronized. Especially, applications accessing
    only a few files randomly profit from such caching.
</li></ul>

<p>
I consider the map/reduce part of Plasma especially as a good test
case for PlasmaFS. Of course, this map/reduce implementation is
perfectly adapted to PlasmaFS, and uses all possibilities to reduce
the frequency of name node operations. It turns out that a typical
running map/reduce task contacts the name node only every 3-4 seconds,
usually to refill a buffer that got empty, or to flush a full buffer
to disk. The point here is that a buffer can be larger than a data
block, and that only a single name node transaction is sufficient to
handle all blocks in the buffer in one go. The buffers are typically
way larger than only a single block, so this reduces the number of
name node operations quite dramatically.  (Important note: This number
(3-4) is only correct for Plasma's map/reduce implementation which
uses a modified and more complex algorithm scheme, but it is not
applicable to the scheme used by Hadoop.)

</p><h2>Speed</h2>

<p>
I have done some tests with the latest development version of
Plasma. The peak number of commits per second seems to be around 500
(here, a &quot;commit&quot; is a transaction writing data that can include
several data update operations). This test used a recently bought SSD,
and ran on a quad-core server machine. It was not evident that the SSD
was the bottleneck (one indication is that the test ran only slightly
faster when syncs were turned off), so there is probably still a lot
of room for optimization.

</p><p>
Given that a map/reduce task needs the name node only every &asymp;0.3 seconds,
this &quot;commit speed&quot; would be theoretically sufficient for around
1600 parallely running tasks. It is likely that other limits are
hit first (e.g. the switching capacity). Anyway, these are encouraging
numbers showing that this young project is not on the wrong track.

</p><p>
The above techniques are already implemented in PlasmaFS. More advanced
options that could be worth an implementation include:

</p><ul>
  <li>As we can maintain exact replicas of the primary name node (via
    two-phase commit), it becomes possible to also use the replicas
    for read accesses. For certain types of read operations this is
    non-trivial, though, because they have an effect on the block
    allocation map (essentially we would need to synchronize a certain
    buffer in both the primary and secondary servers that controls
    delayed block deallocation). nevertheless, this is certainly a viable option.
    Even writes could be handled by
    the secondary nodes, but this tends to become very complicated,
    and is probably not worth it.<br/>&nbsp;
  </li><li>An easier option to increase the capacity is to split the file
    space, so that each name node takes care of a partition only. A
    user transaction would still need a uniform view on the filesystem,
    though. If a name node receives a request for an operation it
    cannot do itself, it automatically extends the scope of the
    transaction to the name node that is responsible for the right
    partition. This scheme would also use the two-phase commit protocol
    for keeping the partitions consistent. I think this option is viable,
    but only for the price of a complex development effort.
</li></ul>

<p>
Given that these two improvements are very complicated to implement,
it is unlikely that it is done soon. There is still a lot of fruit
hanging at lower branches of the tree.


</p><h2>Delegated access control checks</h2>

<p>
Let's quickly discuss another problem, namely how to secure accesses
to data nodes. It is easy to accept that the name nodes can be secured
with classic authentication and authorization schemes in the same
style as they are used for other server software, too. For data nodes,
however, we face the problem that we need to supervise every access to a
data block individually, but want to avoid any extra overhead, especially
that each data access needs to be checked with the name node.

</p><p>
PlasmaFS uses a special cryptographic ticket system to avoid
this. Essentially, the name node creates random keys in periodical
intervals, and broadcasts these to the data nodes. These keys are
secrets shared by the name and data nodes. The accessing clients get
only HMAC-based tickets generated from the keys and from the block ID
the clients are granted access to.  These tickets can be checked by
the data nodes because these nodes know the keys. When the client
loses the right to access the blocks (i.e. when the client transaction
ends), the corresponding key is revoked.

</p><p>
With some additional tricks it can be achieved that the only
communication between the name node and the data node is a periodical
maintenance call that hands out the new keys and revokes the expired
keys. That's an acceptable overhead.


</p><h2>Other quality-assuring features</h2>

<p>
PlasmaFS implements the POSIX file semantics almost completely. This
includes the possibility of modifying data (or better, replacing
blocks by newer versions, which is not possible in other DFS
implementations), the handling of deleted files, and the exclusive
creation of new files. There are a few exceptions, though, namely
neither the link count nor the last access time of files are maintained.
Also, lockf-style locks are not yet available.

</p><p>
For supporting map/reduce and other distributed algorithm schemes,
PlasmaFS offers locality functions. In particular, one can find out
on which nodes a data block is actually stored, and one can also
wish that a new data block is stored on a certain node (if possible).

</p><p>
The PlasmaFS client protocol bases on SunRPC. This protocol has quite
good support on the system level, and it supports strong
authentication and encryption via the GSS-API extension (which is
actually used by PlasmaFS, together with the SCRAM-SHA1 mechanism). I
know that younger developers consider it as out-dated, but even the
Facebook generation must accept that it can keep up with the
requirements of today, and that it includes features that more modern
protocols do not provide (like UDP transport and GSS-API). For the
quality of the code it is important that modifying the SunRPC layer is
easy (e.g. adding or changing a new procedure), and does not imply
much coding. Because of this it could be achieved that the PlasmaFS
protocol is quite clean on the one hand, but is still adequately
expressive on the other hand to support complex transactions.

</p><p>
PlasmaFS is accessible from many environments. Applications can access
it via the mentioned SunRPC protocol (with all features), but also
via NFS, and via a command-line client. In the future, WebDAV support
will also be provided (which is an extension of HTTP, and which will
ensure easy access from many programming environments).

</p><h2>Check Plasma out</h2>

The <a href="http://plasma.camlcity.org">Plasma homepage</a> provides
a lot of documentation, and especially downloads. Also take a look at
the <a href="http://plasma.camlcity.org/plasma/perf.html">performance
page</a>, describing a few tests I recently ran.

<img src="http://blog.camlcity.org/files/img/blog/plasma4_bug.gif" width="1" height="1"/>



</cc-field>
</p>
</div>

<div>
  
</div>

<div>
  Gerd Stolpmann works as O'Caml consultant.
<a href="http://blog.camlcity.org/blog/search1.html">Currently looking for new jobs as consultant!</a>

</div>

<div>
  
</div>


          
