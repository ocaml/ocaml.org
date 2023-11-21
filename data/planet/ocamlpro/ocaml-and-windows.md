---
title: OCaml and Windows
description: "Recently, I have been experimenting wiht OCaml / MSVC running on Windows
  7 64bit. I have mainly followed what the OCaml\u2019s README.win32 was saying and
  I learned some NSIS tricks. The result of this experiment is the following two (rather
  big) windows binaries : ocaml-trunk-64-installer.exe (92 MB)\n..."
url: https://ocamlpro.com/blog/2011_06_23_ocaml_and_windows
date: 2011-06-23T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Fabrice Le Fessant\n  "
source:
---

<p>Recently, I have been experimenting wiht OCaml / MSVC running on Windows 7 64bit. I have mainly followed what the <a href="http://caml.inria.fr/pub/distrib/ocaml-3.12/notes/README.win32">OCaml&rsquo;s README.win32</a> was saying and I learned some NSIS tricks. The result of this experiment is the following two (rather big) windows binaries :</p>
<ul>
<li><a href="http://ocamlpro.com//files/ocaml-trunk-64-installer.exe">ocaml-trunk-64-installer.exe</a> (92 MB)
</li>
<li><a href="http://ocamlpro.com//files/ocaml-3.12-64-installer.exe">ocaml-3.12-64-installer.exe</a> (92 MB)
</li>
</ul>
<p>These binaries are auto-installer for :</p>
<ul>
<li>the OCaml distribution (either the 3.12.1+rc1 version or trunk);
</li>
<li>Emacs (version 23.3) + tuareg mode (version 2.0.4);
</li>
<li>OCamlGraph (version 1.7) : this is just a little experiment with packaging external libraries.
</li>
</ul>
<p>Hopefully, all of this might be useful to some people, at least to people looking for an alternative to WinOcaml which seems to be broken. You should need no other dependencies if you just want to use the OCaml top-level (ocaml.exe). If you want to compile your project you will need MSVC installed and correctly set-up. If your project is using Makefiles then you should probably install cygwin as well. I can give more details if some people are interested.</p>
<p>Unfortunately, the current process for creating these binaries involves an awlful lot of manual steps (including switching for Windows Termninal to cygwin shell) and further, many OCaml packages won&rsquo;t install directly on windows (as most of them are using shell tricks to be configured correctly). I hope we will be able to release something cleaner in a later stage.</p>

