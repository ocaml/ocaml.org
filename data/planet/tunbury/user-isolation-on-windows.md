---
title: User Isolation on Windows
description: "For a long time, we have struggled to match the performance and functionality
  of runc on Windows. Antonin wrote the Docker-based isolation for ocurrent/obuilder
  with PR#127, and I wrote machine-level isolation using QEMU PR#195. Sadly, the most
  obvious approach of using runhcs doesn\u2019t work, see issue#2156."
url: https://www.tunbury.org/2025/06/09/windows-sandbox/
date: 2025-06-09T00:00:00-00:00
preview_image: https://www.tunbury.org/images/sandbox.jpg
authors:
- Mark Elvers
source:
ignore:
---

<p>For a long time, we have struggled to match the performance and functionality of <code class="language-plaintext highlighter-rouge">runc</code> on Windows. Antonin wrote the Docker-based isolation for <a href="https://github.com/ocurrent/obuilder">ocurrent/obuilder</a> with <a href="https://github.com/ocurrent/obuilder/pull/127">PR#127</a>, and I wrote machine-level isolation using QEMU <a href="https://github.com/ocurrent/obuilder/pull/195">PR#195</a>. Sadly, the most obvious approach of using <code class="language-plaintext highlighter-rouge">runhcs</code> doesn’t work, see <a href="https://github.com/microsoft/hcsshim/issues/2156">issue#2156</a>.</p>

<p>On macOS, we use user isolation and ZFS mounts. We mount filesystems over <code class="language-plaintext highlighter-rouge">/Users/&lt;user&gt;</code> and <code class="language-plaintext highlighter-rouge">/usr/local/Homebrew</code> (or <code class="language-plaintext highlighter-rouge">/opt/Homebrew</code> on Apple Silicon). Each command is executed with <code class="language-plaintext highlighter-rouge">su</code>, then the filesystems are unmounted, and snapshots are taken before repeating the cycle. This approach has limitations, primarily because we can only run one job at a time. Firstly, the Homebrew location is per machine, and secondly, switches are not relocatable, so mounting as <code class="language-plaintext highlighter-rouge">/Users/&lt;another user&gt;</code> wouldn’t work.</p>

<p>In a similar vein, we could make user isolation work under Windows. On Windows, opam manages the Cygwin installation in <code class="language-plaintext highlighter-rouge">%LOCALAPPDATA%\opam</code>, so it feels like the shared HomeBrew limitation of macOS doesn’t exist, so can we create users with the same home directory? This isn’t as crazy as it sounds because Windows has drive letters, and right back to the earliest Windows networks I can remember (NetWare 3!), it was common practice for all users to have their home directory available as <code class="language-plaintext highlighter-rouge">H:\</code>. These days, it’s unfortunate that many applications <em>see through</em> drive letters and convert them to the corresponding UNC paths. Excel is particularly annoying as it does this with linked sheets, preventing administrators from easily migrating to a new file server, thereby invalidating UNC paths.</p>

<h1>Windows user isolation</h1>

<p>Windows drive mappings are per user and can be created using the command <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/subst">subst</a>. We might try to set the home directory and profile path when we create a user <code class="language-plaintext highlighter-rouge">net user foo bar /add /homedir:h:\ /profilepath:h:\</code>, but since <code class="language-plaintext highlighter-rouge">h:</code> does not exist in the user’s context, the user is given a temporary profile, which is lost when they log out. If you specify just <code class="language-plaintext highlighter-rouge">/homedir</code>, the profile is retained in <code class="language-plaintext highlighter-rouge">c:\users\foo</code>.</p>

<p>We could now try to map <code class="language-plaintext highlighter-rouge">h:</code> using <code class="language-plaintext highlighter-rouge">subst h: c:\cache\layer</code>, but <code class="language-plaintext highlighter-rouge">subst</code> drives don’t naturally persist between sessions. Alternatively, we could use <code class="language-plaintext highlighter-rouge">net use h: \\DESKTOP-BBBSRML\cache\layer /persistent:yes</code>.</p>

