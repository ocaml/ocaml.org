---
title: Binary distribution with 0install
description: 0install provides an easy way to distribute binaries to users, complementing OPAM's support for source distribution.
date: "2014-10-14"
authors: [ "Thomas Leonard" ]
---

[0install][] provides an easy way to distribute binaries to users, complementing OPAM's support for source distribution.

The traditional way to distribute binaries is to make separate packages for recent versions of the more popular Linux distributions (RPMs, Debs, PKGBUILDs, etc), a `.pkg` for OS X, a `setup.exe` Windows, etc, plus some generic binaries for users of other systems or who lack root privileges.
This requires a considerable amount of work, and expertise with many different package formats.
0install provides a single format that supports all platforms, meaning that you only need to do the packaging work once (though you should still *test* on multiple platforms).

# Example: OPAM binaries

You can install a binary release of OPAM on most systems by first installing the "0install" package from your distribution ("zeroinstall-injector" on older distributions) and then adding OPAM.

1. [Get 0install][0install-downloads]. For the major Linux distributions:

        $ yaourt -S zeroinstall-injector             # Arch Linux
        $ sudo apt-get install zeroinstall-injector  # Debian, Ubuntu, etc
        $ sudo yum install 0install                  # Fedora
        $ sudo yum install zeroinstall-injector      # Red Hat
        $ sudo zypper install zeroinstall-injector   # OpenSUSE

    For OS X: [ZeroInstall.pkg](http://downloads.sourceforge.net/project/zero-install/0install/2.7/ZeroInstall.pkg)

    0install also has [Windows support][0install-windows], but there is currently no Windows binary of OPAM so I didn't publish one with 0install either.

2. Install opam:

        $ 0install add opam https://tools.ocaml.org/opam.xml
        $ opam --version
        1.1.1

	If you already have an `opam` command but want to try the `0install` version anyway,
	just give it a different name (e.g., `0install add 0opam https://tools.ocaml.org/opam.xml` to create a `0opam` command).

`0install add` will open a window if a display is available, or show progress on the console if not:

![](0install-opam.png)

If you want to use the console in all cases, use `--console`.

0install identifies each package with a full URI rather than with a short name.
Here, we are telling 0install to create a local command called `opam` that runs the program <https://tools.ocaml.org/opam.xml>.

0install keeps each package it installs in a separate directory where it won't conflict with anything.
You can see where it put OPAM with the "show" command:

    $ 0install show opam
    - URI: https://tools.ocaml.org/opam.xml
      Version: 1.1.1
      Path: /home/test/.cache/0install.net/implementations/sha256new_RUOX6PWGDCHH5TDNEDRHQJ54YZZ4TSAGBB5AEBRNOKSHM3N7XORA
      
      - URI: http://repo.roscidus.com/utils/aspcud
        Version: 1.9.0
        Path: /home/test/.cache/0install.net/implementations/sha1new=5f838f78e489dabc2e2965ba100f14ae8350cbce
      
      - URI: http://repo.roscidus.com/utils/curl
        Version: 7.32.0-10.20
        Path: (package:rpm:curl:7.32.0-10.20:x86_64)

OPAM depends on two other programs: `aspcud` provides a better solver than the internal one and `curl` is used to download OPAM packages (it also generally needs `gcc`, `m4` and `patch`, but I started with just the ones people are likely to be missing).
In this case, 0install has satisfied the curl dependency using an official Fedora package, but needed to install aspcud using 0install. On Arch Linux, it can use distribution packages for both.
0install will install any required distribution packages using PackageKit, which will prompt the user for permission according to its policy.

You can upgrade (or downgrade) the package by adding a version constraint.
By default, 0install prefers the "stable" version of a program:

    $ 0install update opam
    A later version (https://tools.ocaml.org/opam.xml 1.2.0-pre4) exists but was not selected.
    Using 1.1.1 instead.
    To select "testing" versions, use:
    0install config help_with_testing True

You could do as it suggests and tell it to prefer testing versions globally, or you can add a version constraint if you just want to affect this one program:

    $ 0install update opam --not-before=1.2.0-pre4
    https://tools.ocaml.org/opam.xml: 1.1.1 -> 1.2.0-pre4
    
You can also specify an upper bound (`--before`) or a fixed version (`--version`) if you prefer.
You can control the versions of dependencies with `--version-for`.
By the way, 0install supports tab-completion everywhere: it can do completion on the sub-command (`update`), the application name (`opam`), the option (`--not-before`) and even the list of available versions!

Finally, if an upgrade stops a program from working then you can use `whatchanged` to see the latest changes:

    $ 0install whatchanged opam
    Last checked    : 2014-08-26 11:00
    Last update     : 2014-08-26
    Previous update : 2014-07-03

    https://tools.ocaml.org/opam.xml: 1.1.1 -> 1.2.0-pre4

    To run using the previous selections, use:
    0install run /home/tal/.config/0install.net/apps/opam/selections-2014-07-03.xml

Note: this has a granularity of a day, so you won't see any changes if you're following along, since you didn't have it installed yesterday.

## The Package Metadata

If you visit <https://tools.ocaml.org/opam.xml> you should see a normal-looking web-page describing the package.
If you view the source in your browser, you'll see that it's actually an XML document with a stylesheet providing the formatting.
Here's an extract:

    <group license="OSI Approved :: GNU Lesser General Public License (LGPL)">
      <group>
        <requires interface="http://repo.roscidus.com/utils/aspcud"
                  importance="recommended">
          <executable-in-var name="OPAMEXTERNALSOLVER"/>
        </requires>

        <requires interface="http://repo.roscidus.com/utils/curl"
                  importance="recommended">
          <executable-in-var name="OPAMCURL"/>
        </requires>

        <command name="run" path="opam"/>

        <implementation arch="Linux-x86_64"
                        id="sha1new=6e16ff6ee58e39c9ebbed2fb6c6b6cc437b624a4"
                        released="2014-04-17"
                        stability="stable"
                        version="1.1.1">
          <manifest-digest sha256new="RUOX6PWGDCHH5TDNEDRHQJ54YZZ4TSAGBB5AEBRNOKSHM3N7XORA"/>
          <archive href="http://test.roscidus.com/archives/opam-Linux-x86_64-1.1.1.tgz"
                   size="1476315"/>
        </implementation>

This says that the 64-bit Linux binary for OPAM 1.1.1 is available at the given URL and, when unpacked, has the given SHA256 digest.
It can be run by executing the `opam` binary within the archive.
It depends on `aspcud` and `curl`, which live in other repositories (ideally, these would be the official project sites for these programs, but currently they are provided by a third party).
In both cases, we tell OPAM about the chosen version by setting an environment variable.
The `<group>` elements avoid repeating the same information for multiple versions.
`curl` is marked as `recommended` because, while [0install supports most distribution package managers][0install-distro-int], if it can't find a curl package then it's more likely that it failed to find the curl package than that the platform doesn't have curl.

Lower down there is a more complex entry saying how to build from source, which provides a way to generate more binaries, and
the XML is followed by a GPG signature block (formatted as an XML comment so that the document is still valid XML).

## Security

When you use a program for the first time, 0install downloads the signing GPG key and checks it with the key information service.
If this service knows the key, it saves it as a trusted key for that site.
If not, it prompts you to confirm.
In future, it will check that all updates from that site are signed with the same key, prompting you if not (much like `ssh` does).

If you would like to see the key information hints rather than having them approved automatically, use `0install config auto_approve_keys false` or turn off "Automatic approval for new feeds" in the GUI, and untrust the key (right-click on it for a menu):

![](0install-keys.png)

You will then see prompts like this when using a new site for the first time:

![](0install-key-confirm.png)

## Making packages

Ideally, OPAM's own Git repository would contain an XML file describing its build and runtime dependencies (`curl` and `aspcud` in this case) and
how to build binaries from it.
We would then generate the XML for releases from it automatically using tools such as [0release][].
However, when trying out 0install you may prefer to package up an existing binary release, and this is what I did for OPAM.

The simplest case is that the binary is in the current directory.
In this case, the XML just describes its dependencies and how to run it, but not how to download the program.
You can create a template XML file using [0template][] (or just write it yourself):

    $ 0install add 0template http://0install.net/tools/0template.xml
    $ 0template opam.xml
    'opam.xml' does not exist; creating new template.

    As it ends with .xml, not .xml.template, I assume you want a feed for
    a local project (e.g. a Git checkout). If you want a template for
    publishing existing releases, use opam.xml.template instead.

    Does your program need to be compiled before it can be used?

    1) Generate a source template (e.g. for compiling C source code)
    2) Generate a binary template (e.g. for a pre-compiled binary or script)
    > 2

    Writing opam.xml

