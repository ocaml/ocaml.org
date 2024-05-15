---
title: 'new opam features: more expressive dependencies'
description: This blog will cover yet another aspect of the improvements opam 2.0
  has over opam 1.2. I may be a little more technical than previous issues, as it
  covers a feature directed specifically at packagers and repository maintainers,
  and regarding the package definition format. Specifying dependencies in...
url: https://ocamlpro.com/blog/2017_05_11_new_opam_features_more_expressive_dependencies
date: 2017-05-11T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    Louis Gesbert\n  "
source:
---

<p>This blog will cover yet another aspect of the improvements opam 2.0 has over opam 1.2. I may be a little more technical than previous issues, as it covers a feature directed specifically at packagers and repository maintainers, and regarding the package definition format.</p>
<h3>Specifying dependencies in opam 1.2</h3>
<p>Opam 1.2 already has an advanced way of specifying package dependencies, using formulas on packages and versions, with the following syntax:</p>
<pre><code class="language-shell-session">    depends: [
      &quot;foo&quot; {&gt;= &quot;3.0&quot; &amp; &lt; &quot;4.0~&quot;}
      ( &quot;bar&quot; | &quot;baz&quot; {&gt;= &quot;1.0&quot;} )
    ]
</code></pre>
<p>meaning that the package being defined depends on both package <code>foo</code>, within the <code>3.x</code> series, and one of <code>bar</code> or <code>baz</code>, the latter with version at least <code>1.0</code>. See <a href="https://opam.ocaml.org/doc/Manual.html#PackageFormulas">here</a> for a complete documentation.</p>
<p>This only allows, however, dependencies that are static for a given package.</p>
<p>Opam 1.2 introduced <code>build</code>, <code>test</code> and <code>doc</code> &quot;dependency flags&quot; that could provide some specifics for dependencies (<em>e.g.</em> <code>test</code> dependencies would only be needed when tests were requested for the package). These were constrained to appear before the version constraints, <em>e.g.</em> <code>&quot;foo&quot; {build &amp; doc &amp; &gt;= &quot;3.0&quot;}</code>.</p>
<h3>Extensions in opam 2.0</h3>
<p>Opam 2.0 generalises the dependency flags, and makes the dependencies specification more expressive by allowing to mix <em>filters</em>, <em>i.e.</em> formulas based on opam variables, with the version constraints. If that formula holds, the dependency is enforced, if not, it is discarded.</p>
<p>This is documented in more detail <a href="https://opam.ocaml.org/doc/2.0/Manual.html#Filteredpackageformulas">in the opam 2.0 manual</a>.</p>
<p>Note also that, since the compilers are now packages, the required OCaml version is now expressed using this mechanism as well, through a dependency to the (virtual) package <code>ocaml</code>, <em>e.g.</em> <code>depends: [ &quot;ocaml&quot; {&gt;= &quot;4.03.0&quot;} ]</code>. This replaces uses of the <code>available:</code> field and <code>ocaml-version</code> switch variable.</p>
<h4>Conditional dependencies</h4>
<p>This makes it trivial to add, for example, a condition on the OS to a given dependency, using the built-in variable <code>os</code>:</p>
<pre><code class="language-shell-session">depends: [ &quot;foo&quot; {&gt;= &quot;3.0&quot; &amp; &lt; &quot;4.0~&quot; &amp; os = &quot;linux&quot;} ]
</code></pre>
<p>here, <code>foo</code> is simply not needed if the OS isn't Linux. We could also be more specific about other OSes using more complex formulas:</p>
<pre><code class="language-shell-session">    depends: [
      &quot;foo&quot; { &quot;1.0+linux&quot; &amp; os = &quot;linux&quot; |
              &quot;1.0+osx&quot; &amp; os = &quot;darwin&quot; }
      &quot;bar&quot; { os != &quot;osx&quot; &amp; os != &quot;darwin&quot; }
    ]
