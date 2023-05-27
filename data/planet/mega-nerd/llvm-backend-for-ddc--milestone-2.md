---
title: 'LLVM Backend for DDC : Milestone #2.'
description:
url: http://www.mega-nerd.com/erikd/Blog/CodeHacking/DDC/llvm_milestone2.html
date: 2010-08-22T03:43:00-00:00
preview_image:
featured:
authors:
- mega-nerd
---



<p>
For a couple of weeks after AusHac 2010 I didn't manage to find any time to
working on DDC at all, but I'm now back on it and late last week I  reached the
second milestone on the
	<a href="http://www.mega-nerd.com/erikd/Blog/CodeHacking/DDC/llvm_backend.html">
	LLVM backend for DDC</a>.
The backend now has the ability to box and unbox 32 bit integers and perform
simple arithmetic operations on valid combinations of them.
</p>

<p>
Disciple code that can currently be compiled correctly via LLVM includes basic
stuff like:
</p>

<pre class="code">

  identInt :: Int -&gt; Int
  identInt a = a

  plusOneInt :: Int -&gt; Int
  plusOneInt x = x + 1

  addInt :: Int -&gt; Int -&gt; Int
  addInt a b = a + b

  addInt32U :: Int32# -&gt; Int32# -&gt; Int32#
  addInt32U a b = a + b

  addMixedInt :: Int32# -&gt; Int -&gt; Int
  addMixedInt a b = boxInt32 (a + unboxInt32 b)

  cafOneInt :: Int
  cafOneInt = 1

  plusOne :: Int -&gt; Int
  plusOne x = x + cafOneInt

</pre>

<p>
where <b><tt>Int32#</tt></b> specifies an unboxed 32 bit integer and
<b><tt>Int32</tt></b> specifies the boxed version.
</p>

<p>
While writing the Haskell code for DDC, I'm finding that its easiest to generate
LLVM code for a specific narrow case first and then generalize it as more cases
come to light.
I also found that the way I had been doing the LLVM code generation was tedious
and ugly, invloving lots of concatenation of small lists.
To fix this I built myself an <b><tt>LlvmM</tt></b> monad on top of the
<b><tt>StateT</tt></b> monad:
</p>

<pre class="code">

  type LlvmM = StateT [[LlvmStatement]] IO

</pre>

<p>
Using this I can then generate a block of LLVM code as a list of
<b><tt>LlvmStatement</tt></b>s and add it to the monad using an
<b><tt>addBlock</tt></b> function which basically pushes the blocks of code
down onto a stack:
</p>

<pre class="code">

  addBlock :: [LlvmStatement] -&gt; LlvmM ()
  addBlock code
   = do	  state	&lt;- get
          put (code : state)

</pre>

<p>
The <b><tt>addBlock</tt></b> function is then used as the base building block
for a bunch of more specific functions like these:
</p>

<pre class="code">

  unboxInt32 :: LlvmVar -&gt; LlvmM LlvmVar
  unboxInt32 objptr
   | getVarType objptr == pObj
   = do     int32    &lt;- lift $ newUniqueReg i32
            iptr0    &lt;- lift $ newUniqueNamedReg &quot;iptr0&quot; (pLift i32)
            iptr1    &lt;- lift $ newUniqueNamedReg &quot;iptr1&quot; (pLift i32)
            addBlock
                    [ Comment [ show int32 ++ &quot; = unboxInt32 (&quot; ++ show objptr ++ &quot;)&quot; ]
                    , Assignment iptr0 (GetElemPtr True objptr [llvmWordLitVar 0, i32LitVar 0])
                    , Assignment iptr1 (GetElemPtr True iptr0 [llvmWordLitVar 1])
                    , Assignment int32 (Load iptr1) ]
            return  int32


  readSlot :: Int -&gt; LlvmM LlvmVar
  readSlot 0
   = do   dstreg    &lt;- lift $ newUniqueNamedReg &quot;slot.0&quot; pObj
          addBlock  [ Comment [ show dstreg ++ &quot; = readSlot 0&quot; ]
                    , Assignment dstreg (Load localSlotBase) ]
          return    dstreg

  readSlot n
   | n &gt; 0
   = do   dstreg    &lt;- lift $ newUniqueNamedReg (&quot;slot.&quot; ++ show n) pObj
          r0        &lt;- lift $ newUniqueReg pObj
          addBlock  [ Comment [ show dstreg ++ &quot; = readSlot &quot; ++ show n ]
                    , Assignment r0 (GetElemPtr True localSlotBase [llvmWordLitVar n])
                    , Assignment dstreg (Load (pVarLift r0)) ]
          return    dstreg

  readSlot n = panic stage $ &quot;readSlot with slot == &quot; ++ show n

</pre>

<p>
which are finally hooked up to do things like:
</p>

<pre class="code">

  llvmVarOfExp (XUnbox ty@TCon{} (XSlot v _ i))
   = do   objptr    &lt;- readSlot i
          unboxAny (toLlvmType ty) objptr

  llvmVarOfExp (XUnbox ty@TCon{} (XForce (XSlot _ _ i)))
   = do   orig      &lt;- readSlot i
          forced    &lt;- forceObj orig
          unboxAny (toLlvmType ty) forced

</pre>

<p>
When the code generation of a single function is complete it the list of
<b><tt>LlvmStatement</tt></b> blocks is then retrieved, reversed and
concatenated to produce the list of <b><tt>LlvmStatement</tt></b>s for the
function.
</p>

<p>
With the <b><tt>LlvmM</tt></b> monad in place converting DDC's Sea AST into LLVM
code is now pretty straight forward.
Its just a matter of finding and implementing all the missing pieces.
</p>



