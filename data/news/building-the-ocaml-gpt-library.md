---
title: 'Building the OCaml GPT library'
description: 'In this tutorial, we will explore the process I went through to build my first OCaml library.'
date: "2023-08-07"
preview_image:
featured:
authors:
- Pizie Dust
source:
---

## Introduction
In the world today, software development often demands efficient management of storage devices. One of the key players in this arena is the GUID Partitioning Table (GPT). In this tutorial, we'll go over the steps of how the [`ocaml-gpt`](https://github.com/PizieDust/ocaml-gpt) library was developed and what this means for the OCaml ecosystem, especially in the context of MirageOS, which is lacking in persistent storage capabilities. Through this `ocaml-gpt` library, developers will be able to seamlessly manage partitions in their block devices and disk images enabling enhanced control and reliability in storage management. 

## Background Research
Before diving into the technical details, let's understand the significance of GPT. The GUID Partitioning Table is a modern replacement for the older Master Boot Record (MBR) partitioning scheme. GPT offers advantages like support for larger disk sizes (up to 10 Billion TB), better data integrity, and the flexibility to accommodate more partitions (up to 128). Understanding the principles of GPT sets the stage for comprehending how the `ocaml-gpt` library simplifies its usage. Most of the information and the specifications on GPT were obtained from this Wikipedia article: [GUID Partition Table](https://en.wikipedia.org/wiki/GUID_Partition_Table). This article contains a lot of information specifically.

## Welcome to the World of Dune
[Dune](dune.build) is a build system for OCaml projects. In other words, Dune helps us setup a skeleton project we can use to build our library. It can be used to build executables, libraries, run tests, and much more, which is just perfect for our use case. Dune is absolutely awesome!

So let's dive in by installing Dune using the OCaml Package Manager, [opam](https://opam.ocaml.org/), which is like OCaml's version of Pip for Python or Composer for PHP:

```sh
opam install dune
```
After installation is complete, we can update our shell environment by running:

```sh
eval $(opam env)
```
At this point, we can initialise our project:

```sh
dune init proj ocaml-gpt
```
At which point you should see an error similar to this:

```sh
dune: NAME argument: invalid component name `ocaml-gpt'
      Library names must be non-empty and composed only of the
      following
      characters: 'A'..'Z', 'a'..'z', '_' or '0'..'9'.
Usage: dune init project [OPTION]… NAME [PATH]
Try 'dune init project --help' or 'dune --help' for more information.
```
This is because Dune uses `snake_case` and not `kebab-case`. A quick workaround (suggested by my mentor [Reynir](https://github.com/reynir)) is to generate the files and manually edit the `dune` files to use our `kebab-case` name. So we run the command again:

```sh
dune init proj ocaml_gpt
```
Running the command above will create the directory `ocaml_gpt` in our current working directory. We have to enter this directory to see which files have been generated:

```sh
cd ocaml_gpt
```
Our project folder should look like this:
```
├── _build
│   └── log
├── bin
│   ├── dune
│   └── main.ml
├── dune-project
├── lib
│   └── dune
├── ocaml_gpt.opam
└── test
    ├── dune
    └── ocaml_gpt.ml

