---
title: OMake On Steroids (Part 3)
description:
url: http://blog.camlcity.org/blog/omake3.html
date: 2015-06-23T00:00:00-00:00
preview_image:
featured:
authors:
- camlcity
---



<div>
  <b>Faster builds with omake, part 3: Caches</b><br/>&nbsp;
</div>

<div>
  
In this (last) part of the series we have a closer look at how OMake uses
caches, and what could be improved in this field. Remember that we saw
in total double speed for large OMake projects, and that we also could
reduce the time for incremental builds. In particular for the latter, the
effect of caching is important.

<cc-field name="maintext">
<div style="float:right; width:50%; border: 1px solid black; padding: 10px; margin-left: 1em; margin-bottom: 1em; margin-top: 1em; background-color: #E0E0E0">
This text is part 3/3 of a series about the OMake improvements
sponsored by <a href="http://lexifi.com">LexiFi</a>:
<ul>
  <li>Part 1: <a href="http://blog.camlcity.org/blog/omake1.html">Overview</a>
  </li><li>Part 2: <a href="http://blog.camlcity.org/blog/omake2.html">Linux</a>
  </li><li>Part 3: Caches (this page)
</li></ul>
The original publishing is on <a href="http://blog.camlcity.org/blog">camlcity.org</a>.
</div>
<p>
Caching more is better, right? Unfortunately, this attitude of many
application programmers does not hold if you look closer at how caches
work. Basically, you trade memory for time, but there are also unwanted
effects. As we learned in the last part, bigger process images may also
cost time. What we examined there at the example of the fork() system
call is also true for any memory that is managed in a fine-grained
way. Look at the garbage collector of the OCaml runtime: If more memory
blocks are allocated, the collector also needs to cycle through more
blocks in order to mark and reclaim memory. Although the runtime includes
some clever logic to alleviate this effect (namely by allowing more waste
for bigger heaps and by adjusting the collection speed to the allocation
speed), the slowdown is still measurable.

</p><p>
Another problem for large setups is that if processes consume more
memory the caches maintained by the OS have less memory to work with.
The main competitor on the OS level is the page cache that stores
recently used file blocks. After all, memory is limited, and it is
the question for what we use it. Often enough, the caches on the OS
level are the most effective ones, and user-maintained caches need
to be justified.

</p><p>
In the case of OMake there are mainly two important caches:

</p><ul>
<li>The target cache answers the question whether a file can be built in
    a given directory. The cache covers both types of build rules: explicit
    and implicit rules. For the latter it is very important to have this
    cache because the applicable implicit rules need to be searched.
    As OMake normally uses the &quot;-modules&quot; switch of ocamldep, it has to
    find out on its own in which directory an OCaml module is built.
</li><li>The file cache answers the question whether a file is still up to date,
    or whether it needs to be rebuilt. This is based on three data blobs:
    first, the Unix.stat() properties of the file (and whether the file
    exists at all). Second, the MD5 digest of the file. Third, the digest
    of the command that created the file. If any of these blobs change
    the file is out of date. The details are somewhat complicated, though,
    in particular the computation of the digest costs some time and should
    only be done if it helps avoiding other expensive actions. Parts of the file
    cache survive OMake invocations as these are stored in the &quot;.omakedb&quot;
    file.
</li></ul>

<p>
All in all, I was looking for ways of reducing the size of the caches, and
for a cleverer organization that makes the cache operations cheaper.

</p><h2>The target cache</h2>

The target cache is used for searching the directory where a file can be
built, and also the applicable file extensions (e.g. if a file m.ml
is generated from m.mly there will be entries for both m.ml and m.mly).
As I found it, it was very simple, just a mapping

<blockquote>
filepath &#8614; buildable_flag
</blockquote>

and if a file f could potentially exist in many directories d there
was a separate entry d/f for every d. For a given OCaml module m,
there were entries for every potential suffix (i.e. for .cmi, .cmo, .cmx
etc.), and also for the casing of m (remember that a module M can be
stored in both m.ml and M.ml). In total, the cache had 2 * D * S * M
entries (when D = number of build directories and S = number of file
suffixes). It's a high number of entries.

<p>
The problem is not only the size, but also the speed: For every test
we need to walk the mapping data structure.

</p><p>
The new layout of the cache compresses the data in the following way:

</p><blockquote>
filename &#8614; (directories_buildable, directories_non_buildable)
</blockquote>

