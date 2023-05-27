---
id: web
question: Are we web yet?
answer: Not quite yet, but we're getting there!
categories:
  - name: Authentication
    status: 🆘
    description: n/a
    packages:
    - FPauth
    - u2f
    - webauthn
    - jwt
    - cookie
    - ssl
    - twostep
    - oidc
  - name: Binary protocols
    status: 🟡
    description: There are implementations for most protocols, some of them are really solid, but some of them are still incomplete and need more testing. Some useful protocols for which there is no package include FlatBuffers and AMQP.
    packages:
    - asn1-combinators
    - avro
    - capnp
    - grpc
    - protobuf
    - rpc
    - jsonrpc
    - thrift
    - bson
    - cbor
    - mqtt
  - name: Compression
    status: 🟡
    description: n/a
    packages:
    - zlib
    - decompress
    - camlzip
    - lz4
    - ezgzip
    - hpack
    - brotli
    - zstd
    - snappy
    - lzo
    - zstandard
  - name: Crypto
    status: 🟡
    description: n/a
    packages:
    - cryptokit
    - mirage-crypto
    - nocrypto
    - pkcs11
    - tls
    - hacl_x25519
    - x509
    - fiat-p256
    - sha
    - blake2
    - blake3
    - bls12-381
    - pbkdf
    - dirsp-proscript
  - name: Database
    status: 🟠
    description: n/a
    packages:
    - caqti
    - pgocaml
    - sqlite3
    - lmdb
    - irmin
    - mysql
    - postgresql
    - aws-rds
    - sequoia
    - sqlgg
    - petrol
    - mariadb
  - name: Email
    status: 🟠
    description: n/a
    packages:
    - tidy_email
    - emile
    - smtp
    - letters
    - mrmime
    - sendmail
    - facteur
    - received
    - email_message
  - name: En- & Decoding
    status: 🟠
    description: n/a
    packages:
    - ocaml-tar
    - imagelib
    - base64
    - multipart-form-data
    - multipart_form
    - biniou
  - name: Web Frameworks
    status: 🟠
    description: n/a
    packages:
    - dream
    - eliom
    - opium
    - sihl
  - name: HTTP Clients
    status: 🔴
    description: n/a
    packages:
    - cohttp
    - hyper
    - ocurl
  - name: Internationalization
    status: 🆘
    description: n/a
    packages:
    - gettext
  - name: Logging
    status: 🟠
    description: n/a
    packages:
    - logs
    - dolog
    - tracing
    - catapult
    - opentelemetry
    - prometheus
  - name: Lower Web-Stack
    status: 🟡
    description: n/a
    packages:
    - httpaf
    - http
    - tls
    - websocket
    - websocketaf
    - gluten
    - awa-ssh
    - uri
    - dns
    - tcpip
    - charrua
    - mirage-nat
    - arp
    - ethernet
    - colombe
  - name: Serializers
    status: 🟡
    description: n/a
    packages:
    - atd
    - yojson
    - sexplib
    - yaml
    - csv
    - bencode
    - toml
    - xml-light
    - graphql
    - omd
    - cmarkit
    - css
    - csexp
  - name: External Services
    status: 🆘
    description: n/a
    packages:
    - amqp-client
    - redis
    - zmq
  - name: Syndication/RSS
    status: 🟡
    description: n/a
    packages:
    - syndic
    - river
    - rss
  - name: Templating
    status: 🟡
    description: n/a
    packages:
    - embedded_ocaml_templates
    - mustache
    - jingoo
  - name: External Web APIs
    status: 🆘
    description: n/a
    packages:
    - spotify-web-api
    - disml
    - openai
    - github
    - telegraml
    - slacko
  - name: WebAssembly
    status: 🔴
    description: n/a
    packages:
    - wasm
    - owi
---

OCaml, traditionally known for its strength in systems programming, formal verification, and as the language of choice for numerous academic endeavors, is steadily maturing in the web development landscape. It might not be the most popular choice for web development yet, but with its strong static typing, emphasis on immutability, and excellent performance, it is gradually making a case for itself as a viable alternative to mainstream web development languages.

As a matter of fact, OCaml is used to power production web systems, like [Ahrefs](http://localhost:8080/success-stories/peta-byte-scale-web-crawler) and [OCaml.org](https://github.com/ocaml/ocaml.org).

If you're considering using OCaml for your next web application, you should be aware that you'll likely have to write a lot of things yourself and won't get an equivalent of some frameworks you may be used to coming from other languages. In particular, OCaml doesn't have good solutions for authentication or a production-ready query-builder. You'll also probably have some challenges if you need to interact with external services or external APIs.

## Want to Help?

Here are some tasks that would help make OCaml a stronger candidate for web applications:
- Improve [ocaml-swagger](https://github.com/andrenth/ocaml-swagger) to be able to generate API for popular web APIs like Stripe.
- Implement a converter from [JSON Schema](https://json-schema.org/) to [ATD](https://github.com/ahrefs/atd). This would allow generating OCaml serializers for data formats that provide a JSON Schema (a lot of them do!).
- Create an Oauth2 client library.
- Create clients to the Azure services APIs.
