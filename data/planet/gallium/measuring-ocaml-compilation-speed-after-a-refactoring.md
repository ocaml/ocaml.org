---
title: Measuring OCaml compilation speed after a refactoring
description:
url: http://gallium.inria.fr/blog/measuring-compilation-time/
date: 2021-09-17T08:00:00-00:00
preview_image:
featured:
authors:
- gallium
---




It can be tricky to evaluate the effect of invidual commits or pull requests on
the speed of the OCaml compiler. In this blog post, I (Florian Angeletti) report my
experience on measuring such impact with some degree of statistical significance.


  

  <p>The OCaml typechecker is an important piece of the OCaml compiler
pipeline which accounts for a significant portion of time spent on
compiling an OCaml program (see the <a href="http://gallium.inria.fr/blog/index.rss#compilation-profile">appendices</a>).</p>
<p>The code of the typechecker is also quite optimised, sometimes to the
detriment of the readability of the code. Recently, Jacques Garrigue and
Takafumi Saikawa have worked on a series of pull requests to improve the
readability of the typechecker (<a href="https://github.com/ocaml/ocaml/pull/10337">#10337</a>, <a href="https://github.com/ocaml/ocaml/pull/10474">#10474</a>, <a href="https://github.com/ocaml/ocaml/pull/10541">#10541</a>).
Unfortunately, those improvements are also expected to increase the
typechecking time of OCaml programs because they add abstraction
barriers, and remove some optimisations that were breaking the
abstraction barriers.</p>
<p>The effect is particularly pronounced on <a href="https://github.com/ocaml/ocaml/pull/10337">#10337</a>. Due to the
improvement of the readability of the typechecker, this pull request has
been merged after some quick tests to check that the compilation time
increase was not too dire.</p>
<p>However, the discussion on this pull request highlighted the fact
that it was difficult to measure OCaml compilation time on a scale large
enough to enable good statistical analysis and that it would be
useful.</p>
<p>Consequently, I decided to try my hand at a statistical analysis of
OCaml compilation time, using this pull request <a href="https://github.com/ocaml/ocaml/pull/10337">#10337</a> as a case
study. Beyond this specific PR, I think that it is interesting to write
down a process and a handful of tools for measuring OCaml compilation
time on the opam ecosystem.</p>
<p>Before doing any kind of analysis, the first step is to find an easy
way to collect the data of interest. Fortunately, the OCaml compiler can
emit timing information with flag <code>-dtimings</code>. However, this
information is emitted on stdout, whereas my ideal sampling process
would be to just pick an opam package, launch a build process and
recover the timing information for each file. This doesn&rsquo;t work if the
data is sent to the stdout, and never see again. This first step is thus
to create a version of the OCaml compiler that can output the timing
information of the compilation to a specific directory. With this change
(<a href="https://github.com/ocaml/ocaml/pull/10575">#10575</a>),
installing an opam package with</p>
<pre><code>OCAMLPARAM=&quot;,_,timings=1,dump-dir= /tmp/pkgnname&quot; opam install pkgname</code></pre>
<p>outputs all profiling information to <code>/tmp/pkgname</code>.</p>
<p>This makes it possible to collect large number of data points on
compilation times by using opam, and the canonical installation process
of each package without the need of much glue code.</p>
<p>For this case study, I am using 5 core packages
<code>containers</code>, <code>dune</code>, <code>tyxml</code>,
<code>coq</code> and <code>base</code>. Once their dependencies are
added, I end up with</p>
<ul>
<li>ocamlfind</li>
<li>num</li>
<li>zarith</li>
<li>seq</li>
<li>containers</li>
<li>coq</li>
<li>dune</li>
<li>re</li>
<li>ocamlbuild</li>
<li>uchar</li>
<li>topkg</li>
<li>uutf</li>
<li>tyxml</li>
<li>sexplib0</li>
<li>base</li>
</ul>
<p>Then it is a matter of repeatedly installing those packages, and
measuring the compilation times before and after <a href="https://github.com/ocaml/ocaml/pull/10337">#10337</a>.</p>
<p>In order to get more reliable statistics on each file, each package
was compiled 250 times leading to 1,6 millions of data points (available
<a href="http://gallium.inria.fr/static/longer_complex.log.xz">here</a>) after slightly more
than a week-end of computation.</p>
<p>In order to try to reduce the noise induced by the operating system
scheduler, the compilation process is run with <code>OPAMJOBS=1</code>.
Similarly, the compilation process was isolated as much as possible from
the other process using the <code>cset</code> Linux utility to reserve
one full physical core to the opam processes.</p>
<p>The code for collecting samples, analyzing them, and plotting the
graphs below is available at <a href="https://github.com/Octachron/ocaml-perfomance-monitoring">https://github.com/Octachron/ocaml-perfomance-monitoring</a>.</p>
<h2>Comparing averages, files by
files</h2>
<p>With the data at hand, we can compute the average compilation by
files, and by stage of the OCaml compiler pipeline. In our case, we are
mostly interested in the typechecking stage, and global compilation
time, since #10337 should only alter the time spent on typechecking. It
is therefore useful to split the compilation time into
<code>typechecking + other=total</code>. Then for each files in the 15
packages above, we can can compute the average time for each of those
stages and the relative change of average compilation time:
<code>time after/time before</code>.</p>
<p>Rendering those relative changes for the typechecking time, file by
file (with the corresponding 90% confidence interval) yields</p>
<figure>
<img src="http://gallium.inria.fr/blog/images/mean_ratio.svg" alt="Relative change in average typechecking time by files"/>
<figcaption aria-hidden="true">Relative change in average typechecking
time by files</figcaption>
</figure>
<p>To avoid noise, I have removed files for which the average
typechecking time was inferior to one microsecond on the reference
version of the compiler.</p>
<p>In the graph above, there are few remarkable points:</p>
<ul>
<li>As expected, the average typechecking time increased for almost all
files</li>
<li>A significant portion of points are stuck to the line
&ldquo;after/before=1&rdquo;. This means that for those files there was no changes
at all of the typechecking times.</li>
<li>The standard deviation time varies wildly across packages. The
typechecking of some dune files tend to have a very high variances.
However outside of those files, the standard deviation seems moderate,
and the mean estimator seem to have converged.</li>
<li>For a handful a files for which the typechecking time more than
doubled. However the relative typechecking time does seem to be confined
in the <code>[1,1.2]</code> range for a majority of files.</li>
</ul>
<p>Since the data is quite noisy, it is useful before trying to
interpret it to check that we are not looking only at noise.
Fortunately, we have the data on the time spent outside of the
typechecking stage available, and those times should be mostly noise. We
have thus a baseline, that looks like</p>
<figure>
<img src="http://gallium.inria.fr/blog/images/other_ratio.svg" alt="Relative change in average non-typechecking time by files"/>
<figcaption aria-hidden="true">Relative change in average
non-typechecking time by files</figcaption>
</figure>
<p>This cloud of points look indeed much noisier. More importantly, it
seems centred around the line <code>after/before=1</code>. This means
that our hypothesis that the compilation time outside of the
typechecking stage has not been altered is not visibly invalidated by
our data points. An other interesting point is that the high variance
points seems to be shared between the typechecking and other graphs.</p>
<p>We can even check on the graphs for the average total compilation
(file by file)</p>
<figure>
<img src="http://gallium.inria.fr/blog/images/total_ratio.svg" alt="Relative change in average total time by files"/>
<figcaption aria-hidden="true">Relative change in average total time by
files</figcaption>
</figure>
<p>that those points still have a high variance here. However, outside
of this cluster of points, we have a quite more compact distribution of
points for the total compilation time: it seems that we have a quite
consistent increase of the total compilation time of around 3%.</p>
<p>And this is reflected in the averages:</p>
<table>
<thead>
<tr class="header">
<th>Typechecking average</th>
<th>Other average</th>
<th>Total average</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>1.06641</td>
<td>1.01756</td>
<td>1.03307</td>
</tr>
</tbody>
</table>
<p>There is thus an increase of around 6.6% of typechecking time which
translates to an increase of 3.3% of total time. However, the
non-typechecking time also increased by 1.7% in average. The average is
thus either tainted by some structural bias or the relative variance
(mean/ratio) is still enough for the distribution of the ratio to be
ill-behaved (literature seems to indicate that a relative variance &lt;
10% is required for the distribution of ratio to be Gaussian-like).
Anyway, we probably cannot count on a precision of more than 1.7%. Even
with this caveat, we still have a visible effect on the total
compilation time.</p>
<p>We might better served by comparing the geometric average. Indeed, we
are comparing ratio of time, with possibly a heavy-tailed noise. By
using the geometric average (which compute the exponential of the
arithmetic mean of the logarithms of our ratio), we can check that rare
events don&rsquo;t have an undue influence on the average. In our case the
geometric means looks like</p>
<table>
<colgroup>
<col style="width: 36%"/>
<col style="width: 30%"/>
<col style="width: 32%"/>
</colgroup>
<thead>
<tr class="header">
<th>Typechecking geometric average</th>
<th>Other geometric average</th>
<th>Total geometric average</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>1.05963</td>
<td>1.01513</td>
<td>1.03215</td>
</tr>
</tbody>
</table>
<p>All geometric averages have decreased compared to the arithmetic
means, which is a sign that the compilation time distribution is skewed
towards high compilation times. However, the changes are small and do
not alter our previous interpretation.</p>
<p>We can somewhat refine those observations by looking at the medians
(which are even less affected by the heavy-tailness of
distributions)</p>
<table>
<thead>
<tr class="header">
<th>Typechecking median</th>
<th>Other median</th>
<th>Total media</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>1.03834</td>
<td>1.00852</td>
<td>1.02507</td>
</tr>
</tbody>
</table>
<p>Here, the non-typechecking times seems far less affected by the
structural bias (with an increase of 0.9%) whereas the increase of
typechecking time and total compilation time are reduced but still here
at 3.8% and 2.5% respectively.</p>
<h2>Comparing averages, quantiles</h2>
<p>We can refine our analysis by looking at the quantiles of those
relative changes of compilation time</p>
<figure>
<img src="http://gallium.inria.fr/blog/images/mean_quantiles.svg" alt="Quantiles of the relative change of average typechecking time by files"/>
<figcaption aria-hidden="true">Quantiles of the relative change of
average typechecking time by files</figcaption>
</figure>
<table>
<thead>
<tr class="header">
<th>%</th>
<th>mean quantiles</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>1%</td>
<td>0.875097</td>
</tr>
<tr class="even">
<td>10%</td>
<td>1</td>
</tr>
<tr class="odd">
<td>25%</td>
<td>1.001</td>
</tr>
<tr class="even">
<td>50%</td>
<td>1.03834</td>
</tr>
<tr class="odd">
<td>75%</td>
<td>1.08826</td>
</tr>
<tr class="even">
<td>90%</td>
<td>1.162</td>
</tr>
<tr class="odd">
<td>99%</td>
<td>1.51411</td>
</tr>
<tr class="even">
<td>99.9%</td>
<td>2.76834</td>
</tr>
</tbody>
</table>
<p>Here we see that the typechecking time of around 25% of files is
simply not affected at all by the changes. And for half of the files,
the compilation time is inferior to 9%. Contrarily, there is 1% of files
for which the typechecking time increases by more than 50% (with
outliers around 200%-400% increase).</p>
<p>However, looking at the total compilation does seems to reduce the
overall impact of the change</p>
<figure>
<img src="http://gallium.inria.fr/blog/images/total_quantiles.svg" alt="Quantiles of the relative change in average total time by files"/>
<figcaption aria-hidden="true">Quantiles of the relative change in
average total time by files</figcaption>
</figure>
<table>
<thead>
<tr class="header">
<th>%</th>
<th>total quantiles</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>1%</td>
<td>0.945555</td>
</tr>
<tr class="even">
<td>10%</td>
<td>1</td>
</tr>
<tr class="odd">
<td>25%</td>
<td>1.00707</td>
</tr>
<tr class="even">
<td>50%</td>
<td>1.02507</td>
</tr>
<tr class="odd">
<td>75%</td>
<td>1.05</td>
</tr>
<tr class="even">
<td>90%</td>
<td>1.07895</td>
</tr>
<tr class="odd">
<td>99%</td>
<td>1.17846</td>
</tr>
<tr class="even">
<td>99.9%</td>
<td>1.4379</td>
</tr>
</tbody>
</table>
<p>Indeed, we still have 25% of files not impacted, but for 65% of files
the relative increase of compilation time is less than 8%. (and the
outliers stalls at a 50% increase)</p>
<p>We can also have a quick look at the quantiles for the
non-typechecking time</p>
<figure>
<img src="http://gallium.inria.fr/blog/images/other_quantiles.svg" alt="Quantiles of the relative change in average non-typechecking time by files"/>
<figcaption aria-hidden="true">Quantiles of the relative change in
average non-typechecking time by files</figcaption>
</figure>
<table>
<thead>
<tr class="header">
<th>%</th>
<th>other quantiles</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>1%</td>
<td>0.855129</td>
</tr>
<tr class="even">
<td>10%</td>
<td>0.956174</td>
</tr>
<tr class="odd">
<td>25%</td>
<td>0.995239</td>
</tr>
<tr class="even">
<td>50%</td>
<td>1.00852</td>
</tr>
<tr class="odd">
<td>75%</td>
<td>1.03743</td>
</tr>
<tr class="even">
<td>90%</td>
<td>1.08618</td>
</tr>
<tr class="odd">
<td>99%</td>
<td>1.25541</td>
</tr>
<tr class="even">
<td>99.9%</td>
<td>1.67784</td>
</tr>
</tbody>
</table>
<p>but here the only curiosity if that the curve is more symmetric and
we have 25% of files for which the non-typechecking compilation time
decrease randomly.</p>
<h2>Noise models and minima</h2>
<p>One issue with our previous analysis is the high variance which is
observable in the non-typechecking average times across files. A
possibility to mitigate this issue is to change our noise model. Using
an average, we implicitly assumed that the compilation time was
mostly:</p>
<pre><code>observable_compilation_time = theoretical_computation_time + noise</code></pre>
<p>where noise is a random variable with at least a finite variance and
a mean of <code>0</code>. Indeed, with this symmetry hypothesis the
expectation of the observable computation time aligns with the
theoretical compilation time:</p>
<pre><code>E[observable_computation_time] = E[theoretical_computation_time] + E[noise] = theoretical_computation_time</code></pre>
<p>and the variance <code>Var[observable_computation_time]</code> is
exactly the variance of the noise <code>Var[noise]</code>. Then our
finite variance hypothesis ensure that the empirical average hypothesis
converges relatively well towards the theoretical expectation.</p>
<p>However, we can imagine another noise model with a multiplicative
noise (due to CPU scheduling for instance),</p>
<pre><code>observable_compilation_time = scheduling_noise * theoretical_computation_time + noise</code></pre>
<p>with both <code>scheduling_noise&gt;1</code> and
<code>noise&gt;1</code>. With this model, the expectation of the
observable compilation time does not match up with the theoretical
computation time:</p>
<pre><code>E[observable_computation_time] - theoretical_computation_time =
  (E[scheduling_noise]-1) * theoretical_computation_time + E[noise]</code></pre>
<p>Thus, in this model, the average observable computation time is a
structurally biased estimator for the theoretical computation time. This
bias might be compensated by the fact that we are only looking to ratio.
Nevertheless, this model also induces a second source of variance</p>
<pre><code>Var[observable_computation_time] = theoretical_computation_time^2 Var[scheduling_noise] + Var[noise]</code></pre>
<p>(/assuming the two noises are not correlated), and this variance
increases with the theoretical computation time. This relative standard
deviation might be problematic when computing ratio.</p>
<p>If this second noise model is closer to reality, using the empirical
average estimators might be not ideal. However, the positivity of the
noise opens another avenue for estimators: we can consider the minima of
a series of independent realisations. Then, we have</p>
<pre><code>min(observable_compilation_time) = min(scheduling_noise * theoretical_computation_time) + min(noise) = theoretical_computation_time</code></pre>
<p>if the <code>min(scheduling_noise)=1</code> and
<code>min(noise)=0</code>.</p>
<p>This model has another advantage: by assuming that the (essential)
support of the noise distribution has finite lower bound, we know that
the empirical minima will converge towards a three-parameter Weibull
distribution with a strictly positive support. (To be completely
explicit, we also need to assume some regularity of the distribution
around this lower bound too).</p>
<p>This means that the distribution ratio of the empirical minima will
not exhibits the infinite moments of the ratio of two Gaussians. Without
this issue, our estimator should have less variance.</p>
<p>However, we cannot use Gaussian confidence intervals for the
empirical minima. Moreover, estimating the confidence interval for the
Weibull distribution is more complex. Since we are mostly interested in
corroborating our previous result, we are bypassing the computation of
those confidence intervals.</p>
<h2>Comparing minima</h2>
<p>We can then restart out analysis using the minimal compilation time
file-by-file. Starting with the minimal typechecking time, we get</p>
<figure>
<img src="http://gallium.inria.fr/blog/images/min_ratio.svg" alt="Relative change in minimal typechecking time by files"/>
<figcaption aria-hidden="true">Relative change in minimal typechecking
time by files</figcaption>
</figure>
<p>There are notable differences with the average version: - a very
significant part of our points takes the same time to typecheck before
and after #10337 - there is a discretization effects going on: data
points tend to fall on exactly the same value of the ratio</p>
<p>Beyond those changes, there is still a visible general increase of
typechecking time.</p>
<p>The same differences are visible for the non typechecking compilation
time <img src="http://gallium.inria.fr/blog/images/min_other_ratio.svg" alt="Relative change in minimal non-typechecking time by files"/></p>
<p>and the total compilation time</p>
<figure>
<img src="http://gallium.inria.fr/blog/images/min_total_ratio.svg" alt="Relative change in minimal total time by files"/>
<figcaption aria-hidden="true">Relative change in minimal total time by
files</figcaption>
</figure>
<p>but overall the minimal total compilation and non-typechecking time
mirrors what we had seen with the average. The distribution of the
non-typechecking times is maybe more evenly centred around a ratio of
1.</p>
<p>We can have a look at the averages and median (across files) to have
more global point of view</p>
<table>
<thead>
<tr class="header">
<th></th>
<th>Typechecking</th>
<th>Other</th>
<th>Total</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>Average</td>
<td>1.06907</td>
<td>1.01031</td>
<td>1.02901</td>
</tr>
<tr class="even">
<td>Geometric average</td>
<td>1.05998</td>
<td>1.00672</td>
<td>1.0276</td>
</tr>
<tr class="odd">
<td>Median</td>
<td>1</td>
<td>1</td>
<td>1</td>
</tr>
</tbody>
</table>
<p>A striking change is that the median for the typechecking and total
compilation time is equal to one: more than half of files are not
affected by the changes when looking at the minimal compilation time.
This might be an issue with the granularity of time measurement, or it
could be a genuine fact.</p>
<p>More usefully, we still have an increase of average typechecking time
between 6% and 6.9% depending on the averaging methods, which translates
to a total compilation time increase between 2.7% and 3.3%. And this
time, the increase of unrelated compilation time is between 0.7% to
0.9%. This seems to confirms that do have a real increase of average
compilation time and 3% increase time is a reasonable number.</p>
<h2>Comparing minima, quantiles</h2>
<p>With the discretization, the quantiles of the compilation time are
quite interesting and uncharacteristic.</p>
<p>For instance the typechecking quantiles,</p>
<figure>
<img src="http://gallium.inria.fr/blog/images/min_quantiles.svg" alt="Quantiles of the relative change in minimal typechecking time by files"/>
<figcaption aria-hidden="true">Quantiles of the relative change in
minimal typechecking time by files</figcaption>
</figure>
<table>
<thead>
<tr class="header">
<th>%</th>
<th>min quantiles</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>1%</td>
<td>1</td>
</tr>
<tr class="even">
<td>10%</td>
<td>1</td>
</tr>
<tr class="odd">
<td>25%</td>
<td>1</td>
</tr>
<tr class="even">
<td>50%</td>
<td>1</td>
</tr>
<tr class="odd">
<td>75%</td>
<td>1.07692</td>
</tr>
<tr class="even">
<td>90%</td>
<td>1.2</td>
</tr>
<tr class="odd">
<td>99%</td>
<td>2</td>
</tr>
<tr class="even">
<td>99.9%</td>
<td>2</td>
</tr>
</tbody>
</table>
<p>are stuck to 1 between the first and 50th centile. In other words the
minimal typechecking time of more than 50% of the files in our
experiment is unchanged. For 40% of the files, the increase is less than
20%. And the most extreme files see only an increase of 100% of the
typechecking time. On the higher quantiles, the presence of multiple
jumps is the consequence of the discretization of ratio that was already
visible on the raw data.</p>
<p>When looking at the time spent outside of typechecking,</p>
<figure>
<img src="http://gallium.inria.fr/blog/images/min_other_quantiles.svg" alt="Quantiles of the relative change in minimal non-typechecking time by files"/>
<figcaption aria-hidden="true">Quantiles of the relative change in
minimal non-typechecking time by files</figcaption>
</figure>
<table>
<thead>
<tr class="header">
<th>%</th>
<th>min_other quantiles</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>1%</td>
<td>0.8</td>
</tr>
<tr class="even">
<td>10%</td>
<td>0.947368</td>
</tr>
<tr class="odd">
<td>25%</td>
<td>1</td>
</tr>
<tr class="even">
<td>50%</td>
<td>1</td>
</tr>
<tr class="odd">
<td>75%</td>
<td>1</td>
</tr>
<tr class="even">
<td>90%</td>
<td>1.11111</td>
</tr>
<tr class="odd">
<td>99%</td>
<td>1.33333</td>
</tr>
<tr class="even">
<td>99.9%</td>
<td>1.6</td>
</tr>
</tbody>
</table>
<p>we observe that the non-typechecking relation compilation time for
more than 80% of file is unaffected by the change (or somehow
accelerated for 10% of files).</p>
<p>The quantiles for the total compilation time, <img src="http://gallium.inria.fr/blog/images/min_total_quantiles.svg" alt="Quantiles of the relative change in minimal total time by files"/></p>
<table>
<thead>
<tr class="header">
<th>%</th>
<th>min_total quantiles</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>1%</td>
<td>0.92</td>
</tr>
<tr class="even">
<td>10%</td>
<td>1</td>
</tr>
<tr class="odd">
<td>25%</td>
<td>1</td>
</tr>
<tr class="even">
<td>50%</td>
<td>1</td>
</tr>
<tr class="odd">
<td>75%</td>
<td>1.04545</td>
</tr>
<tr class="even">
<td>90%</td>
<td>1.1</td>
</tr>
<tr class="odd">
<td>99%</td>
<td>1.22727</td>
</tr>
<tr class="even">
<td>99.9%</td>
<td>1.4</td>
</tr>
</tbody>
</table>
<p>mostly reflects the trends set by the typechecking time: 55% of files
are unaffected. For 90% of file the increase is less than 10%, and the
maximal impact on the compilation time peaks at a 40% relative
increase.</p>
<h2>Conclusion</h2>
<p>To sum up, with the available data at hands, it seems sensible to
conclude that #10337 resulted in an average increase of compilation time
of the order of 3%, while the average relative increase of typechecking
time is around 6%. Moreover, for the most impacted files (at the ninth
decile), the relative increase in compilation time ranges between 10% to
40%.</p>
<h2>Appendices</h2>
<h3>Compilation profile</h3>
<p>Since we have data for both typechecking time and non-typechecking
times for a few thousand files, it is interesting to check how much time
is spent on typechecking. We can start by looking at the data points
files by files:</p>
<figure>
<img src="http://gallium.inria.fr/blog/images/profile_ratio.svg" alt="Relative time spent in typechecking by files"/>
<figcaption aria-hidden="true">Relative time spent in typechecking by
files</figcaption>
</figure>
<p>We have here a relatively uniform cloud of points between 20-60% of
time spent in typechecking compared to total compilation time. This is
is reflected on the average and median</p>
<table>
<thead>
<tr class="header">
<th>Arithmetic average</th>
<th>Median</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>38.8827%</td>
<td>39.7336%</td>
</tr>
</tbody>
</table>
<p>Both value are quite comparable, the distribution doesn&rsquo;t seem
significantly skewed.</p>
<p>However, we have a clear cluster of files for which typechecking
accounts for 90% of the total compilation time. Interestingly, this
cluster of points corresponds to the dune cluster of files with a very
variance that we had identified earlier. This explains why those files
have essentially the same profile when looking at the total and
typechecking compilation time: in their case, typechecking accounts for
most of the work done during compilation.</p>
<p>This relatively uniform distribution is visible both on the quantiles
(with an affine part of the quantiles)</p>
<figure>
<img src="http://gallium.inria.fr/blog/images/profile_quantiles.svg" alt="Quantiles of the relative time spent in typechecking by files"/>
<figcaption aria-hidden="true">Quantiles of the relative time spent in
typechecking by files</figcaption>
</figure>
<table>
<thead>
<tr class="header">
<th>%</th>
<th>profile quantiles</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>1%</td>
<td>0.111556</td>
</tr>
<tr class="even">
<td>10%</td>
<td>0.16431</td>
</tr>
<tr class="odd">
<td>25%</td>
<td>0.283249</td>
</tr>
<tr class="even">
<td>50%</td>
<td>0.397336</td>
</tr>
<tr class="odd">
<td>75%</td>
<td>0.487892</td>
</tr>
<tr class="even">
<td>90%</td>
<td>0.573355</td>
</tr>
<tr class="odd">
<td>99%</td>
<td>0.749689</td>
</tr>
<tr class="even">
<td>99.9%</td>
<td>0.913336</td>
</tr>
</tbody>
</table>
<p>and on the histogram of the relative time spent in typechecking</p>
<figure>
<img src="http://gallium.inria.fr/blog/images/profile_hist.svg" alt="Histogram of the relative time spent in typechecking by files"/>
<figcaption aria-hidden="true">Histogram of the relative time spent in
typechecking by files</figcaption>
</figure>
<h3>Histograms</h3>
<p>Histogram versions for the quantile diagrams are also available. Due
to the mixture of continuous and discrete distributions they are not
that easy to read. Note that those histograms have equiprobable bins (in
other words, constant area) rather than constant width bins.</p>
<h3>Average compilation time
histograms</h3>
<p><img src="http://gallium.inria.fr/blog/images/mean_hist.svg" alt="Histogram of the relative change of average typechecking time by files"/>
<img src="http://gallium.inria.fr/blog/images/other_hist.svg" alt="Histogram of the relative change in average non-typechecking time by files"/>
<img src="http://gallium.inria.fr/blog/images/total_hist.svg" alt="Histogram of the relative change in average total time by files"/></p>
<p>An interesting take-away for those histograms is that the
typechecking and total compilation time distribution are clearly skewed
to the right: with very few exceptions, compilation increases.
Contrarily the non-typechecking time distribution is much more
symmetric. Since the change here is due to noise, there is no more
reason for the compilation time to increase or decrease.</p>
<h3>Minimal compilation time
histograms</h3>
<p>There is no much change when looking at the histogram for the minimal
compilation time for a file</p>
<p><img src="http://gallium.inria.fr/blog/images/min_hist.svg" alt="Histogram of the relative change in minimal typechecking time by files"/>
<img src="http://gallium.inria.fr/blog/images/min_other_hist.svg" alt="Histogram of the relative change in minimal non-typechecking time by files"/>
<img src="http://gallium.inria.fr/blog/images/min_total_hist.svg" alt="Histogram of the relative change in minimal total time by files"/></p>
<p>The most notable difference is that the non-typechecking histogram is
completely dominated by the dirac distribution centred at
<code>x=1</code>.</p>


