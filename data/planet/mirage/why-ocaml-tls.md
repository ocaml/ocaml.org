---
title: Why OCaml-TLS?
description:
url: https://mirage.io/blog/why-ocaml-tls
date: 2015-06-26T00:00:00-00:00
preview_image:
featured:
authors:
- Amir Chaudhry
---


        <p>TLS implementations have a history of security flaws, which are often the
result of implementation errors.  These security flaws stem from the
underlying challenges of interpreting ambiguous specifications, the
complexities of large APIs and code bases, and the use of unsafe programming
practices.</p>
<p>Re-engineering security-critical software allows the opportunity to use modern
approaches to prevent these recurring issues. Creating <a href="https://github.com/mirleft/ocaml-tls">the TLS stack in OCaml</a>
offers a range of benefits, including:</p>
<p><strong>Robust memory safety</strong>: Lack of memory safety was the largest single source
of vulnerabilities in various TLS stacks throughout 2014, including
<a href="http://heartbleed.com">Heartbleed (CVE-2014-0160)</a>. OCaml-TLS avoids this
class of issues entirely due to OCaml's automatic memory management, safety
guarantees and the use of a pure-functional programming style.</p>
<p><strong>Improved certificate validation</strong>: Implementation errors in other stacks
allowed validation to be skipped under certain conditions, leaving users
exposed (e.g.
<a href="https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2014-0092">CVE-2014-0092</a>).
In our TLS stack, we return errors explicitly as values and handle all
possible variants. The OCaml toolchain and compile-time checks ensure that
this has taken place.</p>
<p><strong>Mitigation of state machine errors</strong>: Errors such as
<a href="https://gotofail.com">Apple's GoTo Fail (CVE-2014-1266)</a> involved code being
skipped and a default 'success' value being returned, even though signatures
were never verified. Our approach encodes the state machine explicitly, while
state transitions default to failure. The code structure also makes clear the
need to consider preconditions.</p>
<p><strong>Elimination of downgrade attacks</strong>: Legacy requirements forced other TLS
stacks to incorporate weaker 'EXPORT' encryption ciphers. Despite the
environment changing, this code still exists and leads to attacks such as
<a href="https://freakattack.com">FREAK (CVE-2015-0204)</a> and
<a href="https://weakdh.org">Logjam (CVE-2015-4000)</a>. Our TLS server does not support
weaker EXPORT cipher suites so was never vulnerable to such attacks.
In addition our stack never supported SSLv3, which was known to be the cause of many vulnerabilities and is only now in the process of being deprecated (<a href="https://tools.ietf.org/html/rfc7568">RFC: 7568</a>).</p>
<p><strong>Greatly reduced TCB</strong>: The size of the trusted computing base (TCB) of a
system, measured in lines of code, is a widely accepted approximation of the
size of its attack surface.  Our secure Bitcoin Pi&ntilde;ata, a unikernel built
using our TLS stack, is less than 4% the size of an equivalent, traditional
stack (102 kloc as opposed to 2560 kloc).</p>
<p>These are just some of the benefits of re-engineering critical software using
modern techniques.</p>

      
