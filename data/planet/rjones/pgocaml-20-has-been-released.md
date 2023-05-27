---
title: "PG\u2019OCaml 2.0 has been released"
description: "PG\u2019OCaml is a type-safe macro binding to PostgreSQL from OCaml
  that I wrote many moons ago. You can write code like: let hostid = 33 in let name
  = \u201Cjohn.smith\u201D in let rows = PGSQL\u2026"
url: https://rwmj.wordpress.com/2014/05/28/pgocaml-2-0-has-been-released/
date: 2014-05-28T16:57:56-00:00
preview_image: https://s0.wp.com/i/blank.jpg
featured:
authors:
- rjones
---

<p><a href="http://pgocaml.forge.ocamlcore.org/">PG&rsquo;OCaml</a> is a type-safe macro binding to PostgreSQL from OCaml that I wrote many moons ago.</p>
<p>You can write code like:</p>
<pre>
let hostid = 33 in
let name = &quot;john.smith&quot; in
let rows = PGSQL(dbh)
    &quot;select id, subject from contacts
     where hostid = $hostid and name = $name&quot;
</pre>
<p>and the compiler checks (at compile time) that <code>hostid</code> and <code>name</code> have the correct types in the program to match the database schema.  And it&rsquo;ll ensure that the type of <code>rows</code> is something like <code>(int * string) list</code>, and integrate that with type inference in the rest of the program.</p>
<p>The program won&rsquo;t compile if you use the wrong types.  It integrates OCaml&rsquo;s type safety and type inference with the PostgreSQL database engine.</p>
<p>It also avoids SQL injection by automatically creating a safe prepared statement.  What is executed when the program runs will have: <code>... where hostid = ? and name = ?</code>.</p>
<p>As a side-effect of the type checking, it also verifies that the SQL code is syntactically correct.</p>

