---
title: Database - radiation hazard
description: Now that I've shat on mutability in prior posts, let's talk about how
  it pervades my game code.   I'm a fan of the component model for gam...
url: https://cranialburnout.blogspot.com/2013/09/database-radiation-hazard.html
date: 2013-09-12T07:39:00-00:00
preview_image: //4.bp.blogspot.com/-AaVcyyAosxU/UjFRnhc-zHI/AAAAAAAAADE/3XI_Ien7VWg/w1200-h630-p-k-no-nu/inherit.png
featured:
authors:
- Tony Tavener
---

<div dir="ltr" style="text-align: left;" trbidi="on">
<br/>
Now that I've shat on mutability in prior posts, let's talk about how it pervades my game code.<br/>
<br/>
I'm a fan of the component model for game-objects. Basically, an object is a unique ID, and there is a database of properties associated to IDs. This isn't a disk-based database. Rather, it's an in-memory key-value store, often implemented by hashtable (though anything fitting the <code>STORE</code> signature can be provided).<br/>
<br/>
This database is where most mutation is, hence the title of this post. So far this has been a nice fusion &mdash; functional code for the most part, with game-state held in a database. Updating/setting values in the database is typically done by high-level code, based on calculations performed by all the workhorse functions.<br/>
<br/>
<br/>
<b><u>Components (a.k.a. properties)</u></b><br/>
<br/>
Here's a character (pruned for brevity):<br/>
<br/>
<pre>  <span class="Keyword">let</span> make_severin <span class="Constant">()</span> <span class="Keyword">=</span>
    <span class="Include">Db</span>.get_id_by_name <span class="String">&quot;Severin&quot;</span>
    <span class="Operator">|&gt;</span> <span class="Include">Characteristics</span>.s <span class="Structure">{</span>int<span class="Keyword">=</span><span class="Float">3</span><span class="Keyword">;</span>per<span class="Keyword">=</span><span class="Float">0</span><span class="Keyword">;</span>str<span class="Keyword">=</span><span class="Float">0</span><span class="Keyword">;</span>sta<span class="Keyword">=</span><span class="Float">1</span><span class="Keyword">;</span>pre<span class="Keyword">=</span><span class="Float">0</span><span class="Keyword">;</span>com<span class="Keyword">=</span><span class="Float">0</span><span class="Keyword">;</span>dex<span class="Keyword">=</span><span class="Float">0</span><span class="Keyword">;</span>qik<span class="Keyword">=</span><span class="Float">0</span><span class="Structure">}</span>
    <span class="Operator">|&gt;</span> <span class="Include">Size</span>.s <span class="Float">0</span>
    <span class="Operator">|&gt;</span> <span class="Include">Age</span>.s <span class="Delimiter">(</span><span class="Float">62</span>,<span class="Float">35</span><span class="Delimiter">)</span>
    <span class="Operator">|&gt;</span> <span class="Include">Confidence</span>.s <span class="Delimiter">(</span><span class="Float">2</span>,<span class="Float">5</span><span class="Delimiter">)</span>
    <span class="Operator">|&gt;</span> <span class="Include">Nature</span>.<span class="Delimiter">(</span>s human<span class="Delimiter">)</span>
    <span class="Operator">|&gt;</span> <span class="Include">Fatigue</span>.<span class="Include">Levels</span>.<span class="Delimiter">(</span>s standard<span class="Delimiter">)</span>
    <span class="Operator">|&gt;</span> <span class="Include">Virtue</span>.<span class="Delimiter">(</span>s <span class="Type">[</span>
        <span class="Constant">TheGift</span><span class="Keyword">;</span>
        <span class="Constant">HermeticMagus</span><span class="Keyword">;</span>
        <span class="Constant">PlaguedBySupernaturalEntity</span><span class="Delimiter">(</span> <span class="Include">Db</span>.get_id_by_name <span class="String">&quot;Peripeteia&quot;</span> <span class="Delimiter">)</span><span class="Keyword">;</span>
        <span class="Type">]</span><span class="Delimiter">)</span>
    <span class="Operator">|&gt;</span> <span class="Include">Ability</span>.<span class="Delimiter">(</span>s <span class="Type">[</span>
        of_score <span class="Constant">ArtesLiberales</span> <span class="Float">1</span> <span class="String">&quot;geometry&quot;</span><span class="Keyword">;</span>
        of_score <span class="Constant">Chirurgy</span> <span class="Float">2</span> <span class="String">&quot;self&quot;</span><span class="Keyword">;</span>
        of_score <span class="Delimiter">(</span><span class="Constant">AreaLore</span><span class="Delimiter">(</span><span class="String">&quot;Fallen Covenant&quot;</span><span class="Delimiter">))</span> <span class="Float">3</span> <span class="String">&quot;defences&quot;</span><span class="Keyword">;</span>
        of_score <span class="Constant">MagicTheory</span> <span class="Float">5</span> <span class="String">&quot;shapeshifting&quot;</span><span class="Keyword">;</span>
        of_score <span class="Delimiter">(</span><span class="Constant">Language</span><span class="Delimiter">(</span><span class="Constant">French</span><span class="Delimiter">))</span> <span class="Float">5</span> <span class="String">&quot;grogs&quot;</span><span class="Keyword">;</span>
        of_score <span class="Constant">ParmaMagica</span> <span class="Float">5</span> <span class="String">&quot;Terram&quot;</span><span class="Keyword">;</span>
        of_score <span class="Constant">SingleWeapon</span> <span class="Float">3</span> <span class="String">&quot;Staff&quot;</span><span class="Keyword">;</span>
        of_score <span class="Constant">Survival</span> <span class="Float">3</span> <span class="String">&quot;desert&quot;</span><span class="Keyword">;</span>
        <span class="Type">]</span><span class="Delimiter">)</span>
    <span class="Operator">|&gt;</span> <span class="Include">Hermetic</span>.<span class="Include">House</span>.<span class="Delimiter">(</span>s <span class="Constant">Tytalus</span><span class="Delimiter">)</span>
    <span class="Operator">|&gt;</span> <span class="Include">Hermetic</span>.<span class="Include">Arts</span>.<span class="Delimiter">(</span>s <span class="Delimiter">(</span>of_score <span class="Structure">{</span> cr<span class="Keyword">=</span><span class="Float">8</span><span class="Keyword">;</span> it<span class="Keyword">=</span><span class="Float">0</span><span class="Keyword">;</span> mu<span class="Keyword">=</span><span class="Float">6</span><span class="Keyword">;</span> pe<span class="Keyword">=</span><span class="Float">6</span><span class="Keyword">;</span> re<span class="Keyword">=</span><span class="Float">20</span>
                                  <span class="Keyword">;</span> an<span class="Keyword">=</span><span class="Float">0</span><span class="Keyword">;</span> aq<span class="Keyword">=</span><span class="Float">0</span><span class="Keyword">;</span> au<span class="Keyword">=</span><span class="Float">0</span><span class="Keyword">;</span> co<span class="Keyword">=</span><span class="Float">6</span><span class="Keyword">;</span> he<span class="Keyword">=</span><span class="Float">15</span>
                                  <span class="Keyword">;</span> ig<span class="Keyword">=</span><span class="Float">0</span><span class="Keyword">;</span> im<span class="Keyword">=</span><span class="Float">0</span><span class="Keyword">;</span> me<span class="Keyword">=</span><span class="Float">0</span><span class="Keyword">;</span> te<span class="Keyword">=</span><span class="Float">8</span><span class="Keyword">;</span> vi<span class="Keyword">=</span><span class="Float">0</span> <span class="Structure">}</span><span class="Delimiter">))</span>
    <span class="Operator">|&gt;</span> <span class="Include">Hermetic</span>.<span class="Include">KnownSpells</span>.s <span class="Type">[</span>
        <span class="Include">Spell</span>.mastery <span class="Float">4</span> <span class="String">&quot;Acorns for Amusement&quot;</span>
          <span class="Include">Hermetic</span>.<span class="Delimiter">(</span><span class="Type">[</span><span class="Constant">FastCasting</span><span class="Keyword">;</span><span class="Constant">MultipleCasting</span><span class="Keyword">;</span><span class="Constant">QuietCasting</span><span class="Keyword">;</span><span class="Constant">StillCasting</span><span class="Type">]</span><span class="Delimiter">)</span><span class="Keyword">;</span>
        <span class="Include">Spell</span>.name <span class="String">&quot;Carved Assassin&quot;</span><span class="Keyword">;</span>
        <span class="Include">Spell</span>.name <span class="String">&quot;Wall of Thorns&quot;</span><span class="Keyword">;</span>
        <span class="Include">Spell</span>.name <span class="String">&quot;Circular Ward Against Demons&quot;</span><span class="Keyword">;</span>
        <span class="Type">]</span>
    <span class="Operator">|&gt;</span> equip_and_inv <span class="Type">[</span><span class="String">&quot;Wizardly Robes&quot;</span><span class="Keyword">;</span><span class="String">&quot;Staff&quot;</span><span class="Type">]</span> <span class="Type">[</span><span class="String">&quot;Small Pouch&quot;</span><span class="Type">]</span>
