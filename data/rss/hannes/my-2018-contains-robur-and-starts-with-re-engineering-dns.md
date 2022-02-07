---
title: My 2018 contains robur and starts with re-engineering DNS
description:
url: https://hannes.robur.coop/Posts/DNS
date: 2018-01-11T14:02:01-00:00
preview_image:
featured:
---

<h2>2018</h2>
<p>At the end of 2017, I resigned from my PostDoc position at University of
Cambridge (in the <a href="https://www.cl.cam.ac.uk/~pes20/rems/">rems</a> project).  Early
December 2017 I organised the <a href="https://mirage.io/blog/2017-winter-hackathon-roundup">4th MirageOS hack
retreat</a>, with which I'm
very satisfied.  In March 2018 the <a href="http://retreat.mirage.io">5th retreat</a> will
happen (please sign up!).</p>
<p>In 2018 I moved to Berlin and started to work for the (non-profit) <a href="https://techcultivation.org">Center for
the cultivation of technology</a> with our
<a href="http://robur.io">robur.io</a> project &quot;At robur, we build performant bespoke
minimal operating systems for high-assurance services&quot;.  robur is only possible
by generous donations in autumn 2017, enthusiastic collaborateurs, supportive
friends, and a motivated community, thanks to all.  We will receive funding from
the <a href="https://prototypefund.de/project/robur-io/">prototypefund</a> to work on a
<a href="https://robur.io/Our%20Work/Projects#CalDAV-Server">CalDAV server</a> implementation in OCaml
targeting MirageOS.  We're still looking for donations and further funding,
please get in touch.  Apart from CalDAV, I want to start the year by finishing
several projects which I discovered on my hard drive.  This includes DNS, <a href="https://hannes.robur.coop/Posts/Conex">opam
signing</a>, TCP, ... .  My personal goal for 2018 is to develop a
flexible <code>mirage deploy</code>, because after configuring and building a unikernel, I
want to get it smoothly up and running (spoiler: I already use
<a href="https://hannes.robur.coop/Posts/VMM">albatross</a> in production).</p>
<p>To kick off (3% of 2018 is already used) this year, I'll talk in more detail
about <a href="https://github.com/roburio/udns">&micro;DNS</a>, an opinionated from-scratch
re-engineered DNS library, which I've been using since Christmas 2017 in production for
<a href="https://github.com/hannesm/ns.nqsb.io">ns.nqsb.io</a> and
<a href="https://git.robur.io/?p=ns.robur.io.git%3Ba=summary">ns.robur.io</a>.  The
development started in March 2017, and continued over several evenings and long
weekends.  My initial motivation was to implement a recursive resolver to run on
my laptop.  I had a working prototype in use on my laptop over 4 months in the
summer 2017, but that code was not in a good shape, so I went down the rabbit
hole and (re)wrote a server (and learned more about GADT).  A configurable
resolver needs a server, as local overlay, usually anyways.  Furthermore,
dynamic updates are standardised and thus a configuration interface exists
inside the protocol, even with hmac-signatures for authentication!
Coincidentally, I started to solve another issue, namely automated management of let's
encrypt certificates (see <a href="https://github.com/hannesm/ocaml-letsencrypt/tree/nsupdate">this
branch</a> for an
initial hack).  On my journey, I also reported a cache poisoning vulnerability,
which was fixed in <a href="https://docs.docker.com/docker-for-windows/release-notes/#docker-community-edition-17090-ce-win32-2017-10-02-stable">Docker for
Windows</a>.</p>
<p>But let's get started with some content.  Please keep in mind that while the
code is publicly available, it is not yet released (mainly since the test
coverage is not high enough, and the lack of documentation).  I appreciate early
adopters, please let me know if you find any issues or find a use case which is
not straightforward to solve.  This won't be the last article about DNS this
year - persistent storage, resolver, let's encrypt support are still missing.</p>
<h2>What is DNS?</h2>
<p>The <a href="https://en.wikipedia.org/wiki/DNS">domain name system</a> is a core Internet
protocol, which translates domain names to IP addresses.  A domain name is
easier to memorise for human beings than an IP address.  DNS is hierarchical and
decentralised.  It was initially &quot;specified&quot; in Nov 1987 in <a href="https://tools.ietf.org/html/rfc1034">RFC
1034</a> and <a href="https://tools.ietf.org/html/rfc1035">RFC
1035</a>.  Nowadays it spans over more than 20
technical RFCs, 10 security related, 5 best current practises and another 10
informational.  The basic encoding and mechanisms did not change.</p>
<p>On the Internet, there is a set of root servers (administrated by IANA) which
provide the information about which name servers are authoritative for which top level
domain (such as &quot;.com&quot;).  They provide the information about which name servers are
responsible for which second level domain name (such as &quot;example.com&quot;), and so
on.  There are at least two name servers for each domain name in separate
networks - in case one is unavailable the other can be reached.</p>
<p>The building blocks for DNS are: the resolver, a stub (<code>gethostbyname</code> provided
by your C library) or caching forwarding resolver (at your ISP), which send DNS
packets to another resolver, or a recursive resolver which, once seeded with the
root servers, finds out the IP address of a requested domain name.  The other
part are authoritative servers, which reply to requests for their configured
domain.</p>
<p>To get some terminology, a DNS client sends a query, consisting of a domain
name and a query type, and expects a set of answers, which are called resource
records, and contain: name, time to live, type, and data.  The resolver
iteratively requests resource records from authoritative servers, until the requested
domain name is resolved or fails (name does not exist, server
failure, server offline).</p>
<p>DNS usually uses UDP as transport which is not reliable and limited to 512 byte
payload on the Internet (due to various middleboxes).  DNS can also be
transported via TCP, and even via TLS over UDP or TCP.  If a DNS packet
transferred via UDP is larger than 512 bytes, it is cut at the 512 byte mark,
and a bit in its header is set.  The receiver can decide whether to use the 512
bytes of information, or to throw it away and attempt a TCP connection.</p>
<h3>DNS packet</h3>
<p>The packet encoding starts with a 16bit identifier followed by a 16bit header
(containing operation, flags, status code), and four counters, each 16bit,
specifying the amount of resource records in the body: questions, answers,
authority records, and additional records.  The header starts with one bit
operation (query or response), four bits opcode, various flags (recursion,
authoritative, truncation, ...), and the last four bit encode the response code.</p>
<p>A question consists of a domain name, a query type, and a query class.  A
resource record additionally contains a 32bit time to live, a length, and the
data.</p>
<p>Each domain name is a case sensitive string of up to 255 bytes, separated by <code>.</code>
into labels of up to 63 bytes each.  A label is either encoded by its length
followed by the content, or by an offset to the start of a label in the current
DNS frame (poor mans compression).  Care must be taken during decoding to avoid
cycles in offsets.  Common operations on domain names are comparison: equality,
ordering, and also whether some domain name is a subdomain of another domain
name, should be efficient.  My initial representation na&iuml;vely was a list of
strings, now it is an array of strings in reverse order.  This speeds up common
operations by a factor of 5 (see test/bench.ml).</p>
<p>The only really used class is <code>IN</code> (for Internet), as mentioned in <a href="https://tools.ietf.org/html/rfc6895">RFC
6895</a>.  Various query types (<code>MD</code>, <code>MF</code>,
<code>MB</code>, <code>MG</code>, <code>MR</code>, <code>NULL</code>, <code>AFSDB</code>, ...) are barely or never used.  There is no
need to convolute the implementation and its API with these legacy options (if
you have a use case and see those in the wild, please tell me).</p>
<p>My implemented packet decoding does decompression, only allows valid internet
domain names, and may return a partial parse - to use as many resource records
in truncated packets as possible.  There are no exceptions raised, the parsing
uses a monadic style error handling.  Since label decompression requires the
parser to know absolute offsets, the original buffer and the offset is manually
passed around at all times, instead of using smaller views on the buffer.  The
decoder does not allow for gaps, when the outer resource data length specifies a
byte length which is not completely consumed by the specific resource data
subparser (an A record must always consume four bytes).  Failing to check this can
lead to a way to exfiltrate data without getting noticed.</p>
<p>Each zone (a served domain name) contains a SOA &quot;start of authority&quot; entry,
which includes the primary nameserver name, the hostmaster's email address (both
encoded as domain name), a serial number of the zone, a refresh, retry, expiry,
and minimum interval (all encoded as 32bit unsigned number in seconds).  Common
resource records include A, which payload is 32bit IPv4 address.  A nameserver
(NS) record carries a domain name as payload.  A mail exchange (MX) whose
payload is a 16bit priority and a domain name.  A CNAME record is an alias to
another domain name.  These days, there are even records to specify the
certificate authority authorisation (CAA) records containing a flag (critical),
a tag (&quot;issue&quot;) and a value (&quot;letsencrypt.org&quot;).</p>
<h2>Server</h2>
<p>The operation of a DNS server is to listen for a request and serve a reply.
Data to be served can be canonically encoded (the RFC describes the format) in a
zone file.  Apart from insecurity in DNS server implementations, another attack
vector are amplification attacks where an attacker crafts a small UDP frame
with a fake source IP address, and the server answers with a large response to
that address which may lead to a DoS attack.  Various mitigations exist
including rate limiting, serving large replies only via TCP, ...</p>
<p>Internally, the zone file data is stored in a tree (module
<a href="https://github.com/roburio/udns/blob/master/server/dns_trie.mli">Dns_trie</a>
<a href="https://github.com/roburio/udns/blob/master/server/dns_trie.ml">implementation</a>),
where each node contains two maps: <code>sub</code>, which key is a label and value is a
subtree and <code>dns_map</code> (module Dns_map), which key is a resource record type and
value is the resource record.  Both use the OCaml
<a href="http://caml.inria.fr/pub/docs/manual-ocaml/libref/Map.html">Map</a> (&quot;also known
as finite maps or dictionaries, given a total ordering function over the
keys. All operations over maps are purely applicative (no side-effects). The
implementation uses balanced binary trees, and therefore searching and insertion
take time logarithmic in the size of the map&quot;).</p>
<p>The server looks up the queried name, and in the returned Dns_map the queried
type. The found resource records are sent as answer, which also includes the
question and authority information (NS records of the zone) and additional glue
records (IP addresses of names mentioned earlier in the same zone).</p>
<h3>Dns_map</h3>
<p>The data structure which contains resource record types as key, and a collection
of matching resource records as values.  In OCaml the value type must be
homogenous - using a normal sum type leads to an unneccessary unpacking step
(or lacking type information):</p>
<pre><code class="language-OCaml">let lookup_ns t =
  match Map.find NS t with
  | None -&gt; Error `NotFound
  | Some (NS nameservers) -&gt; Ok nameservers
  | Some _ -&gt; Error `NotFound
