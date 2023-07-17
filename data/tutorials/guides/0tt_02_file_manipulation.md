---
id: file-manipulation
title: File Manipulation
description: >
  A guide to basic file manipulation in OCaml with the standard library
category: "Tutorials"
---

# File Manipulation

File manipulation includes operations such as creating new files and
directories, reading and writing from files, deleting files, etc.

In OCaml, these operations are handled through channels - abstract
representations of input/output devices, and the OCaml standard library provides
an array of functions to work with these channels.

In this tutorial, we will cover how to perform basic file operations in OCaml.
You will learn how to open and close channels, use these channels to read from
and write to files and interact with the filesystem. We'll also share some
important 'gotchas' to keep in mind while working with files in OCaml and how to
handle common user errors and exceptions.

To make the most of this tutorial, you should have some basic knowledge of
OCaml, including an [understanding of types, functions and values](data-types).
You should also have a basic understanding of how files work in the operating
system.

## Understanding Buffered Channels in OCaml

Before we dive into file operations, it's essential to grasp the concept of
"channels" and how they are used in OCaml.

In computer programming, **channels** are an abstract representation of input or
output devices. Think of them as the communication bridge between your program
and external files or devices.

A **buffered channel** is a type of channel that temporarily stores data in
memory before it is written to or read from a file on disk. This can improve
performance by reducing the number of disk accesses.

In OCaml, buffered channels form the basis of file manipulation. There are two
types of channels:

1. **`out_channel`:** This type of channel is used when you want to write to a
   file or an output device. It essentially represents a stream of data that
   your program sends out.
2. **`in_channel`:** Conversely, when you want to read from a file or an input
   device, you would use an `in_channel`. It represents a stream of incoming
   data that your program can process.

A key thing to note is that when you open a file for reading or writing in
OCaml, the function doesn't return a file descriptor like in some other
languages. Instead, it returns a channel that you can read from or write to.

In OCaml, standard process streams are also represented as channels. There are
two output channels of type `out_channel`:
- `stdout`: standard output, usually the console;
- `stderr`: standard error output.

There is an input channel, of type `in_channel` called `stdin`, which is the
standard input, typically keyboard input.

Now that you have a basic understanding of what channels are and their types, we
can start exploring how to read from and write to files using these channels.

## Writing to a File

Here's a complete example of writing to a file in OCaml:

```ocaml
let write_to_file () =
  (* Step 1: Open the File *)
  let oc = Out_channel.open_text "file.txt" in
  (* Step 2: Write to the Channel *)
  Out_channel.output_string oc "Hello, World!\n";
  (* Step 3: Flush the Channel *)
  Out_channel.flush oc;
  (* Step 4: Close the Channel *)
  Out_channel.close oc
```

Note that in practice, this is a shorter way to write a string to a file:

```ocaml
let () = Out_channel.with_open_text "file.txt" (fun oc ->
  Out_channel.output_string oc "Hello, World!\n")
```

Let's examine each step one by one.

**Step 1: Open the File**

```ocaml
let oc = Out_channel.open_text "file.txt" 
```

The function `Out_channel.open_text` is used to create an `out_channel` for
writing to the file. The file is open in `text` mode, as opposed to `binary`
mode. To open a file in `binary` mode, you can use the `Out_channel.open_bin`
function.

Here, the file `"file.txt"` is either created if it doesn't exist or opened and
truncated if it does. The returned `out_channel` is stored in the variable `oc`.

**Step 2: Write to the Channel**

```ocaml
Out_channel.output_string oc "Hello, World!\n"
```

Next, we write to the `out_channel` using the function
`Out_channel.output_string`. This function takes two parameters: the
`out_channel` to write to, and the string to write.

In this case, the string `"Hello, World!\n"` is written to the file through the
`oc` output channel.

**Step 3: Flush the Channel**

```ocaml
Out_channel.flush oc
```

To make sure that the data we've written to the `out_channel` is immediately
sent to the file, we flush the channel using `Out_channel.flush`. This function
takes the `out_channel` as a parameter and ensures that all buffered data is
written to the file.

Flushing the channel isn't strictly necessary in this case, since the channel is
flushed on closing. Internally, a channel is a buffer, it keeps its data in
memory and writes to the disk when it is full. Flushing is usually necessary
when multiple processes or threads access the channel in parallel.

**Step 4: Close the Channel**

```ocaml
Out_channel.close oc
```

Finally, after we're done writing to the file, we close the `out_channel` using
`Out_channel.close`. This function takes the `out_channel` as a parameter,
flushes any remaining buffered data to the file, and then closes the channel.
Closing the channel when you're done with it is crucial to free up system
resources.

## Reading from a File