</pre>
<br/>
Each of the modules here represents a component which objects may have. So Severin's Age is (62,35) &mdash; that is actual age and apparent age (Wizards age slowly).<br/>
<br/>
The function make_severin will return an ID. The first line <code>Db.get_id_by_name &quot;Severin&quot;</code> looks up an ID for that name, or generates a new ID if none exists. Each component module has a function &quot;s&quot;, which is the same as &quot;set&quot; except it returns the given ID. It's a convenience function for setting multiple component values at once for the same ID &mdash; which is exactly what's happening here, with Severin's ID being threaded through all of these property-setting calls.<br/>
<br/>
This is the signature common to all components:<br/>
<br/>
<pre>  <span class="Keyword">module type </span><span class="Include">Sig</span> = <span class="Include">sig</span>
    <span class="Keyword">type</span> t
    <span class="Keyword">val</span> get : key <span class="Function">-&gt;</span> t             <span class="Comment">(* get, obeying table's inheritance setting *)</span>
    <span class="Keyword">val</span> get_personal : key <span class="Function">-&gt;</span> t    <span class="Comment">(* ignore inheritance *)</span>
    <span class="Keyword">val</span> get_inheritable : key <span class="Function">-&gt;</span> t <span class="Comment">(* permit inheritance (overriding default) *)</span>
    <span class="Keyword">val</span> get_all : key <span class="Function">-&gt;</span> t <span class="Type">list</span>    <span class="Comment">(* for a stacked component *)</span>
    <span class="Keyword">val</span> set : key <span class="Function">-&gt;</span> t <span class="Function">-&gt;</span> <span class="Type">unit</span>     <span class="Comment">(* set value on key; stacking is possible *)</span>
    <span class="Keyword">val</span> s : t <span class="Function">-&gt;</span> key <span class="Function">-&gt;</span> key        <span class="Comment">(* set, but an alternate calling signature *)</span>
    <span class="Keyword">val</span> del : key <span class="Function">-&gt;</span> <span class="Type">unit</span>          <span class="Comment">(* delete this component from key *)</span>
    <span class="Keyword">val</span> iter : <span class="Delimiter">(</span>key <span class="Function">-&gt;</span> t <span class="Function">-&gt;</span> <span class="Type">unit</span><span class="Delimiter">)</span> <span class="Function">-&gt;</span> <span class="Type">unit</span>
    <span class="Keyword">val</span> fold : <span class="Delimiter">(</span>key <span class="Function">-&gt;</span> t <span class="Function">-&gt;</span> <span class="Identifier">'a</span> <span class="Function">-&gt;</span> <span class="Identifier">'a</span><span class="Delimiter">)</span> <span class="Function">-&gt;</span> <span class="Identifier">'a</span> <span class="Function">-&gt;</span> <span class="Identifier">'a</span>
  <span class="Include">end</span>
</pre>
<br/>
I've used first-class modules so I can unpack a table implementation inside a module, making it a &quot;component&quot;. For example, in the file hermetic.ml I have this:<br/>
<br/>
<pre>  <span class="Keyword">module</span><span class="Include"> House</span> <span class="Keyword">=</span> <span class="Include">struct</span>
    <span class="Keyword">type</span> s <span class="Keyword">=</span> <span class="Constant">Bjornaer</span> <span class="Operator">|</span> <span class="Constant">Bonisagus</span> <span class="Operator">|</span> <span class="Constant">Criamon</span>  <span class="Operator">|</span> <span class="Constant">ExMiscellanea</span>
           <span class="Operator">|</span> <span class="Constant">Flambeau</span> <span class="Operator">|</span> <span class="Constant">Guernicus</span> <span class="Operator">|</span> <span class="Constant">Jerbiton</span> <span class="Operator">|</span> <span class="Constant">Mercere</span>
           <span class="Operator">|</span> <span class="Constant">Merinita</span> <span class="Operator">|</span> <span class="Constant">Tremere</span>   <span class="Operator">|</span> <span class="Constant">Tytalus</span>  <span class="Operator">|</span> <span class="Constant">Verditius</span>
    <span class="Keyword">include</span> (<span class="Keyword">val</span> <span class="Delimiter">(</span><span class="Include">Db</span>.<span class="Include">Hashtbl</span>.create <span class="Constant">()</span><span class="Delimiter">)</span>: <span class="Include">Db.Sig</span> with type t = s)
  <span class="Include">end</span>
</pre>
<br/>
Now the Hermetic.House module has functions to set/get it's values by ID. In the definition of the character, earlier, you can see <code>Hermetic.House.(s Tytalus)</code>.<br/>
<br/>
<br/>
This manner of database, organized by modules, has been very pleasant to use. It's easy to create a new <i>component-module</i>, adding it's own types and extra functions. It doesn't need to be centrally defined unless other modules are genuinely dependent on it. In practice, I define these components where they make sense. There's no need to &quot;open&quot; modules, thanks to the relatively recent local-open syntax of: <code>Module.(in_module_scope)</code>. Variants and record-fields are neatly accessed while keeping them in their appropriate module.<br/>
<br/>
One of the rationales behind a component-model like this is that you can process or collect things by property. This is where the iter and fold are useful. It's easy to grab all entity IDs which have a Wound component (and is therefore able to be injured), for example.<br/>
<br/>
<br/>
<b><u>Database</u></b><br/>
<br/>
The database, conceptually, is the collection of components. In practice though, I want the components to be non-centrally declared otherwise all datatypes would be centralized as well &mdash; so instead, the database is ID management and table-instantiation functors.<br/>
<br/>
First, you create a database of a particular key type...<br/>
<br/>
<pre><span class="Comment">(* Gamewide 'Db' is based on IDs of type 'int' *)</span>
<span class="Keyword">module</span><span class="Include"> Db</span> <span class="Keyword">=</span> <span class="Include">Database.Make</span> (<span class="Include">Database.IntKey</span>)
</pre>
<br/>
The resulting signature has functions related to IDs, and table-instantiation, something like this (I've removed the generic table interfaces, for brevity):<br/>
<br/>
<pre>  <span class="Keyword">module</span><span class="Include"> Db</span> : <span class="Include">sig</span>
    <span class="Keyword">type</span> key <span class="Keyword">=</span> <span class="Include">Database</span>.<span class="Include">IntKey</span>.t

    <span class="Keyword">val</span> persistent_id : <span class="Type">unit</span> <span class="Function">-&gt;</span> key
    <span class="Keyword">val</span> transient_id : <span class="Type">unit</span> <span class="Function">-&gt;</span> key
    <span class="Keyword">val</span> find_id_by_name : <span class="Identifier">'a</span> <span class="Function">-&gt;</span> key
    <span class="Keyword">val</span> get_id_by_name : <span class="Type">string</span> <span class="Function">-&gt;</span> key
    <span class="Keyword">val</span> get_name : key <span class="Function">-&gt;</span> <span class="Type">string</span>
    <span class="Keyword">val</span> string_of_id : key <span class="Function">-&gt;</span> <span class="Type">string</span>
    <span class="Keyword">val</span> delete : key <span class="Function">-&gt;</span> <span class="Type">unit</span>
    <span class="Comment">(* &lt;snip&gt; module type Sig *)</span>

    <span class="Keyword">module</span> <span class="Include">Hashtbl</span> :<span class="Include"> sig</span>
      <span class="Keyword">val</span> create : <span class="Label">?</span><span class="Identifier">size</span>:<span class="Type">int</span> <span class="Function">-&gt;</span> <span class="Label">?</span><span class="Identifier">default</span>:<span class="Identifier">'a</span> <span class="Function">-&gt;</span> <span class="Label">?</span><span class="Identifier">nhrt</span>:<span class="Type">bool</span> <span class="Function">-&gt;</span> <span class="Type">unit</span> <span class="Function">-&gt;</span>
        <span class="Delimiter">(</span><span class="Keyword">module</span><span class="Include"> Sig</span> <span class="Keyword">with</span> <span class="Keyword">type</span> t <span class="Keyword">=</span> <span class="Identifier">'a</span><span class="Delimiter">)</span>
    <span class="Include">end</span>
    <span class="Keyword">module</span> <span class="Include">SingleInherit</span> :<span class="Include"> sig</span>
      <span class="Keyword">val</span> get_parent : key <span class="Function">-&gt;</span> key
      <span class="Keyword">val</span> set_parent : key <span class="Function">-&gt;</span> key <span class="Function">-&gt;</span> <span class="Type">unit</span>
      <span class="Keyword">val</span> del_parent : key <span class="Function">-&gt;</span> <span class="Type">unit</span>
      <span class="Comment">(* &lt;snip&gt; Hashtbl.create... *)</span>
    <span class="Include">end</span>
    <span class="Keyword">module</span> <span class="Include">MultiInherit</span> :<span class="Include"> sig</span>
      <span class="Keyword">val</span> get_parents : key <span class="Function">-&gt;</span> key <span class="Type">list</span>
      <span class="Keyword">val</span> set_parents : key <span class="Function">-&gt;</span> key <span class="Type">list</span> <span class="Function">-&gt;</span> <span class="Type">unit</span>
      <span class="Keyword">val</span> add_parents : key <span class="Function">-&gt;</span> key <span class="Type">list</span> <span class="Function">-&gt;</span> <span class="Type">unit</span>
      <span class="Keyword">val</span> del_parent : key <span class="Function">-&gt;</span> key <span class="Function">-&gt;</span> <span class="Type">unit</span>
      <span class="Comment">(* &lt;snip&gt; Hashtbl.create... *)</span>
    <span class="Include">end</span>
  <span class="Include">end</span>
</pre>
<br/>
Creating a component (aka table, or property) can be as simple as:<br/>
<br/>
<pre><span class="Comment">(* A basic property is just a table with an already-known type *)</span>
<span class="Keyword">module</span><span class="Include"> Size</span> <span class="Keyword">=</span> (<span class="Keyword">val</span> <span class="Delimiter">(</span><span class="Include">Db</span>.<span class="Include">Hashtbl</span>.create <span class="Label">~</span><span class="Identifier">default</span>:<span class="Float">0</span> <span class="Constant">()</span><span class="Delimiter">)</span>: <span class="Include">Db.Sig</span> with type t = int)
</pre>
<br/>
A common alternative is shown in the <code>House</code> example earlier, where the first-class module is unpacked and included within an existing module.<br/>
<br/>
<br/>
<b><u>Inheritance</u></b><br/>
<br/>
There are three kinds of tables which can be instantiated: no inheritance, single inheritance, and multiple inheritance. Oh, did that last one make your hair stand on end? Haha. Well, multiple inheritance of data or properties can be a lot more sensible than the OO notion of it.<br/>
<br/>
The way inheritance works is that an ID may have a parent ID (or a list of IDs for multiple). If a component is not found on ID, it's parent is checked. So if I:&nbsp;<code>Size.get target</code>, then target might inherit from a basic_human which has the size (among other &quot;basic human&quot; traits).<br/>
<br/>
Multiple inheritance allows for the use of <i>property collections</i>. You might see the value of this when considering the basic_human example... say you wanted to also declare foot_soldier properties which imparted some equipment, skills, and credentials. To make a basic_human foot_soldier with multiple inheritance, they're both parents (list-order gives a natural priority).<br/>
<br/>
<div class="separator" style="clear: both; text-align: center;">
<a href="http://4.bp.blogspot.com/-AaVcyyAosxU/UjFRnhc-zHI/AAAAAAAAADE/3XI_Ien7VWg/s1600/inherit.png" imageanchor="1" style="margin-left: 1em; margin-right: 1em;"><img src="http://4.bp.blogspot.com/-AaVcyyAosxU/UjFRnhc-zHI/AAAAAAAAADE/3XI_Ien7VWg/s1600/inherit.png" border="0"/></a></div>
<br/>
<br/>
On the other hand, if only humans could reasonably be foot_soldiers, then you might be okay with single inheritance for this case &mdash; setting basic_human as the parent of foot_soldier.<br/>
<br/>
Currently I'm not using inheritance for the bulk of the game, but the GUI (work in progress) is based on components and uses multiple-inheritance. This is a fragment of the GUI code, so Prop becomes the module used for instantiating components, and it also has the parent-related functions. I've included a few of the components too:<br/>
<br/>
<pre><span class="Comment">(* GUI uses multiple-inheritance (of data), so style and properties may be</span>
<span class="Comment"> * mixed from multiple parents, with parents functioning as property-sets. *)</span>
<span class="Keyword">module</span><span class="Include"> Prop</span> <span class="Keyword">=</span> <span class="Include">Db.MultiInherit</span>

<span class="Keyword">let</span> new_child_of parents <span class="Keyword">=</span>
  <span class="Keyword">let</span> id <span class="Keyword">=</span> new_id <span class="Constant">()</span> <span class="Keyword">in</span>
  <span class="Include">Prop</span>.set_parents id parents<span class="Keyword">;</span>
  id

<span class="Keyword">module</span><span class="Include"> Font</span> <span class="Keyword">=</span> (<span class="Keyword">val</span> <span class="Delimiter">(</span><span class="Include">Prop</span>.<span class="Include">Hashtbl</span>.create <span class="Constant">()</span><span class="Delimiter">)</span>: <span class="Include">Db.Sig</span> with type t = <span class="Include">Fnt2</span>.<span class="Include">t</span>)
<span class="Keyword">module</span><span class="Include"> Pos</span> <span class="Keyword">=</span> (<span class="Keyword">val</span> <span class="Delimiter">(</span><span class="Include">Prop</span>.<span class="Include">Hashtbl</span>.create <span class="Constant">()</span><span class="Delimiter">)</span>: <span class="Include">Db.Sig</span> with type t = <span class="Include">Vec2</span>.<span class="Include">t</span>)
<span class="Keyword">module</span><span class="Include"> Color</span> <span class="Keyword">=</span> (<span class="Keyword">val</span> <span class="Delimiter">(</span><span class="Include">Prop</span>.<span class="Include">Hashtbl</span>.create <span class="Label">~</span><span class="Identifier">default</span>:<span class="Delimiter">(</span><span class="Float">1</span>.,<span class="Float">0</span>.,<span class="Float">1</span>.<span class="Delimiter">)</span> <span class="Constant">()</span><span class="Delimiter">)</span>:
               <span class="Include">Db.Sig</span> with type t = float*float*float)
</pre>
<br/>
<br/>
<b><u>Delete</u></b><br/>
<br/>
It's not all roses. One big pain-in-the-tuchus is deleting an ID. This means removing every entry it has in any of these tables. To do this, when a table is instantiated, it's also registered with the database. The delete operation for any table only needs to know ID, the signature being <code>key -&gt; unit</code>. The real ugly part is what this means at runtime: doing a find-and-remove on every table - every time an entity is deleted. Various optimizations are possible, but for now I'm keeping it brute force.<br/>
<br/>
<br/>
<b><u>The Source</u></b><br/>
<br/>
If you want to see the source, or to <i>*gasp*</i> use it, here is a&nbsp;<a href="https://gist.github.com/atavener/6533969" target="_blank">gist of database.ml / mli</a>. It's very unpolished, needing fleshing-out and useful documentation. I intend to release it at some future point, along with some other code. But if you have tips or suggestions, please share them! I've been going solo with OCaml and suspect that's limiting me &mdash; I could be doing crazy or nonsensical things. Well, I'm sure I am in a few places... maybe right here with this code!<br/>
<br/>
<br/></div>