<p>Ultimately, the path where <code class="language-plaintext highlighter-rouge">%APPDATA%</code> is held must exist when the profile is loaded; it can’t be created as a result of loading the profile. Note that for a new user, the path doesn’t exist at all, but the parent directory where it will be created does exist. In Active Directory/domain environments, the profile and home paths are on network shares, one directory per user. These exist before the user signs in; all users can have <code class="language-plaintext highlighter-rouge">h:</code> mapped to their personal space.</p>

<p>Ultimately, it doesn’t matter whether we can redirect <code class="language-plaintext highlighter-rouge">%LOCALAPPDATA%</code> or not, as we can control the location opam uses by setting the environment variable <code class="language-plaintext highlighter-rouge">OPAMROOT</code>.</p>

<h1>opam knows</h1>

<p>Unfortunately, there’s no fooling opam. It sees through both <code class="language-plaintext highlighter-rouge">subst</code> and network drives and embeds the path into files like <code class="language-plaintext highlighter-rouge">opam\config</code>.</p>

<h2>subst</h2>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>subst h: c:<span class="se">\h</span>ome<span class="se">\f</span>oo
<span class="nb">set </span><span class="nv">OPAMROOT</span><span class="o">=</span>h:<span class="se">\o</span>pam
opam init <span class="nt">-y</span>
...

  In normal operation, opam only alters files within your opam root
    <span class="o">(</span>~<span class="se">\A</span>ppData<span class="se">\L</span>ocal<span class="se">\o</span>pam by default<span class="p">;</span> currently C:<span class="se">\h</span>ome<span class="se">\f</span>oo<span class="se">\o</span>pam<span class="o">)</span><span class="nb">.</span>

...
</code></pre></div></div>

<h2>net use</h2>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>net share <span class="nv">home</span><span class="o">=</span>c:<span class="se">\h</span>ome
net use h: <span class="se">\\</span>DESKTOP-BBBSRML<span class="se">\h</span>ome<span class="se">\f</span>oo /persistent:yes
SET <span class="nv">OPAMROOT</span><span class="o">=</span>h:<span class="se">\o</span>pam
opam init <span class="nt">-y</span>
...

  In normal operation, opam only alters files within your opam root
    <span class="o">(</span>~<span class="se">\A</span>ppData<span class="se">\L</span>ocal<span class="se">\o</span>pam by default<span class="p">;</span> currently UNC<span class="se">\D</span>ESKTOP-BBBSRML<span class="se">\h</span>ome<span class="se">\f</span>oo<span class="se">\o</span>pam<span class="o">)</span><span class="nb">.</span>

...
</code></pre></div></div>

<p>Unless David has some inspiration, I don’t know where to go with this.</p>

<p>Here’s an example from the Windows API.</p>

<div class="language-cpp highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="c1">// If you have: subst X: C:\SomeFolder</span>
<span class="n">QueryDosDevice</span><span class="p">(</span><span class="s">L"X:"</span><span class="p">,</span> <span class="n">buffer</span><span class="p">,</span> <span class="n">size</span><span class="p">);</span>  <span class="c1">// Returns: "C:\SomeFolder"</span>
<span class="n">GetCurrentDirectory</span><span class="p">();</span>                <span class="c1">// Returns: "X:\" (if current)</span>
</code></pre></div></div>

<h1>Windows Sandbox</h1>

<p>Windows has a new(?) feature called <em>Windows Sandbox</em> that I hadn’t seen before. It allows commands to be executed in a lightweight VM based on an XML definition. For example, a simple <code class="language-plaintext highlighter-rouge">test.wsb</code> would contain.</p>

<div class="language-xml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="nt">&lt;Configuration&gt;</span>
  <span class="nt">&lt;MappedFolders&gt;</span>
    <span class="nt">&lt;MappedFolder&gt;</span>
      <span class="nt">&lt;HostFolder&gt;</span>C:\home\foo\opam<span class="nt">&lt;/HostFolder&gt;</span>
      <span class="nt">&lt;SandboxFolder&gt;</span>C:\Users\WDAGUtilityAccount\AppData\Local\opam<span class="nt">&lt;/SandboxFolder&gt;</span>
      <span class="nt">&lt;ReadOnly&gt;</span>false<span class="nt">&lt;/ReadOnly&gt;</span>
    <span class="nt">&lt;/MappedFolder&gt;</span>
  <span class="nt">&lt;/MappedFolders&gt;</span>