Here's a complete example of reading from a file in OCaml:

```ocaml
let read_from_file () =
  (* Step 1: Open the File *)
  let ic = In_channel.open_text "file.txt" in
  (* Step 2: Read from the Channel *)
  let content = In_channel.input_all ic in
  (* Step 3: Close the Channel *)
  In_channel.close ic;
  content
```

Note that in practice, this is a shorter way to read all text content from a
file:

```ocaml
let content = In_channel.with_open_text "file.txt" In_channel.input_all
```

Let's examine each step one by one.


**Step 1: Open the File**

```ocaml
let ic = In_channel.open_text "file.txt"
```

The function`In_channel.open_text` is used to create an `in_channel` for
reading.

Here, the file `"file.txt"` is opened for reading and the returned `in_channel`
is stored in the variable `ic`.

**Step 2: Read from the Channel**

```ocaml
let content = In_channel.input_all ic
```

Next, we read from the `in_channel` using the function `In_channel.input_all`.
This function takes the `in_channel` as a parameter and reads the entire content
of the channel, and stores the read content in the variable `content`.

**Step 3: Close the Channel**


```ocaml
In_channel.close ic
```

After we're done reading from the file, we close the `in_channel` using
`In_channel.close`. This function takes the `in_channel` as a parameter and
closes it. Similar to the `out_channel`, closing the channel is important for
freeing up system resources.

## Filesystem Operations

OCaml provides various functions for filesystem operations, including renaming
and deleting files, and working with directories. In this section, we cover some
of these operations, which are part of the `Sys` and `Unix` modules from the
OCaml standard library.

### Renaming Files

To rename a file in OCaml, we use the `Sys.rename` function. This function
accepts two parameters: the current name of the file, and the new name you want
to assign.

```ocaml
Sys.rename "old_name.txt" "new_name.txt"
```
In this snippet, a file named `old_name.txt` is renamed to `new_name.txt`.

### Deleting Files

The `Sys.remove` function is used to delete a file in OCaml. This function takes
the name of the file you want to delete as its parameter.

```ocaml
Sys.remove "file_to_delete.txt"
```
Here, the file named `file_to_delete.txt` is deleted.

### Creating Directories

To create a new directory, you can use the `Unix.mkdir` function. This function
requires two parameters: the name of the new directory, and the permissions for
the directory (Unix-style octal format is often prefered).

```ocaml
Unix.mkdir "new_directory" 0o777
```
This command creates a new directory named `new_directory` with full permissions
(read, write, and execute for owner, group, and others).

### Listing Directory Contents

The `Sys.readdir` function is used to list the contents of a directory. The
function returns an array of filenames in the directory.

```ocaml
let files = Sys.readdir "directory" in
Array.iter print_endline files
```
In this example, all the file names in the `directory` are printed to the
console.

### Changing the Current Working Directory

You can change the current working directory using the `Sys.chdir` function.

```ocaml
Sys.chdir "/path/to/directory"
```
In this example, the current working directory is changed to
`/path/to/directory`.

### Retrieving the Current Working Directory

The current working directory can be retrieved using the `Sys.getcwd` function.

```ocaml
let cwd = Sys.getcwd ()
```
This code stores the current working directory in the `cwd` variable.

### Checking If a File or Directory Exists

You can check if a file or directory exists using the `Sys.file_exists`
function. This function takes a filename or a directory name as an argument and
returns a boolean indicating whether the file or directory exists.

```ocaml
if Sys.file_exists "file.txt" then
  print_endline "File exists."
else
  print_endline "File does not exist."
```

This code checks if `file.txt` exists and prints a message accordingly.

### Checking If a Path is a Directory

The `Sys.is_directory` function is used to check if a path points to a
directory. It takes a path as an argument and returns a boolean value indicating
whether the path is a directory.

```ocaml
if Sys.is_directory "/path/to/directory" then
  print_endline "It is a directory."
else
  print_endline "It is not a directory."
```

This code checks if `/path/to/directory` is a directory and prints a message
accordingly.

### Changing File Permissions

OCaml's `Unix` module provides a `chmod` function to change the permissions of a
file. The function takes a filename and the new permissions (in Unix-style octal
format) as arguments.

```ocaml
Unix.chmod "file.txt" 0o644
```

This code changes the permissions of `file.txt` to read and write for the owner
and read-only for the group and others.

### Getting File Size

The `Unix.stat` function can be used to get the size of a file. This function
returns a record with various file attributes, including its size.

```ocaml
let stats = Unix.stat "file.txt" in
print_int stats.Unix.st_size
```

This code gets the size of `file.txt` and prints it.

### Working with File Paths

OCaml's `Filename` module provides several functions to work with file paths.

