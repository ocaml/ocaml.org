---
title: Distros and Test Suites.
description:
url: http://www.mega-nerd.com/erikd/Blog/CodeHacking/libsndfile/distros_and_test_suites.html
date: 2010-10-03T11:58:00-00:00
preview_image:
featured:
authors:
- mega-nerd
---



<p>
libsndfile is cross platform and is expected to run on 32 and 64 bit CPUs on
any system that is reasonably POSIX compliant (ie even Windows).
It also has a lot of low level code that does things like endian swapping and
bit shifting etc.
Although I compile and test the code on all the systems I have access to, I
don't have access to everything.
That's why libsndfile has a test suite.
</p>

<p>
The libsndfile test suite is as comprehensive as I can make it.
Its taken a lot or work, over man years to get to where it is, but has saved me
many times that amount of work tracking obscure bugs.
</p>

<p>
The test suite is important.
That's why I suggest that anyone building libsndfile from source should run the
test suite before using the library.
This is especially true for people packaging libsndfile for distributions.
That's why is so disappointing to see something like this
	<a href="https://bugs.gentoo.org/335728">
	Gentoo bug</a>.
</p>

<p>
Gentoo managed to mess up their build meta-data resulting in a libsndfile binary
that was horribly broken on 32 bit systems.
It was broken in such a way that just about every single test in the libsndfile
test suite would have failed.
Unfortunately, since Gentoo didn't run the test suite they distributed their
broken build meta-data to users.
And the users started emailing me with weird bug reports.
</p>

<p>
Fortunately, other distributions like Debian get it right.
Debian even keeps
	<a href="https://buildd.debian.org/">
	build logs</a>
for all releases of all packages on all architectures and makes them available
on the web.
For instance, the build log for libsndfile version 1.0.21-3 on the MIPS can be
	<a href="https://buildd.debian.org/fetch.cgi?&amp;pkg=libsndfile&amp;ver=1.0.21-3&amp;arch=mips&amp;stamp=1280847502&amp;file=log">
	found here</a>.
</p>

<p>
If anyone is using a distro which does not routinely run the test suite when
building packages which supply a test suite, I recommend that they switch to
a distro that does.
</p>



