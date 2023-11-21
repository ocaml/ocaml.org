---
title: "Statically guaranteeing security properties on Java bytecode: Paper presentation
  at VMCAI\_23"
description: We are excited to announce that Nicolas will present a paper at the International
  Conference on Verification, Model Checking, and Abstract Interpretation (VMCAI)
  the 16th and 17th of January. This year, VMCAI is co-located with the Symposium
  on Principles of Programming Languages (POPL) conference, ...
url: https://ocamlpro.com/blog/2023_01_12_vmcai_popl
date: 2023-01-12T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Nicolas Berthier\n  "
source:
---

<p></p>
<p>We are excited to announce that Nicolas will present a paper at the <a href="https://popl23.sigplan.org/home/VMCAI-2023">International Conference on Verification, Model Checking, and Abstract Interpretation (VMCAI)</a> the 16th and 17th of January.</p>
<p>This year, VMCAI is co-located with the <a href="https://popl23.sigplan.org/">Symposium on Principles of Programming Languages (POPL)</a> conference, which, as its name suggests, is a flagship conference in the Programming Languages domain.</p>
<p>What's more, for its 50th anniversary edition, POPL will return back where its first edition took place: Boston!
It is thus in the vicinity of the MIT and Harvard that we will meet with prominent figures of computer science research.</p>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/popl2023.jpg">
      <img src="https://ocamlpro.com/blog/assets/img/popl2023.jpg" alt="This paper will be presented at VMCAI'2023, colocated with POPL'2023 at Boston!"/>
    </a>
    </p><div class="caption">
      This paper will be presented at VMCAI'2023, colocated with POPL'2023 at Boston!
    </div>
  
</div>


<h2>A sound technique to statically guarantee security properties on Java bytecode</h2>
<p>Nicolas will be presenting a novel static program analysis technique dedicated to the discovery of information flows in Java bytecode.
By automatically discovering such flows, the new technique allows developers and users of Java libraries to assess key security properties on the software they run.</p>
<p>Two prominent examples of such properties are <em>confidentiality</em> (stating that no single bit of secret information may be inadvertently revealed by the software), and its dual, <em>integrity</em> (stating that no single bit of trusted information may be tampered via untrusted data).</p>
<p>The technique is proven <em>sound</em> (i.e. it cannot miss a flow of information), and achieves <em>state-of-the-art precision</em> (i.e. it does not raise too many false alarms) according to evaluations using the <a href="https://pp.ipd.kit.edu/uploads/publikationen/ifspec18nordsec.pdf">IFSpec benchmark suite</a>.</p>
<h2>Try it out!</h2>
<p>In addition to being supported by a proof, the technique has also been implemented in a tool called <a href="http://nberth.space/symmaries">Guardies</a>.</p>
<p>We believe this static analysis tool will naturally complement the taint tracking and dynamic analysis techniques that are usually employed to assess software security.</p>
<h2>Reading more about it</h2>
<p>You may already access the full paper <a href="https://arxiv.org/abs/2211.03450">here</a>.</p>
<p>Nicolas developed this contribution while working at the University of Liverpool, in collaboration with Narges Khakpour, herself from the University of Newcastle.</p>

