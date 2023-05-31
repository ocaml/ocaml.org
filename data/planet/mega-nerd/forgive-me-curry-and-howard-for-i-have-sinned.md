---
title: Forgive me Curry and Howard for I have Sinned.
description:
url: http://www.mega-nerd.com/erikd/Blog/CodeHacking/forgive_me.html
date: 2015-11-16T11:22:00-00:00
preview_image:
featured:
authors:
- mega-nerd
---



<p>
Forgive me Curry and Howard for I have sinned.
</p>

<p>
For the last several weeks, I have been writing C++ code.
I've been doing some experimentation in the area of real-time audio Digital
Signal Processing experiments, C++ actually is better than Haskell.
</p>

<p>
Haskell is simply not a good fit here because I need:
</p>

<ul>
<li> To be able to guarantee (by inspection) that there is zero memory
	allocation/de-allocation in the real-time inner processing loop. </li>
<li> Things like IIR filters are inherently stateful, with their internal state
	being updated on every input sample.</li>
</ul>

<p>
There is however one good thing about coding C++; I am constantly reminded of
all the sage advice about C++ I got from my friend Peter Miller who passed
away a bit over a year ago.
</p>

<p>
Here is an example of the code I'm writing:
</p>

<pre class="code">

  class iir2_base
  {
      public :
          // An abstract base class for 2nd order IIR filters.
          iir2_base () ;

          // Virtual destructor does nothing.
          virtual ~iir2_base () { }

          inline double process (double in)
          {
              unsigned minus2 = (minus1 + 1) &amp; 1 ;
              double out = b0 * in + b1 * x [minus1] + b2 * x [minus2]
                              - a1 * y [minus1] - a2 * y [minus2] ;
              minus1 = minus2 ;
              x [minus1] = in ;
              y [minus1] = out ;
              return out ;
          }

      protected :
          // iir2_base internal state (all statically allocated).
          double b0, b1, b2 ;
          double a1, a2 ;
          double x [2], y [2] ;
          unsigned minus1 ;

      private :
          // Disable copy constructor etc.
          iir2_base (const iir2_base &amp;) ;
          iir2_base &amp; operator = (const iir2_base &amp;) ;
  } ;

</pre>