Filling in the blanks, we get:

    <?xml version="1.0"?>
    <interface xmlns="http://zero-install.sourceforge.net/2004/injector/interface">
      <name>OPAM</name>
      <summary>OCaml package manager</summary>

      <description>
        OPAM is an open-source package manager edited by OCamlPro.
        It supports multiple simultaneous compiler installations, flexible
        package constraints, and a Git-friendly development workflow.
      </description>

      <homepage>https://opam.ocaml.org/</homepage>

      <feed-for interface="https://tools.ocaml.org/opam.xml"/>

      <group license="OSI Approved :: GNU Lesser General Public License (LGPL)">
        <requires importance="recommended" interface="http://repo.roscidus.com/utils/aspcud">
          <executable-in-var name="OPAMEXTERNALSOLVER"/>
        </requires>

        <requires importance="recommended" interface="http://repo.roscidus.com/utils/curl">
          <executable-in-var name="OPAMCURL"/>
        </requires>

        <command name="run" path="opam"/>

        <implementation arch="Linux-x86_64" id="." local-path="." version="1.1.1"/>
      </group>
    </interface>

This is almost the same as the XML above, except that we specify `local-path="."` rather than giving a URL and digest
(see the [Feed file format specification][0install-feed-spec] for details).
The `<feed-for>` says where we will eventually host the public list of all versions.

