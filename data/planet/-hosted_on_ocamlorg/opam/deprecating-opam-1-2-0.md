---
title: "Deprecating opam 1.2.0"
authors: [ "Anil Madhavapeddy", "Louis Gesbert" ]
date: 2017-06-14T00:00:00-00:00
description: "Announcement of the deprecation of opam 1.2.0 in favour of 1.2.2"
source:
  name: Opam blog
  url: ""
  tag: "personnal blog"
---

Opam 1.2.0 will be actively deprecated in favour of opam 1.2.2, which now becomes
the only supported stable release.

### Why deprecate opam 1.2.0

OPAM 1.2.0 was released in October 2014, and saw rapid uptake from the
community. We did some rapid bugfixing to solve common problems, and OPAM 1.2.2
was released in April 2015. Since then, 1.2.2 has been a very solid release and
has been the stable version in use to date.

Unfortunately, part of the bugfixes in the 1.2.2 series resulted in an `opam`
file format that is not fully backwards compatible with the 1.2.0 syntax, and
the net effect is that users of 1.2.0 now see a broken package repository. Our
CI tests for new packages regularly fail on 1.2.0, even if they succeed on 1.2.2
and higher.

As we prepare the plan for [1.2.2 -> 2.0
migration](https://github.com/ocaml/opam/issues/2918), it is clear that we need
a "one-in one-out" policy on releases in order to preserve the overall health of
the package repository -- maintaining three separate releases and formats of the
repository is not practical. Therefore the 1.2.0 release needs to be actively
deprecated, and we could use some help from the community to make this happen.

### Who is still using opam 1.2.0?

I found that the Debian Jessie (stable) release includes 1.2.0, and this is
probably the last major distribution including it. The [Debian
Stretch](https://wiki.debian.org/DebianStretch) is due to become the stable
release on the 17th June 2017, and so at that point there will hopefully be no
distributions actively sending opam 1.2.0 out.

### How do we deprecate it?

The format changes, although small, would cause errors on 1.2.0 users with the
main repository. To avoid those, as was done for 1.1.0, we are going to redirect
users of 1.2.0 to a frozen mirror of the repository, making new package updates
unavailable to them.

If there are any remaining users of opam 1.2.0, particularly industrial ones, please reach
out (_e.g._ on [Github](https://github.com/ocaml/opam-repository/issues)). By
performing an active deprecation of an older release, we hope we can focus our
efforts on ensuring the opam users have a good out-of-the-box experience with
opam 1.2.2 and the forthcoming opam 2.0.

Please also see the [discussion thread](https://discuss.ocaml.org/t/rfc-deprecating-opam-1-2-0/332)
regarding the deprecation on the OCaml Discourse forums.
