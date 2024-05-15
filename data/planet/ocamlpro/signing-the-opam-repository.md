---
title: Signing the OPAM repository
description: 'NOTE (September 2016): updated proposal from OCaml 2016 workshop is
  available, including links to prototype implementation. This is an initial proposal
  on signing the OPAM repository. Comments and discussion are expected on the platform
  mailing-list. The purpose of this proposal is to enable a secur...'
url: https://ocamlpro.com/blog/2015_06_05_signing_the_opam_repository
date: 2015-06-05T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    Louis Gesbert\n  "
source:
---

<blockquote>
<p>NOTE (September 2016): updated proposal from OCaml 2016 workshop is
<a href="https://github.com/hannesm/conex-paper/blob/master/paper.pdf">available</a>,
including links to prototype implementation.</p>
</blockquote>
<blockquote>
<p>This is an initial proposal on signing the OPAM repository. Comments and
discussion are expected on the
<a href="http://lists.ocaml.org/listinfo/platform">platform mailing-list</a>.</p>
</blockquote>
<p>The purpose of this proposal is to enable a secure distribution of
OCaml packages. The package repository does not have to be trusted if
package developers sign their releases.</p>
<p>Like <a href="http://www.python.org/dev/peps/pep-0458/">Python's pip</a>, <a href="https://corner.squareup.com/2013/12/securing-rubygems-with-tuf-part-1.html">Ruby's gems</a> or more recently
<a href="http://www.well-typed.com/blog/2015/04/improving-hackage-security/">Haskell's hackage</a>, we are going to implement a flavour of The
Upgrade Framework (<a href="http://theupdateframework.com/">TUF</a>). This is good because:</p>
<ul>
<li>it has been designed by people who <a href="http://google-opensource.blogspot.jp/2009/03/thandy-secure-update-for-tor.html">know the stuff</a> much better than
us
</li>
<li>it is built upon a threat model including many kinds of attacks, and there are
some non-obvious ones (see the <a href="https://raw.githubusercontent.com/theupdateframework/tuf/develop/docs/tuf-spec.txt">specification</a>, and below)
</li>
<li>it has been thoroughly reviewed
</li>
<li>following it may help us avoid a lot of mistakes
</li>
</ul>
<p>Importantly, it doesn't enforce any specific cryptography, allowing us to go
with what we have <a href="http://opam.ocaml.org/packages/nocrypto/nocrypto.0.3.1/">at the moment</a> in native OCaml, and evolve later,
<em>e.g.</em> by allowing ed25519.</p>
<p>There are several differences between the goal of TUF and opam, namely
TUF distributes a directory structure containing the code archive,
whereas opam distributes metadata about OCaml packages. Opam uses git
(and GitHub at the moment) as a first class citizen: new packages are
submitted as pull requests by developers who already have a GitHub
account.</p>
<p>Note that TUF specifies the signing hierarchy and the format to deliver and
check signatures, but allows a lot of flexibility in how the original files are
signed: we can have packages automatically signed on the official repository, or
individually signed by developers. Or indeed allow both, depending on the
package.</p>
<p>Below, we tried to explain the specifics of our implementation, and mostly the
user and developer-visible changes. It should be understandable without prior
knowledge of TUF.</p>
<p>We are inspired by <a href="https://github.com/commercialhaskell/commercialhaskell/wiki/Git-backed-Hackage-index-signing-and-distribution">Haskell's adjustments</a> (and
<a href="https://github.com/commercialhaskell/commercialhaskell/wiki/Package-signing-detailed-propsal">e2e</a>) to TUF using a git repository for packages. A
signed repository and signed packages are orthogonal. In this
proposal, we aim for both, but will describe them independently.</p>
<h2>Threat model</h2>
<ul>
<li>
<p>An attacker can compromise at least one of the package distribution
system's online trusted keys.</p>
</li>
<li>
<p>An attacker compromising multiple keys may do so at once or over a
period of time.</p>
</li>
<li>
<p>An attacker can respond to client requests (MITM or server
compromise) during downloading of the repository, a package, and
also while uploading a new package release.</p>
</li>
<li>
<p>An attacker knows of vulnerabilities in historical versions of one or
more packages, but not in any current version (protecting against
zero-day exploits is emphatically out-of-scope).</p>
</li>
<li>
<p>Offline keys are safe and securely stored.</p>
</li>
</ul>
<p>An attacker is considered successful if they can cause a client to
build and install (or leave installed) something other than the most
up-to-date version of the software the client is updating. If the
attacker is preventing the installation of updates, they want clients
to not realize there is anything wrong.</p>
<h2>Attacks</h2>
<ul>
<li>
<p>Arbitrary package: an attacker should not be able to provide a package
they created in place of a package a user wants to install (via MITM
during package upload, package download, or server compromise).</p>
</li>
<li>
<p>Rollback attacks: an attacker should not be able to trick clients into
installing software that is older than that which the client
previously knew to be available.</p>
</li>
<li>
<p>Indefinite freeze attacks: an attacker should not be able to respond
to client requests with the same, outdated metadata without the
client being aware of the problem.</p>
</li>
<li>
<p>Endless data attacks: an attacker should not be able to respond to
client requests with huge amounts of data (extremely large files)
that interfere with the client's system.</p>
</li>
<li>
<p>Slow retrieval attacks: an attacker should not be able to prevent
clients from being aware of interference with receiving updates by
responding to client requests so slowly that automated updates never
complete.</p>
</li>
<li>
<p>Extraneous dependencies attacks: an attacker should not be able to
cause clients to download or install software dependencies that are
not the intended dependencies.</p>
</li>
<li>
<p>Mix-and-match attacks: an attacker should not be able to trick clients
into using a combination of metadata that never existed together on
the repository at the same time.</p>
</li>
<li>
<p>Malicious repository mirrors: should not be able to prevent updates
from good mirrors.</p>
</li>
<li>
<p>Wrong developer attack: an attacker should not be able to upload a new
version of a package for which they are not the real developer.</p>
</li>
</ul>
<h2>Trust</h2>
<p>A difficult problem in a cryptosystem is key distribution. In TUF and
this proposal, a set of root keys are distributed with opam. A
threshold of these root keys needs to sign (transitively) all keys
which are used to verify opam repository and its packages.</p>
<h3>Root keys</h3>
<p>The root of trust is stored in a set of root keys. In the case of the official
opam OCaml repository, the public keys are to be stored in the opam source,
allowing it to validate the whole trust chain. The private keys will be held by
the opam and repository maintainers, and stored password-encrypted, securely
offline, preferably on unplugged storage.</p>
<p>They are used to sign all the top-level keys, using a quorum. The quorum has
several benefits:</p>
<ul>
<li>the compromise of a number of root keys less than the quorum is harmless
</li>
<li>it allows to safely revoke and replace a key, even if it was lost
</li>
</ul>
<p>The added cost is more maintenance burden, but this remains small since these
keys are not often used (only when keys are going to expire, were compromised or
in the event new top-level keys need to be added).</p>
<p>The initial root keys could be distributed as such:</p>
<ul>
<li>Louis Gesbert, opam maintainer, OCamlPro
</li>
<li>Anil Madhavapeddy, main repository maintainer, OCaml Labs
</li>
<li>Thomas Gazagnaire, main repository maintainer, OCaml Labs
</li>
<li>Gr&eacute;goire Henry, OCamlPro safekeeper
</li>
<li>Someone in the OCaml team ?
</li>
</ul>
<p>Keys will be set with an expiry date so that one expires each year in turn,
leaving room for smooth rollover.</p>
<p>For other repositories, there will be three options:</p>
<ul>
<li>no signatures (backwards compatible ?), <em>e.g.</em> for local network repositories.
This should be allowed, but with proper warnings.
</li>
<li>trust on first use: get the root keys on first access, let the user confirm
their fingerprints, then fully trust them.
</li>
<li>let the user manually supply the root keys.
</li>
</ul>
<h3>End-to-end signing</h3>
<p>This requires the end-user to be able to validate a signature made by the
original developer. There are two trust paths for the chain of trust (where
&quot;&rarr;&quot; stands for &quot;signs for&quot;):</p>
<ul>
<li>(<em>high</em>) root keys &rarr;
repository maintainer keys &rarr; (signs individually)
package delegation + developer key &rarr;
package files
</li>
<li>(<em>low</em>) root keys &rarr;
snapshot key &rarr; (signs as part of snapshot)
package delegation + developer key &rarr;
package files
</li>
</ul>
<p>It is intended that packages may initially follow the <em>low</em> trust path, adding
as little burden and delay as possible when adding new packages, and may then be
promoted to the <em>high</em> path with manual intervention, after verification, from
repository maintainers. This way, most well-known and widely used packages will
be provided with higher trust, and the scope of an attack on the low trust path
would be reduced to new, experimental or little-used packages.</p>
<h3>Repository signing</h3>
<p>This provides consistent, up-to-date snapshots of the repository, and protects
against a whole different class of attacks than end-to-end signing (<em>e.g.</em>
rollbacks, mix-and-match, freeze, etc.)</p>
<p>This is done automatically by a snapshot bot (might run on the repository
server), using the <em>snapshot key</em>, which is signed directly by the root keys,
hence the chain of trust:</p>
<ul>
<li>root keys &rarr;
snapshot key &rarr;
commit-hash
</li>
</ul>
<p>Where &quot;commit-hash&quot; is the head of the repository's git repository (and thus a
valid cryptographic hash of the full repository state, as well as its history)</p>
<h4>Repository maintainer (RM) keys</h4>
<p>Repository maintainers hold the central role in monitoring the repository and
warranting its security, with or without signing. Their keys (called <em>targets
keys</em> in the TUF framework) are signed directly by the root keys. As they have a
high security potential, in order to reduce the consequences of a compromise, we
will be requiring a quorum for signing sensitive operations</p>
<p>These keys are stored password-encrypted on the RM computers.</p>
<h4>Snapshot key</h4>
<p>This key is held by the <em>snapshot bot</em> and signed directly by the root keys. It
is used to guarantee consistency and freshness of repository snapshots, and does
so by signing a git commit-hash and a time-stamp.</p>
<p>It is held online and used by the snapshot bot for automatic signing: it has
lower security than the RM keys, but also a lower potential: it can not be used
directly to inject malicious code or metadata in any existing package.</p>
<h4>Delegate developer keys</h4>
<p>These keys are used by the package developers for end-to-end signing. They can
be generated locally as needed by new packagers (<em>e.g.</em> by the <code>opam-publish</code>
tool), and should be stored password-encrypted. They can be added to the
repository through pull-requests, waiting to be signed (i) as part of snapshots
(which also prevents them to be modified later, but we'll get to it) and (ii)
directly by RMs.</p>
<h4>Initial bootstrap</h4>
<p>We'll need to start somewhere, and the current repository isn't signed. An
additional key, <em>initial-bootstrap</em>, will be used for guaranteeing integrity of
existing, but yet unverified packages.</p>
<p>This is a one-go key, signed by the root keys, and that will then be destroyed.
It is allowed to sign for packages without delegation.</p>
<h3>Trust chain and revocation</h3>
<p>In order to build the trust chain, the opam client downloads a <code>keys/root</code> key
file initially and before every update operation. This file is signed by the
root keys, and can be verified by the client using its built-in keys (or one of
the ways mentioned above for unofficial repositories). It must be signed by a
quorum of known root keys, and contains the comprehensive set of root, RM,
snapshot and initial bootstrap keys: any missing keys are implicitly revoked.
The new set of root keys is stored by the opam client and used instead of the
built-in ones on subsequent runs.</p>
<p>Developer keys are stored in files <code>keys/dev/&lt;id&gt;</code>, self-signed, possibly RM
signed (and, obviously, snapshot-signed). The conditions of their verification,
removal or replacement are included in our validation of metadata update (see
below).</p>
<h2>File formats and hierarchy</h2>
<h3>Signed files and tags</h3>
<p>The files follow the opam syntax: a list of <em>fields</em> <code>fieldname:</code> followed by
contents. The format is detailed in <a href="https://opam.ocaml.org/doc/Manual.html#Generalfileformat">opam's documentation</a>.</p>
<p>The signature of files in opam is done on the canonical textual representation,
following these rules:</p>
<ul>
<li>any existing <code>signature:</code> field is removed
</li>
<li>one field per line, ending with a newline
</li>
<li>fields are sorted lexicographically by field name
</li>
<li>newlines, backslashes and double-quotes are escaped in string literals
</li>
<li>spaces are limited to one, and to these cases: after field leaders
<code>fieldname:</code>, between elements in lists, before braced options, between
operators and their operands
</li>
<li>comments are erased
</li>
<li>fields containing an empty list, or a singleton list containing an empty
list, are erased
</li>
</ul>
<p>The <code>signature:</code> field is a list with elements in the format of string triplets
<code>[ &quot;&lt;keyid&gt;&quot; &quot;&lt;algorithm&gt;&quot; &quot;&lt;signature&gt;&quot; ]</code>. For example:</p>
<pre><code>opam-version: &quot;1.2&quot;
name: &quot;opam&quot;
signature: [
  [ &quot;louis.gesbert@ocamlpro.com&quot; &quot;RSASSA-PSS&quot; &quot;048b6fb4394148267df...&quot; ]
]
</code></pre>
<p>Signed tags are git annotated tags, and their contents follow the same rules. In
this case, the format should contain the field <code>commit:</code>, pointing to the
commit-hash that is being signed and tagged.</p>
<h3>File hierarchy</h3>
<p>The repository format is changed by the addition of:</p>
<ul>
<li>a directory <code>keys/</code> at the root
</li>
<li>delegation files <code>packages/&lt;pkgname&gt;/delegate</code> and
<code>compilers/&lt;patchname&gt;.delegate</code>
</li>
<li>signed checksum files at <code>packages/&lt;pkgname&gt;/&lt;pkgname&gt;.&lt;version&gt;/signature</code>
</li>
</ul>
<p>Here is an example:</p>
<pre><code class="language-shell-session">repository root /
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
</code></pre>
<p>Keys are provided in different files as string triplets
<code>[ [ &quot;keyid&quot; &quot;algo&quot; &quot;key&quot; ] ]</code>. <code>keyid</code> must not conflict with any
previously-defined keys, and <code>algo</code> may be &quot;rsa&quot; and keys encoded in PEM format,
with further options available later.</p>
<p>For example, the <code>keys/root</code> file will have the format:</p>
<pre><code class="language-shell-session">date=2015-06-04T13:53:00Z
root-keys: [ [ &quot;keyid&quot; &quot;{expire-date}&quot; &quot;algo&quot; &quot;key&quot; ] ]
snapshot-keys: [ [ &quot;keyid&quot; &quot;algo&quot; &quot;key&quot; ] ]
repository-maintainer-keys: [ [ &quot;keyid&quot; &quot;algo&quot; &quot;key&quot; ] ]
</code></pre>
<p>This file is signed by current <em>and past</em> root keys -- to allow clients to
update. The <code>date:</code> field provides further protection against rollback attacks:
no clients may accept a file with a date older than what they currently have.
Date is in the ISO 8601 standard with 0 UTC offset, as suggested in TUF.</p>
<h4>Delegation files</h4>
<p><code>/packages/pkgname/delegation</code> delegates ownership on versions of package
<code>pkgname</code>. The file contains version constraints associated with keyids, <em>e.g.</em>:</p>
<pre><code class="language-shell-session">name: pkgname
delegates: [
  &quot;thomas@gazagnaire.org&quot;
  &quot;louis.gesbert@ocamlpro.com&quot; {&gt;= &quot;1.0&quot;}
]
</code></pre>
<p>The file is signed:</p>
<ul>
<li>by the original developer submitting it
</li>
<li>or by a developer previously having delegation for all versions, for changes
</li>
<li>or directly by repository maintainers, validating the delegation, and
increasing the level of trust
</li>
</ul>
<p>Every key a developer delegates trust to must also be signed by the developer.</p>
<p><code>compilers/patch.delegate</code> files follow a similar format (we are considering
changing the hierarchy of compilers to match that of packages, to make things
simpler).</p>
<p>The <code>delegates:</code> field may be empty: in this case, no packages by this name are
allowed on the repository. This may be useful to mark deletion of obsolete
packages, and make sure a new, different package doesn't take the same name by
mistake or malice.</p>
<h4>Package signature files</h4>
<p>These guarantee the integrity of a package: this includes metadata and the
package archive itself (which may, or may not, be mirrored on the the opam
repository server).</p>
<p>The file, besides the package name and version, has a field <code>package-files:</code>
containing a list of files below <code>packages/&lt;pkgname&gt;/&lt;pkgname&gt;.&lt;version&gt;</code>
together with their file sizes in bytes and one or more hashes, prefixed by their
kind, and a field <code>archive:</code> containing the same details for the upstream
archive. For example:</p>
<pre><code class="language-shell-session">name: pkgname
version: pkgversion
package-files: [
  &quot;opam&quot; {901 [ sha1 &quot;7f9bc3cc8a43bd8047656975bec20b578eb7eed9&quot; md5 &quot;1234567890&quot; ]}
  &quot;descr&quot; {448 [ sha1 &quot;8541f98524d22eeb6dd669f1e9cddef302182333&quot; ]}
  &quot;url&quot; {112 [ sha1 &quot;0a07dd3208baf4726015d656bc916e00cd33732c&quot; ]}
  &quot;files/ocaml.4.02.patch&quot; {17243 [ sha1 &quot;b3995688b9fd6f5ebd0dc4669fc113c631340fde&quot; ]}
]
archive: [ 908460 [ sha1 &quot;ec5642fd2faf3ebd9a28f9de85acce0743e53cc2&quot; ] ]
</code></pre>
<p>This file is signed either:</p>
<ul>
<li>by the <code>initial-bootstrap</code> key, only initially
</li>
<li>by a delegate key (<em>i.e.</em> by a delegated-to developer)
</li>
<li>by a quorum of repository maintainers
</li>
</ul>
<p>The latter is needed to hot-fix packages on the repository: repository
maintainers often need to do so. A quorum is still required, to prevent a single
RM key compromise from allowing arbitrary changes to every package. The quorum
is not initially required to sign a delegation, but is, consistently, required
for any change to an existing, signed delegation.</p>
<p>Compiler signature files <code>&lt;version&gt;+&lt;patch&gt;.signature</code> are similar, with fields
<code>compiler-files</code> containing checksums for <code>&lt;version&gt;+&lt;patch&gt;.*</code>, the same field
<code>archive:</code> and an additional optional field <code>patches:</code>, containing the sizes and
hashes of upstream patches used by this compiler.</p>
<p>If the delegation or signature can't be validated, the package or compiler is
ignored. If any file doesn't correspond to its size or hashes, it is ignored as
well. Any file not mentioned in the signature file is ignored.</p>
<h2>Snapshots and linearity</h2>
<h3>Main snapshot role</h3>
<p>The snapshot key automatically adds a <code>signed</code> annotated tag to the top of the
served branch of the repository. This tag contains the commit-hash and the
current timestamp, effectively ensuring freshness and consistency of the full
repository. This protects against mix-and-match, rollback and freeze attacks.</p>
<p>The <code>signed</code> annotated tag is deleted and recreated by the snapshot bot, after
checking the validity of the update, periodically and after each change.</p>
<h3>Linearity</h3>
<p>The repository is served using git: this means, not only the latest version, but
the full history of changes are known. This as several benefits, among them,
incremental downloads &quot;for free&quot;; and a very easy way to sign snapshots. Another
good point is that we have a working full OCaml implementation.</p>
<p>We mentioned above that we use the snapshot signatures not only for repository
signing, but also as an initial guarantee for submitted developer's keys and
delegations. One may also have noticed, in the above, that we sign for
delegations, keys etc. individually, but without a bundle file that would ensure
no signed files have been maliciously removed.</p>
<p>These concerns are all addressed by a <em>linearity condition</em> on the repository's
git: the snapshot bot does not only check and sign for a given state of the
repository, it checks every individual change to the repository since the last
well-known, signed state: patches have to follow from that git commit
(descendants on the same branch), and are validated to respect certain
conditions: no signed files are removed or altered without signature, etc.</p>
<p>Moreover, this check is also done on clients, every time they update: it is
slightly weaker, as the client don't update continuously (an attacker may have
rewritten the commits since last update), but still gives very good guarantees.</p>
<p>A key and delegation that have been submitted by a developer and merged, even
without RM signature, are signed as part of a snapshot: git and the linearity
conditions allow us to guarantee that this delegation won't be altered or
removed afterwards, even without an individual signature. Even if the repository
is compromised, an attacker won't be able to roll out malicious updates breaking
these conditions to clients.</p>
<p>The linearity invariants are:</p>
<ol>
<li>no key, delegation, or package version (signed files) may be removed
</li>
<li>a new key is signed by itself, and optionally by a RM
</li>
<li>a new delegation is signed by the delegate key, optionally by a RM. Signing
keys must also sign the delegate keys
</li>
<li>a new package or package version is signed by a valid key holding a valid
delegation for this package version
</li>
<li>keys can only be modified with signature from the previous key or a quorum
of RM keys
</li>
<li>delegations can only be modified with signature by a quorum of RMs, or
possibly by a former delegate key (without version constraints) in case
there was previously no RM signature
</li>
<li>any package modification is signed by an appropriate delegate key, or by a
quorum of RM keys
</li>
</ol>
<p>It is sometimes needed to do operations, like key revocation, that are not
allowed by the above rules. These are enabled by the following additional rules,
that require the commit including the changes to be signed by a quorum of
repository maintainers using an annotated tag:</p>
<ol>
<li>package or package version removal
</li>
<li>removal (revocation) of a developer key
</li>
<li>removal of a package delegation (it's in general preferable to leave an
empty delegation)
</li>
</ol>
<p>Changes to the <code>keys/root</code> file, which may add, modify or revoke keys for root,
RMs and snapshot keys is verified in the normal way, but needs to be handled for
checking linearity since it decides the validity of RM signatures. Since this
file may be needed before we can check the <code>signed</code> tag, it has its own
timestamp to prevent rollback attacks.</p>
<p>In case the linearity invariant check fail:</p>
<ul>
<li>on the GitHub repository, this is marked and the RMs are advised not to merge
(or to complete missing tag signatures)
</li>
<li>on the clients, the update is refused, and the user informed of what's going
on (the repository has likely been compromised at that point)
</li>
<li>on the repository (checks by the snapshot bot), update is stalled and all
repository maintainers immediately warned. To recover, the broken commits
(between the last <code>signed</code> tag and master) need to be amended.
</li>
</ul>
<h2>Work and changes involved</h2>
<h3>General</h3>
<p>Write modules for key handling ; signing and verification of opam files.</p>
<p>Write the git synchronisation module with linearity checks.</p>
<h3>opam</h3>
<p>Rewrite the default HTTP repository synchronisation module to use git fetch,
verify, and git pull. This should be fully transparent, except:</p>
<ul>
<li>in the cases of errors, of course
</li>
<li>when registering a non-official repository
</li>
<li>for some warnings with features that disable signatures, like source pinning
(probably only the first time would be good)
</li>
</ul>
<p>Include the public root keys for the default repository, and implement
management of updated keys in <code>~/.opam/repo/name</code>.</p>
<p>Handle the new formats for checksums and non-repackaged archives.</p>
<p>Allow a per-repository security threshold (<em>e.g.</em> allow all, allow only signed
packages, allow only packages signed by a verified key, allow only packages
signed by their verified developer). It should be easy but explicit to add a
local network, unsigned repository. Backends other than git won't be signed
anyway (local, rsync...).</p>
<h3>opam-publish</h3>
<p>Generate keys, handle locally stored keys, generate <code>signature</code> files, handle
signing, submit signatures, check delegation, submit new delegation, request
delegation change (might require repository maintainer intervention if an RM
signed the delegation), delete developer, delete package.</p>
<p>Manage local keys. Probably including re-generating, and asking for revocation.</p>
<h3>opam-admin</h3>
<p>Most operations on signatures and keys will be implemented as independent
modules (as to be usable from <em>e.g.</em> unikernels working on the repository). We
should also make them available from <code>opam-admin</code>, for testing and manual
management. Special tooling will also be needed by RMs.</p>
<ul>
<li>fetch the archives (but don't repackage as <code>pkg+opam.tar.gz</code> anymore)
</li>
<li>allow all useful operations for repository maintainers (maybe in a different
tool ?):
<ul>
<li>manage their keys
</li>
<li>list and sign changed packages directly
</li>
<li>list and sign waiting delegations to developer keys
</li>
<li>validate signatures, print reports
</li>
<li>sign tags, including adding a signature to an existing tag to meet the
quorum
</li>
<li>list quorums waiting to be met on a given branch
</li>
</ul>
</li>
<li>generate signed snapshots (same as the snapshot bot, for testing)
</li>
</ul>
<h3>Signing bots</h3>
<p>If we don't want to have this processed on the publicly visible host serving the
repository, we'll need a mechanism to fetch the repository, and submit the
signed tag back to the repository server.</p>
<p>Doing this through mirage unikernels would be cool, and provide good isolation.
We could imagine running this process regularly:</p>
<ul>
<li>fetch changes from the repository's git (GitHub)
</li>
<li>check for consistency (linearity)
</li>
<li>generate and sign the <code>signed</code> tag
</li>
<li>push tag back to the release repository
</li>
</ul>
<h3>Travis</h3>
<p>All security information and check results should be available to RMs before
they make the decision to merge a commit to the repository. This means including
signature and linearity checks in a process running on Travis, or similarly on
every pull-request to the repository, and displaying the results in the GitHub
tracker.</p>
<p>This should avoid most cases where the snapshot bot fails the validation,
leaving it stuck (as well as any repository updates) until the bad commits are
rewritten.</p>
<h2>Some more detailed scenarios</h2>
<h3><code>opam init</code> and <code>update</code> scenario</h3>
<p>On <code>init</code>, the client would clone the repository and get to the <code>signed</code> tag,
get and check the associated <code>keys/root</code> file, and validate the <code>signed</code> tag
according to the new keyset. If all goes well, the new set of root, RM and
snapshot keys is registered.</p>
<p>Then all files' signatures are checked following the trust chains, and copied to
the internal repository mirror opam will be using (<code>~/.opam/repo/&lt;name&gt;</code>). When
a package archive is needed, the download is done either from the repository, if
the file is mirrored, or from its upstream, in both cases with known file size
and upper limit: the download is stopped if going above the expected size, and
the file removed if it doesn't match both.</p>
<p>On subsequent updates, the process is the same except that a fetch operation is
done on the existing clone, and that the repository is forwarded to the new
<code>signed</code> tag only if linearity checks passed (and the update is aborted
otherwise).</p>
<h3><code>opam-publish</code> scenario</h3>
<ul>
<li>The first time a developer runs <code>opam-publish submit</code>, a developer key is
generated, and stored locally.
</li>
<li>Upon <code>opam-publish submit</code>, the package is signed using the key, and the
signature is included in the submission.
</li>
<li>If the key is known, and delegation for this package matches, all is good
</li>
<li>If the key is not already registered, it is added to <code>/keys/dev/</code> within the
pull-request, self-signed.
</li>
<li>If there is no delegation for the package, the <code>/packages/pkgname/delegation</code>
file is added, delegating to the developer key and signed by it.
</li>
<li>If there is an existing delegation that doesn't include the auhor's key,
this will require manual intervention from the repository managers. We may yet
submit a pull-request adding the new key as delegate for this package, and ask
the repository maintainers -- or former developers -- to sign it.
</li>
</ul>
<h2>Security analysis</h2>
<p>We claim that the above measures give protection against:</p>
<ul>
<li>
<p>Arbitrary packages: if an existing package is not signed, it is not installed
(or even visible) to the user. Anybody can submit new unclaimed packages (but,
in the current setting, still need GitHub write access to the repository, or
to bypass GitHub's security).</p>
</li>
<li>
<p>Rollback attacks: git updates must follow the currently known <code>signed</code> tag. if
the snapshot bot detects deletions of packages, it refuses to sign, and
clients double-check this. The <code>keys/root</code> file contains a timestamp.</p>
</li>
<li>
<p>Indefinite freeze attacks: the snapshot bot periodically signs the <code>signed</code>
tag with a timestamp, if a client receives a tag older than the expected age
it will notice.</p>
</li>
<li>
<p>Endless data attacks: we rely on the git protocol and this does not defend
against endless data. Downloading of package archive (of which the origin may
be any mirror), though, is protected. The scope of the attack is mitigated in
our setting, because there are no unattended updates: the program is run
manually, and interactively, so the user is most likely to notice.</p>
</li>
<li>
<p>Slow retrieval attacks: same as above.</p>
</li>
<li>
<p>Extraneous dependencies attacks: metadata is signed, and if the signature does
not match, it is not accepted.</p>
<blockquote>
<p>NOTE: the <code>provides</code> field -- yet unimplemented, see the document in
<code>opam/doc/design</code> -- could provide a vector in this case, by advertising a
replacement for a popular package. Additional measures will be taken when
implementing the feature, like requiring a signature for the provided
package.</p>
</blockquote>
</li>
<li>
<p>Mix-and-match attacks: the repository has a linearity condition, and partial
repositories are not possible.</p>
</li>
<li>
<p>Malicious repository mirrors: if the signature does not match, reject.</p>
</li>
<li>
<p>Wrong developer attack: if the developer is not in the delegation, reject.</p>
</li>
</ul>
<h3>GitHub repository</h3>
<p>Is the link between GitHub (opam-repository) and the signing bot special?
If there is a MITM on this link, they can add arbitrary new packages, but
due to missing signatures only custom universes. No existing package can
be altered or deleted, otherwise consistency condition above does not hold
anymore and the signing bot will not sign.</p>
<p>Certainly, the access can be frozen, thus the signing bot does not receive
updates, but continues to sign the old repository version.</p>
<h3>Snapshot key</h3>
<p>If the snapshot key is compromised, an attacker is able to:</p>
<ul>
<li>
<p>Add arbitrary (non already existing) packages, as above.</p>
</li>
<li>
<p>Freeze, by forever re-signing the <code>signed</code> tag with an updated timestamp.</p>
</li>
</ul>
<p>Most importantly, the attacker won't be able to tamper with existing packages.
This hudgely reduces the potential of an attack, even with a compromised
snapshot key.</p>
<p>The attacks above would also require either a MITM between the repository and
the client, or a compromise of the opam repository: in the latter case, since
the linearity check is reproduces even from the clients:</p>
<ul>
<li>any tamper could be detected very quickly, and measures taken.
</li>
<li>a freeze would be detected as soon as a developer checks that their
package is really online. That currently happens
<a href="https://github.com/ocaml/opam-repository/pulse">several times a day</a>.
</li>
</ul>
<p>The repository would then just have to be reset to before the attack, which git
makes as easy as it can get, and the holders of the root keys would sign a new
<code>/auth/root</code>, revoking the compromised snapshot key and introducing a new one.</p>
<p>In the time before the signing bot can be put back online with the new snapshot
key -- <em>i.e.</em> the breach has been found and fixed -- a developer could manually
sign time-stamped tags before they expire (<em>e.g.</em> once a day) so as not to hold
back updates.</p>
<h3>Repository Maintainer keys</h3>
<p>Repository maintainers are powerful, they can modify existing opam files and
sign them (as hotfix), introduce new delegations for packages, etc.).</p>
<p>However, by requiring a quorum for sensitive operations, we limit the scope of a
single RM key compromise to the validation of new developer keys or delegations
(which should be the most common operation done by RMs): this enables to raise
the level of security of the new, malicious packages but otherwise doesn't
change much from what can be done with just access to the git repository.</p>
<p>A further compromise of a quorum of RM keys would allow to remove or tamper with
any developer key, delegation or package: any of these amounts to being able to
replace any package with a compromised version. Cleaning up would require
replacing all but the root keys, and resetting the repository to before any
malicious commit.</p>
<h2>Difference to TUF</h2>
<ul>
<li>we use git
</li>
<li>thus get linearity &quot;for free&quot;
</li>
<li>and already have a hash over the entire repository
</li>
<li>TUF provides a mechanism for delegation, but it's both heavier and not
expressive enough for what we wanted -- delegate to packages directly.
</li>
<li>We split in lots more files, and per-package ones, to fit with and nicely
extend the git-based workflow that made the success of opam. The original TUF
would have big json files signing for a lot of files, and likely to conflict.
Both developers and repository maintainers should be able to safely work
concurrently without issue. Signing bundles in TUF gives the additional
guarantee that no file is removed without proper signature, but this is
handled by git and signed tags.
</li>
<li>instead of a single file with all signed packages by a specific developer,
one file per package
</li>
</ul>
<h3>Differences to Haskell:</h3>
<ul>
<li>use TUF keys, not gpg
</li>
<li>e2e signing
</li>
</ul>

