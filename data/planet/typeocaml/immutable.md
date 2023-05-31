---
title: Immutable
description: This post describes immutable in OCaml with details. It also illustrates
  the functional programming style together with Quicksort in OCaml. Shadowing is
  also presented....
url: http://typeocaml.com/2015/01/02/immutable/
date: 2015-01-02T15:52:41-00:00
preview_image:
featured:
authors:
- typeocaml
---

<p><img src="http://typeocaml.com/content/images/2014/12/Immutable.jpg#hero" alt="immutable"/></p>

<p>In <strong>pure functional programming</strong>, everything is immutable. Strings, lists, values of customised types etc cannot be changed once being created. For example, a list such as <code>[1;2;3]</code> does not have any operation that can alter its elements. If you want the stuff inside to be changed, you need to create a new list based on it. Suppose you want to change the first element of <code>[1;2;3]</code> to be <code>4</code>, then you have to <code>let new_list = 4::List.tl [1;2;3]</code> or directly <code>let new_list = [4;2;3]</code>, however, you don't have ways to do something like <code>old_list.first_element = 4</code>.  </p>

<p>If you have got used to popular imperative programming languages such C, Java, Python, etc, you may feel that things being immutable sounds quite inconvenient. Yes, maybe sometimes being immutable forces us to do more things. In the example above, if we are able to do <code>old_list.first_element = 4</code>, it seems more natural and straightforward. However, please do not overlook the power of being immutable. It provides us extra safety, and <strong>more importantly, it leads to a different paradigm - functional programming style</strong>.</p>

<p>Before we start to dive into immutables, there are two things that need to be clarified first. </p>

<h1>Shadowing</h1>

<p>People who start to learn OCaml may see something, like the trivial code below, is allowed:</p>

<pre><code class="ocaml">let f x =  
  let y = 1 in
  let y = 2 in
  x * y
</code></pre>

<p>There are two <code>y</code>s and it seems that <code>y</code> has been changed from <code>1</code> to <code>2</code>. A conclusion might be made that things in OCaml are actually mutable because <code>y</code> is mutated. This conclusion is wrong. In OCaml, it is called <em>shadowing</em>. </p>

<p>Basically, the two <code>y</code>s are different. After the binding of second <code>y</code> is defined, the first <code>y</code> is still there for the time being. Just because it happens to have the same name as second <code>y</code>, it is in the shadow and can never be accessed later in the term of <a href="http://www.cs.cornell.edu/Courses/cs3110/2014sp/lectures/3/lec03.html">scope</a>. Thus we should not say <code>y</code> is mutated and in OCaml <em>variable</em> / <em>binding</em> is indeed immutable.</p>

<p><img src="http://typeocaml.com/content/images/2015/01/shadow-1.jpg#small" alt="shadowed"/></p>

<h1>Mutable Variables and Values</h1>

<p>The concept of being <em>immutable</em> or <em>mutable</em> was introduced because we need it to help us to predict whether something's possible change would affect other related things or not. In this section, we majorly talk about <em>mutable</em> in imperative programming as clear understading of <em>what being mutable means</em> can help us appreciate <em>immutable</em> a little more.  </p>

<p>It is easy to know <em>variable</em> is mutable in imperative programming. For example, we can do <code>int i = 0;</code>, then <code>i = 1;</code> and the same <code>i</code> is mutated. Altering a variable can affect other parts in the program, and it can be demonstrated using a <em>for loop</em> example:</p>

<pre><code class="java">/* The *for* scope repeatedly access `i` 
   and `i`'s change will affect each iteration. */

for (int i = 0; i &lt; 10; i++)  
  System.out.println(i);
</code></pre>

<p>Sometimes, even if a variable is mutated, it might not affect anything, like the example (in Java) below: </p>

<pre><code class="java">int[] a = {1;2;3};  
int[] b = a;

a = {5;6;7};

/* What is b now? */
</code></pre>

<p><code>a</code> was initially <code>{1,2,3}</code>. <code>b</code> has been declared to be equal to <code>a</code> so <code>b</code> has the same value as <code>{1,2,3}</code>. <code>a</code> later on was changed to <code>{5,6,7}</code>. Should <code>b</code> be changed to <code>{5,6,7}</code> as well? Of course not, <code>b</code> still remains as <code>{1,2,3}</code>. Thus, even if <code>a</code> is mutated, <code>b</code> is not affected. This is because in this case, the <em>value</em> underneath has not been mutated. Let's modify the code a little bit:</p>

