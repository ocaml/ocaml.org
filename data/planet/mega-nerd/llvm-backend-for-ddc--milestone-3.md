---
title: 'LLVM Backend for DDC : Milestone #3.'
description:
url: http://www.mega-nerd.com/erikd/Blog/CodeHacking/DDC/llvm_milestone3.html
date: 2010-12-01T09:41:00-00:00
preview_image:
featured:
authors:
- mega-nerd
---



<p>
After my
	<a href="http://www.mega-nerd.com/erikd/Blog/CodeHacking/DDC/llvm_backend2.html">
	last post</a>
on this topic, I ran into some problems with the AST (abstract syntax tree) that
was being passed to my code for LLVM code generation.
After discussing the problem with Ben, he spent some time cleaning up the AST
definition, the result of which was that nearly all the stuff I already had,
stopped working.
This was a little disheartening.
That and the fact that I was really busy, meant that I didn't touch the LLVM
backend for a number of weeks.
</p>

<p>
When I finally did get back to it, I found that it wasn't as broken as I had
initially thought.
Although the immediate interface between Ben's code and mine had changed
significantly, all the helper functions I had written were still usable.
Over a week and a bit, I managed to patch everything up again and get back to
where I was.
I also did a lot of cleaning up and came up with a neat solution to a problem
which was bugging me during my previous efforts.
</p>

<p>
The problem was that structs defined via the LLVM backend needed to have exactly
the same memory layout as the structs defined via the C backend.
This is a strict requirement for proper interaction between code generated via
C and LLVM.
This was made a little difficult by David Terei's haskell LLVM wrapper code
	<a href="http://www.mega-nerd.com/erikd/Blog/CodeHacking/DDC/llvm_backend.html">
	(see previous post)</a>
which makes all structs packed by default, while structs on the C side were
not packed.
Another dimension of this problem was finding an easy way to generate LLVM code
to access structs in a way that was easy to read and debug in the code generator
and also not require different code paths for generating 32 and 64 bit code.
</p>

<p>
Struct layout is tricky.
Consider a really simple struct like this:
</p>

<pre class="code">

  struct whatever
  {   int32_t tag ;
      char * pointer ;
  } ;

</pre>

<p>
On a 32 bit system, that struct will take up 8 bytes; 4 bytes for the
<tt><b>int32_t</b></tt> and 4 for the pointer.
However, on a 64 bit system, where pointers are 8 bytes in size, the struct
will take up 16 bytes.
Why not 12 bytes?
Well, some 64 bit CPUs (Alpha and Sparc64 are two I can think of) are not
capable of unaligned memory accesses; a read from memory into a CPU register
where the memory address (in bytes) is not an integer multiple of the size of
the register.
Other CPUs like x86_64 can read unaligned data, but reading unaligned data is
usually slower than reading correctly aligned data.
</p>

<p>
In order to avoid unaligned, the compiler assumes that the start address of the
struct will be aligned to the correct alignment for the biggest CPU register
element in the struct, in this case the pointer.
It then adds 4 bytes of padding between the <tt><b>int32_t</b></tt> and the
pointer to ensure that if the struct is correctly aligned then the pointer will
also be correctly aligned.
</p>

<p>
Because structs are packed in the David Terei's code, the above struct would
require a different definition on 32 and 64 bit systems, ie
</p>

<pre class="code">

  ; 32 bit version of the struct
  %struct.whatever.32 = type &lt;{ i32, i8 * }&gt;

  ; 64 bit version of the struct
  %struct.whatever.64 = type &lt;{ i32, [4 * i8], i8 * }&gt;

</pre>

<p>
where the 64 bit version contains 4 padding bytes.
However, the difference between these two definitions causes another problem.
To access fields within a struct, LLVM code uses the
	<a href="http://llvm.org/docs/LangRef.html#i_getelementptr">
	<tt><b>getelementptr</b></tt></a>
operator which addresses fields by index.
Unfortunately, the index (zero based) of the pointer is 1 for the 32 bit version
and 2 for the 64 bit version.
That would make code generation a bit of a pain in the neck.
</p>

<p>
The solution is allow the specification of LLVM structs in Haskell as a list of
<tt><b>LlvmStructField</b></tt> elements, using
</p>

<pre class="code">

  data LlvmStructField
        = AField String LlvmType    -- Field name and type.
        | APadTo2                   -- Pad next field to a 2 byte offset.
        | APadTo4                   -- Pad next field to a 4 byte offset.
        | APadTo8                   -- Pad next field to a 8 byte offset.

        | APadTo8If64               -- Pad next field to a 8 byte offset only
                                    -- for 64 bit.

</pre>

<p>
Note that the <tt><b>AField</b></tt> constructor requires both a name and the
<tt><b>LlvmType</b></tt>.
I then provide functions to convert the <tt><b>LlvmStructField</b></tt> list
into an opaque <tt><b>LlvmStructDesc</b></tt> type and provide the following
functions:
</p>

<pre class="code">

  -- | Turn an struct specified as an LlvmStructField list into an
  -- LlvmStructDesc and give it a name. The LlvmStructDesc may
  -- contain padding to make it conform to the definition.
  mkLlvmStructDesc :: String -&gt; [LlvmStructField] -&gt; LlvmStructDesc

  -- | Retrieve the struct's LlvmType from the LlvmStructDesc.
  llvmTypeOfStruct :: LlvmStructDesc -&gt; LlvmType

  -- | Given and LlvmStructDesc and the name of a field within the
  -- LlvmStructDesc, retrieve a field's index with the struct and its
  -- LlvmType.
  structFieldLookup :: LlvmStructDesc -&gt; String -&gt; (Int, LlvmType)

</pre>

<p>
Once the <tt><b>LlvmStructDesc</b></tt> is built for a given struct, fields
within the struct can be addressed in the LLVM code generator by name, making
the Haskell code generator code far easier to read.
</p>

<p>
Pretty soon after I got the above working I also managed to get enough LLVM
code generation working to compile a complete small program which then runs
correctly.
I consider that to be milestone 3.
</p>