```ocaml
let dir = Filename.dirname "/path/to/file.txt" in
let base = Filename.basename "/path/to/file.txt" in
let full = Filename.concat dir "new_file.txt" in
print_endline dir;
print_endline base;
print_endline full;
```

This code extracts the directory and base name from a path, and concatenates a
directory name with a base name.

### Creating Temporary Files and Directories

The `Filename` module also provides functions to create temporary files and
directories.

```ocaml
let temp_file = Filename.temp_file "prefix" ".suffix" in
let temp_dir = Filename.temp_dir "prefix" in
print_endline temp_file;
print_endline temp_dir;
```

This code creates a temporary file and a temporary directory, and prints their
paths.

## Error Handling

As with any operation involving I/O, file operations in OCaml can fail for a
variety of reasons, such as when a file does not exist, a directory cannot be
created due to insufficient permissions, or a disk is full. Handling such errors
is crucial to writing robust and resilient programs. This section will cover
some common error handling techniques in OCaml for file manipulation tasks.
General purpose error handling in OCaml is also addressed in
[dedicated tutorial](/docs/error-handling)

### Catching Exceptions

In OCaml, many of the file and directory operations can raise an exception when
they encounter an error. For example, trying to open a non-existent file with
`In_channel.open_text` will raise a `Sys_error` exception. Therefore, it's a
good practice to catch these exceptions and handle them accordingly.

Let's see how we can handle exceptions when reading from a file:

```ocaml
let read_from_file filename =
  try
    let ic = In_channel.open_text filename in
    let content = In_channel.input_all ic in
    In_channel.close ic;
    content
  with
  | Sys_error msg -> print_endline ("Could not read file: " ^ msg); ""
```

In this function, we use a `try ... with` block to catch any `Sys_error` that
might be raised when opening the file, reading its content, or closing it. If
such an exception is raised, we print an error message and return an empty
string.

### Checking Beforehand

Another way to avoid exceptions is to check beforehand whether an operation is
likely to succeed. For example, before opening a file, you can check whether it
exists and whether you have the necessary permissions to open it:

```ocaml
let read_from_file filename =
  if Sys.file_exists filename then
    let ic = In_channel.open_text filename in
    let content = In_channel.input_all ic in
    In_channel.close ic;
    content
  else
    print_endline ("File does not exist: " ^ filename); ""
```

This function checks whether the file exists before trying to open it. If the
file does not exist, it prints an error message and returns an empty string.

## Common Pitfalls

This section covers some frequent pitfalls when working with files in OCaml and
provides remedies to prevent them.

### Ensuring Immediate Writes: Flushing `out_channels`

OCaml buffers `out_channel` data and only writes it to the file when the buffer
is full or when the channel is closed. If immediate write to a file is needed,
you must explicitly flush the `out_channel` using the flush function.

Here's an example:

```ocaml
let oc = open_out "myfile.txt"
output_string oc "Hello, world!"
flush oc
```

### Remembering to Close Channels

When you open a file, the operating system allocates a file descriptor for it.
File descriptors are a limited resource, so it's important to release them when
you're done using them by closing the file. Furthermore, not closing an
`out_channel` might result in data loss, because some data might still be in the
buffer and not yet written to the file.

However, simply closing the file at the end of the function is not sufficient,
because if an exception is raised before the function reaches the point where it
closes the file, the file will remain open. You should therefore ensure that
files are always closed, even if an exception is raised. One way to do this is
to use a `try ... with` block:

```ocaml
let read_from_file filename =
  let ic = In_channel.open_text filename in
  try
    let content = In_channel.input_all ic in
    In_channel.close ic;
    content
  with exn ->
    In_channel.close ic;
    raise exn
```

In this function, if an exception is raised when calling `In_channel.input_all`,
the file is closed before the exception is re-raised.

Alternatively, you can use the `In_channel.with_open_*` or
`Out_channel.with_open_*` functions covered above, which will ensure that the
channel is closed if an exception is raised. The example above can be written as
below:

```ocaml
let read_from_file filename =
  In_channel.with_open_text filename In_channel.input_all
```

### Avoiding Namespace Conflicts with the Unix Module

The OCaml `Unix` module and the `Stdlib` module both provide access to standard
file descriptors with the same names like `stdin`, `stdout`, and `stderr`
leading to type errors. You can fully qualify the `Stdlib` module channels or
open the `Stdlib` module and use the unqualified names.

Examples:

```ocaml
let () =
  let oc = Stdlib.open_out "myfile.txt" in
  output_string oc "Hello, world!";
  Stdlib.flush oc;
  Stdlib.close_out oc

let () =
  open Stdlib
  let oc = open_out "myfile.txt" in
  output_string oc "Hello, world!";
  flush oc;
  close_out oc
```

