---
title: Preprocessor extensions for code generation
description: PPX          Preprocessor extensions for code generation    "A Guide
  to Extension Points in OCaml"[1] provides a great   "quic...
url: http://blog.shaynefletcher.org/2017/05/preprocessor-extensions-for-code.html
date: 2017-05-04T20:27:00-00:00
preview_image:
featured:
authors:
- Shayne Fletcher
---


<html>
  <head>
    
    <title>PPX</title>
  </head>
  <body>
  <h2>Preprocessor extensions for code generation</h2>
  <p>&quot;A Guide to Extension Points in OCaml&quot;[1] provides a great
  &quot;quick-start&quot; on using the OCaml extension points API to implement
  preprocessor extensions for abstract syntax tree rewrites. This post
  picks up where that tutorial leaves off by showing how to write a
  ppx that does code generation.
  </p>
  <p>The problem treated here is one posed in Whitequark's blog :
  &quot;Implement a syntax extension that would accept type declarations of
  the form 
  <code class="code">type t = A [@id 1] | B of int [@id 4] [@@id_of]</code> 
  to generate a function mapping a value of type <code class="code">t</code> to its
  integer representation.&quot;
  </p>

  <h2>Implementing the &quot;<code class="code">id_of</code>&quot; ppx</h2>

  <h3>The basic strategy</h3>
  <p>In the OCaml parse tree, structures are lists of structure
  items. Type declarations are structure items as are let-bindings to
  functions.
  </p>
  <p>In this program, analysis of an inductive type declaration <code class="code">t</code> 
  may result in the production of a new structure item, the AST of an <code class="code">of_id</code> function
  to be appended to the structure containing <code class="code">t</code>.
  </p>
  <p>Now the general strategy in writing a ppx is to provide a record
  of type <code class="code">Ast_mapper.mapper</code>. That record is based on
  the <code class="code">Ast_mapper.default_mapper</code> record but selectively
  overriding those fields for those sytactic categories that the ppx
  is intending to transform.
  </p>
  <p>Now, as we determined above, the effect of the ppx is to provide
  a function from a structure to a new structure. Accordingly, at a
  minimum then we'll want to override the <code class="code">structure</code> field
  of the default mapper. Schematically then our ppx code will take on
  the following shape.
  </p><pre><code class="code"><span class="keyword">open</span> <span class="constructor">Ast_mapper</span>
<span class="keyword">open</span> <span class="constructor">Ast_helper</span>
<span class="keyword">open</span> <span class="constructor">Asttypes</span>
<span class="keyword">open</span> <span class="constructor">Parsetree</span>
<span class="keyword">open</span> <span class="constructor">Longident</span>

<span class="keyword">let</span> structure_mapper mapper structure =
  ...

 <span class="keyword">let</span> id_of_mapper =  {
   default_mapper <span class="keyword">with</span> structure = structure_mapper
}

<span class="keyword">let</span> () = register <span class="string">&quot;id_of&quot;</span> id_of_mapper</code></pre>
  <p>
  This program goes just a little bit further
  though. Any <code class="code">@id</code> or <code class="code">@@id_of</code> attributes that
  get as far as the OCaml compiler would be ignored. So, it's not
  neccessary that they be removed by our ppx once they've been acted
  upon but it seems tidy to do so. Accordingly, there are two more
  syntactic constructs that this ppx operates on.
  </p><pre><code class="code"><span class="keyword">open</span> <span class="constructor">Ast_mapper</span>
<span class="keyword">open</span> <span class="constructor">Ast_helper</span>
<span class="keyword">open</span> <span class="constructor">Asttypes</span>
<span class="keyword">open</span> <span class="constructor">Parsetree</span>
<span class="keyword">open</span> <span class="constructor">Longident</span>

<span class="keyword">let</span> structure_mapper mapper structure =
  ...

<span class="keyword">let</span> type_declaration_mapper mapper decl =
  ...

