---
id: web
question: Is OCaml Web yet?
answer: Yes, but some parts are still missing
categories:
  - name: Web Frameworks
    status: 🟡
    description: |
      Web development frameworks for building OCaml Web applications.
    packages:
    - name: dream
    - name: eliom
    - name: opium
    - name: sihl
    - name: ocsigen-start
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
    - name: ts2ocaml
      extern:
        url: https://github.com/ocsigen/ts2ocaml
        synopsis: Generate OCaml bindings from TypeScript definitions via the TypeScript compiler API
    - name: ocsigen-toolkit
    - name: bonsai
    - name: ocaml-vdom
    - name: fmlib_browser
  - name: WebAssembly
    status: 🟡
    description: |
      Packages and tools for compiling OCaml code to WebAssembly.
    packages:
    - name: wasm_of_ocaml
      extern: 
        url: https://github.com/ocaml-wasm/wasm_of_ocaml
        synopsis: Compiler from OCaml bytecode to WebAssembly
    - name: wasocaml
      extern: 
        url: https://github.com/ocaml-wasm/wasocaml
        synopsis: Compiler from OCaml to WebAssembly
    - name: wasm
    - name: owi
  - name: Lower Web-Stack
    status: 🟡
    description: |
      Packages that provide foundational networking and communication capabilities.
    packages:
    - name: cohttp
    - name: httpaf
    - name: http
    - name: ocsigenserver
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
  - name: Templating
    status: 🟡
    description: |
      Packages that assist in generating dynamic HTML or text content.
    packages:
    - name: tyxml
    - name: embedded_ocaml_templates
    - name: dream_html
    - name: ppx_dream_eml
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
    - name: html_of_wiki
      extern:
        url: https://github.com/ocsigen/html_of_wiki
        synopsis: Static website generator for software projects
  - name: Mobile apps
    status: 🟡
    description: Packages for creating mobile applications
    packages:
    - name: eliom
    - name: ocsigen-start
    - name: cordova
    - name: Ocaml-chcp
      extern:
        url: https://github.com/besport/ocaml-chcp
        synopsis: Binding to use Cordova-Hot-Code-Push Javascript module into your OCaml mobile app
    - name: cordova-plugin-activity-indicator
    - name: cordova-plugin-background-mode
    - name: cordova-plugin-barcode-scanner
    - name: cordova-plugin-battery-status
    - name: cordova-plugin-camera
    - name: cordova-plugin-clipboard
    - name: cordova-plugin-datepicker
    - name: cordova-plugin-device
    - name: cordova-plugin-device-motion
    - name: cordova-plugin-device-orientation
    - name: cordova-plugin-dialogs
    - name: cordova-plugin-email-composer
    - name: cordova-plugin-fcm
    - name: cordova-plugin-file
    - name: cordova-plugin-file-opener
    - name: cordova-plugin-file-transfer
    - name: cordova-plugin-geolocation
    - name: cordova-plugin-globalization
    - name: cordova-plugin-image-picker
    - name: cordova-plugin-inappbrowser
    - name: cordova-plugin-insomnia
    - name: cordova-plugin-keyboard
    - name: cordova-plugin-loading-spinner
    - name: cordova-plugin-local-notifications
    - name: cordova-plugin-media
    - name: cordova-plugin-media-capture
    - name: cordova-plugin-network-information
    - name: cordova-plugin-progress
    - name: cordova-plugin-push-notifications
    - name: cordova-plugin-qrscanner
    - name: cordova-plugin-screen-orientation
    - name: cordova-plugin-sim-card
    - name: cordova-plugin-sms
    - name: cordova-plugin-social-sharing
    - name: cordova-plugin-statusbar
    - name: cordova-plugin-toast
    - name: cordova-plugin-touch-id
    - name: cordova-plugin-vibration
    - name: cordova-plugin-videoplayer
  - name: Authentication
    status: 🔴
    description: |
      Packages for authentication-related functionality in OCaml Web applications.
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
  - name: Database
    status: 🟠
    description: |
      Database-related packages for interacting with databases in OCaml Web applications, from simple connectors to type-safe SQL wrappers.
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
  - name: Internationalization
    status: 🆘
    description: |
      Internationalization and localization for OCaml applications.
    packages:
    - name: gettext
    - name: ocsigen-i18n
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
  - name: External Web APIs
    status: 🆘
    description: |
      Packages that provide OCaml bindings and clients for interacting with external Web APIs.
    packages:
    - name: spotify-web-api
    - name: disml
    - name: openai
    - name: github
    - name: telegraml
    - name: slacko
    - name: ocaml-googlemaps
      extern:
        url: https://github.com/besport/ocaml-googlemaps
        synopsis: OCaml binding for Google Map
    - name: geoloc
      extern:
        url: https://github.com/besport/geoloc
        synopsis: Library for geolocation features using Google Map
    - name: ocaml-woosmaps
      extern:
        url: https://github.com/besport/ocaml-woosmaps
        synopsis: OCaml binding for Woosmap
    - name: ocaml-mixpanel
      extern:
        url: https://github.com/besport/ocaml-mixpanel
        synopsis: Binding to mixpanel
    - name: ocaml-gapi
      extern:
        url: https://github.com/besport/ocaml-gapi
        synopsis: Binding to Google API to implement Google Sign-In in a Web application
    - name: ocaml-twttr
      extern:
        url: https://github.com/besport/ocaml-twttr
        synopsis: Binding to the twttr Javascript plugin (Twitter)
    - name: ocaml-gtag
      extern:
        url: https://github.com/besport/ocaml-gtag
        synopsis: Binding to Google GTag
    - name: ocaml-hls
      extern:
        url: https://github.com/besport/ocaml-hls
        synopsis: Binding to hls.js to use hls video players in OCaml apps
    - name: ocaml-js-video-players
      extern:
        url: https://github.com/besport/ocaml-js-video-players
        synopsis: Add different video players to your OCaml Web or mobile app (Youtube, Dailymotion, Vimeo)
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
  - name: Compression
    status: 🟡
    description: |
      Packages that enable compression and decompression of data in OCaml Web applications.
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
---