</code></pre>
<p>Meaning that Linux and OSX require <code>foo</code>, respectively versions <code>1.0+linux</code> and <code>1.0+osx</code>, while other systems require <code>bar</code>, any version.</p>
<h4>Dependency flags</h4>
<p>Dependency flags, as used in 1.2, are no longer needed, and are replaced by variables that can appear anywhere in the version specification. The following variables are typically useful there:</p>
<ul>
<li><code>with-test</code>, <code>with-doc</code>: replace the <code>test</code> and <code>doc</code> dependency flags, and are <code>true</code> when the package's tests or documentation have been requested
</li>
<li>likewise, <code>build</code> behaves similarly as before, limiting the dependency to a &quot;build-dependency&quot;, implying that the package won't need to be rebuilt if the dependency changes
</li>
<li><code>dev</code>: this boolean variable holds <code>true</code> on &quot;development&quot; packages, that is, packages that are bound to a non-stable source (a version control system, or if the package is pinned to an archive without known checksum). <code>dev</code> sources often happen to need an additional preliminary step (e.g. <code>autoconf</code>), which may have its own dependencies.
</li>
</ul>
<p>Use <code>opam config list</code> for a list of pre-defined variables. Note that the <code>with-test</code>, <code>with-doc</code> and <code>build</code> variables are not available everywhere: the first two are allowed only in the <code>depends:</code>, <code>depopts:</code>, <code>build:</code> and <code>install:</code> fields, and the latter is specific to the <code>depends:</code> and <code>depopts:</code> fields.</p>
<p>For example, the <code>datakit.0.9.0</code> package has:</p>
<pre><code class="language-shell-session">depends: [
  ...
  &quot;datakit-server&quot; {&gt;= &quot;0.9.0&quot;}
  &quot;datakit-client&quot; {with-test &amp; &gt;= &quot;0.9.0&quot;}
  &quot;datakit-github&quot; {with-test &amp; &gt;= &quot;0.9.0&quot;}
  &quot;alcotest&quot; {with-test &amp; &gt;= &quot;0.7.0&quot;}
]
</code></pre>
<p>When running <code>opam install datakit.0.9.0</code>, the <code>with-test</code> variable is set to <code>false</code>, and the <code>datakit-client</code>, <code>datakit-github</code> and <code>alcotest</code> dependencies are filtered out: they won't be required. With <code>opam install datakit.0.9.0 --with-test</code>, the <code>with-test</code> variable is true (for that package only, tests on packages not listed on the command-line are not enabled!). In this case, the dependencies resolve to:</p>
<pre><code class="language-shell-session">depends: [
  ...
  &quot;datakit-server&quot; {&gt;= &quot;0.9.0&quot;}
  &quot;datakit-client&quot; {&gt;= &quot;0.9.0&quot;}
  &quot;datakit-github&quot; {&gt;= &quot;0.9.0&quot;}
  &quot;alcotest&quot; {&gt;= &quot;0.7.0&quot;}
]
</code></pre>
<p>which is treated normally.</p>
<h4>Computed versions</h4>
<p>It is also possible to use variables, not only as conditions, but to compute the version values: <code>&quot;foo&quot; {= var}</code> is allowed and will require the version of package <code>foo</code> corresponding to the value of variable <code>var</code>.</p>
<p>This is useful, for example, to define a family of packages, which are released together with the same version number: instead of having to update the dependencies of each package to match the common version at each release, you can leverage the <code>version</code> package-variable to mean &quot;that other package, at the same version as current package&quot;. For example, <code>foo-client</code> could have the following:</p>
<pre><code class="language-shell-session">depends: [ &quot;foo-core&quot; {= version} ]
</code></pre>
<p>It is even possible to use variable interpolations within versions, <em>e.g.</em> specifying an os-specific version differently than above:</p>
<pre><code class="language-shell-session">depends: [ &quot;foo&quot; {= &quot;1.0+%{os}%&quot;} ]
</code></pre>
<p>this will expand the <code>os</code> variable, resolving to <code>1.0+linux</code>, <code>1.0+darwin</code>, etc.</p>
<p>Getting back to our <code>datakit</code> example, we could leverage this and rewrite it to the more generic:</p>
<pre><code class="language-shell-session">depends: [
  ...
  &quot;datakit-server&quot; {&gt;= version}
  &quot;datakit-client&quot; {with-test &amp; &gt;= version}
  &quot;datakit-github&quot; {with-test &amp; &gt;= version}
  &quot;alcotest&quot; {with-test &amp; &gt;= &quot;0.7.0&quot;}
]
</code></pre>
<p>Since the <code>datakit-*</code> packages follow the same versioning, this avoids having to rewrite the opam file on every new version, with a risk of error each time.</p>
<p>As a side note, these variables are consistent with what is now used in the <a href="http://opam.ocaml.org/doc/2.0/Manual.html#opamfield-build"><code>build:</code></a> field, and the <a href="http://opam.ocaml.org/doc/2.0/Manual.html#opamfield-build-test"><code>build-test:</code></a> field is now deprecated. So this other part of the same <code>datakit</code> opam file:</p>
<pre><code class="language-shell-session">build:
  [&quot;ocaml&quot; &quot;pkg/pkg.ml&quot; &quot;build&quot; &quot;--pinned&quot; &quot;%{pinned}%&quot; &quot;--tests&quot; &quot;false&quot;]
build-test: [
  [&quot;ocaml&quot; &quot;pkg/pkg.ml&quot; &quot;build&quot; &quot;--pinned&quot; &quot;%{pinned}%&quot; &quot;--tests&quot; &quot;true&quot;]
  [&quot;ocaml&quot; &quot;pkg/pkg.ml&quot; &quot;test&quot;]
]
</code></pre>
<p>would now be preferably written as:</p>
<pre><code class="language-shell-session">build: [&quot;ocaml&quot; &quot;pkg/pkg.ml&quot; &quot;build&quot; &quot;--pinned&quot; &quot;%{pinned}%&quot; &quot;--tests&quot; &quot;%{with-test}%&quot;]
run-test: [&quot;ocaml&quot; &quot;pkg/pkg.ml&quot; &quot;test&quot;]
</code></pre>
<p>which avoids building twice just to change the options.</p>
<h4>Conclusion</h4>
<p>Hopefully this extension to expressivity in dependencies will make the life of packagers easier; feedback is welcome on your personal use-cases.</p>
<p>Note that the official repository is still in 1.2 format (served as 2.0 at <code>https://opam.ocaml.org/2.0</code>, through automatic conversion), and will only be migrated a little while after opam 2.0 is finally released. You are welcome to experiment on custom repositories or pinned packages already, but will need a little more patience before you can contribute package definitions making use of the above to the <a href="https://github.com/ocaml/opam-repository">official repository</a>.</p>
<blockquote>
<p>NOTE: this article is cross-posted on <a href="https://opam.ocaml.org/blog/">opam.ocaml.org</a> and <a href="https://ocamlpro.com/blog">ocamlpro.com</a>.</p>
</blockquote>

