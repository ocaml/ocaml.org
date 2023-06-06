---
title: 'OCaml Design Pattern: Easy functorization refactoring for unit testing'
description: "I\u2019ve recently stumbled upon a useful OCaml design pattern for functorizing
  an existing module, without changing the way existing clients of that module use
  it. This is really useful for stubb\u2026"
url: https://mcclurmc.wordpress.com/2012/12/18/ocaml-pattern-easy-functor/
date: 2012-12-18T23:31:33-00:00
preview_image: https://s0.wp.com/i/blank.jpg
featured:
authors:
- mcclurmc
---

<p>I&rsquo;ve recently stumbled upon a useful OCaml design pattern for functorizing an existing module, without changing the way existing clients of that module use it. This is really useful for stubbing out dependencies when you&rsquo;re refactoring code for unit tests. Here&rsquo;s a simplified example from a bit of code that I refactored today.</p>
<pre class="brush: plain; title: ; notranslate">
module Ovs = struct

  let vsctl args = call_cmd &quot;ovs-vsctl&quot; args

  let create_bond name bridges interfaces props =
    let prop_args = make_bond_properties name props in
    let iface_args = do_stuff_with interfaces prop_args in
    let bridge_args = do_other_stuff_with bridges in
    vsctl [ bridge_args; iface_args ]

end
</pre>
<p>The above code is loosely based on <a href="https://mcclurmc.wordpress.com/feed/github.com/xen-org/xen-api">xen-api&rsquo;s</a> network daemon, a service which configures an XCP host&rsquo;s networking. The above module is for the Open vSwitch backend, which uses the ovs-vsctl command line tool to convigure the vSwitch controller. I just implemented some new functionality in the make_bond_properties function (not shown above), and I want to test that ovs-vsctl command is being invoked properly.</p>
<p>I want to be able to test that the list of arguments we&rsquo;re passing to the vsctl function is correct, but this function calls vsctl directly with the arguements, so I can&rsquo;t &ldquo;see&rdquo; them in my test case. We could just split create_bond into create_bond_arguments and do_create_bond functions. But if we ever write unit tests for the other 20 functions that call vsctl, we&rsquo;ll have to do the exact same thing for all of them. Instead, we&rsquo;ll refactor the Ovs module so that we can pass in an alternative implementation of vsctl.</p>
<pre class="brush: plain; title: ; notranslate">
module Ovs = struct
  module Cli = struct
    let vsctl args = call_cmd &quot;ovs-vsctl&quot; args
  end

  module type Cli_S = module type of Cli

  module Make(Cli : Cli_S) =

    (* continue with original definition of Ovs *)
    let create_bond name bridge interfaces props =
      let prop_args = make_bond_properties name props in
      let per_iface_args = do_stuff_with interfaces prop_args in
      vsctl [ bridge; per_iface_args ]

  end

  include Make(Cli)

end
</pre>
<p>You can see that we&rsquo;ve just inserted a few lines of code around the original Ovs module implementation. We moved the vsctl function into Ovs.Cli, and we moved the rest of the definition of Ovs into Ovs.Make(Cli : Cli_S). The neat bit is at the end, when we include Make(Cli) inside of module Ovs. This calls the Make functor with a module that contains the original definition of the vsctl function, and includes that in the Ovs definition. Now we have a functorized module, which we can customize in our test cases. Yet we haven&rsquo;t changed the definition of the original Ovs module at all, so we don&rsquo;t have to change any of the code that depends on the Ovs module! This trick also works on toplevel modules in *.ml files, too.</p>
<p>Now our testcase is easy to write:</p>
<pre class="brush: plain; title: ; notranslate">
module TestCli = struct
  let vsctl args = assert_args_are_correct args
end

let test_create_bond =
  let module Ovs = Ovs.Make(TestCli) in
  let test_properties = ... in
  Ovs.create_bond &quot;bond0&quot; &quot;xapi0&quot; [&quot;eth0&quot;; &quot;eth1&quot;] test_properties
</pre>
<p>So the test is actually performed by the vsctl command, which we injected into the Ovs module using the Ovs.Make functor. Easy!</p>
<p>One more thought: I had considered using first class modules to inject test dependencies into a module like Ovs. This would have worked as well, but I couldn&rsquo;t think of a good way to do it that wouldn&rsquo;t have required rewriting all the Ovs call sites (I didn&rsquo;t think to hard about it, so maybe it&rsquo;s easier than I think). Also, first class modules are really meant for swapping dependencies at runtime, more akin to what Java programmers mean when they say &ldquo;dependency injection.&rdquo; In this case, we really would rather have the dependency injection done at compile time, so there&rsquo;s no real benefit to using first class modules.</p>