</code></pre>
<p>Instead, I use in my current rewrite <a href="https://en.wikipedia.org/wiki/Generalized_algebraic_data_type">generalized algebraic data
types</a> (read
<a href="http://caml.inria.fr/pub/docs/manual-ocaml/extn.html#sec251">OCaml manual</a> and
<a href="http://mads-hartmann.com/ocaml/2015/01/05/gadt-ocaml.html">Mads Hartmann blog post about use cases for
GADTs</a>, <a href="https://andreas.github.io/2018/01/05/modeling-graphql-type-modifiers-with-gadts/">Andreas
Garn&aelig;s about using GADTs for GraphQL type
modifiers</a>)
to preserve a relation between key and value (and A record has a list of IPv4
addresses and a ttl as value) - similar to
<a href="http://erratique.ch/software/hmap">hmap</a>, but different: a closed key-value
mapping (the GADT), no int for each key and mutable state.  Thanks to Justus
Matthiesen for helping me with GADTs and this code.  Look into the
<a href="https://github.com/roburio/udns/blob/master/src/dns_map.mli">interface</a> and
<a href="https://github.com/roburio/udns/blob/master/src/dns_map.ml">implementation</a>.</p>
<pre><code class="language-OCaml">(* an ordering relation, I dislike using int for that *)
module Order = struct
  type (_,_) t =
    | Lt : ('a, 'b) t
    | Eq : ('a, 'a) t
    | Gt : ('a, 'b) t
