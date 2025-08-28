---
title: Debugging OBuilder on macOS
description: The log from an OBuilder job starts with the steps needed to reproduce
  the job locally. This boilerplate output assumes that all OBuilder jobs start from
  a Docker base image, but on some operating systems, such as FreeBSD and macOS, OBuilder
  uses ZFS base images. On OpenBSD and Windows, it uses QEMU images. The situation
  is further complicated when the issue only affects a specific architecture that
  may be unavailable to the user.
url: https://www.tunbury.org/2025/05/08/debugging-obuilder-macos/
date: 2025-05-08T12:00:00-00:00
preview_image: https://www.tunbury.org/images/obuilder.png
authors:
- Mark Elvers
source:
ignore:
---

<p>The log from an <a href="https://github.com/ocurrent/obuilder">OBuilder</a> job starts with the steps needed to reproduce the job locally. This boilerplate output assumes that all OBuilder jobs start from a Docker base image, but on some operating systems, such as FreeBSD and macOS, OBuilder uses ZFS base images. On OpenBSD and Windows, it uses QEMU images. The situation is further complicated when the issue only affects a specific architecture that may be unavailable to the user.</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>2025-05-08 13:29.37: New job: build bitwuzla-cxx.0.7.0, using opam 2.3
                              from https://github.com/ocaml/opam-repository.git#refs/pull/27768/head (55a47416d532dc829d9111297970934a21a1b1c4)
                              on macos-homebrew-ocaml-4.14/amd64

To reproduce locally:

cd $(mktemp -d)
git clone --recursive "https://github.com/ocaml/opam-repository.git" &amp;&amp; cd "opam-repository" &amp;&amp; git fetch origin "refs/pull/27768/head" &amp;&amp; git reset --hard 55a47416
git fetch origin master
git merge --no-edit b8a7f49af3f606bf8a22869a1b52b250dd90092e
cat &gt; ../Dockerfile &lt;&lt;'END-OF-DOCKERFILE'

FROM macos-homebrew-ocaml-4.14
USER 1000:1000
RUN ln -f ~/local/bin/opam-2.3 ~/local/bin/opam
RUN opam init --reinit -ni
RUN opam option solver=builtin-0install &amp;&amp; opam config report
ENV OPAMDOWNLOADJOBS="1"
ENV OPAMERRLOGLEN="0"
ENV OPAMPRECISETRACKING="1"
ENV CI="true"
ENV OPAM_REPO_CI="true"
RUN rm -rf opam-repository/
COPY --chown=1000:1000 . opam-repository/
RUN opam repository set-url -k local --strict default opam-repository/
RUN opam update --depexts || true
RUN opam pin add -k version -yn bitwuzla-cxx.0.7.0 0.7.0
RUN opam reinstall bitwuzla-cxx.0.7.0; \
    res=$?; \
    test "$res" != 31 &amp;&amp; exit "$res"; \
    export OPAMCLI=2.0; \
    build_dir=$(opam var prefix)/.opam-switch/build; \
    failed=$(ls "$build_dir"); \
    partial_fails=""; \
    for pkg in $failed; do \
    if opam show -f x-ci-accept-failures: "$pkg" | grep -qF "\"macos-homebrew\""; then \
    echo "A package failed and has been disabled for CI using the 'x-ci-accept-failures' field."; \
    fi; \
    test "$pkg" != 'bitwuzla-cxx.0.7.0' &amp;&amp; partial_fails="$partial_fails $pkg"; \
    done; \
    test "${partial_fails}" != "" &amp;&amp; echo "opam-repo-ci detected dependencies failing: ${partial_fails}"; \
    exit 1


END-OF-DOCKERFILE
docker build -f ../Dockerfile .
</code></pre></div></div>

<p>It is, therefore, difficult to diagnose the issue on these operating systems and on esoteric architectures. Is it an issue with the CI system or the job itself?</p>

<p>My approach is to get myself into an interactive shell at the point in the build where the failure occurs. On Linux and FreeBSD, the log is available in <code class="language-plaintext highlighter-rouge">/var/log/syslog</code> or <code class="language-plaintext highlighter-rouge">/var/log/messages</code> respectively. On macOS, this log is written to <code class="language-plaintext highlighter-rouge">ocluster.log</code>. macOS workers are single-threaded, so the worker must be paused before progressing.</p>

