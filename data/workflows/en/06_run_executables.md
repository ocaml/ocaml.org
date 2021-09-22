---
title: "Running executables"
---

> **TL;DR**
> 
> Add an `executable` stanza in your dune file and run the executable with `dune exec <executable_path>.exe` or `dune exec <public_name>`.

To tell dune to produce an executable, you can use the executable stanza:

```
(executable
 (name <executable_name>)
 (public_name <public_name>)
 (libraries <libraries...>))
```

The `<executable_name>` is the name of the executable used internally in the project.
The `<public_name>` is the name of the installed binary when installing the package.
Finally, `<libraries...>` is the list of libraries to link to the executable.

Once dune has produced the executable with `dune build`, you can execute it with `dune exec <executable_path>.exe` or `dune exec <public_name>`.

For instance, if you've put your dune file in `bin/dune` with the following content:

```
(executable
 (name main)
 (public_name my-app)
 (libraries))
```

You can run it with `dune exec bin/main.exe` or `dune exec my-app`.
