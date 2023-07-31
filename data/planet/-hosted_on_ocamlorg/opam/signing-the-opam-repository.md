---
title: "Signing the OPAM repository"
authors: [ "Louis Gesbert", "Hannes Mehnert" ]
date: 2015-06-05T00:00:00-00:00
description: "Proposal for a secure distribution of OCaml packages"
source:
  name: Opam blog
  url: ""
  tag: "personnal blog"
---

> NOTE (September 2016): updated proposal from OCaml 2016 workshop is
> [available](https://github.com/hannesm/conex-paper/blob/master/paper.pdf),
> including links to prototype implementation.

> This is an initial proposal on signing the OPAM repository. Comments and
> discussion are expected on the
> [platform mailing-list](https://lists.ocaml.org/listinfo/platform).

The purpose of this proposal is to enable a secure distribution of
OCaml packages. The package repository does not have to be trusted if
package developers sign their releases.

Like [Python's pip][python-tuf], [Ruby's gems][ruby-tuf] or more recently
[Haskell's hackage][haskell-tuf], we are going to implement a flavour of The
Upgrade Framework ([TUF][tuf]). This is good because:

- it has been designed by people who [know the stuff][thandy] much better than
  us
- it is built upon a threat model including many kinds of attacks, and there are
  some non-obvious ones (see the [specification][tuf-spec], and below)
- it has been thoroughly reviewed
- following it may help us avoid a lot of mistakes

Importantly, it doesn't enforce any specific cryptography, allowing us to go
with what we have [at the moment][nocrypto] in native OCaml, and evolve later,
_e.g._ by allowing ed25519.

There are several differences between the goal of TUF and opam, namely
TUF distributes a directory structure containing the code archive,
whereas opam distributes metadata about OCaml packages. Opam uses git
(and GitHub at the moment) as a first class citizen: new packages are
submitted as pull requests by developers who already have a GitHub
account.

Note that TUF specifies the signing hierarchy and the format to deliver and
check signatures, but allows a lot of flexibility in how the original files are
signed: we can have packages automatically signed on the official repository, or
individually signed by developers. Or indeed allow both, depending on the
package.

Below, we tried to explain the specifics of our implementation, and mostly the
user and developer-visible changes. It should be understandable without prior
knowledge of TUF.

We are inspired by [Haskell's adjustments][haskell-tuf-git] (and
[e2e][haskell-tuf-e2e]) to TUF using a git repository for packages. A
signed repository and signed packages are orthogonal. In this
proposal, we aim for both, but will describe them independently.

## Threat model

- An attacker can compromise at least one of the package distribution
  system's online trusted keys.

- An attacker compromising multiple keys may do so at once or over a
  period of time.

- An attacker can respond to client requests (MITM or server
  compromise) during downloading of the repository, a package, and
  also while uploading a new package release.

- An attacker knows of vulnerabilities in historical versions of one or
  more packages, but not in any current version (protecting against
  zero-day exploits is emphatically out-of-scope).

- Offline keys are safe and securely stored.

An attacker is considered successful if they can cause a client to
build and install (or leave installed) something other than the most
up-to-date version of the software the client is updating. If the
attacker is preventing the installation of updates, they want clients
to not realize there is anything wrong.

## Attacks

- Arbitrary package: an attacker should not be able to provide a package
  they created in place of a package a user wants to install (via MITM
  during package upload, package download, or server compromise).

- Rollback attacks: an attacker should not be able to trick clients into
  installing software that is older than that which the client
  previously knew to be available.

- Indefinite freeze attacks: an attacker should not be able to respond
  to client requests with the same, outdated metadata without the
  client being aware of the problem.

- Endless data attacks: an attacker should not be able to respond to
  client requests with huge amounts of data (extremely large files)
  that interfere with the client's system.

- Slow retrieval attacks: an attacker should not be able to prevent
  clients from being aware of interference with receiving updates by
  responding to client requests so slowly that automated updates never
  complete.

- Extraneous dependencies attacks: an attacker should not be able to
  cause clients to download or install software dependencies that are
  not the intended dependencies.

- Mix-and-match attacks: an attacker should not be able to trick clients
  into using a combination of metadata that never existed together on
  the repository at the same time.

- Malicious repository mirrors: should not be able to prevent updates
  from good mirrors.

- Wrong developer attack: an attacker should not be able to upload a new
  version of a package for which they are not the real developer.

## Trust

A difficult problem in a cryptosystem is key distribution. In TUF and
this proposal, a set of root keys are distributed with opam. A
threshold of these root keys needs to sign (transitively) all keys
which are used to verify opam repository and its packages.

### Root keys

The root of trust is stored in a set of root keys. In the case of the official
opam OCaml repository, the public keys are to be stored in the opam source,
allowing it to validate the whole trust chain. The private keys will be held by
the opam and repository maintainers, and stored password-encrypted, securely
offline, preferably on unplugged storage.

They are used to sign all the top-level keys, using a quorum. The quorum has
several benefits:

- the compromise of a number of root keys less than the quorum is harmless
- it allows to safely revoke and replace a key, even if it was lost

The added cost is more maintenance burden, but this remains small since these
keys are not often used (only when keys are going to expire, were compromised or
in the event new top-level keys need to be added).

The initial root keys could be distributed as such:
- Louis Gesbert, opam maintainer, OCamlPro
- Anil Madhavapeddy, main repository maintainer, OCaml Labs
- Thomas Gazagnaire, main repository maintainer, OCaml Labs
- Grégoire Henry, OCamlPro safekeeper
- Someone in the OCaml team ?

Keys will be set with an expiry date so that one expires each year in turn,
leaving room for smooth rollover.

For other repositories, there will be three options:
- no signatures (backwards compatible ?), _e.g._ for local network repositories.
  This should be allowed, but with proper warnings.
- trust on first use: get the root keys on first access, let the user confirm
  their fingerprints, then fully trust them.
- let the user manually supply the root keys.

### End-to-end signing

This requires the end-user to be able to validate a signature made by the
original developer. There are two trust paths for the chain of trust (where
"&rarr;" stands for "signs for"):

- (_high_) root keys &rarr;
  repository maintainer keys &rarr; (signs individually)
  package delegation + developer key &rarr;
  package files
- (_low_) root keys &rarr;
  snapshot key &rarr; (signs as part of snapshot)
  package delegation + developer key &rarr;
  package files

It is intended that packages may initially follow the _low_ trust path, adding
as little burden and delay as possible when adding new packages, and may then be
promoted to the _high_ path with manual intervention, after verification, from
repository maintainers. This way, most well-known and widely used packages will
be provided with higher trust, and the scope of an attack on the low trust path
would be reduced to new, experimental or little-used packages.

### Repository signing

This provides consistent, up-to-date snapshots of the repository, and protects
against a whole different class of attacks than end-to-end signing (_e.g._
rollbacks, mix-and-match, freeze, etc.)

This is done automatically by a snapshot bot (might run on the repository
server), using the _snapshot key_, which is signed directly by the root keys,
hence the chain of trust:

- root keys &rarr;
  snapshot key &rarr;
  commit-hash

Where "commit-hash" is the head of the repository's git repository (and thus a
valid cryptographic hash of the full repository state, as well as its history)

#### Repository maintainer (RM) keys

Repository maintainers hold the central role in monitoring the repository and
warranting its security, with or without signing. Their keys (called _targets
keys_ in the TUF framework) are signed directly by the root keys. As they have a
high security potential, in order to reduce the consequences of a compromise, we
will be requiring a quorum for signing sensitive operations

These keys are stored password-encrypted on the RM computers.

#### Snapshot key

This key is held by the _snapshot bot_ and signed directly by the root keys. It
is used to guarantee consistency and freshness of repository snapshots, and does
so by signing a git commit-hash and a time-stamp.

It is held online and used by the snapshot bot for automatic signing: it has
lower security than the RM keys, but also a lower potential: it can not be used
directly to inject malicious code or metadata in any existing package.

#### Delegate developer keys

These keys are used by the package developers for end-to-end signing. They can
be generated locally as needed by new packagers (_e.g._ by the `opam-publish`
tool), and should be stored password-encrypted. They can be added to the
repository through pull-requests, waiting to be signed (i) as part of snapshots
(which also prevents them to be modified later, but we'll get to it) and (ii)
directly by RMs.

#### Initial bootstrap

We'll need to start somewhere, and the current repository isn't signed. An
additional key, _initial-bootstrap_, will be used for guaranteeing integrity of
existing, but yet unverified packages.

This is a one-go key, signed by the root keys, and that will then be destroyed.
It is allowed to sign for packages without delegation.

### Trust chain and revocation

In order to build the trust chain, the opam client downloads a `keys/root` key
file initially and before every update operation. This file is signed by the
root keys, and can be verified by the client using its built-in keys (or one of
the ways mentioned above for unofficial repositories). It must be signed by a
quorum of known root keys, and contains the comprehensive set of root, RM,
snapshot and initial bootstrap keys: any missing keys are implicitly revoked.
The new set of root keys is stored by the opam client and used instead of the
built-in ones on subsequent runs.

Developer keys are stored in files `keys/dev/<id>`, self-signed, possibly RM
signed (and, obviously, snapshot-signed). The conditions of their verification,
removal or replacement are included in our validation of metadata update (see
below).


## File formats and hierarchy

### Signed files and tags

The files follow the opam syntax: a list of _fields_ `fieldname:` followed by
contents. The format is detailed in [opam's documentation][opam-format].

The signature of files in opam is done on the canonical textual representation,
following these rules:
- any existing `signature:` field is removed
- one field per line, ending with a newline
- fields are sorted lexicographically by field name
- newlines, backslashes and double-quotes are escaped in string literals
- spaces are limited to one, and to these cases: after field leaders
  `fieldname:`, between elements in lists, before braced options, between
  operators and their operands
- comments are erased
- fields containing an empty list, or a singleton list containing an empty
  list, are erased

The `signature:` field is a list with elements in the format of string triplets
`[ "<keyid>" "<algorithm>" "<signature>" ]`. For example:

```opam
opam-version: "1.2"
name: "opam"
signature: [
  [ "louis.gesbert@ocamlpro.com" "RSASSA-PSS" "048b6fb4394148267df..." ]
]
```

Signed tags are git annotated tags, and their contents follow the same rules. In
this case, the format should contain the field `commit:`, pointing to the
commit-hash that is being signed and tagged.

### File hierarchy

The repository format is changed by the addition of:
- a directory `keys/` at the root
- delegation files `packages/<pkgname>/delegate` and
  `compilers/<patchname>.delegate`
- signed checksum files at `packages/<pkgname>/<pkgname>.<version>/signature`

Here is an example:

```
repository root /
|--packages/
|  |--pkgname/
|  |  |--delegation                    - signed by developer, repo maintainer
|  |  |--pkgname.version1/
|  |  |  |--opam
|  |  |  |--descr
|  |  |  |--url
|  |  |  `--signature                  - signed by developer1
|  |  `--pkgname.version2/ ...
|  `--pkgname2/ ...
|--compilers/
|  |--version/
|  |  |--version+patch/
|  |  |  |--version+patch.comp
|  |  |  |--version+patch.descr
|  |  |  `--version+patch.signature
|  |  `--version+patch2/ ...
|  |--patch.delegate
|  |--patch2.delegate
|  `--version2/ ...
`--keys/
   |--root
   `--dev/
      |--developer1-email              - signed by developer1,
      `--developer2-email ...            and repo maint. once verified
```

Keys are provided in different files as string triplets
`[ [ "keyid" "algo" "key" ] ]`. `keyid` must not conflict with any
previously-defined keys, and `algo` may be "rsa" and keys encoded in PEM format,
with further options available later.

For example, the `keys/root` file will have the format:
```
date: "2015-06-04T13:53:00Z"
root-keys: [ [ "keyid" "{expire-date}" "algo" "key" ] ]
snapshot-keys: [ [ "keyid" "algo" "key" ] ]
repository-maintainer-keys: [ [ "keyid" "algo" "key" ] ]
```

This file is signed by current _and past_ root keys -- to allow clients to
update. The `date:` field provides further protection against rollback attacks:
no clients may accept a file with a date older than what they currently have.
Date is in the ISO 8601 standard with 0 UTC offset, as suggested in TUF.

#### Delegation files

`/packages/pkgname/delegation` delegates ownership on versions of package
`pkgname`. The file contains version constraints associated with keyids, _e.g._:

```opam
name: pkgname
delegates: [
  "thomas@gazagnaire.org"
  "louis.gesbert@ocamlpro.com" {>= "1.0"}
]
```
The file is signed:
- by the original developer submitting it
- or by a developer previously having delegation for all versions, for changes
- or directly by repository maintainers, validating the delegation, and
  increasing the level of trust

Every key a developer delegates trust to must also be signed by the developer.

`compilers/patch.delegate` files follow a similar format (we are considering
changing the hierarchy of compilers to match that of packages, to make things
simpler).

The `delegates:` field may be empty: in this case, no packages by this name are
allowed on the repository. This may be useful to mark deletion of obsolete
packages, and make sure a new, different package doesn't take the same name by
mistake or malice.

#### Package signature files

These guarantee the integrity of a package: this includes metadata and the
package archive itself (which may, or may not, be mirrored on the the opam
repository server).

The file, besides the package name and version, has a field `package-files:`
containing a list of files below `packages/<pkgname>/<pkgname>.<version>`
together with their file sizes in bytes and one or more hashes, prefixed by their
kind, and a field `archive:` containing the same details for the upstream
archive. For example:

```opam
name: pkgname
version: pkgversion
package-files: [
  "opam" {901 [ sha1 "7f9bc3cc8a43bd8047656975bec20b578eb7eed9" md5 "1234567890" ]}
  "descr" {448 [ sha1 "8541f98524d22eeb6dd669f1e9cddef302182333" ]}
  "url" {112 [ sha1 "0a07dd3208baf4726015d656bc916e00cd33732c" ]}
  "files/ocaml.4.02.patch" {17243 [ sha1 "b3995688b9fd6f5ebd0dc4669fc113c631340fde" ]}
]
archive: [ 908460 [ sha1 "ec5642fd2faf3ebd9a28f9de85acce0743e53cc2" ] ]
```

This file is signed either:
- by the `initial-bootstrap` key, only initially
- by a delegate key (_i.e._ by a delegated-to developer)
- by a quorum of repository maintainers

The latter is needed to hot-fix packages on the repository: repository
maintainers often need to do so. A quorum is still required, to prevent a single
RM key compromise from allowing arbitrary changes to every package. The quorum
is not initially required to sign a delegation, but is, consistently, required
for any change to an existing, signed delegation.

Compiler signature files `<version>+<patch>.signature` are similar, with fields
`compiler-files` containing checksums for `<version>+<patch>.*`, the same field
`archive:` and an additional optional field `patches:`, containing the sizes and
hashes of upstream patches used by this compiler.

If the delegation or signature can't be validated, the package or compiler is
ignored. If any file doesn't correspond to its size or hashes, it is ignored as
well. Any file not mentioned in the signature file is ignored.

## Snapshots and linearity

### Main snapshot role

The snapshot key automatically adds a `signed` annotated tag to the top of the
served branch of the repository. This tag contains the commit-hash and the
current timestamp, effectively ensuring freshness and consistency of the full
repository. This protects against mix-and-match, rollback and freeze attacks.

The `signed` annotated tag is deleted and recreated by the snapshot bot, after
checking the validity of the update, periodically and after each change.

### Linearity

The repository is served using git: this means, not only the latest version, but
the full history of changes are known. This as several benefits, among them,
incremental downloads "for free"; and a very easy way to sign snapshots. Another
good point is that we have a working full OCaml implementation.

We mentioned above that we use the snapshot signatures not only for repository
signing, but also as an initial guarantee for submitted developer's keys and
delegations. One may also have noticed, in the above, that we sign for
delegations, keys etc. individually, but without a bundle file that would ensure
no signed files have been maliciously removed.

These concerns are all addressed by a _linearity condition_ on the repository's
git: the snapshot bot does not only check and sign for a given state of the
repository, it checks every individual change to the repository since the last
well-known, signed state: patches have to follow from that git commit
(descendants on the same branch), and are validated to respect certain
conditions: no signed files are removed or altered without signature, etc.

Moreover, this check is also done on clients, every time they update: it is
slightly weaker, as the client don't update continuously (an attacker may have
rewritten the commits since last update), but still gives very good guarantees.

A key and delegation that have been submitted by a developer and merged, even
without RM signature, are signed as part of a snapshot: git and the linearity
conditions allow us to guarantee that this delegation won't be altered or
removed afterwards, even without an individual signature. Even if the repository
is compromised, an attacker won't be able to roll out malicious updates breaking
these conditions to clients.

The linearity invariants are:
 1. no key, delegation, or package version (signed files) may be removed
 2. a new key is signed by itself, and optionally by a RM
 3. a new delegation is signed by the delegate key, optionally by a RM. Signing
    keys must also sign the delegate keys
 4. a new package or package version is signed by a valid key holding a valid
    delegation for this package version
 5. keys can only be modified with signature from the previous key or a quorum
    of RM keys
 6. delegations can only be modified with signature by a quorum of RMs, or
    possibly by a former delegate key (without version constraints) in case
    there was previously no RM signature
 7. any package modification is signed by an appropriate delegate key, or by a
    quorum of RM keys

It is sometimes needed to do operations, like key revocation, that are not
allowed by the above rules. These are enabled by the following additional rules,
that require the commit including the changes to be signed by a quorum of
repository maintainers using an annotated tag:

 1. package or package version removal
 2. removal (revocation) of a developer key
 3. removal of a package delegation (it's in general preferable to leave an
    empty delegation)

Changes to the `keys/root` file, which may add, modify or revoke keys for root,
RMs and snapshot keys is verified in the normal way, but needs to be handled for
checking linearity since it decides the validity of RM signatures. Since this
file may be needed before we can check the `signed` tag, it has its own
timestamp to prevent rollback attacks.

In case the linearity invariant check fail:
- on the GitHub repository, this is marked and the RMs are advised not to merge
  (or to complete missing tag signatures)
- on the clients, the update is refused, and the user informed of what's going
  on (the repository has likely been compromised at that point)
- on the repository (checks by the snapshot bot), update is stalled and all
  repository maintainers immediately warned. To recover, the broken commits
  (between the last `signed` tag and master) need to be amended.






## Work and changes involved

### General

Write modules for key handling ; signing and verification of opam files.

Write the git synchronisation module with linearity checks.

### opam

Rewrite the default HTTP repository synchronisation module to use git fetch,
verify, and git pull. This should be fully transparent, except:
- in the cases of errors, of course
- when registering a non-official repository
- for some warnings with features that disable signatures, like source pinning
  (probably only the first time would be good)

Include the public root keys for the default repository, and implement
management of updated keys in `~/.opam/repo/name`.

Handle the new formats for checksums and non-repackaged archives.

Allow a per-repository security threshold (_e.g._ allow all, allow only signed
packages, allow only packages signed by a verified key, allow only packages
signed by their verified developer). It should be easy but explicit to add a
local network, unsigned repository. Backends other than git won't be signed
anyway (local, rsync...).

### opam-publish

Generate keys, handle locally stored keys, generate `signature` files, handle
signing, submit signatures, check delegation, submit new delegation, request
delegation change (might require repository maintainer intervention if an RM
signed the delegation), delete developer, delete package.

Manage local keys. Probably including re-generating, and asking for revocation.

### opam-admin

Most operations on signatures and keys will be implemented as independent
modules (as to be usable from _e.g._ unikernels working on the repository). We
should also make them available from `opam-admin`, for testing and manual
management. Special tooling will also be needed by RMs.

- fetch the archives (but don't repackage as `pkg+opam.tar.gz` anymore)
- allow all useful operations for repository maintainers (maybe in a different
  tool ?):
  * manage their keys
  * list and sign changed packages directly
  * list and sign waiting delegations to developer keys
  * validate signatures, print reports
  * sign tags, including adding a signature to an existing tag to meet the
    quorum
  * list quorums waiting to be met on a given branch
- generate signed snapshots (same as the snapshot bot, for testing)

### Signing bots

If we don't want to have this processed on the publicly visible host serving the
repository, we'll need a mechanism to fetch the repository, and submit the
signed tag back to the repository server.

Doing this through mirage unikernels would be cool, and provide good isolation.
We could imagine running this process regularly:

- fetch changes from the repository's git (GitHub)
- check for consistency (linearity)
- generate and sign the `signed` tag
- push tag back to the release repository

### Travis

All security information and check results should be available to RMs before
they make the decision to merge a commit to the repository. This means including
signature and linearity checks in a process running on Travis, or similarly on
every pull-request to the repository, and displaying the results in the GitHub
tracker.

This should avoid most cases where the snapshot bot fails the validation,
leaving it stuck (as well as any repository updates) until the bad commits are
rewritten.

## Some more detailed scenarios

### `opam init` and `update` scenario

On `init`, the client would clone the repository and get to the `signed` tag,
get and check the associated `keys/root` file, and validate the `signed` tag
according to the new keyset. If all goes well, the new set of root, RM and
snapshot keys is registered.

Then all files' signatures are checked following the trust chains, and copied to
the internal repository mirror opam will be using (`~/.opam/repo/<name>`). When
a package archive is needed, the download is done either from the repository, if
the file is mirrored, or from its upstream, in both cases with known file size
and upper limit: the download is stopped if going above the expected size, and
the file removed if it doesn't match both.

On subsequent updates, the process is the same except that a fetch operation is
done on the existing clone, and that the repository is forwarded to the new
`signed` tag only if linearity checks passed (and the update is aborted
otherwise).

### `opam-publish` scenario

* The first time a developer runs `opam-publish submit`, a developer key is
  generated, and stored locally.
* Upon `opam-publish submit`, the package is signed using the key, and the
  signature is included in the submission.
* If the key is known, and delegation for this package matches, all is good
* If the key is not already registered, it is added to `/keys/dev/` within the
  pull-request, self-signed.
* If there is no delegation for the package, the `/packages/pkgname/delegation`
  file is added, delegating to the developer key and signed by it.
* If there is an existing delegation that doesn't include the auhor's key,
  this will require manual intervention from the repository managers. We may yet
  submit a pull-request adding the new key as delegate for this package, and ask
  the repository maintainers -- or former developers -- to sign it.

## Security analysis

We claim that the above measures give protection against:

- Arbitrary packages: if an existing package is not signed, it is not installed
  (or even visible) to the user. Anybody can submit new unclaimed packages (but,
  in the current setting, still need GitHub write access to the repository, or
  to bypass GitHub's security).

- Rollback attacks: git updates must follow the currently known `signed` tag. if
  the snapshot bot detects deletions of packages, it refuses to sign, and
  clients double-check this. The `keys/root` file contains a timestamp.

- Indefinite freeze attacks: the snapshot bot periodically signs the `signed`
  tag with a timestamp, if a client receives a tag older than the expected age
  it will notice.

- Endless data attacks: we rely on the git protocol and this does not defend
  against endless data. Downloading of package archive (of which the origin may
  be any mirror), though, is protected. The scope of the attack is mitigated in
  our setting, because there are no unattended updates: the program is run
  manually, and interactively, so the user is most likely to notice.

- Slow retrieval attacks: same as above.

- Extraneous dependencies attacks: metadata is signed, and if the signature does
  not match, it is not accepted.

  > NOTE: the `provides` field -- yet unimplemented, see the document in
  > `opam/doc/design` -- could provide a vector in this case, by advertising a
  > replacement for a popular package. Additional measures will be taken when
  > implementing the feature, like requiring a signature for the provided
  > package.

- Mix-and-match attacks: the repository has a linearity condition, and partial
  repositories are not possible.

- Malicious repository mirrors: if the signature does not match, reject.

- Wrong developer attack: if the developer is not in the delegation, reject.

### GitHub repository

Is the link between GitHub (opam-repository) and the signing bot special?
If there is a MITM on this link, they can add arbitrary new packages, but
due to missing signatures only custom universes. No existing package can
be altered or deleted, otherwise consistency condition above does not hold
anymore and the signing bot will not sign.

Certainly, the access can be frozen, thus the signing bot does not receive
updates, but continues to sign the old repository version.

### Snapshot key

If the snapshot key is compromised, an attacker is able to:

- Add arbitrary (non already existing) packages, as above.

- Freeze, by forever re-signing the `signed` tag with an updated timestamp.

Most importantly, the attacker won't be able to tamper with existing packages.
This hudgely reduces the potential of an attack, even with a compromised
snapshot key.

The attacks above would also require either a MITM between the repository and
the client, or a compromise of the opam repository: in the latter case, since
the linearity check is reproduces even from the clients:

- any tamper could be detected very quickly, and measures taken.
- a freeze would be detected as soon as a developer checks that their
  package is really online. That currently happens
  [several times a day][opam-repo-pulse].

The repository would then just have to be reset to before the attack, which git
makes as easy as it can get, and the holders of the root keys would sign a new
`/auth/root`, revoking the compromised snapshot key and introducing a new one.

In the time before the signing bot can be put back online with the new snapshot
key -- _i.e._ the breach has been found and fixed -- a developer could manually
sign time-stamped tags before they expire (_e.g._ once a day) so as not to hold
back updates.

### Repository Maintainer keys

Repository maintainers are powerful, they can modify existing opam files and
sign them (as hotfix), introduce new delegations for packages, etc.).

However, by requiring a quorum for sensitive operations, we limit the scope of a
single RM key compromise to the validation of new developer keys or delegations
(which should be the most common operation done by RMs): this enables to raise
the level of security of the new, malicious packages but otherwise doesn't
change much from what can be done with just access to the git repository.

A further compromise of a quorum of RM keys would allow to remove or tamper with
any developer key, delegation or package: any of these amounts to being able to
replace any package with a compromised version. Cleaning up would require
replacing all but the root keys, and resetting the repository to before any
malicious commit.

## Difference to TUF

- we use git
- thus get linearity "for free"
- and already have a hash over the entire repository
- TUF provides a mechanism for delegation, but it's both heavier and not
  expressive enough for what we wanted -- delegate to packages directly.
- We split in lots more files, and per-package ones, to fit with and nicely
  extend the git-based workflow that made the success of opam. The original TUF
  would have big json files signing for a lot of files, and likely to conflict.
  Both developers and repository maintainers should be able to safely work
  concurrently without issue. Signing bundles in TUF gives the additional
  guarantee that no file is removed without proper signature, but this is
  handled by git and signed tags.
- instead of a single file with all signed packages by a specific developer,
  one file per package

### Differences to Haskell:

- use TUF keys, not gpg
- e2e signing

[tuf]: http://theupdateframework.com/
[python-tuf]: http://www.python.org/dev/peps/pep-0458/
[ruby-tuf]: https://corner.squareup.com/2013/12/securing-rubygems-with-tuf-part-1.html
[haskell-tuf]: http://www.well-typed.com/blog/2015/04/improving-hackage-security/
[haskell-tuf-git]: https://github.com/commercialhaskell/commercialhaskell/wiki/Git-backed-Hackage-index-signing-and-distribution
[haskell-tuf-e2e]: https://github.com/commercialhaskell/commercialhaskell/wiki/Package-signing-detailed-propsal
[thandy]: http://google-opensource.blogspot.jp/2009/03/thandy-secure-update-for-tor.html
[nocrypto]: https://opam.ocaml.org/packages/nocrypto/nocrypto.0.3.1/
[tuf-tests]: https://github.com/theupdateframework/tuf/tree/develop/tests
[tuf-spec]: https://raw.githubusercontent.com/theupdateframework/tuf/develop/docs/tuf-spec.txt
[tuf-spec-priorities]: https://github.com/theupdateframework/tuf/blob/e034be2687fa4eacc6c05ffff8a0d8a387eb3d20/docs/tuf-spec.txt#L632
[opam-format]: https://opam.ocaml.org/doc/Manual.html#Generalfileformat
[opam-repo-pulse]: https://github.com/ocaml/opam-repository/pulse