<p>Each step in an OBuilder job consists of taking a snapshot of the previous layer, running a command in that layer, and keeping or discarding the layer depending on the command’s success or failure. On macOS, layers are ZFS snapshots mounted over the Homebrew directory and the CI users’ home directory. We can extract the appropriate command from the logs.</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>2025-05-08 14:31.17    application [INFO] Exec "zfs" "clone" "-o" "canmount=noauto" "--" "obuilder/result/a67e6d3b460fa52b5c57581e7c01fa74ddca0a0b5462fef34103a09e87f3feec@snap" "obuilder/result/af09425cd7744c7b32ed000b11db90295142f3d3430fddb594932d5c02343b40"
2025-05-08 14:31.17    application [INFO] Exec "zfs" "mount" "obuilder/result/af09425cd7744c7b32ed000b11db90295142f3d3430fddb594932d5c02343b40"
2025-05-08 14:31.17    application [INFO] Exec "zfs" "clone" "-o" "mountpoint=none" "--" "obuilder/result/a67e6d3b460fa52b5c57581e7c01fa74ddca0a0b5462fef34103a09e87f3feec/brew@snap" "obuilder/result/af09425cd7744c7b32ed000b11db90295142f3d3430fddb594932d5c02343b40/brew"
2025-05-08 14:31.17    application [INFO] Exec "zfs" "clone" "-o" "mountpoint=none" "--" "obuilder/result/a67e6d3b460fa52b5c57581e7c01fa74ddca0a0b5462fef34103a09e87f3feec/home@snap" "obuilder/result/af09425cd7744c7b32ed000b11db90295142f3d3430fddb594932d5c02343b40/home"
cannot open 'obuilder/result/af09425cd7744c7b32ed000b11db90295142f3d3430fddb594932d5c02343b40@snap': dataset does not exist
2025-05-08 14:31.17    application [INFO] Exec "zfs" "clone" "--" "obuilder/cache/c-opam-archives@snap" "obuilder/cache-tmp/8608-c-opam-archives"
2025-05-08 14:31.17    application [INFO] Exec "zfs" "clone" "--" "obuilder/cache/c-homebrew@snap" "obuilder/cache-tmp/8609-c-homebrew"
2025-05-08 14:31.18       obuilder [INFO] result_tmp = /Volumes/obuilder/result/af09425cd7744c7b32ed000b11db90295142f3d3430fddb594932d5c02343b40
2025-05-08 14:31.18    application [INFO] Exec "zfs" "set" "mountpoint=/Users/mac1000" "obuilder/result/af09425cd7744c7b32ed000b11db90295142f3d3430fddb594932d5c02343b40/home"
2025-05-08 14:31.18    application [INFO] Exec "zfs" "set" "mountpoint=/usr/local" "obuilder/result/af09425cd7744c7b32ed000b11db90295142f3d3430fddb594932d5c02343b40/brew"
2025-05-08 14:31.18       obuilder [INFO] src = /Volumes/obuilder/cache-tmp/8608-c-opam-archives, dst = /Users/mac1000/.opam/download-cache, type rw
2025-05-08 14:31.18    application [INFO] Exec "zfs" "set" "mountpoint=/Users/mac1000/.opam/download-cache" "obuilder/cache-tmp/8608-c-opam-archives"
Unmount successful for /Volumes/obuilder/cache-tmp/8608-c-opam-archives
2025-05-08 14:31.18       obuilder [INFO] src = /Volumes/obuilder/cache-tmp/8609-c-homebrew, dst = /Users/mac1000/Library/Caches/Homebrew, type rw
2025-05-08 14:31.18    application [INFO] Exec "zfs" "set" "mountpoint=/Users/mac1000/Library/Caches/Homebrew" "obuilder/cache-tmp/8609-c-homebrew"
Unmount successful for /Volumes/obuilder/cache-tmp/8609-c-homebrew
2025-05-08 14:31.19    application [INFO] Exec "sudo" "dscl" "." "list" "/Users"
2025-05-08 14:31.19    application [INFO] Exec "sudo" "-u" "mac1000" "-i" "getconf" "DARWIN_USER_TEMP_DIR"
2025-05-08 14:31.19    application [INFO] Fork exec "sudo" "su" "-l" "mac1000" "-c" "--" "source ~/.obuilder_profile.sh &amp;&amp; env 'TMPDIR=/var/folders/s_/z7_t3bvn5txfn81hk9p3ntfw0000z8/T/' 'OPAM_REPO_CI=true' 'CI=true' 'OPAMPRECISETRACKING=1' 'OPAMERRLOGLEN=0' 'OPAMDOWNLOADJOBS=1' "$0" "$@"" "/usr/bin/env" "bash" "-c" "opam reinstall bitwuzla-cxx.0.7.0;
        res=$?;
        test "$res" != 31 &amp;&amp; exit "$res";
        export OPAMCLI=2.0;
        build_dir=$(opam var prefix)/.opam-switch/build;
        failed=$(ls "$build_dir");
        partial_fails="";
        for pkg in $failed; do
          if opam show -f x-ci-accept-failures: "$pkg" | grep -qF "\"macos-homebrew\""; then
            echo "A package failed and has been disabled for CI using the 'x-ci-accept-failures' field.";
          fi;
          test "$pkg" != 'bitwuzla-cxx.0.7.0' &amp;&amp; partial_fails="$partial_fails $pkg";
        done;
        test "${partial_fails}" != "" &amp;&amp; echo "opam-repo-ci detected dependencies failing: ${partial_fails}”;
        exit 1"
