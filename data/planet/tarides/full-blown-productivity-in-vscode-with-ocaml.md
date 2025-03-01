---
title: Full blown productivity in VSCode with OCaml
description: More features for ocaml-lsp that enhance productivity when writing OCaml.
url: https://tarides.com/blog/2025-02-28-full-blown-productivity-in-vscode-with-ocaml
date: 2025-02-28T00:00:00-00:00
preview_image: https://tarides.com/blog/images/adopt_ocaml-1360w.webp
authors:
- Tarides
source:
---

<p>Happy New Year, OCamlers! 🎉
As we usher in another year, we have something special to celebrate — a New Year's gift that promises to make your coding experience even better!
We have been working on exciting new features in VSCode designed to boost productivity, streamline workflows, and make your development journey smoother and more enjoyable.</p>
<p>For users of Emacs, we have a brand new <code>emacs</code> mode for interacting with the <code>lsp</code> server that will make your coding experience as enjoyable as it should be. Check out the Discuss announcement at <a href="https://discuss.ocaml.org/t/ann-release-of-ocaml-eglot-1-0-0/15978">Release of ocaml-eglot 1.0.0</a> and the project repository at <a href="https://github.com/tarides/ocaml-eglot">ocaml-eglot</a>.</p>
<p>Without further ado, let's "unwrap" 🎁 these features for your viewing pleasure.</p>
<h2>1. Type of Selection</h2>
<p>This feature enhances code comprehension by allowing you to grow or shrink the selection to view updated types at different levels of granularity. You can adjust the verbosity of the type information to suit your needs, providing either a concise or detailed view. This information can be accessed conveniently through the default hover pop-up or via a dedicated output panel, making it adaptable to your workflow.</p>
<h4>Command name: <code>Get the Type of the Selection</code></h4>
<ul>
<li>Command shortcut: <kbd>Alt</kbd> + <kbd>T</kbd></li>
<li>Grow Selection: continously press <kbd>Alt</kbd> + <kbd>T</kbd></li>
<li>Shrink Selection: <kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>T</kbd></li>
<li>Add Verbosity: <kbd>Alt</kbd> + <kbd>V</kbd></li>
</ul>
<p><img src="https://tarides.com/blog/images/2024-12-20.vscode-client-imp/type_selection_1~nODG6ymRfc2mc4ZQtkJf2Q.gif" alt="Using Alt+T to get the type of Selection"></p>
<h4>Using a dedicated Output Panel</h4>
<p>In the settings/preferences of the ocaml platform extension, you can toggle an option to display the results of type selection in a dedicated output panel.</p>
<p><img src="https://tarides.com/blog/images/2024-12-20.vscode-client-imp/type_selection-1360w~Dcz5VUnRGC2KGPr3U6pfSQ.webp" sizes="(min-width: 1360px) 1360px, (min-width: 680px) 680px, 100vw" srcset="/blog/images/2024-12-20.vscode-client-imp/type_selection-170w~0mHCNot-22a78rMDi_48fg.webp 170w, /blog/images/2024-12-20.vscode-client-imp/type_selection-340w~zudMAcXKrK0cc0j-PXWGUw.webp 340w, /blog/images/2024-12-20.vscode-client-imp/type_selection-680w~8WrShq3--GO0vBCffhJEug.webp 680w, /blog/images/2024-12-20.vscode-client-imp/type_selection-1360w~Dcz5VUnRGC2KGPr3U6pfSQ.webp 1360w" alt="Toggling the settings to use a dedicated output panel"></p>
<p><img src="https://tarides.com/blog/images/2024-12-20.vscode-client-imp/type_of_selection_3b~BtFhS-dRVmx4NPFyWjDUaA.gif" alt="Type Selection with results displayed in a dedicated output panel"></p>
<h2>2. Search by Type or Polarity</h2>
<p>Looking for functions or values that match a specific type?
The Search by Type/Polarity feature let's you input a type signature, e.g., <code>int -&gt; string</code> or a polarity <code>-int +string</code>, and then it fetches all matching functions and values across your project.</p>
<h4>Command name: <code>Search a value by type or polarity</code></h4>
<h4>Command shortcut: <kbd>Alt</kbd> + <kbd>F</kbd></h4>
<ul>
<li>
<p>Search by Type
<img src="https://tarides.com/blog/images/2024-12-20.vscode-client-imp/search_type~s5VxdelITfYqJqahXF6RQQ.gif" alt="Searching a value by it's type"></p>
</li>
<li>
<p>Search by Polarity
<img src="https://tarides.com/blog/images/2024-12-20.vscode-client-imp/search_polarity~02LYdhV2T5U9cI-9Z9-MmA.gif" alt="Searching a value by it's polarity"></p>
</li>
</ul>
<h2>3. Construct Typed Holes</h2>
<p>This feature let's you construct possible values for a given typed hole.</p>
<h4>Command name: <code>List values that can fill the selected typed-hole</code></h4>
<h4>Command shortcut: <kbd>Alt</kbd> + <kbd>C</kbd></h4>
<p><img src="https://tarides.com/blog/images/2024-12-20.vscode-client-imp/construct_1~ydYDYFSZlpuoII028UnGbA.gif" alt="Construct functionality to list values that can fill the selected typed-hole"></p>
<p>This feature also comes with a configurable option that allows it to construct values for the next typed hole automatically.</p>
<p><img src="https://tarides.com/blog/images/2024-12-20.vscode-client-imp/construct_toggle-1360w~FGhUKQXnEJ6txwIPDG7h7g.webp" sizes="(min-width: 1360px) 1360px, (min-width: 680px) 680px, 100vw" srcset="/blog/images/2024-12-20.vscode-client-imp/construct_toggle-170w~0pHX-bkvKZ7qM2Xjy97ijw.webp 170w, /blog/images/2024-12-20.vscode-client-imp/construct_toggle-340w~FdpeQlwrx335I9C08Lm45Q.webp 340w, /blog/images/2024-12-20.vscode-client-imp/construct_toggle-680w~R0X33zINWjQlLt0AHfwwaQ.webp 680w, /blog/images/2024-12-20.vscode-client-imp/construct_toggle-1360w~FGhUKQXnEJ6txwIPDG7h7g.webp 1360w" alt="Setting to toggle construct to be conducted for the next typed hole automatically"></p>
<p><img src="https://tarides.com/blog/images/2024-12-20.vscode-client-imp/construct_2~Zkwc5CmvowlxRa5V5CyhcA.gif" alt="Performing construct with chaining turned on"></p>
<h2>4. Jump to a specific Target</h2>
<p>Traditional navigation, while it works, falls short when it comes to navigation in OCaml. This feature provides a seamless way to jump to specific targets which are closest to your cursor in the source code. For example, a large match construct and you could jump from one case to the next effortlesly.</p>
<h4>Command name: <code>List possible parent targets for jumping</code></h4>
<h4>Command shortcut: <kbd>Alt</kbd> + <kbd>J</kbd></h4>
<p>At this point, we support the following targets:</p>
<ul>
<li>Modules</li>
<li>Functions</li>
<li>Let statements</li>
<li>Match statements</li>
<li>Match cases (previous and next)</li>
</ul>
<p><img src="https://tarides.com/blog/images/2024-12-20.vscode-client-imp/jump_highlight_5~OrqDUTlXj0HmBEs1WgOrAQ.gif" alt="Jumping to a specific target"></p>
<h2>5. Navigate Typed Holes</h2>
<p>This feature let's you navigate to typed holes.</p>
<h4>Command name: <code>List typed holes in the file for navigation</code></h4>
<ul>
<li>As you move through the list with your arrow keys, the cursor jumps to the typed hole to give you a preview.
When you make a selection, the cursor stays there.</li>
</ul>
<p><img src="https://tarides.com/blog/images/2024-12-20.vscode-client-imp/navigate_hole_1~OuZBRz-KX1UKkuRFpC8rOA.gif" alt="Navigating to different typed holes"></p>
<ul>
<li>If you toggle the Navigate</li>
</ul>
<p><img src="https://tarides.com/blog/images/2024-12-20.vscode-client-imp/construct_after_navigate_toggle-1360w~JBmIXiZygSnYiNEDYnqapg.webp" sizes="(min-width: 1360px) 1360px, (min-width: 680px) 680px, 100vw" srcset="/blog/images/2024-12-20.vscode-client-imp/construct_after_navigate_toggle-170w~lmUy6HxuVJA0mZeP_PwJ_g.webp 170w, /blog/images/2024-12-20.vscode-client-imp/construct_after_navigate_toggle-340w~J5RRJ0cxVlemPMQ-QXdZTA.webp 340w, /blog/images/2024-12-20.vscode-client-imp/construct_after_navigate_toggle-680w~GajjBOXyazwr4VsZf0w0cg.webp 680w, /blog/images/2024-12-20.vscode-client-imp/construct_after_navigate_toggle-1360w~JBmIXiZygSnYiNEDYnqapg.webp 1360w" alt="Setting to automatically perform construct after jumping to a typed hole"></p>
<p><img src="https://tarides.com/blog/images/2024-12-20.vscode-client-imp/navigate_hole_2~Nda3owocXy-BCDPrSWwqxQ.gif" alt="Automatically performing construct after navigating to a typed hole"></p>
<ul>
<li>If you don't feel like jumping to a typed hole yet, just hit <kbd>Esc</kbd> and your cursor will portal back to it's original position.</li>
</ul>
<p><img src="https://tarides.com/blog/images/2024-12-20.vscode-client-imp/navigate_hole_3~kwJYeOUQwp-Mp-leqMEQXA.gif" alt="Pressing the Escape key to stop operations and return back to the origin cursor position"></p>
<p>Hope you are excited to try out these new features. It is our wish that you have a much better and smoother experience while coding OCaml in VsCode.</p>
<p>Please feel free to open issues if you discover a problematic behaviour:</p>
<ul>
<li><a href="https://github.com/ocamllabs/vscode-ocaml-platform/issues">Issues for VSCode OCaml Platform Extension</a></li>
<li><a href="https://github.com/ocaml/ocaml-lsp/issues">Issues for OCaml LSP Server</a></li>
<li><a href="https://github.com/ocaml/merlin/issues">Issues for Merlin</a></li>
</ul>
<p>You can connect with Tarides on <a href="https://bsky.app/profile/tarides.com">Bluesky</a>, <a href="https://mastodon.social/@tarides">Mastodon</a>, <a href="https://www.threads.net/@taridesltd">Threads</a>, and <a href="https://www.linkedin.com/company/tarides">LinkedIn</a> or sign up for our mailing list to stay updated on our latest projects. We look forward to hearing from you!</p>

