(** Configurations used in the ocaml.org backend. *)

val opam_polling : int
val documentation_url : string
val documentation_status_url : string
val package_caches_ttl : float
val doc_cache_max : int

val doc_negative_ttl : float
(** Short TTL (seconds) for negatively cached docs-ci outcomes (missing/empty
    sidebars and missing/unparseable doc pages), long enough to absorb a retry
    storm but short enough not to mask a documentation rebuild. Overridable via
    [OCAMLORG_DOC_NEGATIVE_TTL]. See ocaml/ocaml.org#3888. *)

val latest_documented_version_depth : int
(** Upper bound on how many versions [latest_documented_version] probes (newest
    first) before giving up, bounding the per-call fan-out of status.json
    fetches on a cold cache. Overridable via
    [OCAMLORG_LATEST_DOC_VERSION_DEPTH]. See ocaml/ocaml.org#3888. *)

val doc_cache_max_bytes : int
(** Byte budget for each bounded docs-ci cache. Entry size is
    attacker-selectable, so the entry-count cap [doc_cache_max] alone bounds
    memory weakly; each cache also evicts FIFO until under this byte budget.
    Overridable via [OCAMLORG_DOC_CACHE_MAX_BYTES]. *)

val max_doc_fetch_bytes : int
(** Upper bound (bytes) on a single response fetched from the documentation
    backend, to avoid buffering a pathologically large artifact into memory.
    Overridable via [OCAMLORG_MAX_DOC_FETCH_BYTES]. *)

val doc_fetch_timeout : float
(** Wall-clock budget (seconds) for a single fetch from the documentation
    backend, so a stalled backend can't hang a request indefinitely. Overridable
    via [OCAMLORG_DOC_FETCH_TIMEOUT]. *)

val package_builder : string
(** The package-state builder the server runs at every poll:
    [OCAMLORG_PACKAGE_BUILDER], by default [ocamlorg-package-builder], looked up
    on [PATH]. *)

val package_builder_nice : int
(** Niceness the builder runs at: [OCAMLORG_PACKAGE_BUILDER_NICE], by default
    19. *)

val package_builder_timeout : float
(** Seconds after which a running builder is killed:
    [OCAMLORG_PACKAGE_BUILDER_TIMEOUT], by default 1800. *)

val package_builder_oom_score_adj : int
(** [oom_score_adj] the builder raises itself to once the clone is pulled:
    [OCAMLORG_PACKAGE_BUILDER_OOM_SCORE_ADJ], by default 1000, so that the
    kernel kills it before the server if memory runs out. A value outside -1000
    to 1000 stops the server at startup. *)
