---
id: data-types
title: Data Types and Matching
description: >
  Learn to build custom types and write function to process this data
category: "language"
date: 2021-05-27T21:07:30-00:00
---

# Variables and Data types

Variables and data types are fundamental concepts in programming languages. A variable is a named location in memory that is used to store data, and a data type is a classification of data that determines the possible values and operations that can be performed on that data.

Understanding and using variables and data types correctly is essential for writing correct and efficient code. In this documentation, we will explore how to declare and initialize variables, the different data types that are available, and how to convert between different data types. We will also discuss type annotations and type inference, which are mechanisms that can help ensure the correctness and safety of your code. By the end of this page, you should have a solid understanding of these fundamental concepts and be able to use them effectively in your own programs.

## Declaring and initializing variables

Declaring and initializing variables is the process of creating a named location in memory and assigning it an initial value. This is done using the `let` keyword in OCaml, followed by the variable name and an optional type annotation. For example:

```ocaml
let x: int = 5
```

This declares a variable `x` of type `int` and initializes it with the value 5.

Did you notice the `: int` after the name of the variable? This is called a type annotation. A type annotation is a notation that is used to specify the expected type of a variable, function.

In OCaml, type annotations are written using the `:` character followed by the desired type after the variable name or function signature. For example:

```ocaml
let x: int = 5 (* x is of type int *)

let add (x: int) (y: int): int = x + y (* add is a function that takes two int arguments and returns an int result *)

let is_even (x: int): bool = x mod 2 = 0 (* is_even is a function that takes an int argument and returns a bool result *)
```

In these examples, the type annotations specify the expected types of the variables and functions, and the compiler will check for compatibility and raise an error if an incompatible type is used. Type annotations can make your code more readable and self-documenting, and they can help catch type errors at compile time.

Type annotations are optional in OCaml, and the compiler will infer the types of your variables and functions if they are not specified explicitly. For instance, consider the declaration below:

```ocaml
let x = 5 (* x is inferred to be of type int *)
```

In this case, the compiler will infer the type of `x` to be `int` based on the value 5 that is assigned to it. This is called type inference, and it can make your code more concise and readable by allowing you to omit explicit type annotations in many cases.

Unlike some other programming languages, it is not possible to declare a variable without an initial value in OCaml. Every variable must be initialized with a value when it is declared, and attempting to use an uninitialized variable will result in a compile-time error. Therefore, it is important to always provide an initial value for your variables when you declare them.

In OCaml, variable names can consist of alphanumeric characters, the underscore `_` character and the single quote `'` character, and they are case-sensitive. It is recommended to use descriptive and meaningful names for your variables, and to follow a consistent naming convention within your codebase. For example, using camelCase for variable names is a common convention in OCaml.

Valid variable names in OCaml include:

- `x`
- `user_name`
- `employeeSalary`
- `my_function'`
- `attempt'`

Invalid variable names in OCaml include:

- `1st_attempt` (cannot start with a digit)
- `name-of-variable` (cannot contain special characters other than underscore)
- `if` (cannot be a reserved keyword)
- `let` (cannot be a reserved keyword)
- `My_variable` (cannot start with a capital letter)

In summary, declaring and initializing variables is an essential part of writing OCaml programs. By using the `let` keyword and providing an initial value, you can create named locations in memory that can be used to store data. You can also use type annotations and type inference to ensure the correctness and safety of your code. In the next section, we will explore the different data types that are available in OCaml.

## Data types

### Primitive Types and Values

In OCaml, primitive data types are the basic building blocks of data representation, and they include types such as integers, floating-point numbers, strings, and booleans. These types have predefined values and operations, and they are used to represent the most common forms of data in programs.

The primitive data types in OCaml are:

- `int`: represents signed integers, such as `1`, `-5`, and `0`. The range of values that can be represented by an int is determined by the implementation and the available memory.
- `float`: represents floating-point numbers, such as `3.14`, `1e10`, and `0.0`. The precision and range of values that can be represented by a float are determined by the implementation and the available memory.
- `char`: represents a single character, such as `'a'`, `'0'`, and special characters like `'\n'`. A char value is written using single quotes, and it can be any Unicode character.
- `string`: represents a sequence of characters, such as `"hello"`, and `"123"`. A string value is written using double quotes, and it can contain any number of characters.
- `bool`: represents a boolean value, which can either be `true` or `false`. A bool value is typically used in conditional statements and loops to control the flow of execution in a program.

Primitive data types have a fixed size and a predefined set of operations that can be performed on them. For example, you can use the `+` operator to add two `int` values, and the `/` operator to divide a `float` value by another `float` value. You can also use the `<` operator to compare two `int` or `float` values, and the `^` operator to concatenate two `string` values.

### Tuples

A tuple is a fixed-size collection of values, each of which can have a different type. Tuples are similar to lists, but they have a fixed size, and they are often used to represent small and heterogeneous data structures.

In OCaml, tuples are defined using a comma-separated list of values enclosed in parentheses. For example:

```ocaml
(* t1 is a tuple of type (int * string * float) with values 1, "hello", and 2.0 *)
let t1 = (1, "hello", 2.0)

(* t2 is a tuple of type (bool * int * string) with values true, 5, and "world" *)
let t2 = (true, 5, "world")
```

In these examples, the tuples `t1` and `t2` are defined using a comma-separated list of values, and they have specific types and values. The type of a tuple is determined by the types of its elements, and it is represented as a tuple of types enclosed in parentheses.

Tuples are often used to return multiple values from a function, and they can be easily deconstructed using pattern matching. For example:

```ocaml
let foo =
  let x = 1
  let y = "hello"
  let z = 2.0
  (x, y, z) (* return a tuple with values x, y, and z *)

let (a, b, c) = foo (* decompose the returned tuple and bind its values to variables a, b, and c *)
```

In this example, the `foo` function returns a tuple with three values, which are then deconstructed using pattern matching and assigned to the variables `a`, `b`, and `c`. This allows you to access the individual values of the tuple in a safe and convenient way.

In addition to returning multiple values from a function, tuples can also be used to store and manipulate data in a structured and efficient way. For example, you can define a tuple of records to represent a collection of objects, and you can use pattern matching to access and update individual fields of the records.

```ocaml
(* define a record type representing a person *)
type person = { name: string; age: int }

(* define a tuple of records representing three people *)
let people =
  [( { name = "Alice"; age = 25 },
     { name = "Bob"; age = 30 },
     { name = "Charlie"; age = 35 } )]

(* deconstruct the tuple and bind its elements to variables *)
let (alice, bob, charlie) = people 

let new_people =
  (* update the age of Alice and Charlie using pattern matching *)
  match people with
  | ( { name = "Alice"; age = _ }, bob, { name = "Charlie"; age = _ }) -> ( { alice with age = 26 }, bob, { charlie with age = 36 })
  | _ -> people
```

In this example, the people tuple is defined as a tuple of records, and it is used to represent a collection of three people. The tuple is then deconstructed and its elements are bound to the variables `alice`, `bob`, and `charlie`. Finally, the `new_people` tuple is defined by updating the age of Alice and Charlie using pattern matching on the people tuple. This allows you to access and update individual fields of the records in a safe and concise way.

But don't worry if the last line is confusing for now: we'll cover pattern matching in depth in a next chapter.

In summary, tuples are fixed-size collections of values in OCaml, and they are often used to represent small and heterogeneous data structures. Tuples are defined using a comma-separated list of values enclosed in parentheses, and their type is determined by the types of their elements. Tuples are commonly used to return multiple values from a function, and they can be deconstructed using pattern matching to access and manipulate their individual elements.

### Custom data types: records

You can also use the `type` keyword to define custom data types, which can be used to represent more complex or domain-specific data structures. There are two main ways to define custom data types in OCaml: using records and using variants.