2025-05-08 14:31.28         worker [INFO] OBuilder partition: 27% free, 2081 items
2025-05-08 14:31.58         worker [INFO] OBuilder partition: 27% free, 2081 items
2025-05-08 14:32.28         worker [INFO] OBuilder partition: 27% free, 2081 items
2025-05-08 14:32.43    application [INFO] Exec "zfs" "inherit" "mountpoint" "obuilder/cache-tmp/8608-c-opam-archives"
Unmount successful for /Users/mac1000/.opam/download-cache
2025-05-08 14:32.44    application [INFO] Exec "zfs" "inherit" "mountpoint" "obuilder/cache-tmp/8609-c-homebrew"
Unmount successful for /Users/mac1000/Library/Caches/Homebrew
2025-05-08 14:32.45    application [INFO] Exec "zfs" "set" "mountpoint=none" "obuilder/result/af09425cd7744c7b32ed000b11db90295142f3d3430fddb594932d5c02343b40/home"
Unmount successful for /Users/mac1000
2025-05-08 14:32.45    application [INFO] Exec "zfs" "set" "mountpoint=none" "obuilder/result/af09425cd7744c7b32ed000b11db90295142f3d3430fddb594932d5c02343b40/brew"
Unmount successful for /usr/local
2025-05-08 14:32.46    application [INFO] Exec "zfs" "rename" "--" "obuilder/cache/c-homebrew" "obuilder/cache-tmp/8610-c-homebrew"
Unmount successful for /Volumes/obuilder/cache/c-homebrew
2025-05-08 14:32.46    application [INFO] Exec "zfs" "promote" "obuilder/cache-tmp/8609-c-homebrew"
2025-05-08 14:32.46    application [INFO] Exec "zfs" "destroy" "-f" "--" "obuilder/cache-tmp/8610-c-homebrew"
Unmount successful for /Volumes/obuilder/cache-tmp/8610-c-homebrew
2025-05-08 14:32.48    application [INFO] Exec "zfs" "rename" "--" "obuilder/cache-tmp/8609-c-homebrew@snap" "obuilder/cache-tmp/8609-c-homebrew@old-2152"
2025-05-08 14:32.48    application [INFO] Exec "zfs" "destroy" "-d" "--" "obuilder/cache-tmp/8609-c-homebrew@old-2152"
2025-05-08 14:32.48    application [INFO] Exec "zfs" "snapshot" "-r" "--" "obuilder/cache-tmp/8609-c-homebrew@snap"
2025-05-08 14:32.48    application [INFO] Exec "zfs" "rename" "--" "obuilder/cache-tmp/8609-c-homebrew" "obuilder/cache/c-homebrew"
Unmount successful for /Volumes/obuilder/cache-tmp/8609-c-homebrew
2025-05-08 14:32.49    application [INFO] Exec "zfs" "rename" "--" "obuilder/cache/c-opam-archives" "obuilder/cache-tmp/8611-c-opam-archives"
Unmount successful for /Volumes/obuilder/cache/c-opam-archives
2025-05-08 14:32.50    application [INFO] Exec "zfs" "promote" "obuilder/cache-tmp/8608-c-opam-archives"
2025-05-08 14:32.50    application [INFO] Exec "zfs" "destroy" "-f" "--" "obuilder/cache-tmp/8611-c-opam-archives"
Unmount successful for /Volumes/obuilder/cache-tmp/8611-c-opam-archives
2025-05-08 14:32.51    application [INFO] Exec "zfs" "rename" "--" "obuilder/cache-tmp/8608-c-opam-archives@snap" "obuilder/cache-tmp/8608-c-opam-archives@old-2152"
2025-05-08 14:32.51    application [INFO] Exec "zfs" "destroy" "-d" "--" "obuilder/cache-tmp/8608-c-opam-archives@old-2152"
2025-05-08 14:32.51    application [INFO] Exec "zfs" "snapshot" "-r" "--" "obuilder/cache-tmp/8608-c-opam-archives@snap"
2025-05-08 14:32.52    application [INFO] Exec "zfs" "rename" "--" "obuilder/cache-tmp/8608-c-opam-archives" "obuilder/cache/c-opam-archives"
Unmount successful for /Volumes/obuilder/cache-tmp/8608-c-opam-archives
2025-05-08 14:32.52    application [INFO] Exec "zfs" "destroy" "-r" "-f" "--" "obuilder/result/af09425cd7744c7b32ed000b11db90295142f3d3430fddb594932d5c02343b40"
Unmount successful for /Volumes/obuilder/result/af09425cd7744c7b32ed000b11db90295142f3d3430fddb594932d5c02343b40
2025-05-08 14:32.58         worker [INFO] OBuilder partition: 27% free, 2081 items
2025-05-08 14:33.04         worker [INFO] Job failed: "/usr/bin/env" "bash" "-c" "opam reinstall bitwuzla-cxx.0.7.0;
        res=$?;
        test "$res" != 31 &amp;&amp; exit "$res";
        export OPAMCLI=2.0;
        build_dir=$(opam var prefix)/.opam-switch/build;
        failed=$(ls "$build_dir");
        partial_fails="";
        for pkg in $failed; do
          if opam show -f x-ci-accept-failures: "$pkg" | grep -qF "\"macos-homebrew\""; then
            echo "A package failed and has been disabled for CI using the 'x-ci-accept-failures' field.";
          fi;
          test "$pkg" != 'bitwuzla-cxx.0.7.0' &amp;&amp; partial_fails="$partial_fails $pkg";
        done;
        test "${partial_fails}" != "" &amp;&amp; echo "opam-repo-ci detected dependencies failing: ${partial_fails}";
        exit 1" failed with exit status 1

