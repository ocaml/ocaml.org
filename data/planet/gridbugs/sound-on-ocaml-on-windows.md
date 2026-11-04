---
title: Sound on OCaml on Windows
description: I got my OCaml music synthesizer working on Windows. Here's all the things
  that went wrong in the process.
url: https://www.gridbugs.org/sound-on-ocaml-on-windows/
date: 2025-06-02T00:00:00-00:00
preview_image: https://www.gridbugs.org/sound-on-ocaml-on-windows/banner.jpg
authors:
- Gridbugs
source:
ignore:
keywords:
- appdata
- conf-ao
- conf-portaudio
- cygwin
- llama
- msys2
- opam
- os-distribution
- topkg
- users
---

<p><img src="https://www.gridbugs.org/sound-on-ocaml-on-windows/banner.jpg" alt="Close up of a modular synthesizer"></p>
<p><em>I got my OCaml music synthesizer working on Windows. Here’s all the things that went wrong in the process.</em></p>
<p>This post will chronicle my attempt to use OCaml to play generated audio
samples on a Windows PC. This is part of my work on the <a href="https://github.com/gridbugs/llama/">llama synthesizer
library</a>, where I’ve been rewriting the
low-level audio logic formerly written in Rust (with
<a href="https://crates.io/crates/cpal">cpal</a>) into OCaml to simplify the build process
and development experience. I’ve written down some of my complaints about
the developer experience working on <code>llama</code> in a <a href="https://www.gridbugs.org/frustrating-interactions-with-the-ocaml-ecosystem-while-developing-a-synthesizer-library/">previous
post</a>
and some of those difficulties came from complications working with Rust/OCaml
interop, so removing all Rust from the project will help reduce friction
developing it further.</p>
<p>I have a proof-of-concept version of <code>llama</code> based on <a href="https://opam.ocaml.org/packages/ao/">OCaml’s libao
bindings</a> which works on Linux and MacOS.
Libao claims to support Windows but I haven’t figured out how to install it on
Windows so I might experiment with some easier-to-install alternatives in this post.</p>
<p>The intention of this post is to serve as a guide to anyone getting started with
OCaml on Windows, to highlight some of the remaining problems with the OCaml ecosystem on
Windows, and to demonstrate some usability issues with Opam in general. My summary is that
OCaml on Windows is easier than I expected it to be, but there are still some
rough edges that newcomers should be aware of to properly set expectations. I
wrote down everything I tried as I tried it, so all the mistakes, blind alleys
and failed debugging experiments will be documented here as well as the paths
that eventually led to solutions.</p>
<h2><a href="https://www.gridbugs.org/rss.xml#install-opam" class="zola-anchor" aria-label="Anchor link for: install-opam">Install Opam</a></h2>
<p>For the purposes of this post I’ll set up an entire OCaml environment on Windows
from scratch. I’ll be using PowerShell 7.5.1 for all shell commands in this
post. For the purposes of translating commands and paths to other machines, I’ll
state explicitly that my username is “s”.</p>
<p>We’ll install Opam with WinGet. I’ve had some difficulty setting up WinGet in
the past and written about setting it up properly in a <a href="https://www.gridbugs.org/setting-up-winget-for-the-first-time/">previous
post</a> but today it worked as expected.</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s&gt; winget install Git.Git OCaml.opam
</span><span>...
</span><span>PS C:\Users\s&gt; opam init
</span><span>...
</span><span>How should opam obtain Unix tools?
</span><span>&gt; 1. Automatically create an internal Cygwin installation that will be managed by
</span><span>     opam (recommended)
</span><span>  2. Use an existing Cygwin/MSYS2 installation
</span><span>  3. Abort initialisation
</span><span>
</span><span>[1/2/3] 1  &lt;-- here I selected option 1
</span><span>...
</span></code></pre>
<p>Allowing Opam to manage its own Cygwin installation is the recommended way of
using Opam on Windows, so that’s what I’ll try first. This results in Cygwin being
installed to <code>C:\Users\s\AppData\Local\opam\.cygwin</code>. This might come in handy
to know if we ever need to manually install a Cygwin package, though hopefully
Opam can take care of installing any such packages via Opam’s <code>depexts</code> system
which knows how to install system-specific packages needed by Opam packages by
directly invoking the package manager to install the appropriately-named package.</p>
<p>Bear in mind that Opam’s initialization can take 15 minutes or so on Windows
with most of the time spent building the OCaml compiler. Compiling OCaml code
on Windows tends to be much slower than on MacOS and Linux. I don’t understand
why.</p>
<h2><a href="https://www.gridbugs.org/rss.xml#install-a-sound-library" class="zola-anchor" aria-label="Anchor link for: install-a-sound-library">Install a sound library</a></h2>
<p>We need to choose a library in the Opam repository that can give us access
to the sound card. Ideally we would use a library with a <code>depext</code> tailored to
Windows with Cygwin, as that way Opam can take care of installing any system dependencies
via Cygwin. Since my experimental version of <code>llama</code> is already implemented with
libao that would be the most convenient choice, however its <code>depexts</code> don’t look
promising:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s&gt; opam show conf-ao
</span><span>...
</span><span>depexts     ["libao-devel"]
</span><span>              {os-distribution = "centos" | os-family = "fedora" | os-family = "suse" |
</span><span>               os-family = "opensuse"}
</span><span>            ["libao"]
</span><span>              {os = "freebsd" | os = "macos" &amp; os-distribution = "homebrew" |
</span><span>               os-distribution = "nixos" |
</span><span>               os-family = "arch"}
</span><span>            ["libao-dev"]
</span><span>              {os-family = "debian" | os-family = "ubuntu" | os-distribution = "alpine"}
</span></code></pre>
<p>There are no entries in that list for Windows, so using libao would require
setting it up manually which I’d prefer to avoid.</p>
<p>Another candidate library is
<a href="https://opam.ocaml.org/packages/portaudio/">portaudio</a>.</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s&gt; opam show conf-portaudio
</span><span>...
</span><span>depexts     ["portaudio-dev"] {os-distribution = "alpine"}
</span><span>            ["portaudio-devel"]
</span><span>              {os-distribution = "centos" | os-distribution = "fedora" |
</span><span>               os-family = "suse" |
</span><span>               os-family = "opensuse"}
</span><span>            ["portaudio"] {os = "macos" &amp; os-distribution = "homebrew"}
</span><span>            ["portaudio"]
</span><span>              {os = "freebsd" | os-family = "arch" | os-distribution = "nixos" |
</span><span>               os-distribution = "ol"}
</span><span>            ["portaudio"] {os = "win32" &amp; os-distribution = "cygwinports"}
</span><span>            ["portaudio19-dev"] {os-family = "debian" | os-family = "ubuntu"}
</span></code></pre>
<p>That’s more promising as there’s a <code>depext</code> that gets chosen on <code>{os = "win32" &amp; os-distribution = "cygwinports"}</code>. It’s a little concerning that the name of the
<code>os-distribution</code> is “cygwinports” and not just “cygwin”. I’ve never come across
cygwinports before, but maybe it won’t matter. The next step is to see if
installing <code>conf-portaudio</code> with Opam causes the right <code>depext</code> to be installed
with Cygwin:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s&gt; opam install conf-portaudio
</span><span>The following actions will be performed:
</span><span>=== recompile 1 package
</span><span>  ↻ mingw-w64-shims 0.2.0 [uses conf-pkg-config]
</span><span>=== install 2 packages
</span><span>  ∗ conf-pkg-config 4     [required by conf-portaudio]
</span><span>  ∗ conf-portaudio  1
</span><span>
</span><span>Proceed with ↻ 1 recompilation and ∗ 2 installations? [y/n] y
</span><span>
</span><span>The following system packages will first need to be installed:
</span><span>    pkgconf
</span><span>
</span><span>&lt;&gt;&lt;&gt; Handling external dependencies &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;  🐫
</span><span>
</span><span>+ C:\Users\s\AppData\Local\opam\.cygwin\setup-x86_64.exe "--root" "C:\\Users\\s\\AppData\\Local\\opam\\.cygwin\\root" "--quiet-mode" "noinput" "--no-shortcuts" "--no-startmenu" "--no-desktop" "--no-admin" "--no-version-check" "--no-write-registry" "--packages" "pkgconf" "--upgrade-also" "--only-site" "--site" "https://cygwin.mirror.constant.com/" "--local-package-dir" "C:\\Users\\s\\AppData\\Local\\opam\\.cygwin\\cache"
</span><span>- Starting cygwin install, version 2.934
</span><span>- User has NO backup/restore rights
</span><span>- User has NO symlink creation right
</span><span>- io_stream_cygfile: fopen(/etc/setup/setup.rc) failed 2 No such file or directory
</span><span>- Current Directory: C:\Users\s\AppData\Local\opam\.cygwin\cache
</span><span>- root: C:\Users\s\AppData\Local\opam\.cygwin\root user
</span><span>- Changing gid back to original
</span><span>- Selected local directory: C:\Users\s\AppData\Local\opam\.cygwin\cache
</span><span>- net: Preconfig
</span><span>- site: https://cygwin.mirror.constant.com/
</span><span>- solving: 1 tasks, update: yes, use test packages: no
</span><span>- solving: 2 tasks, update: no, use test packages: no
</span><span>- Augmented Transaction List:
</span><span>-    0 install libpkgconf6 2.4.3-1
</span><span>-    1 install pkgconf     2.4.3-1
</span><span>- Downloaded C:\Users\s\AppData\Local\opam\.cygwin\cache/https%3a%2f%2fcygwin.mirror.constant.com%2f/x86_64/release/pkgconf/libpkgconf6/libpkgconf6-2.4.3-1.tar.zst
</span><span>- Downloaded C:\Users\s\AppData\Local\opam\.cygwin\cache/https%3a%2f%2fcygwin.mirror.constant.com%2f/x86_64/release/pkgconf/pkgconf-2.4.3-1.tar.zst
</span><span>- Extracting from file://C:\Users\s\AppData\Local\opam\.cygwin\cache/https%3a%2f%2fcygwin.mirror.constant.com%2f/x86_64/release/pkgconf/libpkgconf6/libpkgconf6-2.4.3-1.tar.zst
</span><span>- Extracting from file://C:\Users\s\AppData\Local\opam\.cygwin\cache/https%3a%2f%2fcygwin.mirror.constant.com%2f/x86_64/release/pkgconf/pkgconf-2.4.3-1.tar.zst
</span><span>- running: C:\Users\s\AppData\Local\opam\.cygwin\root\bin\dash.exe "/etc/postinstall/0p_000_autorebase.dash"
</span><span>- running: C:\Users\s\AppData\Local\opam\.cygwin\root\bin\dash.exe "/etc/postinstall/0p_update-info-dir.dash"
</span><span>- running: C:\Users\s\AppData\Local\opam\.cygwin\root\bin\dash.exe "/etc/postinstall/zp_man-db-update-index.dash"
</span><span>- Ending cygwin install
</span><span>
</span><span>&lt;&gt;&lt;&gt; Processing actions &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;  🐫
</span><span>⬇ retrieved mingw-w64-shims.0.2.0  (cached)
</span><span>⊘ removed   mingw-w64-shims.0.2.0
</span><span>∗ installed conf-pkg-config.4
</span><span>
</span><span>#=== ERROR while compiling conf-portaudio.1 ===================================#
</span><span>"pkg-config": command not found.
</span><span>
</span><span>
</span><span>&lt;&gt;&lt;&gt; Error report &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;  🐫
</span><span>┌─ The following actions failed
</span><span>│ λ build conf-portaudio 1
</span><span>└─
</span><span>┌─ The following changes have been performed (the rest was aborted)
</span><span>│ ⊘ remove  mingw-w64-shims 0.2.0
</span><span>│ ∗ install conf-pkg-config 4
</span><span>└─
</span></code></pre>
<p>A few things have gone wrong here. Firstly, from:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>The following system packages will first need to be installed:
</span><span>    pkgconf
</span></code></pre>
<p>…we can see that Opam has detected that some <code>depexts</code> need to be installed, but
only <code>pkgconf</code> and not <code>portaudio</code> are on the list. To help understand why, look
at the <code>depexts</code> of the <code>conf-pkg-config</code> package:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s&gt; opam show conf-pkg-config
</span><span>...
</span><span>depexts     ["pkg-config"] {os-family = "debian" | os-family = "ubuntu"}
</span><span>...
</span><span>            ["system:pkgconf"] {os = "win32" &amp; os-distribution = "cygwinports"}
</span><span>            ["pkgconf"] {os-distribution = "cygwin"}
</span><span>
</span></code></pre>
<p>This package makes an explicit distinction between “cygwinports” and “cygwin” so
it stands to reason that my initial concerns about <code>os-distribution = "cygwinports"</code> were merited.</p>
<p>The second issue is that even though Opam installed <code>pkgconf</code> with Cygwin, the
<code>pkg-config</code> executable couldn’t be found while installing the <code>conf-portaudio</code>
package. Remember earlier we located the Cygwin installation that Opam will be
managing? Looking in <code>C:\Users\s\AppData\Local\opam\.cygwin\root\bin</code>, there
is a program <code>pkgconf.exe</code>, but not a <code>pkg-config.exe</code>. At some
point in the past few years <code>pkg-config</code> was renamed to <code>pkgconf</code> and this change is slowly trickling
into different package managers at different rates.</p>
<p>The first thing to try here is modifying the package metadata for
<code>conf-portaudio</code> to use the correct name for <code>pkgconf</code>. Start by saving the
existing metadata to a local file which we can then modify:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s&gt; opam show conf-portaudio --raw &gt; conf-portaudio.opam
</span></code></pre>
<p>We should now be able to install the <code>conf-portaudio</code> package from this file
rather than using the metadata stored in the Opam repo by running:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s&gt; opam install .\conf-portaudio.opam
</span></code></pre>
<p>This command hung with <code>Processing 1/1: [conf-portaudio.1: rsync]</code> so I left it
running while I went to run some errands and when I got back over an hour later
it was still hung.</p>
<p>I cancelled the hung operation. Despite not completing it did have the side
effect of creating an Opam “pin” for the <code>conf-portaudio</code> package.
An Opam pin is a configuration to override the source of a package, usually to
allow for local development of said package. We can see all the current Opam
pins with:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s&gt; opam pin list
</span><span>conf-portaudio.1  (uninstalled)  rsync  file://C:/Users/s
</span></code></pre>
<p>Before proceeding I wanted to remove the pin since something has clearly gone wrong:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s&gt; opam pin remove conf-portaudio
</span><span>Cannot remove C:\Users\s\AppData\Local\opam\default\.opam-switch\sources\conf-portaudio\
</span><span>AppData\Local\Application Data\Application Data\Application Data\Application Data\
</span><span>Application Data\Application Data\Application Data\Application Data\Application Data\
</span><span>Temporary Internet Files (C:\Users\s\AppData\Local\Microsoft\WinGet\Packages\
</span><span>OCaml.opam_Microsoft.Winget.Source_8wekyb3d8bbwe\opam.exe: "unlink" failed on
</span><span>C:\Users\s\AppData\Local\opam\default\.opam-switch\sources\conf-portaudio\AppData\
</span><span>Local\Application Data\Application Data\Application Data\Application Data\
</span><span>Application Data\Application Data\Application Data\Application Data\Application Data\
</span><span>Temporary Internet Files: No such file or directory).
</span></code></pre>
<p>Hmm. The <code>Application Data\Application Data\Application Data</code> component of the path looks suspicious.
Opam creates a copy of pinned packages so let’s take a look at <code>conf-portaudio</code>’s
copy in
<code>C:\Users\s\AppData\Local\opam\default\.opam-switch\sources\conf-portaudio</code>:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s&gt; ls .\AppData\Local\opam\default\.opam-switch\sources\conf-portaudio\
</span><span>
</span><span>    Directory: C:\Users\s\AppData\Local\opam\default\.opam-switch\sources\conf-portaudio
</span><span>
</span><span>Mode                 LastWriteTime         Length Name
</span><span>----                 -------------         ------ ----
</span><span>d----          04/11/2024    21:49                .bin
</span><span>d----          04/11/2024    22:26                .cargo
</span><span>d----          04/11/2024    21:49                .completions
</span><span>d----          04/11/2024    21:49                .config
</span><span>d----          22/11/2024    14:34                .dotfiles
</span><span>d----          04/11/2024    21:49                .emacs.d
</span><span>d----          25/11/2024    15:12                .local
</span><span>d----          04/11/2024    21:59                .ms-ad
</span><span>d----          04/11/2024    22:25                .rustup
</span><span>d----          04/11/2024    21:29                .ssh
</span><span>d----          18/11/2024    14:35                .vscode
</span><span>d----          29/05/2025    16:03                AppData
</span><span>-a---          28/03/2025    17:00           3654 .bash_history
</span><span>-a---          25/11/2024    18:07           9168 .bashrc
</span><span>...
</span></code></pre>
<p>Hey, that looks like my home directory! It appears I unwittingly pinned the
<code>conf-portaudio</code> package to my entire home directory, and since Opam installs
packages <em>inside</em> my home directory it was recurring forever, continuously
copying my home directory inside itself. No wonder it hung.</p>
<p>Manually fixing the problem:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s&gt; rm .\AppData\Local\opam\default\.opam-switch\sources\conf-portaudio
</span><span>
</span><span>Confirm
</span><span>The item at C:\Users\s\AppData\Local\opam\default\.opam-switch\sources\conf-portaudio has children and the Recurse parameter was not specified. If you continue, all children will be removed with the item. Are you sure you want to continue?
</span><span>[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): A
</span><span>Removed 32536 of 134845 files [1.197 GB of 15.926 GB (48.6 MB/s)
</span></code></pre>
<p>That’s almost <code>16GB</code> of recursive copies of my home directory! This command
ended up failing due to permission problems so I had to delete it from the
explorer UI instead as I’m not very familiar with file management within
PowerShell.</p>
<p>Now that I manually deleted that folder, removing the pin works:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s&gt; opam pin remove conf-portaudio
</span><span>Ok, conf-portaudio is no longer pinned to file://C:/Users/s (version 1)
</span></code></pre>
<p>What I’ve learnt here is that Opam doesn’t pin individual files but rather
entire directories. A pin is a mapping from package to directory, and when you
run <code>opam pin .\foo.opam</code> Opam learns the package name is <code>foo</code> from the name of
the file (I think), but assumes the directory is the directory containing
<code>foo.opam</code>. Most Opam package source directories contain an opam file and the
source code for the package. What’s unusual in this case is that the
<code>conf-portaudio</code> package does not have source code. We say it’s a “metapackage”
as installing it just installs its dependencies (including external
dependencies) and runs a command to verify their installation, but it has no
source code of its own. So in order to pin <code>conf-portaudio</code> we need to first
create a new directory and move the opam file there.</p>
<p>Pinning the directory is sufficient as Opam will scan the directory for any opam files
and create pins for each corresponding package using the current directory as the source.
I’ve also modified the opam file to run <code>pkgconf</code> rather than <code>pkg-config</code>.</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s\conf-portaudio&gt; opam pin .
</span><span>[NOTE] Package conf-portaudio is already pinned to file://C:/Users/s/conf-portaudio (version 1).
</span><span>conf-portaudio is now pinned to file://C:/Users/s/conf-portaudio (version 1)
</span><span>
</span><span>The following actions will be performed:
</span><span>=== install 1 package
</span><span>  ∗ conf-portaudio 1 (pinned)
</span><span>
</span><span>Proceed with ∗ 1 installation? [y/n] n   (don't want to install it just yet)
</span><span>[NOTE] Pinning command successful, but your installed packages may be out of sync.
</span></code></pre>
<p>By default <code>opam pin</code> will prompt to install the pinned package in addition to just storing
the package → directory mapping, but I just want to create the mapping for now so I
chose <code>n</code> at the prompt. Before installing the package I want to make sure that
pinning it had the desired effect. Ask Opam what it thinks should be the package metadata
for <code>conf-portaudio</code> now:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s\conf-portaudio&gt; opam show conf-portaudio --raw
</span><span>opam-version: "2.0"
</span><span>name: "conf-portaudio"
</span><span>version: "1"
</span><span>synopsis: "Virtual package relying on portaudio"
</span><span>description:
</span><span>  "This package can only install if the portaudio library is installed on the system."
</span><span>maintainer: "https://github.com/ocaml/opam-repository/issues"
</span><span>authors: "portaudio dev team"
</span><span>license: "BSD-1-Clause"
</span><span>homepage: "http://www.portaudio.com/"
</span><span>bug-reports: "https://github.com/ocaml/opam-repository/issues"
</span><span>depends: [
</span><span>  "conf-pkg-config" {build}
</span><span>]
</span><span>flags: conf
</span><span>build: ["pkgconf" "--exists" "portaudio-2.0"]
</span><span>depexts: [
</span><span>  ["portaudio-dev"] {os-distribution = "alpine"}
</span><span>  ["portaudio-devel"]
</span><span>    {os-distribution = "centos" | os-family = "fedora" | os-family = "suse" |
</span><span>     os-family = "opensuse"}
</span><span>  ["portaudio"] {os = "macos" &amp; os-distribution = "homebrew"}
</span><span>  ["portaudio"]
</span><span>    {os = "freebsd" | os-family = "arch" | os-distribution = "nixos" |
</span><span>     os-distribution = "ol"}
</span><span>  ["portaudio"] {os = "win32" &amp; os-distribution = "cygwinports"}
</span><span>  ["portaudio19-dev"] {os-family = "debian" | os-family = "ubuntu"}
</span><span>]
</span><span>url {
</span><span>  src: "file://C:/Users/s/conf-portaudio"
</span><span>}
</span></code></pre>
<p>Note that the <code>build</code> command calls <code>pkgconf</code> rather than <code>pkg-config</code> as it did
previously, indicating that my custom version of <code>conf-portaudio</code> is being used.</p>
<p>Now we can try installing it again.</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s\conf-portaudio&gt; opam install conf-portaudio
</span><span>
</span><span>&lt;&gt;&lt;&gt; Synchronising pinned packages &gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;  🐫
</span><span>[conf-portaudio.1] synchronised (no changes)
</span><span>
</span><span>The following actions will be performed:
</span><span>=== install 1 package
</span><span>  ∗ conf-portaudio 1 (pinned)
</span><span>
</span><span>&lt;&gt;&lt;&gt; Processing actions &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;  🐫
</span><span>[ERROR] The compilation of conf-portaudio.1 failed at "pkgconf --exists portaudio-2.0".
</span><span>
</span><span>#=== ERROR while compiling conf-portaudio.1 ===================================#
</span><span># context     2.3.0 | win32/x86_64 | ocaml.5.3.0 | pinned(file://C:/Users/s/conf-portaudio)
</span><span># path        ~\AppData\Local\opam\default\.opam-switch\build\conf-portaudio.1
</span><span># command     ~\AppData\Local\opam\.cygwin\root\bin\pkgconf.exe --exists portaudio-2.0
</span><span># exit-code   1
</span><span># env-file    ~\AppData\Local\opam\log\conf-portaudio-12212-533065.env
</span><span># output-file ~\AppData\Local\opam\log\conf-portaudio-12212-533065.out
</span><span>
</span><span>
</span><span>
</span><span>&lt;&gt;&lt;&gt; Error report &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;  🐫
</span><span>┌─ The following actions failed
</span><span>│ λ build conf-portaudio 1
</span><span>└─
</span><span>╶─ No changes have been performed
</span></code></pre>
<p>That’s progress! There’s now an error message indicating that <code>pkgconf --exists portaudio-2.0</code> failed, which is expected because the <code>conf-portaudio</code> package’s
<code>depexts</code> don’t contain a case for <code>os-distribution = "cygwin"</code> (only <code>os-distribution = "cygwinports"</code>).</p>
<p>Next step is to fix the <code>conf-portaudio</code> <code>depexts</code> so they install the appropriate
package on Cygwin. I added this line to the <code>depexts</code> section in <code>conf-portaudio.opam</code>:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>    ["portaudio"] {os = "win32" &amp; os-distribution = "cygwin"}
</span></code></pre>
<p>I needed to run <code>opam pin .</code> again to get Opam to update its copy of the custom
version of this package’s metadata. Every time you change the opam file of a
pinned package you have to re-pin the package for the change to be come visible
to Opam.</p>
<p>Then I tried installing <code>conf-portaudio</code> again:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s\conf-portaudio&gt; opam install conf-portaudio
</span><span>
</span><span>&lt;&gt;&lt;&gt; Synchronising pinned packages &gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;  🐫
</span><span>[conf-portaudio.1] synchronised (no changes)
</span><span>
</span><span>The following actions will be performed:
</span><span>=== install 1 package
</span><span>  ∗ conf-portaudio 1 (pinned)
</span><span>
</span><span>The following system packages will first need to be installed:
</span><span>    portaudio
</span><span>
</span><span>&lt;&gt;&lt;&gt; Handling external dependencies &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;  🐫
</span><span>
</span><span>+ C:\Users\s\AppData\Local\opam\.cygwin\setup-x86_64.exe "--root" "C:\\Users\\s\\AppData\\Local\\opam\\.cygwin\\root" "--quiet-mode" "noinput" "--no-shortcuts" "--no-startmenu" "--no-desktop" "--no-admin" "--no-version-check" "--no-write-registry" "--packages" "portaudio" "--upgrade-also" "--only-site" "--site" "https://cygwin.mirror.constant.com/" "--local-package-dir" "C:\\Users\\s\\AppData\\Local\\opam\\.cygwin\\cache"
</span><span>- Starting cygwin install, version 2.934
</span><span>- User has NO backup/restore rights
</span><span>- User has NO symlink creation right
</span><span>- io_stream_cygfile: fopen(/etc/setup/setup.rc) failed 2 No such file or directory
</span><span>- Current Directory: C:\Users\s\AppData\Local\opam\.cygwin\cache
</span><span>- root: C:\Users\s\AppData\Local\opam\.cygwin\root user
</span><span>- Changing gid back to original
</span><span>- Selected local directory: C:\Users\s\AppData\Local\opam\.cygwin\cache
</span><span>- net: Preconfig
</span><span>- site: https://cygwin.mirror.constant.com/
</span><span>- Package 'portaudio' not found.
</span><span>- solving: 0 tasks, update: yes, use test packages: no
</span><span>- solving: 0 tasks, update: no, use test packages: no
</span><span>- Augmented Transaction List: is empty
</span><span>- running: C:\Users\s\AppData\Local\opam\.cygwin\root\bin\dash.exe "/etc/postinstall/0p_000_autorebase.dash"
</span><span>- running: C:\Users\s\AppData\Local\opam\.cygwin\root\bin\dash.exe "/etc/postinstall/0p_update-info-dir.dash"
</span><span>- running: C:\Users\s\AppData\Local\opam\.cygwin\root\bin\dash.exe "/etc/postinstall/zp_man-db-update-index.dash"
</span><span>- Ending cygwin install
</span><span>
</span><span>&lt;&gt;&lt;&gt; Processing actions &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;  🐫
</span><span>[ERROR] The compilation of conf-portaudio.1 failed at "pkgconf --exists portaudio-2.0".
</span><span>
</span><span>#=== ERROR while compiling conf-portaudio.1 ===================================#
</span><span># context     2.3.0 | win32/x86_64 | ocaml.5.3.0 | pinned(file://C:/Users/s/conf-portaudio)
</span><span># path        ~\AppData\Local\opam\default\.opam-switch\build\conf-portaudio.1
</span><span># command     ~\AppData\Local\opam\.cygwin\root\bin\pkgconf.exe --exists portaudio-2.0
</span><span># exit-code   1
</span><span># env-file    ~\AppData\Local\opam\log\conf-portaudio-9396-6b5019.env
</span><span># output-file ~\AppData\Local\opam\log\conf-portaudio-9396-6b5019.out
</span><span>
</span><span>
</span><span>
</span><span>&lt;&gt;&lt;&gt; Error report &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;  🐫
</span><span>┌─ The following actions failed
</span><span>│ λ build conf-portaudio 1
</span><span>└─
</span><span>╶─ No changes have been performed
</span></code></pre>
<p>This time Opam tried to install the <code>portaudio</code> Cygwin package, however <code>Package 'portaudio' not found.</code> tells us that there is no such Cygwin package.</p>
<p>However digging around in the Cygwin package repo I did come across a package
named <code>mingw64-x86_64-portaudio</code>, though it’s unmaintained and hasn’t been
updated since 2018. I <em>also</em> happened to find the package
<code>mingw64-x86_64-libao</code>, also unmaintained and not updated since 2013, however if
this package works then I might be able to use <code>llama</code> on Windows unmodified,
since it’s currently based on libao.</p>
<p>Repeating the steps above to create a custom version of the <code>conf-ao</code> package -
Opam’s meta package for installing the system-appropriate libao package:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s\conf-ao&gt; opam show conf-ao --raw &gt; conf-ao.opam
</span><span>PS C:\Users\s\conf-ao&gt; opam pin .
</span><span>conf-ao is now pinned to file://C:/Users/s/conf-ao (version 1)
</span><span>
</span><span>The following actions will be performed:
</span><span>=== install 1 package
</span><span>  ∗ conf-ao 1 (pinned)
</span><span>
</span><span>Proceed with ∗ 1 installation? [y/n] n
</span><span>[NOTE] Pinning command successful, but your installed packages may be out of sync.
</span></code></pre>
<p>Then I modified <code>conf-ao.opam</code>, adding the following to its <code>depexts</code>:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>  ["mingw64-x86_64-libao"] {os = "win32" &amp; os-distribution = "cygwin"}
</span></code></pre>
<p>…and changed its build command to test for the system libao package using
<code>pkgconf</code> instead of <code>pkg-config</code>, the same as what I did for <code>conf-portaudio</code>.</p>
<p>Moment of truth:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s\conf-ao&gt; opam install conf-ao
</span><span>
</span><span>&lt;&gt;&lt;&gt; Synchronising pinned packages &gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;  🐫
</span><span>[conf-ao.1] synchronised (no changes)
</span><span>
</span><span>The following actions will be performed:
</span><span>=== install 1 package
</span><span>  ∗ conf-ao 1 (pinned)
</span><span>
</span><span>The following system packages will first need to be installed:
</span><span>    mingw64-x86_64-libao
</span><span>
</span><span>&lt;&gt;&lt;&gt; Handling external dependencies &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;  🐫
</span><span>
</span><span>+ C:\Users\s\AppData\Local\opam\.cygwin\setup-x86_64.exe "--root" "C:\\Users\\s\\AppData\\Local\\opam\\.cygwin\\root" "--quiet-mode" "noinput" "--no-shortcuts" "--no-startmenu" "--no-desktop" "--no-admin" "--no-version-check" "--no-write-registry" "--packages" "mingw64-x86_64-libao" "--upgrade-also" "--only-site" "--site" "https://cygwin.mirror.constant.com/" "--local-package-dir" "C:\\Users\\s\\AppData\\Local\\opam\\.cygwin\\cache"
</span><span>- Starting cygwin install, version 2.934
</span><span>- User has NO backup/restore rights
</span><span>- User has NO symlink creation right
</span><span>- Current Directory: C:\Users\s\AppData\Local\opam\.cygwin\cache
</span><span>- root: C:\Users\s\AppData\Local\opam\.cygwin\root user
</span><span>- Changing gid back to original
</span><span>- Selected local directory: C:\Users\s\AppData\Local\opam\.cygwin\cache
</span><span>- net: Preconfig
</span><span>- site: https://cygwin.mirror.constant.com/
</span><span>- solving: 1 tasks, update: yes, use test packages: no
</span><span>- solving: 1 tasks, update: no, use test packages: no
</span><span>- Augmented Transaction List:
</span><span>-    0 install mingw64-x86_64-libao 1.1.0-1
</span><span>- Downloaded C:\Users\s\AppData\Local\opam\.cygwin\cache/https%3a%2f%2fcygwin.mirror.constant.com%2f/noarch/release/mingw64-x86_64-libao/mingw64-x86_64-libao-1.1.0-1.tar.xz
</span><span>- Extracting from file://C:\Users\s\AppData\Local\opam\.cygwin\cache/https%3a%2f%2fcygwin.mirror.constant.com%2f/noarch/release/mingw64-x86_64-libao/mingw64-x86_64-libao-1.1.0-1.tar.xz
</span><span>- running: C:\Users\s\AppData\Local\opam\.cygwin\root\bin\dash.exe "/etc/postinstall/0p_000_autorebase.dash"
</span><span>- running: C:\Users\s\AppData\Local\opam\.cygwin\root\bin\dash.exe "/etc/postinstall/0p_update-info-dir.dash"
</span><span>- running: C:\Users\s\AppData\Local\opam\.cygwin\root\bin\dash.exe "/etc/postinstall/zp_man-db-update-index.dash"
</span><span>- Ending cygwin install
</span><span>
</span><span>&lt;&gt;&lt;&gt; Processing actions &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;  🐫
</span><span>[ERROR] The compilation of conf-ao.1 failed at "pkgconf --exists ao".
</span><span>
</span><span>#=== ERROR while compiling conf-ao.1 ==========================================#
</span><span># context     2.3.0 | win32/x86_64 | ocaml.5.3.0 | pinned(file://C:/Users/s/conf-ao)
</span><span># path        ~\AppData\Local\opam\default\.opam-switch\build\conf-ao.1
</span><span># command     ~\AppData\Local\opam\.cygwin\root\bin\pkgconf.exe --exists ao
</span><span># exit-code   1
</span><span># env-file    ~\AppData\Local\opam\log\conf-ao-8080-676a1b.env
</span><span># output-file ~\AppData\Local\opam\log\conf-ao-8080-676a1b.out
</span><span>
</span><span>
</span><span>
</span><span>&lt;&gt;&lt;&gt; Error report &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;  🐫
</span><span>┌─ The following actions failed
</span><span>│ λ build conf-ao 1
</span><span>└─
</span><span>╶─ No changes have been performed
</span></code></pre>
<p>Ok so it found the <code>mingw64-x86_64-libao</code> package in the Cygwin repo but it
looks like <code>pkgconf</code> can’t see it.</p>
<p>Manually inspecting the Cygwin directory, and I do see that libao has been
installed:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s\conf-ao&gt; ls C:\Users\s\AppData\Local\opam\.cygwin\root\usr\x86_64-w64-mingw32\sys-root\mingw\lib\libao.*
</span><span>
</span><span>    Directory: C:\Users\s\AppData\Local\opam\.cygwin\root\usr\x86_64-w64-mingw32\sys-root\mingw\lib
</span><span>
</span><span>Mode                 LastWriteTime         Length Name
</span><span>----                 -------------         ------ ----
</span><span>-a---          02/12/2013    15:27          50102 libao.a
</span><span>-a---          02/12/2013    15:27           9386 libao.dll.a
</span></code></pre>
<p>But that’s doesn’t look like a standard path for libraries.
Reading more about the <code>mingw64-x86_64-*</code> packages in the Cygwin repo and it
doesn’t look like I’ll easily be able to mix them with other Cygwin packages,
which could make it tricky to proceed with Opam in its current configuration
where it manages a Cygwin environment for us.</p>
<p>An alternative package manager for Windows is “Msys2”. During <code>opam init</code> you
can select Msys2 as an alternative to Cygwin, though there’s no option for Opam
to install the Msys2 environment for us. There appears to be a <code>libao</code> package in
the Msys2 repository, so the next step will be to try setting up an Msys2
environment and a new Opam installation which uses it and then install the
<code>conf-ao</code> package along with its <code>depexts</code> within that environment.</p>
<h2><a href="https://www.gridbugs.org/rss.xml#trying-again-with-msys2" class="zola-anchor" aria-label="Anchor link for: trying-again-with-msys2">Trying again with Msys2</a></h2>
<p>Firstly I deleted <code>C:\Users\s\AppData\Local\opam</code> to get a fresh start.</p>
<p>I installed Msys2 from the installer at <a href="https://www.msys2.org/">its website</a>,
which created a directory <code>C:\msys64</code> which will be the root directory of our
Msys2 environment.</p>
<p>Then I reran <code>opam init</code> to create a new Opam environment, this time selecting
the second option for obtaining Unix tools: <code>Use an existing Cygwin/MSYS2 installation</code>. I’ll post the entire output of the interactive session with <code>opam init</code> in case it helps someone set up Opam on their machine:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s&gt; opam init
</span><span>No configuration file found, using built-in defaults.
</span><span>
</span><span>&lt;&gt;&lt;&gt; Windows Developer Mode &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;  🐫
</span><span>opam does not require Developer Mode to be enabled on Windows, but it is
</span><span>recommended, in particular because it enables support for symlinks without
</span><span>requiring opam to be run elevated (which we do not recommend doing).
</span><span>
</span><span>More information on enabling Developer Mode may be obtained from
</span><span>https://learn.microsoft.com/en-gb/windows/apps/get-started/enable-your-device-for-development
</span><span>
</span><span>&lt;&gt;&lt;&gt; Unix support infrastructure &gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;  🐫
</span><span>
</span><span>opam and the OCaml ecosystem in general require various Unix tools in order to operate correctly. At present, this requires the installation of Cygwin to provide these tools.
</span><span>
</span><span>How should opam obtain Unix tools?
</span><span>&gt; 1. Automatically create an internal Cygwin installation that will be managed by opam (recommended)
</span><span>  2. Use an existing Cygwin/MSYS2 installation
</span><span>  3. Abort initialisation
</span><span>
</span><span>[1/2/3] 2
</span><span>Enter the prefix of an existing Cygwin installation (e.g. C:\cygwin64) C:\msys64
</span><span>
</span><span>The following system packages will first need to be installed:
</span><span>    diffutils make patch rsync unzip
</span><span>
</span><span>&lt;&gt;&lt;&gt; Handling external dependencies &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;  🐫
</span><span>
</span><span>opam believes some required external dependencies are missing. opam can:
</span><span>&gt; 1. Run C:\msys64\usr\bin\pacman.exe to install them (may need root/sudo access)
</span><span>  2. Display the recommended C:\msys64\usr\bin\pacman.exe command and wait while you run it manually (e.g. in another terminal)
</span><span>  3. Continue anyway, and, upon success, permanently register that this external dependency is present, but not detectable
</span><span>  4. Abort the installation
</span><span>
</span><span>[1/2/3/4] 1
</span><span>
</span><span>+ C:\msys64\usr\bin\pacman.exe "-Su" "--noconfirm" "diffutils" "make" "patch" "rsync" "unzip"
</span><span>- :: Starting core system upgrade...
</span><span>-  there is nothing to do
</span><span>- :: Starting full system upgrade...
</span><span>- resolving dependencies...
</span><span>- looking for conflicting packages...
</span><span>-
</span><span>- Packages (6) libxxhash-0.8.3-1  diffutils-3.10-1  make-4.4.1-2  patch-2.7.6-3  rsync-3.4.1-1  unzip-6.0-3
</span><span>-
</span><span>- Total Download Size:   1.43 MiB
</span><span>- Total Installed Size:  4.51 MiB
</span><span>-
</span><span>- :: Proceed with installation? [Y/n]
</span><span>- :: Retrieving packages...
</span><span>-  make-4.4.1-2-x86_64 downloading...
</span><span>-  diffutils-3.10-1-x86_64 downloading...
</span><span>-  rsync-3.4.1-1-x86_64 downloading...
</span><span>-  unzip-6.0-3-x86_64 downloading...
</span><span>-  patch-2.7.6-3-x86_64 downloading...
</span><span>-  libxxhash-0.8.3-1-x86_64 downloading...
</span><span>- checking keyring...
</span><span>- checking package integrity...
</span><span>- loading package files...
</span><span>- checking for file conflicts...
</span><span>- checking available disk space...
</span><span>- :: Processing package changes...
</span><span>- installing diffutils...
</span><span>- installing make...
</span><span>- installing patch...
</span><span>- Optional dependencies for patch
</span><span>-     ed: for patch -e functionality
</span><span>- installing libxxhash...
</span><span>- installing rsync...
</span><span>- installing unzip...
</span><span>- :: Running post-transaction hooks...
</span><span>- (1/1) Updating the info directory file...
</span><span>Checking for available remotes: rsync and local, git.
</span><span>  - you won't be able to use mercurial repositories unless you install the hg command on your system.
</span><span>  - you won't be able to use darcs repositories unless you install the darcs command on your system.
</span><span>
</span><span>
</span><span>&lt;&gt;&lt;&gt; Fetching repository information &gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;  🐫
</span><span>[default] Initialised
</span><span>
</span><span>&lt;&gt;&lt;&gt; Required setup - please read &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;  🐫
</span><span>
</span><span>  In normal operation, opam only alters files within ~\AppData\Local\opam.
</span><span>
</span><span>  However, to best integrate with your system, some environment variables
</span><span>  should be set. When you want to access your opam installation, you will
</span><span>  need to run:
</span><span>
</span><span>    (&amp; opam env) -split '\r?\n' | ForEach-Object { Invoke-Expression $_ }
</span><span>
</span><span>  You can always re-run this setup with 'opam init' later.
</span><span>
</span><span>opam doesn't have any configuration options for pwsh; you will have to run (&amp; opam env) -split '\r?\n' | ForEach-Object { Invoke-Expression $_ } whenever you change you current 'opam switch' or start a new terminal session. Alternatively, would you like to
</span><span>select a different shell? [y/n] n
</span><span>
</span><span>&lt;&gt;&lt;&gt; Creating initial switch 'default' (invariant ["ocaml" {&gt;= "4.05.0"}] - initially with ocaml-base-compiler)
</span><span>
</span><span>&lt;&gt;&lt;&gt; Installing new switch packages &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;  🐫
</span><span>Switch invariant: ["ocaml" {&gt;= "4.05.0"}]
</span><span>
</span><span>The following system packages will first need to be installed:
</span><span>    mingw-w64-x86_64-gcc
</span><span>
</span><span>&lt;&gt;&lt;&gt; Handling external dependencies &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;  🐫
</span><span>
</span><span>opam believes some required external dependencies are missing. opam can:
</span><span>&gt; 1. Run C:\msys64\usr\bin\pacman.exe to install them (may need root/sudo access)
</span><span>  2. Display the recommended C:\msys64\usr\bin\pacman.exe command and wait while you run it manually (e.g. in another terminal)
</span><span>  3. Continue anyway, and, upon success, permanently register that this external dependency is present, but not detectable
</span><span>  4. Abort the installation
</span><span>
</span><span>[1/2/3/4] 1
</span><span>
</span><span>+ C:\msys64\usr\bin\pacman.exe "-Su" "--noconfirm" "mingw-w64-x86_64-gcc"
</span><span>- :: Starting core system upgrade...
</span><span>-  there is nothing to do
</span><span>- :: Starting full system upgrade...
</span><span>- resolving dependencies...
</span><span>- looking for conflicting packages...
</span><span>-
</span><span>- Packages (16) mingw-w64-x86_64-binutils-2.44-1  mingw-w64-x86_64-crt-git-12.0.0.r509.g079e6092b-1  mingw-w64-x86_64-gcc-libs-14.2.0-2  mingw-w64-x86_64-gettext-runtime-0.23.1-1  mingw-w64-x86_64-gmp-6.3.0-2  mingw-w64-x86_64-headers-git-12.0.0.r509.g079e6092b-1  mingw-w64-x86_64-isl-0.27-1  mingw-w64-x86_64-libiconv-1.18-1  mingw-w64-x86_64-libwinpthread-git-12.0.0.r509.g079e6092b-1  mingw-w64-x86_64-mpc-1.3.1-2  mingw-w64-x86_64-mpfr-4.2.1-2  mingw-w64-x86_64-windows-default-manifest-6.4-4  mingw-w64-x86_64-winpthreads-git-12.0.0.r509.g079e6092b-1  mingw-w64-x86_64-zlib-1.3.1-1  mingw-w64-x86_64-zstd-1.5.7-1  mingw-w64-x86_64-gcc-14.2.0-2
</span><span>-
</span><span>- Total Download Size:    65.78 MiB
</span><span>- Total Installed Size:  518.69 MiB
</span><span>-
</span><span>- :: Proceed with installation? [Y/n]
</span><span>- :: Retrieving packages...
</span><span>-  mingw-w64-x86_64-gcc-14.2.0-2-any downloading...
</span><span>-  mingw-w64-x86_64-headers-git-12.0.0.r509.g079e6092b-1-any downloading...
</span><span>-  mingw-w64-x86_64-binutils-2.44-1-any downloading...
</span><span>-  mingw-w64-x86_64-crt-git-12.0.0.r509.g079e6092b-1-any downloading...
</span><span>-  mingw-w64-x86_64-isl-0.27-1-any downloading...
</span><span>-  mingw-w64-x86_64-gcc-libs-14.2.0-2-any downloading...
</span><span>-  mingw-w64-x86_64-libiconv-1.18-1-any downloading...
</span><span>-  mingw-w64-x86_64-zstd-1.5.7-1-any downloading...
</span><span>-  mingw-w64-x86_64-gmp-6.3.0-2-any downloading...
</span><span>-  mingw-w64-x86_64-mpfr-4.2.1-2-any downloading...
</span><span>-  mingw-w64-x86_64-gettext-runtime-0.23.1-1-any downloading...
</span><span>-  mingw-w64-x86_64-mpc-1.3.1-2-any downloading...
</span><span>-  mingw-w64-x86_64-zlib-1.3.1-1-any downloading...
</span><span>-  mingw-w64-x86_64-winpthreads-git-12.0.0.r509.g079e6092b-1-any downloading...
</span><span>-  mingw-w64-x86_64-libwinpthread-git-12.0.0.r509.g079e6092b-1-any downloading...
</span><span>-  mingw-w64-x86_64-windows-default-manifest-6.4-4-any downloading...
</span><span>- checking keyring...
</span><span>- checking package integrity...
</span><span>- loading package files...
</span><span>- checking for file conflicts...
</span><span>- checking available disk space...
</span><span>- :: Processing package changes...
</span><span>- installing mingw-w64-x86_64-libwinpthread-git...
</span><span>- installing mingw-w64-x86_64-gcc-libs...
</span><span>- installing mingw-w64-x86_64-libiconv...
</span><span>- installing mingw-w64-x86_64-gettext-runtime...
</span><span>- installing mingw-w64-x86_64-zlib...
</span><span>- installing mingw-w64-x86_64-zstd...
</span><span>- installing mingw-w64-x86_64-binutils...
</span><span>- installing mingw-w64-x86_64-headers-git...
</span><span>- installing mingw-w64-x86_64-crt-git...
</span><span>- installing mingw-w64-x86_64-gmp...
</span><span>- installing mingw-w64-x86_64-isl...
</span><span>- installing mingw-w64-x86_64-mpfr...
</span><span>- installing mingw-w64-x86_64-mpc...
</span><span>- installing mingw-w64-x86_64-windows-default-manifest...
</span><span>- installing mingw-w64-x86_64-winpthreads-git...
</span><span>- installing mingw-w64-x86_64-gcc...
</span><span>
</span><span>&lt;&gt;&lt;&gt; Processing actions &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;  🐫
</span><span>∗ installed arch-x86_64.1
</span><span>∗ installed base-bigarray.base
</span><span>∗ installed base-threads.base
</span><span>∗ installed base-unix.base
</span><span>∗ installed host-arch-x86_64.1
</span><span>∗ installed host-system-mingw.1
</span><span>∗ installed msys2-mingw64.1
</span><span>⬇ retrieved msys2.0.1.0  (https://opam.ocaml.org/cache)
</span><span>∗ installed msys2.0.1.0
</span><span>∗ installed conf-mingw-w64-gcc-x86_64.1
</span><span>⬇ retrieved flexdll.0.44  (https://opam.ocaml.org/cache)
</span><span>∗ installed flexdll.0.44
</span><span>∗ installed ocaml-env-mingw64.1
</span><span>∗ installed ocaml-options-vanilla.1
</span><span>∗ installed system-mingw.1
</span><span>⬇ retrieved ocaml-config.3  (2 extra sources)
</span><span>⬇ retrieved ocaml-config.3  (2 extra sources)
</span><span>⬇ retrieved ocaml-compiler.5.3.0  (https://opam.ocaml.org/cache)
</span><span>∗ installed ocaml-compiler.5.3.0
</span><span>∗ installed ocaml-base-compiler.5.3.0
</span><span>∗ installed ocaml-config.3
</span><span>∗ installed ocaml.5.3.0
</span><span>∗ installed base-domains.base
</span><span>∗ installed base-effects.base
</span><span>∗ installed base-nnp.base
</span><span>Done.
</span><span># To update the current shell environment, run: (&amp; opam env --switch=default) -split '\r?\n' | ForEach-Object { Invoke-Expression $_ }
</span></code></pre>
<p>During initialization, Opam took care of installing a C compiler and various
other essential tools into the Msys2 environment at <code>C:\msys64</code>.</p>
<p>My next goal is to get Opam to install libao with Msys2. I’m not sure what the
correct <code>depexts</code> entry should be for this, so I’ll start with <code>["libao"] {os = "win32" &amp; os-distribution = "cygwin"}</code>. I updated my custom copy of the
<code>conf-ao</code> package and pinned the package with Opam:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s\conf-ao&gt; opam pin .\conf-ao.opam
</span><span>Fatal error:
</span><span>"rsync": command not found.
</span></code></pre>
<p>I guess I need to manually install <code>rsync</code> into my Msys2 environment? To do
this, launch an Msys2 terminal by running the <code>msys2.exe</code> program from the Msys2
installation (<code>C:\msys64\msys2.exe</code>). Msys2 uses <code>pacman</code> as its package
manager, borrowed from Archlinux:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>$ pacman -S rsync
</span><span>warning: rsync-3.4.1-1 is up to date -- reinstalling
</span><span>resolving dependencies...
</span><span>looking for conflicting packages...
</span><span>
</span><span>Packages (1) rsync-3.4.1-1
</span><span>
</span><span>Total Installed Size:  0.67 MiB
</span><span>Net Upgrade Size:      0.00 MiB
</span><span>
</span><span>:: Proceed with installation? [Y/n] n
</span></code></pre>
<p>Ok looks like <code>rsync</code> was already installed.</p>
<p>Maybe when Opam isn’t managing Cygwin for us we need to to manually
update the shell environment to bring various commands into PATH?</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s\conf-ao&gt; (&amp; opam env --switch=default) -split '\r?\n' | ForEach-Object { Invoke-Expression $_ }
</span><span>PS C:\Users\s\conf-ao&gt; opam pin .\conf-ao.opam
</span><span>Fatal error:
</span><span>"rsync": command not found.
</span></code></pre>
<p>No such luck.</p>
<p>Checking that <code>rsync</code> works as expected:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s\conf-ao&gt; C:\msys64\usr\bin\rsync --help
</span><span>rsync  version 3.4.1  protocol version 32
</span><span>Copyright (C) 1996-2025 by Andrew Tridgell, Wayne Davison, and others.
</span><span>Web site: https://rsync.samba.org/
</span><span>...
</span></code></pre>
<p>Maybe I just need to manually add <code>C:\msys64\usr\bin</code> to my PATH.</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s\conf-ao&gt; $env:PATH += ";C:\msys64\usr\bin"
</span><span>PS C:\Users\s\conf-ao&gt; rsync --version
</span><span>rsync  version 3.4.1  protocol version 32
</span><span>Copyright (C) 1996-2025 by Andrew Tridgell, Wayne Davison, and others.
</span><span>Web site: https://rsync.samba.org/
</span><span>...
</span></code></pre>
<p>And now pinning <code>conf-ao</code> again:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s\conf-ao&gt; opam pin .\conf-ao.opam
</span><span>[ERROR] Could not retrieve Could not extract archive:
</span><span>        Unknown archive type: C:\Users\s\AppData\Local\Temp\opam-4184-d29c4e\conf-ao.opam
</span></code></pre>
<p>Which reminds me that I’m not supposed to <code>pin</code> the opam file directly but
instead the entire folder which contains it.</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s\conf-ao&gt; opam pin .
</span><span>conf-ao is now pinned to file://C:/Users/s/conf-ao (version 1)
</span><span>
</span><span>The following actions will be performed:
</span><span>=== install 3 packages
</span><span>  ∗ conf-ao                       1 (pinned)
</span><span>  ∗ conf-mingw-w64-pkgconf-x86_64 1          [required by conf-pkg-config]
</span><span>  ∗ conf-pkg-config               4          [required by conf-ao]
</span><span>
</span><span>Proceed with ∗ 3 installations? [y/n] n
</span><span>[NOTE] Pinning command successful, but your installed packages may be out of sync.
</span></code></pre>
<p>That’s good.
I’m curious about the
<code>conf-mingw-w64-pkgconf-x86_64</code> package. It
wasn’t needed when installing
<code>depexts</code> with Cygwin, so it’s probably specific to Msys2, which means it can
probably give us a hint as to the proper way to specify Msys2-specific
<code>depexts</code>, which we’ll need to do for our pinned <code>conf-ao</code> package (I was only
guessing how to add its new <code>depexts</code> initially).</p>
<p><code>conf-mingw-w64-pkgconf-x86_64</code> is probably a dependency of <code>conf-pkg-config</code> on
Msys2, so I’ll start by looking at <code>conf-pkg-config</code>’s metadata and then look at
the metadata for <code>conf-mingw-w64-pkgconf-x86_64</code>.</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s\conf-ao&gt; opam show --raw conf-pkg-config
</span><span>...
</span><span>depends: [
</span><span>  ("host-arch-x86_64" {os = "win32" &amp; os-distribution = "msys2"} &amp;
</span><span>   "conf-mingw-w64-pkgconf-x86_64" {os = "win32" &amp; os-distribution = "msys2"} |
</span><span>   "host-arch-x86_32" {os = "win32" &amp; os-distribution = "msys2"} &amp;
</span><span>   "conf-mingw-w64-pkgconf-i686" {os = "win32" &amp; os-distribution = "msys2"})
</span><span>]
</span><span>...
</span><span>PS C:\Users\s\conf-ao&gt; opam show --raw conf-mingw-w64-pkgconf-x86_64
</span><span>...
</span><span>depexts:
</span><span>  ["mingw-w64-x86_64-pkgconf"] {os = "win32" &amp; os-distribution = "msys2"}
</span></code></pre>
<p>From this we can learn that when using Msys2 to install <code>depexts</code>, the
<code>os-distribution</code> variable evaluates to “msys2” instead of “cygwin”. Also on
Msys2 Opam will install the system package <code>mingw-w64-x86_64-pkgconf</code> to
install <code>pkg-config</code>/<code>pkgconf</code>. This suggests that the correct <code>depext</code> entry
for <code>conf-ao</code> is in fact:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>["mingw-w64-x86_64-libao"] {os = "win32" &amp; os-distribution = "msys2"}
</span></code></pre>
<p>After updating the local copy of <code>conf-ao</code> with the above <code>depext</code> and
re-pinning it I tried installing <code>conf-ao</code> again:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s\conf-ao&gt; opam install conf-ao
</span><span>
</span><span>&lt;&gt;&lt;&gt; Synchronising pinned packages &gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;  🐫
</span><span>[conf-ao.1] synchronised (no changes)
</span><span>
</span><span>The following actions will be performed:
</span><span>=== install 3 packages
</span><span>  ∗ conf-ao                       1 (pinned)
</span><span>  ∗ conf-mingw-w64-pkgconf-x86_64 1          [required by conf-pkg-config]
</span><span>  ∗ conf-pkg-config               4          [required by conf-ao]
</span><span>
</span><span>Proceed with ∗ 3 installations? [y/n] y
</span><span>
</span><span>The following system packages will first need to be installed:
</span><span>    mingw-w64-x86_64-libao mingw-w64-x86_64-pkgconf
</span><span>
</span><span>&lt;&gt;&lt;&gt; Handling external dependencies &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;  🐫
</span><span>
</span><span>opam believes some required external dependencies are missing. opam can:
</span><span>&gt; 1. Run C:\msys64\usr\bin\pacman.exe to install them (may need root/sudo access)
</span><span>  2. Display the recommended C:\msys64\usr\bin\pacman.exe command and wait while you run it manually (e.g. in another terminal)
</span><span>  3. Continue anyway, and, upon success, permanently register that this external dependency is present, but not detectable
</span><span>  4. Abort the installation
</span><span>
</span><span>[1/2/3/4] 1
</span><span>
</span><span>+ C:\msys64\usr\bin\pacman.exe "-Su" "--noconfirm" "mingw-w64-x86_64-libao" "mingw-w64-x86_64-pkgconf"
</span><span>- :: Starting core system upgrade...
</span><span>-  there is nothing to do
</span><span>- :: Starting full system upgrade...
</span><span>- resolving dependencies...
</span><span>- looking for conflicting packages...
</span><span>-
</span><span>- Packages (2) mingw-w64-x86_64-libao-1.2.2-2  mingw-w64-x86_64-pkgconf-1~2.3.0-1
</span><span>-
</span><span>- Total Download Size:   0.16 MiB
</span><span>- Total Installed Size:  0.77 MiB
</span><span>-
</span><span>- :: Proceed with installation? [Y/n]
</span><span>- :: Retrieving packages...
</span><span>-  mingw-w64-x86_64-pkgconf-1~2.3.0-1-any downloading...
</span><span>-  mingw-w64-x86_64-libao-1.2.2-2-any downloading...
</span><span>- checking keyring...
</span><span>- checking package integrity...
</span><span>- loading package files...
</span><span>- checking for file conflicts...
</span><span>- checking available disk space...
</span><span>- :: Processing package changes...
</span><span>- installing mingw-w64-x86_64-libao...
</span><span>- installing mingw-w64-x86_64-pkgconf...
</span><span>
</span><span>&lt;&gt;&lt;&gt; Processing actions &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;  🐫
</span><span>∗ installed conf-mingw-w64-pkgconf-x86_64.1
</span><span>∗ installed conf-pkg-config.4
</span><span>∗ installed conf-ao.1
</span><span>Done.
</span></code></pre>
<p>Success! And the fact that <code>conf-ao</code> installed successfully meant that
<code>conf-ao</code>’s build command which uses <code>pkgconf</code> to check whether the <code>ao</code> library
is visible also ran successfully, so we’re hopefully in a good place to link
against <code>ao</code> when building <code>llama</code>, which will be the next step.</p>
<h2><a href="https://www.gridbugs.org/rss.xml#making-noise" class="zola-anchor" aria-label="Anchor link for: making-noise">Making Noise</a></h2>
<p>Let’s try building and running an example from the <code>llama</code> synthesizer library.</p>
<p>Get the code:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s&gt; git clone git@github.com:gridbugs/llama
</span><span>Cloning into 'llama'...
</span><span>...
</span><span>Resolving deltas: 100% (961/961), done.
</span><span>PS C:\Users\s&gt; cd .\llama\
</span></code></pre>
<p>Since an old version of the packages in this repo are already published to Opam,
we need to pin them with Opam so the local versions are used and not the
released versions.</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s\llama&gt; opam pin .
</span><span>This will pin the following packages: llama, llama_core, llama_interactive, llama_midi, llama_tests. Continue? [y/n] y
</span><span>llama is now pinned to git+file://C:/Users/s/llama#main (version 0.1.0)
</span><span>llama_core is now pinned to git+file://C:/Users/s/llama#main (version 0.1.0)
</span><span>llama_interactive is now pinned to git+file://C:/Users/s/llama#main (version 0.1.0)
</span><span>llama_midi is now pinned to git+file://C:/Users/s/llama#main (version 0.1.0)
</span><span>Package llama_tests does not exist, create as a NEW package? [y/n] y
</span><span>llama_tests is now pinned to git+file://C:/Users/s/llama#main (version dev)
</span><span>
</span><span>[ERROR] Package conflict!
</span><span>  * Missing dependency:
</span><span>    - llama_tests → llama_midi &gt;= dev
</span><span>    no matching version
</span><span>
</span><span>[NOTE] Pinning command successful, but your installed packages may be out of sync.
</span></code></pre>
<p>That error is because the <code>llama_tests</code> library is unreleased while all the
other packages are released. Opam phones home while pinning packages to work out which
versions to pin (it uses the latest released version of each
released package and “dev” for unreleased packages from the look of things).
That’s not ideal here though because the unreleased <code>llama_tests</code> package is
looking for a version of <code>llama_midi</code> of its same version and failing to find it
because the unreleased <code>llama_tests</code> is version “dev” while <code>llama_midi</code> is
version “0.1.0”. I think we can work around this by forcing Opam to pin all the
packages at version “dev”:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s\llama&gt; opam pin . --with-version=dev
</span><span>This will pin the following packages: llama, llama_core, llama_interactive, llama_midi, llama_tests. Continue? [y/n] y
</span><span>[NOTE] Package llama is currently pinned to git+file://C:/Users/s/llama#main (version 0.1.0).
</span><span>llama is now pinned to git+file://C:/Users/s/llama#main (version dev)
</span><span>[NOTE] Package llama_core is currently pinned to git+file://C:/Users/s/llama#main (version 0.1.0).
</span><span>llama_core is now pinned to git+file://C:/Users/s/llama#main (version dev)
</span><span>[NOTE] Package llama_interactive is currently pinned to git+file://C:/Users/s/llama#main (version 0.1.0).
</span><span>llama_interactive is now pinned to git+file://C:/Users/s/llama#main (version dev)
</span><span>[NOTE] Package llama_midi is currently pinned to git+file://C:/Users/s/llama#main (version 0.1.0).
</span><span>llama_midi is now pinned to git+file://C:/Users/s/llama#main (version dev)
</span><span>[NOTE] Package llama_tests is already pinned to git+file://C:/Users/s/llama#main (version dev).
</span><span>llama_tests is now pinned to git+file://C:/Users/s/llama#main (version dev)
</span><span>
</span><span>The following actions will be performed:
</span><span>=== install 44 packages
</span><span>  ∗ ao                           0.2.4        [required by llama]
</span><span>  ∗ base                         v0.17.2      [required by ppx_inline_test]
</span><span>  ∗ bigarray-compat              1.1.0        [required by ctypes]
</span><span>  ∗ conf-libffi                  2.0.0        [required by ctypes-foreign]
</span><span>...
</span><span>Proceed with ∗ 44 installations? [y/n] n
</span><span>[NOTE] Pinning command successful, but your installed packages may be out of sync.
</span></code></pre>
<p>Just checking that we now don’t have 2 pins for each released package (“0.1.0”
and “dev”) from the two different runs of <code>opam pin</code>:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s\llama&gt; opam pin list
</span><span>conf-ao.1                             rsync  file://C:/Users/s/conf-ao
</span><span>llama.dev              (uninstalled)  git    git+file://C:/Users/s/llama#main
</span><span>llama_core.dev         (uninstalled)  git    git+file://C:/Users/s/llama#main
</span><span>llama_interactive.dev  (uninstalled)  git    git+file://C:/Users/s/llama#main
</span><span>llama_midi.dev         (uninstalled)  git    git+file://C:/Users/s/llama#main
</span><span>llama_tests.dev        (uninstalled)  git    git+file://C:/Users/s/llama#main
</span></code></pre>
<p>Looks good, and also we can see that our custom <code>conf-ao</code> is there which is
expected. One potential issue is that the <code>llama</code> packages are fetched with <code>git</code>
rather than <code>rsync</code>, which might bite us later if we modify the local files
in the <code>llama</code> project without committing the results. We can avoid this by not
installing any of these local packages with Opam, and instead just installing
their dependencies and then building the project with Dune.</p>
<p>Install the deps:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s\llama&gt; opam install . --deps-only
</span><span>[llama.dev] synchronised (no changes)
</span><span>[llama_core.dev] synchronised (no changes)
</span><span>[llama_interactive.dev] synchronised (no changes)
</span><span>[llama_midi.dev] synchronised (no changes)
</span><span>[llama_tests.dev] synchronised (no changes)
</span><span>The following actions will be performed:
</span><span>=== install 39 packages
</span><span>  ∗ ao                           0.2.4   [required by llama]
</span><span>  ∗ base                         v0.17.2 [required by ppx_inline_test]
</span><span>  ∗ bigarray-compat              1.1.0   [required by ctypes]
</span><span>  ∗ conf-libffi                  2.0.0   [required by ctypes-foreign]
</span><span>  ∗ conf-mingw-w64-libffi-x86_64 1       [required by conf-libffi]
</span><span>  ∗ conf-mingw-w64-sdl2-x86_64   1       [required by conf-sdl2]
</span><span>  ∗ conf-sdl2                    1       [required by tsdl]
</span><span>  ∗ csexp                        1.5.2   [required by dune-configurator]
</span><span>  ∗ ctypes                       0.23.0  [required by tsdl]
</span><span>  ∗ ctypes-foreign               0.23.0  [required by tsdl]
</span><span>  ∗ dune                         3.19.0  [required by llama_midi, llama_core, llama, etc.]
</span><span>  ∗ dune-configurator            3.19.0  [required by ao]
</span><span>  ∗ integers                     0.7.0   [required by ctypes]
</span><span>  ∗ jane-street-headers          v0.17.0 [required by time_now]
</span><span>  ∗ jst-config                   v0.17.0 [required by time_now]
</span><span>  ∗ ocaml-compiler-libs          v0.17.0 [required by ppxlib]
</span><span>  ∗ ocaml_intrinsics_kernel      v0.17.1 [required by base]
</span><span>  ∗ ocamlbuild                   0.16.1  [required by tsdl]
</span><span>  ∗ ocamlfind                    1.9.8   [required by tsdl]
</span><span>  ∗ ppx_assert                   v0.17.0 [required by jst-config]
</span><span>  ∗ ppx_base                     v0.17.0 [required by time_now]
</span><span>  ∗ ppx_cold                     v0.17.0 [required by ppx_base]
</span><span>  ∗ ppx_compare                  v0.17.0 [required by ppx_base]
</span><span>  ∗ ppx_derivers                 1.2.1   [required by ppxlib]
</span><span>  ∗ ppx_enumerate                v0.17.0 [required by ppx_base]
</span><span>  ∗ ppx_globalize                v0.17.0 [required by ppx_base]
</span><span>  ∗ ppx_hash                     v0.17.0 [required by ppx_base]
</span><span>  ∗ ppx_here                     v0.17.0 [required by ppx_assert]
</span><span>  ∗ ppx_inline_test              v0.17.0 [required by llama_tests]
</span><span>  ∗ ppx_optcomp                  v0.17.0 [required by time_now]
</span><span>  ∗ ppx_sexp_conv                v0.17.0 [required by ppx_base]
</span><span>  ∗ ppxlib                       0.35.0  [required by ppx_inline_test]
</span><span>  ∗ ppxlib_jane                  v0.17.2 [required by ppx_globalize, ppx_enumerate, ppx_hash]
</span><span>  ∗ sexplib0                     v0.17.0 [required by base, ppxlib]
</span><span>  ∗ stdio                        v0.17.0 [required by ppx_optcomp]
</span><span>  ∗ stdlib-shims                 0.3.0   [required by ppxlib]
</span><span>  ∗ time_now                     v0.17.0 [required by ppx_inline_test]
</span><span>  ∗ topkg                        1.0.8   [required by tsdl]
</span><span>  ∗ tsdl                         1.1.0   [required by llama_interactive]
</span><span>
</span><span>Proceed with ∗ 39 installations? [y/n] y
</span><span>
</span><span>The following system packages will first need to be installed:
</span><span>    mingw-w64-x86_64-libffi mingw-w64-x86_64-SDL2
</span><span>...
</span></code></pre>
<p>Note the additional depexts <code>mingw-w64-x86_64-libffi</code> and
<code>mingw-w64-x86_64-SDL2</code>. Based on their names these appear to be packages in the
Msys2 repo. It’s great that these packages don’t seem to require the manual
intervention needed for <code>libao</code>. While my project’s dependencies install, let’s
investigate how one of these packages works:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s&gt; opam show conf-sdl2
</span><span>...
</span><span>depends     "conf-pkg-config" {build}
</span><span>            ("host-arch-x86_32" {os = "win32" &amp; os-distribution != "cygwinports"} &amp;
</span><span>             "conf-mingw-w64-sdl2-i686" {os = "win32" &amp; os-distribution != "cygwinports"} |
</span><span>             "host-arch-x86_64" {os = "win32" &amp; os-distribution != "cygwinports"} &amp;
</span><span>             "conf-mingw-w64-sdl2-x86_64"
</span><span>               {os = "win32" &amp; os-distribution != "cygwinports"})
</span><span>...
</span></code></pre>
<p>Similar to <code>conf-pkg-config</code>, we see the dependency on an additional
<code>conf-mingw-w64-*</code> metapackage under some conditions. Here though it’s
<code>os-distribution != "cygwinports"</code> rather than <code>os-distribution = "msys2"</code> which
makes me wonder if this would cause a problem on a regular Cygwin installation,
where <code>os-distribution = "cygwin"</code>. That would cause the <code>os-distribution != "cygwinports"</code>
to be true which seems to select <code>conf-mingw-w64-*</code> packages, but my intuition
is that those packages should only be selected on Msys2. There’s too much
else going on to also investigate that now and maybe my hunch is wrong anyway.</p>
<p>There’s a new problem: <code>llama</code>’s dependencies failed to install:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>#=== ERROR while compiling topkg.1.0.8 ========================================#
</span><span># context     2.3.0 | win32/x86_64 | ocaml.5.3.0 | https://opam.ocaml.org#11859fd62a66b5e319a415e807797407068a7c13
</span><span># path        ~\AppData\Local\opam\default\.opam-switch\build\topkg.1.0.8
</span><span># command     ~\AppData\Local\opam\default\bin\ocaml.exe pkg/pkg.ml build --pkg-name topkg --dev-pkg false
</span><span># exit-code   125
</span><span># env-file    ~\AppData\Local\opam\log\topkg-18684-d088ec.env
</span><span># output-file ~\AppData\Local\opam\log\topkg-18684-d088ec.out
</span><span>### output ###
</span><span># Exception: Fl_package_base.No_such_package ("findlib", "").
</span><span>
</span><span>&lt;&gt;&lt;&gt; Error report &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;  🐫
</span><span>┌─ The following actions failed
</span><span>│ λ build topkg 1.0.8
</span><span>└─
</span></code></pre>
<p>The <a href="https://opam.ocaml.org/packages/topkg/">topkg</a> package is a build tool.
According to its description it’s in maintenance mode and should no longer be
used. It’s got 165 reverse dependencies so the fact that it doesn’t build on
Windows (or maybe just when using Msys2 or maybe just on my machine) is a little
concerning however for our purposes here it’s only used to build <code>tsdl</code> which is
only needed for the interactive components of <code>llama</code>. It would still be nice to
get it working but my priority is getting the sound to work, so consider fixing
<code>topkg</code> to be a stretch goal.</p>
<p>For now, let’s just install the dependencies needed for non-interactive
synthesizer demos:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s\llama&gt; opam install llama --deps-only
</span><span>
</span><span>&lt;&gt;&lt;&gt; Synchronising pinned packages &gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;  🐫
</span><span>[llama.dev] synchronised (no changes)
</span><span>
</span><span>The following actions will be performed:
</span><span>=== install 2 packages
</span><span>  ∗ llama_core dev (pinned) [required by llama]
</span><span>  ∗ llama_midi dev (pinned) [required by llama_core]
</span><span>
</span><span>Proceed with ∗ 2 installations? [y/n] n
</span></code></pre>
<p>Good news! All the necessary dependencies were successfully installed in the
previous step. Those two deps are local packages in this project so we don’t
need to install them with Opam. In theory we should now have everything we need
to run an example:</p>
<iframe width="560" height="315" src="https://www.youtube.com/embed/ZikuC-SCtEQ?si=EY2akELtCOS0Kfji" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen=""></iframe>
<p>Honestly that was easier than I thought it would be. I’m really happy that I
didn’t need to manually install libao and that Msys2/Opam could take care of
installing it and all the other system dependencies needed to build the synth
library and to access the sound card.</p>
<p>Most of what went wrong during this process could conceivably be called “user
error” though the fact that I have 5 years of OCaml programming behind me
and still hit some pretty major footguns with Opam maybe suggests some aspects
of its UX could be improved. Still some things were actually broken:</p>
<ul>
<li><code>conf-ao</code> is hardcoded to run <code>pkg-config</code> despite the executable being named
<code>pkgconf</code> in some cases, and has no depext for Msys2. The workaround was to
pin <code>conf-ao</code> and fix its problems in a local copy of the package.</li>
<li>Opam couldn’t find the <code>rsync</code> executable in the Msys2 environment despite
being configured to use an Msys2 environment where <code>rsync</code> was installed. The
workaround was to manually add <code>C:\msys64\usr\bin</code> to PATH.</li>
<li><code>topkg</code> failed to build. The workaround was to only use the non-interactive
components of my project, as <code>topkg</code> is only necessary to compile the SDL bindings
which are only needed for interactive synthesizer features.</li>
</ul>
<p>The parts of Opam’s UX that I evidently still struggle with relate to working
with local packages and pins.
Looking back at the “user errors” in this post, a couple of times I tried to pin
an opam file led to bizarre errors (
<code>Unknown archive type: C:\Users\s\AppData\Local\Temp\opam-4184-d29c4e\conf-ao.opam</code>)
and unexpected results (recursively copying my home directory inside itself
until I told it to stop). Opam pins are associated with package sources in the
form of a directory, git repo, or archive file - not with opam files themselves.
What’s confusing when working with packages like <code>conf-ao</code> is that these
packages <em>don’t have sources</em>. They are metapackages that just exist to
collect some dependencies on other Opam packages or external dependencies, but
they have no source code or other files to fetch during installation. I’ve
learnt that the correct thing to do is put the opam file I want to pin inside a
directory and then pin that directory.</p>
<p>The other pinning-related mistake I made was pinning a project containing
multiple packages where some but not all of the packages had been released. This
led to the non-released packages being pinned at version “dev” while the
released packages are pinned to the latest released version of those packages.
If the unreleased package depends on a released package, chances are it won’t be
able to resolve the dependency because it will try to find a version of the
released package with version “dev”. I’ve learnt that for such projects one must
run <code>opam pin . --with-version=dev</code>. Possibly that should be the default
behaviour or at least Opam should warn when some but not all of the packages in
a project are released.
I’ve complained about this exact behaviour
<a href="https://www.gridbugs.org/frustrating-interactions-with-the-ocaml-ecosystem-while-developing-a-synthesizer-library/#if-some-but-not-all-of-the-interdependent-packages-in-a-project-are-released-opam-can-t-solve-the-project-s-dependencies">before</a>
but I still make this mistake all the time.</p>
<p>I have gotten used to Opam’s quirks and am no longer too phased when things go
wrong. And on Windows in particular I had quite low expectations of the OCaml
ecosystem since it’s historically been infamously hard to get working. This is
why I’m pleasantly surprised it was this easy to get generated audio playing
on Windows with OCaml, despite spending over a day on it at this point. The fact
that Opam can be installed through WinGet now, and that it takes care of setting up all
the external dependencies with Msys2 (or Cygwin) for you during initialization
is very slick. It’s definitely come a long way since the last time I tried to
use OCaml on Windows in earnest.</p>
<p>That said many of the problems I had with Opam in this post were not
Windows-related. The problems with pinning are things I had encountered before
on Unix so I could recognize them and employ workarounds. I’ve adopted a
defensive approach to working with Opam where I expect the unexpected and often
explicitly verify that it did what I want such as always running <code>opam pin list</code>
after <code>opam pin</code> and using <code>opam show --raw</code> to check that pinning a package
has taken effect if I’m changing a pinned package’s metadata. I don’t believe
“user error” is an apt term to use here. The error is not with the user it’s
with the usability of the tool.</p>
<h2><a href="https://www.gridbugs.org/rss.xml#stretch-goal-fixing-topkg" class="zola-anchor" aria-label="Anchor link for: stretch-goal-fixing-topkg">Stretch Goal: Fixing topkg</a></h2>
<p>I set aside 2 days to get <code>llama</code> working on Windows and it’s only been a day and
a half, so let’s see if we can’t get <code>topkg</code> to build and then run the graphical
interactive synthesizer demos which that would enable.</p>
<p>We’ll start by grabbing the source code for topkg. Opam has a handy feature for
doing just this:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s&gt; opam source topkg
</span><span>Successfully extracted to C:\Users\s\topkg.1.0.8
</span><span>PS C:\Users\s&gt; cd .\topkg.1.0.8\
</span></code></pre>
<p>Now pin <code>topkg</code> to the local version so we can tweak things locally and test
out how they affect building <code>topkg</code> as a dependency:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s\topkg.1.0.8&gt; opam pin .
</span><span>This will pin the following packages: topkg-care, topkg. Continue? [y/n] y
</span><span>topkg-care is now pinned to file://C:/Users/s/topkg.1.0.8 (version 1.0.8)
</span><span>topkg is now pinned to file://C:/Users/s/topkg.1.0.8 (version 1.0.8)
</span><span>
</span><span>The following actions will be performed:
</span><span>=== remove 6 packages
</span><span>  ⊘ base-domains            base               [conflicts with ocaml]
</span><span>  ⊘ base-effects            base               [conflicts with ocaml]
</span><span>  ⊘ base-nnp                base               [uses base-domains]
</span><span>  ⊘ ocaml-compiler          5.3.0
</span><span>  ⊘ ocaml_intrinsics_kernel v0.17.1            [conflicts with ocaml]
</span><span>  ⊘ ppxlib_jane             v0.17.2            [conflicts with ocaml]
</span><span>=== downgrade 20 packages
</span><span>  ↘ base                    v0.17.2 to v0.16.4 [uses ocaml]
</span><span>  ↘ jane-street-headers     v0.17.0 to v0.16.0 [uses ocaml]
</span><span>  ↘ jst-config              v0.17.0 to v0.16.0 [uses ocaml]
</span><span>  ↘ ocaml                   5.3.0 to 4.14.2    [required by topkg, topkg-care]
</span><span>  ↘ ocaml-base-compiler     5.3.0 to 4.14.2    [required by ocaml]
</span><span>  ↘ ocaml-compiler-libs     v0.17.0 to v0.12.4 [uses ocaml]
</span><span>  ↘ ppx_assert              v0.17.0 to v0.16.0 [uses ocaml]
</span><span>  ↘ ppx_base                v0.17.0 to v0.16.0 [uses ocaml]
</span><span>  ↘ ppx_cold                v0.17.0 to v0.16.0 [uses ocaml]
</span><span>  ↘ ppx_compare             v0.17.0 to v0.16.0 [uses ocaml]
</span><span>  ↘ ppx_enumerate           v0.17.0 to v0.16.0 [uses ocaml]
</span><span>  ↘ ppx_globalize           v0.17.0 to v0.16.0 [uses ocaml]
</span><span>  ↘ ppx_hash                v0.17.0 to v0.16.0 [uses ocaml]
</span><span>  ↘ ppx_here                v0.17.0 to v0.16.0 [uses ocaml]
</span><span>  ↘ ppx_inline_test         v0.17.0 to v0.16.1 [uses ocaml]
</span><span>  ↘ ppx_optcomp             v0.17.0 to v0.16.0 [uses ocaml]
</span><span>  ↘ ppx_sexp_conv           v0.17.0 to v0.16.0 [uses ocaml]
</span><span>  ↘ sexplib0                v0.17.0 to v0.16.0 [uses ocaml]
</span><span>  ↘ stdio                   v0.17.0 to v0.16.0 [uses ocaml]
</span><span>  ↘ time_now                v0.17.0 to v0.16.0 [uses ocaml]
</span><span>...
</span></code></pre>
<p>Opam wants to remove or downgrade lots of packages including the compiler
itself. That seems a bit drastic so let’s see if there’s a way to avoid doing
that. After all <code>topkg.1.0.8</code> was part of the package solution Opam found when
building <code>llama</code>’s dependencies and <code>ocaml.5.3.0</code> was sufficient in that solution.
It’s odd that it wouldn’t also be sufficient here.
The opam files in <code>topkg</code>’s source archive look like they should be compatible
with <code>ocaml.5.3.0</code> so I really have no idea why Opam wanted to downgrade
everything.</p>
<p>Regardless, we don’t actually need to install <code>topkg</code> while pinning it. It’s
pinned now so that should be sufficient for the local copy to be compiled as a
dependency of <code>llama</code>. Let’s see if that’s correct:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s\llama&gt; opam install . --deps-only
</span><span>[llama_core.dev] synchronised (no changes)
</span><span>[llama.dev] synchronised (no changes)
</span><span>[llama_interactive.dev] synchronised (no changes)
</span><span>[llama_midi.dev] synchronised (no changes)
</span><span>[llama_tests.dev] synchronised (no changes)
</span><span>The following actions will be performed:
</span><span>=== install 2 packages
</span><span>  ∗ topkg 1.0.8 (pinned) [required by tsdl]
</span><span>  ∗ tsdl  1.1.0          [required by llama_interactive]
</span><span>
</span><span>Proceed with ∗ 2 installations? [y/n] y
</span><span>
</span><span>&lt;&gt;&lt;&gt; Processing actions &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;  🐫
</span><span>⬇ retrieved tsdl.1.1.0  (cached)
</span><span>[ERROR] The compilation of topkg.1.0.8 failed at "ocaml pkg/pkg.ml build --pkg-name topkg --dev-pkg true".
</span><span>
</span><span>#=== ERROR while compiling topkg.1.0.8 ========================================#
</span><span># context     2.3.0 | win32/x86_64 | ocaml.5.3.0 | pinned(file://C:/Users/s/topkg.1.0.8)
</span><span># path        ~\AppData\Local\opam\default\.opam-switch\build\topkg.1.0.8
</span><span># command     ~\AppData\Local\opam\default\bin\ocaml.exe pkg/pkg.ml build --pkg-name topkg --dev-pkg true
</span><span># exit-code   125
</span><span># env-file    ~\AppData\Local\opam\log\topkg-6140-4d0e5a.env
</span><span># output-file ~\AppData\Local\opam\log\topkg-6140-4d0e5a.out
</span><span>### output ###
</span><span># Exception: Fl_package_base.No_such_package ("findlib", "").
</span><span>
</span><span>
</span><span>
</span><span>&lt;&gt;&lt;&gt; Error report &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;  🐫
</span><span>┌─ The following actions failed
</span><span>│ λ build topkg 1.0.8
</span><span>└─
</span></code></pre>
<p>Looks good, especially this line:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span># context     2.3.0 | win32/x86_64 | ocaml.5.3.0 | pinned(file://C:/Users/s/topkg.1.0.8)
</span></code></pre>
<p>To debug this problem it will help to have a command we can run to quickly
reproduce it. Running the <code>topkg</code>’s build command, copied from its opam file,
causes the same error as we see when installing <code>topkg</code> as a dependency:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s\topkg.1.0.8&gt; opam exec ocaml -- .\pkg\pkg.ml build --pkg-name topkg --dev-pkg true
</span><span>Exception: Fl_package_base.No_such_package ("findlib", "").
</span></code></pre>
<p>Before digging into the source of <code>topkg</code> too deeply it might pay to verify that
findlib is indeed installed:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s\topkg.1.0.8&gt; cat C:\Users\s\AppData\Local\opam\default\lib\findlib\META
</span><span># specifications for "findlib":
</span><span>description = "Package manager"
</span><span>requires = "findlib.internal"
</span><span>requires(toploop) += "findlib.top"
</span><span>requires(create_toploop) += "findlib.top"
</span><span>version = "1.9.8"
</span><span>
</span><span>package "internal" (
</span><span>  version = "1.9.8"
</span><span>  description = "Package manager"
</span><span>  requires = ""
</span><span>  archive(byte) = "findlib.cma"
</span><span>  archive(native) = "findlib.cmxa"
</span><span>  plugin(byte) = "findlib.cma"
</span><span>  plugin(native) = "findlib.cmxs"
</span><span>)
</span><span>
</span><span>package "dynload" (
</span><span>  version = "1.9.8"
</span><span>  description = "Package manager dynamic loader"
</span><span>  requires = "findlib dynlink"
</span><span>  archive(byte) = "findlib_dynload.cma"
</span><span>  archive(native) = "findlib_dynload.cmxa"
</span><span>#Even if it strange and discouraged to dynload this package
</span><span>  plugin(byte) = "findlib_dynload.cma"
</span><span>  plugin(native) = "findlib_dynload.cmxs"
</span><span>  linkopts = "-linkall"
</span><span>)
</span><span>
</span><span>package "top" (
</span><span>  version = "1.9.8"
</span><span>  description = "Package manager toplevel support"
</span><span>  requires = "findlib.internal"
</span><span>  archive(byte) = "findlib_top.cma"
</span><span>  archive(native) = "findlib_top.cmxa"
</span><span>)
</span></code></pre>
<p>Ok this suggests that the problem is with <code>topkg</code> itself and not with my
environment. I tried installing <code>llama</code>’s dependencies with Opam on Linux and
<code>topkg</code> built fine, suggesting that the problem is specific to Windows. A likely
hypothesis is that it’s related to differences with how file paths work between
the Unix world and Windows, since this is a common point of pain for running
OCaml programs on Windows in my experience. The main two differences that tend
to cause problems are that the path separator is <code>\</code> on Windows and <code>/</code> on Unix,
and that Windows paths begin with <code>C:</code> while <code>:</code> is conventionally used to
delimit multiple paths when they appear in strings on Unix systems (Windows
tends to use <code>;</code> for this instead to avoid confusion around the colon in <code>C:</code>).</p>
<p>Next step was to instrument <code>topkg</code> with debug printouts to better understand
where the error was happening, but pretty quickly I realized that the problem
was happening before any code in <code>topkg</code> could run.</p>
<p>Here’s a simplified version of <code>pkg/pkg.ml</code> from the <code>topkg</code> package that still exhibits the problem:</p>
<pre data-lang="ocaml" style="background-color:#ffffff;color:#323232;" class="language-ocaml "><code class="language-ocaml" data-lang="ocaml"><span style="font-weight:bold;color:#a71d5d;">#!/</span><span>usr</span><span style="font-weight:bold;color:#a71d5d;">/</span><span>bin</span><span style="font-weight:bold;color:#a71d5d;">/</span><span>env ocaml
</span><span style="font-weight:bold;color:#a71d5d;">#use </span><span style="color:#183691;">"topfind"
</span><span>
</span><span style="font-weight:bold;color:#a71d5d;">let </span><span style="color:#0086b3;">() </span><span style="font-weight:bold;color:#a71d5d;">=</span><span> print_endline </span><span style="color:#183691;">"hi"
</span></code></pre>
<p>Now I can run:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s\topkg.1.0.8&gt; opam exec ocaml -- .\pkg\pkg.ml
</span><span>Exception: Fl_package_base.No_such_package ("findlib", "").
</span></code></pre>
<p>And of course removing the <code>#use "topfind"</code> from the top of that file makes the
problem go away.</p>
<p>Interestingly I can add code before the <code>#use "topfind"</code> line and it still gets
executed:</p>
<pre data-lang="ocaml" style="background-color:#ffffff;color:#323232;" class="language-ocaml "><code class="language-ocaml" data-lang="ocaml"><span style="font-weight:bold;color:#a71d5d;">#!/</span><span>usr</span><span style="font-weight:bold;color:#a71d5d;">/</span><span>bin</span><span style="font-weight:bold;color:#a71d5d;">/</span><span>env ocaml
</span><span style="font-weight:bold;color:#a71d5d;">let </span><span style="color:#0086b3;">() </span><span style="font-weight:bold;color:#a71d5d;">=</span><span> print_endline </span><span style="color:#183691;">"before"</span><span>;;
</span><span>
</span><span style="font-weight:bold;color:#a71d5d;">#use </span><span style="color:#183691;">"topfind"
</span><span>
</span><span style="font-weight:bold;color:#a71d5d;">let </span><span style="color:#0086b3;">() </span><span style="font-weight:bold;color:#a71d5d;">=</span><span> print_endline </span><span style="color:#183691;">"after"</span><span>;;
</span></code></pre>
<p>The output is:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s\topkg.1.0.8&gt; opam exec ocaml -- .\pkg\pkg.ml
</span><span>before
</span><span>Exception: Fl_package_base.No_such_package ("findlib", "").
</span></code></pre>
<p>Searching online I found <a href="https://github.com/ocaml-community/utop/issues/112">this
issue</a> which mentions the
<code>OCAML_TOPLEVEL_PATH</code> variable. On my Windows machine this variable is set to
<code>C:\Users\s\AppData\Local\opam\default\lib\toplevel</code>. That path refers to a
folder and inside that folder is a file named <code>topfind</code> with some OCaml code in
it. I’m not too familiar with the <code>#use</code> directive in OCaml but it seems to
behave similarly to <code>#include</code> in C; acting as though the contents of the
specified file replaced the occurrence of <code>#use &lt;file&gt;</code>.</p>
<p>Some of the code in <code>topfind</code> makes calls to the <code>findlib</code> library (part of the
<code>ocamlfind</code> package) which is generally concerned with mapping library names to
files containing compiled OCaml modules. The <code>ocamlfind</code> package installs a file
named <code>findlib.conf</code> containing some metadata about library locations within an
Opam switch. On my Windows machine this file was at <code>C:\Users\s\AppData\Local\opam\default\lib\findlib.conf</code>
and its contents was:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>destdir="C:\\Users\\s\\AppData\\Local\\opam\\default\\lib"
</span><span>path="C:\\Users\\s\\AppData\\Local\\opam\\default/lib/ocaml:C:\\Users\\s\\AppData\\Local\\opam\\default\\lib"
</span><span>ocamlc="ocamlc.opt"
</span><span>ocamlopt="ocamlopt.opt"
</span><span>ocamldep="ocamldep.opt"
</span><span>ocamldoc="ocamldoc.opt"
</span></code></pre>
<p>The <code>path</code> field looks suspicious, since the paths on Windows begin with <code>C:</code>,
but it looks like a colon character is also being used to separate the two paths.
Recall that on Windows it’s common to use a semicolon to separate paths, rather than a colon
as is typically seen on Unix. As an experiment I manually replaced the colon
with a semicolon in <code>findlib.conf</code> and suddenly I could successfully build
<code>topkg</code> both on its own and as a dependency for <code>llama</code>:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s\llama&gt; opam install . --deps-only
</span><span>[llama_core.dev] synchronised (no changes)
</span><span>[llama.dev] synchronised (no changes)
</span><span>[llama_interactive.dev] synchronised (no changes)
</span><span>[llama_midi.dev] synchronised (no changes)
</span><span>[llama_tests.dev] synchronised (no changes)
</span><span>The following actions will be performed:
</span><span>=== install 2 packages
</span><span>  ∗ topkg 1.0.8 (pinned) [required by tsdl]
</span><span>  ∗ tsdl  1.1.0          [required by llama_interactive]
</span><span>
</span><span>Proceed with ∗ 2 installations? [y/n] y
</span><span>
</span><span>&lt;&gt;&lt;&gt; Processing actions &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;  🐫
</span><span>⬇ retrieved tsdl.1.1.0  (cached)
</span><span>∗ installed topkg.1.0.8
</span><span>∗ installed tsdl.1.1.0
</span><span>Done.
</span></code></pre>
<p>So the problem wasn’t with <code>topkg</code> after all but rather with <code>ocamlfind</code>. The
<code>ocamlfind</code> package is a bit old-school, building with a <code>configure</code> script
and <code>Makefile</code>. I’m guessing somewhere in there it fails to detect that it’s
running on Windows, at least in Msys2 environments, and uses the wrong path
delimiter for paths in <code>findlib.conf</code>.</p>
<p>With that problem adequately worked around we should finally be able to run a
graphical example:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s\llama&gt; dune exec .\examples\interactive.exe
</span><span>File "examples/dune", line 44, characters 14-25:
</span><span>44 |  (public_name interactive)
</span><span>                   ^^^^^^^^^^^
</span><span>C:/msys64/mingw64/bin/../lib/gcc/x86_64-w64-mingw32/14.2.0/../../../../x86_64-w64-mingw32/bin/ld.exe: C:/msys64/mingw64/bin/../lib/libmingw32.a(lib64_libmingw32_a-ucrtexewin.o): in function `wmain':
</span><span>C:/M/B/src/mingw-w64/mingw-w64-crt/crt/crtexewin.c:67:(.text+0xb5): undefined reference to `wWinMain'
</span><span>collect2.exe: error: ld returned 1 exit status
</span><span>** Fatal error: Error during linking
</span><span>
</span><span>File "caml_startup", line 1:
</span><span>Error: Error during linking (exit code 2)
</span></code></pre>
<p>Not quite yet!</p>
<h2><a href="https://www.gridbugs.org/rss.xml#fixing-the-linker-error" class="zola-anchor" aria-label="Anchor link for: fixing-the-linker-error">Fixing the linker error</a></h2>
<p>Linker errors like this usually mean that we’re not linking against a certain
shared library, in this case whichever shared library would define the symbol
<code>wWinMain</code>. I assumed the <code>tsdl</code> library would have taken care of making sure
the appropriate linker flags were passed. It works fine on Linux and MacOS but
maybe there are some Windows-specific flags it’s leaving out.</p>
<p><code>pkgconf</code> should be able to tell us what flags are necessary to use a certain
library. I assume whatever flags are necessary for SDL2 should suffice here:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s\llama&gt; pkgconf.exe sdl2 --libs
</span><span>-LC:/msys64/mingw64/bin/../lib -lmingw32 -mwindows -lSDL2main -lSDL2
</span></code></pre>
<p>I’ll start by adding these to the <code>library_flags</code> field of the <code>executable</code>
stanza of the example I’m trying to run:</p>
<pre data-lang="dune" style="background-color:#ffffff;color:#323232;" class="language-dune "><code class="language-dune" data-lang="dune"><span>(</span><span style="font-weight:bold;color:#a71d5d;">executable
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">public_name</span><span> interactive)
</span><span> (modules interactive)
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">package</span><span> llama_interactive)
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">libraries</span><span> llama_interactive keyboard_helper)
</span><span> (link_flags -LC:/msys64/mingw64/bin/../lib -lmingw32 -mwindows -lSDL2main -lSDL2))
</span></code></pre>
<p>Building the example:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s\llama&gt; dune build .\examples\interactive.exe
</span><span>File "examples/dune", line 44, characters 14-25:
</span><span>44 |  (public_name interactive)
</span><span>                   ^^^^^^^^^^^
</span><span>C:\Users\s\AppData\Local\opam\default\bin\ocamlopt.opt.exe: unknown option '-LC:/msys64/mingw64/bin/../lib'.
</span><span>Usage: ocamlopt &lt;options&gt; &lt;files&gt;
</span><span>Try 'ocamlopt --help' for more information.
</span></code></pre>
<p>Turns out you can’t pass raw linker flags to the OCaml compiler like that.
In the
<a href="https://www.gridbugs.org/frustrating-interactions-with-the-ocaml-ecosystem-while-developing-a-synthesizer-library/#linking-against-os-specific-native-libraries-with-dune-is-hard">past</a>
I’ve had success wrapping the linker flags in <code>-cclib "&lt;flags&gt;"</code> so I tried
that:</p>
<pre data-lang="dune" style="background-color:#ffffff;color:#323232;" class="language-dune "><code class="language-dune" data-lang="dune"><span>(link_flags -cclib </span><span style="color:#183691;">"-LC:/msys64/mingw64/bin/../lib -lmingw32 -mwindows -lSDL2main -lSDL2"</span><span>)
</span></code></pre>
<p>And the error message changed which is often a sign of progress:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s\llama&gt; dune build .\examples\interactive.exe
</span><span>File "examples/dune", line 44, characters 14-25:
</span><span>44 |  (public_name interactive)
</span><span>                   ^^^^^^^^^^^
</span><span>flexlink: unknown option '-mwindows'.
</span><span>FlexDLL version 0.44
</span><span>
</span><span>Usage:
</span><span>  flexlink -o &lt;result.dll/exe&gt; file1.obj file2.obj ... -- &lt;extra linker arguments&gt;
</span><span>
</span><span>  -o                  Choose the name of the output file
</span><span>  -exe                Link the main program as an exe file
</span><span>  -maindll            Link the main program as a dll file
</span><span>  -noflexdllobj       Do not add the Flexdll runtime object (for exe)
</span><span>  -noentry            Do not use the Flexdll entry point (for dll)
</span><span>  -noexport           Do not export any symbol
</span><span>  -norelrelocs        Ensure that no relative relocation is generated
</span><span>  -base               Specify base address (Win64 only)
</span><span>  -pthread            Pass -pthread to the linker
</span><span>  -I &lt;dir&gt;            Add a directory where to search for files
</span><span>  -L &lt;dir&gt;            Add a directory where to search for files
</span><span>  -l &lt;lib&gt;            Library file
</span><span>  -chain {msvc|msvc64|cygwin64|mingw|mingw64|gnat|gnat64|ld}
</span><span>                      Choose which linker to use
</span><span>  -use-linker &lt;cmd&gt;   Choose an alternative linker to use
</span><span>  -use-mt &lt;cmd&gt;       Choose an alternative manifest tool to use
</span><span>  -x64                (Deprecated)
</span><span>  -defaultlib &lt;obj&gt;   External object (no export, no import)
</span><span>  -save-temps         Do not delete intermediate files
</span><span>  -implib             Do not delete the generated import library
</span><span>  -outdef             Produce a def file with exported symbols
</span><span>  -v                  Increment verbosity (can be repeated)
</span><span>  -show-exports       Show exported symbols
</span><span>  -show-imports       Show imported symbols
</span><span>  -dry                Show the linker command line, do not actually run it
</span><span>  -dump               Only dump the content of object files
</span><span>  -patch              Only patch the target image (to be used with -stack)
</span><span>  -nocygpath          Do not use cygpath (default for msvc, mingw)
</span><span>  -cygpath            Use cygpath (default for cygwin)
</span><span>  -no-merge-manifest  Do not merge the manifest (takes precedence over -merge-manifest)
</span><span>  -merge-manifest     Merge manifest to the dll or exe (if generated)
</span><span>  -real-manifest      Use the generated manifest (default behavior)
</span><span>  -default-manifest   Use the default manifest (default.manifest/default_amd64.manifest)
</span><span>  -export &lt;sym&gt;       Explicitly export a symbol
</span><span>  -noreexport         Do not reexport symbols imported from import libraries
</span><span>  -where              Show the FlexDLL directory
</span><span>  -nounderscore       Normal symbols are not prefixed with an underscore
</span><span>  -nodefaultlibs      Do not assume any default library
</span><span>  -builtin            Use built-in linker to produce a dll
</span><span>  -explain            Explain why library objects are linked
</span><span>  -subsystem &lt;id&gt;     Set the subsystem (default: console)
</span><span>  -custom-crt         Use a custom CRT
</span><span>  -stack &lt;int&gt;        Set the stack reserve in the resulting image
</span><span>  -link &lt;option&gt;      Next argument is passed verbatim to the linker
</span><span>  -g                  (Ignored)
</span><span>  -D &lt;symbol&gt;         (Ignored)
</span><span>  -U &lt;symbol&gt;         (Ignored)
</span><span>  --                  Following arguments are passed verbatim to the linker
</span><span>  -version            Print linker version and FlexDLL directory and exit
</span><span>  -vnum               Print linker version number and exit
</span><span>  -help               Display this list of options
</span><span>  --help              Display this list of options
</span><span>
</span><span>Notes:
</span><span>* The -I, -l and -L options do not need to be separated from their argument.
</span><span>* An option like /linkXXX is an abbrevation for '-link XXX'.
</span><span>* An option like -Wl,-XXX is an abbreviation for '-link -XXX'.
</span><span>* FlexDLL's object files are searched by default in the same directory as
</span><span>  flexlink, or in the directory given by the environment variable FLEXDIR
</span><span>  if it is defined.
</span><span>* Extra argument can be passed in the environment variable FLEXLINKFLAGS.
</span><span>
</span><span>Homepage: https://github.com/ocaml/flexdll
</span><span>File "caml_startup", line 1:
</span><span>Error: Error during linking (exit code 2)
</span></code></pre>
<p>Getting rid of the <code>-mwindows</code> argument just gets us back to the original linker
error, so I assume it’s important.</p>
<p>Reading more about <code>wMinMain</code> and it looks like I was wrong assuming that we
need to pass additional linker flags to tell the linker which shared library to
look in. Rather, the linker was looking for <code>wWinMain</code> as the entry point to the
program called by the C runtime’s initialization code. I have to define it
myself. Perhaps OCaml assumes that the entry point will be named <code>WinMain</code> which
seems to be the entry point for Windows C programs that don’t accept unicode
arguments whereas <code>wWinMain</code> is used when programs <em>do</em> accept unicode
arguments (I think the “w” stands for “wide” as in “wide character” since
unicode characters can be wider than a byte). For some reason depending on SDL
seems to require that the entry point be <code>wWinMain</code>. I don’t understand why.</p>
<p>Following <a href="https://dune.readthedocs.io/en/latest/howto/override-default-entrypoint.html">these
instructions</a>
I defined a custom entry point in some C code.
For starters it’s stolen from <a href="https://sourceforge.net/p/mingw-w64/wiki2/Unicode%20apps/">here</a>:</p>
<pre data-lang="c" style="background-color:#ffffff;color:#323232;" class="language-c "><code class="language-c" data-lang="c"><span style="font-weight:bold;color:#a71d5d;">#include </span><span style="color:#183691;">&lt;wchar.h&gt;
</span><span style="font-weight:bold;color:#a71d5d;">#include </span><span style="color:#183691;">&lt;stdio.h&gt;
</span><span>
</span><span style="font-weight:bold;color:#a71d5d;">int
</span><span style="font-weight:bold;color:#795da3;">wWinMain </span><span>(</span><span style="font-weight:bold;color:#a71d5d;">int </span><span>argc, wchar_t </span><span style="font-weight:bold;color:#a71d5d;">**</span><span>argv)
</span><span>{
</span><span>  </span><span style="color:#62a35c;">wprintf</span><span>(</span><span style="font-weight:bold;color:#a71d5d;">L</span><span style="color:#183691;">"Hello</span><span style="color:#0086b3;">\n</span><span style="color:#183691;">"</span><span>);
</span><span>  </span><span style="font-weight:bold;color:#a71d5d;">return </span><span style="color:#0086b3;">0</span><span>;
</span><span>}
</span></code></pre>
<p>And in the <code>dune</code> file:</p>
<pre data-lang="dune" style="background-color:#ffffff;color:#323232;" class="language-dune "><code class="language-dune" data-lang="dune"><span>(</span><span style="font-weight:bold;color:#a71d5d;">executable
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">public_name</span><span> interactive)
</span><span> (modules interactive)
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">package</span><span> llama_interactive)
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">libraries</span><span> llama_interactive keyboard_helper)
</span><span> (foreign_stubs
</span><span>  (language c)
</span><span>  (names interactive_win)))
</span></code></pre>
<p>Testing it out:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s\llama&gt; dune exec .\examples\interactive.exe
</span><span>Done: 49% (96/194, 98 left) (jobs: 0)Hello
</span></code></pre>
<p>Nice, the linker error is gone. Obviously this just prints “Hello” and exits
without actually calling into any OCaml code. Now I just need to change the C
code to call into the original OCaml code:</p>
<pre data-lang="c" style="background-color:#ffffff;color:#323232;" class="language-c "><code class="language-c" data-lang="c"><span style="font-weight:bold;color:#a71d5d;">#include </span><span style="color:#183691;">&lt;wchar.h&gt;
</span><span style="font-weight:bold;color:#a71d5d;">#include </span><span style="color:#183691;">&lt;stdio.h&gt;
</span><span>
</span><span style="font-weight:bold;color:#a71d5d;">#define </span><span>CAML_INTERNALS
</span><span style="font-weight:bold;color:#a71d5d;">#include </span><span style="color:#183691;">"caml/misc.h"
</span><span style="font-weight:bold;color:#a71d5d;">#include </span><span style="color:#183691;">"caml/mlvalues.h"
</span><span style="font-weight:bold;color:#a71d5d;">#include </span><span style="color:#183691;">"caml/sys.h"
</span><span style="font-weight:bold;color:#a71d5d;">#include </span><span style="color:#183691;">"caml/callback.h"
</span><span>
</span><span style="font-weight:bold;color:#a71d5d;">int
</span><span style="font-weight:bold;color:#795da3;">wWinMain </span><span>(</span><span style="font-weight:bold;color:#a71d5d;">int </span><span>argc, wchar_t </span><span style="font-weight:bold;color:#a71d5d;">**</span><span>argv)
</span><span>{
</span><span>  caml_main(argv);
</span><span>  caml_do_exit(</span><span style="color:#0086b3;">0</span><span>);
</span><span>  </span><span style="font-weight:bold;color:#a71d5d;">return </span><span style="color:#0086b3;">0</span><span>;
</span><span>}
</span></code></pre>
<p>But then when I ran the example nothing happened. Adding print statements to the
OCaml code didn’t have any effect, and it looks like the program is exiting
somewhere inside <code>caml_main</code> with no error message.</p>
<p>Powershell provides exit codes of programs in the <code>$LastExitCode</code> variable:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS C:\Users\s\llama&gt; dune exec .\examples\interactive.exe
</span><span>Done: 100% (194/194, 0 left) (jobs: 0)
</span><span>PS C:\Users\s\llama&gt; $LastExitCode
</span><span>-1073741819
</span></code></pre>
<p>Converting to a 32-bit unsigned int assuming 2’s complement this is <code>0xC0000005</code>
which corresponds to an “Access Violation” which is similar to a segmentation
fault in the Unix world, so probably I’m doing something wrong with pointers.</p>
<p>For inspiration I took a look at the real OCaml <code>main</code> function defined
<a href="https://github.com/ocaml/ocaml/blob/trunk/runtime/main.c">here</a>.
There’s some Windows-specific parts that I was missing which I added.
I also realized I was using the wrong type for my <code>wWinMain</code> function so I
changed its arguments based on some Microsoft documentation I found. This meant
I needed to convert the Windows way of representing command-line arguments into
the Unix-style <code>argv</code> which OCaml presumably expects. I was running out of time so
instead I just generated a fake value for <code>argv</code>. Here’s the C program I ended up with:</p>
<pre data-lang="C" style="background-color:#ffffff;color:#323232;" class="language-C "><code class="language-C" data-lang="C"><span style="font-weight:bold;color:#a71d5d;">#include </span><span style="color:#183691;">&lt;wchar.h&gt;
</span><span style="font-weight:bold;color:#a71d5d;">#include </span><span style="color:#183691;">&lt;stdio.h&gt;
</span><span>
</span><span style="font-weight:bold;color:#a71d5d;">#define </span><span>CAML_INTERNALS
</span><span style="font-weight:bold;color:#a71d5d;">#include </span><span style="color:#183691;">"caml/misc.h"
</span><span style="font-weight:bold;color:#a71d5d;">#include </span><span style="color:#183691;">"caml/mlvalues.h"
</span><span style="font-weight:bold;color:#a71d5d;">#include </span><span style="color:#183691;">"caml/sys.h"
</span><span style="font-weight:bold;color:#a71d5d;">#include </span><span style="color:#183691;">"caml/osdeps.h"
</span><span style="font-weight:bold;color:#a71d5d;">#include </span><span style="color:#183691;">"caml/callback.h"
</span><span style="font-weight:bold;color:#a71d5d;">#include </span><span style="color:#183691;">&lt;windows.h&gt;
</span><span>
</span><span style="font-weight:bold;color:#a71d5d;">int </span><span style="color:#0086b3;">WINAPI </span><span style="font-weight:bold;color:#795da3;">wWinMain</span><span>(</span><span style="color:#0086b3;">HINSTANCE </span><span>hInstance, </span><span style="color:#0086b3;">HINSTANCE </span><span>hPrevInstance, </span><span style="color:#0086b3;">PWSTR </span><span>pCmdLine, </span><span style="font-weight:bold;color:#a71d5d;">int </span><span>nCmdShow) {
</span><span>  </span><span style="font-style:italic;color:#969896;">// fake argv for now since I don't know how to convert windows arguments to argv
</span><span>  char_os argv0[] </span><span style="font-weight:bold;color:#a71d5d;">= </span><span>{ (</span><span style="font-weight:bold;color:#a71d5d;">unsigned short int</span><span>)</span><span style="color:#183691;">'x'</span><span>, </span><span style="color:#0086b3;">0 </span><span>};
</span><span>  char_os</span><span style="font-weight:bold;color:#a71d5d;">**</span><span> argv </span><span style="font-weight:bold;color:#a71d5d;">= </span><span style="color:#62a35c;">malloc</span><span>(</span><span style="font-weight:bold;color:#a71d5d;">sizeof</span><span>(char_os</span><span style="font-weight:bold;color:#a71d5d;">*</span><span>) </span><span style="font-weight:bold;color:#a71d5d;">* </span><span style="color:#0086b3;">2</span><span>);
</span><span>  argv[</span><span style="color:#0086b3;">0</span><span>] </span><span style="font-weight:bold;color:#a71d5d;">=</span><span> argv0;
</span><span>  argv[</span><span style="color:#0086b3;">1</span><span>] </span><span style="font-weight:bold;color:#a71d5d;">= </span><span style="color:#0086b3;">NULL</span><span>; </span><span style="font-style:italic;color:#969896;">// ocaml probably uses a null terminator for its argv since there's no argc?
</span><span>  caml_main(argv);
</span><span>  caml_do_exit(</span><span style="color:#0086b3;">0</span><span>);
</span><span>  </span><span style="font-weight:bold;color:#a71d5d;">return </span><span style="color:#0086b3;">0</span><span>;
</span><span>}
</span></code></pre>
<p>And finally it works!</p>
<iframe width="560" height="315" src="https://www.youtube.com/embed/vS2qgKDK7y4?si=FNlN2OBef58aj_Nw" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen=""></iframe>
<p>Well it mostly works. There’s about a second of input latency which isn’t
there when I run it on Linux or MacOS, but at least it can now open a window and
get input from the keyboard and mouse.</p>
<p>That brings us to the end of the 2-day period I’ve allocated for working on
this project. Clearly <code>llama</code> is not ready for use in “production” on Windows but at
least I now know that it’s technically possible to make it work. All the
problems I worked around the past 2 days are not problems with <code>llama</code> itself
but various other packages in the OCaml ecosystem (at least <code>conf-ao</code> calling the wrong
<code>pkg-config</code> executable and missing Msys2 <code>depexts</code> and <code>ocamlfind</code> using the
wrong path delimiters on Windows). I’ll gradually work on upstreaming fixes to
these problems but in the meantime I’ll be playing my synthesizer on Unix
machines only.</p>
