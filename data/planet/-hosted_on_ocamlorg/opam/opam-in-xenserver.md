---
title: "Why we use OPAM for XenServer development"
authors: [ "Dave Scott" ]
date: 2015-02-18T00:00:00-00:00
description: "How and why OPAM is used at Xen."
source:
  name: Opam blog
  url: ""
  tag: "personnal blog"
---

*This is a guest post from an OPAM user about how they use it.  If you would like to post
 about your own use, [please let us know](https://github.com/ocaml/platform-blog/issues).*

[XenServer](https://web.archive.org/web/20150617021106/http://xenserver.org/) uses the
[Xen project's](http://www.xenproject.org/)
"[Xapi toolstack](http://www.xenproject.org/developers/teams/xapi.html)":
a suite of tools written mostly in OCaml which

- manages clusters of Xen hosts with shared storage and networking
- allows running VMs to be migrated between hosts (with or without storage)
  with minimal downtime
- automatically restarts VMs after host failure
  ([High Availability](http://xapi-project.github.io/features/HA/HA.html))
- allows cross-site [Disaster Recovery](http://xapi-project.github.io/features/DR/DR.html)
- simplifies maintainence through [Rolling Pool Upgrade](http://xapi-project.github.io/features/RPU/RPU.html)
- collects performance statistics for historical analysis and for alerting
- has a full-featured
  [XML-RPC based API](http://xapi-project.github.io/xen-api/),
  used by clients such as
  [XenCenter](https://github.com/xenserver/xenadmin),
  [Xen Orchestra](https://xen-orchestra.com),
  [OpenStack](http://www.openstack.org)
  and [CloudStack](http://cloudstack.apache.org)

The Xapi toolstack is built from a large set of libraries and components
which are
developed independently and versioned separately. It's easy for us to
share code with other open-source projects like
[Mirage](https://web.archive.org/web/20210315014753/http://openmirage.org/), however
this flexibility comes 
with a cost: when one binary such as "xapi" (the cluster manager)
depends on 45 separate libraries,
how do we quickly set up a
build environment?
Exactly which libraries do we need? How do we apply updates?
If we change one of these libraries (e.g. to make a bugfix), exactly which
bits should we rebuild?
This is where [OPAM](https://opam.ocaml.org),
the source package manager, makes everything easy.

Installing a build environment with OPAM is particularly easy. 
For example in a CentOS 6.5 VM,
first [install OPAM](https://opam.ocaml.org/doc/Install.html):

and then:
```
$ opam init --comp=4.01.0
$ eval `opam config env`
```

Next install the necessary C libraries and development tools for xapi
using a command like

```
$ sudo yum install `opam install xapi -e centos`
```

Finally to build xapi itself:
```
$ opam install xapi
  ∗  install obuild                 0.1.1          [required by cdrom, nbd]
  ∗  install base-no-ppx            base           [required by lwt]
  ∗  install cmdliner               0.9.7          [required by nbd, tar-format]
  ∗  install camlp4                 4.01.0         [required by nbd]
  ∗  install ocamlfind              1.5.5          [required by xapi]
  ∗  install xmlm                   1.2.0          [required by xapi-libs-transitional, rpc, xen-api-client]
  ∗  install uuidm                  0.9.5          [required by xapi-forkexecd]
  ∗  install type_conv              111.13.00      [required by rpc]
  ∗  install syslog                 1.4            [required by xapi-forkexecd]
  ∗  install ssl                    0.4.7          [required by xapi]
  ∗  install ounit                  2.0.0          [required by xapi]
  ∗  install omake                  0.9.8.6-0.rc1  [required by xapi]
  ∗  install oclock                 0.4.0          [required by xapi]
  ∗  install libvhd                 0.9.0          [required by xapi]
  ∗  install fd-send-recv           1.0.1          [required by xapi]
  ∗  install cppo                   1.1.2          [required by ocplib-endian]
  ∗  install cdrom                  0.9.1          [required by xapi]
  ∗  install base-bytes             legacy         [required by ctypes, re]
  ∗  install sexplib                111.17.00      [required by cstruct]
  ∗  install fieldslib              109.20.03      [required by cohttp]
  ∗  install lwt                    2.4.7          [required by tar-format, nbd, rpc, xen-api-client]
  ∗  install xapi-stdext            0.12.0         [required by xapi]
  ∗  install stringext              1.2.0          [required by uri]
  ∗  install re                     1.3.0          [required by xapi-forkexecd, tar-format, xen-api-client]
  ∗  install ocplib-endian          0.8            [required by cstruct]
  ∗  install ctypes                 0.3.4          [required by opasswd]
  ∗  install xenctrl                0.9.26         [required by xapi]
  ∗  install rpc                    1.5.1          [required by xapi]
  ∗  install xapi-inventory         0.9.1          [required by xapi]
  ∗  install uri                    1.7.2          [required by xen-api-client]
  ∗  install cstruct                1.5.0          [required by tar-format, nbd, xen-api-client]
  ∗  install opasswd                0.9.3          [required by xapi]
  ∗  install xapi-rrd               0.9.1          [required by xapi-idl, xapi-rrd-transport]
  ∗  install cohttp                 0.10.1         [required by xen-api-client]
  ∗  install xenstore               1.2.5          [required by xapi]
  ∗  install tar-format             0.2.1          [required by xapi]
  ∗  install nbd                    1.0.2          [required by xapi]
  ∗  install io-page                1.2.0          [required by xapi-rrd-transport]
  ∗  install crc                    0.9.0          [required by xapi-rrd-transport]
  ∗  install xen-api-client         0.9.7          [required by xapi]
  ∗  install message-switch         0.10.4         [required by xapi-idl]
  ∗  install xenstore_transport     0.9.4          [required by xapi-libs-transitional]
  ∗  install mirage-profile         0.4            [required by xen-gnt]
  ∗  install xapi-idl               0.9.19         [required by xapi]
  ∗  install xen-gnt                2.2.0          [required by xapi-rrd-transport]
  ∗  install xapi-forkexecd         0.9.2          [required by xapi]
  ∗  install xapi-rrd-transport     0.7.2          [required by xapi-rrdd-plugin]
  ∗  install xapi-tapctl            0.9.2          [required by xapi]
  ∗  install xapi-netdev            0.9.1          [required by xapi]
  ∗  install xapi-libs-transitional 0.9.6          [required by xapi]
  ∗  install xapi-rrdd-plugin       0.6.0          [required by xapi]
  ∗  install xapi                   1.9.56
===== ∗  52 =====
Do you want to continue ? [Y/n] y
```

Obviously it's extremely tedious to do all that by hand!

OPAM also makes iterative development very easy.
Consider a scenario where a
[common interface](https://github.com/xapi-project/xcp-idl) has to be changed.
Without OPAM we have to figure out which components to rebuild manually--
this is both time-consuming and error-prone. When we want to make some
local changes we simply clone the repo and tell OPAM to "pin" the package
to the local checkout. OPAM will take care of rebuilding only the
dependent packages:

```
$ git clone git://github.com/xapi-project/xcp-idl
... make some local changes ...
$ opam pin add xapi-idl ./xcp-idl
$ opam install xapi
...
xapi-idl needs to be reinstalled.
The following actions will be performed:
  ↻  recompile xapi-idl               0.9.19*
  ↻  recompile xapi-rrd-transport     0.7.2    [uses xapi-idl]
  ↻  recompile xapi-forkexecd         0.9.2    [uses xapi-idl]
  ↻  recompile xapi-tapctl            0.9.2    [uses xapi-forkexecd]
  ↻  recompile xapi-netdev            0.9.1    [uses xapi-forkexecd]
  ↻  recompile xapi-libs-transitional 0.9.6    [uses xapi-forkexecd]
  ↻  recompile xapi-rrdd-plugin       0.6.0    [uses xapi-idl]
  ↻  recompile xapi                   1.9.56   [uses xapi-idl]
===== ↻  8 =====
Do you want to continue ? [Y/n] 
```

It's even easier if you just want to pin to a branch, such as master:
```
$ opam pin add xapi-idl git://github.com/xapi-project/xcp-idl
```

It's important to be able to iterate quickly when testing a bugfix--
OPAM makes this easy too. After making a change to a "pinned" repository
the user just has to type

```
$ opam update -u
```

and only the affected components will be rebuilt.

OPAM allows us to create our own 'development remotes' containing the
latest, bleeding-edge versions of our libraries. To install these unstable
versions we only need to type:

```
$ opam remote add xapi-project git://github.com/xapi-project/opam-repo-dev
$ opam update -u

=-=- Updating package repositories =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
[xapi-project] git://github.com/xapi-project/opam-repo-dev already up-to-date
[default] /home/djs/ocaml/opam-repository synchronized

Updates available for 4.01.0, apply them with 'opam upgrade':
=== ∗  1   ↻  6   ↗  6 ===
The following actions will be performed:
  ∗  install   xapi-backtrace         0.2               [required by xapi-idl, xapi-stdext]
  ↗  upgrade   xenctrl                0.9.26 to 0.9.28
  ↗  upgrade   xapi-stdext            0.12.0 to 0.13.0
  ↻  recompile xapi-rrd               0.9.1             [uses xapi-stdext]
  ↻  recompile xapi-inventory         0.9.1             [uses xapi-stdext]
  ↗  upgrade   xapi-idl               0.9.19 to 0.9.21
  ↻  recompile xapi-rrd-transport     0.7.2             [uses xapi-idl]
  ↻  recompile xapi-forkexecd         0.9.2             [uses xapi-idl, xapi-stdext]
  ↗  upgrade   xapi-libs-transitional 0.9.6 to 0.9.7
  ↻  recompile xapi-tapctl            0.9.2             [uses xapi-stdext]
  ↻  recompile xapi-netdev            0.9.1             [uses xapi-stdext]
  ↗  upgrade   xapi-rrdd-plugin       0.6.0 to 0.6.1
  ↗  upgrade   xapi                   1.9.56 to 1.9.58
===== ∗  1   ↻  6   ↗  6 =====
Do you want to continue ? [Y/n]
```

When a linked set of changes are ready to be pushed, we can make a
[single pull request](https://github.com/xapi-project/opam-repo-dev/pull/66)
updating a set of components, which triggers the
[travis](https://travis-ci.org/)
integration tests.

Summary
-------

The Xapi toolstack is built from a large set of libraries, independently
versioned and released, many of them shared with other projects
(such as [Mirage](https://web.archive.org/web/20210315014753/http://openmirage.org/)). The libraries are
easy to build and test separately, but the sheer number of dependencies
makes it difficult to build the whole project -- this is where opam
really shines. Opam simplifies our day-to-day lives by

- automatically rebuilding dependent software when dependencies change
- allowing us to share 'development remotes' containing bleeding-edge software
  amongst the development team
- allowing us to 'release' a co-ordinated set of versions with a `git push`
  and then trigger integration tests via [travis](https://travis-ci.org/)

If you have a lot of OCaml code to build, try OPAM!
