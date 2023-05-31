---
title: Managing and Analyzing Big-Data in Genomics
description: Abstract Biology is an increasingly computational discipline. Rapid advances
  in experimental techniques, especially DNA sequencing, are generating data at exponentially
  increasing rates. Aside from...
url: http://ashishagarwal.org/2012/06/29/ibm-pl-day/
date: 2012-06-29T17:18:00-00:00
preview_image: https://s0.wp.com/i/blank.jpg
featured:
authors:
- ashishagarwal
---

<p><strong>Abstract</strong></p>
<blockquote><p>Biology is an increasingly computational discipline. Rapid advances in experimental techniques, especially DNA sequencing, are generating data at exponentially increasing rates. Aside from the algorithmic challenges this poses, researchers must manage large volumes and innumerable varieties of data, run computational jobs on an HPC cluster, and track the inputs/outputs of the numerous computational tools they employ. Here we describe a software stack fully implemented in OCaml that operates the Genomics Core Facility at NYU&rsquo;s Center for Genomics and Systems Biology.</p>
<p>We define a domain specific language (DSL) that allows us to easily describe the data we need to track. More importantly, the DSL approach provides us with code generation capabilities. From a single description, we generate PostgreSQL schema definitions, OCaml bindings to the database, and web pages and forms for end-users to interact with the database. Strong type safety is provided at each stage. Database bindings check properties not expressible in SQL, and web pages, forms, and links are validated at compile time by the Ocsigen framework. Since the entire stack depends on this single data description, rapid updates are easy; the compiler informs us of all necessary changes.</p>
<p>The application launches compute intensive jobs on a high-performance compute (HPC) cluster, requiring consideration of concurrency and fault-tolerance. We have implemented what we call a &ldquo;flow&rdquo; monad that combines error and thread monads. Errors are modeled with polymorphic variants, which get arranged automatically into a hierarchical structure from lower level system calls to high level functions. The net result is extremely precise information in the case of any failures and reasonably straightforward concurrency management.</p></blockquote>
<p><a href="http://ashishagarwal.org/wp-content/uploads/2012/06/IBM_PL_Day_2012.pdf" class="pdf">Download slides</a></p>
<p><strong>Citation</strong><br/>
Sebastien Mondet, Ashish Agarwal, Paul Scheid, Aviv Madar, Richard Bonneau, Jane Carlton, Kristin C. Gunsalus. Managing and Analyzing Big-Data in Genomics. <em><a href="http://researcher.watson.ibm.com/researcher/view_project.php?id=3198">IBM Programming Languages Day 2012</a></em>, Hawthorne, NY, June 28, 2012.</p>