You can test your XML locally like this:

    $ 0install run opam.xml --version
    1.1.1

    $ 0install select opam.xml          
    - URI: /tmp/opam/opam.xml
      Version: 1.1.1
      Path: /tmp/opam
      
      - URI: http://repo.roscidus.com/utils/aspcud
        Version: 1.9.0-1
        Path: (package:arch:aspcud:1.9.0-1:x86_64)
      
      - URI: http://repo.roscidus.com/utils/curl
        Version: 7.37.1-1
        Path: (package:arch:curl:7.37.1-1:x86_64)

Now we need a way to generate similar XML for released archives on the web.
Rename `opam.xml` to `opam.xml.template` and change the `<implementation>` to:

    <implementation arch="{arch}" version="{version}">
      <manifest-digest/>
      <archive href="http://example.com/archives/opam-{arch}-{version}.tgz"/>
    </implementation>

If the archive is already published somewhere, you can use the full URL in the `<archive>`.
If you're making a new release locally, just put the archive in the same directory as the XML and give the leaf only (`href="opam-{arch}-{version}.tgz"`).

You can now run `0template` on the template XML to generate the XML with the hashes, sizes, etc, filled in:

    $ 0template opam.xml.template version=1.1.1 arch=Linux-x86_64
    Writing opam-1.1.1.xml

This generates:


    <group license="OSI Approved :: GNU Lesser General Public License (LGPL)">
      <requires importance="recommended" interface="http://repo.roscidus.com/utils/aspcud">
        <executable-in-var name="OPAMEXTERNALSOLVER"/>
      </requires>

      <requires importance="recommended" interface="http://repo.roscidus.com/utils/curl">
        <executable-in-var name="OPAMCURL"/>
      </requires>

      <command name="run" path="opam"/>

      <implementation arch="Linux-x86_64"
                      id="sha1new=6e16ff6ee58e39c9ebbed2fb6c6b6cc437b624a4"
                      released="2014-08-26"
                      version="1.1.1">
        <manifest-digest sha256new="RUOX6PWGDCHH5TDNEDRHQJ54YZZ4TSAGBB5AEBRNOKSHM3N7XORA"/>
        <archive href="http://example.com/archives/opam-Linux-x86_64-1.1.1.tgz" size="1476315"/>
      </implementation>
    </group>