<pre><code class="java">int[] a = {1,2,3};  
int[] b = a;

a[0] = 0;

/* What is b now? */
</code></pre>

<p><code>a[0] = 0;</code> altered the first element in the underlying array and <code>a</code> would become <code>{0,2,3}</code>. Since <em>array</em> in Java is <em>mutable</em>, <code>b</code> now becomes <code>{0,2,3}</code> too as <code>b</code> was assigned the identical array as <code>a</code> had initially. So the array value being mutable can lead to the case where if a mutable value is changed somewhere, all places that access it will be affected.  </p>

<p>A <em>mutable</em> value must provide a way for developers to alter itself through bindings, such as <code>a[0] = 0;</code> is the way for arrays, i.e., via <code>a[index]</code> developers can access the array <code>a</code> by <code>index</code> and <code>=</code> can directly assign the new element at that index in the array. </p>

<p>A <em>immutable</em> value does not provide such as way. We can check immutable type <em>String</em> in Java to confirm this.</p>

<p><img src="http://typeocaml.com/content/images/2015/01/immutable_mutable-1.jpg#small" alt="immutable_mutable"/></p>

<p>To summarise, when dealing with <em>mutable</em>, especially when we test our imperative code, we should not forget possible changes of both <em>variable</em> and <em>value</em>.</p>

<p><strong>Note</strong> that OCaml does support <em>mutable</em> and it is a kind of hybrid of <em>functional</em> and <em>imperative</em>. However, we really should care about the <em>functional</em> side of OCaml more. For the <em>imperative</em> style of OCaml and when to use it, the next post will cover with details.</p>

<h1>Extra Safety from Immutable</h1>

<p>As described before, if a mutable variable / value is altered in one place, we need to be cautious about all other places that may have access to it. The code of altering an array in the previous section is an example. Another example is supplying a mutable value to a method as argument.</p>

<pre><code class="java">public static int getMedian(int[] a) {  
    Arrays.sort(a);
    return a[a.length/2];
}

public static void main(String[] args) {  
    int[] x = {3,4,2,1,5,9,6};
    int median = getMedian(x);

    /* x is not {3,4,2,1,5,9,6} any more */
    ...
}
</code></pre>

<p><code>getMedian</code> will sort the supplied argument and the order of the elements in <code>x</code> will be changed after the call. If we need <code>x</code> to always maintain the original order, then the above code has serious flaw. It is not that bad if it is us who wrote <code>getMedian</code>, because we can just refine the code directly. However, if <code>getMedian</code> is in a third party library, even though we still can override this method, how can we know whether other method in the same library have this kind of flaw or not? A library would be useless if we cannot trust it completely. </p>

<p>Allowing mutables also introduces troubles for threading. When multiple threads try to alter a mutable value at the same time, we sometimes can just put a locker there to restrain the access to the value, with the sacrifice of make it single-threading at that point. However, if we have to precisely control the order of altering, things get much more complicated. This is why we have hundreds of books and articles to teach how to do a great multithreading in imperative programming languages. </p>

<p>If everything is immutable, then we do not need to worry about any of those any more. When we need to alter an immutable value, we create a new value that implements the change based on the old value and the old value is kept intact. All places that need access to the original value are very safe. As an example in OCaml:</p>

