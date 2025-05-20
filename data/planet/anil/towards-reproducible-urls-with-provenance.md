---
title: Towards reproducible URLs with provenance
description:
url: https://anil.recoil.org/ideas/urls-with-provenance
date: 2024-08-01T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
ignore: true
---

<h1>Towards reproducible URLs with provenance</h1>
<p>This is an idea proposed in 2024 as a Cambridge Computer Science Part II project, and is <span class="idea-available">available</span> for being worked on. It may be co-supervised with <a href="https://patrick.sirref.org" class="contact">Patrick Ferris</a>.</p>
<p>Vurls are an attempt to add versioning to URI resolution. For example, what should happen when we request <code>https://doi.org/10.1109/SASOW.2012.14</code> and how do we track the chain of events that leads to an answer coming back?  The prototype <a href="https://github.com/quantifyearth/vurl">vurl</a> library written in OCaml outputs the following:</p>
<pre><code class="language-ocaml"># Eio_main.run @@ fun env -&gt;
  Vurl_eio.with_default ~net:env#net env#cwd @@ fun () -&gt;
  let vurl = Vurl.of_uri "https://doi.org/10.1109/SASOW.2012.14" in
  let vurl, file = Vurl.file vurl in
  Vurl.pp Format.std_formatter vurl;;

{
  "intentional_uri": "https://doi.org/10.1109/SASOW.2012.14",
  "segments": [
    {
      "uri": "file:./_data/document-6498375",
      "cid": "bag5qgeraipjyvov4axsmb4pktfhmleqi4oc2lno5if6f6wjyq37w4ktncvxq"
    },
    {
      "uri": "https://ieeexplore.ieee.org/document/6498375/",
      "cid": "bag5qgeraipjyvov4axsmb4pktfhmleqi4oc2lno5if6f6wjyq37w4ktncvxq"
    },
    {
      "uri": "http://ieeexplore.ieee.org/document/6498375/",
      "cid": "bag5qgerap5iaobunfnlovfzv4jeq2ygp6ltszlrreaskyh3mseky5osh2boq"
    }
  ]
}
</code></pre>
<p>The <code>intentional_uri</code> is the original URI, and the <code>segments</code> are the different versions of the document as tracked through HTTP redirects and so on. The <code>cid</code> is a content identifier tgat is a hash of the content retrieved in that snapshot. The <code>file</code> is the local file that the URI resolves to.</p>
<p>This project will build on the vurl concept to build a practical implementation that integrates it into a popular HTTP library (in any language, but Python or OCaml are two good starts), and also builds a simple proxy service that can be used to resolve these URLs. The web service should be able to take a normal url and return the content of the URL at that point in time, and also return a vurl representing the complete state of the protocol traffic, and also be able to take a vurl and return the diff between two versions of the content.</p>
<p>Once successful, the project could also explore what more compact representations of the vurls would look like, and how to integrate them into existing web infrastructure.</p>
<h2>Related reading</h2>
<ul>
<li><a href="https://github.com/quantifyearth/vurl">https://github.com/quantifyearth/vurl</a> has some prototype code.</li>
<li><a href="https://anil.recoil.org/papers/2024-uncertainty-cs">Uncertainty at scale: how CS hinders climate research</a> has relevant background reading on some of the types of diffs that would be useful in a geospatial context.</li>
<li><a href="https://anil.recoil.org/papers/2024-planetary-computing">Planetary computing for data-driven environmental policy-making</a> covers the broader data processing pipelines we need to integrate into.</li>
</ul>

