### A Clever Implementation of Bind

<!-- Jakub's Note: I found the implementation of `bind` using `Fun.flip`, `Option.map`, and `Option.join` to be a bit confusing, so I'm suggesting the above implementation.
     However, it is a clever utilization of the building blocks introduced by the prior lessons. I broke the clever implementation down in the following section, but don't know it it is too
     long. I'm curious what your thoughts are. To advocate for the length of this section, it acts as a nice culmination of this lesson. To concede the counterpoint, it requires a lot of text
     to fully explain step by step -->

There is a more clever way we can define our `bind` function that uses many of the features of the OCaml standard library we've learned so far.

Lets construct our clever version of `bind` slowly. For reference, below is what we will be building up to:

```ocaml
# let clever_bind o f = o |> Option.map f |> Option.join;;
val clever_bind : 'a option -> ('a -> 'b option) -> 'b option = <fun>
```

We will be using `Option.map` as a building block.

First, we must account for the fact that the parameters to `Option.bind` and `Option.map` are flipped:

```ocaml
# #show Option.bind;;
val bind : 'a option -> ('a -> 'b option) -> 'b option

# #show Option.map;;
val map : ('a -> 'b) -> 'a option -> 'b option
```

There are different ways we can solve this problem.

One solution is to use the handy `flip` function from the [`Fun` module in OCaml's standard library](https://github.com/ocaml/ocaml/blob/trunk/stdlib/fun.ml). `Fun.flip` has the signature `('a -> 'b -> 'c) -> 'b -> 'a -> 'c`, where the first parameter is a function that itself takes two parameters (`'a` and `'b`) and returns a value `'c`. `Fun.flip` then requires two additional arguments in the reverse order accepted by the function we supplied. Ultimately, `Fun.flip` returns the same `'c` returned by our supplied function.

Lets try using `Fun.flip` first:

```ocaml
# let clever_bind o f = (Fun.flip Option.map) o f;;
val clever_bind : 'a option -> ('a -> 'b) -> 'b option = <fun>;; 
```

Another option is to simply apply the arguments to `clever_bind` in the reverse order when applying them to `Option.map`:

```ocaml
# let clever_bind o f = Option.map f o;;
val clever_bind : 'a option -> ('a -> 'b) -> 'b option = <fun>;; 
```

Both versions meet our needs, but the second is a little easier to read.

Now, lets recall that `bind` requires argument `f` to be a function that returns an option. Lets try that to see where what we get:

```ocaml
# clever_bind (Some 3) (fun x -> Some x);;
- : int option option = Some (Some 3)
```

Since `Option.map` returns a value wrapped in an option, `clever_bind` returns `Some (Some 3)` when we supply it with `Some 3`, which has the signature `'a option option`.

We already know how to solve this problem with `Option.join`:

```ocaml
# let clever_bind o f = Option.join (Option.map f o);;
val clever_bind : 'a option -> ('a -> 'b option) -> 'b option = <fun>
```

You may be wondering how OCaml inferred the correct signature.

OCaml's type inference determines the output type of `Option.map` based on its function argument. Since `Option.map` applies `f : 'a -> 'b option` to each element inside an option, the result is always wrapped in an additional option. If we supply `Option.map` with `Some 3` and `f` returns `Some 4`, the result is `Some (Some 4)`. If `f` returns `None`, the result is `Some None`. If we supply `None`, the result is simply `None`:

```ocaml
# Option.map (fun x -> Some (x+1)) None;;
- : int option option = None
```

This means `Option.map` produces a value of type `'b option option`, reflecting the extra level of wrapping. Since `Option.join` is specifically designed to flatten one level of option, it takes a value of type `'b option option` and returns `'b option`. By chaining these functions together, OCaml infers that the overall function must have the type:

```ocaml
'a option -> ('a -> 'b option) -> 'b option
```

This process is purely a result of function composition and type inference.

And with that explanation, we have a full understanding of our solution.

Finally, to make our solution match the target example we started with above, we can re-implement it with the pipe operator (`|>`):

```ocaml
# let clever_bind o f = o |> Option.map f |> Option.join;;
val clever_bind : 'a option -> ('a -> 'b option) -> 'b option = <fun>
```

While this implementation of `bind` is a useful excercise, it may be a little too clever for practical purposes. You may be interested to see that the standard library implements `Option.bind` similarly to how we defined it in the previous section. Here is a link to the implementation in the [option.ml file](https://github.com/ocaml/ocaml/blob/trunk/stdlib/option.ml). You can find the interface for `Option.bind` in the [option.mli file](https://github.com/ocaml/ocaml/blob/trunk/stdlib/option.mli).


**Side Note**:
By the way, any type where `map` and `join` functions can be implemented, with similar behaviour, can be called a _monad_, and `option` is often used to introduce monads. But don't freak out! You don't need to know what a monad is to use the `option` type.