You can test this as before:

    $ 0install run opam-1.1.1.xml --version
    1.1.1

Finally, you can submit the XML to a repository (which is easy to host yourself) using the [0repo][] tool:

    $ 0install add 0repo http://0install.net/tools/0repo.xml
    [ ... configure your repository ... ]
    $ 0repo add opam-1.1.1.xml

0repo will merge the XML into the repository's master list of versions, upload the archive (or test the URL, if already uploaded), commit the final XML to Git, and push the XML to your web server.
There are simpler ways to get the signed XML, e.g. using [0publish-gui][] for a graphical UI, but
if you're going to release more than one version of one program then the automation (and sanity checking) you get from 0repo is usually worth it.
In my case, I configured 0repo to push the signed XML to a GitHub Pages repository.

There are plenty of ways to extend this.
For the OPAM 1.2 release, instead of adding the official binaries one by one, I used 0template to make a template for the source code,
added the 1.2 source release, and used that to generate the binaries (mainly because I wanted to build in an older docker container so the binaries would work on more systems).
For my own software, I commit an XML file saying how to build it to my Git repository and let [0release][] handle the whole release process (from tagging the Git repository, to building the binaries in various VMs, to publishing the archives and the final signed XML).
In the future, we hope to integrate this with OPAM so that source and binary releases can happen together.

## Extending 0install

0install is easy to script.
It has a stable command line interface (and a new [JSON API][0install-json] too).
There is also an OCaml API, but this is not yet stable (it's still rather Pythonic, as the software was recently [ported from Python][0install-from-python]).

For example, I have used 0install to manage Xen images of [Mirage unikernels][mirage].
This command shows the latest binary of the `mir-hello` unikernel for Xen (downloading it first if needed):

    $ 0install download --os=Xen http://test.roscidus.com/mir-console.xml --show
    - URI: http://test.roscidus.com/mir-console.xml
      Version: 0.2
      Path: /home/tal/.cache/0install.net/implementations/sha256new_EY2FDE4ECMNCXSRUZ3BSGTJQMFXE2U6C634PBDJKOBUU3SWD5GDA

## Summary

0install is a mature cross-platform system for managing software that is included in the repositories of most Linux distributions and is also available for Windows, OS X and Unix.
It is useful to distribute binary executables in cases where users shouldn't have to compile from source.
It supports GPG signature checking, automatic updates, pinned versions and parallel installations of multiple versions.
A single package format is sufficient for all platforms (you still need to create separate binary archives for e.g. OS X and Linux, of course).

0install is a decentralised system, meaning that there is no central repository.
Packages are named by URI and the metadata is downloaded directly from the named repository.
There are some extra services (such as the [default mirror service][0mirror], the search service and the key information service), but these are all optional.

Using 0install to get OPAM means that all platforms can be supported without the need to package separately for each one, and users who don't wish to install as root still get signature checking, dependency handling and automatic updates.
We hope that 0install will make it easier for you to distribute binaries of your own applications.

My talk at OCaml 2014 ([video][ocaml2014-video], [slides][ocaml2014-slides]) gives more information about 0install and its conversion to OCaml.

[0install]: http://0install.net/
[0install-downloads]: http://0install.net/injector.html
[0install-windows]: https://0install.de/downloads/
[0install-distro-int]: http://0install.net/distribution-integration.html
[0install-feed-spec]: http://0install.net/interface-spec.html
[0install-from-python]: http://roscidus.com/blog/blog/2014/06/06/python-to-ocaml-retrospective/
[0install-json]: http://0install.net/json-api.html
[0publish-gui]: http://0install.net/packaging-binaries.html
[0repo]: http://0install.net/0repo.html
[0release]: http://0install.net/0release.html
[0template]: http://0install.net/0template.html
[0mirror]: http://roscidus.com/0mirror/
[opam-quick-install]: https://opam.ocaml.org/doc/Quick_Install.html
[mirage]: http://openmirage.org/
[ocaml2014-slides]: https://ocaml.org/meetings/ocaml/2014/0install-slides.pdf
[ocaml2014-video]: https://www.youtube.com/watch?v=dYRT6z0NGII&list=UUP9g4dLR7xt6KzCYntNqYcw
