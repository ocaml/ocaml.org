---
title: How to build type-safe State Machines using type-state
description: Tired of writing state machines full of invalid transitions? Type-state
  may be what you're looking for. In this issue of Practical OCaml we show you how
  to use it to build type-safe state machines.
url: https://practicalocaml.com/how-to-build-type-safe-state-machines-using-type-state/
date: 2023-08-29T10:29:59-00:00
preview_image:
featured:
authors:
- Practical OCaml
source:
---

<p>This will be a short one, but I hope it'll make you want to go refactor everything.</p><p>There are a lot of ways of writing state machines in typed languages, all varying in the degree of type-safety. Sure you can put everything in a record full of <code>this option</code> or have one variant per state and a bunch of repeated things...but today I wanna show you a way of doing state machines with something called <em>type-state.</em></p><p>What this buys you is that you can offer a nice uniform API for your state machines while keeping the internal states cleanly separated.</p><p>Let's start from the beginning.</p><h2>What is type-state?</h2><p>Type state is kind of a weird term. You don't really have <em>state</em> in your types, right? Like you don't have a counter that keeps incrementing.</p><figure class="kg-card kg-code-card"><pre><code class="language-ocaml">type counter = int
let inc : counter -&gt; counter = fun x -&gt; x + 1

let one: counter = inc 0
let two: counter+1?  = inc one
</code></pre><figcaption>Look ma! I made a counter that counts, but you can't see how much it counts on its type. But it's counting, I promise.</figcaption></figure><p>You can bend backwards to do this with some <em>type schemes</em> (which is a fancy word for &quot;how to do something&quot; or &quot;pattern&quot; that you may read around). Like a common way of doing this is to use type-params to keep adding types to something. For example:</p><pre><code class="language-ocaml">type zero = Zero
type 'a inc = Inc of 'a

(* our `inc` function wraps whatever in an `inc` type *)
let inc : 'a -&gt; 'a inc = fun x -&gt; Inc x

let one: zero inc = inc Zero
let two: zero inc inc = inc one
let three: zero inc inc inc = inc two</code></pre><p>And this sort of thing can be suuuper useful if you want to statically validate something. For example, let's say you have a <code>fuel</code> type and you can only accelerate your car if you have <em>enough fuel</em>. And <em>enough fuel</em> is defined as &quot;one unit of fuel&quot; or in types as &quot;it's wrapped by one <code>fuel</code> type&quot;.</p><p>So we can start with a car without fuel, fuel it up, and then consume the fuel. And in the next example, you can see how the type annotation matches the amount of fuel a car has.</p><figure class="kg-card kg-code-card"><pre><code class="language-ocaml">type no_fuel = No_fuel
type 'a fuel = Fuel of 'a

let fuel_up x = (Fuel (Fuel x))

let run (Fuel x) = x

let empty_car = No_fuel
let full_car: no_fuel fuel fuel = empty_car |&gt; fuel_up
let full_car: no_fuel fuel = run full_car
let full_car: no_fuel = run full_car

(* this last one will be a type error! *)
let full_car: no_fuel = run full_car</code></pre><figcaption>In this example we statically track the amount of fuel by using a <code>fuel</code> type that is essentially a counter. When we <em>fuel up</em> the counter goes up, when we <em>run</em> the counter goes down. We can only call <em>run</em> on a car with at least one <code>fuel</code>.</figcaption></figure><p>This fails because the last <code>full_car</code> that worked becomes a car with no fuel, and our <code>run</code> function requires a car <em>with</em> fuel.</p><p>But alas, this can get super complex quickly because:</p><ol><li>We're not used to this kind of programming in the types (unlike in programming languages like Idris or TypeScript)</li><li>We don't have good debugging tools for this, and type errors can become strange quickly, especially if we use polymorphic variants, objects, or <a href="https://practicalocaml.com/a-quick-guide-to-gadts-and-why-you-aint-gonna-need-them/">GADTs</a>. </li></ol><p>Okay, there's more to say about type-state, but this should be enough for now: <strong>type-state lets you rule out certain behaviors by putting in your types, information about the values.</strong></p><p>Moving on...</p><h2>Type-state state machines</h2><p>Alright, we're ready to go. The pattern is pretty straightforward:</p><ol><li>We need a type for our <em>thing</em>, which will be a state machine</li><li>We need a type parameter for the <em>state</em> the machine is in</li><li>We want to save that state as a discrete value in our state machine type</li></ol><pre><code class="language-ocaml">type 'state fsm = { state: 'state }</code></pre><p>That's it. That's the pattern. If it seems small it's because it is, but there's so much power to this pattern! Let's explore with an example.</p><h3>Requesting Permissions as a Type-state machine</h3><p>We'll build a tiny Permissions module that will help us check if a User has the right permissions to access a resource. There will be 3 states: Requested, Granted, and Denied. We'll always start on Requested, and we can move to Granted or Denied. If we are on Granted we should have access to the resource itself, if we are on Denied we should have access to some reason for why we were denied access.</p><p>So we start with our basics, the pattern:</p><pre><code class="language-ocaml">type 'state t = { state: 'state };</code></pre><p>Next, we're going to add the 3 states as distinct types:</p><pre><code class="language-ocaml">type id
type scope

type 'resource granted = { resource : 'resource }
type denied = { reason : string }
type requested = { scopes : scope list }</code></pre><p>Let's put this together with our <code>t</code> type. We will need to introduce a new type parameter for the <code>'resource</code>, so we know what <code>'resource</code> to use when we create our <code>'resource granted</code> state. We'll also add some more metadata that is specific to a permission request but is shared across all states.</p><pre><code class="language-ocaml">type ('state, 'resource) t = {
  (* the state of the permission request *)
  state : 'state;
  (* other shared metadata *)
  resource_id : id;
  user_id : id;
}</code></pre><p>And now we can build our API on top of this, using our <code>'state</code> type to guide the user to the functions they can use:</p><ol><li>We want to create a new Permissions Request that will be &nbsp;<code>requested t</code> </li><li>We want to call a function that returns either a <code>granted t</code> with our resource, or a <code>denied t</code> with a reason</li><li>If we get a <code>denied t</code> we want to be able to see the reasons</li><li>If we get a <code>granted t</code> we want to be able to <em>use</em> the resource.</li></ol><p>Let's get to work!</p><p>We'll start with a constructor function, and a function to transition to our final states:</p><pre><code class="language-ocaml">let make ~resource_id ~user_id ~scopes =
  { state = { scopes }; resource_id; user_id }

