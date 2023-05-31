---
title: Writing Lifters Using Primus Lisp
description: The Binary Analysis Platform Blog
url: http://binaryanalysisplatform.github.io/2021/09/15/writing-lifters-using-primus-lisp/
date: 2021-09-15T00:00:00-00:00
preview_image:
featured:
authors:
- bap
---

<h1>Defining instructions semantics using Primus Lisp (Tutorial)</h1>

<h2>Introduction</h2>

<p>So you found a machine instruction that is not handled by <a href="https://github.com/BinaryAnalysisPlatform/bap">BAP</a> and you wonder how to add it to BAP. This is the tutorial that will gently guide you through the whole process of discovering the instruction, studying its semantics, encoding it, testing, and finally submitting to BAP. The latter is optional but highly appreciated.</p>

<p>In modern BAP, the easiest option is to use <a href="https://binaryanalysisplatform.github.io/bap/api/master/bap-primus/Bap_primus/Std/Primus/Lisp/index.html">Primus Lisp</a> to define new instructions. The idea is that for each instruction, you describe its effects using Primus Lisp. No recompilation or OCaml coding is required. For example here is the semantics of the <code class="language-plaintext highlighter-rouge">tst</code> instruction in the thumb mode taken from BAP,</p>

<div class="language-lisp highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="p">(</span><span class="nb">defun</span> <span class="nv">tTST</span> <span class="p">(</span><span class="nv">rn</span> <span class="nv">rm</span> <span class="nv">_</span> <span class="nv">_</span><span class="p">)</span>
  <span class="s">&quot;tst rn, rm&quot;</span>
  <span class="p">(</span><span class="k">let</span> <span class="p">((</span><span class="nv">rd</span> <span class="p">(</span><span class="nb">logand</span> <span class="nv">rn</span> <span class="nv">rm</span><span class="p">)))</span>
    <span class="p">(</span><span class="nb">set</span> <span class="nv">ZF</span> <span class="p">(</span><span class="nv">is-zero</span> <span class="nv">rd</span><span class="p">))</span>
    <span class="p">(</span><span class="nb">set</span> <span class="nv">NF</span> <span class="p">(</span><span class="nv">msb</span> <span class="nv">rd</span><span class="p">))))</span>
</code></pre></div></div>

<p>You now probably have the question: what is <code class="language-plaintext highlighter-rouge">tTST</code> and why it has four parameters? We use LLVM (and now Ghidra) as the disassembler backend and when we write a lifter (i.e., when we define the semantics of instructions) we rely on the representation of instructions that are provided by the backend. In LLVM it is MC Instructions, which more or less corresponds to LLVM <a href="https://llvm.org/docs/MIRLangRef.html">MIR</a>.</p>

<h2>Picking an instruction</h2>

