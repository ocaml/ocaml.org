---
title: A second foray into agentic coding
description: "Continuing the previous theme of dabbling with matters agentic. Previously,
  I\u2019d quite assiduously kept my fingers away from files. This time, I wanted
  to try something exploratory, switching to the agent for things I was actively stuck
  on."
url: https://www.dra27.uk/blog/platform/2025/09/28/effectful-bug-hunting.html
date: 2025-09-28T00:00:00-00:00
preview_image:
authors:
- ""
source:
ignore:
---

<p>Continuing the <a href="https://www.dra27.uk/blog/platform/2025/09/17/late-to-the-party.html">previous theme</a>
of dabbling with matters agentic. Previously, I’d quite assiduously kept my
fingers away from files. This time, I wanted to try something exploratory,
switching to the agent for things I was actively stuck on.</p>

<p>I was still (very) curious at the latent remaining bug in <a href="https://www.dra27.uk/blog/platform/2025/09/25/building-with-effects.html">Lucas’s excellent work</a>.
There were some corners which had been cut in the prototype, and I had a brief
foray into this problem, with a view this time to ensuring artefact equivalence
between what OCaml’s build system would produce and what our altered driver
program was doing.</p>

<p>If you have a pre-built compiler and a clean (of binary artefacts) OCaml source
tree, you can actually build the bytecode compiler in just three, ahem, short
commands (I’m intentionally glossing over all the generated source files):</p>
<div class="language-console highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="gp">$</span><span class="w"> </span>ocamlc <span class="nt">-I</span> utils <span class="nt">-I</span> parsing <span class="nt">-I</span> typing <span class="nt">-I</span> bytecomp <span class="nt">-I</span> file_formats <span class="nt">-I</span> lambda <span class="nt">-I</span> middle_end <span class="nt">-I</span> middle_end/closure <span class="nt">-I</span> middle_end/flambda <span class="nt">-I</span> middle_end/flambda/base_types <span class="nt">-I</span> driver <span class="nt">-I</span> runtime <span class="nt">-g</span> <span class="nt">-strict-sequence</span> <span class="nt">-principal</span> <span class="nt">-absname</span> <span class="nt">-w</span> +a-4-9-40-41-42-44-45-48 <span class="nt">-warn-error</span> +a <span class="nt">-bin-annot</span> <span class="nt">-strict-formats</span> <span class="nt">-linkall</span> <span class="nt">-a</span> <span class="nt">-o</span> compilerlibs/ocamlcommon.cma utils/config.mli utils/build_path_prefix_map.mli utils/format_doc.mli utils/misc.mli utils/identifiable.mli utils/numbers.mli utils/arg_helper.mli utils/local_store.mli utils/load_path.mli utils/profile.mli utils/clflags.mli utils/terminfo.mli utils/ccomp.mli utils/warnings.mli utils/consistbl.mli utils/linkdeps.mli utils/strongly_connected_components.mli utils/targetint.mli utils/int_replace_polymorphic_compare.mli utils/domainstate.mli utils/binutils.mli utils/lazy_backtrack.mli utils/diffing.mli utils/diffing_with_keys.mli utils/compression.mli parsing/location.mli parsing/unit_info.mli parsing/asttypes.mli parsing/longident.mli parsing/parsetree.mli parsing/docstrings.mli parsing/syntaxerr.mli parsing/ast_helper.mli parsing/ast_iterator.mli parsing/builtin_attributes.mli parsing/camlinternalMenhirLib.mli parsing/parser.mli parsing/pprintast.mli parsing/parse.mli parsing/printast.mli parsing/ast_mapper.mli parsing/attr_helper.mli parsing/ast_invariants.mli parsing/depend.mli typing/annot.mli typing/value_rec_types.mli typing/ident.mli typing/path.mli typing/type_immediacy.mli typing/outcometree.mli typing/primitive.mli typing/shape.mli typing/types.mli typing/data_types.mli typing/rawprinttyp.mli typing/gprinttyp.mli typing/btype.mli typing/oprint.mli typing/subst.mli typing/predef.mli typing/datarepr.mli file_formats/cmi_format.mli typing/persistent_env.mli typing/env.mli typing/errortrace.mli typing/typedtree.mli typing/signature_group.mli typing/printtyped.mli typing/ctype.mli typing/out_type.mli typing/printtyp.mli typing/errortrace_report.mli typing/includeclass.mli typing/mtype.mli typing/envaux.mli typing/includecore.mli typing/tast_iterator.mli typing/tast_mapper.mli typing/stypes.mli typing/shape_reduce.mli file_formats/cmt_format.mli typing/cmt2annot.mli typing/untypeast.mli typing/includemod.mli typing/includemod_errorprinter.mli typing/typetexp.mli typing/printpat.mli typing/patterns.mli typing/parmatch.mli typing/typedecl_properties.mli typing/typedecl_variance.mli typing/typedecl_unboxed.mli typing/typedecl_immediacy.mli typing/typedecl_separability.mli lambda/debuginfo.mli lambda/lambda.mli typing/typeopt.mli typing/typedecl.mli typing/value_rec_check.mli typing/typecore.mli typing/typeclass.mli typing/typemod.mli lambda/printlambda.mli lambda/switch.mli lambda/matching.mli lambda/value_rec_compiler.mli lambda/translobj.mli lambda/translattribute.mli lambda/translprim.mli lambda/translcore.mli lambda/translclass.mli lambda/translmod.mli lambda/tmc.mli lambda/simplif.mli lambda/runtimedef.mli file_formats/cmo_format.mli middle_end/internal_variable_names.mli middle_end/linkage_name.mli middle_end/compilation_unit.mli middle_end/variable.mli middle_end/flambda/base_types/closure_element.mli middle_end/flambda/base_types/var_within_closure.mli middle_end/flambda/base_types/tag.mli middle_end/symbol.mli middle_end/flambda/base_types/set_of_closures_id.mli middle_end/flambda/base_types/set_of_closures_origin.mli middle_end/flambda/parameter.mli middle_end/flambda/base_types/static_exception.mli middle_end/flambda/base_types/mutable_variable.mli middle_end/flambda/base_types/closure_id.mli middle_end/flambda/projection.mli middle_end/flambda/base_types/closure_origin.mli middle_end/clambda_primitives.mli middle_end/flambda/allocated_const.mli middle_end/flambda/flambda.mli middle_end/flambda/freshening.mli middle_end/flambda/base_types/export_id.mli middle_end/flambda/simple_value_approx.mli middle_end/flambda/export_info.mli middle_end/backend_var.mli middle_end/clambda.mli file_formats/cmx_format.mli file_formats/cmxs_format.mli bytecomp/instruct.mli bytecomp/meta.mli bytecomp/opcodes.mli bytecomp/bytesections.mli bytecomp/dll.mli bytecomp/symtable.mli driver/pparse.mli driver/compenv.mli driver/main_args.mli driver/compmisc.mli driver/makedepend.mli driver/compile_common.mli utils/config.ml utils/build_path_prefix_map.ml utils/format_doc.ml utils/misc.ml utils/identifiable.ml utils/numbers.ml utils/arg_helper.ml utils/local_store.ml utils/load_path.ml utils/clflags.ml utils/profile.ml utils/terminfo.ml utils/ccomp.ml utils/warnings.ml utils/consistbl.ml utils/linkdeps.ml utils/strongly_connected_components.ml utils/targetint.ml utils/int_replace_polymorphic_compare.ml utils/domainstate.ml utils/binutils.ml utils/lazy_backtrack.ml utils/diffing.ml utils/diffing_with_keys.ml utils/compression.ml parsing/location.ml parsing/unit_info.ml parsing/asttypes.ml parsing/longident.ml parsing/docstrings.ml parsing/syntaxerr.ml parsing/ast_helper.ml parsing/ast_iterator.ml parsing/builtin_attributes.ml parsing/camlinternalMenhirLib.ml parsing/parser.ml parsing/lexer.mli parsing/lexer.ml parsing/pprintast.ml parsing/parse.ml parsing/printast.ml parsing/ast_mapper.ml parsing/attr_helper.ml parsing/ast_invariants.ml parsing/depend.ml typing/ident.ml typing/path.ml typing/primitive.ml typing/type_immediacy.ml typing/shape.ml typing/types.ml typing/data_types.ml typing/rawprinttyp.ml typing/gprinttyp.ml typing/btype.ml typing/oprint.ml typing/subst.ml typing/predef.ml typing/datarepr.ml file_formats/cmi_format.ml typing/persistent_env.ml typing/env.ml typing/errortrace.ml typing/typedtree.ml typing/signature_group.ml typing/printtyped.ml typing/ctype.ml typing/out_type.ml typing/printtyp.ml typing/errortrace_report.ml typing/includeclass.ml typing/mtype.ml typing/envaux.ml typing/includecore.ml typing/tast_iterator.ml typing/tast_mapper.ml typing/stypes.ml typing/shape_reduce.ml file_formats/cmt_format.ml typing/cmt2annot.ml typing/untypeast.ml typing/includemod.ml typing/includemod_errorprinter.ml typing/typetexp.ml typing/printpat.ml typing/patterns.ml typing/parmatch.ml typing/typedecl_properties.ml typing/typedecl_variance.ml typing/typedecl_unboxed.ml typing/typedecl_immediacy.ml typing/typedecl_separability.ml typing/typeopt.ml typing/typedecl.ml typing/value_rec_check.ml typing/typecore.ml typing/typeclass.ml typing/typemod.ml lambda/debuginfo.ml lambda/lambda.ml lambda/printlambda.ml lambda/switch.ml lambda/matching.ml lambda/value_rec_compiler.ml lambda/translobj.ml lambda/translattribute.ml lambda/translprim.ml lambda/translcore.ml lambda/translclass.ml lambda/translmod.ml lambda/tmc.ml lambda/simplif.ml lambda/runtimedef.ml bytecomp/meta.ml bytecomp/opcodes.ml bytecomp/bytesections.ml bytecomp/dll.ml bytecomp/symtable.ml driver/pparse.ml driver/compenv.ml driver/main_args.ml driver/compmisc.ml driver/makedepend.ml driver/compile_common.ml
<span class="gp">$</span><span class="w"> </span>ocamlc <span class="nt">-I</span> utils <span class="nt">-I</span> parsing <span class="nt">-I</span> typing <span class="nt">-I</span> bytecomp <span class="nt">-I</span> file_formats <span class="nt">-I</span> lambda <span class="nt">-I</span> middle_end <span class="nt">-I</span> middle_end/closure <span class="nt">-I</span> middle_end/flambda <span class="nt">-I</span> middle_end/flambda/base_types <span class="nt">-I</span> driver <span class="nt">-I</span> runtime <span class="nt">-g</span> <span class="nt">-strict-sequence</span> <span class="nt">-principal</span> <span class="nt">-absname</span> <span class="nt">-w</span> +a-4-9-40-41-42-44-45-48 <span class="nt">-warn-error</span> +a <span class="nt">-bin-annot</span> <span class="nt">-strict-formats</span> <span class="nt">-a</span> <span class="nt">-o</span> compilerlibs/ocamlbytecomp.cma bytecomp/bytegen.mli bytecomp/printinstr.mli bytecomp/emitcode.mli bytecomp/bytelink.mli bytecomp/bytelibrarian.mli bytecomp/bytepackager.mli driver/errors.mli driver/compile.mli driver/maindriver.mli bytecomp/instruct.ml bytecomp/bytegen.ml bytecomp/printinstr.ml bytecomp/emitcode.ml bytecomp/bytelink.ml bytecomp/bytelibrarian.ml bytecomp/bytepackager.ml driver/errors.ml driver/compile.ml driver/maindriver.ml
<span class="gp">$</span><span class="w"> </span>ocamlc <span class="nt">-I</span> utils <span class="nt">-I</span> parsing <span class="nt">-I</span> typing <span class="nt">-I</span> bytecomp <span class="nt">-I</span> file_formats <span class="nt">-I</span> lambda <span class="nt">-I</span> middle_end <span class="nt">-I</span> middle_end/closure <span class="nt">-I</span> middle_end/flambda <span class="nt">-I</span> middle_end/flambda/base_types <span class="nt">-I</span> driver <span class="nt">-I</span> runtime <span class="nt">-g</span> <span class="nt">-compat-32</span> <span class="nt">-o</span> ocamlc <span class="nt">-strict-sequence</span> <span class="nt">-principal</span> <span class="nt">-absname</span> <span class="nt">-w</span> +a-4-9-40-41-42-44-45-48 <span class="nt">-warn-error</span> +a <span class="nt">-bin-annot</span> <span class="nt">-strict-formats</span> compilerlibs/ocamlcommon.cma compilerlibs/ocamlbytecomp.cma driver/main.mli driver/main.ml
</code></pre></div></div>

