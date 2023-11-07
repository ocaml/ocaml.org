---
title: Florian compiler weekly, 26 September 2023
description:
url: http://gallium.inria.fr/blog/florian-cw-2023-09-26
date: 2023-09-26T08:00:00-00:00
preview_image:
featured:
authors:
- GaGallium
source:
---
    


  <p>This series of blog post aims to give a short weekly glimpse into my
(Florian Angeletti) work on the OCaml compiler. This week subject is
some data analysis of the OCaml changelog.</p>


  

  
  <p>OCaml 5.1.0 has been released two weeks ago, last week was thus a
good time to do some retrospective on this development cycle.</p>
<p>In particular, the OCaml compiler has accumulated a good amount of
history in its changelog file. However, since this is a hand-written
files with some human-enforced rules, it is not so straightforward to
parse it and extract data.</p>
<p>I have thus spent some time mining information from this changelog,
with a <a href="https://github.com/Octachron/ocaml-changelog-analyzer/blob/main/parse/sapient.ml#L122">bunch
of pretty ad-hoc rules</a>. The result of this effort is a <a href="https://github.com/Octachron/ocaml-changelog-analyzer/blob/main/refs/changes.json">cleaned-up
json change file</a>, available with few analysis tools and plot scripts
at <a href="https://github.com/Octachron/ocaml-changelog-analyzer">https://github.com/Octachron/ocaml-changelog-analyzer</a>.</p>
<p>Starting from this file, it is possible to extract some interesting
titbit&rsquo;s about the history of OCaml 4 and 5. For instance, in term of
raw numbers, from OCaml 4.00.0 to OCaml 5.1.0, the changelog increased
by 2930 entries. Filtering patch release, we have an average of 151.5
contributions by release, with a standard deviation of 48.84, <img src="http://gallium.inria.fr/blog/number_of_contributions_by_release.svg"/></p>
<p>With 208 changes, the OCaml 5.1 release is the third release in term
of contributions behind OCaml 4.03 (277 changes, with a one year release
cycle and introduced flambda), and OCaml 4.08 (226 changes with many
standard library changes after the introduction of the
<code>Stdlib</code> namespacing in OCaml 4.07.0).</p>
<p>Similarly, OCaml 5.1.0 with 78 authors has the largest number of
authors, followed by OCaml 4.03.0 and OCaml 4.08:</p>
<p><img src="http://gallium.inria.fr/blog/authors_by_release.svg"/></p>
<p>We have an average of 49 authors by release, with a standard
deviation around 11.8. Maybe more importantly, we can see that we still
a flux of a dozen of new contributors every releases Unfortunately, I am
not tracking contributors from before OCaml 4.01., which is biasing the
computation of the number of new authors. Thus it is hard to tell if the
record number of new authors in 4.02 and 4.03 is due to the switch to
the Github workflow, since it could be a data artifact.</p>
<p>Moreover, focusing only on the number of authors or contributions
hide the diversity of contributions by authors. For instance, counting
the number of authored change entries since OCaml 4.01, we have:</p>
<ul>
<li>9 authors with more than 100 contributions</li>
<li>6 authors with a number of contributions between 40 and 90</li>
<li>16 authors with a number of contributions 15 and 35</li>
<li>119 authors with more than 1 contribution but less than 13</li>
<li>207 authors with one contribution</li>
</ul>
<p>If we represent each contributors by the number of authored
contributions and the number of reviews on a two dimensional log plot,
we have a quite wide cloud of points:</p>
<p><img src="http://gallium.inria.fr/blog/cloud.svg"/></p>
<p>It is reassuring to see that there are contributors spending a
significant amount of their time on reviews.</p>
<p>It is also fun to visualize the influx of new contributors by
plotting the contributions of each persons release by release with some
linear interpolation in-between:</p>
<p><video src="contributor_ballet.webm" controls=""><a href="http://gallium.inria.fr/blog/contributor_ballet.webm">Video</a></video></p>
<p>It is quite a bit harder to read this movie. Trying to extract few
key points, I can see:</p>
<ul>
<li>a vast group of ephemeral contributors</li>
<li>a lot of fluctuation of the activity of active contributors from
release to release,</li>
<li>a small group of prolific and constant contributors.</li>
</ul>


  