<pre><code class="ocaml">(* trivial way to get median in OCaml, simply for comparison to the imperative case *)
let get_median l =  
  (* we can't sort in place, have to return a new sorted list *)
  let sorted_l = List.sort compare l in
  let len = List.length l in
  List.nth (len/2) sorted_l (* here we use our new sorted list *)

let median_mul_hd =  
  let l = [3;4;2;1;5;9;6] in
  let median = get_median l in
  median * List.hd l (* the hd of l will not be 1, but still 3 - the original hd *)
</code></pre>

<p>With immutables, the burden of cautions on unexpected modification of values are  relieved for us. Hence, for OCaml, we do not need to spend time on studying materials such as <em>Item 39: Make defensive copies when needed</em> in <a href="http://www.amazon.co.uk/Effective-Java-Edition-Joshua-Bloch/dp/0321356683">Effective Java</a>. </p>

<p><img src="http://typeocaml.com/content/images/2015/01/extra_safety-2.jpg#small" alt="extra_safety"/></p>

<p>Being immutable brings extra safety to our code and helps us to avoid possibly many trivial bugs like the ones described before. However, this is not free of charge. We may feel more restrictive and lose much flexibilities (<em>[1]</em>). Moreover, because we cannot alter anything, pure functional programming forces us to adapt to a new style, which will be illustrated next. </p>

<h1>Functional Programming Style</h1>

<p>As mentioned in <a href="http://typeocaml.com/2014/12/04/recursion-reloaded/">Recursion Reloaded</a>, we <em>cannot</em> use loops such in pure functional programming, because <em>mutable</em> is not in functional world. Actually, there was a little misinterpretation there: it is not <em>we cannot</em> but is <em>we are not able to</em>. </p>

<p>A typical <em>while loop</em> in Java looks like this:</p>

<pre><code class="java">int i = 0;  
while ( i &lt; 10 ) {  
   ...
   i++;
}

/* note that above is the same as
   for(int i = 0; i &lt; n; i++) ... */
</code></pre>

<p>The reason that the while loop works in Java is because:</p>

<ol>
<li><code>i</code> is defined before <code>while</code> scope.  </li>
<li>We go into <code>while</code> scope and <code>i</code> continues to be valid inside.  </li>
<li>Since <code>i</code> is mutable, <code>i</code>'s change is also valid inside <code>while</code>.  </li>
<li>So we can check the same <code>i</code> again and again, and also use it repeatedly inside <code>while</code>.</li>
</ol>

<p>Are we able to do the same thing in OCaml / Functional Programming? The answer is <strong>no</strong>.If you are not convinced, then we can try to assume we were able to and <strong>fake</strong> some OCaml syntax. </p>

<pre><code class="ocaml">(* fake OCaml code *)

let i = 0 in  
while i &lt; 10 do  
  ...
  let i = i + 1 ...
end while
</code></pre>

<ol>
<li><code>i</code> is defined before <em>while</em>, no problem.  </li>
<li>Initially, <code>while</code> gets <code>i</code> for the first time and check it against <code>10</code>, no problem.  </li>
<li><code>i</code> can be used for the first time inside <code>...</code>, still no problem.  </li>
<li>Then we need to increase <code>i</code> and the problem starts.  </li>
<li>Recall that <code>i</code> is immutable in OCaml. The <code>first i</code> after <code>let</code> in <code>let i = i + 1</code> is actually new and the <code>original i</code> is shadowed.  </li>
<li>The new <code>i</code> is created within the <code>while</code> scope, so after one iteration, it is invalid any more.  </li>
<li>Thus the second time at <code>while i &lt; 10 do</code>, the original <code>i</code> would be still 0 and the loop would stuck there forever. </li>
</ol>

<p>The above attempt proves that we can't do looping in pure functional programming any more. This is why we replace it with recursion as described in <a href="http://typeocaml.com/2014/12/04/recursion-reloaded/">Recursion Reloaded</a> before. </p>

<p>Furthermore, we can see that the execution runtime in imperative programming is normally driven by mutating states (like the <em>while loop</em> gets running by changing <code>i</code>). In functional programming, however, the execution continues by creating new things and giving them to the next call / expression / function. Just like in recursion, a state needs to be changed, so we give the same function the new state as argument. This is indeed <em>the functional programming style:</em> <strong>we create and then deliver</strong>.</p>

<p>One may still think <em>imperative</em> is easier and more straightforward than <em>functional</em>. Our brain likes <em>change and forget</em>, so for <em>imperative</em>'s easiness, maybe. However, if you say <em>imperative</em> is more straightforward, I doubt it.</p>

<p>Let's temporarily forget the programming / coding part and just have a look at something at high level. </p>

<blockquote>
  <p>Suppose there is process, in which there are two states: <code>A</code> and <code>B</code>. Most importantly, <code>State A</code> can change to <code>State B</code>. Now plese close your eyes and draw a diagram for this simple process in your mind. </p>
</blockquote>

<p>Done? </p>

<p>I bet you imagined this diagram as below:</p>

<p><img src="http://typeocaml.com/content/images/2015/01/state_true.jpg#small" alt="state_true"/></p>

<p>But NOT </p>

<p><img src="http://typeocaml.com/content/images/2015/01/state_false.jpg#small" alt="state_false"/></p>

<p>When we were really thinking of the trivial process, there must be two separate states in our mind and an explicit arrow would be there to clearly indicate the transition. This is much more nature than imagining just one state and the two situations inside. Afterall, this is called landscape and we often need it when we design something. </p>

<p>When we start to implement it, we might think differently. We sometimes intend to use the easy way we get used to. For example, in many cases we can just use one state variable and forget <code>State A</code> after transiting to <code>State B</code> during implementation, because always remembering <code>State A</code> may be unnecessary. This difference between design and implementation are always there and we are just not aware of it or we just feel it smoother due to our imperative habit. </p>

<p>Functional programming style does not have that difference. In the above example, if we implement it in OCaml, we will do exactly the same as the upper diagram, i.e., we create <code>State A</code> and when the state needs to be changed to <code>B</code>, we create a new <code>State B</code>. This is why I say <em>functional</em> is more straightforward because it directly reflects our intuitive design. If you are not convinced still, let's design and implement the <em>quicksort</em> in both imperative and functional styles as an demonstration.</p>

<h1>Quicksort</h1>

<p>Quicksort is a classic sorting algorithm. </p>

<ol>
<li>If only one or no element is there, then we are done.  </li>
<li>Everytime we select a pivot element, e.g. the first element,  from all elements that we need to sort.  </li>
<li>We compare elements with the pivot, put the <em>smaller</em> elements on its left hand side and <em>larger</em> ones on its right hand side. Note that neither <em>smaller</em>s or <em>larger</em>s need to be in order.  </li>
<li>The pivot then gets fixed.  </li>
<li>Quicksort all elements on its left.  </li>
<li>Quicksort all elements on its right. </li>
</ol>

<p>The core idea of quicksort is that we partition all elements into 3 parts: <em>smaller</em>, <em>pivot</em> and <em>larger</em> in every iteration. So <em>smaller</em> elements won't need to be compared with <em>bigger</em> elements ever in the future, thus time is saved. In addition, although we split the elements into 3 parts, <em>pivot</em> will be fixed after one iteration and only <em>smaller</em> and <em>larger</em> will be taken account into the next iteration. Hence the number of effective parts, which cost time next, is actually 2. How many times we can get <em>smaller</em> and <em>larger</em> then? <em>O(logn)</em> times, right? So at most we will have <em>O(logn)</em> iterations. Hence The time complexity of quicksort is <em>O(nlogn)</em>.</p>

<h2>Design</h2>

<p>The key part of quicksort is <em>partitioning</em>, i.e., step 2 and 3. How can we do it? Again, let's design the process first without involving any coding details. </p>

<p>Say we have some elements <code>4, 1, 6, 3, 7</code>. You don't have to write any code and you just need to manually partition them once like step 2 and 3. How will you do it in your imagination or on paper? Could you please try it now?</p>

<p>Done?</p>

<p>I bet you imagined or wrote down the flow similar as below:</p>

<p><img src="http://typeocaml.com/content/images/2015/01/quicksort-1.jpg#small" alt="quicksort"/></p>

<p>The mechanism of <em>partition</em> is not complicated. We get the <em>pivot</em> out first. Then get an element out of the rest of elements one by one. For each element, we compare it with the <em>pivot</em>. If it is smaller, then it goes to the left; otherwise, goes to the right. The whole process ends when no element remains. Simple enough? I believe even for non-developers, they would mannually do the <em>partition</em> like shown in the diagram. </p>

<p>Our design of <em>partition</em> is quite finished. It is time to implement it.</p>

<h2>Imperative implementation</h2>

<p>Let's first try using Java. Can we follow the design in the diagram directly? I bet not. The design assumed that the pivot <code>4</code> will have two bags (initially empty): one on its left and the other on its right. Just this single point beats Java. In Java or other imperative programming languages, normally when we sort some elements, all elements are in an array and we prefer doing things in place if we are able to. That says, for example, if we want <code>1</code> to be on the left hand side of <code>4</code>, we would use <em>swap</em>. It is efficient and the correct way when adjusting the positions of elements in an array.</p>

<p>There are a number of ways to implement <em>partition</em> in Java and here the one presented in the book of <a href="http://algs4.cs.princeton.edu/23quicksort/">Algorithms, Robert Sedgewick and Kevin Wayne</a> is briefly presented as a diagram below:</p>

<p><img src="http://typeocaml.com/content/images/2015/01/quicksort_imperative-1.jpg#small" alt="quicksort_imperative"/></p>

<p>We do not have <em>smaller bag</em> or <em>larger bag</em> any more. We do not do <em>throwing element into according bag</em> either. We have to maintain two additional pointers <code>i</code> and <code>j</code>. <code>i</code> is used to indicate the next element in action. If an element is smaller than the pivot, swapping it with the pivot will put it to the left. If an element is larger, then we swap it with <code>j</code>'s element. <code>j</code> can now decrease while <code>i</code> stays put because <code>i</code> now is a new element that was just swapped from <code>j</code>. The whole process stops when <code>i &gt; j</code>. </p>

<p>As we can see, the implementation is quite different from the high level design and much more complicated, isn't it? The design just tells us <em>we get a new element out, compare it with the pivot, and put it to the left or right depending on the comparison.</em>. We cannot have such a simple summary for the implementation above. More than that, we need to pay extra attention on <code>i</code> and <code>j</code> as <strong>manipulating indices of an array is always error-prone</strong>. </p>

<p>The Java code is directly copied from <a href="http://algs4.cs.princeton.edu/23quicksort/Quick.java.html">the book</a> to here:</p>

<pre><code class="java">private static int partition(Comparable[] a, int lo, int hi) {  
        int i = lo;
        int j = hi + 1;
        Comparable v = a[lo];
        while (true) { 
            // find item on lo to swap
            while (less(a[++i], v))
                if (i == hi) break;

            // find item on hi to swap
            while (less(v, a[--j]))
                if (j == lo) break;      // redundant since a[lo] acts as sentinel

            // check if pointers cross
            if (i &gt;= j) break;

            exch(a, i, j);
        }

        // put partitioning item v at a[j]
        exch(a, lo, j);

        // now, a[lo .. j-1] &lt;= a[j] &lt;= a[j+1 .. hi]
        return j;
    }
</code></pre>

<h2>Functional Implementation</h2>

<p>The functional implementation fits the design perfectly and We have to thank the <em>always creating new and deliver</em> of functional programming style for that.  </p>

<ol>
<li>The design asks for two bags around the pivot and we can directly do that: <code>(left, pivot, right)</code>.  </li>
<li>The design says if an element is <em>smaller</em>, then put to the left. We can again directly do that <code>if x &lt; pivot then (x::left, pivot, right)</code>.  </li>
<li>We can also directly handle <em>larger</em>: <code>else (left, pivot, x::right)</code>. </li>
</ol>

<p>For iterations, we can just use <em>recursion</em>. The complete OCaml code for <em>partition</em> is like this:</p>

<pre><code class="ocaml">let partition pivot l =  
  (* we can actually remove pivot in aux completely.
     we put it here to make it more meaningful *)
  let rec aux (left, pivot, right) = function
    | [] -&gt; (left, pivot, right)
    | x::rest -&gt;
      if x &lt; pivot then aux (x::left, pivot, right) rest
      else aux (left, pivot, x::right) rest
  in
  aux ([], pivot, []) l (* two bags are initially empty *)
</code></pre>

<p>If you know <code>fold</code> and remove pivot during the process, then it can be even simpler:</p>

<pre><code class="ocaml">(* using the List.fold from Jane Street's core lib *)
let partition_fold pivot l =  
  List.fold ~f:(
    fun (left, right) x -&gt; 
      if x &lt; pivot then (x::left, right)
      else (left, x::right)) ~init:([], []) l
</code></pre>

<p>One we get the functional <em>partition</em>, we can write <em>quicksort</em> easily:</p>

<pre><code class="ocaml">let rec quicksort = function  
  | [] | _::[] as l -&gt; l
  | pivot::rest -&gt;
    let left, right = partition_fold pivot rest in
    quicksort left @ (pivot::quicksort right)
</code></pre>

<h2>Summary</h2>

<p>Now we have two implementations for <em>quicksort</em>: imperative and functional. Which one is more straightforward and simpler? </p>

<p>In fact, functional style is more than just being consistent with the design: <strong>it handles data directly, instead of via any intermedia layer in between</strong>. In imperative programming, we often use array and like we said before, we have to manipulate the indices. The <em>indices</em> stand between our minds and the data. In functional programming, it is different. We use immutable list and using indices makes not much sense any more (as it will be slow). So each time, we just care the head element and often it is more than enough. This is one of the reasons why I love OCaml. Afterall, we want to deal with data and why do we need any unnecessary gates to block our way while they pretend to help us?</p>

<p>One may say imperative programming is faster as we do not need to constantly allocate memory for new things. Yes, normally array is faster than list. And also doing things in place is more effient. However, OCaml has a very good type system and a great <a href="https://realworldocaml.org/v1/en/html/understanding-the-garbage-collector.html">GC</a>, so the performance is not bad at all even if we always creating and creating. </p>

<p>If you are interested, you can do the design and imperative implementation for <em>mergesort</em>, and you will find out that we have to create new auxiliary spaces just like we would do in functional programming. </p>

<h1>OCaml - the Hybrid</h1>

<p>So far in this post, we used quite a lot of comparisons between imperative and functional to prove <em>immutable is good</em> and <em>functional programming style is great</em>. Yes, I am a fan of OCaml and believe functional programming is a decent way to do coding. However, I am not saying imperative programming is bad (I do Java and Python for a living in daytime and become an OCamler at deep night). </p>

<p><em>Imperative</em> has its glories and OCaml actually never forgets that. That's why OCaml itself is a hybrid, i.e., you can just write OCaml code in imperative style. One of the reasons OCaml reserves imperative part is that sometimes we need to remember a state in one single place. Another reason can be that we need arrays for a potential performance boost. </p>

<p>Anyhow, OCaml is still a functional programming language and we should not forget that. Especially for beginners, please do pure functional programming in OCaml as much as possible. Do not bow to your imperative habit. For the question of <em>when should I bring up imperative style in OCaml</em> will be answered in the next post <a href="http://typeocaml.com/2015/01/20/mutable/">Mutable</a>. </p>

<hr/>

<p><strong>[1].</strong> </p>

<p>People enjoy flexbilities and conveniences, and that's one of the reasons why many people fancy Java and especially Python. It feels free there and we can easily <a href="http://www.amazon.co.uk/Beginning-Python-Programming-Learn-Treading-ebook/dp/B00639H0AK/">learn them in 7 days</a> and implement our ideas with them quickly. However, be aware of the double sides of being flexible and convenient. </p>

<p>When we really want to make a proper product using Java or Python, we may need to read books on <em>what not to do even though they are allowed</em> (yeah, this is a point, if we should not use something in most cases, why it is allowed at all?). We have to be very careful in many corners and 30% - 50% of the time would be spent on testing. Eventually, <em>how to write beautiful code</em> might become <em>how to test beautifully</em>. </p>

<p>OCaml and other functional programming languages are on the opposite side - they are very restrictive, but restrictions are for the great of good. For example, we cannot freely use the best excuse of <em>sorry I can't return you a valid answer</em> - <strong>return null;</strong>. Instead, we have the <em>None</em>, which is part of <em>option</em>, to explicitly tell you that nothing can be returned. The elegant reward of using <em>option</em> is that when we try to access it, <strong>we have to deal with the <em>None</em></strong>. Thus <em>NullPointerException</em> does not exist in OCaml (<em>[2]</em>). </p>

<p><img src="http://typeocaml.com/content/images/2014/12/null.jpg#small" alt="null"/></p>

<p>For <em>if</em> and <em>pattern matching</em>, OCaml forces us to cover all possible cases. It sounds troublesome during coding as we sometimes know that we don't care about some cases or some cases will never happen. Yes, we may ignore those cases in our working code in Java or Python, but later do we have to consider them in testing code? Often we do, right? </p>

<p>OCaml cuts off some flexibilities. As an outcome, to achieve a goal, we have quite limited number of ways and occasionally even just one way and that way might be very tough (we will see it in later posts on functional pearls). But trust me, after mastering OCaml at a certain level and looking at the very robust OCaml code you wrote, you would appreciate OCaml and recall this slogan: </p>

<blockquote>
  <p>&quot;Less is more&quot; - Andrea del Sarto, Robert Browning. </p>
</blockquote>

<p><strong>[2].</strong> &quot;Options are important because they are the standard way in OCaml to encode a value that might not be there; there's no such thing as a NullPointerException in OCaml. &quot; - <a href="https://realworldocaml.org/v1/en/html/a-guided-tour.html">Chapter 1 in Real World Ocaml</a></p>

<p><strong>Ps.</strong></p>

<p><a href="http://en.wikipedia.org/wiki/Wolverine_(character)">Wolverine</a> in the head image of this post is a major character in <a href="http://en.wikipedia.org/wiki/X-Men">X-Men's world</a>. Since the regeneration of his body cells is super fast, he will not be permernantly hurt or age. Just like Wolverine, <em>immutables</em> in OCaml will not change once created. However, unlike Wolverine, they can not be immortals because many of them would be recycled by the garbage collector at some point during the runtime.</p>