<p>I wanted to try a different angle on the <code class="language-plaintext highlighter-rouge">Load_path</code>, and this time produced a
function which <em>predicts</em> the files in the tree. The rules for this were pretty
easy for me to define, and I wasn’t sure I could face watching Claude
special-case everything. 130 lines of verifiably correct hacked OCaml later, I
had my load path function. A little bit more code later, those three commands
above were translated into an OCaml script (based on the ocamlcommon and
ocamlbytecomp libraries) which should exactly the same build. It ran - and it
built the compiler.</p>

<p><code class="language-plaintext highlighter-rouge">ocamlc</code> was, pleasingly, <em>exactly</em> the same. The .cma files, however, were not.
For ocamlcommon.cma, that turned out to be me being sloppy with my commands.
<code class="language-plaintext highlighter-rouge">ocamlcommon.cma</code> is linked with <code class="language-plaintext highlighter-rouge">-linkall</code>, but
<code class="language-plaintext highlighter-rouge">ocamlc -a foo.cma -linkall bar.cmo</code> is not the same as
<code class="language-plaintext highlighter-rouge">ocamlc -a foo.cma -linkall bar.ml</code>, because <code class="language-plaintext highlighter-rouge">-linkall</code> gets recorded in the
.cmo file <em>as well</em>. Easy fix - but the files were still different. A bit more
tweaking and I could see that actually the .cmo files were different.</p>

