---
title: 'Verification for Dummies: SMT and Induction '
description: "Adrien Champion adrien.champion@ocamlpro.com\n This work is licensed
  under a Creative Commons Attribution-ShareAlike 4.0 International License. These
  posts broadly discusses induction as a formal verification technique, which here
  really means formal program verification. I will use concrete, runnabl..."
url: https://ocamlpro.com/blog/2021_10_14_verification_for_dummies_smt_and_induction
date: 2021-10-14T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    Adrien Champion\n  "
source:
---

<ul>
<li>Adrien Champion <a href="mailto:adrien.champion@ocamlpro.com">adrien.champion@ocamlpro.com</a>
</li>
<li><a href="http://creativecommons.org/licenses/by-sa/4.0/"></a> This work is licensed under a <a href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.
</li>
</ul>
<p>These posts broadly discusses <em>induction</em> as a <em>formal verification</em> technique, which here really means <em>formal program verification</em>. I will use concrete, runnable examples whenever possible. Some of them can run directly in a browser, while others require to run small easy-to-retrieve tools locally. Such is the case for pretty much all examples dealing directly with induction.</p>
<p>The next chapters discuss the following notions:</p>
<ul>
<li>formal logics and formal frameworks;
</li>
<li>SMT-solving: modern, <em>low-level</em> verification building blocks;
</li>
<li>declarative transition systems;
</li>
<li>transition system unrolling;
</li>
<li>BMC and induction proofs over transition systems;
</li>
<li>candidate strengthening.
</li>
</ul>
<p>The approach presented here is far from being the only one when it comes to program verification. It happens to be relatively simple to
understand, and I believe that familiarity with the notions discussed here makes understanding other approaches significantly easier.</p>
<p>This book thus hopes to serve both as a relatively deep dive into the specific technique of SMT-based induction, as well as an example of the technical challenges inherent to both developing and using automated proof engines.</p>
<p>Some chapters contain a few pieces of Rust code. Usually to provide a runnable version of a system under discussion, or to serve as example of actual code that we want to encode and verify. Some notions of Rust could definitely help in places, but this is not mandatory (probably).</p>
<p>Read more here: <a href="https://github.com/rust-lang/this-week-in-rust/pull/2479"></a><a href="https://ocamlpro.github.io/verification_for_dummies/">https://ocamlpro.github.io/verification_for_dummies/</a></p>