<span class="keyword">let</span> constructor_declaration_mapper mapper decl =
  ...

<span class="keyword">let</span> id_of_mapper argv = {
  default_mapper <span class="keyword">with</span>
    structure = structure_mapper;
    type_declaration = type_declaration_mapper;
    constructor_declaration = constructor_declaration_mapper
}</code></pre>
  
  <h3>Implementing the mappings</h3>
  <p>To warm up, lets start with the easy mappers.</p>
  <p>The role of <code class="code">type_declaration_mapper</code> is a function
  from a <code class="code">type_declaration</code> argument to
  a <code class="code">type_declaration</code> result that is the argument in all
  but that any <code class="code">@@id_of</code> attribute has been removed.
  </p><pre><code class="code"><span class="keyword">let</span> type_declaration_mapper
    (mapper : mapper)
    (decl : type_declaration) : type_declaration  =
  <span class="keyword">match</span> decl <span class="keyword">with</span>
    <span class="comment">(*Case of an inductive type &quot;t&quot;*)</span>
  <span class="keywordsign">|</span> {ptype_name = {txt = <span class="string">&quot;t&quot;</span>; _};
     ptype_kind = <span class="constructor">Ptype_variant</span> constructor_declarations;
     ptype_attributes;_} <span class="keywordsign">-&gt;</span>
    <span class="keyword">let</span> (_, attrs) =
      <span class="constructor">List</span>.partition (<span class="keyword">fun</span> ({txt;_},_) <span class="keywordsign">-&gt;</span>txt=<span class="string">&quot;id_of&quot;</span>) ptype_attributes <span class="keyword">in</span>
    {(default_mapper.type_declaration mapper decl)
    <span class="keyword">with</span> ptype_attributes=attrs}
  <span class="comment">(*Not an inductive type named &quot;t&quot;*)</span>
  <span class="keywordsign">|</span> _ <span class="keywordsign">-&gt;</span> default_mapper.type_declaration mapper decl</code></pre>
  <p><code class="code">constructor_declaration_mapper</code> is analogous
  to <code class="code">type_declaration_mapper</code> above but this time
  its <code class="code">@id</code> attributes that are removed.
  </p><pre><code class="code"><span class="keyword">let</span> constructor_declaration_mapper
    (mapper : mapper)
    (decl : constructor_declaration) : constructor_declaration =
  <span class="keyword">match</span> decl <span class="keyword">with</span>
  <span class="keywordsign">|</span> {pcd_name={loc; _}; pcd_attributes; _} <span class="keywordsign">-&gt;</span>
    <span class="keyword">let</span> (_, attrs) =
      <span class="constructor">List</span>.partition (<span class="keyword">fun</span> ({txt;_}, _) <span class="keywordsign">-&gt;</span> txt=<span class="string">&quot;id&quot;</span>) pcd_attributes  <span class="keyword">in</span>
    {(default_mapper.constructor_declaration mapper decl)
    <span class="keyword">with</span> pcd_attributes=attrs}</code></pre>
  <p>Now to the raison d'etre of the
  ppx, <code class="code">structure_mapper</code>. 
  </p>
  <p>First, a utility function that computes from
  a <code class="code">constructor_declaration</code> with an <code class="code">@id</code>
  attribute, a (function) <code class="code">case</code> for it. For example,
  suppose &quot;<code class="code">Bar of int [@id 4]</code>&quot; is the constructor
  declaration, then the <code class="code">case</code> to be computed is the AST
  corresponding to the code &quot;<code class="code">| Bar _ -&gt; 4</code>&quot;.
  </p><pre><code class="code">  <span class="keyword">let</span> case_of_constructor_declaration :
      constructor_declaration <span class="keywordsign">-&gt;</span> case =  <span class="keyword">function</span>
    <span class="keywordsign">|</span> {pcd_name={txt;loc};pcd_args;pcd_attributes; _} <span class="keywordsign">-&gt;</span>
      <span class="keyword">match</span> <span class="constructor">List</span>.filter (<span class="keyword">fun</span> ({txt;_}, _) <span class="keywordsign">-&gt;</span> txt=<span class="string">&quot;id&quot;</span>) pcd_attributes <span class="keyword">with</span>
      <span class="comment">(*No &quot;@id&quot;*)</span>
      <span class="keywordsign">|</span> [] <span class="keywordsign">-&gt;</span>
        raise (<span class="constructor">Location</span>.<span class="constructor">Error</span> (<span class="constructor">Location</span>.error ~loc <span class="string">&quot;[@id] : Missing&quot;</span>))
      <span class="comment">(*Single &quot;@id&quot;*)</span>
      <span class="keywordsign">|</span> [(_, payload)] <span class="keywordsign">-&gt;</span>
        <span class="keyword">begin</span> <span class="keyword">match</span> payload <span class="keyword">with</span>
          <span class="keywordsign">|</span> <span class="constructor">PStr</span> [{pstr_desc=<span class="constructor">Pstr_eval</span> ({pexp_desc=
              <span class="constructor">Pexp_constant</span> (<span class="constructor">Pconst_integer</span> (id, <span class="constructor">None</span>)); _}, _)
            }] <span class="keywordsign">-&gt;</span>
            <span class="constructor">Exp</span>.case
              (<span class="constructor">Pat</span>.construct
                 {txt=<span class="constructor">Lident</span> txt; loc=(!default_loc)}
                 (<span class="keyword">match</span> pcd_args <span class="keyword">with</span>
                 <span class="keywordsign">|</span> <span class="constructor">Pcstr_tuple</span> [] <span class="keywordsign">-&gt;</span> <span class="constructor">None</span> <span class="keywordsign">|</span> _ <span class="keywordsign">-&gt;</span> <span class="constructor">Some</span> (<span class="constructor">Pat</span>.any ())))
              (<span class="constructor">Exp</span>.constant (<span class="constructor">Pconst_integer</span> (id, <span class="constructor">None</span>)))
          <span class="keywordsign">|</span> _ <span class="keywordsign">-&gt;</span>
            raise (<span class="constructor">Location</span>.<span class="constructor">Error</span> (<span class="constructor">Location</span>.error ~loc
            <span class="string">&quot;[@id] : Bad (or missing) argument (should be int e.g. [@id 4])&quot;</span>))
        <span class="keyword">end</span>
      <span class="comment">(*Many &quot;@id&quot;s*)</span>
      <span class="keywordsign">|</span> (_ :: _) <span class="keywordsign">-&gt;</span>
        raise (<span class="constructor">Location</span>.<span class="constructor">Error</span> (<span class="constructor">Location</span>.error ~loc
        <span class="string">&quot;[@id] : Multiple occurences&quot;</span>))</code></pre>
  <p>One more utility function is required.</p>
  <p><code class="code">eval_structure_item item acc</code> computes structure
  items to push on the front of <code class="code">acc</code>. If <code class="code">item</code>
  is a single declaration of an inductive type <code class="code">t</code>
  attributed with <code class="code">@@id_of</code>, then two structure items will
  be produced : one for <code class="code">t</code> and one synthesized
  for <code class="code">t</code>'s <code class="code">of_id</code> function. In all other
  cases, just one structure item will be pushed onto <code class="code">acc</code>.
  </p><pre><code class="code"><span class="keyword">let</span> eval_structure_item
    (mapper : mapper)
    (item : structure_item)
    (acc : structure) : structure =
  <span class="keyword">match</span> item <span class="keyword">with</span>
  <span class="comment">(*Case of a single inductive type declaration*)</span>
  <span class="keywordsign">|</span> { pstr_desc = <span class="constructor">Pstr_type</span> (_, [type_decl]); pstr_loc} <span class="keywordsign">-&gt;</span>
    <span class="keyword">begin</span>
      <span class="keyword">match</span> type_decl <span class="keyword">with</span>
      <span class="comment">(*Case where the type identifer is [t]*)</span>
      <span class="keywordsign">|</span> {ptype_name = {txt = <span class="string">&quot;t&quot;</span>; _};
         ptype_kind = <span class="constructor">Ptype_variant</span> constructor_declarations;
         ptype_attributes;
         _} <span class="keywordsign">-&gt;</span>
        <span class="keyword">begin</span>
          <span class="keyword">match</span> <span class="constructor">List</span>.filter (<span class="keyword">fun</span> ({txt;_},_) <span class="keywordsign">-&gt;</span>txt=<span class="string">&quot;id_of&quot;</span>)
            ptype_attributes
          <span class="keyword">with</span>
          <span class="comment">(*No [@@id_of]*)</span>
          <span class="keywordsign">|</span> [] <span class="keywordsign">-&gt;</span> default_mapper.structure_item mapper item :: acc

          <span class="comment">(*At least one [@@id_of] (treat multiple occurences as if
            one)*)</span>
          <span class="keywordsign">|</span> _ <span class="keywordsign">-&gt;</span>
            <span class="comment">(*Cases of an [id_of] function for [t], one for each
              of its constructors*)</span>
            <span class="keyword">let</span> cases=
              <span class="constructor">List</span>.fold_right
                (<span class="keyword">fun</span> x acc <span class="keywordsign">-&gt;</span>
                  case_of_constructor_declaration x :: acc)
                constructor_declarations [] <span class="keyword">in</span>
            <span class="comment">(*The [id_of] function itself*)</span>
            <span class="keyword">let</span> id_of : structure_item =
              <span class="constructor">Str</span>.value <span class="constructor">Nonrecursive</span> [
                <span class="constructor">Vb</span>.mk
                  (<span class="constructor">Pat</span>.var {txt=<span class="string">&quot;id_of&quot;</span>; loc=(!default_loc)})
                  (<span class="constructor">Exp</span>.function_ cases)] <span class="keyword">in</span>

            default_mapper.structure_item mapper item :: id_of :: acc
        <span class="keyword">end</span>
      <span class="comment">(*Case the type identifier is something other than [t]*)</span>
      <span class="keywordsign">|</span> _ <span class="keywordsign">-&gt;</span> default_mapper.structure_item mapper item :: acc
    <span class="keyword">end</span>
  <span class="comment">(*Case this structure item is something other than a single type
    declaration*)</span>
  <span class="keywordsign">|</span> _ <span class="keywordsign">-&gt;</span> default_mapper.structure_item mapper item :: acc</code></pre>
  
  <p>Finally we can write <code class="code">structure_mapper</code> itself as a
  simple fold over a structure.
  </p><pre><code class="code"><span class="keyword">let</span> structure_mapper
    (mapper : mapper)
    (structure : structure) : structure =
  <span class="constructor">List</span>.fold_right (eval_structure_item mapper)structure []</code></pre>
 <h3>Building and testing</h3>
  <p>So that's it, this preprocessor extension is complete. Assuming
  the code is contained in a file called <code class="code">ppx_id_of.ml</code> it
  can be compiled with a command along the lines of the following.
  </p><pre>ocamlc -o ppx_id_of.exe  -I +compiler-libs ocamlcommon.cma ppx_id_of.ml</pre>
  When built, it can be tested with a command like
  <code class="code"> ocamlc -dsource -ppx ppx_id_of.exe test.ml</code>.
  
  <p>
  For example, when invoked on the following program,
