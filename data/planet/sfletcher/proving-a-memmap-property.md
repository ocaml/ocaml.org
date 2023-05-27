---
title: Proving a mem/map property
description: Here are two well known "classic" functions over polymorphic       lists.                 map
  f l  computes a ne...
url: http://blog.shaynefletcher.org/2017/05/proving-mem-map-property.html
date: 2017-05-11T20:17:00-00:00
preview_image:
featured:
authors:
- Shayne Fletcher
---

&amp;#60;!DOCTYPE HTML PUBLIC &amp;#34;-//W3C//DTD HTML 4.01//EN&amp;#34;
          &amp;#34;http://www.w3.org/TR/html4/strict.dtd&amp;#34;&amp;#62;
&amp;#60;html&amp;#62;
  &amp;#60;head&amp;#62;
&amp;#60;style&amp;#62;
.keyword { font-weight : bold ; color : Red }
.keywordsign { color : #C04600 }
.comment { color : Green }
.constructor { color : Blue }
.type { color : #5C6585 }
.string { color : Maroon }
.warning { color : Red ; font-weight : bold }
.info { margin-left : 3em; margin-right: 3em }
.param_info { margin-top: 4px; margin-left : 3em; margin-right : 3em }
.code { color : #465F91 ; }
pre { margin-bottom: 4px; font-family: monospace; }
pre.verbatim, pre.codepre { }&amp;#60;/style&amp;#62;
    &amp;#60;title&amp;#62;&amp;#60;/title&amp;#62;
  &amp;#60;/head&amp;#62;
  &amp;#60;body&amp;#62;
    &amp;#60;p&amp;#62;
      Here are two well known &amp;#34;classic&amp;#34; functions over polymorphic
      lists.
    &amp;#60;/p&amp;#62;
    &amp;#60;p&amp;#62;
      &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;map f l&amp;#60;/code&amp;#62; computes a new list from &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;l&amp;#60;/code&amp;#62;
      by applying &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;f&amp;#60;/code&amp;#62; to each of its elements.
&amp;#60;pre&amp;#62;&amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;&amp;#60;span class=&amp;#34;keyword&amp;#34;&amp;#62;let&amp;#60;/span&amp;#62; &amp;#60;span class=&amp;#34;keyword&amp;#34;&amp;#62;rec&amp;#60;/span&amp;#62; map (f : &amp;#60;span class=&amp;#34;keywordsign&amp;#34;&amp;#62;'&amp;#60;/span&amp;#62;a &amp;#60;span class=&amp;#34;keywordsign&amp;#34;&amp;#62;-&amp;#38;gt;&amp;#60;/span&amp;#62; &amp;#60;span class=&amp;#34;keywordsign&amp;#34;&amp;#62;'&amp;#60;/span&amp;#62;b) : &amp;#60;span class=&amp;#34;keywordsign&amp;#34;&amp;#62;'&amp;#60;/span&amp;#62;a list &amp;#60;span class=&amp;#34;keywordsign&amp;#34;&amp;#62;-&amp;#38;gt;&amp;#60;/span&amp;#62; &amp;#60;span class=&amp;#34;keywordsign&amp;#34;&amp;#62;'&amp;#60;/span&amp;#62;b list = &amp;#60;span class=&amp;#34;keyword&amp;#34;&amp;#62;function&amp;#60;/span&amp;#62;
        &amp;#60;span class=&amp;#34;keywordsign&amp;#34;&amp;#62;|&amp;#60;/span&amp;#62; [] &amp;#60;span class=&amp;#34;keywordsign&amp;#34;&amp;#62;-&amp;#38;gt;&amp;#60;/span&amp;#62; []
        &amp;#60;span class=&amp;#34;keywordsign&amp;#34;&amp;#62;|&amp;#60;/span&amp;#62; h :: t &amp;#60;span class=&amp;#34;keywordsign&amp;#34;&amp;#62;-&amp;#38;gt;&amp;#60;/span&amp;#62; f h :: map f t
        ;;
&amp;#60;/code&amp;#62;&amp;#60;/pre&amp;#62;
    &amp;#60;/p&amp;#62;

    &amp;#60;p&amp;#62;&amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;mem x l&amp;#60;/code&amp;#62; returns &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;true&amp;#60;/code&amp;#62; is &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;x&amp;#60;/code&amp;#62;
      is an element of &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;l&amp;#60;/code&amp;#62; and returns &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;false&amp;#60;/code&amp;#62; if it
      is not.
&amp;#60;pre&amp;#62;&amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;&amp;#60;span class=&amp;#34;keyword&amp;#34;&amp;#62;let&amp;#60;/span&amp;#62; &amp;#60;span class=&amp;#34;keyword&amp;#34;&amp;#62;rec&amp;#60;/span&amp;#62; mem (a : &amp;#60;span class=&amp;#34;keywordsign&amp;#34;&amp;#62;'&amp;#60;/span&amp;#62;a) : &amp;#60;span class=&amp;#34;keywordsign&amp;#34;&amp;#62;'&amp;#60;/span&amp;#62;a list &amp;#60;span class=&amp;#34;keywordsign&amp;#34;&amp;#62;-&amp;#38;gt;&amp;#60;/span&amp;#62; bool  = &amp;#60;span class=&amp;#34;keyword&amp;#34;&amp;#62;function&amp;#60;/span&amp;#62;
        &amp;#60;span class=&amp;#34;keywordsign&amp;#34;&amp;#62;|&amp;#60;/span&amp;#62; [] &amp;#60;span class=&amp;#34;keywordsign&amp;#34;&amp;#62;-&amp;#38;gt;&amp;#60;/span&amp;#62; &amp;#60;span class=&amp;#34;keyword&amp;#34;&amp;#62;false&amp;#60;/span&amp;#62;
        &amp;#60;span class=&amp;#34;keywordsign&amp;#34;&amp;#62;|&amp;#60;/span&amp;#62; x :: l &amp;#60;span class=&amp;#34;keywordsign&amp;#34;&amp;#62;-&amp;#38;gt;&amp;#60;/span&amp;#62; a = x &amp;#60;span class=&amp;#34;keywordsign&amp;#34;&amp;#62;||&amp;#60;/span&amp;#62; mem a l
        ;;
&amp;#60;/code&amp;#62;&amp;#60;/pre&amp;#62;
    &amp;#60;/p&amp;#62;
    &amp;#60;p&amp;#62;
      If &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;y&amp;#60;/code&amp;#62; is an element of the list obtained by
      mapping &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;f&amp;#60;/code&amp;#62; over &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;l&amp;#60;/code&amp;#62; then there must be an
      element &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;x&amp;#60;/code&amp;#62; in &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;l&amp;#60;/code&amp;#62; such that 
      &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;f x = y&amp;#60;/code&amp;#62;. Conversely, if there exists an &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;x&amp;#60;/code&amp;#62;
      in &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;l&amp;#60;/code&amp;#62; such that &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;y = f x&amp;#60;/code&amp;#62;,
      then &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;y&amp;#60;/code&amp;#62; must be a member of the list obtained by
      mapping &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;f&amp;#60;/code&amp;#62; over &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;l&amp;#60;/code&amp;#62;.
   &amp;#60;/p&amp;#62;
    &amp;#60;p&amp;#62;
      We attempt a proof of correctness of the given definitions with
      respect to this property.
    &amp;#60;/p&amp;#62;

    &amp;#60;b&amp;#62;Lemma&amp;#60;/b&amp;#62; &amp;#60;code&amp;#62;mem_map_iff&amp;#60;/code&amp;#62;:
    &amp;#60;pre&amp;#62;&amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;
    &amp;#38;forall; (f : &amp;#38;alpha; &amp;#38;rarr; &amp;#38;beta;) (l : &amp;#38;alpha; list) (y : &amp;#38;beta;),
        mem y (map f l) &amp;#38;iff; &amp;#38;exist;(x : &amp;#38;alpha;), f x = y &amp;#38;and; mem x l.
    &amp;#60;/code&amp;#62;&amp;#60;/pre&amp;#62;
    &amp;#60;b&amp;#62;Proof:&amp;#60;/b&amp;#62;&amp;#60;br/&amp;#62;
    &amp;#60;ul&amp;#62;

      &amp;#60;li&amp;#62;We first treat the forward implication
        &amp;#60;pre&amp;#62;
          &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;
    &amp;#38;forall; (f : &amp;#38;alpha; &amp;#38;rarr; &amp;#38;beta;) (l : &amp;#38;alpha; list) (y : &amp;#38;beta;),
      mem y (map f l) &amp;#38;Implies; &amp;#38;exist;(x : &amp;#38;alpha;), f x = y &amp;#38;and; mem x l
        &amp;#60;/code&amp;#62;&amp;#60;/pre&amp;#62;
        and proceed by induction on &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;l&amp;#60;/code&amp;#62;.
        &amp;#60;br/&amp;#62;
        &amp;#60;br/&amp;#62;

        &amp;#60;ul&amp;#62;
          &amp;#60;li&amp;#62;&amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;l = []&amp;#60;/code&amp;#62;:
            &amp;#60;ul&amp;#62;
              &amp;#60;li&amp;#62;Show &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;mem y (map f []) &amp;#38;Implies; &amp;#38;exist;(x : &amp;#38;alpha;), f x = y &amp;#38;and; mem x []&amp;#60;/code&amp;#62;.&amp;#60;/li&amp;#62;
              &amp;#60;li&amp;#62;&amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;mem y (map f []) &amp;#38;equiv; False&amp;#60;/code&amp;#62;.&amp;#60;/li&amp;#62;
              &amp;#60;li&amp;#62;Proof follows &amp;#60;i&amp;#62;(ex falso quodlibet)&amp;#60;/i&amp;#62;.&amp;#60;/li&amp;#62;
            &amp;#60;/ul&amp;#62;
            &amp;#60;br/&amp;#62;
          &amp;#60;/li&amp;#62; &amp;#60;!-- l is empty --&amp;#62;

        &amp;#60;li&amp;#62;&amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;l&amp;#60;/code&amp;#62; has form &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;x' :: l&amp;#60;/code&amp;#62; (use &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;l&amp;#60;/code&amp;#62; now to refer to the tail):
            &amp;#60;ul&amp;#62;
              &amp;#60;li&amp;#62;Assume the induction hypothesis:
                &amp;#60;ul&amp;#62;&amp;#60;li&amp;#62;&amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;mem y (map f l) &amp;#38;Implies; &amp;#38;exist;x, f x = y &amp;#38;and; mem x l&amp;#60;/code&amp;#62;.&amp;#60;/li&amp;#62;&amp;#60;/ul&amp;#62;&amp;#60;/li&amp;#62;
              &amp;#60;li&amp;#62;We are required to show for an arbitrary &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;(x' : &amp;#38;alpha;)&amp;#60;/code&amp;#62;:
                &amp;#60;ul&amp;#62;&amp;#60;li&amp;#62;&amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;mem y (map f (x' :: l)) &amp;#38;Implies; &amp;#38;exist;(x : &amp;#38;alpha;), f x = y &amp;#38;and; mem x (x' :: l)&amp;#60;/code&amp;#62;.&amp;#60;/li&amp;#62;&amp;#60;/ul&amp;#62;
              &amp;#60;/li&amp;#62;
              &amp;#60;li&amp;#62;By simplification, we can rewrite the above to:
                &amp;#60;ul&amp;#62;&amp;#60;li&amp;#62;&amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;f x' = y &amp;#38;or; mem y (map f l) &amp;#38;Implies; &amp;#38;exist;(x : &amp;#38;alpha;), f x = y &amp;#38;and; (x' = x &amp;#38;or; mem x l).&amp;#60;/code&amp;#62;&amp;#60;/li&amp;#62;&amp;#60;/ul&amp;#62;
              &amp;#60;/li&amp;#62;
              &amp;#60;li&amp;#62;We assume then an &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;(x' : &amp;#38;alpha;)&amp;#60;/code&amp;#62; and a &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;(y : &amp;#38;beta;)&amp;#60;/code&amp;#62; such
                that:
                &amp;#60;ol&amp;#62;
                  &amp;#60;li&amp;#62;&amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;f x' = y &amp;#38;or; mem y (map f l)&amp;#60;/code&amp;#62;.&amp;#60;/li&amp;#62;
                  &amp;#60;li&amp;#62;&amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;mem y (map f l) &amp;#38;Implies; &amp;#38;exist;(x : &amp;#38;alpha;), f x = y &amp;#38;and; mem x l&amp;#60;/code&amp;#62;.&amp;#60;/li&amp;#62;
                &amp;#60;/ol&amp;#62;
              &amp;#60;/li&amp;#62;
              &amp;#60;li&amp;#62;Show &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;&amp;#38;exist;(x : &amp;#38;alpha;), f x = y &amp;#38;and; (x' = x &amp;#38;or; mem x l)&amp;#60;/code&amp;#62;:
                &amp;#60;ul&amp;#62;
                  &amp;#60;li&amp;#62;First consider &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;f x' = y&amp;#60;/code&amp;#62; in (1).
                    &amp;#60;ul&amp;#62;
                      &amp;#60;li&amp;#62;Take &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;x = x'&amp;#60;/code&amp;#62; in the goal.&amp;#60;/li&amp;#62;
                      &amp;#60;li&amp;#62;Then by (1) &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;f x = y &amp;#38;and; x = x'&amp;#60;/code&amp;#62;.&amp;#60;/li&amp;#62;
                      &amp;#60;li&amp;#62;So &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;x'&amp;#60;/code&amp;#62; is a witness.&amp;#60;/li&amp;#62;
                    &amp;#60;/ul&amp;#62;
                  &amp;#60;/li&amp;#62;
                  &amp;#60;li&amp;#62;Now consider &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;mem y (map f l)&amp;#60;/code&amp;#62; in (1).
                    &amp;#60;ul&amp;#62;
                      &amp;#60;li&amp;#62;&amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;&amp;#38;exist;(x&amp;#60;sup&amp;#62;*&amp;#60;/sup&amp;#62; : &amp;#38;alpha;), f x&amp;#60;sup&amp;#62;*&amp;#60;/sup&amp;#62; = y &amp;#38;and; mem x&amp;#60;sup&amp;#62;*&amp;#60;/sup&amp;#62; l&amp;#60;/code&amp;#62; by (2).&amp;#60;/li&amp;#62;
                      &amp;#60;li&amp;#62;Take &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;x = x&amp;#60;sup&amp;#62;*&amp;#60;/sup&amp;#62;&amp;#60;/code&amp;#62; in the goal.&amp;#60;/li&amp;#62;
                      &amp;#60;li&amp;#62;By the above &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;f x&amp;#60;sup&amp;#62;*&amp;#60;/sup&amp;#62; = y &amp;#38;and; mem x&amp;#60;sup&amp;#62;*&amp;#60;/sup&amp;#62; l&amp;#60;/code&amp;#62;&amp;#60;/li&amp;#62;
                      &amp;#60;li&amp;#62;So &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;x&amp;#60;sup&amp;#62;*&amp;#60;/sup&amp;#62;&amp;#60;/code&amp;#62; is a witness&amp;#60;/code&amp;#62;.&amp;#60;/li&amp;#62;
                    &amp;#60;/ul&amp;#62;
                  &amp;#60;/li&amp;#62;
                &amp;#60;/ul&amp;#62;
              &amp;#60;/li&amp;#62;
            &amp;#60;/ul&amp;#62;
          &amp;#60;/li&amp;#62; &amp;#60;!-- l is non-empty --&amp;#62;
        &amp;#60;/ul&amp;#62;
        &amp;#60;br/&amp;#62;&amp;#60;/br&amp;#62;
      &amp;#60;/li&amp;#62;&amp;#60;!-- Forward implication --&amp;#62;

      &amp;#60;li&amp;#62;
      We now work on the reverse implication. We want to show that
      &amp;#60;pre&amp;#62;&amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;
    &amp;#38;forall; (f : &amp;#38;alpha; &amp;#38;rarr; &amp;#38;beta;) (l : &amp;#38;alpha; list) (y : &amp;#38;beta;),
       &amp;#38;exist;(x : &amp;#38;alpha;), f x = y &amp;#38;and; mem x l &amp;#38;Implies; mem y (map f l)
      &amp;#60;/code&amp;#62;&amp;#60;/pre&amp;#62;
      and proceed by induction on &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;l&amp;#60;/code&amp;#62;.
      &amp;#60;br/&amp;#62;&amp;#60;br/&amp;#62;
      &amp;#60;ul&amp;#62;
        &amp;#60;li&amp;#62;&amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;l = []&amp;#60;/code&amp;#62;:
        &amp;#60;ul&amp;#62;
          &amp;#60;li&amp;#62;Assume &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;x&amp;#60;/code&amp;#62;, &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;y&amp;#60;/code&amp;#62; with &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;f x = y &amp;#38;and; mem x []&amp;#60;/code&amp;#62;.&amp;#60;/li&amp;#62;
          &amp;#60;li&amp;#62;Show &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;mem y (map f [])&amp;#60;/code&amp;#62;:&amp;#60;/li&amp;#62;
           &amp;#60;ul&amp;#62;
             &amp;#60;li&amp;#62;&amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;mem x [] &amp;#38;equiv; false&amp;#60;/code&amp;#62;.&amp;#60;/li&amp;#62;
             &amp;#60;li&amp;#62;Proof follows &amp;#60;i&amp;#62;(ex falso quodlibet)&amp;#60;/i&amp;#62;.&amp;#60;/li&amp;#62;
           &amp;#60;/ul&amp;#62;
        &amp;#60;/ul&amp;#62;
        &amp;#60;/li&amp;#62;&amp;#60;!-- l = [] --&amp;#62;

        &amp;#60;li&amp;#62;&amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;l&amp;#60;/code&amp;#62; has form &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;x' :: l&amp;#60;/code&amp;#62; (use &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;l&amp;#60;/code&amp;#62; now to refer to the tail):
          &amp;#60;ul&amp;#62;
            &amp;#60;li&amp;#62;Assume the induction hypothesis:
            &amp;#60;ul&amp;#62;&amp;#60;li&amp;#62;&amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;&amp;#38;exist;(x : &amp;#38;alpha;), f x = y &amp;#38;and; mem x l &amp;#38;Implies; mem y (map f l)&amp;#60;/code&amp;#62;.&amp;#60;/li&amp;#62;&amp;#60;/ul&amp;#62;
            &amp;#60;/li&amp;#62;
            &amp;#60;li&amp;#62;We are required to show for an arbitrary &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;(x' : &amp;#38;alpha;)&amp;#60;/code&amp;#62;:
              &amp;#60;ul&amp;#62;&amp;#60;li&amp;#62;&amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;&amp;#38;exist; (x : &amp;#38;alpha;), f x = y &amp;#38;and; mem x (x' :: l) &amp;#38;Implies; mem y (map f (x' :: l))&amp;#60;/code&amp;#62;&amp;#60;/li&amp;#62;&amp;#60;/ul&amp;#62;
            &amp;#60;/li&amp;#62;
            &amp;#60;li&amp;#62;By simplification, we can rewrite the above to:
              &amp;#60;ul&amp;#62;&amp;#60;li&amp;#62;&amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;&amp;#38;exist; (x : &amp;#38;alpha;), f x = y &amp;#38;and; x = x' &amp;#38;or; mem x l &amp;#38;Implies; f x' = y &amp;#38;or; mem y (map f l)&amp;#60;/code&amp;#62;.&amp;#60;/li&amp;#62;&amp;#60;/ul&amp;#62;
            &amp;#60;/li&amp;#62;
            &amp;#60;li&amp;#62;Assume the goal and induction hypotheses:
              &amp;#60;ul&amp;#62;
                &amp;#60;li&amp;#62;There is &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;(x : &amp;#38;alpha;)&amp;#60;/code&amp;#62; and &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;(y : &amp;#38;beta;)&amp;#60;/code&amp;#62; such that:
                  &amp;#60;ol&amp;#62;
                    &amp;#60;li&amp;#62;&amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;f x = y &amp;#38;and; (x = x' &amp;#38;or; mem x l)&amp;#60;/code&amp;#62;&amp;#60;/li&amp;#62;
                    &amp;#60;li&amp;#62;&amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;f x = y &amp;#38;and; mem x l &amp;#38;Implies; mem y (map f l)&amp;#60;/code&amp;#62;&amp;#60;/li&amp;#62;
                  &amp;#60;/ol&amp;#62;
                &amp;#60;/li&amp;#62;
              &amp;#60;/ul&amp;#62;
            &amp;#60;/li&amp;#62;
            &amp;#60;li&amp;#62;Show &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;f x' = y &amp;#38;or; mem y (map f l)&amp;#60;/code&amp;#62;:
              &amp;#60;ul&amp;#62;
                &amp;#60;li&amp;#62;Assume &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;x = x'&amp;#60;/code&amp;#62; in (1) and show &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;f x' = y&amp;#60;/code&amp;#62;:
                  &amp;#60;ul&amp;#62;
                   &amp;#60;li&amp;#62;Since, &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;f x = y&amp;#60;/code&amp;#62; is given by (1.), &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;f x' = y&amp;#60;/code&amp;#62;.&amp;#60;/li&amp;#62;
                  &amp;#60;/ul&amp;#62;
                &amp;#60;/li&amp;#62;
                &amp;#60;li&amp;#62;Assume &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;mem x l&amp;#60;/code&amp;#62; in (1) and show &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;mem y (map f l)&amp;#60;/code&amp;#62;:
                  &amp;#60;ul&amp;#62;
                    &amp;#60;li&amp;#62;Rewrite &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;mem y (map f l)&amp;#60;/code&amp;#62; via (2) to &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;f x = y &amp;#38;and; mem x l&amp;#60;/code&amp;#62;.&amp;#60;/li&amp;#62;
                    &amp;#60;li&amp;#62;&amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;f x = y&amp;#60;/code&amp;#62; by (1) so &amp;#60;code class=&amp;#34;code&amp;#34;&amp;#62;mem y (map f l)&amp;#60;/code&amp;#62;.&amp;#60;/li&amp;#62;
                  &amp;#60;/ul&amp;#62;
                &amp;#60;/li&amp;#62;
              &amp;#60;/ul&amp;#62;
            &amp;#60;/li&amp;#62;
          &amp;#60;/ul&amp;#62;
        &amp;#60;/li&amp;#62;&amp;#60;!-- l is non-empty --&amp;#62;
      &amp;#60;/ul&amp;#62;
      &amp;#60;/li&amp;#62;&amp;#60;!-- Reverse implication --&amp;#62;
    &amp;#60;/ul&amp;#62;
&amp;#38;#8718;
    &amp;#60;hr/&amp;#62;
    &amp;#60;p&amp;#62;
    References:&amp;#60;br/&amp;#62;
    &amp;#60;a href=&amp;#34;https://www.cis.upenn.edu/~bcpierce/sf/current/index.html&amp;#34;&amp;#62;&amp;#34;Sofware Foundations&amp;#34;&amp;#60;/a&amp;#62; -- Pierce et. al.
    &amp;#60;/p&amp;#62;
  &amp;#60;/body&amp;#62;
&amp;#60;/html&amp;#62;