Records are used to define a data type that consists of a fixed set of named fields, each of which has a specific type. For example:

```ocaml
type point = { x: float; y: float } (* point is a custom type with x and y fields of type float *)

let p1: point = { x = 1.0; y = 2.0 } (* p1 is a point value with x = 1.0 and y = 2.0 *)
let p2: point = { x = 3.0; y = 4.0 } (* p2 is a point value with x = 3.0 and y = 4.0 *)
```

In this example, the point type is defined to have two `float` fields named `x` and `y`, and the values `p1` and `p2` are instances of this type with specific field values. Records provide a compact and intuitive way to define complex data structures, and they can be easily accessed and manipulated using field labels and pattern matching.

### Custom data types: variants

Variants (also known as a union type) is a data type that can have one of several possible values, each of which has a specific type. A variant is defined using the `|` character to separate the different alternatives, and each alternative is specified using a constructor name and the corresponding type. For example:

```ocaml
type shape =
  | Circle of float (* Circle is a variant with a float value *)
  | Rectangle of float * float (* Rectangle is a variant with two float values *)
  | Triangle of float * float * float (* Triangle is a variant with three float values *)

let s1: shape = Circle 5.0 (* s1 is a Circle value with a radius of 5.0 *)
let s2: shape = Rectangle (2.0, 3.0) (* s2 is a Rectangle value with sides 2.0 and 3.0 *)
let s3: shape = Triangle (3.0, 4.0, 5.0) (* s3 is a Triangle value with sides 3.0, 4.0, and 5.0 *)
```

In this example, the `shape` type is defined to have three alternatives: `Circle`, `Rectangle`, and `Triangle`, each of which has a different set of associated values. The values `s1`, `s2`, and `s3` are instances of the shape type, and they have specific values that correspond to the different alternatives.