<p>A bit more poking and checking with <code class="language-plaintext highlighter-rouge">ocamlobjinfo</code> and a few other flags and
tricks, and I observed that:</p>

<div class="language-console highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="gp">$</span><span class="w"> </span>ocamlc <span class="nt">-g</span> <span class="nt">-c</span> utils/config.ml
</code></pre></div></div>

<p>resulted in slightly different <em>debug information</em> from:</p>

<div class="language-console highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="gp">$</span><span class="w"> </span>console <span class="nt">-g</span> <span class="nt">-c</span> utils/config.mli utils/config.ml
</code></pre></div></div>

<p>(it’s observably to do with the debug information - omit the <code class="language-plaintext highlighter-rouge">-g</code> and they’re
all identical). Lots to suspect here, but time for…</p>

<div class="language-console highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="gp">$</span><span class="w"> </span>claude
<span class="go">╭───────────────────────────────────────────────────╮
│ ✻ Welcome to Claude Code!                         │
</span></code></pre></div></div>

<p>The problem was easy to state, but not quite so quick to come up with a
conclusive explanation. Claude, like most of these models, appears not to have
been trained on <a href="https://www.researchgate.net/figure/Then-a-Miracle-Occurs-Copyrighted-artwork-by-Sydney-Harris-Inc-All-materials-used-with_fig2_302632920">this old cartoon</a>,
and very merrily buzzes along for a few rounds of investigation, followed by a
highly dubious explanation for how it was probably something to do with
marshalling and, mumble mumble, the final binaries are the same so this bug is
probably OK.</p>