</p><pre><code class="code"><span class="keyword">type</span> t =
  <span class="keywordsign">|</span> <span class="constructor">A</span> [@id 2]
  <span class="keywordsign">|</span> <span class="constructor">B</span> <span class="keyword">of</span> int [@id 4] [@@id_of]

<span class="keyword">module</span> <span class="constructor">M</span> = <span class="keyword">struct</span>
  <span class="keyword">type</span> t =
  <span class="keywordsign">|</span> <span class="constructor">Foo</span> <span class="keyword">of</span> int [@id 42]
  <span class="keywordsign">|</span> <span class="constructor">Bar</span> [@id 43] [@@id_of]

  <span class="keyword">module</span> <span class="constructor">N</span> = <span class="keyword">struct</span>
     <span class="keyword">type</span> t =
     <span class="keywordsign">|</span> <span class="constructor">Baz</span> [@id 8]
     <span class="keywordsign">|</span> <span class="constructor">Quux</span> <span class="keyword">of</span> string * int [@id 7] [@@id_of]

    <span class="keyword">module</span> <span class="constructor">Q</span> = <span class="keyword">struct</span>
      <span class="keyword">type</span> t =
        <span class="keywordsign">|</span> <span class="constructor">U</span> [@id 0] [@@id_of]
    <span class="keyword">end</span>
  <span class="keyword">end</span>
