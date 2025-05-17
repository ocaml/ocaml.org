---
title: A DSL for decentralised identity in OCaml
description:
url: https://anil.recoil.org/ideas/dsl-for-decentralised-id
date: 2022-08-01T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<h1>A DSL for decentralised identity in OCaml</h1>
<p>This is an idea proposed in 2022 as a Cambridge Computer Science Part II project, and has been <span class="idea-completed">completed</span> by <a href="https://www.linkedin.com/in/michal-mgeladze-arciuch" class="contact">Michał Mgeładze-Arciuch</a>. It was co-supervised with <a href="https://patrick.sirref.org" class="contact">Patrick Ferris</a>.</p>
<p>There are currently multiple identity providers without direct incentives to
cooperate. This leads to many redundant implementations of the identity
handling logic, many of which are not immediately compatible with each other,
leading to additional increases in friction when eventual agreement needs to be
reached to perform user actions.  Furthermore, from the perspective of the user
of the identity service, they need to keep track of identity documents from
multiple sources, which leads to more security attack surface.</p>
<p>Solving the problem of partial identity proofs allows for many possible
opportunities. For example, consider a simple May Ball ticketing system in
which every college member gets a discount to their College, but without
revealing their exact identity. Or imagine an e-commerce system, in which every
user could prove their age to be over a given threshold, without revealing any
additional information to the retailer.  In the example of a carbon credits
project, we would be able to allow entities associated with any carbon
offsetting project to prove their association, protecting the identity of
whistleblowers.</p>
<p>This project will build a system of Decentralised Digital Identifiers, which
can be used to prove a subset of the information associated with the user’s
identity using cryptographic proofs. Every participant in
the system will have a public-private key pair associated with them. Then any
identity provider P could provide an identity document for Alice, who has a
public key A, by cryptographically signing a message containing both A, to
point to the receiver of this document, and the document itself. Then, whenever
Alice would want to authenticate herself to a service provider S, she could do
so simply by sending the message she received from P to S. Then the service
provider can verify that P, indeed supplied Alice with the given identity
document.</p>
<p>This Part II project was successfully completed but not available online; please
contact the author for a copy of it. <a href="https://www.linkedin.com/in/michal-mgeladze-arciuch" class="contact">Michał Mgeładze-Arciuch</a> has subsequently founded <a href="https://www.czechtradeoffices.com/se/news/czech-startup-yoneda-labs-raises-over-$100-million-to-revolutionize-chemical-reactions-with-ai">Yoneda
Labs to revolutionize chemical
reactions</a>!</p>

