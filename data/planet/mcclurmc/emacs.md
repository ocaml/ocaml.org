---
title: Emacs!
description: "I love Emacs. I\u2019ve been using it ever since I took my first programming
  language theory class in college. I had played around with it before then, but it
  took my professor\u2019s recommendat\u2026"
url: https://mcclurmc.wordpress.com/2010/01/19/emacs/
date: 2010-01-19T06:43:00-00:00
preview_image: https://s0.wp.com/i/blank.jpg
featured:
authors:
- mcclurmc
---

<p>I love Emacs. I&rsquo;ve been using it ever since I took my first programming language theory class in college. I had played around with it before then, but it took my professor&rsquo;s recommendation and half a class worth of a tutorial and I was hooked.</p>
<p>We studied Scheme in that class, which is why my prof recommended that we all use Emacs. Scheme is a variant of Lisp, which is the language that Emacs is built around. And Elisp, as it&rsquo;s called, is a great embedded language for customizing Emacs. You could think of it as Visual Basic for Applications, which is Microsoft&rsquo;s language for customizing Office products, but much more simple and powerful to use (as long as parentheses don&rsquo;t scare you).</p>
<p>I&rsquo;ve only got one or two friends that might consider themselves to be Emacs gurus, and one of them wrote me the other day with a challenge. &ldquo;I believe this problem is trivial,&rdquo; he said, which is never a good sign, &ldquo;but I&rsquo;ve only had 20 minutes to think about and I&rsquo;ve got to run.&rdquo; He had been working on an Emacs library to help him configure a massive Ant build script. Part of his build process involved him logging into numerous test and dev machines, and he wanted to automate that in Emacs. He had written a list of interactive functions that would allow him to <tt>rlogin</tt> into each machine by typing <tt>M-x machine</tt> (<tt>M</tt> stands for <tt>Alt</tt>, or <tt>Meta</tt>, in Emacs, and is used to specify commands from the keyboard). These functions were each defined with syntax like the following:</p>
<p><code></code></p>
<pre>(defun machine1 ()
  (interactive)
  (rlogin &quot;machine1&quot; &quot;*machine1*&quot;))</pre>
<p>&nbsp;</p>
<p>This list of functions had grown quite a bit in the months since he implemented this feature, and he wanted to find a way to automatically define a function that would log him into a specified machine by simply typing <tt>M-x machine</tt>. Easy, right?</p>
<h2>A first attempt</h2>
<p>My first approach to this problem was to create an association list of functions and their names. We would create a single interactive function that would select and run the appropriate generated function.</p>
<div></div>
<p><code></code></p>
<pre>(defun my-login (fn)
&nbsp; (interactive &quot;sWhich function? &quot;)
&nbsp; (funcall
    (cdr (assoc (read fn) my-fnassoc)))))</pre>
