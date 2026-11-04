---
title: Setting up a Macbook
description: A (partial) list of things I did
url: https://mort.io/blog/setup-new-laptop/
date: 2020-01-01T00:00:00-00:00
preview_image:
authors:
- Richard Mortier
source:
ignore:
keywords:
- brew
- grep
- homebrew
- install
- itunes
- karabiner
- macbook
- opam
- podcasts
- touchbar
---

<p>This is the set of things that I roughly did to set up my old new Macbook:
configurations, packages, etc. Not guaranteed complete, but hopefully captures
much of it.</p>
<h2><a href="https://mort.io/rss.xml#keyboard" class="zola-anchor" aria-label="Anchor link for: keyboard">Keyboard</a></h2>
<ul>
<li>Set the touchbar to expanded</li>
<li>Turn off various emacs conflicts (e.g., <code>S-M-6</code>)</li>
<li>Use <a href="https://karabiner-elements.pqrs.org/" rel="external">Karabiner Elements</a> to make
<code>CAPSLOCK</code> become <code>ESC</code> on a single press</li>
</ul>
<h2><a href="https://mort.io/rss.xml#homebrew-packages" class="zola-anchor" aria-label="Anchor link for: homebrew-packages">Homebrew packages</a></h2>
<ul>
<li>Install <a href="https://brew.sh/" rel="external">Homebrew</a> and then</li>
</ul>
<pre class="giallo z-code"><code data-lang="shellscript"><span class="giallo-l"><span class="z-3 z-i"># install packages</span></span>
<span class="giallo-l"><span class="z-1">brew</span><span class="z-2"> install</span><span class="z-8">                                    \</span></span>
<span class="giallo-l"><span class="z-2">  aspcud</span><span class="z-8">                                        \</span></span>
<span class="giallo-l"><span class="z-2">  aspell</span><span class="z-8">                                        \</span></span>
<span class="giallo-l"><span class="z-2">  bash-completion</span><span class="z-8">                               \</span></span>
<span class="giallo-l"><span class="z-2">  coreutils</span><span class="z-8">                                     \</span></span>
<span class="giallo-l"><span class="z-2">  direnv</span><span class="z-8">                                        \</span></span>
<span class="giallo-l"><span class="z-2">  emacs</span><span class="z-8">                                         \</span></span>
<span class="giallo-l"><span class="z-2">  evernote</span><span class="z-8">                                      \</span></span>
<span class="giallo-l"><span class="z-2">  ffmpeg</span><span class="z-8">                                        \</span></span>
<span class="giallo-l"><span class="z-2">  font-hack-nerd-font</span><span class="z-8">                           \</span></span>
<span class="giallo-l"><span class="z-2">  gawk</span><span class="z-8">                                          \</span></span>
<span class="giallo-l"><span class="z-2">  gcc</span><span class="z-8">                                           \</span></span>
<span class="giallo-l"><span class="z-2">  get_iplayer</span><span class="z-8">                                   \</span></span>
<span class="giallo-l"><span class="z-2">  ghostscript</span><span class="z-8">                                   \</span></span>
<span class="giallo-l"><span class="z-2">  git</span><span class="z-8">                                           \</span></span>
<span class="giallo-l"><span class="z-2">  git-lfs</span><span class="z-8">                                       \</span></span>
<span class="giallo-l"><span class="z-2">  gnupg2</span><span class="z-8">                                        \</span></span>
<span class="giallo-l"><span class="z-2">  gnuplot</span><span class="z-8">                                       \</span></span>
<span class="giallo-l"><span class="z-2">  gpg-agent</span><span class="z-8">                                     \</span></span>
<span class="giallo-l"><span class="z-2">  graphviz</span><span class="z-8">                                      \</span></span>
<span class="giallo-l"><span class="z-2">  imagemagick</span><span class="z-8">                                   \</span></span>
<span class="giallo-l"><span class="z-2">  jq</span><span class="z-8">                                            \</span></span>
<span class="giallo-l"><span class="z-2">  lua</span><span class="z-8">                                           \</span></span>
<span class="giallo-l"><span class="z-2">  mu</span><span class="z-8">                                            \</span></span>
<span class="giallo-l"><span class="z-2">  ncftp</span><span class="z-8">                                         \</span></span>
<span class="giallo-l"><span class="z-2">  nmap</span><span class="z-8">                                          \</span></span>
<span class="giallo-l"><span class="z-2">  ocaml</span><span class="z-8">                                         \</span></span>
<span class="giallo-l"><span class="z-2">  offlineimap</span><span class="z-8">                                   \</span></span>
<span class="giallo-l"><span class="z-2">  omnigraffle</span><span class="z-8">                                   \</span></span>
<span class="giallo-l"><span class="z-2">  opam</span><span class="z-8">                                          \</span></span>
<span class="giallo-l"><span class="z-2">  python</span><span class="z-8">                                        \</span></span>
<span class="giallo-l"><span class="z-2">  python@2</span><span class="z-8">                                      \</span></span>
<span class="giallo-l"><span class="z-2">  qemu</span><span class="z-8">                                          \</span></span>
<span class="giallo-l"><span class="z-2">  rcs</span><span class="z-8">                                           \</span></span>
<span class="giallo-l"><span class="z-2">  readline</span><span class="z-8">                                      \</span></span>
<span class="giallo-l"><span class="z-2">  rsync</span><span class="z-8">                                         \</span></span>
<span class="giallo-l"><span class="z-2">  socat</span><span class="z-8">                                         \</span></span>
<span class="giallo-l"><span class="z-2">  sshfs</span><span class="z-8">                                         \</span></span>
<span class="giallo-l"><span class="z-2">  telnet</span><span class="z-8">                                        \</span></span>
<span class="giallo-l"><span class="z-2">  tmux</span><span class="z-8">                                          \</span></span>
<span class="giallo-l"><span class="z-2">  unrar</span><span class="z-8">                                         \</span></span>
<span class="giallo-l"><span class="z-2">  wget</span></span></code></pre><pre class="giallo z-code"><code data-lang="shellscript"><span class="giallo-l"><span class="z-3 z-i"># install casks</span></span>
<span class="giallo-l"><span class="z-1">brew</span><span class="z-2"> tap homebrew/cask-versions</span></span>
<span class="giallo-l"><span class="z-1">brew</span><span class="z-2"> cask install</span><span class="z-8">                               \</span></span>
<span class="giallo-l"><span class="z-2">  adium</span><span class="z-8">                                         \</span></span>
<span class="giallo-l"><span class="z-2">  disk-inventory-x</span><span class="z-8">                              \</span></span>
<span class="giallo-l"><span class="z-2">  docker</span><span class="z-8">                                        \</span></span>
<span class="giallo-l"><span class="z-2">  dropbox</span><span class="z-8">                                       \</span></span>
<span class="giallo-l"><span class="z-2">  emacs</span><span class="z-8">                                         \</span></span>
<span class="giallo-l"><span class="z-2">  evernote</span><span class="z-8">                                      \</span></span>
<span class="giallo-l"><span class="z-2">  font-hack-nerd-font</span><span class="z-8">                           \</span></span>
<span class="giallo-l"><span class="z-2">  get-iplayer-automator</span><span class="z-8">                         \</span></span>
<span class="giallo-l"><span class="z-2">  google-backup-and-sync</span><span class="z-8">                        \</span></span>
<span class="giallo-l"><span class="z-2">  google-drive-file-stream</span><span class="z-8">                      \</span></span>
<span class="giallo-l"><span class="z-2">  gpodder</span><span class="z-8">                                       \</span></span>
<span class="giallo-l"><span class="z-2">  inkscape</span><span class="z-8">                                      \</span></span>
<span class="giallo-l"><span class="z-2">  iterm2</span><span class="z-8">                                        \</span></span>
<span class="giallo-l"><span class="z-2">  karabiner-elements</span><span class="z-8">                            \</span></span>
<span class="giallo-l"><span class="z-2">  keepingyouawake</span><span class="z-8">                               \</span></span>
<span class="giallo-l"><span class="z-2">  keybase</span><span class="z-8">                                       \</span></span>
<span class="giallo-l"><span class="z-2">  mactex</span><span class="z-8">                                        \</span></span>
<span class="giallo-l"><span class="z-2">  mp3tag</span><span class="z-8">                                        \</span></span>
<span class="giallo-l"><span class="z-2">  musicbrainz-picard</span><span class="z-8">                            \</span></span>
<span class="giallo-l"><span class="z-2">  omnigraffle6</span><span class="z-8">                                  \</span></span>
<span class="giallo-l"><span class="z-2">  onedrive</span><span class="z-8">                                      \</span></span>
<span class="giallo-l"><span class="z-2">  osxfuse</span><span class="z-8">                                       \</span></span>
<span class="giallo-l"><span class="z-2">  sharepod</span><span class="z-8">                                      \</span></span>
<span class="giallo-l"><span class="z-2">  signal</span><span class="z-8">                                        \</span></span>
<span class="giallo-l"><span class="z-2">  slack</span><span class="z-8">                                         \</span></span>
<span class="giallo-l"><span class="z-2">  vlc</span></span></code></pre><pre class="giallo z-code"><code data-lang="shellscript"><span class="giallo-l"><span class="z-1">git</span><span class="z-2"> lfs install</span><span class="z-8"> --system</span><span class="z-3 z-i"> # enable `git-lfs` system-wide</span></span>
<span class="giallo-l"><span class="z-1">mu</span><span class="z-2"> index</span><span class="z-8"> --rebuild</span><span class="z-3 z-i"> # rebuild `mu` index</span></span>
<span class="giallo-l"><span class="z-1">opam</span><span class="z-2"> init</span><span class="z-3 z-i"> # initialise `opam`</span></span></code></pre><h2><a href="https://mort.io/rss.xml#podcasts" class="zola-anchor" aria-label="Anchor link for: podcasts">Podcasts</a></h2>
<ul>
<li>Extract  RSS feeds from iTunes:</li>
</ul>
<pre class="giallo z-code"><code data-lang="shellscript"><span class="giallo-l"><span class="z-1">grep</span><span class="z-2"> Location Library.xml</span><span class="z-5"> |</span><span class="z-1"> sed</span><span class="z-2"> 's/[[:space:]]//g'</span><span class="z-5"> |</span><span class="z-1"> sort</span><span class="z-5"> |</span><span class="z-8"> \</span></span>
<span class="giallo-l"><span class="z-1">  grep</span><span class="z-8"> -iv</span><span class="z-2"> "\.\(mp[34]\|m4[av]\)"</span><span class="z-5"> |</span><span class="z-1"> grep</span><span class="z-2"> http</span><span class="z-5"> |</span><span class="z-1"> cut</span><span class="z-8"> -b</span><span class="z-2"> 28-</span><span class="z-5"> |</span><span class="z-8"> \</span></span>
<span class="giallo-l"><span class="z-1">  cut</span><span class="z-8"> -f</span><span class="z-9"> 1</span><span class="z-8"> -d</span><span class="z-2">"&lt;"</span><span class="z-5"> &gt;</span><span class="z-2"> PODCAST.URLS</span></span></code></pre><h2><a href="https://mort.io/rss.xml#ocal" class="zola-anchor" aria-label="Anchor link for: ocal"></a><a href="https://github.com/mor1/ocal" rel="external">OCal</a></h2>
<pre class="giallo z-code"><code data-lang="shellscript"><span class="giallo-l"><span class="z-1">opam</span><span class="z-2"> install</span><span class="z-8"> -y</span><span class="z-2"> ocal</span></span></code></pre>