### Be Aware of File Truncation with `open_out` and `open_out_bin`

The `open_out` and `open_out_bin` functions replace any existing file content
with new data. Use `open_out_gen` instead if you want to preserve the existing
content.

Example:

```ocaml
let () =
  let oc = open_out_bin "myfile.txt" in
  output_string oc "Initial data";
  close_out oc
let () =
  let oc = open_out_bin "myfile.txt" in
  output_string oc "New data";
  close_out oc
```

In the example above, the second call to `open_out_bin` deletes the string
`"Initial data"` and replaces it with `"New data"`. To preserve existing
content, use the `open_out_gen` function with the `Open_append` flag to append
the new content to the existing one.

## Advanced Topics

### File Permissions and Open Flags

You can specify the behaviour of the operating system when opening a file. For
instance, you specify the file permission of the file to be created, or whether
to clear the content if the file already exists.

Both the `In_channel` and `Out_channel` modules provide the `open_gen` function,
which accepts a list of open flags. The

Below, we'll break down each open flag and its usage:

- `Open_rdonly`: opens a file in read-only mode. You can only read from the
  file, and any attempt to write will result in an error.
- `Open_wronly`: opens a file in write-only mode. You can write to the file, but
  reading from the file is not allowed.
- `Open_append`: When this flag is set, the system will always write at the end
  of the file, appending new content instead of overwriting existing content.
- `Open_creat`: create the file if it does not already exist.
- `Open_trunc`: clear any existing content in the file.
- `Open_excl`: used with `Open_creat` to ensure a new file is created. If a file
  with the same name already exists, opening the file will fail.
- `Open_binary`: opens the file in binary mode, which allows binary data to be
  read from or written to the file without any conversions.
- `Open_text`: opens the file in text mode. Depending on the system's
  configuration, the system may perform conversions, such as replacing `'\n'`
  with the appropriate line ending sequence for the platform.
- `Open_nonblock`: opens the file in non-blocking mode, which allows operations
  to return immediately instead of waiting for the operation to finish.

These flags can be used in combination to provide precise control over how a
file is opened. For example, to open a file in binary mode for reading and
writing, allowing creation of the file if it doesn't exist, you could use
`Open_creat` along with `Open_binary` and `Open_wronly`:

```ocaml
let oc = Out_channel.open_gen [Open_wronly; Open_creat; Open_binary] 0o666 "myfile.bin"
```

In this example, `0o666` represents the permissions set for the file (read and
write permissions for user, group, and others), following the standard Unix
permission format.

### Reading from a File Line by Line

When dealing with large text files or when you need to process a file's content
line by line, reading the entire file into memory with a function like
`In_channel.input_all` is not always practical. Instead, you can use the
`In_channel.input_line` function to read from a file one line at a time. This
function reads a line from an `in_channel` and returns it as a string, excluding
the line termination character(s).

Here's a sample function that opens a file and prints out each line:

```ocaml
let print_lines_from_file filename =
  let rec print_line_from_channel ic =
    match In_channel.input_line ic with
    | Some line ->
      print_endline line;
      print_line_from_channel ic
    | None -> ()
  in
  In_channel.with_open_text filename print_line_from_channel
```

In this function, we use OCaml's pattern matching with the `input_line`
function. If `input_line` returns `Some line`, we print the line and recursively
call `print_line_from_channel` to continue reading the next line. If
`input_line` returns `None`, it means we've reached the end of the file, and we
end the recursion.

This approach of reading a file line by line is memory efficient as it only
keeps one line in memory at a time, making it suitable for processing large
files or streaming data.

## Conclusion

In this tutorial, we've covered how to manage files and filesystem operations in
OCaml. We discussed the role of channels and how to use the `In_channel` and
`Out_channel` modules for reading and writing files. We also touched upon
various filesystem operations, like renaming, deleting, and checking files.

In our exploration, we also detailed error handling in OCaml's file operations
and discussed common pitfalls. We further delved into advanced topics like
managing modes and file permissions, or how to avoid loading files in memory by
reading them line-by-line.

To dive deeper into file manipulation, you may be interested in exploring topics
we didn't cover in this tutorial. This includes binary file handling and
concurrent and parallel file access.

You can also refer to the OCaml Standard Library documentation, which contains a
lot more functions to manipulate file and work with the filesystem:

- [In_channel module](https://ocaml.org/api/In_channel.html)
- [Out_channel module](https://ocaml.org/api/Out_channel.html)
- [Sys module](https://ocaml.org/api/Sys.html)
- [Unix module](https://ocaml.org/api/Unix.html)
- [Filename module](https://ocaml.org/api/Filename.html)