<span class="nt">&lt;/Configuration&gt;</span>
</code></pre></div></div>

<p>The sandbox started quickly and worked well until I tried to run a second instance. The command returns an error stating that only one is allowed. Even doing <code class="language-plaintext highlighter-rouge">runas /user:bar "WindowsSandbox.exe test.wsb"</code> fails with the same error.</p>

<h1>Full circle</h1>

<p>I think this brings us back to Docker. I wrote the QEMU implementation because of Docker’s poor performance on Windows, coupled with the unreliability of OBuilder on Windows. However, I wonder if today’s use case means that it warrants a second look.</p>

<div class="language-powershell highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="c"># Install Docker Engine</span><span class="w">
</span><span class="n">Invoke-WebRequest</span><span class="w"> </span><span class="nt">-UseBasicParsing</span><span class="w"> </span><span class="s2">"https://download.docker.com/win/static/stable/x86_64/docker-28.2.2.zip"</span><span class="w"> </span><span class="nt">-OutFile</span><span class="w"> </span><span class="nx">docker.zip</span><span class="w">
</span><span class="n">Expand-Archive</span><span class="w"> </span><span class="nx">docker.zip</span><span class="w"> </span><span class="nt">-DestinationPath</span><span class="w"> </span><span class="s2">"C:\Program Files"</span><span class="w">
 </span><span class="n">Environment</span><span class="p">]::</span><span class="n">SetEnvironmentVariable</span><span class="p">(</span><span class="s2">"Path"</span><span class="p">,</span><span class="w"> </span><span class="nv">$</span><span class="nn">env</span><span class="p">:</span><span class="nv">Path</span><span class="w"> </span><span class="o">+</span><span class="w"> </span><span class="s2">";C:\Program Files\docker"</span><span class="p">,</span><span class="w"> </span><span class="s2">"Machine"</span><span class="p">)</span><span class="w">

</span><span class="c"># Start Docker service</span><span class="w">
</span><span class="n">dockerd</span><span class="w"> </span><span class="nt">--register-service</span><span class="w">
</span><span class="n">Start-Service</span><span class="w"> </span><span class="nx">docker</span><span class="w">
</span></code></pre></div></div>

<p>Create a simple <code class="language-plaintext highlighter-rouge">Dockerfile</code> and build the image using <code class="language-plaintext highlighter-rouge">docker build . -t opam</code>.</p>

<div class="language-dockerfile highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">FROM</span><span class="s"> mcr.microsoft.com/windows/servercore:ltsc2022</span>

<span class="c"># Download opam</span>
<span class="k">ADD</span><span class="s"> https://github.com/ocaml/opam/releases/download/2.3.0/opam-2.3.0-x86_64-windows.exe C:\\windows\\opam.exe</span>

<span class="k">RUN </span>net user opam /add /passwordreq:no

<span class="k">USER</span><span class="s"> opam</span>

<span class="c"># Run something as the opam user to create c:\\users\\opam</span>
<span class="k">RUN </span>opam <span class="nt">--version</span>

<span class="k">WORKDIR</span><span class="s"> c:\\users\\opam</span>

<span class="k">CMD</span><span class="s"> ["cmd"]</span>
</code></pre></div></div>

<p>Test with <code class="language-plaintext highlighter-rouge">opam init</code>.</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>docker run <span class="nt">--isolation</span><span class="o">=</span>process <span class="nt">--rm</span> <span class="nt">-it</span> <span class="nt">-v</span> C:<span class="se">\c</span>ache<span class="se">\t</span>emp<span class="se">\:</span>c:<span class="se">\U</span>sers<span class="se">\o</span>pam<span class="se">\A</span>ppData<span class="se">\L</span>ocal<span class="se">\o</span>pam opam:latest opam init <span class="nt">-y</span>
</code></pre></div></div>
