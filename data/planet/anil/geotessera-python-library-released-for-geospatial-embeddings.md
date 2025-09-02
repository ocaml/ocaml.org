---
title: GeoTessera Python library released for geospatial embeddings
description:
url: https://anil.recoil.org/notes/geotessera-python
date: 2025-08-31T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
ignore:
---

<p>We've been having great fun at the <a href="https://www.cst.cam.ac.uk/research/eeg">EEG</a>
recently releasing embeddings of
our new <a href="https://github.com/ucam-eo/tessera">TESSERA</a> geospatial foundation
model.</p>
<blockquote>
<p>TESSERA is a foundation model for Earth observation that processes Sentinel-1
and Sentinel-2 satellite data to generate representation (embedding) maps. It
compresses a full year of Sentinel-1 and Sentinel-2 data and learns useful
temporal-spectral features.
<cite>-- <a href="https://github.com/ucam-eo/tessera">Temporal Embeddings of Surface Spectra for Earth Representation and Analysis</a></cite></p>
</blockquote>
<p>A <a href="https://en.wikipedia.org/wiki/Foundation_model">foundation model</a> is
designed to be used for downstream tasks without having to retrain a full model
for every individual task. Our <a href="https://anil.recoil.org/papers/2025-tessera">preprint paper</a>
describes what sorts of geospatial tasks you can solve more quickly, ranging from crop
type classification, forest canopy height estimation, above-ground biomass
calculations, wildfire detection, forest stocks, and many more.</p>
<p><a href="https://anil.recoil.org/images/tessera-f1.webp"> </a></p><figure class="image-center"><a href="https://anil.recoil.org/images/tessera-f1.webp"><img src="https://anil.recoil.org/images/tessera-f1.webp" alt="Parametric UMAP false colour visualisation of TESSERA embeddings for Cambridgeshire" title="Parametric UMAP false colour visualisation of TESSERA embeddings for Cambridgeshire" loading="lazy" srcset="/images/tessera-f1.1024.webp 1024w,/images/tessera-f1.1280.webp 1280w,/images/tessera-f1.1440.webp 1440w,/images/tessera-f1.1600.webp 1600w,/images/tessera-f1.320.webp 320w,/images/tessera-f1.480.webp 480w,/images/tessera-f1.640.webp 640w,/images/tessera-f1.768.webp 768w" sizes="(max-width: 768px) 100vw, 33vw" class="content-image"><figcaption>Parametric UMAP false colour visualisation of TESSERA embeddings for Cambridgeshire</figcaption></a></figure><a href="https://anil.recoil.org/images/tessera-f1.webp"> </a><p></p>
<p>TESSERA is an open model that is trained only on public satellite data (thanks
<a href="https://www.esa.int/Applications/Observing_the_Earth/Copernicus/The_Sentinel_missions">ESA</a>!),
and we make tiled embeddings available for download that have 128-dimensional
vectors precomputed for every 10m<sup>2</sup> surface of the planet. This makes using
TESSERA really simple in existing GIS workflows.</p>
<h2><a href="https://anil.recoil.org/news.xml#taking-the-geotessera-cli-for-a-spin" class="anchor" aria-hidden="true"></a>Taking the GeoTessera CLI for a spin</h2>
<p>To make it even simpler, I've just <a href="https://pypi.org/project/geotessera/0.5.1/">published</a> a new Python library called
<a href="https://github.com/ucam-eo/geotessera">geotessera</a> which provides a
programmatic and CLI interface to accessing these.</p>
<figure class="image-center"><img src="https://raw.githubusercontent.com/ucam-eo/tessera-coverage-map/refs/heads/main/geotessera.gif"></figure>
<p>The full set of TESSERA embeddings are petabytes when generated<sup><a href="https://anil.recoil.org/news.xml#fn-1" role="doc-noteref" class="fn-label">[1]</a></sup>, so it's important that you download just the ones
you need for a given region of interest. We chunked up the embeddings into image tiles where each pixel represents a 10m<sup>2</sup> are, and are hosting these at the Computer Lab on <a href="https://dl.geotessera.org">dl.geotessera.org</a>.<sup><a href="https://anil.recoil.org/news.xml#fn-2" role="doc-noteref" class="fn-label">[2]</a></sup> Geotessera uses <a href="https://www.fatiando.org/pooch/latest/index.html">Pooch</a> to build up a registry of <a href="https://github.com/ucam-eo/tessera-manifests">manifests</a> in Git, and provides helper functions to calculate which tiles you need.
automate.</p>
<p>You can take this for a spin very quickly if you have <a href="https://docs.astral.sh/uv/">uv</a> installed. First, let's check global coverage of what's available:</p>
<pre><code>uvx geotessera coverage
</code></pre>
<p>This will drop a figure like the below into <code>tessera_coverage.png</code>. You can also refine the map to an area of interest by passing in a GeoJSON, shapefile or manual bounding box to the command-line arguments.</p>
<figure class="image-center"><img src="https://raw.githubusercontent.com/ucam-eo/tessera-coverage-map/refs/heads/main/map.png"></figure>
<p>We're still churning through the inference (and prioritising areas of interest for our early adopters), so the green spots represent full coverage from 2017-2024, the blue represents just 2024, and orange for in-between.
Now, we want to download the embeddings themselves. Let's do Cambridgeshire:</p>
<pre><code>uvx geotessera download \
  --output cb \
  --region-file https://raw.githubusercontent.com/ucam-eo/geotessera/refs/heads/main/example/CB.geojson