<p>Hmm. A few rounds of, “no, this needs to be equivalent as otherwise it’s not
reproducible” (“You’re so right!”), and we had a lot of test programs, a
frequent need for reminders that debugging OCaml’s Marshalling format was
possibly not going to help, but we weren’t very much closer to an answer.</p>

<p>Stepping back, I re-framed the problem, instead asking Claude to produce a
program which would give a textual dump of the debug information in each file,
so we could compare it. This was interesting - especially the occasional
hallucinations at having analysed “all the fields”, but we got there.</p>

<p>What was interesting was that we were struggling to perceive differences between
anything. Claude at this point was desperate to delve into the runtime code and
start doing hex-dumps of the marshal format to see what was actually different.
I appear to be a little older than Claude, and was more reticent about this
approach. I suggested we look at the polymorphic hash of some of these fields
instead. At this point, we started to see some differences - Claude’s inferences
at this point were working well, and there was a strong suggestion to add all
sorts of accessor functions into the <code class="language-plaintext highlighter-rouge">Types</code> module to be able to introspect
some of the values in more detail than normally intended (i.e. polymorphic hash
was telling that us that some abstract values were different, but we wanted to
see what the differences really were).</p>

<p>Reader, I told it to use <code class="language-plaintext highlighter-rouge">Obj.magic</code> instead 🫣</p>