<p></p>
<p>There are a few things going on in this function. The <tt>(interactive &quot;sWhich function? &quot;)</tt> statement tells Emacs that this function can be called interactively using the <tt>M-x my-login</tt> syntax. The strange string &ldquo;sWhich function? &rdquo; is just a format string telling Emacs to prompt the user for a string argument (the &ldquo;s&rdquo;) with the prompt &ldquo;Which function? &ldquo;. If this were a multivariate function, we would simply break each format string with a &ldquo;\n&rdquo; character in order to prompt for each of our arguments. The <tt>read</tt> function just turns our argument string into a symbol, and the call <tt>(cdr (assoc (read fn) fnassoc))</tt> looks the symbol up in the association list <tt>my-fnassoc</tt>. <tt>funcall</tt> executes the returned function. Now we just need to build <tt>my-fnassoc</tt>.</p>
<p><code></code></p>
<pre>(defun mkfunls (name)
  (let* ((host (prin1-to-string name))
         (buff (format &quot;*%s*&quot; host)))
    `(,name . (lambda () (rlogin ,host ,buff)))))</pre>
<p></p>
<p>This function creates a single association pair of the form <tt>(host . login-function)</tt>. Since our <tt>name</tt> parameter is a symbol, we need to convert it to a string using <tt>prin1-to-string</tt>. The Emacs <tt>rlogin</tt> command allows us to specify the name of the buffer in which we spawn the remote shell. We can use the  <tt>format</tt> function to create a standard buffer name for each <tt>rlogin</tt> session we create.</p>
<p>The final line of <tt>mkfunls</tt> takes advantage of Lisp&rsquo;s backquoting feature. The syntax looks a little strange at first, but if you can put up with Lisp&rsquo;s other oddities then there&rsquo;s no sense not learning about backquoting too. Quoting in Lisp, accomplished with either the <tt>quote</tt> special form or the abbreviation <tt>'</tt> (a single apostrophe). Quoting prevents evaluation of the form being quoted, so evaluating <code>(+ 1 2)</code> returns the value 3, while evaluating <code>(quote (+ 1 2))</code>, or the equivalent <code>'(+ 1 2)</code>, returns the value <code>(+ 1 2)</code> instead.</p>
<p>Backquoting accomplishes the same thing, but allows the programmer to  selectively specify which parts of a list are to be evaluated and which parts aren&rsquo;t. It&rsquo;s called backquoting because we use a backwards apostrophe (<code>`</code> &mdash; found under the tilde) instead of <code>quote</code> or the regular apostrophe. We select the forms we want to evaluate using a comma. So the line <code>`(,name . (lambda () (rlogin ,host ,buff)))</code> evaluates the <code>name</code>, <code>host</code>, and <code>buff</code> variables but quotes all the rest of the symbols. So the call <code>(mkfunls 'machine1)</code> evaluates to <code>(machine1 lambda nil (rlogin &quot;machine1&quot; &quot;*machine1*&quot;))</code>. Now all that&rsquo;s left is to create our host/rlogin association list and we&rsquo;ll be able to log in to remote hosts with a single command.</p>
<p><code>(setq my-fnassoc (mapcar 'mkfunls '(m1 m2 m3)))</code></p>
<p>This creates an association list with the host names <code>m1, m2, m3</code> and sets the variable <code>my-fnassoc</code>. The function <code>mapcar</code> applies it&rsquo;s first argument, in the case the function <code>mkfunls</code>, to it&rsquo;s second argument, which must be a list.</p>
<p>Now when we type <code>M-x my-login</code> we receive the prompt &ldquo;Which host?&rdquo;, to which we can reply with any of the hosts we specified in the <code>my-fnassoc</code> list above.</p>
<p>But this doesn&rsquo;t quite solve my buddy&rsquo;s problem, does it? His list of login functions, while a little cumbersome to maintain, defined interactive functions at the top level, which allowed him to run <code>M-x machine1</code> instead of the more indirect call to <code>M-x my-login</code> above.</p>
<h2>A better solution</h2>
<p>What we want is to automatically generate named, interactive functions. My initial thought was that this was a perfect task for macros, but it turns out that we don&rsquo;t even have to bother with macros to make this work. Instead, we&rsquo;ll use the backquoting syntax from above to build up <code>defuns</code> and then evaluate them.</p>
<p><code></code></p>
<pre>(defun mkdefun (name)
  (let* ((host (prin1-to-string name))
         (buff (format &quot;*%s*&quot; host)))
    (eval
     `(defun ,name () (interactive) (rlogin ,host ,buff)))))</pre>
<p></p>
<p>This is very similar to our <code>mkfunls</code> function above. Instead of returning an association list, we&rsquo;re evaluating a <code>defun</code>. We use the backquote syntax to selectively evaluate the <code>name</code>, <code>host</code>, and <code>buff</code> variables. <code>eval</code> then evaluates the <code>defun</code> for us and creates a new top level definition. We can then map over a list of function names like we did before:</p>
<p><code>(mapc 'mkdefun '(m1 m2 m3))</code></p>
<p><code>mapc</code> is like <code>mapcar</code>, except that it doesn&rsquo;t return the a list of the results of the function evaluations. This is useful when we only care about a function&rsquo;s side effect and not its results.</p>
<p>So now we have a simple method to automatically generate repetitive Emacs commands. All we have to do is append new function names to the list in the <code>mapc</code> command and we have a new function!</p>