end

module Key = struct
  (* The key and its value type *)
  type _ t =
    | Soa : (int32 * Dns_packet.soa) t
    | A : (int32 * Ipaddr.V4.t list) t
    | Ns : (int32 * Dns_name.DomSet.t) t
    | Cname : (int32 * Dns_name.t) t

  (* we need a total order on our keys *)
  let compare : type a b. a t -&gt; b t -&gt; (a, b) Order.t = fun t t' -&gt;
    let open Order in
    match t, t' with
    | Cname, Cname -&gt; Eq | Cname, _ -&gt; Lt | _, Cname -&gt; Gt
    | Ns, Ns -&gt; Eq | Ns, _ -&gt; Lt | _, Ns -&gt; Gt
    | Soa, Soa -&gt; Eq | Soa, _ -&gt; Lt | _, Soa -&gt; Gt
    | A, A -&gt; Eq
end

type 'a key = 'a Key.t

(* our OCaml Map with an encapsulated constructor as key *)
type k = K : 'a key -&gt; k
module M = Map.Make(struct
    type t = k
    (* the price I pay for not using int as three-state value *)
    let compare (K a) (K b) = match Key.compare a b with
      | Order.Lt -&gt; -1
      | Order.Eq -&gt; 0
      | Order.Gt -&gt; 1
  end)

