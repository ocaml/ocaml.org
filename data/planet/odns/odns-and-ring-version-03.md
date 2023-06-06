---
title: ODNS and ring version 0.3
description:
url: http://odns.tuxfamily.org/2011/03/02/odns-and-ring-version-0-3/
date: 2011-03-02T13:28:24-00:00
preview_image:
featured:
authors:
- odns
---

<p>So here they are, <a href="http://download.tuxfamily.org/odns/odns-0.3.tar.gz">the brand new ODNS library and the ring tool</a>. Below are the main changes.</p>
<h3>ODNS release notes</h3>
<dl>
<dt>Resolver class name changing</dt>
<dt>
</dt><dd>This is not a nice change to change the API, but I should have done it before. The main class of the library was named &ldquo;<code>query</code>&rdquo; and its main method (the one actually making the query) was &ldquo;<code>action</code>&ldquo;. That was actually historic naming before me, and though I often thought about updating it, I always left it unchanged. But when you think, that&rsquo;s a strange naming. The &ldquo;query&rdquo; class is actually a resolver, so I called it&hellip; &ldquo;<code>resolver</code>&rdquo; (tadada!). And the &ldquo;action&rdquo; method is actually when one makes the actual query, so it becomes&hellip; (suspense?!) &ldquo;<code>query</code>&ldquo;.<br/>
That&rsquo;s more logical naming and looking also much more like other DNS libraries (this second point is a minor reason though: I may name things differently if there is a good reason. Here I don&rsquo;t see any). Hopefully there should not be big naming change like this too often, but I allowed myself to do this one as this is still an early 0.2. Obviously when I&rsquo;ll arrive to a 1.x naming, API will be fully stable.</dd>

<dt>Runtime Cache</dt>
<dd>The library now caches, and uses in subsequent calls, the resource records through a complex algorithm taking the Time To Live values of records, and doing other processing (for instance a SOA record cannot have a TTL higher than 0, etc.). As I lock the cache, this feature is thread-safe (you can query names in separate threads in the same time. They will both share the same cache without any problem).<br/>
<strong>Notes</strong>:
<ol>
<li>this is only a &ldquo;runtime&rdquo; cache for now. Which means 2 programs running in the same time won&rsquo;t share the cache. Moreover the same program stopping will restart with a fresh cache. I plan to make a cache saving and sharing across the system in the next version.</li>
<li>Caching and getting result from cache is the default behavior. If you want to bypass the cache system (which means not storing, nor checking for recent records which answers your query), this is possible to configure the resolver class this way with the <code>resolver#set_nocache</code> method.</li>
</ol>
</dd>
<dt>Using resolvers as resolver templates</dt>
<dd>You may have a program where you need to do a lot of resolving and the default resolver configuration does not suit you. So there was one solution which was that you were re-setting all the configuration option each time you create a resolver. Now I created the function <code>Dns#resolver_from_model</code> whose basic use is to create a new resolver with the same configuration as another. This allows you to create a resolver that you keep on the global scope of your program for instance, then you create all other needed resolver from this &ldquo;template&rdquo;. Later if I create new configuration options in further version of the library and you want to set this option differently as well, you will have just one place in your program to update: the template. All other resolvers will be updated accordingly.<br/>
The helpers also uses now the same kind of template system thanks to an optional parameter <code>~configuration</code> making now the helper functions to be as powerful and customizable as the main resolver, with all the additional calculations.</dd>
<dt>Helpers now are multi-threaded.</dt>
<dd>Previously the helpers were making all queries one after another. So if you imagined a srv_lookup call on a domain, which returns 10 records and you want the IPv4 addresses and IPv6 addresses of all 10 of them (if they are not provided in the additional section by the name server, which is the recommended logics but is not done by all servers, and if we don&rsquo;t have the information in cache already), we were making 20 queries on a row. Now with threading I can make the 20 queries at the same time.</dd>
<dt>Annoying Makefile bug fixed</dt>
<dd>I noticed that I had an installation bug. Only the DNS module of the library was accessible. I fixed this. Now all 4 public modules are accessible: Dns (main module, low level functions and high level resolver), Iana (utility module to get IANA&rsquo;s number information), Dnsprint (utility module to pretty-print DNS stuffs. It needs to be improved and I don&rsquo;t advice to use it yet), Dns_helper (very high level DNS function, the most interesting module if there is already the function you need there!).</dd>
<dt>New Resolver configuration Options</dt>
<dd>
<ul>
<li>The nameservers can now be checked and set with object&rsquo;s methods. Moreover they are not anymore an optional parameter settable during resolver initialization because thinking this back, there is no reason to treat this configuration differently form others (and I used the fact I was already breaking everything by changing the name of the class as an excuse, but obviously this kind of thing also should not happen anymore if I can avoid it). This also allowed me to remove the unit parameter on the constructor which is necessary when there are only optional parameters.</li>
<li>The resolver can be set recursive (default) or not. This is not a local recursivity algorithm. It only sets our desire for the query to be recursive (depending on the name server&rsquo;s will to accept this or not).</li>
<li>You can set the resolver as &ldquo;verbose&rdquo; (default is disabled) to output into some channel (standard output, a file, whatever) resolution steps. This output can be set ANSI capable (default: not) if the output is for instance a terminal (to have nicer display).</li>
</ul>
</dd>
<dt>Failure Cases Handling</dt>
<dd>Cases of failures are now much better handled with <a href="http://odns.tuxfamily.org/doc/dns/html/Dns.resolver-c.html">documented exceptions in the API</a>, so that robust programs can be built above ODNS.</dd>
<dt>Various Bug Fixes</dt>
<dd>As always!</dd>
</dl>
<h3>ring release notes</h3>
<dl>
<dt>Verbose option with pretty color output</dt>
<dd>The color output can be disabled (-T), still keeping the verbosity (-v), if for instance you wanted to redirect the output to a file.</dd>
<dt>Recursion can be disabled</dt>
<dd>If you don&rsquo;t want to set recursion</dd>
<dt>Retries and timeout option can now be set</dt>
<dd></dd>
<dt>Better handling of error cases.</dt>
<dd></dd>
</dl>

