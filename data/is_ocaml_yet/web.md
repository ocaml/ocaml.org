---
id: web
question: Is OCaml web yet?
answer: Not quite yet, but we're getting there!
categories:
  - name: Authentication
    status: 🔴
    description: |
      Packages for authentication-related functionality in OCaml web applications.
    packages:
    - name: jwt
    - name: cookie
    - name: FPauth
    - name: u2f
    - name: webauthn
    - name: ssl
    - name: twostep
    - name: oidc
    - name: spoke
  - name: Binary protocols
    status: 🟡
    description: |
      There are implementations for a lot of popular protocols, some of them are solid, but some of them are still incomplete and need more testing. Some useful protocols for which there is no package include FlatBuffers and AMQP.
    packages:
    - name: asn1-combinators
    - name: avro
    - name: capnp
    - name: grpc
    - name: protobuf
    - name: rpc
    - name: jsonrpc
    - name: thrift
    - name: bson
    - name: cbor
    - name: mqtt
    - name: msgpck
  - name: Browser
    status: 🟢
    description: |
      OCaml has excellent support for running in the browser!
      The [Js_of_ocaml](/p/js_of_ocaml/latest) compiler, which translates OCaml into JavaScript, is a well-established tool dating back to 2010. It integrates seamlessly with the existing OCaml ecosystem and powers numerous production applications.

      In addition, [Melange](/p/melange/latest) is a more recent entry to the OCaml-JavaScript compiler space. Originating as a fork of [ReScript](https://rescript-lang.org/), Melange may not have the extensive track record of Js_of_ocaml, but it builds on a very strong foundation and already integrates well with Dune, the OCaml build system.
    packages:
    - name: js_of_ocaml
    - name: melange
    - name: brr
    - name: gen_js_api
    - name: bonsai
    - name: ocaml-vdom
    - name: fmlib_browser
  - name: Compression
    status: 🟡
    description: |
      Packages that enable compression and decompression of data in OCaml web applications.
    packages:
    - name: zlib
    - name: decompress
    - name: camlzip
    - name: lz4
    - name: ezgzip
    - name: hpack
    - name: brotli
    - name: zstd
    - name: snappy
    - name: lzo
    - name: zstandard
    - name: carton
  - name: Cryptography
    status: 🟡
    description: |
      Packages for secure communication, encryption, hashing, and other cryptographic operations.
    packages:
    - name: cryptokit
    - name: mirage-crypto
    - name: nocrypto
    - name: pkcs11
    - name: tls
    - name: x509
    - name: fiat-p256
    - name: sha
    - name: blake2
    - name: blake3
    - name: bls12-381
    - name: pbkdf
    - name: dirsp-proscript
    - name: digestif
  - name: Database
    status: 🟠
    description: |
      Database-related packages for interacting with databases in OCaml web applications, from simple connectors to type-safe SQL wrappers.
    packages:
    - name: petrol
    - name: caqti
    - name: pgocaml
    - name: sqlite3
    - name: lmdb
    - name: irmin
    - name: mysql
    - name: postgresql
    - name: aws-rds
    - name: sequoia
    - name: sqlgg
    - name: mariadb
  - name: Email
    status: 🟠
    description: |
      Packages for sending and managing email communications.
    packages:
    - name: tidy_email
    - name: emile
    - name: smtp
    - name: letters
    - name: mrmime
    - name: sendmail
    - name: received
    - name: email_message
    - name: colombe
    - name: dkim
    - name: uspf
  - name: En- & Decoding
    status: 🟠
    description: |
      Encoding and decoding various data formats.
    packages:
    - name: tar
    - name: imagelib
    - name: base64
    - name: multipart-form-data
    - name: multipart_form
    - name: biniou
  - name: Web Frameworks
    status: 🟠
    description: |
      Web development frameworks for building OCaml web applications.
    packages:
    - name: dream
    - name: eliom
    - name: opium
    - name: sihl
  - name: HTTP Clients
    status: 🔴
    description: |
      HTTP client libraries for making HTTP requests.
    packages:
    - name: cohttp
    - name: hyper
    - name: ocurl
    - name: http-lwt-client
    - name: ezcurl
  - name: Internationalization
    status: 🆘
    description: |
      Internationalization and localization for OCaml applications.
    packages:
    - name: gettext
  - name: Logging
    status: 🟠
    description: |
      Packages for logging and monitoring that assist in tracking application behavior and performance.
    packages:
    - name: logs
    - name: dolog
    - name: tracing
    - name: catapult
    - name: opentelemetry
    - name: prometheus
  - name: Lower Web-Stack
    status: 🟡
    description: |
      Packages that provide foundational networking and communication capabilities.
    packages:
    - name: httpaf
    - name: http
    - name: tls
    - name: websocket
    - name: websocketaf
    - name: gluten
    - name: awa
    - name: uri
    - name: dns
    - name: tcpip
    - name: charrua
    - name: mirage-nat
    - name: arp
    - name: ethernet
    - name: paf
    - name: mimic
    - name: tiny_httpd
  - name: Message Queues & Key-Value Stores
    status: 🆘
    description: |
      Packages for interacting with popular message queues and key-value stores.
    packages:
    - name: amqp-client
    - name: kafka
    - name: redis
    - name: zmq
  - name: Serializers
    status: 🟡
    description: |
      Packages for serializing and deserializing data in different formats.
    packages:
    - name: atd
    - name: yojson
    - name: jsonm
    - name: sexplib
    - name: yaml
    - name: csv
    - name: bencode
    - name: toml
    - name: xml-light
    - name: graphql
    - name: omd
    - name: cmarkit
    - name: css
    - name: csexp
    - name: data-encoding
  - name: Syndication/RSS
    status: 🟡
    description: |
      Packages for syndicating content and working with RSS feeds.
    packages:
    - name: syndic
    - name: river
    - name: rss
  - name: Templating
    status: 🟡
    description: |
      Packages that assist in generating dynamic HTML or text content.
    packages:
    - name: tyxml
    - name: embedded_ocaml_templates
    - name: mustache
    - name: jingoo
  - name: Static Site Generation
    status: 🟡
    description: |
      Packages for generating static websites.
    packages:
    - name: finch
    - name: stone
    - name: camyll
    - name: yocaml
      extern:
        url: https://github.com/xhtmlboi/yocaml
        synopsis: YOCaml is a static site generator, mostly written in OCaml
    - name: dream-serve
    - name: soupault
  - name: External Web APIs
    status: 🆘
    description: |
      Packages that provide OCaml bindings and clients for interacting with external web APIs.
    packages:
    - name: spotify-web-api
    - name: disml
    - name: openai
    - name: github
    - name: telegraml
    - name: slacko
  - name: WebAssembly
    status: 🔴
    description: |
      Packages and tools for compiling OCaml code to WebAssembly.
    packages:
    - name: wasm
    - name: owi
---

OCaml, traditionally known for its strength in systems programming, formal verification, and as the language of choice for numerous academic endeavors, is steadily maturing in the web development landscape. With its strong static typing, emphasis on immutability, and excellent performance, it is gradually making a case for itself as a viable alternative to mainstream web development languages.

As a matter of fact, OCaml is used to power production web systems, like [Ahrefs](/success-stories/peta-byte-scale-web-crawler) and [OCaml.org](https://github.com/ocaml/ocaml.org).

If you're considering using OCaml for your next web application, you should be aware that you'll likely have to write a noticeable amount of things yourself and won't yet get an equivalent of some frameworks you may be used to coming from other languages. In particular, OCaml doesn't have out-of-the-box solutions for authentication or a fully production-ready query-builder. You'll also probably have some challenges if you need to interact with external services or external APIs.

## Want to Help?

Here are some projects that would help make OCaml a stronger candidate for web applications:
- Improve [ocaml-swagger](https://github.com/andrenth/ocaml-swagger) to be able to generate API for popular web APIs like Stripe.
- Implement a converter from [JSON Schema](https://json-schema.org/) to [ATD](https://github.com/ahrefs/atd). This would allow generating OCaml serializers for data formats that provide a JSON Schema (a lot of them do!).
- Create an Oauth2 client library.
- Create clients to the Azure services APIs.
