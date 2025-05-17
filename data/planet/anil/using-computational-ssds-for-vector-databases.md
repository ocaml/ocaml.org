---
title: Using computational SSDs for vector databases
description:
url: https://anil.recoil.org/ideas/computational-storage-for-vector-dbs
date: 2025-02-01T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<h1>Using computational SSDs for vector databases</h1>
<p>This is an idea proposed in 2025 as a Cambridge Computer Science Part III or MPhil project, and is <span class="idea-available">available</span> for being worked on. It may be co-supervised with <a href="https://toao.com" class="contact">Sadiq Jaffer</a>.</p>
<p>Large <a href="https://en.wikipedia.org/wiki/Foundation_model">pre-trained models</a> can be used to embed media/documents into concise vector representations with the property that vectors that are "close" to each other are semantically related. <a href="https://en.wikipedia.org/wiki/Nearest_neighbor_search">ANN</a> (Approximate Nearest Neighbour) search on these embeddings is used heavily already in <a href="https://blogs.nvidia.com/blog/what-is-retrieval-augmented-generation/">RAG</a> systems for LLMs or search-by-example for satellite imagery.</p>
<p>Right now, most ANN databases almost exclusively use memory-resident indexes to accelerate this searching. This is a showstopper for larger datasets, such as the terabytes of PDFs we have for our <a href="https://anil.recoil.org/projects/ce">big evidence synthesis</a> project, each of which generates dozens of embeddings. For global satellite datasets for <a href="https://anil.recoil.org/projects/rsn">remote sensing of nature</a> at 10m scale this is easily petabytes per year (the raw data here would need to come from tape drives).</p>
<p>The project idea is that <a href="https://www.xilinx.com/publications/product-briefs/xilinx-smartssd-computational-storage-drive-product-brief.pdf">computational storage devices</a> can add compute (via FPGAs) to the SSD controller and let us compute on the data <em>before</em> it reaches main-memory. Binary-quantisation of embedding vectors is now practical <sup><a href="https://anil.recoil.org/news.xml#fn-1" role="doc-noteref" class="fn-label">[1]</a></sup>, and so simple comparison of these should be quite amenable to acceleration with the SSD-attached FPGA. Since we're willing to tradeoff searching more vectors, each SSD only needs to have a lightweight index (potentially a flat IVF) shard. In a big storage array, every SSD could then return the small number of original (un-quantised) embeddings which were closest to the query points, and then the the CPU would do a fast final reranking step <sup><a href="https://anil.recoil.org/news.xml#fn-2" role="doc-noteref" class="fn-label">[2]</a></sup>.</p>
<p>Our hypothesis is that we could scale vector database size just by adding more SSDs, through both storage and aggregate disk throughput.
There are risks to overcome though: if the FPGAs on the SSD controllers dont have enough compute to keep up with the full SSD bandwidth, or we can't discard enough of a % of vectors via the on-disk index then we're memory bound without much gain. A key part of the solution is balancing out the memory vs SSD bandwidth carefully via some autotuning.
(e.g. if we have 4TB per SSD shard we have 9GBs of max bandwidth, so we'd need to discard 99.9% of the on-disk indexed vectors to get sub-second response times).</p>
<p>But if the experiment does succeed, we could get real-time sub-second responses time on massive datasets, which would be a game changer for interaction exploration of huge datasets.  A student more interested in the programming interface side may also wish to look over my <a href="https://anil.recoil.org/notes/fpgas-hardcaml">OCaml FPGA notes</a>.</p>
<section role="doc-endnotes"><ol>
<li>
<p>https://arxiv.org/abs/2405.12497</p>
<span><a href="https://anil.recoil.org/news.xml#ref-1-fn-1" role="doc-backlink" class="fn-label">↩︎︎</a></span></li><li>
<p>https://arxiv.org/abs/2106.00882</p>
<span><a href="https://anil.recoil.org/news.xml#ref-1-fn-2" role="doc-backlink" class="fn-label">↩︎︎</a></span></li></ol></section>

