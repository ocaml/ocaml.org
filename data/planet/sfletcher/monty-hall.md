---
title: Monty Hall
description: 'Suppose you''re on a game show, and you''re given the choice of three
  doors : Behind one door is a car; behind the others, goats. You pick a d...'
url: http://blog.shaynefletcher.org/2016/10/monty-hall.html
date: 2016-10-12T16:05:00-00:00
preview_image:
featured:
authors:
- Shayne Fletcher
---

<p>Suppose you're on a game show, and you're given the choice of three doors : Behind one door is a car; behind the others, goats. You pick a door, say No. 1, and the host, who knows what's behind the doors, opens another door, say No.3 which has a goat. He then says to you, &quot;Do you want to pick door No. 2?&quot; Is it to your advantage to switch your choice?
</p>

<p>What do you think?</p>

<p>This problem is known as the &quot;<a href="https://en.wikipedia.org/wiki/Monty_Hall_problem">Monty Hall</a>&quot; problem. It's named after the host of the American television game show &quot;Let's make a deal&quot;.
</p>

<p>
<a href="https://en.wikipedia.org/wiki/Paul_Erd%C5%91s">Paul Erd&#337;s</a>, one of the most prolific mathematicians in history remained unconvinced (of the correct answer to the above problem) until he was shown a computer simulation confirming the predicted result.</p>

<p>
Here's a simulation in OCaml one hopes, may have convinced Paul!
</p>

<pre class="prettyprint ocaml">
module Monty = struct

  (*[dtr w p n] where [n] is the number of doors, selects which door
    to remain (closed) given the winning door [w] and the player
    chosen door [p]*)
  let rec dtr w p n =
    if p &lt;&gt; w then  w 
    else if p = 0 then n - 1 else 0

  (*[gen_game d] generates a game with [d] doors and returns a game
    with a winning door, a player selected door and a door to keep
    closed before if the player wants to switch*)
  let gen_game (d : int) : (int * int * int) =
    let w = Random.int d and p = Random.int d in 
    (w, p, dtr w p d)

  let num_wins = ref 0 (*To keep track of scores*)
  type strategy = Hold | Switch (*The type of strategies*)

  (*Play a single game*)
  let play_game (d : int) (s : strategy) : unit =
    let w, p, r = gen_game d in
    match s with
    | Hold &rarr; num_wins := !num_wins + if p = w then 1 else 0
    | Switch &rarr; num_wins := !num_wins + if r = w then 1 else 0

  (*Play a set of [n] games*)
  let play_games (d : int) (n : int) (s : strategy ) : unit = 
    let rec loop (i : int) : unit = 
      if i = n then ()
      else  begin
        play_game d s;
        loop (i + 1)
      end 
    in loop 0

end

open Monty

(*Initialized from the command line*)
let version       = ref false
let num_doors     = ref 0
let num_sims      = ref 0
let read_args () =
  let specification =
    [(&quot;-v&quot;, Arg.Set version, &quot;Print the version number&quot;);
     (&quot;-d&quot;, Arg.Set_int num_doors, &quot;Number of doors (&gt;= 3)&quot; );
     (&quot;-n&quot;, Arg.Set_int num_sims, &quot;Number of simulations (&gt;= 1)&quot;);
    ]
  in Arg.parse specification
  (fun s &rarr;
    Printf.printf &quot;Warning : Ignoring unrecognized argument \&quot;%s\&quot;\n&quot; s)
  &quot;Usage : monty -d &lt;number of doors&gt; -n &lt;number of simulations&gt;&quot;

(*[fabs e] computes the absolute value of [e]*)
let fabs (e : float) : float = if e &lt; 0. then ~-.e else e

(*Driver*)
let () = 
  try
    read_args ();
    if !version then Printf.printf &quot;1.0.0\n&quot;
    else
      let n = !num_sims and d = !num_doors in
      if d &lt; 3 then
        raise (Invalid_argument &quot;Number of doors must be &gt;= than 3&quot;);
      if n &lt; 1 then
        raise (Invalid_argument &quot;Number of simulations must be &gt;= 1&quot;);
      begin
        (*Hold*)
        num_wins := 0;
        play_games d n Hold;
        Printf.printf &quot;Num wins (hold): %d\n&quot; !num_wins;
        let err=fabs (float_of_int (!num_wins) /. 
                    (float_of_int n) -. 1.0 /. (float_of_int d)) in
        Printf.printf &quot;Error %f\n&quot; err;
        (*Switch*)
        num_wins := 0;
        play_games d n Switch;
        Printf.printf &quot;Num wins (switch): %d\n&quot; !num_wins;
        let err=fabs (float_of_int (!num_wins) /. 
                   (float_of_int n) -. (float_of_int (d - 1) /. 
                                                (float_of_int d))) in
        Printf.printf &quot;Error %f\n&quot; err ;
      end

  with 
  | Invalid_argument s &rarr; Printf.printf &quot;%s\n&quot; s
</pre>
