---
title: OCamlbuild support in Chamo
description: 'The Chamo editor now includes some ocamlbuild support through the internal
  command "ocaml_build": An ocamlbuild command is proposed to the u...'
url: https://ocameleon.blogspot.com/2008/04/ocamlbuild-support-in-chamo.html
date: 2008-04-30T14:33:00-00:00
preview_image: //2.bp.blogspot.com/_RT8DPiBmxGY/SBiIKhuVATI/AAAAAAAAAAM/WBh5pChCVHw/w1200-h630-p-k-no-nu/ocamlbuild_asks.png
featured:
authors:
- Zoggy
---

The Chamo editor now includes some ocamlbuild support through the internal command &quot;ocaml_build&quot;: An ocamlbuild command is proposed to the user who can edit it and run it.<br/><br/><a href="http://2.bp.blogspot.com/_RT8DPiBmxGY/SBiIKhuVATI/AAAAAAAAAAM/WBh5pChCVHw/s1600-h/ocamlbuild_asks.png" onblur="try {parent.deselectBloggerImageGracefully();} catch(e) {}"><img src="http://2.bp.blogspot.com/_RT8DPiBmxGY/SBiIKhuVATI/AAAAAAAAAAM/WBh5pChCVHw/s320/ocamlbuild_asks.png" style="margin: 0pt 10px 10px 0pt; float: left; cursor: pointer;" alt="" border="0"/></a><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>The output of the command is displayed in a new &quot;outputs&quot; window, and is analyzed. In case of error (or warning considered as error), the editor displays, in the active view, the file where the error was found, and highlights the corresponding characters.<br/><br/><div style="text-align: center;"><a href="http://3.bp.blogspot.com/_RT8DPiBmxGY/SBiIcxuVAUI/AAAAAAAAAAU/Y6lbWsiazv4/s1600-h/ocamlbuild_error.png" onblur="try {parent.deselectBloggerImageGracefully();} catch(e) {}"><img src="http://3.bp.blogspot.com/_RT8DPiBmxGY/SBiIcxuVAUI/AAAAAAAAAAU/Y6lbWsiazv4/s320/ocamlbuild_error.png" style="margin: 0pt 10px 10px 0pt; float: left; cursor: pointer;" alt="" border="0"/></a><br/></div><br/><br/><br/><br/><br/><br/><br/><br/>The command used to compile is kept associated to the file, so that it is proposed the next time the internal command &quot;ocaml_build&quot; is launch on the file. These associations are even stored on disk to be kept between two sessions of Chamo launched in the same directory.
