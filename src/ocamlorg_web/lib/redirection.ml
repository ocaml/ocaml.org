let t =
  [ "/releases/4.05.html", "/???"
  ; "/releases/4.12.0.html", "/???"
  ; "/releases/4.09.1.html", "/???"
  ; "/releases/4.10.2.html", "/???"
  ; "/releases/4.08.0.html", "/???"
  ; "/releases/4.09.0.html", "/???"
  ; "/releases/4.11.2.html", "/???"
  ; "/releases/4.08.1.html", "/???"
  ; "/releases/4.04.html", "/???"
  ; "/releases/4.01.0.fr.html", "/???"
  ; "/releases/", "/???"
  ; "/releases/index.html", "/???"
  ; "/releases/4.00.1.html", "/???"
  ; "/releases/3.12.1.html", "/???"
  ; "/releases/index.fr.html", "/???"
  ; "/releases/4.01.0.html", "/???"
  ; "/releases/4.10.0.html", "/???"
  ; "/releases/4.03.html", "/???"
  ; "/releases/4.11.1.html", "/???"
  ; "/releases/4.07.1.html", "/???"
  ; "/releases/4.06.html", "/???"
  ; "/releases/4.06.1.html", "/???"
  ; "/releases/4.10.1.html", "/???"
  ; "/releases/4.02.html", "/???"
  ; "/releases/4.11.0.html", "/???"
  ; "/releases/caml-light/license.html", "/???"
  ; "/releases/caml-light/releases/0.75.html", "/???"
  ; "/releases/caml-light/releases/", "/???"
  ; "/releases/caml-light/releases/index.html", "/???"
  ; "/releases/caml-light/faq.html", "/???"
  ; "/releases/caml-light/", "/???"
  ; "/releases/caml-light/index.html", "/???"
  ; "/releases/4.07.0.html", "/???"
  ; "/learn/taste.html", "/???"
  ; "/learn/taste.fr.html", "/???"
  ; "/learn/success.html", Url.principles_successes
  ; "/learn/history.fr.html", Url.history
  ; "/learn/history.html", Url.history
  ; "/learn/faq.html", "/???"
  ; "/learn/companies.html", Url.principles_industrial_users
  ; "/learn/description.html", "/???"
  ; "/learn/", Url.resources_language
  ; "/learn/index.html", Url.resources_language
  ; "/learn/index.fr.html", Url.resources_language
  ; "/learn/teaching-ocaml.html", Url.principles_academic
  ; "/learn/tutorials/", Url.resources_tutorial Url.resources_tutorials
  ; ( "/learn/tutorials/index.ja.html"
    , Url.resources_tutorial Url.resources_tutorials )
  ; ( "/learn/tutorials/index.ko.html"
    , Url.resources_tutorial Url.resources_tutorials )
  ; ( "/learn/tutorials/index.it.html"
    , Url.resources_tutorial Url.resources_tutorials )
  ; ( "/learn/tutorials/index.html"
    , Url.resources_tutorial Url.resources_tutorials )
  ; ( "/learn/tutorials/index.zh.html"
    , Url.resources_tutorial Url.resources_tutorials )
  ; ( "/learn/tutorials/index.fr.html"
    , Url.resources_tutorial Url.resources_tutorials )
  ; ( "/learn/tutorials/index.de.html"
    , Url.resources_tutorial Url.resources_tutorials )
  ; ( "/learn/tutorials/up_and_running.html"
    , Url.resources_tutorial "up-and-running-with-ocaml" )
  ; ( "/learn/tutorials/a_first_hour_with_ocaml.html"
    , Url.resources_tutorial "a-first-hour-with-ocaml" )
  ; ( "/learn/tutorials/guidelines.html"
    , Url.resources_tutorial "ocaml-programming-guidelines" )
  ; ( "/learn/tutorials/compiling_ocaml_projects.ja.html"
    , Url.resources_tutorial "compiling-ocaml-projects" )
  ; ( "/learn/tutorials/compiling_ocaml_projects.html"
    , Url.resources_tutorial "compiling-ocaml-projects" )
  ; ( "/learn/tutorials/data_types_and_matching.it.html"
    , Url.resources_tutorial "data-types-and-matching" )
  ; ( "/learn/tutorials/data_types_and_matching.fr.html"
    , Url.resources_tutorial "data-types-and-matching" )
  ; ( "/learn/tutorials/data_types_and_matching.zh.html"
    , Url.resources_tutorial "data-types-and-matching" )
  ; ( "/learn/tutorials/data_types_and_matching.ja.html"
    , Url.resources_tutorial "data-types-and-matching" )
  ; ( "/learn/tutorials/data_types_and_matching.html"
    , Url.resources_tutorial "data-types-and-matching" )
  ; ( "/learn/tutorials/functional_programming.fr.html"
    , Url.resources_tutorial "functional-programming" )
  ; ( "/learn/tutorials/functional_programming.html"
    , Url.resources_tutorial "functional-programming" )
  ; ( "/learn/tutorials/functional_programming.zh.html"
    , Url.resources_tutorial "functional-programming" )
  ; ( "/learn/tutorials/functional_programming.it.html"
    , Url.resources_tutorial "functional-programming" )
  ; ( "/learn/tutorials/functional_programming.ja.html"
    , Url.resources_tutorial "functional-programming" )
  ; ( "/learn/tutorials/if_statements_loops_and_recursion.ko.html"
    , Url.resources_tutorial "if-statements-loops-and-recursions" )
  ; ( "/learn/tutorials/if_statements_loops_and_recursion.ja.html"
    , Url.resources_tutorial "if-statements-loops-and-recursions" )
  ; ( "/learn/tutorials/if_statements_loops_and_recursion.html"
    , Url.resources_tutorial "if-statements-loops-and-recursions" )
  ; ( "/learn/tutorials/if_statements_loops_and_recursion.fr.html"
    , Url.resources_tutorial "if-statements-loops-and-recursions" )
  ; ( "/learn/tutorials/if_statements_loops_and_recursion.zh.html"
    , Url.resources_tutorial "if-statements-loops-and-recursions" )
  ; ( "/learn/tutorials/if_statements_loops_and_recursion.it.html"
    , Url.resources_tutorial "if-statements-loops-and-recursions" )
  ; "/learn/tutorials/modules.fr.html", Url.resources_tutorial "modules"
  ; "/learn/tutorials/modules.html", Url.resources_tutorial "modules"
  ; "/learn/tutorials/modules.zh.html", Url.resources_tutorial "modules"
  ; "/learn/tutorials/modules.ja.html", Url.resources_tutorial "modules"
  ; "/learn/tutorials/modules.ko.html", Url.resources_tutorial "modules"
  ; "/learn/tutorials/labels.zh.html", Url.resources_tutorial "labels"
  ; "/learn/tutorials/labels.ja.html", Url.resources_tutorial "labels"
  ; "/learn/tutorials/labels.html", Url.resources_tutorial "labels"
  ; ( "/learn/tutorials/pointers.zh.html"
    , Url.resources_tutorial "pointers-in-ocaml" )
  ; "/learn/tutorials/pointers.html", Url.resources_tutorial "pointers-in-ocaml"
  ; ( "/learn/tutorials/null_pointers_asserts_and_warnings.ja.html"
    , Url.resources_tutorial "null-pointers-asserts-and-warnings" )
  ; ( "/learn/tutorials/null_pointers_asserts_and_warnings.zh.html"
    , Url.resources_tutorial "null-pointers-asserts-and-warnings" )
  ; ( "/learn/tutorials/null_pointers_asserts_and_warnings.fr.html"
    , Url.resources_tutorial "null-pointers-asserts-and-warnings" )
  ; ( "/learn/tutorials/null_pointers_asserts_and_warnings.it.html"
    , Url.resources_tutorial "null-pointers-asserts-and-warnings" )
  ; ( "/learn/tutorials/null_pointers_asserts_and_warnings.html"
    , Url.resources_tutorial "null-pointers-asserts-and-warnings" )
  ; "/learn/tutorials/functors.html", Url.resources_tutorial "functors"
  ; "/learn/tutorials/objects.ja.html", Url.resources_tutorial "objects"
  ; "/learn/tutorials/objects.html", Url.resources_tutorial "objects"
  ; "/learn/tutorials/objects.zh.html", Url.resources_tutorial "objects"
  ; ( "/learn/tutorials/error_handling.html"
    , Url.resources_tutorial "error-handling" )
  ; ( "/learn/tutorials/common_error_messages.html"
    , Url.resources_tutorial "common-error-messages" )
  ; ( "/learn/tutorials/common_error_messages.ja.html"
    , Url.resources_tutorial "common-error-messages" )
  ; ( "/learn/tutorials/common_error_messages.zh.html"
    , Url.resources_tutorial "common-error-messages" )
  ; ( "/learn/tutorials/common_error_messages.fr.html"
    , Url.resources_tutorial "common-error-messages" )
  ; "/learn/tutorials/debug.html", Url.resources_tutorial "debug"
  ; "/learn/tutorials/map.html", Url.resources_tutorial "map"
  ; "/learn/tutorials/map.ja.html", Url.resources_tutorial "map"
  ; "/learn/tutorials/map.zh.html", Url.resources_tutorial "map"
  ; "/learn/tutorials/map.fr.html", Url.resources_tutorial "map"
  ; "/learn/tutorials/set.fr.html", Url.resources_tutorial "sets"
  ; "/learn/tutorials/set.ja.html", Url.resources_tutorial "sets"
  ; "/learn/tutorials/set.html", Url.resources_tutorial "sets"
  ; "/learn/tutorials/set.zh.html", Url.resources_tutorial "sets"
  ; "/learn/tutorials/hashtbl.ja.html", Url.resources_tutorial "hashtables"
  ; "/learn/tutorials/hashtbl.html", Url.resources_tutorial "hashtables"
  ; "/learn/tutorials/hashtbl.zh.html", Url.resources_tutorial "hashtables"
  ; "/learn/tutorials/streams.html", Url.resources_tutorial "streams"
  ; "/learn/tutorials/format.fr.html", Url.resources_tutorial "format"
  ; "/learn/tutorials/format.html", Url.resources_tutorial "format"
  ; ( "/learn/tutorials/command-line_arguments.ja.html"
    , Url.resources_tutorial "command-line-arguments" )
  ; ( "/learn/tutorials/command-line_arguments.html"
    , Url.resources_tutorial "command-line-arguments" )
  ; ( "/learn/tutorials/command-line_arguments.zh.html"
    , Url.resources_tutorial "command-line-arguments" )
  ; ( "/learn/tutorials/file_manipulation.zh.html"
    , Url.resources_tutorial "file-manipulation" )
  ; ( "/learn/tutorials/file_manipulation.html"
    , Url.resources_tutorial "file-manipulation" )
  ; ( "/learn/tutorials/file_manipulation.ja.html"
    , Url.resources_tutorial "file-manipulation" )
  ; ( "/learn/tutorials/calling_c_libraries.html"
    , Url.resources_tutorial "calling-c-libraries" )
  ; ( "/learn/tutorials/calling_fortran_libraries.html"
    , Url.resources_tutorial "calling-fortran-libraries" )
  ; ( "/learn/tutorials/garbage_collection.zh.html"
    , Url.resources_tutorial "garbage-collection" )
  ; ( "/learn/tutorials/garbage_collection.ja.html"
    , Url.resources_tutorial "garbage-collection" )
  ; ( "/learn/tutorials/garbage_collection.html"
    , Url.resources_tutorial "garbage-collection" )
  ; ( "/learn/tutorials/performance_and_profiling_discussion.html"
    , Url.resources_tutorial "performance-and-profiling" )
  ; ( "/learn/tutorials/performance_and_profiling.ja.html"
    , Url.resources_tutorial "performance-and-profiling" )
  ; ( "/learn/tutorials/comparison_of_standard_containers.html"
    , Url.resources_tutorial "performance-and-profiling" )
  ; ( "/learn/tutorials/comparison_of_standard_containers.zh.html"
    , Url.resources_tutorial "performance-and-profiling" )
  ; ( "/learn/tutorials/performance_and_profiling.html"
    , Url.resources_tutorial "performance-and-profiling" )
  ; ( "/learn/tutorials/comparison_of_standard_containers.ko.html"
    , Url.resources_tutorial "comparison-of-standard-containers" )
  ; ( "/learn/tutorials/comparison_of_standard_containers.ja.html"
    , Url.resources_tutorial "comparison-of-standard-containers" )
  ; "/learn/tutorials/camlp5.html", Url.resources_tutorial "???"
  ; "/learn/tutorials/lists.html", Url.resources_tutorial "???"
  ; "/learn/tutorials/humor_proof.html", Url.resources_tutorial "???"
  ; "/learn/tutorials/introduction_to_gtk.html", Url.resources_tutorial "???"
  ; "/learn/tutorials/99problems.html", Url.resources_tutorial "???"
  ; "/learn/libraries.html", "/???"
  ; "/learn/books.html", "/???"
  ; "/learn/portability.html", "/???"
  ; "/learn/success.fr.html", "/???"
  ; "/consortium/", "/???"
  ; "/consortium/index.html", "/???"
  ; "/consortium/index.fr.html", "/???"
  ; "/contributors.fr.html", "/???"
  ; "/platform/", "/???"
  ; "/platform/index.html", "/???"
  ; "/platform/ocaml_on_windows.html", "/???"
  ; "/governance.html", "/???"
  ; "/docs/license.fr.html", "/???"
  ; "/docs/license.html", "/???"
  ; "/docs/logos.html", "/???"
  ; "/docs/install.html", "/???"
  ; "/docs/consortium-license.html", "/???"
  ; "/docs/consortium-license.fr.html", "/???"
  ; "/docs/", "/???"
  ; "/docs/index.html", "/???"
  ; "/docs/index.fr.html", "/???"
  ; "/docs/install.fr.html", "/???"
  ; "/docs/cheat_sheets.html", "/???"
  ; "/docs/papers.html", Url.resources_papers_archive
  ; "/index.html", Url.index
  ; "/index.fr.html", Url.index
  ; "/contributors.html", Url.index
  ; "/ocamllabs/index.html", "/???"
  ; "/about.fr.html", "/???"
  ; "/meetings/ocaml/2013/program.html", "/???"
  ; "/meetings/ocaml/2013/talks/index.html", "/???"
  ; "/meetings/ocaml/2013/call.html", "/???"
  ; "/meetings/ocaml/2013/index.html", "/???"
  ; "/meetings/ocaml/2014/program.html", "/???"
  ; "/meetings/ocaml/2014/ocaml2014_10.html", "/???"
  ; "/meetings/ocaml/2014/index.html", "/???"
  ; "/meetings/ocaml/2014/cfp.html", "/???"
  ; "/meetings/ocaml/2015/program.html", "/???"
  ; "/meetings/ocaml/2015/index.html", "/???"
  ; "/meetings/ocaml/2015/cfp.html", "/???"
  ; "/meetings/ocaml/2012/index.html", "/???"
  ; "/meetings/ocaml/2008/index.html", "/???"
  ; "/meetings/ocaml/2009/index.html", "/???"
  ; "/meetings/ocaml/2017/index.html", "/???"
  ; "/meetings/ocaml/2010/index.html", "/???"
  ; "/meetings/ocaml/2019/index.html", "/???"
  ; "/meetings/ocaml/2020/index.html", "/???"
  ; "/meetings/ocaml/2018/index.html", "/???"
  ; "/meetings/ocaml/2011/index.html", "/???"
  ; "/meetings/ocaml/2016/index.html", "/???"
  ; "/meetings/index.html", "/???"
  ; "/meetings/index.fr.html", "/???"
  ; "/community/planet/index.html", "/???"
  ; "/community/planet/older.html", "/???"
  ; "/community/planet/syndication.html", "/???"
  ; "/community/mailing_lists.fr.html", "/???"
  ; "/community/planet.html", "/???"
  ; "/community/support.fr.html", "/???"
  ; "/community/cwn/index.html", "/???"
  ; "/community/announcements/CompCert_award.html", "/???"
  ; "/community/support.html", "/???"
  ; "/community/index.html", "/???"
  ; "/community/index.fr.html", "/???"
  ; "/community/history/forge.html", "/???"
  ; "/community/media.html", "/???"
  ; "/community/mailing_lists.html", "/???"
  ; "/about.html", "/???"
  ; "/caml-light/license.html", "/???"
  ; "/caml-light/releases/0.75.html", "/???"
  ; "/caml-light/releases/index.html", "/???"
  ; "/caml-light/faq.html", "/???"
  ; "/caml-light/index.html", "/???"
  ]