<p>So let&rsquo;s find some ARM instruction that is not yet handled by BAP and use it as a working example. The bap mc command is an ideal companion in writing lifters (mc - stands for machine code), as it lets you work with individual instructions. Besides, I wasn&rsquo;t able to find any ARM instruction that we do not handle (except co-processors instructions, which are not interesting from the didactic perspective) so we will be working with the thumb2 instruction set. So first of all, we need a binary encoding for the instruction that we would like to lift. If you don&rsquo;t have one then use llvm-mc (or any other assembler). The encoding (which I found from some wild-caught arm binary is <code class="language-plaintext highlighter-rouge">2d e9 f8 43</code> and we can disassemble it using bap mc</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>$ bap mc --arch=thumb --show-insn=asm -- 2d e9 f8 43
push.w {r3, r4, r5, r6, r7, r8, r9, lr}
</code></pre></div></div>

<p>Or, if we want to go the other way around, from assembly to binary encoding then here is the llvm-mc command-line,</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>$ echo &quot;push.w {r3, r4, r5, r6, r7, r8, r9, lr}&quot; | llvm-mc -triple=thumb -mattr=thumb2 --show-inst -show-encoding
    .text
    push.w    {r3, r4, r5, r6, r7, r8, r9, lr} @ encoding: [0x2d,0xe9,0xf8,0x43]
                                        @ &lt;MCInst #4118 t2STMDB_UPD
                                        @  &lt;MCOperand Reg:15&gt;
                                        @  &lt;MCOperand Reg:15&gt;
                                        @  &lt;MCOperand Imm:14&gt;
                                        @  &lt;MCOperand Reg:0&gt;
                                        @  &lt;MCOperand Reg:75&gt;
                                        @  &lt;MCOperand Reg:76&gt;
                                        @  &lt;MCOperand Reg:77&gt;
                                        @  &lt;MCOperand Reg:78&gt;
                                        @  &lt;MCOperand Reg:79&gt;
                                        @  &lt;MCOperand Reg:80&gt;
                                        @  &lt;MCOperand Reg:81&gt;
                                        @  &lt;MCOperand Reg:13&gt;&gt;
</code></pre></div></div>

<p>Now we need to get full information about the instruction name. In BAP, all instruction names are packaged in namespaces to enable multiple backends. To get full information about the instruction encoding and decoding we will use the &ndash;show-knowledge option of bap mc. This command-line option will instruct BAP to dump the whole knowledge base, so it will have everything that bap knows so far about the instruction. The property that we&rsquo;re looking for, is <code class="language-plaintext highlighter-rouge">bap:lisp-name</code> and <code class="language-plaintext highlighter-rouge">bap:insn</code>. The first will give us the true name and the last will show us how the instruction and operands are represented, e.g.,</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>$ bap mc --arch=thumb --show-knowledge -- 2d e9 f8 43 | grep lisp-name
   (bap:lisp-name (llvm-thumb:t2STMDB_UPD))
$ bap mc --arch=thumb --show-knowledge -- 2d e9 f8 43 | grep bap:insn
   (bap:insn ((t2STMDB_UPD SP SP 0xe Nil R3 R4 R5 R6 R7 R8 R9 LR)))
</code></pre></div></div>

<h2>Writing the stub semantics</h2>

<p>Okay, now we have nearly all the knowledge so we can start writing the semantics. Let&rsquo;s start with some stub semantics, we will later look into the instruction set manual and learn the instruction semantics, but we want to make sure that BAP loads our files and calls our semantics function.</p>

<p>BAP searches for the semantics file in a number of predefined locations (see <code class="language-plaintext highlighter-rouge">bap --help</code> and search for <code class="language-plaintext highlighter-rouge">--primus-lisp-semantics</code> option for more details). The default locations include you <code class="language-plaintext highlighter-rouge">$HOME/.local/share/bap/primus/semantics</code> and the system-wide location that is usually dependent on your installation (usually it is in an opam switch in <code class="language-plaintext highlighter-rouge">&lt;opam-switch&gt;/share/bap/primus/semantics</code>. So you can either place your file in the home location or just pick an arbitrary location and tell bap where to search for it using <code class="language-plaintext highlighter-rouge">--bap-primus-semantics=&lt;dir&gt;</code>. In our example, we use the current folder (denoted with <code class="language-plaintext highlighter-rouge">.</code> in Unix systems) where we create a file named <code class="language-plaintext highlighter-rouge">extra-thumb2.lisp</code> (the name of the file doesn&rsquo;t really matter for the purposes of example, as long as it has the <code class="language-plaintext highlighter-rouge">.lisp</code> extension).</p>

<p>Now, we can create the stub definition of the instruction,</p>
<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>$ cat extra-thumb2.lisp
(defun llvm-thumb:t2STMDB_UPD (_ _ _ _ _ _ _ _ _ _ _ _)
  (msg &quot;yay, it works&quot;))
</code></pre></div></div>
<p>and let&rsquo;s check that bap properly dispatches the semantics,</p>
<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>$ bap mc --arch=thumb --primus-lisp-semantics=. --show-bil -- 2d e9 f8 43
yay, it works
{

}
</code></pre></div></div>

<h2>Learning the instruction semantics</h2>

<p>So what does this series of <code class="language-plaintext highlighter-rouge">_ _ _ _ ...</code> mean? We see that bap applies <code class="language-plaintext highlighter-rouge">t2STMDB_UPD</code> as</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>bap mc --arch=thumb --show-knowledge -- 2d e9 f8 43 | grep bap:insn
   (bap:insn ((t2STMDB_UPD SP SP 0xe Nil R3 R4 R5 R6 R7 R8 R9 LR)))
</code></pre></div></div>

<p>So it has 12 operands. We haven&rsquo;t yet learned their semantics so we just ignored them. In Primus Lisp, like in OCaml, you can use the wildcard character as the argument name, if you&rsquo;re not using it. Now it is time to figure out what do they mean. The encoding of the llvm machine instruction is defined in the LLVM <a href="https://llvm.org/docs/TableGen/">target description (*.td)</a> files, which we can find in the LLVLM GitHub repository, namely, we <a href="https://github.com/llvm/llvm-project/blob/1a56a291c5ab4681fb34386f1501336545daa8d6/llvm/lib/Target/ARM/ARMInstrThumb2.td#L5048-L5049">can learn</a>,</p>
<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>// PUSH/POP aliases for STM/LDM
def : t2InstAlias&lt;&quot;push${p}.w $regs&quot;, (t2STMDB_UPD SP, pred:$p, reglist:$regs)&gt;;
</code></pre></div></div>
<p>So now we know that <code class="language-plaintext highlighter-rouge">push.w regs</code> is an alias (syntactic sugar) to <code class="language-plaintext highlighter-rouge">stmdb sp!, {r3, r4, r5, r6, r7, r8, r9, lr}</code> (or even <code class="language-plaintext highlighter-rouge">stmdb sp!, {r3-r9, lr</code>}. Let&rsquo;s check that our gues is correct using <code class="language-plaintext highlighter-rouge">llvm-mc</code>,</p>
<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>$ echo 'stmdb sp!, {r3-r9, lr}' | llvm-mc -triple=thumb -mattr=thumb2 -show-encoding
    .text
    push.w    {r3, r4, r5, r6, r7, r8, r9, lr} @ encoding: [0x2d,0xe9,0xf8,0x43]
</code></pre></div></div>

<p>Indeed, the encoding is the same. So now it is time to download an <a href="https://developer.arm.com/documentation/100076/0100/a32-t32-instruction-set-reference">instruction reference</a> and look for the <code class="language-plaintext highlighter-rouge">stm</code> instruction. It is on page 357 of the pdf version, in section c2.141, and it says that instruction stores multiple registers. The <code class="language-plaintext highlighter-rouge">db</code> suffix is the addressing mode that instructs us to Decrement the address Before each store operation. And the <code class="language-plaintext highlighter-rouge">!</code> suffix (encoded as <code class="language-plaintext highlighter-rouge">_UPD</code> in llvm) prescribes us to store the final address back to the destination register. This is a high-level reference intended for <code class="language-plaintext highlighter-rouge">asm</code> programmers, so if we need more details with the precisely described semantics we can also look into the <a href="https://developer.arm.com/documentation/ddi0406/latest">ARM Architecture Reference Manual</a> (the <a href="https://documentation-service.arm.com/static/5f8daeb7f86e16515cdb8c4e?token=">pdf file</a>). Here is the semantics obtained from this reference, which is described in the ARM pseudocode,</p>

<p><img src="https://files.gitter.im/552697e015522ed4b3dec2a1/YxnQ/2021-09-13-133357_455x249_scrot.png" alt="arm pseudocode"/></p>

<p>(I had to screen-shot it, as the indentation matters in their pseudo-code but it could not be copied properly from the pdf file).</p>

<h2>Learning Primus Lisp</h2>

<p>So we&rsquo;re now ready to write some lisp code. You may have already skimmed through the <a href="https://binaryanalysisplatform.github.io/bap/api/master/bap-primus/Bap_primus/Std/Primus/Lisp/index.html">Primus Lisp documentation</a> that describes the syntax and semantics of the language. If you didn&rsquo;t don&rsquo;t worry (but it is still advised to do this eventually). Primus Lisp is a Lisp dialect that looks much like Common Lisp. Since it is Lisp, it has a very simple syntax - everything is an s-expression, i.e., either an atom, e.g., 1, &lsquo;hello, r0, or an application of a name to a list of arguments, e.g., (malloc 100) or (malloc (sizeof ptr_t)). The semantics of Primus Lisp is very simple as well. Basically, Primus Lisp is a universal syntax for assemblers. There is no other data type than bitvectors. From the perspective of the type system we distinguish bitvectors by their sizes, e.g., 0x1:1 is a one-bitvector with the only bit set to 1 and 0x1:16 is a 16-bitvector which has different size and different value and is a 16-bit word with the lower bit set to 1. All operations evaluate to words and accept words. Now what operations you can use? We can use BAP to get the up-to-date documentation for Primus Lisp. For this we will use the primus-lisp-documentation command (we need to pass the &ndash;semantics option as we have two interperters for Primus Lips, one for dynamic execution and another for static execution, which have different libraries and slightly different set of primitives),</p>
<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>bap primus-lisp-documentation --semantics &gt; semantics.org
</code></pre></div></div>

<p>This command will generate the API documentation in the emacs org-mode. If you don&rsquo;t want to use Emacs to read this file then you can use <code class="language-plaintext highlighter-rouge">pandoc</code> to transform it to any format you like, e.g.,</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>pandoc semantics.org -o semantics.pdf
</code></pre></div></div>

<p>That will generate the <a href="https://files.gitter.im/552697e015522ed4b3dec2a1/xo1n/semantics.pdf">following document</a>.</p>

<h2>Encoding semantics (the first attempt)</h2>

<p>Now, after we skimmed through the documentation, let&rsquo;s make our first ugly (and may be incorrect) attempt to describe the semantics of the instruction,</p>

<div class="language-lisp highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="p">(</span><span class="nb">defun</span> <span class="nv">llvm-thumb:t2STMDB_UPD</span> <span class="p">(</span><span class="nv">dst</span> <span class="nv">base</span> <span class="nv">_pred</span> <span class="nv">_?</span> <span class="nv">r1</span> <span class="nv">r2</span> <span class="nv">r3</span> <span class="nv">r4</span> <span class="nv">r5</span> <span class="nv">r6</span> <span class="nv">r7</span> <span class="nv">r8</span><span class="p">)</span>
  <span class="p">(</span><span class="k">let</span> <span class="p">((</span><span class="nv">len</span> <span class="mi">8</span><span class="p">)</span>
        <span class="p">(</span><span class="nv">stride</span> <span class="p">(</span><span class="nv">sizeof</span> <span class="nv">word-width</span><span class="p">))</span>
        <span class="p">(</span><span class="nv">ptr</span> <span class="p">(</span><span class="nb">-</span> <span class="nv">base</span> <span class="p">(</span><span class="nb">*</span> <span class="nv">len</span> <span class="nv">stride</span><span class="p">))))</span>
    <span class="p">(</span><span class="nv">store-word</span> <span class="p">(</span><span class="nb">+</span> <span class="nv">ptr</span> <span class="p">(</span><span class="nb">*</span> <span class="nv">stride</span> <span class="mi">0</span><span class="p">))</span> <span class="nv">r1</span><span class="p">)</span>
    <span class="p">(</span><span class="nv">store-word</span> <span class="p">(</span><span class="nb">+</span> <span class="nv">ptr</span> <span class="p">(</span><span class="nb">*</span> <span class="nv">stride</span> <span class="mi">1</span><span class="p">))</span> <span class="nv">r2</span><span class="p">)</span>
    <span class="p">(</span><span class="nv">store-word</span> <span class="p">(</span><span class="nb">+</span> <span class="nv">ptr</span> <span class="p">(</span><span class="nb">*</span> <span class="nv">stride</span> <span class="mi">2</span><span class="p">))</span> <span class="nv">r3</span><span class="p">)</span>
    <span class="p">(</span><span class="nv">store-word</span> <span class="p">(</span><span class="nb">+</span> <span class="nv">ptr</span> <span class="p">(</span><span class="nb">*</span> <span class="nv">stride</span> <span class="mi">3</span><span class="p">))</span> <span class="nv">r4</span><span class="p">)</span>
    <span class="p">(</span><span class="nv">store-word</span> <span class="p">(</span><span class="nb">+</span> <span class="nv">ptr</span> <span class="p">(</span><span class="nb">*</span> <span class="nv">stride</span> <span class="mi">4</span><span class="p">))</span> <span class="nv">r5</span><span class="p">)</span>
    <span class="p">(</span><span class="nv">store-word</span> <span class="p">(</span><span class="nb">+</span> <span class="nv">ptr</span> <span class="p">(</span><span class="nb">*</span> <span class="nv">stride</span> <span class="mi">5</span><span class="p">))</span> <span class="nv">r6</span><span class="p">)</span>
    <span class="p">(</span><span class="nv">store-word</span> <span class="p">(</span><span class="nb">+</span> <span class="nv">ptr</span> <span class="p">(</span><span class="nb">*</span> <span class="nv">stride</span> <span class="mi">6</span><span class="p">))</span> <span class="nv">r7</span><span class="p">)</span>
    <span class="p">(</span><span class="nv">store-word</span> <span class="p">(</span><span class="nb">+</span> <span class="nv">ptr</span> <span class="p">(</span><span class="nb">*</span> <span class="nv">stride</span> <span class="mi">7</span><span class="p">))</span> <span class="nv">r8</span><span class="p">)</span>
    <span class="p">(</span><span class="nv">set$</span> <span class="nv">dst</span> <span class="nv">ptr</span><span class="p">)))</span>
</code></pre></div></div>

<p>and before getting into the details, let&rsquo;s see how bap translates this semantics to BIL,</p>
<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>$ bap mc --arch=thumb --primus-lisp-semantics=. --show-bil -- 2d e9 f8 43
{
  #3 := SP - 0x20
  mem := mem with [#3, el]:u32 &lt;- R3
  mem := mem with [#3 + 4, el]:u32 &lt;- R4
  mem := mem with [#3 + 8, el]:u32 &lt;- R5
  mem := mem with [#3 + 0xC, el]:u32 &lt;- R6
  mem := mem with [#3 + 0x10, el]:u32 &lt;- R7
  mem := mem with [#3 + 0x14, el]:u32 &lt;- R8
  mem := mem with [#3 + 0x18, el]:u32 &lt;- R9
  mem := mem with [#3 + 0x1C, el]:u32 &lt;- LR
  SP := #3
}
</code></pre></div></div>
<p>The result looks good and, maybe even correct, but let&rsquo;s explore the lisp code.</p>

<p>The first thing to notice is that instead of using <code class="language-plaintext highlighter-rouge">_ _ ...</code> placeholders we gave each parameter a name. The first parameter is the destination register (it is the llvm rule that all functions that update a register have this register as the first parameter), then we have the base register (in our working example the destination and the base register are the same). Next, we have the _pred which we currently ignore, but will return later. We use the _ prefix to indicate that it is unused. Then there is an operand of unknown purpose, which we denoted as <code class="language-plaintext highlighter-rouge">_?</code> (I usually just blank them with <code class="language-plaintext highlighter-rouge">_</code>, but this is to show that lisp allows you to use any non-whitespace characters in the identifier). Finally, we have <code class="language-plaintext highlighter-rouge">r1</code> til <code class="language-plaintext highlighter-rouge">r8</code>, which binds the passed registers. Here, <code class="language-plaintext highlighter-rouge">r1</code> denotes not the register <code class="language-plaintext highlighter-rouge">r1</code> of ARM but the first register passed to the function, i.e., <code class="language-plaintext highlighter-rouge">r3</code> in our example. (It is to show that you can pick any names for your parameters and that they can even shadow the globally defined target-specific register names, which is probably a bad idea from the readability perspective, choosing something like <code class="language-plaintext highlighter-rouge">xN</code> would be probably a better idea).</p>

<p>Now it is time to look into the body of the function. First of all, we used <code class="language-plaintext highlighter-rouge">(let (&lt;bindings&gt;) &lt;body&gt;)</code> construct to bind several variables. Each binding has the form <code class="language-plaintext highlighter-rouge">(&lt;varN&gt; &lt;exprN&gt;)</code> and it evaluates <code class="language-plaintext highlighter-rouge">&lt;exprN&gt;</code> and binds its value to <code class="language-plaintext highlighter-rouge">&lt;varN&gt;</code> and make it available for expressions <code class="language-plaintext highlighter-rouge">&lt;exprN+1&gt;</code> and in the <code class="language-plaintext highlighter-rouge">&lt;body&gt;</code>, e.g., in the full form,</p>

<div class="language-lisp highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="p">(</span><span class="k">let</span> <span class="p">((</span><span class="nv">&lt;var1&gt;</span> <span class="nv">&lt;expr1&gt;</span><span class="p">)</span>
      <span class="p">(</span><span class="nv">&lt;var2&gt;</span> <span class="nv">&lt;expr2&gt;</span><span class="p">)</span>
      <span class="o">....</span>
      <span class="p">(</span><span class="nv">&lt;varN&gt;</span> <span class="nv">&lt;exprN&gt;</span><span class="p">))</span>
   <span class="nv">&lt;body&gt;</span><span class="p">)</span>
</code></pre></div></div>

<p>we can use <code class="language-plaintext highlighter-rouge">&lt;var1&gt;</code> in <code class="language-plaintext highlighter-rouge">&lt;expr2&gt;, ..., &lt;exprN&gt;</code>, and in the <code class="language-plaintext highlighter-rouge">&lt;body&gt;</code>, i.e., this is the lexical scope of <code class="language-plaintext highlighter-rouge">&lt;var1&gt;</code>. Once the let expression is evaluated <code class="language-plaintext highlighter-rouge">&lt;var1&gt;</code> becomes unbound (or bound to whatever it was bound before. In other words, normal lexical scoping, which is totally equivalent to the OCaml,</p>
<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">var1</span> <span class="o">=</span> <span class="n">expr1</span> <span class="k">in</span>
<span class="k">let</span> <span class="n">var2</span> <span class="o">=</span> <span class="n">expr2</span> <span class="k">in</span>
<span class="o">...</span>
<span class="k">let</span> <span class="n">varN</span> <span class="o">=</span> <span class="n">exprN</span> <span class="k">in</span>
<span class="n">body</span>
</code></pre></div></div>

<p>The let-bound variables are reified into temporary variables in BIL. You may also notice that Primus Lisp Semantic compiler is clever enough and removed the constants. Let&rsquo;s go through the variables.</p>

<p>The first variable is <code class="language-plaintext highlighter-rouge">len</code> is a constant equal to <code class="language-plaintext highlighter-rouge">8</code>, which is the number of registers passed to the function. Unfortunately, llvm encodes the 15 registers not with a bitset (as it is actually represented in the instruction) but as a list of operands. So instead of writing one function, we will need to write 15 overloads per each number of registers in the list.</p>

<p>The next variable is also a constant, but we use a complex expression to describe it, <code class="language-plaintext highlighter-rouge">(sizeof word-width)</code>. The Primus Lisp Semantics Compiler is a meta-interpreter and it computes all values that are known in the static time. As a result, we don&rsquo;t see this constant in the reified code.</p>

<h2>Unleashing the macro power</h2>

<p>Now let&rsquo;s deal with the body. It goes without saying that it is ugly. We have to manually unfold the loop since we don&rsquo;t have a program variable that denotes the set of registers that we have to store, but instead, llvm represents this instruction as a set of 15 overloads. BAP Primus Lisp supports overloads as well, but we definitely won&rsquo;t like to write 15 overloads with repetitive code, it is tedious, error-prone, and insults us as programmers.</p>

<p>Here comes the macro system. Primus Lisp employs a very simple macro system based on term rewriting. For each application <code class="language-plaintext highlighter-rouge">(foo x y z)</code> the parser looks for a definition of macro foo that has the matching number of parameters. If an exact match is found then <code class="language-plaintext highlighter-rouge">(foo x y z)</code> is rewritten with the body of the match. Otherwise, a match with the largest number of parameters is selected and the excess arguments are bound to the last parameter, e.g., if we have</p>

<div class="language-lisp highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="p">(</span><span class="nb">defmacro</span> <span class="nv">foo</span> <span class="p">(</span><span class="nv">x</span> <span class="nv">xs</span><span class="p">)</span> <span class="o">...</span><span class="p">)</span>
</code></pre></div></div>

<p>then it will be called with <code class="language-plaintext highlighter-rouge">x</code> bound to <code class="language-plaintext highlighter-rouge">a</code> and <code class="language-plaintext highlighter-rouge">xs</code> bound to <code class="language-plaintext highlighter-rouge">(b c)</code> if applied as <code class="language-plaintext highlighter-rouge">(foo a b c)</code>, where <code class="language-plaintext highlighter-rouge">a</code>, <code class="language-plaintext highlighter-rouge">b</code>, <code class="language-plaintext highlighter-rouge">c</code> could be arbitrary s-expressions.</p>

<p>The body of the macro may reference itself, i.e., it could be recursive. To illustrate it let&rsquo;s write the simplest recursive macro that will compute the length of the list,</p>
<div class="language-lisp highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="p">(</span><span class="nb">defmacro</span> <span class="nb">length</span> <span class="p">(</span><span class="nv">r</span><span class="p">)</span> <span class="mi">1</span><span class="p">)</span>
<span class="p">(</span><span class="nb">defmacro</span> <span class="nb">length</span> <span class="p">(</span><span class="nv">_</span> <span class="nv">rs</span><span class="p">)</span> <span class="p">(</span><span class="nb">+</span> <span class="mi">1</span> <span class="p">(</span><span class="nb">length</span> <span class="nv">rs</span><span class="p">)))</span>
</code></pre></div></div>
<p>and now we can check that it works by adding</p>

<div class="language-lisp highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="p">(</span><span class="nv">msg</span> <span class="s">&quot;we have $0 registers&quot;</span> <span class="p">(</span><span class="nb">length</span> <span class="nv">r1</span> <span class="nv">r2</span> <span class="nv">r3</span> <span class="nv">r4</span> <span class="nv">r5</span> <span class="nv">r6</span> <span class="nv">r7</span> <span class="nv">r8</span><span class="p">))</span>
</code></pre></div></div>

<p>to the body of our definition. It will print,</p>
<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>we have 0x8 registers
</code></pre></div></div>

<p>Note that macros do not perform any compuations on bitvectors, unlike the Primus meta compiler. The macro engine operates on s-expressions, and <code class="language-plaintext highlighter-rouge">(length r1 r2 r3 r4 r5 r6 r7 r8)</code> is rewritten <code class="language-plaintext highlighter-rouge">(+ 1 (+ 1 (+ 1 (+ 1 (+ 1 (+ 1 (+ 1 1)))))))</code> on the syntatic level and is later reduced by the Primus Meta Compiler into <code class="language-plaintext highlighter-rouge">8</code>.</p>

<p>To solidify the knowledge and to move forward let&rsquo;s write a macro <code class="language-plaintext highlighter-rouge">store-registers</code> that will take an arbitrary number of registers, e.g., <code class="language-plaintext highlighter-rouge">(store-registers base stride off r1 r2 r3 .... rm)</code> which will unfold to a sequence of stores, where each register <code class="language-plaintext highlighter-rouge">rN</code> is stored as <code class="language-plaintext highlighter-rouge">(store-word (+ base (* stride N)) rN)</code>.</p>

<p>First, let&rsquo;s define the base case of our recursion,</p>
<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="p">(</span><span class="n">defmacro</span> <span class="n">store</span><span class="o">-</span><span class="n">registers</span> <span class="p">(</span><span class="n">base</span> <span class="n">stride</span> <span class="n">off</span> <span class="n">reg</span><span class="p">)</span>
  <span class="p">(</span><span class="n">store</span><span class="o">-</span><span class="n">word</span> <span class="p">(</span><span class="o">+</span> <span class="n">base</span> <span class="c">(* stride off)) reg))
</span></code></pre></div></div>
<p>and now the recursive case,</p>
<div class="language-lisp highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="p">(</span><span class="nb">defmacro</span> <span class="nv">store-registers</span> <span class="p">(</span><span class="nv">base</span> <span class="nv">stride</span> <span class="nv">off</span> <span class="nv">reg</span> <span class="nv">regs</span><span class="p">)</span>
  <span class="p">(</span><span class="nb">prog</span>
     <span class="p">(</span><span class="nv">store-registers</span> <span class="nv">base</span> <span class="nv">stride</span> <span class="nv">off</span> <span class="nv">reg</span><span class="p">)</span>
     <span class="p">(</span><span class="nv">store-registers</span> <span class="nv">base</span> <span class="nv">stride</span> <span class="p">(</span><span class="nb">+</span> <span class="nv">off</span> <span class="mi">1</span><span class="p">)</span> <span class="nv">regs</span><span class="p">)))</span>
</code></pre></div></div>
<p>Notice, that the body of the macro must be a single s-expression. There is no so-called <em>implicit body</em> and if we need to chain two expressions we have to explicitly use the <code class="language-plaintext highlighter-rouge">prog</code> construct. This construct has a very simple semantics, <code class="language-plaintext highlighter-rouge">(prog s1 s2 ... sN)</code> means evaluate <code class="language-plaintext highlighter-rouge">s1</code>, then <code class="language-plaintext highlighter-rouge">s2</code>, and so on until <code class="language-plaintext highlighter-rouge">sN</code> and make the result of the whole form equal to the result of the evaluation of the last expression.</p>

<p>And a better representation of the body will be,</p>

<div class="language-lisp highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="p">(</span><span class="nb">defun</span> <span class="nv">llvm-thumb:t2STMDB_UPD</span> <span class="p">(</span><span class="nv">dst</span> <span class="nv">base</span> <span class="nv">_pred</span> <span class="nv">_?</span> <span class="nv">r1</span> <span class="nv">r2</span> <span class="nv">r3</span> <span class="nv">r4</span> <span class="nv">r5</span> <span class="nv">r6</span> <span class="nv">r7</span> <span class="nv">r8</span><span class="p">)</span>
  <span class="p">(</span><span class="k">let</span> <span class="p">((</span><span class="nv">len</span> <span class="mi">8</span><span class="p">)</span>
        <span class="p">(</span><span class="nv">stride</span> <span class="p">(</span><span class="nv">sizeof</span> <span class="nv">word-width</span><span class="p">))</span>
        <span class="p">(</span><span class="nv">ptr</span> <span class="p">(</span><span class="nb">-</span> <span class="nv">base</span> <span class="p">(</span><span class="nb">*</span> <span class="nv">len</span> <span class="nv">stride</span><span class="p">))))</span>
    <span class="p">(</span><span class="nv">store-registers</span> <span class="nv">ptr</span> <span class="nv">stride</span> <span class="mi">0</span> <span class="nv">r1</span> <span class="nv">r2</span> <span class="nv">r3</span> <span class="nv">r4</span> <span class="nv">r5</span> <span class="nv">r6</span> <span class="nv">r7</span> <span class="nv">r8</span><span class="p">)</span>
    <span class="p">(</span><span class="nv">set$</span> <span class="nv">dst</span> <span class="nv">ptr</span><span class="p">)))</span>
</code></pre></div></div>

<p>And let&rsquo;s double-check that we still have the same reification to BIL with</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>$ bap mc --arch=thumb --primus-lisp-semantics=. --show-bil -- 2d e9 f8 43
{
  #3 := SP - 0x20
  mem := mem with [#3, el]:u32 &lt;- R3
  mem := mem with [#3 + 4, el]:u32 &lt;- R4
  mem := mem with [#3 + 8, el]:u32 &lt;- R5
  mem := mem with [#3 + 0xC, el]:u32 &lt;- R6
  mem := mem with [#3 + 0x10, el]:u32 &lt;- R7
  mem := mem with [#3 + 0x14, el]:u32 &lt;- R8
  mem := mem with [#3 + 0x18, el]:u32 &lt;- R9
  mem := mem with [#3 + 0x1C, el]:u32 &lt;- LR
  SP := #3
}
</code></pre></div></div>

<p>In fact, we can also put into a macro the body of our function, and our length macro will be of use here, e.g.,</p>

<div class="language-lisp highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="p">(</span><span class="nb">defun</span> <span class="nv">llvm-thumb:t2STMDB_UPD</span> <span class="p">(</span><span class="nv">dst</span> <span class="nv">base</span> <span class="nv">_pred</span> <span class="nv">_?</span> <span class="nv">r1</span> <span class="nv">r2</span> <span class="nv">r3</span> <span class="nv">r4</span> <span class="nv">r5</span> <span class="nv">r6</span> <span class="nv">r7</span> <span class="nv">r8</span><span class="p">)</span>
  <span class="p">(</span><span class="nv">stmdb_upd</span> <span class="nv">dst</span> <span class="nv">base</span> <span class="nv">r1</span> <span class="nv">r2</span> <span class="nv">r3</span> <span class="nv">r4</span> <span class="nv">r5</span> <span class="nv">r6</span> <span class="nv">r7</span> <span class="nv">r8</span><span class="p">))</span>

<span class="p">(</span><span class="nb">defmacro</span> <span class="nv">stmdb_upd</span> <span class="p">(</span><span class="nv">dst</span> <span class="nv">base</span> <span class="nv">regs</span><span class="p">)</span>
  <span class="p">(</span><span class="k">let</span> <span class="p">((</span><span class="nv">len</span> <span class="p">(</span><span class="nb">length</span> <span class="nv">regs</span><span class="p">))</span>
        <span class="p">(</span><span class="nv">stride</span> <span class="p">(</span><span class="nv">sizeof</span> <span class="nv">word-width</span><span class="p">))</span>
        <span class="p">(</span><span class="nv">ptr</span> <span class="p">(</span><span class="nb">-</span> <span class="nv">base</span> <span class="p">(</span><span class="nb">*</span> <span class="nv">len</span> <span class="nv">stride</span><span class="p">))))</span>
    <span class="p">(</span><span class="nv">store-registers</span> <span class="nv">ptr</span> <span class="nv">stride</span> <span class="mi">0</span> <span class="nv">regs</span><span class="p">)</span>
    <span class="p">(</span><span class="nv">set$</span> <span class="nv">dst</span> <span class="nv">ptr</span><span class="p">)))</span>
</code></pre></div></div>

<h3>A side-note on the macro resolution mechanism</h3>

<p>A small notice on the macro resolution process. Another way of describing it is that the rewriting engine picks the most specific definition. In fact, this is true for the definitions also. The resolution mechanism collects all definitions for the given name that matches the given context and selects the most specific. The context is defined using the Primus Lisp type class mechanism. The only difference between macros and functions (beyond that macros operate on the syntax tree level) is that macros add the number of arguments (arity) to the context so that the definition with the highest arity is ordered after (have precedence over) all other definitions. This is described more thoroughly in the reference documentation. Another important takeaway for us is that when we write a lifter we end up referencing target-specific functions and registers. So we would like to limit the context of the applicability of our functions to the specified target. (Otherwise, our functions will be loaded and type-checked for all architectures, e.g., when an x86 binary is parsed, and we don&rsquo;t want this). Therefore, we should start our lifter with the context declaration that will be automatically attached to each definition in the file,</p>

<div class="language-lisp highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="p">(</span><span class="k">declare</span> <span class="p">(</span><span class="nv">context</span> <span class="p">(</span><span class="nv">target</span> <span class="nv">arm</span><span class="p">)))</span>
</code></pre></div></div>

<h2>Taming names with namespaces and packages</h2>

<p>Now, let&rsquo;s look into the packages. A package is the Common Lisp (and Lisp in general) name for a namespace. A namespace is just a set of names, and each name in Primus Lisp has a package. In fact, when we write <code class="language-plaintext highlighter-rouge">(defmacro stmdb_upd () ...)</code>, i.e., without specifying the namespace, the name is automatically prefixed with the current namespace/package. By default, it is the <code class="language-plaintext highlighter-rouge">user</code> package. So our definition was read by the Lisp reader as <code class="language-plaintext highlighter-rouge">(defmacro user:stmdb_upd ...)</code>. It is not only the macro or function names that are packaged. Any identifier is properly namespaced. So that <code class="language-plaintext highlighter-rouge">(store-registers ptr stride 0 regs)</code> is read as <code class="language-plaintext highlighter-rouge">(user:store-registers user:ptr user:stride 0 user:regs)</code>.</p>

<p>The namespaces are also thoroughly described in the documentation but the rendered documentation is outdated because our bot is broken (I really need to fix it), so right now I can only refer you to the sources of the <a href="https://github.com/BinaryAnalysisPlatform/bap/blob/a9b8a329d63f2f723793a97d29028720ec8e3a18/lib/bap_primus/bap_primus.mli#L2753">documentation in the mli file</a>. And if you have bap installed in opam, then you can also install <code class="language-plaintext highlighter-rouge">odig</code> and <code class="language-plaintext highlighter-rouge">odoc</code> and use <code class="language-plaintext highlighter-rouge">odig</code> doc bap to generate and read the documentation on your machine. (It will spill an error but just repeat and it will show the correctly rendered documentation, it is a bug upstream that we have reported but&hellip; well I have diverged).</p>

<p>what we will do now, we will define the thumb package and llvm-thumb package. The first package will be our working package where we will put all our definitions. And the second package will be specific to llvm,</p>
<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>(defpackage thumb (:use core target arm))
(defpackage llvm-thumb (:use thumb))

(in-package thumb)
</code></pre></div></div>

<p>The <code class="language-plaintext highlighter-rouge">(:use core target arm)</code> stanza means that all definitions in these packages are imported (read &ldquo;copied&rdquo;) into the <code class="language-plaintext highlighter-rouge">thumb</code> package. And the same for <code class="language-plaintext highlighter-rouge">llvm-thumb</code>, basically, <code class="language-plaintext highlighter-rouge">(defpackage llvm-thumb (:use thumb))</code> means copy (export) all definitions from <code class="language-plaintext highlighter-rouge">thumb</code> to <code class="language-plaintext highlighter-rouge">llvm-thumb</code>.</p>

<p>Both <code class="language-plaintext highlighter-rouge">thumb</code> and <code class="language-plaintext highlighter-rouge">llvm-thumb</code> packages are already defined in BAP, so we can just say</p>
<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>(in-package thumb)
</code></pre></div></div>

<p>Unlike Common Lisp, in Primus Lisp, the same package could be defined multiple times and even used before defined. The packages may even mutually import each other. The package system resolves it and finds the least fixed point, but it is probably too much for such a simple tutorial. For us, the main takeaway is that we don&rsquo;t need to write llvm-thumb and are no longer polluting the namespace with our definitions thanks to packaging and contexts.</p>

<h2>The final step, writing overloads</h2>

<p>Unfortunately, there is no macro mechanism that will operate on the definition level and generate definitions from some pattern. We probably will develop something for that, but right now for each overload we still need to write a corresponding function, e.g.,</p>
<div class="language-lisp highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="p">(</span><span class="nb">defun</span> <span class="nv">t2STMDB_UPD</span> <span class="p">(</span><span class="nv">dst</span> <span class="nv">base</span> <span class="nv">_pred</span> <span class="nv">_?</span>
                      <span class="nv">r1</span> <span class="nv">r2</span> <span class="nv">r3</span> <span class="nv">r4</span> <span class="nv">r5</span> <span class="nv">r6</span> <span class="nv">r7</span> <span class="nv">r8</span> <span class="nv">r9</span> <span class="nv">r10</span> <span class="nv">r11</span> <span class="nv">r12</span> <span class="nv">r13</span> <span class="nv">r14</span> <span class="nv">r15</span><span class="p">)</span>
  <span class="p">(</span><span class="nv">stmdb_upd</span> <span class="nv">dst</span> <span class="nv">base</span> <span class="nv">r1</span> <span class="nv">r2</span> <span class="nv">r3</span> <span class="nv">r4</span> <span class="nv">r5</span> <span class="nv">r6</span> <span class="nv">r7</span> <span class="nv">r8</span> <span class="nv">r9</span> <span class="nv">r10</span> <span class="nv">r11</span> <span class="nv">r12</span> <span class="nv">r13</span> <span class="nv">r14</span> <span class="nv">r15</span><span class="p">))</span>
<span class="o">....</span>
<span class="p">(</span><span class="nb">defun</span> <span class="nv">t2STMDB_UPD</span> <span class="p">(</span><span class="nv">dst</span> <span class="nv">base</span> <span class="nv">_pred</span> <span class="nv">_?</span>
                      <span class="nv">r1</span><span class="p">)</span>
  <span class="p">(</span><span class="nv">stmdb_upd</span> <span class="nv">dst</span> <span class="nv">base</span> <span class="nv">r1</span><span class="p">))</span>
</code></pre></div></div>

<p>So that the final version of our code will look like this (see also the <a href="https://gist.github.com/ivg/7ceb427a4bc7b5dd80f4ee467ba963d8">gist</a> version)</p>

<div class="language-lisp highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="p">(</span><span class="k">declare</span> <span class="p">(</span><span class="nv">context</span> <span class="p">(</span><span class="nv">target</span> <span class="nv">arm</span><span class="p">)))</span>

<span class="p">(</span><span class="nb">in-package</span> <span class="nv">thumb</span><span class="p">)</span>

<span class="p">(</span><span class="nb">defun</span> <span class="nv">t2STMDB_UPD</span> <span class="p">(</span><span class="nv">dst</span> <span class="nv">base</span> <span class="nv">_pred</span> <span class="nv">_?</span>
                      <span class="nv">r1</span> <span class="nv">r2</span> <span class="nv">r3</span> <span class="nv">r4</span> <span class="nv">r5</span> <span class="nv">r6</span> <span class="nv">r7</span> <span class="nv">r8</span> <span class="nv">r9</span> <span class="nv">r10</span> <span class="nv">r11</span> <span class="nv">r12</span> <span class="nv">r13</span> <span class="nv">r14</span> <span class="nv">r15</span><span class="p">)</span>
  <span class="p">(</span><span class="nv">stmdb_upd</span> <span class="nv">dst</span> <span class="nv">base</span> <span class="nv">r1</span> <span class="nv">r2</span> <span class="nv">r3</span> <span class="nv">r4</span> <span class="nv">r5</span> <span class="nv">r6</span> <span class="nv">r7</span> <span class="nv">r8</span> <span class="nv">r9</span> <span class="nv">r10</span> <span class="nv">r11</span> <span class="nv">r12</span> <span class="nv">r13</span> <span class="nv">r14</span> <span class="nv">r15</span><span class="p">))</span>

<span class="p">(</span><span class="nb">defun</span> <span class="nv">t2STMDB_UPD</span> <span class="p">(</span><span class="nv">dst</span> <span class="nv">base</span> <span class="nv">_pred</span> <span class="nv">_?</span>
                      <span class="nv">r1</span> <span class="nv">r2</span> <span class="nv">r3</span> <span class="nv">r4</span> <span class="nv">r5</span> <span class="nv">r6</span> <span class="nv">r7</span> <span class="nv">r8</span> <span class="nv">r9</span> <span class="nv">r10</span> <span class="nv">r11</span> <span class="nv">r12</span> <span class="nv">r13</span> <span class="nv">r14</span><span class="p">)</span>
  <span class="p">(</span><span class="nv">stmdb_upd</span> <span class="nv">dst</span> <span class="nv">base</span> <span class="nv">r1</span> <span class="nv">r2</span> <span class="nv">r3</span> <span class="nv">r4</span> <span class="nv">r5</span> <span class="nv">r6</span> <span class="nv">r7</span> <span class="nv">r8</span> <span class="nv">r9</span> <span class="nv">r10</span> <span class="nv">r11</span> <span class="nv">r12</span> <span class="nv">r13</span> <span class="nv">r14</span><span class="p">))</span>

<span class="p">(</span><span class="nb">defun</span> <span class="nv">t2STMDB_UPD</span> <span class="p">(</span><span class="nv">dst</span> <span class="nv">base</span> <span class="nv">_pred</span> <span class="nv">_?</span>
                      <span class="nv">r1</span> <span class="nv">r2</span> <span class="nv">r3</span> <span class="nv">r4</span> <span class="nv">r5</span> <span class="nv">r6</span> <span class="nv">r7</span> <span class="nv">r8</span> <span class="nv">r9</span> <span class="nv">r10</span> <span class="nv">r11</span> <span class="nv">r12</span> <span class="nv">r13</span><span class="p">)</span>
  <span class="p">(</span><span class="nv">stmdb_upd</span> <span class="nv">dst</span> <span class="nv">base</span> <span class="nv">r1</span> <span class="nv">r2</span> <span class="nv">r3</span> <span class="nv">r4</span> <span class="nv">r5</span> <span class="nv">r6</span> <span class="nv">r7</span> <span class="nv">r8</span> <span class="nv">r9</span> <span class="nv">r10</span> <span class="nv">r11</span> <span class="nv">r12</span> <span class="nv">r13</span><span class="p">))</span>

<span class="p">(</span><span class="nb">defun</span> <span class="nv">t2STMDB_UPD</span> <span class="p">(</span><span class="nv">dst</span> <span class="nv">base</span> <span class="nv">_pred</span> <span class="nv">_?</span>
                      <span class="nv">r1</span> <span class="nv">r2</span> <span class="nv">r3</span> <span class="nv">r4</span> <span class="nv">r5</span> <span class="nv">r6</span> <span class="nv">r7</span> <span class="nv">r8</span> <span class="nv">r9</span> <span class="nv">r10</span> <span class="nv">r11</span> <span class="nv">r12</span><span class="p">)</span>
  <span class="p">(</span><span class="nv">stmdb_upd</span> <span class="nv">dst</span> <span class="nv">base</span> <span class="nv">r1</span> <span class="nv">r2</span> <span class="nv">r3</span> <span class="nv">r4</span> <span class="nv">r5</span> <span class="nv">r6</span> <span class="nv">r7</span> <span class="nv">r8</span> <span class="nv">r9</span> <span class="nv">r10</span> <span class="nv">r11</span> <span class="nv">r12</span><span class="p">))</span>

<span class="p">(</span><span class="nb">defun</span> <span class="nv">t2STMDB_UPD</span> <span class="p">(</span><span class="nv">dst</span> <span class="nv">base</span> <span class="nv">_pred</span> <span class="nv">_?</span>
                      <span class="nv">r1</span> <span class="nv">r2</span> <span class="nv">r3</span> <span class="nv">r4</span> <span class="nv">r5</span> <span class="nv">r6</span> <span class="nv">r7</span> <span class="nv">r8</span> <span class="nv">r9</span> <span class="nv">r10</span> <span class="nv">r11</span><span class="p">)</span>
  <span class="p">(</span><span class="nv">stmdb_upd</span> <span class="nv">dst</span> <span class="nv">base</span> <span class="nv">r1</span> <span class="nv">r2</span> <span class="nv">r3</span> <span class="nv">r4</span> <span class="nv">r5</span> <span class="nv">r6</span> <span class="nv">r7</span> <span class="nv">r8</span> <span class="nv">r9</span> <span class="nv">r10</span> <span class="nv">r11</span><span class="p">))</span>

<span class="p">(</span><span class="nb">defun</span> <span class="nv">t2STMDB_UPD</span> <span class="p">(</span><span class="nv">dst</span> <span class="nv">base</span> <span class="nv">_pred</span> <span class="nv">_?</span>
                      <span class="nv">r1</span> <span class="nv">r2</span> <span class="nv">r3</span> <span class="nv">r4</span> <span class="nv">r5</span> <span class="nv">r6</span> <span class="nv">r7</span> <span class="nv">r8</span> <span class="nv">r9</span> <span class="nv">r10</span><span class="p">)</span>
  <span class="p">(</span><span class="nv">stmdb_upd</span> <span class="nv">dst</span> <span class="nv">base</span> <span class="nv">r1</span> <span class="nv">r2</span> <span class="nv">r3</span> <span class="nv">r4</span> <span class="nv">r5</span> <span class="nv">r6</span> <span class="nv">r7</span> <span class="nv">r8</span> <span class="nv">r9</span> <span class="nv">r10</span><span class="p">))</span>

<span class="p">(</span><span class="nb">defun</span> <span class="nv">t2STMDB_UPD</span> <span class="p">(</span><span class="nv">dst</span> <span class="nv">base</span> <span class="nv">_pred</span> <span class="nv">_?</span>
                      <span class="nv">r1</span> <span class="nv">r2</span> <span class="nv">r3</span> <span class="nv">r4</span> <span class="nv">r5</span> <span class="nv">r6</span> <span class="nv">r7</span> <span class="nv">r8</span> <span class="nv">r9</span><span class="p">)</span>
  <span class="p">(</span><span class="nv">stmdb_upd</span> <span class="nv">dst</span> <span class="nv">base</span> <span class="nv">r1</span> <span class="nv">r2</span> <span class="nv">r3</span> <span class="nv">r4</span> <span class="nv">r5</span> <span class="nv">r6</span> <span class="nv">r7</span> <span class="nv">r8</span> <span class="nv">r9</span><span class="p">))</span>

<span class="p">(</span><span class="nb">defun</span> <span class="nv">t2STMDB_UPD</span> <span class="p">(</span><span class="nv">dst</span> <span class="nv">base</span> <span class="nv">_pred</span> <span class="nv">_?</span>
                      <span class="nv">r1</span> <span class="nv">r2</span> <span class="nv">r3</span> <span class="nv">r4</span> <span class="nv">r5</span> <span class="nv">r6</span> <span class="nv">r7</span> <span class="nv">r8</span><span class="p">)</span>
  <span class="p">(</span><span class="nv">stmdb_upd</span> <span class="nv">dst</span> <span class="nv">base</span> <span class="nv">r1</span> <span class="nv">r2</span> <span class="nv">r3</span> <span class="nv">r4</span> <span class="nv">r5</span> <span class="nv">r6</span> <span class="nv">r7</span> <span class="nv">r8</span><span class="p">))</span>

<span class="p">(</span><span class="nb">defun</span> <span class="nv">t2STMDB_UPD</span> <span class="p">(</span><span class="nv">dst</span> <span class="nv">base</span> <span class="nv">_pred</span> <span class="nv">_?</span>
                      <span class="nv">r1</span> <span class="nv">r2</span> <span class="nv">r3</span> <span class="nv">r4</span> <span class="nv">r5</span> <span class="nv">r6</span> <span class="nv">r7</span><span class="p">)</span>
  <span class="p">(</span><span class="nv">stmdb_upd</span> <span class="nv">dst</span> <span class="nv">base</span> <span class="nv">r1</span> <span class="nv">r2</span> <span class="nv">r3</span> <span class="nv">r4</span> <span class="nv">r5</span> <span class="nv">r6</span> <span class="nv">r7</span><span class="p">))</span>

<span class="p">(</span><span class="nb">defun</span> <span class="nv">t2STMDB_UPD</span> <span class="p">(</span><span class="nv">dst</span> <span class="nv">base</span> <span class="nv">_pred</span> <span class="nv">_?</span>
                      <span class="nv">r1</span> <span class="nv">r2</span> <span class="nv">r3</span> <span class="nv">r4</span> <span class="nv">r5</span> <span class="nv">r6</span><span class="p">)</span>
  <span class="p">(</span><span class="nv">stmdb_upd</span> <span class="nv">dst</span> <span class="nv">base</span> <span class="nv">r1</span> <span class="nv">r2</span> <span class="nv">r3</span> <span class="nv">r4</span> <span class="nv">r5</span> <span class="nv">r6</span><span class="p">))</span>

<span class="p">(</span><span class="nb">defun</span> <span class="nv">t2STMDB_UPD</span> <span class="p">(</span><span class="nv">dst</span> <span class="nv">base</span> <span class="nv">_pred</span> <span class="nv">_?</span>
                      <span class="nv">r1</span> <span class="nv">r2</span> <span class="nv">r3</span> <span class="nv">r4</span> <span class="nv">r5</span><span class="p">)</span>
  <span class="p">(</span><span class="nv">stmdb_upd</span> <span class="nv">dst</span> <span class="nv">base</span> <span class="nv">r1</span> <span class="nv">r2</span> <span class="nv">r3</span> <span class="nv">r4</span> <span class="nv">r5</span><span class="p">))</span>

<span class="p">(</span><span class="nb">defun</span> <span class="nv">t2STMDB_UPD</span> <span class="p">(</span><span class="nv">dst</span> <span class="nv">base</span> <span class="nv">_pred</span> <span class="nv">_?</span>
                      <span class="nv">r1</span> <span class="nv">r2</span> <span class="nv">r3</span> <span class="nv">r4</span><span class="p">)</span>
  <span class="p">(</span><span class="nv">stmdb_upd</span> <span class="nv">dst</span> <span class="nv">base</span> <span class="nv">r1</span> <span class="nv">r2</span> <span class="nv">r3</span> <span class="nv">r4</span><span class="p">))</span>

<span class="p">(</span><span class="nb">defun</span> <span class="nv">t2STMDB_UPD</span> <span class="p">(</span><span class="nv">dst</span> <span class="nv">base</span> <span class="nv">_pred</span> <span class="nv">_?</span>
                      <span class="nv">r1</span> <span class="nv">r2</span> <span class="nv">r3</span><span class="p">)</span>
  <span class="p">(</span><span class="nv">stmdb_upd</span> <span class="nv">dst</span> <span class="nv">base</span> <span class="nv">r1</span> <span class="nv">r2</span> <span class="nv">r3</span><span class="p">))</span>

<span class="p">(</span><span class="nb">defun</span> <span class="nv">t2STMDB_UPD</span> <span class="p">(</span><span class="nv">dst</span> <span class="nv">base</span> <span class="nv">_pred</span> <span class="nv">_?</span>
                      <span class="nv">r1</span> <span class="nv">r2</span><span class="p">)</span>
  <span class="p">(</span><span class="nv">stmdb_upd</span> <span class="nv">dst</span> <span class="nv">base</span> <span class="nv">r1</span> <span class="nv">r2</span><span class="p">))</span>

<span class="p">(</span><span class="nb">defun</span> <span class="nv">t2STMDB_UPD</span> <span class="p">(</span><span class="nv">dst</span> <span class="nv">base</span> <span class="nv">_pred</span> <span class="nv">_?</span>
                      <span class="nv">r1</span><span class="p">)</span>
  <span class="p">(</span><span class="nv">stmdb_upd</span> <span class="nv">dst</span> <span class="nv">base</span> <span class="nv">r1</span><span class="p">))</span>

<span class="p">(</span><span class="nb">defmacro</span> <span class="nv">stmdb_upd</span> <span class="p">(</span><span class="nv">dst</span> <span class="nv">base</span> <span class="nv">regs</span><span class="p">)</span>
  <span class="p">(</span><span class="k">let</span> <span class="p">((</span><span class="nv">len</span> <span class="p">(</span><span class="nb">length</span> <span class="nv">regs</span><span class="p">))</span>
        <span class="p">(</span><span class="nv">stride</span> <span class="p">(</span><span class="nv">sizeof</span> <span class="nv">word-width</span><span class="p">))</span>
        <span class="p">(</span><span class="nv">ptr</span> <span class="p">(</span><span class="nb">-</span> <span class="nv">base</span> <span class="p">(</span><span class="nb">*</span> <span class="nv">len</span> <span class="nv">stride</span><span class="p">))))</span>
    <span class="p">(</span><span class="nv">store-registers</span> <span class="nv">ptr</span> <span class="nv">stride</span> <span class="mi">0</span> <span class="nv">regs</span><span class="p">)</span>
    <span class="p">(</span><span class="nv">set$</span> <span class="nv">dst</span> <span class="nv">ptr</span><span class="p">)))</span>

<span class="p">(</span><span class="nb">defmacro</span> <span class="nv">store-registers</span> <span class="p">(</span><span class="nv">base</span> <span class="nv">stride</span> <span class="nv">off</span> <span class="nv">reg</span><span class="p">)</span>
  <span class="p">(</span><span class="nv">store-word</span> <span class="p">(</span><span class="nb">+</span> <span class="nv">base</span> <span class="p">(</span><span class="nb">*</span> <span class="nv">stride</span> <span class="nv">off</span><span class="p">))</span> <span class="nv">reg</span><span class="p">))</span>

<span class="p">(</span><span class="nb">defmacro</span> <span class="nv">store-registers</span> <span class="p">(</span><span class="nv">base</span> <span class="nv">stride</span> <span class="nv">off</span> <span class="nv">reg</span> <span class="nv">regs</span><span class="p">)</span>
  <span class="p">(</span><span class="nb">prog</span>
     <span class="p">(</span><span class="nv">store-registers</span> <span class="nv">base</span> <span class="nv">stride</span> <span class="nv">off</span> <span class="nv">reg</span><span class="p">)</span>
     <span class="p">(</span><span class="nv">store-registers</span> <span class="nv">base</span> <span class="nv">stride</span> <span class="p">(</span><span class="nb">+</span> <span class="nv">off</span> <span class="mi">1</span><span class="p">)</span> <span class="nv">regs</span><span class="p">)))</span>

<span class="p">(</span><span class="nb">defmacro</span> <span class="nb">length</span> <span class="p">(</span><span class="nv">r</span><span class="p">)</span> <span class="mi">1</span><span class="p">)</span>
<span class="p">(</span><span class="nb">defmacro</span> <span class="nb">length</span> <span class="p">(</span><span class="nv">_</span> <span class="nv">rs</span><span class="p">)</span> <span class="p">(</span><span class="nb">+</span> <span class="mi">1</span> <span class="p">(</span><span class="nb">length</span> <span class="nv">rs</span><span class="p">)))</span>
</code></pre></div></div>

<p>I think on this we can conclude our tutorial. I will later polish it, but it covers most of the features of Primus Lisp and writing lifters.</p>

<p>Except for the last step - which is making a PR to BAP with the file. Please, once you wrote a semantics for a machine instruction do not hesitate and PR it to the main repository. It should go to plugins/<target>/semantics/<your-file>, or you can just add the lisp code to an existing lisp file in this folder if you think it would be easier to maintain. This will be highly appreciated.</your-file></target></p>

<p>Happy lifting!</p>

<h2>The Bonus Track - Recitation</h2>

<p>And as the final accord and recitation, let&rsquo;s check how we can lift <code class="language-plaintext highlighter-rouge">push {r1-r12,r14}</code>.</p>

<p>1) We will use <code class="language-plaintext highlighter-rouge">llvm-mc</code> to obtain the binary encoding,</p>
<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>$ echo 'push {r1-r12,r14}' | llvm-mc -triple=thumb -mattr=thumb2 -show-encoding
    .text
    push.w    {r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, lr} @ encoding: [0x2d,0xe9,0xfe,0x5f]
</code></pre></div></div>
<p>2) next we check that our overload is correctly picked up,</p>
<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>$ bap mc --arch=thumb --primus-lisp-semantics=. --show-bil -- 0x2d,0xe9,0xfe,0x5f
{
  #3 := SP - 0x34
  mem := mem with [#3, el]:u32 &lt;- R1
  mem := mem with [#3 + 4, el]:u32 &lt;- R2
  mem := mem with [#3 + 8, el]:u32 &lt;- R3
  mem := mem with [#3 + 0xC, el]:u32 &lt;- R4
  mem := mem with [#3 + 0x10, el]:u32 &lt;- R5
  mem := mem with [#3 + 0x14, el]:u32 &lt;- R6
  mem := mem with [#3 + 0x18, el]:u32 &lt;- R7
  mem := mem with [#3 + 0x1C, el]:u32 &lt;- R8
  mem := mem with [#3 + 0x20, el]:u32 &lt;- R9
  mem := mem with [#3 + 0x24, el]:u32 &lt;- R10
  mem := mem with [#3 + 0x28, el]:u32 &lt;- R11
  mem := mem with [#3 + 0x2C, el]:u32 &lt;- R12
  mem := mem with [#3 + 0x30, el]:u32 &lt;- LR
  SP := #3
}
</code></pre></div></div>
<p>So, yay, it works! :)</p>