let request_access t =
  match run_request t with
  | Ok resource -&gt; Ok { t with state = { resource } }
  | Error reason -&gt; Error { t with state = { reason } }</code></pre><p>The basic machinery is done. We create, and the type system will infer correctly that the state should be <code>requested</code>, because a <code>requested</code> record includes <code>scopes</code>.</p><p>Then, our <code>request_access</code> function will return either <code>(granted, 'resource) t</code> or a <code>(denied, 'resource) t</code> wrapped in a result. We can use any variant for this, even a Future, but a result is already present so we'll go with that here.</p><p>Great, the next step is implementing our operations:</p><pre><code class="language-ocaml">(* extract the reason from a `denied` state *)
let reason { state = { reason }; _ } = reason

(* do something with the resource in a `granted` state *)
let with_resource { state = {resource}; _ } fn = fn resource

(* get the resource out of a granted permission *)
let get { state = {resource}; _ } fn = resource</code></pre><p>And done. The types get inferred nicely here as well because the records are all disjoint. Now we can use our little state machine:</p><pre><code class="language-ocaml">(* this would be our resource *)
module Album =  struct
  type t = string
  let print = print_string
end

let _ =
  let req: (_, Album.t) Permission_request.t =
    Permission_request.make
      ~resource_id:&quot;spotify:album:5SYItU4P7NIwiI6Swug4GE&quot;
      ~user_id:&quot;user:2pVEM9qgPvPeMslgnGDDOr&quot;
      ~scopes:[ &quot;listen&quot;; &quot;star&quot;; &quot;playlist/add&quot;; &quot;share&quot; ]
  in

  match Permission_request.request_access req with
  | Ok res -&gt;
      Permission_request.with_resource res Album.print;
      let album = Permission_request.get res in
      Album.print album;
  | Error res -&gt;
      print_string (Permission_request.reason res)</code></pre><p>Pretty neat, right?</p><p>For completeness sake, here's our <code>Permission_request</code> module:</p><pre><code class="language-ocaml">module Permission_request = struct
  type id = string
  type scope = string
  type 'resource granted = { resource : 'resource }
  type denied = { reason : string }
  type requested = { scopes : scope list }

  type ('state, 'resource) t = {
    (* the state of the permission request *)
    state : 'state;
    (* other shared metadata *)
    resource_id : id;
    user_id : id;
  }

  let make ~resource_id ~user_id ~scopes =
    { state = { scopes }; resource_id; user_id }

  (* TODO(@you): you can implement here the logic for checking
   * if you actually have permissions for this request :)
   *)
  let run_request : (requested, 'resource') t -&gt; ('resource, string) result =
   fun _t -&gt; Error &quot;unimplemented!&quot;

  let request_access t =
    match run_request t with
    | Ok resource -&gt; Ok { t with state = { resource } }
    | Error reason -&gt; Error { t with state = { reason } }

  let reason { state = { reason }; _ } = reason
  let with_resource { state = { resource }; _ } fn = fn resource
  let get { state = {resource}; _ } = resource
end</code></pre><h2>Conclusions: Type-state is Great</h2><p>Type-state is just another tool in your bat-belt to build great APIs with type-safety, and good ergonomics.</p><p>It has a cost, like everything else, but <strong>it enables you to grow your states</strong> and maintain them separately by using submodules, in a very natural way. After all they are different types!</p><p>I picked up this pattern from Rust libraries that model the state of sockets, database connections, and many other things, by doing exactly the same thing. Of course, having <code>traits</code> in Rust means we can extend the methods for a specific type-state, which means narrowing down even further the information you have to process when you go type <code>req.</code> and get the autocompletion list.</p><p>But at least in OCaml we can implement the pattern safely and maybe with time our autocompletion will get smarter and do the same filtering for us!</p><p>That's it. That's type-states for OCaml.</p><p>Have you implemented typed state machines in some other ways? Have anything to add or challenge? I'd love to hear it! <a href="https://twitter.com/leostera/status/1696470989582864872?ref=practicalocaml.com">Join the x.com thread</a>.</p><p>Happy Cameling! &#128043;</p>