<p>However, what happened next was truly fascinating and definitely very efficient.
The value being returned for one of the type IDs was simply not believable. It
was far too <em>high</em>. Claude also correctly observed that it was in fact a block,
and not an integer, which was what we were expecting. The human brain at this
point cuts in, and looks at the type: <code class="language-plaintext highlighter-rouge">Types.get_id: t -&gt; int</code>. No, that
accessor looks right. Brain slowly whirring; look at the code:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">get_id</span> <span class="n">t</span> <span class="o">=</span> <span class="p">(</span><span class="n">repr</span> <span class="n">t</span><span class="p">)</span><span class="o">.</span><span class="n">id</span>
</code></pre></div></div>

<p>Oh - it’s not an accessor (in another life, I could possibly have performed
Claude’s responses…).</p>

<p>All I had to point out was that <code class="language-plaintext highlighter-rouge">Types.get_id</code> was not an accessor, it was
normalising the result (to walk <code class="language-plaintext highlighter-rouge">Tlink</code> members of the type representation), and
Claude was on it, replacing semi-elegant OCaml code with a sea of calls to <code class="language-plaintext highlighter-rouge">Obj</code>
functions.</p>

<p>But we had our answer - the type chain was different, if semantically equivalent
and, more importantly, Claude then leaped to the problem.</p>

<p>The internal <code class="language-plaintext highlighter-rouge">Types.new_id</code> reference isn’t reset between compilations 💥</p>

<p>A quick rebuild later, and the same debug information was given regardless of
whether <code class="language-plaintext highlighter-rouge">utils/config.mli</code> was compiled at the same time as <code class="language-plaintext highlighter-rouge">utils/config.ml</code>.
Go Claude. My contribution was keeping the explorations looking at relevant
parts of the system, and not disappearing off on sometimes ridiculous and
unbelievable tangents. Maybe it would have got there on its own, but who knows
the tokens required and the GPUs scorched…</p>

<p>Plug that back into my little script. ocamlcommon.cma still different. At this
point, a line from <a href="https://en.wikipedia.org/wiki/Four_Weddings_and_a_Funeral">Four Weddings and a Funeral</a>
could be heard loud and clear in the human mind. It’s the one which follows
“Dear Lord, forgive me for what I am about to, ah, say in this magnificent place
of worship…”.</p>

<p>The fix was definitely working. But a quick bit of further experimentation
revealed that including <em>other</em> .mli files before utils/config.ml (and there are
a lot) was causing the information to change.</p>

<p>So:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>$ claude -c
</code></pre></div></div>