OCaml, traditionally known for its strength in systems programming, formal verification, and as the language of choice for numerous academic endeavors, is steadily maturing in the Web development landscape. With its strong static typing, emphasis on immutability, and excellent performance, it is gradually making a case for itself as a viable alternative to mainstream Web development languages.

The Web in OCaml is fast and type-safe! According to your needs, you can
choose to use tidy server-side Web frameworks, or innovative full-stack
solutions for integrated Web and mobile applications. To run in the
browser, OCaml compiles to JavaScript and WebAssembly!

As a matter of fact, OCaml is used to power production Web systems, like
[Ahrefs](/success-stories/peta-byte-scale-web-crawler),
[OCaml.org](https://github.com/ocaml/ocaml.org) or the [Be
Sport](https://besport.com/news) social network.

If you're considering using OCaml for your next Web application, you
should be aware that you might have to write a noticeable amount of
things yourself and won't yet get an equivalent of all the features you
may be used to coming from other languages. In particular, OCaml doesn't
have out-of-the-box solutions for authentication or a fully
production-ready query-builder. You'll also probably have some
challenges if you need to interact with external services or external
APIs.

However, this is often more than offset by the time you save thanks to
the advantages of the language and the power of certain tools. The
language's powerful type system will save you a lot of debugging time by
eliminating many problems at compile time (such as html conformity).
Innovative solutions such as multi-tier programming can drastically
simplify client-server communication. Last but not least, OCaml can even
allow you to program your Web and mobile application in a single code.

## Want to Help?

Here are some projects that would help make OCaml a stronger candidate for Web applications:
- Improve [ocaml-swagger](https://github.com/andrenth/ocaml-swagger) to be able to generate API for popular Web APIs like Stripe.
- Implement a converter from [JSON Schema](https://json-schema.org/) to [ATD](https://github.com/ahrefs/atd). This would allow generating OCaml serializers for data formats that provide a JSON Schema (a lot of them do!).
- Create an Oauth2 client library.
- Create clients to the Azure services APIs.
