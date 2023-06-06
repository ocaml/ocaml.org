---
title: 'LLVM Backend for DDC : Very Nearly Done.'
description:
url: http://www.mega-nerd.com/erikd/Blog/CodeHacking/DDC/llvm_very_nearly_done.html
date: 2011-01-01T02:54:00-00:00
preview_image:
featured:
authors:
- mega-nerd
---



<p>
The LLVM backend for
	<a href="http://disciple.ouroborus.net/">
	DDC</a>
that I've been working on sporadically
	<a href="http://www.mega-nerd.com/erikd/Blog/CodeHacking/DDC/llvm_backend.html">
	since June</a>
is basically done.
When compiling via the LLVM backend, all but three of 100+ tests in the DDC
test suite pass.
The tests that pass when going via the C backend but fail via the LLVM backend
are of two kinds:
</p>

<ol>
	<li>Use DDC's <tt><b>foreign import</b></tt> construct to name a C macro
		 to perform a type cast where the macro is defined in one of C header
		 files.
		</li>
	<li>Use static inline functions in the C backend to do peek and poke
		operations on arrays of unboxed values.
		</li>
</ol>

<p>
In both of these cases, DDC is using features of the C language to make code
generation easier.
Obviously, the LLVM backend needs to do something else to get the same effect.
</p>

<p>
Fixing the type casting problem should be relatively simple.
<a href="http://www.cse.unsw.edu.au/~benl/">
	Ben</a>
is currently working on making type casts a primitive of the Core language
so that both the C and LLVM backends can easily generate code for them.
</p>

<p>
The array peek and poke problem is little more complex.
I suspect that it too will require the addition of new Core language primitive
operations.
This is a much more complex problem than the type casting one and I've only just
begun to start thinking about it.
</p>

<p>
Now that the backend is nearly done, its not unreasonable to look at its
performance.
The following table shows the compile and run times of a couple of tests in the
DDC test suite compiling via the C and the LLVM backend.
</p>

<br/>

<center>
<table class="simple">
	<tr>
		<th>Test name</th>
			<th>C Build Time</th>
			<th>LLVM Build Time</th>
			<th>C Run Time</th>
			<th>LLVM Run Time</th>
	</tr>
	<tr>
		<th align="left">93-Graphics/Circle</th>
			<td align="right">3.124s</td>
			<td align="right">3.260s</td>
			<td align="right">1.701s</td>
			<td align="right">1.536s</td>
	</tr>
	<tr>
		<th align="left">93-Graphics/N-Body/Boxed</th>
			<td align="right">6.126s</td>
			<td align="right">6.526s</td>
			<td align="right">7.649s</td>
			<td align="right">4.899s</td>
	</tr>
	<tr>
		<th align="left">93-Graphics/N-Body/UnBoxed</th>
			<td align="right">3.559s</td>
			<td align="right">4.017s</td>
			<td align="right">9.843s</td>
			<td align="right">6.162s</td>
	</tr>
	<tr>
		<th align="left">93-Graphics/RayTracer</th>
			<td align="right">12.890s</td>
			<td align="right">13.102s</td>
			<td align="right">13.465s</td>
			<td align="right">8.973s</td>
	</tr>
	<tr>
 		<th align="left">93-Graphics/SquareSpin</th>
			<td align="right">2.699s</td>
			<td align="right">2.889s</td>
			<td align="right">1.609s</td>
			<td align="right">1.604s</td>
	</tr>
	<tr>
		<th align="left">93-Graphics/Styrene</th>
			<td align="right">13.685s</td>
			<td align="right">14.349s</td>
			<td align="right">11.312s</td>
			<td align="right">8.527s</td>
	</tr>

</table>
</center>

<br/>

<p>
Although there is a small increase in compile times when compiling via LLVM, the
LLVM run times are significantly reduced.
The conceptual complexity of the LLVM backend is also low (the line count is
about 4500 lines, which will probably fall with re-factoring) and thanks to
LLVM's type checking being significantly better than C's, I think its reasonable
to be more confident in the quality of the LLVM backend than the existing C
backend.
Finally, implementing things like proper tail call optimisation will be far
easier in LLVM backend than in C.
</p>

<p>
All in all, I think doing this LLVM backend has been an interesting challenge
and will definitely pay off in the long run.
</p>