<p>As a human of hopefully normal emotional response to situations, the feeling of
being back at square one would normally have meant I’d have at least needed a
coffee before being able to face dusting off all the tools and scripts which had
been constructed in the previous investigations. But here of course the LLM
doesn’t care and was straight into using the tools previously constructed to
look at the revised problem. A lot more <code class="language-plaintext highlighter-rouge">Obj.magic</code>-like investigations later
looking at the shape of some debugging information, and Claude found another bit
to reset, this time in <code class="language-plaintext highlighter-rouge">Ctype</code>. All the level information in the type-checker
isn’t reset between compilations. Not a semantic issue, because the type checker
uses those numbers <em>relatively</em>, but again they leak into the representation of
some of the debugging information.</p>

<p>And it was working 🥳</p>

<p>Next up was trying to put those fixes into something resembling a commit series
that might one day be an acceptable PR. What I really wanted was a test. Claude
was great for this, although it lacks anything approximating taste (and this is
me writing…!). However, with no feelings to be hurt, the pointers were easy to
issue and the results impressive - especially constructing a non-trivial
ocamltest block. The result is previewable in <a href="https://github.com/dra27/ocaml/pull/237/files">dra27/ocaml#237</a>
on my GitHub fork, and the test is entirely Claude’s.</p>

<p>Having got to this stage, I extended the compiler with some of Lucas’s patches,
and started passing just the .ml files for compilation, allowing the compiler to
compile the .mli files on demand, as before. With some idle tinkering, I got to
the end of “coreall”, which is the point in OCaml’s build process where
<code class="language-plaintext highlighter-rouge">ocamlc</code>, the bytecode versions of everything in <code class="language-plaintext highlighter-rouge">tools/</code> and <code class="language-plaintext highlighter-rouge">ocamllex</code> have
all been compiled, along with the Standard Library. That was all being done from
a single compiler process, where the OCaml script driving the compiler consisted
mostly of the list of .ml files. Coupled with the predictive load path I’d
already put together, at this stage the “plumbing” needed in the scheduler is
just:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">compile_file</span> <span class="n">source_file</span> <span class="bp">()</span> <span class="o">=</span>
  <span class="nn">Compenv</span><span class="p">.</span><span class="n">readenv</span> <span class="nn">Format</span><span class="p">.</span><span class="n">std_formatter</span> <span class="p">(</span><span class="nc">Before_compile</span> <span class="n">source_file</span><span class="p">);</span>
  <span class="k">let</span> <span class="n">output_prefix</span> <span class="o">=</span> <span class="nn">Compenv</span><span class="p">.</span><span class="n">output_prefix</span> <span class="n">source_file</span> <span class="k">in</span>
  <span class="k">if</span> <span class="nn">Filename</span><span class="p">.</span><span class="n">extension</span> <span class="n">source_file</span> <span class="o">=</span> <span class="s2">".mli"</span> <span class="k">then</span>
    <span class="nn">Compile</span><span class="p">.</span><span class="n">interface</span> <span class="o">~</span><span class="n">source_file</span> <span class="o">~</span><span class="n">output_prefix</span>
  <span class="k">else</span>
    <span class="k">let</span> <span class="n">start_from</span> <span class="o">=</span> <span class="nn">Clflags</span><span class="p">.</span><span class="nn">Compiler_pass</span><span class="p">.</span><span class="nc">Parsing</span> <span class="k">in</span>
    <span class="nn">Compile</span><span class="p">.</span><span class="n">implementation</span> <span class="o">~</span><span class="n">start_from</span> <span class="o">~</span><span class="n">source_file</span> <span class="o">~</span><span class="n">output_prefix</span>

