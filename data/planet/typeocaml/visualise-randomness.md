---
title: Visualise Randomness
description: Visualising the randomness is a simple fun way to test randomness and
  see how a random generator behaves. The post demonstrate how to do it in OCaml with
  the library camlimages...
url: http://typeocaml.com/2015/11/22/visualise_random/
date: 2015-11-22T13:14:20-00:00
preview_image:
featured:
authors:
- typeocaml
---

<p><img src="http://typeocaml.com/content/images/2015/11/visual_random-1.jpg#hero" alt="heor"/></p>

<p>It has been almost half year since my last blog post on OCaml. Well, actually I haven't even touched OCaml for that long time. My current job (in Python) got much busier. But finally, things <s>camls</s> calms down a bit now. I can at least have time sitting in front of my 2008 macbook pro, opening terminal, doing </p>

<pre><code>opam update

opam upgrade

opam switch 4.02.3

eval `opam config env`
</code></pre>

<p>Hmmmm, I like this feeling. </p>

<p><strong>typeocaml</strong> is back now. I digged my typeocaml notebook from one of our 78 packing boxes, and went through the list of <em>many things about OCaml</em> that I planned to write about. Those items still look familiar but obviously not very clear in my mind now. One should never put a vacuum space in things beloved. They would fade.</p>

<p>Anyway, enough chit-chat, back to the topic.</p>

<hr/>

<p>This post is about visualising the randomness of random number generators. It will be lightweight and is just something I did for fun with OCaml. We will know a good way to test randomness and also learn how to create a <em>jpg</em> picture using an OCaml image library: <strong>camlimages</strong>. I hope it would be tiny cool.</p>

<h1>What is randomness?</h1>

<p>Say, we got a function <code>var ran_gen : int -&gt; int</code> from nowhere. It claims to be a good random integer generator with uniform distribution, which takes a bound and &quot;perfectly&quot; generates a random integer within [0, bound). The usage is simple but the question is <em>can you trust it</em> or <em>will the numbers it generates be really random</em>?</p>

<p>For example, here is a rather simple <code>ran_gen_via_time</code>:</p>

<pre><code class="ocaml">let decimal_only f = f -. (floor f)  
let ran_via_time bound =  
  ((Unix.gettimeofday() |&gt; decimal_only) *. 100,000,000. |&gt; int_of_float) mod bound
(*
  Unix.gettimeofday() returns float like 1447920488.92716193 in second. 
  We get the decimal part and then amplify it to be integer like, i.e., 1447920488.92716193 ==&gt; 0.92716193 ==&gt; 92716193.
  Then we mod it by bound to get the final &quot;random&quot; number.
*)
</code></pre>

<p>This generator is based on the <em>timestamp</em> when it is called and then mod by the <em>bound</em>. Will it be a good generator? My gut tells me <em>not really</em>. If the calls to the function has some patterns, then eaily the numbers become constant. </p>

<p>For example, if the <em>bound</em> is 10, then at <em>t</em> I make first call, I will get <code>t mod 10</code>. If I call at <em>t + 10</em> again, I will get <code>(t+10) mod 10</code> which is actually <code>t mod 10</code>. If I call it every 10 seconds, then I get a constant. Thus this generator's randomness would not be as good as it claims to be.</p>

<p>For any given random number generator, we have to really make sure its randomness is good enough to suite our goal, especially when we have to rely on them for trading strategies, gaming applications, online gambling hosting, etc. </p>

<p>However, we also need to be aware of that most of random generators are not perfect (<em><a href="https://en.wikipedia.org/wiki/Random_number_generation">Random number generator</a></em> and <em><a href="https://en.wikipedia.org/wiki/Pseudorandom_number_generator">Pseudorandom number generator</a></em>). What we often do is just to see whether the randomness of a given generator can reach a certain level or not.</p>

<h1>Test randomness using statistics</h1>

<p><a href="https://en.wikipedia.org/wiki/Chi-squared_test">Chi-squared test</a> is a fairly simple and common methodology to test randomness mathematically.</p>

<p>Say, we have a generator producing random integers between [0, 10) with uniform distribution. So ideally, if the generator is perfect, and if we ran 1000 times, then there would be 100 of <em>0</em>, 100 of <em>1</em>, ..., 100 of <em>9</em> , right? For the test, we can just try the generator <em>N</em> times, and see whether the frequency of each number generated somehow matches or is close to <em>N / bound</em>.</p>

<p>Of course, the frquencies of numbers would not exactly match expectation. So we need some mathematics to measure the level of matching.</p>