On the left side, only simple filenames without paths are used. So
we need only 1/D entries than before now. On the right side, we have
two sets: the directories where the file can be built, and the directories
where the file cannot be built (and if a directory appears in neither
set, we don't know yet). As the number of directories is very limited,
these sets can be represented as bitsets.

<p>
Note that if we were to program a lame build system, we could even
simplify this to

</p><blockquote>
filename &#8614; directory_buildable option
</blockquote>

but we want to take into account that files can potentially be built in
several directories, and that it depends on the include paths currently
in scope which directory is finally picked.

<p>
It's not only that the same information is now stored in a compressed
way. Also, the main user of the target cache picks a single file and
searches the directory where it can be built. Because the data structure
is now aligned with this style of accessing it, only one walk over the
mapping is needed per file (instead of one walk per combination of directory
and file). Inside the loop over the directories we only need to look into
the bitsets, which is very cheap.



</p><h2>The file cache</h2>

Compared to the target cache, the file cache is really complicated. For
every file we have three meta data blobs (stat, file digest, command
digest). Also, there are two versions of the cache: the persistent
version, as stored in the .omakedb file, and the live version.

<p>
Many simpler build systems (like &quot;make&quot;) only use the file stats for
deciding whether a file is out of date. This is somewhat imprecise,
in particular when the filesystem stores the timestamps of the files
with only low granularity (e.g. in units of seconds). Another problem
occurs when the timestamps are not synchronous with the system clock,
as it happens with remote filesystems.

</p><div style="float:right; width:50%; border: 1px solid black; padding: 10px; margin-left: 1em; margin-top: 1em; background-color: #E0E0E0">
There is a now a <a href="https://github.com/gerdstolpmann/omake-fork/tags">pre-release omake-0.10.0-test1</a> that can be bootstrapped! It contains all
of the described improvements, plus a number of bugfixes.
</div>

<p>
OMake is programmed so that it only uses the timestamps between
invocations. This means that if OMake is started another time, and the
timestamp of a file changed compared with the previous invocation of
OMake, it is assumed that the file has changed. OMake does not use
timestamps during its runs. Instead it relies on the file cache as the
instance that decides which files need to be created again. For doing
so, it only uses digests (i.e. a rule fires when the digests of the
input files change, or when the digest of the command changes).

</p><p>
The role of the .omakedb file is now that a subset of the file cache
is made persistent beween invocations. This file stores the timestamps
of the files and the digests. OMake simply assumes that the saved digest
is still the current one if the timestamp of the file remains the same.
Otherwise it recomputes the digest. This is the only purpose of the
timestamps. Inaccuracies do not play a big role when we can assume that
users typically do not start omake instances so quickly after each other
that clock deviations would matter.

</p><p>
The complexity of the file cache is better understood if you look at
key operations:

</p><ul>
  <li>Load the .omakedb file and interpret it in the right way
  </li><li>Decide whether the cached file digest can be trusted or not
      (and in the latter case the digest is recomputed from the existing
      file)
  </li><li>Decide whether a rule is out of date or not. This check needs
      to take the cache contents for the inputs and the outputs of
      the rule into account.
  </li><li>Sometimes, we want to avoid expensive checks, and e.g. only know
      whether a digest might be out of date from the available information
      without having to recompute the digest.
</li></ul>

<p>
After finding a couple of imprecise checks in the existing code, I
actually went through the whole Omake_cache module, and went through
all data cases. After that I'm now sure that it is perfect in the sense
that only those digests are recomputed that are really needed for
deciding whether a rule is out of date.

</p><p>
There are also some compressions:

</p><ul>
  <li>The cache no longer stores the complete Unix.stat records, but only
      the subset of the fields that are really meaningful (timestamps, inode),
      and represent these fields as a single string.
  </li><li>There is a separate data structure for the question whether a file
      exists. This is one of the cases where OS level caches already do a
      good job. Now, only for the n most recently accessed files this
      information is available (where n=100). On Linux with its fast system
      calls this cache is probably unnecessary, but on Windows I actually saw some
      speedup.
</li></ul>

<p>
All taken together, this gives another little boost. This is mostly observable
on Windows as this OS does not profit from the improvements described in the
previous article of the series.

<img src="http://blog.camlcity.org/files/img/blog/omake3_bug.gif" width="1" height="1"/>
</p></cc-field>
</div>

<div>
  
</div>

<div>
  Gerd Stolpmann works as OCaml consultant.

</div>

<div>
  
</div>


          