<span class="k">let</span> <span class="k">rec</span> <span class="n">execute</span> <span class="n">task</span> <span class="o">=</span>
  <span class="k">try</span> <span class="n">task</span> <span class="bp">()</span>
  <span class="k">with</span> <span class="n">effect</span> <span class="p">(</span><span class="nn">Load_path</span><span class="p">.</span><span class="nc">Missing</span> <span class="n">path</span><span class="p">)</span><span class="o">,</span> <span class="n">k</span> <span class="o">-&gt;</span>
    <span class="k">let</span> <span class="n">file</span> <span class="o">=</span> <span class="nn">Filename</span><span class="p">.</span><span class="n">chop_extension</span> <span class="n">path</span> <span class="o">^</span> <span class="s2">".mli"</span> <span class="k">in</span>
    <span class="n">execute</span> <span class="p">(</span><span class="n">compile_file</span> <span class="n">file</span><span class="p">);</span>
    <span class="n">execute</span> <span class="p">(</span><span class="nn">Effect</span><span class="p">.</span><span class="nn">Deep</span><span class="p">.</span><span class="n">continue</span> <span class="n">k</span><span class="p">)</span>
</code></pre></div></div>

<p>(as an aside, when it goes to being done with Domains I’ll possibly switch it to
a shallow handler, because the call stack with the deep handlers isn’t as
reasonable as I’d hoped for, but to be honest I just wanted to see it work!)</p>

<p>Fascinatingly, all the artefacts (.cma and binaries) being produced were
identical except for the <code class="language-plaintext highlighter-rouge">Lazy</code> module in the Standard Library!</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>$ claude -c
</code></pre></div></div>

<p>Claude was simultaneously amazing and useless at this. Amazing, because I was
prompting some of this while cooking a meal, so being able to bark an
instruction (actually, I hadn’t set it up for voice - I was just quickly
typing) and then leave it to think for a minute or two was strangely efficient,
because investigating this on my own would have taken too much continuous
concentration. It was useless because we didn’t get anywhere near a believable
explanation, despite various efforts at resetting things. Sometimes you just
have to say <code class="language-plaintext highlighter-rouge">/exit</code> (and eat a meal…).</p>

<p>However, after the aforementioned meal, I dug into it a bit further. The issue
here was clearly to do with some state in the compiler - if ocamlcommon.cma or
ocamlmiddleend.cma were compiled, then the Lazy module differed. Incidentally,
at this point this wasn’t debug information which varied, it was the actual
module, but it was still semantically the same. Claude had correctly identified
that it was to do with the marshalling, and we had identified that there was a
difference in string sharing (so not entirely useless, in fairness). I carried
on poking and, with a little bit of jerry-rigging, managed to determine the
relatively small set of files in flambda and in ocamlcommon whose compilation
caused the change in Lazy. I was highly suspicious it was to do with compilation
of lazy values.</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>$ claude -c
</code></pre></div></div>

<p>Feeding this information to Claude was a much better trick - the reasoning at
this point would contradict its own tangents (“I should look at … but wait,
the user has given me the list of affected files”). Impressively, we did hone in
on the much more complex explanation for this third issue, which is to do with
lazy values used in globals in the <code class="language-plaintext highlighter-rouge">Matching</code> module. In this particular case,
if the compiler has compiled a file which matched on a lazy, causing
<code class="language-plaintext highlighter-rouge">Matching.code_force_lazy_block</code> to be forced in the compiler and thus the
<code class="language-plaintext highlighter-rouge">CamlinternalLazy</code> identified to be added to the current persistent environment,
then a subsequent module (in this case <code class="language-plaintext highlighter-rouge">lazy.ml</code> in the Standard Library) which
<em>both</em> pattern matches on a lazy and which also refers to <code class="language-plaintext highlighter-rouge">CamlinternalLazy</code>
ends up with two extern’d string representations of <code class="language-plaintext highlighter-rouge">CamlinternalLazy</code> instead
of one. The reason is that the forced code block in <code class="language-plaintext highlighter-rouge">Matching</code> still refers to a
string used in a <em>previous</em> persistent environment. It’s not a semantic issue at
all, but it manifests itself because the string is not shared when the
subsequent file looks up the <code class="language-plaintext highlighter-rouge">CamlinternalLazy</code> identifier.</p>

<p>It was a battle to update the test to show this behaviour, but in fairness that
would have been a battle anyway! However, we got there too.</p>

<p>Three reproducibility issues identified, and a viable PR produced - with tests!</p>