<ol>
<li><em>k</em> is the number of possible candidates - e.g., <em>k = 10</em> for [0, 10)  </li>
<li><em>Ei</em> is the expected frequency for each candidate - <em>i = 1, 2, k</em>  </li>
<li><em>Oi</em> is the frequency for each candidate produced by the generator - <em>i = 1, 2, k</em></li>
</ol>

<p>Thus we can get <code>X^2 = (O1-E1)^2/E1 + ... + (Ok-Ek)^2/Ek</code></p>

<p>Essentially, the bigger <code>X^2</code> is, the matching is more unlikely. If we really want to see how unlikely or likely they match each other, then we need to check <code>X^2</code> against the <em>chi square distribution table</em> like below:</p>

<p><img src="https://faculty.elgin.edu/dkernler/statistics/ch09/images/chi-square-table.gif" alt="chi square distribution table"/></p>

<ol>
<li>The <em>Degrees of Freedom</em> is our <code>k-1</code> (if <em>k = 1</em>, then our freedom is <em>0</em>, which means we just have one to choose all the time and don't have any freedom).  </li>
<li>The bold headings of columns are the probabilities that the observations match the expectations.  </li>
<li>The many numbers in those cells are values of <code>X^2</code>.</li>
</ol>

<p>For example, say in our case above, <code>k = 10</code>, so <em>Degree of freedom is 9</em>. </p>

<p>If we get <code>X^2</code> as <em>2</em>, which is less than <em>2.088</em>, then we can say we have more than <em>0.99</em> probability that the observations match the expectations, i.e., our random generator follows uniform distribution very well. </p>

<p>If we get <code>X^2</code> as <em>23</em>, which is bigger than <em>21.666</em>, the probability of matching is less than <em>0.01</em>, so our generator at least is not following uniform distribution.</p>

<p>This is roughly how we could use Chi-squared test for randomness checking. Of course, the description above is amateur and I am just trying to put it in a way for easier understanding. </p>

<h1>Test randomness via visualisation</h1>

<p>Let's admit one thing first: Math can be boring. Although math can describe things most precisely, it does not make people like me feel intuitive, or say, straightforward. If I can directly see problems and the solutions via my eyes, I would be much happier and this was the reason why I tried to visualise the randomness of generators.</p>

<p>The way of the visualisation is fairly simple.</p>

<ol>
<li>We create a canvas.  </li>
<li>Each pixel on the canvas is a candidate random number that the generator can produce.  </li>
<li>We run the generator for lots of times.  </li>
<li>The more times a pixel gets hit, we draw a deeper color on it.  </li>
<li>In the end, we can directly feel the randomness depending on the color distribution on the canvas.</li>
</ol>

<h2>A trivial example</h2>

<p>Initially we have such a canvas.</p>

<p><img src="http://typeocaml.com/content/images/2015/11/randomness_canvas.jpg" alt="canvas"/></p>

<p>We use the random generator generating numbers. If a slot get a hit, we put a color on it.</p>

<p><img src="http://typeocaml.com/content/images/2015/11/randomness_1.jpg" alt="random_1"/></p>

<p>If any slot keeps been hit, we put deeper and deeper color on it.</p>

<p><img src="http://typeocaml.com/content/images/2015/11/randomness_2.jpg" alt="random_2"/></p>

<p>When the generator finishes, we can get a final image.</p>

<p><img src="http://typeocaml.com/content/images/2015/11/randomness_3.jpg" alt="random_3"/></p>

<p>From the resulting image, we can see that several numbers are really much deeper than others, and we can directly get a feeling about the generator. </p>

<p>Of course, this is just trivial. Normally, we can get much bigger picture and see the landscape of the randomness, instead of just some spots. Let's get our hands dirty then.</p>

<h2>Preparation</h2>

<p>Assuming the essentials of OCaml, such as <em>ocaml</em> itself, <em>opam</em> and <em>ocamlbuild</em>, have been installed, the only 3rd party library we need to get now is <a href="https://bitbucket.org/camlspotter/camlimages">camlimagges</a>. </p>

<p>Before invoke <code>opam install camlimages</code>, we need to make sure <a href="http://stackoverflow.com/questions/24805385/camlimages-fatal-error-exception-failureunsupported"><em>libjpeg</em> being installed first in your system</a>. Basically, <em>camlimages</em> relies on system libs of <em>libjpeg</em>, <em>libpng</em>, etc to save image files in respective formats. In this post, we will save our images to <code>.jpg</code>, so depending on the operating system, we can just directly try installing it by the keyword of <em>libjpeg</em>.</p>

<p>For example, </p>

<ul>
<li><em>mac</em> -&gt; <code>brew install libjpeg</code>; </li>
<li><em>ubuntu</em> -&gt; <code>apt-get install libjpeg</code>; </li>
<li><em>redhat</em> -&gt; <code>yum install libjpeg</code></li>
</ul>

<p>After <em>libjpeg</em> is installed, we can then invoke <code>opam install camlimages</code>.</p>

<p>In addition, for easier compiling or testing purposes, maybe <a href="https://ocaml.org/learn/tutorials/ocamlbuild/">ocamlbuild</a> <code>opam install ocamlbuild</code> and <a href="https://opam.ocaml.org/blog/about-utop/">utop</a> <code>opam install utop</code> could be installed, but it is up to you.</p>

<pre><code>brew install libjpeg  
opam install camlimages  
opam install ocamlbuild  
opam install utop  
</code></pre>

<h2>The general process</h2>

<p>The presentation of an <em>RGB</em> image in memory is a bitmap, which is fairly simple: just an 2-d array (<em>width</em> x <em>height</em>) with each slot holding a color value, in a form like <em>(red, green, blue)</em>. Once we have such a bitmap, we can just save it to the disk in various formats (different commpression techniques).</p>

<p>So the process could be like this:</p>

<ol>
<li>Create a matrix array, with certain size (<em>width</em> and <em>height</em>)  </li>
<li>Manipulate the values (colors) of all slots via random generated numbers  </li>
<li>Convert the matrix bitmap to a real image  </li>
<li>Save the image to a <em>jpg</em> file</li>
</ol>

<h2>Fill the matrix</h2>

<p>First, let's create a matrix.</p>

<pre><code class="ocaml">open Camlimages

(* w is the width and h is the height *)
let bitmap = Array.make_matrix w h {Color.r = 255; g = 255; b = 255}  
(* 
  Color is a type in camlimages for presenting RGB colors,
  and initially white here.
*)
</code></pre>

<p>When we generate a random number, we need to map it to a slot. Our image is a rectangle, i.e., having rows and columns. Our random numbers are within a bound <em>[0, b)</em>, i.e., 1-d dimension. A usual way to convert from 1-d to 2-d is just divide the number by the width to get the row and modulo the number by the width to get the col.</p>

<pre><code class="ocaml">let to_row_col ~w ~v = v / w, v mod w  
</code></pre>

<p>After we get a random number, we now need to fill its belonging slot darker. Initially, each slot can be pure white, i.e., <code>{Color.r = 255; g = 255; b = 255}</code>. In order to make it darker, we simply just to make the <em>rgb</em> equally smaller.</p>

<pre><code class="ocaml">let darker {Color.r = r;g = g;b = b} =  
  let d c = if c-30 &gt;= 0 then c-30 else 0 
  in 
  {Color.r = d r;g = d g;b = d b}
(*
  The decrement `30` really depends on how many times you would like to run the generator 
  and also how obvious you want the color difference to be.
*)
</code></pre>

<p>And now we can integrate the major random number genrations in.</p>

<pre><code class="ocaml">(*
  ran_f: the random number generator function, produce number within [0, bound)
         fun: int -&gt; int
  w, h:  the width and height
         int
  n:     the expected times of same number generated
         int

  Note in total, the generator will be called w * h * n times.
*)
let random_to_bitmap ~ran_f ~w ~h ~n =  
  let bitmap = Array.make_matrix w h {Color.r = 255; g = 255; b = 255} in
  let to_row_col ~w ~v = v / w, v mod w in
  let darker {Color.r = r;g = g;b = b} = let d c = if c-30 &gt;= 0 then c-30 else 0 in {Color.r = d r;g = d g;b = d b} 
  in
  for i = 1 to w * h * n do
    let row, col = to_row_col ~w ~v:(ran_f (w * h)) in
    bitmap.(row).(col) &lt;- darker bitmap.(row).(col);
  done;
  bitmap
</code></pre>

<h2>Convert the matrix to an image</h2>

<p>We will use the module <em>Rgb24</em> in <em>camlimages</em> to map the matrix to an image.</p>

<pre><code class="ocaml">let bitmap_to_img ~bitmap =  
  let w = Array.length bitmap in
  let h = if w = 0 then 0 else Array.length bitmap.(0) in
  let img = Rgb24.create w h in
  for i = 0 to w-1 do
    for j = 0 to h-1 do
      Rgb24.set img i j bitmap.(i).(j)
    done
  done;
  img
</code></pre>

<h2>Save the image</h2>

<p>Module <em>Jpeg</em> will do the trick perfectly, as long as you remembered to install <em>libjpeg</em> before <em>camlimages</em> arrives.</p>

<pre><code class="ocaml">let save_img ~filename ~img = Jpeg.save filename [] (Images.Rgb24 img)  
</code></pre>

<h2>Our master function</h2>

<p>By grouping them all together, we get our master function.</p>

<pre><code class="ocaml">let random_plot ~filename ~ran_f ~w ~h ~n =  
  let bitmap = random_to_bitmap ~ran_f ~w ~h ~n in
  let img = bitmap_to_img ~bitmap in
  save_img ~filename ~img
</code></pre>

<p>All source code is in here <a href="https://github.com/MassD/typeocaml_code/tree/master/visualise_randomness">https://github.com/MassD/typeocaml_code/tree/master/visualise_randomness</a></p>

<h2>Result - standard Random.int</h2>

<p>OCaml standard lib provides a <a href="http://caml.inria.fr/pub/docs/manual-ocaml/libref/Random.html">random integer genertor</a>:</p>

<pre><code class="ocaml">val int : int -&gt; int

Random.int bound returns a random integer between 0 (inclusive) and bound (exclusive). bound must be greater than 0 and less than 2^30.  
</code></pre>

<p>Let's have a look what it looks like:</p>

<pre><code class="ocaml">let _ = random_plot ~filename:&quot;random_plot_int.jpg&quot; ~ran_f:Random.int ~w:1024 ~h:1024 ~n:5  
</code></pre>

<p><img src="https://raw.githubusercontent.com/MassD/typeocaml_code/master/visualise_randomness/random_plot_int.jpg" alt="ran_int"/></p>

<p>Is it satisfying? Well, I guess so.</p>

<h2>Result - ran_gen_via_time</h2>

<p>Let's try it on the <code>ran_gen_via_time</code> generator we invented before:</p>

<pre><code class="ocaml">let decimal_only f = f -. (floor f)  
let ran_via_time bound =  
  ((Unix.gettimeofday() |&gt; decimal_only) *. 100,000,000. |&gt; int_of_float) mod bound

let _ = random_plot ~filename:&quot;random_plot_time.jpg&quot; ~ran_f:ran_via_time ~w:1024 ~h:1024 ~n:5  
</code></pre>

<p><img src="https://raw.githubusercontent.com/MassD/typeocaml_code/master/visualise_randomness/random_plot_time.jpg" alt="ran_time"/></p>

<p>Is it satisfying? Sure not.</p>

<p>Apparently, there are quite some patterns on images. Can you identify them?</p>

<p>For example,</p>

<p><img src="http://typeocaml.com/content/images/2015/11/random_plot_time.jpg" alt="ran_time_patr"/></p>

<p>One pattern is the diagonal lines there (parrallel to the red lines I've added).</p>

<h1>Only quick and fun</h1>

<p>Of course, visualisation of randomness is nowhere near accurately assess the quality of random geneators. It is just a fun way to feel its randomness.</p>

<p>I hope you enjoy it.</p>

<hr/>

<h1>JPG vs PNG</h1>

<p>Pointed by <a href="https://news.ycombinator.com/item?id=10609990">Ono-Sendai on hacker news</a>, it might be better to use <code>png</code> rather than <code>jpg</code>.</p>

<p>I've tried and the results for the bad <code>ran_gen_via_time</code> are like:</p>

<h2>JPG</h2>

<p><img src="https://raw.githubusercontent.com/MassD/typeocaml_code/master/visualise_randomness/random_plot_time.jpg" alt="jpg"/></p>

<h2>PNG</h2>

<p><img src="https://raw.githubusercontent.com/MassD/typeocaml_code/master/visualise_randomness/random_plot_time.png" alt="png"/></p>

<p>Seems not that different from my eyes. But anyway it was a good point.</p>

<p><a href="https://github.com/MassD/typeocaml_code/blob/master/visualise_randomness/plot_random.ml">https://github.com/MassD/typeocaml_code/blob/master/visualise_randomness/plot_random.ml</a> has been updated for <code>png</code> support. <strong>Please remember to install libpng-devel for your OS for png saving support</strong>.</p>

<h1>Fortuna random generator from nocrypto</h1>

<p><a href="https://twitter.com/h4nnes">@h4nnes</a> has suggested me to try the <em>fortuna generator</em> from <a href="https://github.com/mirleft/ocaml-nocrypto">nocrypto</a>.</p>

<pre><code>opam install nocrypto  
</code></pre>

<p>and</p>

<pre><code>let _ = Nocrypto_entropy_unix.initialize()  
let _ = random_plot ~filename:&quot;random_plot_fortuna&quot; ~ran_f:Nocrypto.Rng.Int.gen ~w:1024 ~h:1024 ~n:5  
</code></pre>

<p>and we get</p>

<p><img src="https://raw.githubusercontent.com/MassD/typeocaml_code/master/visualise_randomness/random_plot_fortuna.jpg" alt="fortuna"/></p>

<p>It is a very nice generator, isn't it?</p>
