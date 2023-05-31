---
title: After NoSQL there will be NoServer
description:
url: http://blog.camlcity.org/blog/plasma5.html
date: 2011-11-04T00:00:00-00:00
preview_image:
featured:
authors:
- camlcity
---



<div>
  <b>An experiment, and a vision</b><br/>&nbsp;
</div>

<div>
  
<p>
The recent success of NoSQL technologies has not only to do with the
fact that it is taken advantage of distribution and replication, but
even more with the &quot;middleware effect&quot; that these features became
relatively easy to use.  Now it is no longer required to be an expert
for these cluster techniques in order to profit from them. Let's think
a bit ahead: how could a platform look like that makes distributed
programming even easier, and that integrates several styles of storing
data and managing computations?

<cc-field name="maintext">
<p>
The starting point for this exploration is a recent experience I made
with my own attempt in the NoSQL arena,
the <a href="http://plasma.camlcity.org">Plasma project</a>. Two weeks
ago, it was &quot;only&quot; a distributed, replicating, and failure-resiliant
filesystem PlasmaFS, with its own map/reduce implementation on top of
it. Then I had an idea: is it possible to develop a key/value database
on top of this filesystem? Which features, and relative
advantages/disadvantages would it have? In other words, I was
examining whether the existing platform makes it simpler to develop
a database with a reasonable feature set.

</p><p>
When we talk about clusters, I have especially Internet applications
in mind that are bombarded by the users with requests, but that have
also to do a lot of background processing.


</p><h2>The key/value database needed less than 2000 lines of code</h2>

<p>
Now, PlasmaFS is not following the simple pattern of HDFS, but bases
on a transactional core, and it even allows the users to manage the
transactions. For example, it is possible to rename a bunch of files
atomically by just wrapping the rename operations into a single
transaction.  The transactional support goes even further: When
reading from a file one can activate a special snapshot mode, which
just means that the reader's view of the file is isolated from any
writes happening at the same time.

</p><p>
These are clearly advanced features, and the question was whether they
helped for writing a key/value database library. And yes, it was
extremely helpful - in less than 2000 lines of code this library
provides data distribution and replication, a high degree of data
safety, almost unlimited scalabilitiy for database reads, and
reasonable performance for writes. Of course, most of these features
are just &quot;inherited&quot; from PlasmaFS, and the library just had to
implement the file format (i.e. a B tree,
see <a href="http://projects.camlcity.org/projects/dl/plasma-0.5/doc/html/Plasmakv_intro.html">
this page for details</a>). This is not cheating, but exactly the
point: the platform makes it easy to provide features that would
otherwise be extremely complicated to provide.

</p><h2>NoServer</h2>

<p>
This key/value database is just a library, and one can use it only
on machines where PlasmaFS is deployed. Of course it is possible to
access the same database file from several machines - PlasmaFS handles
all the networking involved with it. The point is that during the
implementation of the library this never had to be taken into account.
There is no networking code in this library, and this is why it is
the first example of the new NoServer paradigm - not only server.

</p><p>
The genuine advantage of this paradigm is that it enables developers
to write code they never would be able to create without the help of
the platform. This is a bit comparable to the current situation for
SQL databases: Everybody can store data in them, even over the
network, without needing to have any clue how this works in detail.
In the NoServer paradigm, we just go one step further, because the
provided services by the platform are a lot more low-level, and the
developer has a lot more freedom. Instead with a query language
the shared resources are accessed with normal file operations,
extended by transactional directives. The hope is that this makes
a lot of server programming superflous, especially the difficult
parts of it (e.g. what to do when a machine crashes).

</p><p>
A simple key/value database is obviously not difficult to create with
these programming means. The interesting question is what else can be
done with it in a cluster environment. Obviously, having a common
filesystem on all machines of the cluster makes a lot of file copying
superflous that a normal cluster would do with rsync and/or
ssh. PlasmaFS can even be directly mounted (although the transactional
features are unavailable then), so even applications can access
PlasmaFS files that have not specially been ported to it.  An example
would be a read-only Lucene search index residing in PlasmaFS.
Replacing the index by an updated one would be done by simply moving
the new index into the right directory, and signalling Lucene that it
has to re-open the index.

</p><p>
So far Plasma is implemented, and works well (I just released the
release 0.5, which is now beta quality). The vision goes of course
beyond that.

</p><h2>What the platform also needs</h2>

<p>
There are a number of further datastructures that can obviously be
well represented in files, such as hashtables or queues. Let's explore
the latter a bit more in detail: How would a queue manager look like?
There are a few data representation options. For example, every queue
element could be a file in a directory, or a container format is
established where the elements can be appended to. PlasmsFS also
allows it to cut arbitrary holes into files, so it is even possible to
physically remove elements from the beginning of the queue file by
just removing the data blocks storing the elements from the file.  As
we don't want to run the queue manager as server, but just as library
inside any program accessing the queue, the question is how event
notifications are handled (which would be obvious in server context).
Usually, one has to notify some followup processor when new elements
have been added to the queue. Plasma currently does not include a
method for doing this, so the platform needs to be extended by a
notification framework (which should not be too difficult).

</p><p>
An important question is also how programs are activated running on
different nodes. In my vision there would be a central task execution
manager. Of course, this manager is normal client/server middleware.
Again, the point here is that the application developer needs no 
special skills for triggering remote activation, he just uses
libraries. I've no absolutely clear picture of this part yet, but
it seems to be necessary to have the option of invoking programs
in the inetd style as well as directly as if started via ssh.
Also, a central directory would be maintained that includes
important data such as which program can be run on which node.

</p><h2>We won't live totally without servers, only with fewer ones</h2>

<p>
My vision does not include that servers are completely banned. We will
still need them for special features or data access patterns, and of
course for interaction with other systems.  For example, PlasmaFS is
bad at coordinating concurrent write accesses to the same file. Also,
PlasmaFS employs a central namenode with a limited capacity only. So,
if you are doing OLTP processing, a normal SQL database will still do
better. If you need extraordinary write performance, but can pay the
price of weakened consistency guarantees, a system like Cassandra will
work better.

</p><p>
Nevertheless, there is the big field of &quot;average deployments&quot; where
the number of nodes is not too big and the performance requirements
are not too special, but the ACID guarantees PlasmaFS gives are
essential. For this field, the NoServer paradigm could be the ideal
choice to reduce the development overhead dramatically.

</p><h2>Check Plasma out</h2>

The <a href="http://plasma.camlcity.org">Plasma homepage</a> provides
a lot of documentation, and especially downloads. Also take a look at
the <a href="http://plasma.camlcity.org/plasma/perf.html">performance
page</a>, describing a few tests I recently ran.

<img src="http://blog.camlcity.org/files/img/blog/plasma5_bug.gif" width="1" height="1"/>



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


          