<span class="keyword">end</span></code></pre>
  the resulting output is,
  <pre><code class="code"><span class="keyword">type</span> t =
  <span class="keywordsign">|</span> <span class="constructor">A</span>
  <span class="keywordsign">|</span> <span class="constructor">B</span> <span class="keyword">of</span> int
<span class="keyword">let</span> id_of = <span class="keyword">function</span> <span class="keywordsign">|</span> <span class="constructor">A</span>  <span class="keywordsign">-&gt;</span> 2 <span class="keywordsign">|</span> <span class="constructor">B</span> _ <span class="keywordsign">-&gt;</span> 4
<span class="keyword">module</span> <span class="constructor">M</span> =
  <span class="keyword">struct</span>
    <span class="keyword">type</span> t =
      <span class="keywordsign">|</span> <span class="constructor">Foo</span> <span class="keyword">of</span> int
      <span class="keywordsign">|</span> <span class="constructor">Bar</span>
    <span class="keyword">let</span> id_of = <span class="keyword">function</span> <span class="keywordsign">|</span> <span class="constructor">Foo</span> _ <span class="keywordsign">-&gt;</span> 42 <span class="keywordsign">|</span> <span class="constructor">Bar</span>  <span class="keywordsign">-&gt;</span> 43
    <span class="keyword">module</span> <span class="constructor">N</span> =
      <span class="keyword">struct</span>
        <span class="keyword">type</span> t =
          <span class="keywordsign">|</span> <span class="constructor">Baz</span>
          <span class="keywordsign">|</span> <span class="constructor">Quux</span> <span class="keyword">of</span> string * int
        <span class="keyword">let</span> id_of = <span class="keyword">function</span> <span class="keywordsign">|</span> <span class="constructor">Baz</span>  <span class="keywordsign">-&gt;</span> 8 <span class="keywordsign">|</span> <span class="constructor">Quux</span> _ <span class="keywordsign">-&gt;</span> 7
        <span class="keyword">module</span> <span class="constructor">Q</span> = <span class="keyword">struct</span> <span class="keyword">type</span> t =
                            <span class="keywordsign">|</span> <span class="constructor">U</span>
                          <span class="keyword">let</span> id_of = <span class="keyword">function</span> <span class="keywordsign">|</span> <span class="constructor">U</span>  <span class="keywordsign">-&gt;</span> 0  <span class="keyword">end</span>
      <span class="keyword">end</span>
  <span class="keyword">end</span></code></pre>
  
  <hr/>
  <p>
    References:<br/>
     [1] <a href="https://whitequark.org/blog/2014/04/16/a-guide-to-extension-points-in-ocaml/">&quot;A
     Guide to Extension Points in OCaml&quot; -- Whitequark (blog post
     2014)</a>
  </p>
  </body>
</html>