Variants are a powerful and flexible way to represent data in OCaml, and they can be used to model complex and hierarchical data structures. They also support pattern matching (which we'll explore in the next page), which allows you to deconstruct values of a variant type and extract their individual components in a safe and concise way.

### Type conversion

Type conversion is the process of converting a value of one type to another compatible type. This is also known as type casting or type coercion, and it is a common operation in many programming languages. Type conversion is necessary in some cases because not all values of different types are compatible with each other, and the compiler needs to know how to convert them in order to combine them in a meaningful way.

The OCaml standard library provides several functions to convert from one type to another. For example:

```ocaml
let x: int = 5 (* x is of type int *)
let y: float = float_of_int x (* y is of type float, and it is the result of converting x to a float value using the float_of_int function *)
let z: string = string_of_int x (* z is of type string, and it is the result of converting x to a string value using the string_of_int function *)
```

In these examples, the values `y` and `z` are derived from the value of `x` by converting it to a different type using the appropriate conversion function.

It is important to note that type conversion in OCaml is not always possible, and it can lead to runtime errors if the source and target types are not compatible. For example, trying to convert a string value to an int value using the int_of_string function will raise an error if the string does not contain a valid integer. Therefore, it is important to check the compatibility of the source and target types before performing type conversion, and to handle any potential errors gracefully.

## Scope

Variable scopes refer to the regions of a program where a variable is visible and accessible. This is an important concept in many programming languages, because it determines the lifetime and visibility of variables, and it helps to avoid conflicts and misunderstandings.

In OCaml, variables have either local or global scope, depending on where they are defined and used. Local variables are defined within a specific block of code, such as a function body or a loop, and they are only visible and accessible within that block. Global variables, on the other hand, are defined outside of any specific block, and they are visible and accessible throughout the entire module.

Here is an example of local and global variable scopes in OCaml:

```ocaml
let x = "hello" (* x is a global variable of type int and has a value of 5 *)

let foo =
  let x = "world" (* x is a local variable of type string and has a value of "hello" *)
  (* x is only visible and accessible within the body of the foo function *)
  print_endline x

let bar =
  (* x is not visible or accessible within the body of the bar function, because it is shadowed by the local x defined in the foo function *)
  print_endline x

(* x is still visible and accessible here, because it is a global variable *)
print_endline x
```

Notice that the variable `x` declared in the scope of `foo` has the same name as the global variable `x`. This is called shadowing.

Shadowing means defining a new variable with the same name as an existing variable, which hides the original variable and replaces it with the new one. This is a common technique in many programming languages, and it is often used to temporarily change the value or type of a variable within a specific scope.

Beware that shadowing can lead to confusion and errors if not used carefully, because it can make it difficult to understand the meaning and type of a variable in a given context. Therefore, it is recommended to avoid shadowing whenever possible, and to use more descriptive and unique variable names to avoid conflicts and misunderstandings.

## Advanced Topics

In this section, we will cover advanced topics related to data types in OCaml. These topics provide additional insights and techniques that can help you to write more powerful and expressive code in OCaml. However, they are not essential for understanding the basics of the language, so feel free to skip them for now and come back to them later.

We will cover the following topics:

- Mutually recursive data types
- Polymorphic variants
- Cohersion of polymorphic variants
- Extensible data types
- GADTs

### Mutually recursive data types

Mutually recursive data types are data types that are defined in terms of each other, forming a circular reference. This is a powerful and expressive technique that allows you to define complex and interdependent data structures, and it is often used to model real-world phenomena that have a recursive and circular nature.

In OCaml, mutually recursive data types are defined using the `and` keyword, which allows you to define multiple data types in a single statement. For example:

```ocaml
type shape =
  | Circle of float
  | Rectangle of float * float
  | Triangle of float * float * float
and color =
  | Red
  | Green
  | Blue
and object_ =
  | Shape of shape * color
  | Group of object_ list
```

In this example, the `shape`, `color`, and `object_` data types are defined in a mutually recursive manner, using the `and` keyword. The shape type represents geometric shapes, such as circles, rectangles, and triangles, and it is used as the basis for the object type. The `color` type represents colors, and it is used as an attribute of object values. Finally, the `object_` type represents objects in a scene, and it can be either a single shape with a color, or a group of objects.

Mutually recursive data types can be used to define complex and interdependent data structures, such as trees, graphs, and networks. For example, here is how you can define a binary tree data type using mutually recursive data types:

```ocaml
type 'a tree =
  | Leaf
  | Node of 'a * 'a tree * 'a tree
```

In this example, the tree data type is defined as a binary tree, which can store data in a hierarchical and recursive structure. The tree can be either a leaf node or a node with a value and two child nodes. This allows you to represent and manipulate trees in a natural and efficient way.

### Polymorphic variants

In OCaml, polymorphic variants are data types that can take on multiple, distinct forms. This is a flexible and extensible technique that allows you to represent a wide range of values and data structures, and it is often used to model complex and dynamic data.

Polymorphic variants are defined using the `[< ... ]` syntax, which allows you to specify a list of possible forms that the variant can take. For example:

```ocaml
(* define a polymorphic variant type representing fruits *)
type fruit = [ `Apple | `Banana | `Orange | `Strawberry ]
```

In this example, the `fruit` data type is defined as a polymorphic variant, and it can take on four distinct forms: `Apple`, `Banana`, `Orange`, and `Strawberry`.

Polymorphic variants are often used to define extensible data types, which can be extended and updated at runtime. For example:

```ocaml
(* define a polymorphic variant type representing fruits *)
type fruit = [ `Apple | `Banana | `Orange | `Strawberry ]

let add_fruit fruit = function
  | `Apple -> [< fruit; `Apple >]
  | `Banana -> [< fruit; `Banana >]
  | `Orange -> [< fruit; `Orange >]
  | `Strawberry -> [< fruit; `Strawberry >]

let basket1 = `Apple (* define a basket with an Apple fruit *)
let basket2 = add_fruit basket1 `Banana (* add a Banana fruit to the basket *)
let basket3 = add_fruit basket2 `Orange (* add an Orange fruit to the basket *)
let basket4 = add_fruit basket3 `Strawberry (* add a Strawberry fruit to the basket *)
```

In this example, the `fruit` data type is defined as a polymorphic variant, and the `add_fruit` function is used to add a fruit to a basket. The `add_fruit` function takes a basket and a fruit as arguments, and it returns a new basket with the added fruit using the `[< ... ]` syntax. This allows you to extend and update the basket at runtime, without having to define a new data type or modify the existing one.

### Cohersion of polymorphic variants

???

### Extensible variant types

Extensible variant types are a way to define a variant type in OCaml that can be extended with additional variant constructors at a later time. This is useful in situations where a type may need to be extended to support new cases in the future, without the need to make changes to existing code that uses the type.

To define an extensible variant type, the `..` syntax is used in place of a list of variant constructors. For example:

```ocaml
type attr = ..
New variant constructors can be added to the type using the `+=` syntax:

```ocaml
type attr += Str of string
type attr += Int of int
type attr += Float of float
```

The variant constructors added to the type in this way can be used in pattern matching, just like regular variant constructors. It is important to include a default case in pattern matching to handle any unknown variant constructors that may be added in the future. For example:

```ocaml
let to_string = function
  | Str s -> s
  | Int i -> Int.to_string i
  | Float f -> string_of_float f
  | _ -> "?"
```

One of the built-in types in OCaml that is an extensible variant type is exn, which is used for exceptions. Exception constructors can be declared using the `+=` syntax:

```ocaml
type exn += Exc of int
```

Extensible variant constructors can be rebound to a different name, which allows for exporting variants from another module. For example:

```ocaml
# let not_in_scope = Str "Foo";;
Error: Unbound constructor Str
type Expr.attr += Str = Expr.Str
# let now_works = Str "foo";;
val now_works : Expr.attr = Expr.Str "foo"
```

Extensible variant constructors can also be declared as private, which prevents them from being directly constructed using constructor application. However, they can still be de-structured in pattern-matching. For example:

```ocaml
module B : sig
  type Expr.attr += private Bool of int
  val bool : bool -> Expr.attr
end = struct
  type Expr.attr += Bool of int
  let bool p = if p then Bool 1 else Bool 0
end

# let inspection_works = function
    | B.Bool p -> (p = 1)
    | _ -> true;;
val inspection_works : Expr.attr -> bool = <fun>

# let construction_is_forbidden = B.Bool 1;;
Error: Cannot use private constructor Bool to create values of type Expr.attr
```

In summary, extensible variant types provide a way to define a variant type that can be extended with additional variant constructors in the future, without the need to modify existing code that uses the type. This can be useful for defining types that may need to be extended to support new cases over time.

### GADTs

Generalized Algebraic Data Types (GADTs) are a type system feature that allows you to define data types in a more flexible and expressive way. This is a powerful and expressive technique that allows you to represent complex and interdependent data structures, and it is often used to model real-world phenomena that have a recursive and circular nature.

Consider the following variant:

```ocaml
(* define an ADT type representing expressions *)
type 'a expr =
  | Var of string
  | Int of int
  | Add of int expr * int expr
  | Mul of int expr * int expr
  | Eq of 'a expr * 'a expr
```

And how it could be re-written using a GADT:

```ocaml
(* define a GADT type representing expressions *)
type 'a expr =
  | Var : string -> string expr
  | Int : int -> int expr
  | Add : int expr * int expr -> int expr
  | Mul : int expr * int expr -> int expr
  | Eq : 'a expr * 'a expr -> bool expr
  | If : bool expr * 'a expr * 'a expr -> 'a expr
```

In this example, the `expr` data type is defined as a GADT, and it is extended with a new form called `If`. The `If` form is a ternary operator that takes a `bool` expression, a `'a` expression, and another `'a` expression as arguments, and it returns an `'a` expression. This allows you to define recursive and circular data structures that can be evaluated and manipulated in a flexible and expressive way.