4 directories, 8 files
```
Here, we can edit the `dune-project` file to specify some information about our project such as the author's name, package name, license, dependencies, etc. Ironically, `dune-project` is `kebab-case`.
So a quick breakdown of the different directories:
- The `bin` directory is where we can keep our executables and binaries.
- The `lib` directory is where we can keep our library files and main code.
- The `test` directory is where we can write our unit test.

For our project, we are using the following dependencies:
- OCaml (version 4.02 or later)
- Dune (build system)
- `uuidm` (library for UUID manipulation)
- `checkseum` (library for checksum calculations)
- `OCaml-cstruct` (library for working with C-like structures)
- `cmdliner` (librrary for )

## Breaking Down the Modules
If you read the GPT specification in the Wikipedia article, you will notice that the GPT header has a certain format to be followed. 

#### GPT Header Format
Below is a snippet from the Wikipedia article detailing the different components that make up the GPT header along with the various offsets, lengths, and content.
```
|   Offset  	|  Length  	|                                                                 Contents                                                                	|
|:---------:	|:--------:	|:---------------------------------------------------------------------------------------------------------------------------------------:	|
| 0 (0x00)  	| 8 bytes  	| Signature ("EFI PART", 45h 46h 49h 20h 50h 41h 52h 54h or 0x5452415020494645ULL[a] on little-endian machines)                           	|
| 8 (0x08)  	| 4 bytes  	| Revision number of header - 1.0 (00h 00h 01h 00h) for UEFI 2.10                                                                         	|
| 12 (0x0C) 	| 4 bytes  	| Header size in little endian (in bytes, usually 5Ch 00h 00h 00h or 92 bytes)                                                            	|
| 16 (0x10) 	| 4 bytes  	| CRC32 of header (offset +0 to +0x5b) in little endian, with this field zeroed during calculation                                        	|
| 20 (0x14) 	| 4 bytes  	| Reserved; must be zero                                                                                                                  	|
| 24 (0x18) 	| 8 bytes  	| Current LBA (location of this header copy)                                                                                              	|
| 32 (0x20) 	| 8 bytes  	| Backup LBA (location of the other header copy)                                                                                          	|
| 40 (0x28) 	| 8 bytes  	| First usable LBA for partitions (primary partition table last LBA + 1)                                                                  	|
| 48 (0x30) 	| 8 bytes  	| Last usable LBA (secondary partition table first LBA − 1)                                                                               	|
| 56 (0x38) 	| 16 bytes 	| Disk GUID in mixed endian[12]                                                                                                           	|
| 72 (0x48) 	| 8 bytes  	| Starting LBA of array of partition entries (usually 2 for compatibility)                                                                	|
| 80 (0x50) 	| 4 bytes  	| Number of partition entries in array                                                                                                    	|
| 84 (0x54) 	| 4 bytes  	| Size of a single partition entry (usually 80h or 128)                                                                                   	|
| 88 (0x58) 	| 4 bytes  	| CRC32 of partition entries array in little endian                                                                                       	|
| 92 (0x5C) 	| *        	| Reserved; must be zeroes for the rest of the block (420 bytes for a sector size of 512 bytes; but can be more with larger sector sizes) 	|
```
Using this, we can abstract our library into different modules: one module for our partitions and the other module for the header itself. 

#### Partition Module:
Partitions in the GPT header contain fields that we can organise as an OCaml record. This record encapsulates essential attributes of a partition entry. The fields we will be working with are:

- `type_guid`: This field stores the UUID (Universally Unique Identifier) that indicates the type of the partition. It provides information about the purpose and format of the partition.
- `partition_guid`: This field holds the UUID that uniquely identifies the partition. This identifier is unique within the context of the entire GPT table and helps distinguish one partition from another.
- `starting_lba`: This field is of type `int64` and represents the starting logical block address (LBA) of the partition. LBAs are used to locate data blocks on the storage device.
- `ending_lba`: This field is also of type `int64` and signifies the ending LBA of the partition. It marks the last block address occupied by the partition. Using the `starting_lba` and the `ending_lba` we can determine the size of the partition.
- `attributes`: This field is an `int64` that stores partition-specific attributes. These attributes provide additional information about the partition, such as whether it's bootable or whether it's required by the system.
- `name`: The name of the partition, represented as a `string`. This field stores a descriptive label for the partition, making it more user friendly.

When combined, these fields represent a partition entry in our GPT table. At this point, we now have to think of the methods in our module, namely for creating and parsing our partition entries. In our module we have functions for this:
- `make`: This function is used to create our partition entry. The output is a record of the different fields that make up a partition entry.
- `marshal`: We take a `Cstruct` record of our partition and convert it into a binary before, which can then be written unto a disk.
- `unmarshal`: The reverse of marshaling, where we take a binary buffer and extract a `Cstruct` record of it's representation.

#### GPT Module
This module defines a record type that represents the structure of the GPT header itself. Below is an explanation of the different fields and methods in this module:

- `signature`: A string that represents the GPT header signature, which is basically just `"EFI PART"`.
- `revision`: An integer that signifies the revision of the GPT standard. In most cases, it's set to `0x010000`.
- `header_size`: The size of the GPT header in bytes.
- `header_crc32`: A cyclic redundancy check (`CRC32`) value calculated over the header's contents, excluding this field itself.
- `reserved`: A reserved field.
- `current_lba`: The logical block address (LBA) of the current GPT header.
- `backup_lba`: The LBA of the backup GPT header.
- `first_usable_lba`: The LBA where partitions can start.
- `last_usable_lba`: The last LBA available for partitions.
- `disk_guid`: The UUID that uniquely identifies the disk.
- `partition_entry_lba`: The LBA of the start of the partition entries.
- `num_partition_entries`: The number of partition entries in the GPT.
- `partitions`: A list of partition entries, each of type `Partition.t` gotten from the Partition module.
- `partition_size`: The size of an individual partition entry in bytes.
- `partitions_crc32`: A `CRC32` value calculated over the contents of the partition entries.

With our fields, we can now define the different methods to compute our GPT header:
- `calculate_header_crc32`: Calculates the CRC32 checksum for the GPT header.
- `calculate_partition_crc32`: Calculates the CRC32 checksum for the list of partition entries.
- `make`: Construct a GPT header based on the provided list of partition entries.
- `unmarshal`: Parses the binary buffer to create a GPT header record.
- `marshal`: Fills a binary buffer with the values from the GPT header record.

At this point, all that's left to do is code our modules, types, and methods.

## Writing Test
Tests are a great way to verify that our code is working as we expect it to. It also helps maintain a standard as we continue updating our code. Writing Unit tests are definitely important.
In our project, we are using the [`Alcotest`](https://ocaml.org/p/alcotest/latest) library to conduct our tests. This is an awesome library, and many thanks to [Craig Ferguson](https://www.craigfe.io/) for creating this beautiful package and the whole OCaml open-source community for maintaining it.

Using `Alcotest`, we can test different parts of our code and even the different functions we have in our code. For our library, we wrote the following test:

- `test_make_partition`: Tests the creation of a partition using the `Partition.make` function.
- `test_make_partition_wrong_type_guid`: Tests the scenario where an invalid GUID type is provided to create a partition.
- `test_make_gpt_no_partitions`: Tests the creation of a GPT table with no partitions.
- `test_make_gpt_too_many_partitions`: Tests the case when trying to create a GPT table with more than the allowed number of partitions.
- `test_make_gpt_overlapping_partitions`: Tests the creation of a GPT table with overlapping partitions, which should result in an error.
- `test_make_gpt_sorted_partitions`: Tests the creation of a GPT table with properly sorted partitions and verified that the generated tables are equal.

After writing our test, we can run them using:

```
dune runtest
```

In our case, our tests are running correctly producing the output:

```
Testing `OCaml GPT'.
This run has ID `ZZG9RBT8'.

  [OK]          Test GPT Partitions          0   correct-partition.
  [OK]          Test GPT Partitions          1   wrong-type_guid.
  [OK]          Test GPT Header              0   gpt-empty-partitions.
  [OK]          Test GPT Header              1   gpt-too-many-partitions.
  [OK]          Test GPT Header              2   gpt-overlapping-partitions.
  [OK]          Test GPT Header              3   gpt-sorted-partitions.

