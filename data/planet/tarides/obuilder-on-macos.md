---
title: OBuilder on macOS
description: "Introduction The CI team at Tarides provides critical infrastucture
  to support the OCaml community. At the heart of that infrastructure is\u2026"
url: https://tarides.com/blog/2023-08-02-obuilder-on-macos
date: 2023-08-02T00:00:00-00:00
preview_image: https://tarides.com/static/838569cdf42276596862e3c38773ec0d/b5380/tarides_og.png
authors:
- Tarides
source:
---

<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#introduction" aria-label="introduction permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Introduction</h1>
<p>The CI team at Tarides provides critical infrastucture to support the OCaml community. At the heart of that infrastructure is providing a cluster of machines for running jobs. This blog post details how we improved our support for macOS and moved closer to our goal of supporting all Tier1 OCaml platforms.</p>
<p>In 2022, Patrick Ferris of Tarides, successfully implemented a macOS worker for <a href="https://github.com/ocurrent/obuilder">OBuilder</a>. The workers were added to <a href="https://opam.ci.ocaml.org"><code>opam-repo-ci</code></a> and <a href="https://ocaml.ci.dev">OCaml CI</a>, and this work was presented at the <a href="https://icfp22.sigplan.org/details/ocaml-2022-papers/8/Homogeneous-builds-with-OBuilder-and-OCaml">OCaml workshop in 2022</a> (<a href="https://watch.ocaml.org/w/64N6AFMfrfz7wpNJ5rsJsQ">video</a>).</p>
<p>Since then, I took over the day-to-day responsibility. This work builds upon those foundations to achieve a greater throughput of jobs on the existing Apple hardware. Originally, we launched macOS support using rsync for snapshots and user accounts for sandboxing and process isolation. At the time, we identified that this architecture was likely to be relatively slow<sup><a href="https://tarides.com/feed.xml#fn-1" class="footnote-ref">1</a></sup> given the overhead of using rsync over native file system snapshots.</p>
<p>This post describes how we switched the snapshots over to use ZFS, which has improved the I/O throughput, leading to more jobs built per hour. It also removed our use of MacFUSE, both simplifying the setup and further improving the I/O throughput.</p>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#obuilder" aria-label="obuilder permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>OBuilder</h1>
<p>The OBuilder library is the core of Tarides' CI Workers <sup><a href="https://tarides.com/feed.xml#fn-2" class="footnote-ref">2</a></sup>. OCaml CI, <code>opam-repo-ci</code>, OCurrent Deployer, OCaml Docs CI, and the Base Image Builder all generate jobs which need to be executed by OBuilder across a range of platforms. A central scheduler accepts job submissions and passes them off to individual workers running on physical servers. These jobs are described in a build script similar to a Dockerfile.</p>
<p>OBuilder takes the build scripts and performs its steps in a sandboxed environment. After each step, OBuilder uses the snapshot feature of the filesystem (ZFS or Btrfs) to store the state of the build. There is also an rsync backend that copies the build state. On Linux, it uses <code>runc</code> to sandbox the build steps, but any system that can run a command safely in a chroot could be used. Repeating a build will reuse the cached results.</p>
<p>It is worth briefly expanding upon this description to understand the typical steps OBuilder takes. Upon receiving a job, OBuilder loads the base image as the starting point for the build process. A base image contains an opam switch with an OCaml compiler installed and a Git clone of <code>opam-repository</code>. These base images are built periodically into Docker images using the <a href="https://images.ci.ocaml.org">Base Image Builder</a> and published to <a href="https://hub.docker.com/r/ocaml/opam">Docker Hub</a>. Steps within the job specification could install operating system packages and opam libraries before finally building the test package and executing any tests. A filesystem snapshot of the working folder is taken between each build step. These snapshots allow each step to be cached, if the same job is executed again or identical steps are shared between jobs. Additionally, the opam package download folder is shared between all jobs.</p>
<p>On Linux-based systems, the file system snapshots are performed by Btrfs and process isolation is performed via <code>runc</code>. A ZFS implementation of file system snapshots and a pseudo implementation using rsync are also available. Given sufficient system resources, tens or hundreds of jobs can be executed concurrently.</p>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#the-macos-challenges" aria-label="the macos challenges permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>The macOS Challenges</h1>
<p>macOS is a challenging system for OBuilder because there is no native container support. We must manually recreate the sandboxing needed for the build steps using user isolation. Furthermore, macOS operating system packages are installed via Homebrew, and the Homebrew installation folder is not relocatable. It is either <code>/usr/local</code> on Intel x86_64 or <code>/opt/homebrew</code> on Apple silicon (ARM64). The Homebrew documentation includes the warning <strong>Pick another prefix at your peril!</strong>,  and the internet is littered with bug reports of those who have ignored this warning. For building OCaml, the per-user <code>~/.opam</code> folder is relocatable by setting the environment variable <code>OPAMROOT=/path</code>; however, once set it cannot be changed, as the full path is embedded in objects built.</p>
<p>We need a sandbox that includes the user's home directory and the Homebrew folder.</p>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#initial-solution" aria-label="initial solution permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Initial Solution</h1>
<p>The initial macOS solution used dummy users for the base images, user isolation for the sandbox, a FUSE file system driver to redirect the Homebrew installation, and rsync to create file system snapshots.</p>
<p>For each step, OBuilder used rsync to copy the required snapshot from the store to the user&rsquo;s home directory. The FUSE file system driver redirected filesystem access to <code>/usr/local</code> to the user&rsquo;s home directory. This allowed the state of the Homebrew installation to be captured along with the opam switch held within the home directory. Once the build step was complete, rsync copied the current state back to the OBuilder store. The base images exist in dummy users' home directories, which are copied to the active user when needed.</p>
<p>The implementation was reliable but was hampered by I/O bottlenecks, and the lack of opam caching quickly hit GitHub's download rate limit.</p>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#a-new-implementation" aria-label="a new implementation permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>A New Implementation</h1>
<p>OBuilder already supported ZFS, which could be used on macOS through the <a href="https://openzfsonosx.org">OpenZFS on OS X</a> project. The ZFS and other store implementations hold a single working directory as the root for the <code>runc</code> container. On macOS, we need the sandbox to contain both the user&rsquo;s home directory and the Homebrew installation, but these locations need to be <em>in place</em> within the file system. This was achieved by adding two ZFS subvolumes mounted on these paths.</p>
<table>
<thead>
<tr>
<th>ZFS Volume</th>
<th>Mount point</th>
<th>Usage</th>
</tr>
</thead>
<tbody>
<tr>
<td>obuilder/result/<sha></sha></td>
<td>/Volumes/obuilder/result/<sha></sha></td>
<td>Job log</td>
</tr>
<tr>
<td>obuilder/result/<sha>/home</sha></td>
<td>/Users/mac1000</td>
<td>User&rsquo;s home directory</td>
</tr>
<tr>
<td>obuilder/result/<sha>/brew</sha></td>
<td>/opt/homebrew or /usr/local</td>
<td>Homebrew installation</td>
</tr>
</tbody>
</table>
<p>The ZFS implementation was extended to work recursively on the result folder, thereby including the subvolumes in the snapshot and clone operations. The sandbox is passed the ZFS root path and can mount the subvolumes to the appropriate mount points within the file system. The build step is then executed as a local user.</p>
<p>The ZFS store and OBuilder job specification included support to cache arbitrary folders. The sandbox was updated to use this feature to cache both the opam and the Homebrew download folders.</p>
<p>To create the initial base image, empty folders are mounted on the user home directory and Homebrew folder, then a shell script installs opam, OCaml, and a Git clone of the opam repository. When a base image is initially needed, the ZFS volume can be cloned as the basis of the first step. This replaces the Docker base images with OCaml and opam installed in them used by the Linux OBuilder implementation.</p>
<table>
<thead>
<tr>
<th>ZFS Volumes for macOS Homebrew Base Image for OCaml 4.14</th>
</tr>
</thead>
<tbody>
<tr>
<td>obuilder/base-image/macos-homebrew-ocaml-4.14</td>
</tr>
<tr>
<td>obuilder/base-image/macos-homebrew-ocaml-4.14/brew</td>
</tr>
<tr>
<td>obuilder/base-image/macos-homebrew-ocaml-4.14/home</td>
</tr>
</tbody>
</table>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#performance-improvements" aria-label="performance improvements permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Performance Improvements</h1>
<p>The rsync store was written for portability, not efficiency, and copying the files between each step quickly becomes the bottleneck. ZFS significantly improves efficiency through native snapshots and mounting the data at the appropriate point within the file system. However, this is not without cost, as unmounting a file system causes the disk-write cache to be flushed.</p>
<p>The ZFS store keeps all of the cache steps mounted. With a large cache disk (&gt;100GB), the store could reach several thousand result steps. As the number of mounted volumes increases, macOS&rsquo;s disk arbitration service takes exponentially longer to mount and unmount the file systems. Initially, the number of cache steps was artificially limited to keep the mount/unmount times within acceptable limits. Later, the ZFS store was updated to unmount unused volumes between each step.</p>
<p>The rsync store did not support caching of the opam downloads folder. This quickly led us to hit the download rate limits imposed by GitHub. Homebrew is also hosted on GitHub; therefore, these steps were also impacted. The list of folders shared between jobs is part of the job specification and was already passed to the sandbox, but it was not implemented. The job specification was updated to include the Homebrew downloads folder, and the shared cache folders were mounted within the sandbox.</p>
<p>Throughput has been improved by approximately fourfold. The rsync backend gave a typical performance of four jobs per hour. With ZFS, we see jobs rates of typically 16 jobs per hour. The best recorded rate with ZFS is over 100 jobs per hour!</p>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#multi-user-considerations" aria-label="multi user considerations permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Multi-User Considerations</h1>
<p>The rsync and ZFS implementations are limited to running one job simultaneously, limiting the throughput of jobs on macOS. It would be ideal if the implementation could be extended to support concurrent jobs; however, with user isolation, it is unclear how this could be achieved, as the full path of the OCaml installation is included in numerous binary files within the <code>~/.opam</code> directory. Thus, opam installed in <code>/Users/foo/.opam</code> could not be mounted as <code>/Users/bar/.opam</code>. The other issue with supporting multiuser is that Homebrew is not designed to be used by multiple Unix users. A given Homebrew installation is only meant to be used by a single non-root user.</p>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#summary" aria-label="summary permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Summary</h1>
<p>With this work adding macOS support to OBuilder using ZFS, the cluster provides workers for macOS on both x86_64 and ARM64. This capability is available to all CI systems managed by Tarides. Initial support has been added to <code>opam-repo-ci</code> to provide builds for the opam repository, allowing us to check packages build on macOS. We have also added support to OCaml-CI to provide builds for GitHub and GitLab hosted projects, and there is work in progress to provide macOS builds for testing OCaml's Multicore support. MacOS builds are an important piece of our goal to provide builds on all Tier 1 OCaml platforms. We hope you find it useful too.</p>
<p>All the code is open source and available on <a href="https://github.com/ocurrent">github.com/ocurrent</a>.</p>
<div class="footnotes">
<hr/>
<ol>
<li>As compared to other workers where native snapshots are available, such as BRTRS on Linux.<a href="https://tarides.com/feed.xml#fnref-1" class="footnote-backref">&#8617;</a><a href="https://tarides.com/feed.xml#fnref-1" class="footnote-backref">&#8617;</a></li>
<li>In software development, a &quot;Continuous Integration (CI) worker&quot; is a computing resource responsible for automating the process of building, testing, and deploying code changes in Continuous Integration systems.<a href="https://tarides.com/feed.xml#fnref-2" class="footnote-backref">&#8617;</a><a href="https://tarides.com/feed.xml#fnref-2" class="footnote-backref">&#8617;</a></li>
</ol>
</div>
