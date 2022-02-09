---
title: Traceroute
description:
url: https://hannes.robur.coop/Posts/Traceroute
date: 2020-06-24T10:38:10-00:00
preview_image:
featured:
---

<h2>Traceroute</h2>
<p>Is a diagnostic utility which displays the route and measures transit delays of
packets across an Internet protocol (IP) network.</p>
<pre><code class="language-bash">$ doas solo5-hvt --net:service=tap0 -- traceroute.hvt --ipv4=10.0.42.2/24 --ipv4-gateway=10.0.42.1 --host=198.167.222.207
            |      ___|
  __|  _ \  |  _ \ __ \
\__ \ (   | | (   |  ) |
____/\___/ _|\___/____/
Solo5: Bindings version v0.6.5
Solo5: Memory map: 512 MB addressable:
Solo5:   reserved @ (0x0 - 0xfffff)
Solo5:       text @ (0x100000 - 0x212fff)
Solo5:     rodata @ (0x213000 - 0x24bfff)
Solo5:       data @ (0x24c000 - 0x317fff)
Solo5:       heap &gt;= 0x318000 &lt; stack &lt; 0x20000000
2020-06-22 15:41:25 -00:00: INF [netif] Plugging into service with mac 76:9b:36:e0:e5:74 mtu 1500
2020-06-22 15:41:25 -00:00: INF [ethernet] Connected Ethernet interface 76:9b:36:e0:e5:74
2020-06-22 15:41:25 -00:00: INF [ARP] Sending gratuitous ARP for 10.0.42.2 (76:9b:36:e0:e5:74)
2020-06-22 15:41:25 -00:00: INF [udp] UDP interface connected on 10.0.42.2
2020-06-22 15:41:25 -00:00: INF [application]  1  10.0.42.1  351us
2020-06-22 15:41:25 -00:00: INF [application]  2  192.168.42.1  1.417ms
2020-06-22 15:41:25 -00:00: INF [application]  3  192.168.178.1  1.921ms
2020-06-22 15:41:25 -00:00: INF [application]  4  88.72.96.1  16.716ms
2020-06-22 15:41:26 -00:00: INF [application]  5  *
2020-06-22 15:41:27 -00:00: INF [application]  6  92.79.215.112  16.794ms
2020-06-22 15:41:27 -00:00: INF [application]  7  145.254.2.215  21.305ms
2020-06-22 15:41:27 -00:00: INF [application]  8  145.254.2.217  22.05ms
2020-06-22 15:41:27 -00:00: INF [application]  9  195.89.99.1  21.088ms
2020-06-22 15:41:27 -00:00: INF [application] 10  62.115.9.133  20.105ms
2020-06-22 15:41:27 -00:00: INF [application] 11  213.155.135.82  30.861ms
2020-06-22 15:41:27 -00:00: INF [application] 12  80.91.246.200  30.716ms
2020-06-22 15:41:27 -00:00: INF [application] 13  80.91.253.163  28.315ms
2020-06-22 15:41:27 -00:00: INF [application] 14  62.115.145.27  30.436ms
2020-06-22 15:41:27 -00:00: INF [application] 15  80.67.4.239  42.826ms
2020-06-22 15:41:27 -00:00: INF [application] 16  80.67.10.147  47.213ms
2020-06-22 15:41:27 -00:00: INF [application] 17  198.167.222.207  48.598ms
Solo5: solo5_exit(0) called
</code></pre>
<p>This means with a traceroute utility you can investigate which route is taken
to a destination host, and what the round trip time(s) on the path are. The
sample output above is taken from a virtual machine on my laptop to the remote
host 198.167.222.207. You can see there are 17 hops between us, with the first
being my laptop with a tiny round trip time of 351us, the second and third are
using private IP addresses, and are my home network. The round trip time of the
fourth hop is much higher, this is the first hop on the other side of my DSL
modem. You can see various hops on the public Internet: the packets pass from
my Internet provider's backbone across some exchange points to the destination
Internet provider somewhere in Sweden.</p>
<p>The implementation of traceroute relies mainly on the time-to-live (ttl) field
(in IPv6 lingua it is &quot;hop limit&quot;) of IP packets, which is meant to avoid route
cycles that would infinitely forward IP packets in circles. Every router, when
forwarding an IP packet, first checks that the ttl field is greater than zero,
and then forwards the IP packet where the ttl is decreased by one. If the ttl
field is zero, instead of forwarding, an ICMP time exceeded packet is sent back
to the source.</p>
<p>Traceroute works by exploiting this mechanism: a series of IP packets with
increasing ttls is sent to the destination. Since upfront the length of the
path is unknown, it is a reactive system: first send an IP packet with a ttl of
one, if a ICMP time exceeded packet is returned, send an IP packet with a ttl of
two, etc. -- until an ICMP packet of type destination unreachable is received.
Since some hosts do not reply with a time exceeded message, it is crucial for
not getting stuck to use a timeout for each packet: when the timeout is reached,
an IP packet with an increased ttl is sent and an unknown for the ttl is
printed (see the fifth hop in the example above).</p>
<p>The packets send out are conventionally UDP packets without payload. From a
development perspective, one question is how to correlate the ICMP packet
with the sent UDP packet. Conveniently, ICMP packets contain the IP header and
the first eight bytes of the next protocol - the UDP header containing source
port, destination port, checksum, and payload length (each fields of size two
bytes). This means when we record the outgoing ports together with the sent
timestamp, and correlate the later received ICMP packet to the sent packet.
Great.</p>
<p>But as a functional programmer, let's figure whether we can abolish the
(globally shared) state. Since the ICMP packet contains the original IP
header and the first eight bytes of the UDP header, this is where we will
embed data. As described above, the data is the sent timestamp and the value
of the ttl field. For the latter, we can arbitrarily restrict it to 31 (5 bits).
For the timestamp, it is mainly a question about precision and maximum expected
round trip time. Taking the source and destination port are 32 bits, using 5 for
ttl, remaining are 27 bits (an unsigned value up to 134217727). Looking at the
decimal representation, 1 second is likely too small, 13 seconds are sufficient
for the round trip time measurement. This implies our precision is 100ns, by
counting the digits.</p>
<p>Finally to the code. First we need forth and back conversions between ports
and ttl, timestamp:</p>
<pre><code class="language-OCaml">(* takes a time-to-live (int) and timestamp (int64, nanoseconda), encodes them
   into 16 bit source port and 16 bit destination port:
   - the timestamp precision is 100ns (thus, it is divided by 100)
   - use the bits 27-11 of the timestamp as source port
   - use the bits 11-0 as destination port, and 5 bits of the ttl
*)
let ports_of_ttl_ts ttl ts =
  let ts = Int64.div ts 100L in
  let src_port = 0xffff land (Int64.(to_int (shift_right ts 11)))
  and dst_port = 0xffe0 land (Int64.(to_int (shift_left ts 5))) lor (0x001f land ttl)
  in
  src_port, dst_port

(* inverse operation of ports_of_ttl_ts for the range (src_port and dst_port
   are 16 bit values) *)
let ttl_ts_of_ports src_port dst_port =
  let ttl = 0x001f land dst_port in
  let ts =
    let low = Int64.of_int (dst_port lsr 5)
    and high = Int64.(shift_left (of_int src_port) 11)
    in
    Int64.add low high
  in
  let ts = Int64.mul ts 100L in
  ttl, ts
</code></pre>
<p>They should be inverse over the range of valid input: ports are 16 bit numbers,
ttl expected to be at most 31, ts a int64 expressed in nanoseconds.</p>
<p>Related is the function to print out one hop and round trip measurement:</p>
<pre><code class="language-OCaml">(* write a log line of a hop: the number, IP address, and round trip time *)
let log_one now ttl sent ip =
  let now = Int64.(mul (logand (div now 100L) 0x7FFFFFFL) 100L) in
  let duration = Mtime.Span.of_uint64_ns (Int64.sub now sent) in
  Logs.info (fun m -&gt; m &quot;%2d  %a  %a&quot; ttl Ipaddr.V4.pp ip Mtime.Span.pp duration)
</code></pre>
<p>The most logic is when a ICMP packet is received:</p>
<pre><code class="language-OCaml">module Icmp = struct
  type t = {
    send : int -&gt; unit Lwt.t ;
    log : int -&gt; int64 -&gt; Ipaddr.V4.t -&gt; unit ;
    task_done : unit Lwt.u ;
  }

  let connect send log task_done =
    let t = { send ; log ; task_done } in
    Lwt.return t

  (* This is called for each received ICMP packet. *)
  let input t ~src ~dst buf =
    let open Icmpv4_packet in
    (* Decode the received buffer (the IP header has been cut off already). *)
    match Unmarshal.of_cstruct buf with
    | Error s -&gt;
      Lwt.fail_with (Fmt.strf &quot;ICMP: error parsing message from %a: %s&quot; Ipaddr.V4.pp src s)
    | Ok (message, payload) -&gt;
      let open Icmpv4_wire in
      (* There are two interesting cases: Time exceeded (-&gt; send next packet),
         and Destination (port) unreachable (-&gt; we reached the final host and can exit) *)
      match message.ty with
      | Time_exceeded -&gt;
        (* Decode the payload, which should be an IPv4 header and a protocol header *)
        begin match Ipv4_packet.Unmarshal.header_of_cstruct payload with
          | Ok (pkt, off) when
              (* Ensure this packet matches our sent packet: the protocol is UDP
                 and the destination address is the host we're tracing *)
              pkt.Ipv4_packet.proto = Ipv4_packet.Marshal.protocol_to_int `UDP &amp;&amp;
              Ipaddr.V4.compare pkt.Ipv4_packet.dst (Key_gen.host ()) = 0 -&gt;
            let src_port = Cstruct.BE.get_uint16 payload off
            and dst_port = Cstruct.BE.get_uint16 payload (off + 2)
            in
            (* Retrieve ttl and sent timestamp, encoded in the source port and
               destination port of the UDP packet we sent, and received back as
               ICMP payload. *)
            let ttl, sent = ttl_ts_of_ports src_port dst_port in
            (* Log this hop. *)
            t.log ttl sent src;
            (* Sent out the next UDP packet with an increased ttl. *)
            let ttl' = succ ttl in
            Logs.debug (fun m -&gt; m &quot;ICMP time exceeded from %a to %a, now sending with ttl %d&quot;
                           Ipaddr.V4.pp src Ipaddr.V4.pp dst ttl');
            t.send ttl'
          | Ok (pkt, _) -&gt;
            (* Some stray ICMP packet. *)
            Logs.debug (fun m -&gt; m &quot;unsolicited time exceeded from %a to %a (proto %X dst %a)&quot;
                           Ipaddr.V4.pp src Ipaddr.V4.pp dst pkt.Ipv4_packet.proto Ipaddr.V4.pp pkt.Ipv4_packet.dst);
            Lwt.return_unit
          | Error e -&gt;
            (* Decoding error. *)
            Logs.warn (fun m -&gt; m &quot;couldn't parse ICMP time exceeded payload (IPv4) (%a -&gt; %a) %s&quot;
                          Ipaddr.V4.pp src Ipaddr.V4.pp dst e);
            Lwt.return_unit
        end
      | Destination_unreachable when Ipaddr.V4.compare src (Key_gen.host ()) = 0 -&gt;
        (* We reached the final host, and the destination port was not listened to *)
        begin match Ipv4_packet.Unmarshal.header_of_cstruct payload with
          | Ok (_, off) -&gt;
            let src_port = Cstruct.BE.get_uint16 payload off
            and dst_port = Cstruct.BE.get_uint16 payload (off + 2)
            in
            (* Retrieve ttl and sent timestamp. *)
            let ttl, sent = ttl_ts_of_ports src_port dst_port in
            (* Log the final hop. *)
            t.log ttl sent src;
            (* Wakeup the waiter task to exit the unikernel. *)
            Lwt.wakeup t.task_done ();
            Lwt.return_unit
          | Error e -&gt;
            (* Decoding error. *)
            Logs.warn (fun m -&gt; m &quot;couldn't parse ICMP unreachable payload (IPv4) (%a -&gt; %a) %s&quot;
                          Ipaddr.V4.pp src Ipaddr.V4.pp dst e);
            Lwt.return_unit
        end
      | ty -&gt;
        Logs.debug (fun m -&gt; m &quot;ICMP unknown ty %s from %a to %a: %a&quot;
                       (ty_to_string ty) Ipaddr.V4.pp src Ipaddr.V4.pp dst
                       Cstruct.hexdump_pp payload);
        Lwt.return_unit
end
</code></pre>
<p>Now, the remaining main unikernel is the module <code>Main</code>:</p>
<pre><code class="language-OCaml">module Main (R : Mirage_random.S) (M : Mirage_clock.MCLOCK) (Time : Mirage_time.S) (N : Mirage_net.S) = struct
  module ETH = Ethernet.Make(N)
  module ARP = Arp.Make(ETH)(Time)
  module IPV4 = Static_ipv4.Make(R)(M)(ETH)(ARP)
  module UDP = Udp.Make(IPV4)(R)

  (* Global mutable state: the timeout task for a sent packet. *)
  let to_cancel = ref None

  (* Send a single packet with the given time to live. *)
  let rec send_udp udp ttl =
    (* This is called by the ICMP handler which successfully received a
       time exceeded, thus we cancel the timeout task. *)
    (match !to_cancel with
     | None -&gt; ()
     | Some t -&gt; Lwt.cancel t ; to_cancel := None);
    (* Our hop limit is 31 - 5 bit - should be sufficient for most networks. *)
    if ttl &gt; 31 then
      Lwt.return_unit
    else
      (* Create a timeout task which:
         - sleeps for --timeout interval
         - logs an unknown hop
         - sends another packet with increased ttl
      *)
      let cancel =
        Lwt.catch (fun () -&gt;
            Time.sleep_ns (Duration.of_ms (Key_gen.timeout ())) &gt;&gt;= fun () -&gt;
            Logs.info (fun m -&gt; m &quot;%2d  *&quot; ttl);
            send_udp udp (succ ttl))
          (function Lwt.Canceled -&gt; Lwt.return_unit | exc -&gt; Lwt.fail exc)
      in
      (* Assign this timeout task. *)
      to_cancel := Some cancel;
      (* Figure out which source and destination port to use, based on ttl
         and current timestamp. *)
      let src_port, dst_port = ports_of_ttl_ts ttl (M.elapsed_ns ()) in
      (* Send packet via UDP. *)
      UDP.write ~ttl ~src_port ~dst:(Key_gen.host ()) ~dst_port udp Cstruct.empty &gt;&gt;= function
      | Ok () -&gt; Lwt.return_unit
      | Error e -&gt; Lwt.fail_with (Fmt.strf &quot;while sending udp frame %a&quot; UDP.pp_error e)

  (* The main unikernel entry point. *)
  let start () () () net =
    let cidr = Key_gen.ipv4 ()
    and gateway = Key_gen.ipv4_gateway ()
    in
    let log_one = fun port ip -&gt; log_one (M.elapsed_ns ()) port ip
    (* Create a task to wait on and a waiter to wakeup. *)
    and t, w = Lwt.task ()
    in
    (* Setup network stack: ethernet, ARP, IPv4, UDP, and ICMP. *)
    ETH.connect net &gt;&gt;= fun eth -&gt;
    ARP.connect eth &gt;&gt;= fun arp -&gt;
    IPV4.connect ~cidr ~gateway eth arp &gt;&gt;= fun ip -&gt;
    UDP.connect ip &gt;&gt;= fun udp -&gt;
    let send = send_udp udp in
    Icmp.connect send log_one w &gt;&gt;= fun icmp -&gt;

    (* The callback cascade for an incoming network packet. *)
    let ethif_listener =
      ETH.input
        ~arpv4:(ARP.input arp)
        ~ipv4:(
          IPV4.input
            ~tcp:(fun ~src:_ ~dst:_ _ -&gt; Lwt.return_unit)
            ~udp:(fun ~src:_ ~dst:_ _ -&gt; Lwt.return_unit)
            ~default:(fun ~proto ~src ~dst buf -&gt;
                match proto with
                | 1 -&gt; Icmp.input icmp ~src ~dst buf
                | _ -&gt; Lwt.return_unit)
            ip)
        ~ipv6:(fun _ -&gt; Lwt.return_unit)
        eth
    in
    (* Start the callback in a separate asynchronous task. *)
    Lwt.async (fun () -&gt;
        N.listen net ~header_size:Ethernet_wire.sizeof_ethernet ethif_listener &gt;|= function
        | Ok () -&gt; ()
        | Error e -&gt; Logs.err (fun m -&gt; m &quot;netif error %a&quot; N.pp_error e));
    (* Send the initial UDP packet with a ttl of 1. This entails the domino
       effect to receive ICMP packets, send out another UDP packet with ttl
       increased by one, etc. - until a destination unreachable is received,
       or the hop limit is reached. *)
    send 1 &gt;&gt;= fun () -&gt;
    t
end
</code></pre>
<p>The configuration (<code>config.ml</code>) for this unikernel is as follows:</p>
<pre><code class="language-OCaml">open Mirage

let host =
  let doc = Key.Arg.info ~doc:&quot;The host to trace.&quot; [&quot;host&quot;] in
  Key.(create &quot;host&quot; Arg.(opt ipv4_address (Ipaddr.V4.of_string_exn &quot;141.1.1.1&quot;) doc))

let timeout =
  let doc = Key.Arg.info ~doc:&quot;Timeout (in millisecond)&quot; [&quot;timeout&quot;] in
  Key.(create &quot;timeout&quot; Arg.(opt int 1000 doc))

let ipv4 =
  let doc = Key.Arg.info ~doc:&quot;IPv4 address&quot; [&quot;ipv4&quot;] in
  Key.(create &quot;ipv4&quot; Arg.(required ipv4 doc))

let ipv4_gateway =
  let doc = Key.Arg.info ~doc:&quot;IPv4 gateway&quot; [&quot;ipv4-gateway&quot;] in
  Key.(create &quot;ipv4-gateway&quot; Arg.(required ipv4_address doc))

let main =
  let packages = [
    package ~sublibs:[&quot;ipv4&quot;; &quot;udp&quot;; &quot;icmpv4&quot;] &quot;tcpip&quot;;
    package &quot;ethernet&quot;;
    package &quot;arp-mirage&quot;;
    package &quot;mirage-protocols&quot;;
    package &quot;mtime&quot;;
  ] in
  foreign
    ~keys:[Key.abstract ipv4 ; Key.abstract ipv4_gateway ; Key.abstract host ; Key.abstract timeout]
    ~packages
    &quot;Unikernel.Main&quot;
    (random @-&gt; mclock @-&gt; time @-&gt; network @-&gt; job)

let () =
  register &quot;traceroute&quot;
    [ main $ default_random $ default_monotonic_clock $ default_time $ default_network ]
</code></pre>
<p>And voila, that's all the code. If you copy it together (or download the two
files from <a href="https://github.com/roburio/traceroute">the GitHub repository</a>),
and have OCaml, opam, and <a href="https://mirage.io/wiki/install">mirage (&gt;= 3.8.0)</a> installed,
you should be able to:</p>
<pre><code class="language-bash">$ mirage configure -t hvt
$ make depend
$ make
$ solo5-hvt --net:service=tap0 -- traceroute.hvt ...
... get the output shown at top ...
</code></pre>
<p>Enhancements may be to use a different protocol (TCP? or any other protocol ID (may be used to encode more information), encode data into IPv4 ID, or the full 8 bytes of the upper protocol), encrypt/authenticate the data transmitted (and verify it has not been tampered with in the ICMP reply), improve error handling and recovery, send multiple packets for improved round trip time measurements, ...</p>
<p>If you develop enhancements you'd like to share, please sent a pull request to the git repository.</p>
<p>Motivation for this traceroute unikernel was while talking with <a href="https://twitter.com/networkservice">Aaron</a> and <a href="https://github.com/phaer">Paul</a>, who contributed several patches to the IP stack which pass the ttl through.</p>
<p>If you want to support our work on MirageOS unikernels, please <a href="https://robur.coop/Donate">donate to robur</a>. I'm interested in feedback, either via <a href="https://twitter.com/h4nnes">twitter</a>, <a href="https://mastodon.social/@hannesm">hannesm@mastodon.social</a> or via eMail.</p>