</code></pre>
<p>This will drop a bunch of GeoTIFFs into the <code>cb/</code> directory which you can inspect using GDAL in the normal way. Note that the local UTM coordinates are preserved (this varies by latitude) and that there are 128 bands per TIFF.</p>
<pre><code>% gdalinfo -stats cb/tessera_2024_lat51.95_lon0.05.tif
&lt;...&gt;
Pixel Size = (10.000000000000000,-10.000000000000000)
Metadata:
  GEOTESSERA_VERSION=0.5.1
  TESSERA_DATASET_VERSION=v1
  TESSERA_DESCRIPTION=GeoTessera satellite embedding tile
  TESSERA_TILE_LAT=51.95
  TESSERA_TILE_LON=0.05
  TESSERA_YEAR=2024
  AREA_OR_POINT=Area
Image Structure Metadata:
  COMPRESSION=LZW
  INTERLEAVE=PIXEL
Corner Coordinates:
Upper Left  (  293612.221, 5765288.255) (  0d 0'24.03"W, 51d59'59.39"N)
Lower Left  (  293612.221, 5753888.255) (  0d 0' 0.61"E, 51d53'50.90"N)
Upper Right (  300932.221, 5765288.255) (  0d 5'59.33"E, 52d 0' 9.01"N)
Lower Right (  300932.221, 5753888.255) (  0d 6'23.09"E, 51d54' 0.49"N)
Center      (  297272.221, 5759588.255) (  0d 2'59.76"E, 51d56'59.99"N)
Band 1 Block=256x256 Type=Float32, ColorInterp=Gray
  Description = Tessera_Band_0
  Minimum=-4.017, Maximum=11.446, Mean=3.649, StdDev=2.089
  Metadata:
    STATISTICS_MINIMUM=-4.0171508789062
    STATISTICS_MAXIMUM=11.445509910583
    STATISTICS_MEAN=3.6492421642927
    STATISTICS_STDDEV=2.088705775134
    STATISTICS_VALID_PERCENT=100
</code></pre>
<p>Once you have the GeoTIFFs locally, you can drop into your normal GIS workflows. But
you can also continue to use the CLI to do false colour visualisations, for
example using PCA, to help visualise what's going on.</p>
<pre><code>uvx geotessera visualize cb cb.tiff
uvx geotessera serve cb.tiff --open
</code></pre>
<p>These two commands will first output an RGB mosaic of the tiles (false colour, like the one at the start of this post), and then tile them using <a href="https://leafletjs.com/">LeafletJS</a> so you explore them with OpenStreetMap in the background.</p>
<h2><a href="https://anil.recoil.org/news.xml#a-geospatial-classification-workflow" class="anchor" aria-hidden="true"></a>A geospatial classification workflow</h2>
<p>At this point you are probably itching to do some actual machine learning. You can try out the Tessera interactive Jupyter notebook next!</p>
<pre><code>git clone https://github.com/ucam-eo/tessera-interactive-map
cd tessera-interactive-map
uv venv
source .venv/bin/activate
uv pip install -r requirements.txt
code app.ipynb
</code></pre>
<p>This will spin up the environment in VS Code as a notebook, where if you run the cells you get an interactive bounding box that you can use to do manual classification by simply marking labels. Here's a video that demonstrates this, courtesy of <a href="https://www.cst.cam.ac.uk/people/ray25" class="contact">Robin Young</a>:</p>
<p></p><div class="video-center"><iframe title="" width="100%" height="315px" src="https://crank.recoil.org/videos/embed/a736234b-98bd-4923-a01e-87cff597f8b2" frameborder="0" allowfullscreen="" sandbox="allow-same-origin allow-scripts allow-popups allow-forms"></iframe></div><p></p>
<p>Have fun with this! All of this is really bleeding edge stuff, so if you run into issues (likely) then please do <a href="https://github.com/ucam-eo/geotessera">file an issue</a> and let us know. In fact, let us know if you build something where you didn't find any bugs, too!</p>
<h2><a href="https://anil.recoil.org/news.xml#what-next" class="anchor" aria-hidden="true"></a>What next?</h2>
<p>Coding in Python again after a few years has been a fun experience for me, but
I'm yearning to return to OCaml again. Accordingly, I've been building out an
implementation of GeoTessera in native OCaml, using
<a href="https://github.com/ocaml-multicore/eio">eio</a>. This is also a perfect usecase
for <a href="https://oxcaml.org">oxcaml</a> extensions to speed up floating point
processing, and <a href="https://github.com/tmattio" class="contact">Thibaut Mattio</a> has just published
<a href="https://github.com/raven-ml/raven">Raven</a> for handling numpy format arrays in
OCaml.   Stay <a href="https://anil.recoil.org/notes/cresting-the-ocaml-ai-hump">tuned</a> for more on that...</p>
<p>There's also plenty to be done on improvements to GeoTessera; I'll be adding in
modules to help with machine learning workflows as soon as the external uses of them
have stabilised a bit more.  I'm also enjoying getting re-familiar with modern
Python tooling. <code>uv</code> is a remarkable piece of work, but I'm still figuring out how to
(e.g.) run notebooks directly using it without running into package issues.</p>
<p>And finally, storage management remains a real headache as we are <a href="https://anil.recoil.org/notes/syncoid-sanoid-zfs">striping and syncing</a> hundreds of terabytes of storage and keeping it
<a href="https://www.tunbury.org/2025/08/27/fsperf/">performant</a>.  As we go back to generate
embeddings for earlier years, we'll be hitting petabytes easily. While the normal
answer is to store this on a cloud, the problem is the egress bandwidth is hugely
expensive, and it's imporant we have a local storage cluster for this. Any tips
on how to build out a cheap such cluster are welcome!</p>
<section role="doc-endnotes"><ol>
<li>
<p>We ran the inference on a combination of <a href="https://www.amd.com/en/products/accelerators/instinct/mi300/mi300x.html">AMD MIX300</a> and the <a href="https://www.hpc.cam.ac.uk/d-w-n">Dawn</a> cluster you may have seen me <a href="https://crank.recoil.org/w/9YmWNZrmGD2794Fk33djUp">talking about on the BBC</a> a while back.</p>
<span><a href="https://anil.recoil.org/news.xml#ref-1-fn-1" role="doc-backlink" class="fn-label">↩︎︎</a></span></li><li>
<p>The humungous number of SSDs are jury-rigged onto machines kindly donated to the Lab by <a href="https://janestreet.com">Jane Street</a>.</p>
<span><a href="https://anil.recoil.org/news.xml#ref-1-fn-2" role="doc-backlink" class="fn-label">↩︎︎</a></span></li></ol></section>