Full test results in `~/xxxx/xxxx/ocaml_gpt/_build/default/test/_build/_tests/OCaml GPT'.
Test Successful in 0.002s. 6 tests run.
```

## A Few Executables

After building our library, we can also go a step further by creating tools that we can use to manipulate real block devices using our library. Tools such as listing the GPT header in a disk, resising a partition, creating a partition, etc.

I want to give a special thanks to [Daniel Bünzli](https://github.com/dbuenzli) for creating the `Cmdliner` package, which allows the declarative definition of command line interfaces for OCaml. Using this package, we can build a nice command line interface for our executables.

In our project, we can create our binary executables in the `bin` directory.
For our project, we have created the `gpt_inspect` executable which should list the contents of a GPT header on a block device. 
After creating our executable, we can run it with:

```
dune exec -- bin/gpt_inspect.exe disk.img 
```
where `disk.img` is the disk or block device

## The Future
We can definitely build more tools for this library and especially how we can integrate it into the larger ecosystem of MirageOS. I believe this library brings us one step closer to having persistent storage in MirageOS unikernels. 

This was my first time building a package in OCaml, and the experience is definitely worth it. 

A special big thanks to my mentor [Reynir Björnsson](https://robur.coop/), who was always available when I hit blocking issues. Thank you, Reynir.


