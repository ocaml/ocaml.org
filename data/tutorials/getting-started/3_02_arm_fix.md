---
id: arm64-fix
title: Fix Homebrew Errors on Apple M1
description: |
  This page will walk you through the workaround for ARM64 processors on newer Macs.
category: "Resources"
---

Since [Homebrew has changed](https://github.com/Homebrew/brew/issues/9177) the way it installs, sometimes the executable files cannot be found on macOS ARM64 M1. This might cause errors as you work through these tutorials. We want Homebrew to install ARM64 by default, so there are a few changes we need to make in order to do this.

Before we get started, let's check where Homebrew is installed. We can do this by running this in the CLI:

```shell
where brew
```

If the response is `/usr/local/bin/brew`, we'll need to make the changes. It needs to be `/opt/homebrew/bin/brew`.

## Install CLT

First, ensure the Command Line Tools (CLT) are installed by running

```shell
$ ls /Library/Developer/CommandLineTools
Library SDKs usr
```

If they're not installed, let's install them now. You don't have to install all of XCode; you can install just the CLT by [downloading them directly from Apple's Developer](https://developer.apple.com/download/all/). Look for a non-beta version for stability, like "Command Line Tools for XCode 14.3.1"

## Disable Rosetta

Next, it's necessary to disable Rosetta if you have it installed. This [Apple Support article](https://support.apple.com/en-us/HT211861) tells you how to check. If it's installed, please follow the steps below.

1. Uninstall Homebrew by running the following:

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall.sh)"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
```

1. Reinstall Homebrew:

```Shell
brew install /Users/tarides/Library/Caches/Homebrew/downloads/9e6d2a225119ad88cde6474d39696e66e4f87dc4a4d101243b91986843df691e--libev--4.33.arm64_monterey.bottle.tar.gz
```

1. Check to see if Homebrew is in the correct location now. It should return what's shown below:

```shell
$ which brew
/opt/homebrew/bin/brew
```

1. Close Terminal

It's essential to close your current Terminal window and open a new one for it to work properly. Then run the following command. If you get the output shown, you're ready to brew!

```shell
$ brew doctor
Your system is ready to brew.
```

## Return to Install Tutorial

Now that's all sorted, you can return to the [Install OCaml tutorial](/docs/installing-ocaml) to install and initialise opam.

You're all set to keep learning OCaml!