</code></pre></div></div>

<p>Run each of the <em>Exec</em> commands at the command prompt up to the <em>Fork exec</em>. We do need to run it, but we want an interactive shell, so let’s change the final part of the command to <code class="language-plaintext highlighter-rouge">bash</code>:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>sudo su -l mac1000 -c -- "source ~/.obuilder_profile.sh &amp;&amp; env 'TMPDIR=/var/folders/s_/z7_t3bvn5txfn81hk9p3ntfw0000z8/T/' 'OPAM_REPO_CI=true' 'CI=true' 'OPAMPRECISETRACKING=1' 'OPAMERRLOGLEN=0' 'OPAMDOWNLOADJOBS=1' bash"
</code></pre></div></div>

<p>Now, at the shell prompt, we can try <code class="language-plaintext highlighter-rouge">opam reinstall bitwuzla-cxx.0.7.0</code>. Hopefully, this fails, which proves we have successfully recreated the environment!</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>$ opam source bitwuzla-cxx.0.7.0
$ cd bitwuzla-cxx.0.7.0
$ dune build
File "vendor/dune", lines 201-218, characters 0-436:
201 | (rule
202 |  (deps
203 |   (source_tree bitwuzla)
.....
216 |      %{p0002}
217 |      (run patch -p1 --directory bitwuzla))
218 |     (write-file %{target} "")))))
(cd _build/default/vendor &amp;&amp; /usr/bin/patch -p1 --directory bitwuzla) &lt; _build/default/vendor/patch/0001-api-Add-hook-for-ocaml-z-value.patch
patching file 'include/bitwuzla/cpp/bitwuzla.h'
Can't create '/var/folders/s_/z7_t3bvn5txfn81hk9p3ntfw0000z8/T/build_9012b8_dune/patchoEyVbKAjSTw', output is in '/var/folders/s_/z7_t3bvn5txfn81hk9p3ntfw0000z8/T/build_9012b8_dune/patchoEyVbKAjSTw': Permission denied
patch: **** can't create '/var/folders/s_/z7_t3bvn5txfn81hk9p3ntfw0000z8/T/build_9012b8_dune/patchoEyVbKAjSTw': Permission denied
</code></pre></div></div>