(* v contains a key and value pair, wrapped by a single constructor *)
type v = V : 'a key * 'a -&gt; v

(* t is the main type of a Dns_map, used by clients *)
type t = v M.t

(* retrieve a typed value out of the store *)
let get : type a. a Key.t -&gt; t -&gt; a = fun k t -&gt;
  match M.find (K k) t with
  | V (k', v) -&gt;
    (* this comparison is superfluous, just for the types *)
    match Key.compare k k' with
    | Order.Eq -&gt; v
    | _ -&gt; assert false
</code></pre>
<p>This helps me to programmaticaly retrieve tightly typed values from the cache,
important when code depends on concrete values (i.e. when there are domain
names, look these up as well and add as additional records).  Look into <a href="https://github.com/roburio/udns/blob/master/server/dns_server.ml">server/dns_server.ml</a></p>
<h3>Dynamic updates, notifications, and authentication</h3>
<p><a href="https://tools.ietf.org/html/rfc2136">Dynamic updates</a> specify in-protocol
record updates (supported for example by <code>nsupdate</code> from ISC bind-tools),
<a href="https://tools.ietf.org/html/rfc1996">notifications</a> are used by primary servers
to notify secondary servers about updates, which then initiate a <a href="https://tools.ietf.org/html/rfc5936">zone
transfer</a> to retrieve up to date
data. <a href="https://tools.ietf.org/html/rfc2845">Shared hmac secrets</a> are used to
ensure that the transaction (update, zone transfer) was authorised.  These are
all protocol extensions, there is no need to use out-of-protocol solutions.</p>
<p>The server logic for update and zone transfer frames is slightly more complex,
and includes a dependency upon an authenticator (implemented using the
<a href="https://github.com/mirleft/ocaml-nocrypto">nocrypto</a> library, and
<a href="http://erratique.ch/software/ptime">ptime</a>).</p>
<h3>Deployment and Let's Encrypt</h3>
<p>To deploy servers without much persistent data, an authentication schema is
hardcoded in the dns-server: shared secrets are also stored as DNS entries
(DNSKEY), and <code>_transfer.zone</code>, <code>_update.zone</code>, and <code>_key-management.zone</code> names
are introduced to encode the permissions.  A <code>_transfer</code> key also needs to
encode the IP address of the primary (to know where to request zone transfers)
and secondary IP (to know where to send notifications).</p>
<p>Please have a look at
<a href="https://git.robur.io/?p=ns.robur.io.git%3Ba=summary">ns.robur.io</a> and the <a href="https://github.com/roburio/udns/blob/master/mirage/examples">examples</a> for more details.  The shared secrets are provided as boot parameter of the unikernel.</p>
<p>I hacked maker's
<a href="https://github.com/hannesm/ocaml-letsencrypt/tree/nsupdate">ocaml-letsencrypt</a>
library to use &micro;DNS and sending update frames to the given IP address.  I
already used this to have letsencrypt issue various certificates for my domains.</p>
<p>There is no persistent storage of updates yet, but this can be realised by
implementing a secondary (which is notified on update) that writes every new
zone to persistent storage (e.g. <a href="https://github.com/mirage/mirage-block">disk</a>
or <a href="https://github.com/mirage/ocaml-git">git</a>).  I also plan to have an
automated Let's Encrypt certificate unikernel which listens for certificate
signing requests and stores signed certificates in DNS.  Luckily the year only
started and there's plenty of time left.</p>
<p>I'm interested in feedback, either via <strike><a href="https://twitter.com/h4nnes">twitter</a></strike>
hannesm@mastodon.social or via eMail.</p>