<p>This matches the output we see on the CI logs. <code class="language-plaintext highlighter-rouge">/var/folders/s_/z7_t3bvn5txfn81hk9p3ntfw0000z8/T</code> is the <code class="language-plaintext highlighter-rouge">TMPDIR</code> value set in the environment. <code class="language-plaintext highlighter-rouge">Permission denied</code> looks like file system permissions. <code class="language-plaintext highlighter-rouge">ls -l</code> and <code class="language-plaintext highlighter-rouge">touch</code> show we can write to this directory.</p>

<p>As we are running on macOS, and the Dune is invoking <code class="language-plaintext highlighter-rouge">patch</code>, my thought goes to Apple’s <code class="language-plaintext highlighter-rouge">patch</code> vs GNU’s <code class="language-plaintext highlighter-rouge">patch</code>. Editing <code class="language-plaintext highlighter-rouge">vendor/dune</code> to use <code class="language-plaintext highlighter-rouge">gpatch</code> rather than <code class="language-plaintext highlighter-rouge">patch</code> allows the project to build.</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>$ dune build
(cd _build/default/vendor &amp;&amp; /usr/local/bin/gpatch --directory bitwuzla -p1) &lt; _build/default/vendor/patch/0001-api-Add-hook-for-ocaml-z-value.patch
File include/bitwuzla/cpp/bitwuzla.h is read-only; trying to patch anyway
patching file include/bitwuzla/cpp/bitwuzla.h
</code></pre></div></div>

<p>Running Apple’s <code class="language-plaintext highlighter-rouge">patch</code> directly,</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>$ patch -p1 &lt; ../../../../vendor/patch/0001-api-Add-hook-for-ocaml-z-value.patch
patching file 'include/bitwuzla/cpp/bitwuzla.h'
Can't create '/var/folders/s_/z7_t3bvn5txfn81hk9p3ntfw0000z8/T/patchorVrfBtHVDI', output is in '/var/folders/s_/z7_t3bvn5txfn81hk9p3ntfw0000z8/T/patchorVrfBtHVDI': Permission denied
patch: **** can't create '/var/folders/s_/z7_t3bvn5txfn81hk9p3ntfw0000z8/T/patchorVrfBtHVDI': Permission denied
</code></pre></div></div>

<p>However, <code class="language-plaintext highlighter-rouge">touch /var/folders/s_/z7_t3bvn5txfn81hk9p3ntfw0000z8/T/patchorVrfBtHVDI</code> succeeds.</p>

<p>Looking back at the output from GNU <code class="language-plaintext highlighter-rouge">patch</code>, it reports that the file itself is read-only.</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>$ ls -l include/bitwuzla/cpp/bitwuzla.h
-r--r--r--  1 mac1000  admin  52280 May  8 15:05 include/bitwuzla/cpp/bitwuzla.h
</code></pre></div></div>

<p>Let’s try to adjust the permissions:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>$ chmod 644 include/bitwuzla/cpp/bitwuzla.h
$ patch -p1 &lt; ../../../../vendor/patch/0001-api-Add-hook-for-ocaml-z-value.patch
patching file 'include/bitwuzla/cpp/bitwuzla.h’
</code></pre></div></div>

<p>And now, it succeeds. The issue is that GNU’s <code class="language-plaintext highlighter-rouge">patch</code> and Apple’s <code class="language-plaintext highlighter-rouge">patch</code> act differently when the file being patched is read-only. Apple’s <code class="language-plaintext highlighter-rouge">patch</code> gives a spurious error, while GNU’s <code class="language-plaintext highlighter-rouge">patch</code> emits a warning and makes the change anyway.</p>

<p>Updating the <code class="language-plaintext highlighter-rouge">dune</code> file to include <code class="language-plaintext highlighter-rouge">chmod</code> should both clear the warning and allow the use of the native patch.</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>(rule
 (deps
  (source_tree bitwuzla)
  (:p0001
   (file patch/0001-api-Add-hook-for-ocaml-z-value.patch))
  (:p0002
   (file patch/0002-binding-Fix-segfault-with-parallel-instances.patch)))
 (target .bitwuzla_tree)
 (action
  (no-infer
   (progn
    (run chmod -R u+w bitwuzla)
    (with-stdin-from
     %{p0001}
     (run patch -p1 --directory bitwuzla))
    (with-stdin-from
     %{p0002}
     (run patch -p1 --directory bitwuzla))
    (write-file %{target} "")))))
</code></pre></div></div>

<p>As an essential last step, we need to tidy up on this machine. Exit the shell. Refer back to the log file for the job and run all the remaining ZFS commands. This is incredibly important on macOS and essential to keep the jobs database in sync with the layers.</p>
