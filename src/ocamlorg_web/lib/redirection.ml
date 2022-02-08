module Url = Ocamlorg_frontend.Url

let from_v2 =
  [
    ("/releases/4.05.html", Url.release "4.05");
    ("/releases/4.13.0.html", Url.release "4.13.0");
    ("/releases/4.12.1.html", Url.release "4.12.1");
    ("/releases/4.12.0.html", Url.release "4.12.0");
    ("/releases/4.09.1.html", Url.release "4.09.1");
    ("/releases/4.10.2.html", Url.release "4.10.2");
    ("/releases/4.08.0.html", Url.release "4.08.0");
    ("/releases/4.09.0.html", Url.release "4.09.0");
    ("/releases/4.11.2.html", Url.release "4.11.2");
    ("/releases/4.08.1.html", Url.release "4.08.1");
    ("/releases/4.04.html", Url.release "4.04");
    ("/releases/4.01.0.fr.html", Url.release "4.01.0");
    ("/releases/", Url.releases);
    ("/releases/index.html", Url.releases);
    ("/releases/4.00.1.html", Url.release "4.00.1");
    ("/releases/3.12.1.html", Url.release "3.12.1");
    ("/releases/index.fr.html", Url.releases);
    ("/releases/4.01.0.html", Url.release "4.01.0");
    ("/releases/4.10.0.html", Url.release "4.10.0");
    ("/releases/4.03.html", Url.release "4.03");
    ("/releases/4.11.1.html", Url.release "4.11.1");
    ("/releases/4.07.1.html", Url.release "4.07.1");
    ("/releases/4.06.html", Url.release "4.06");
    ("/releases/4.06.1.html", Url.release "4.06.1");
    ("/releases/4.10.1.html", Url.release "4.10.1");
    ("/releases/4.02.html", Url.release "4.02");
    ("/releases/4.11.0.html", Url.release "4.11.0");
    ("/releases/caml-light/license.html", "/");
    ("/releases/caml-light/releases/0.75.html", "/");
    ("/releases/caml-light/releases/", "/");
    ("/releases/caml-light/releases/index.html", "/");
    ("/releases/caml-light/faq.html", "/");
    ("/releases/caml-light/", "/");
    ("/releases/caml-light/index.html", "/");
    ("/releases/4.07.0.html", Url.release "4.07.0");
    ("/learn/taste.html", "/");
    ("/learn/taste.fr.html", "/");
    ("/learn/success.html", Url.success_stories);
    ("/learn/history.fr.html", Url.about);
    ("/learn/history.html", Url.about);
    ("/learn/faq.html", Url.about);
    ("/learn/companies.html", Url.industrial_users);
    ("/learn/description.html", Url.about);
    ("/learn/", Url.learn);
    ("/learn/index.html", Url.learn);
    ("/learn/index.fr.html", Url.learn);
    ("/learn/teaching-ocaml.html", Url.academic_users);
    ("/learn/tutorials/", Url.learn);
    ("/learn/tutorials/index.ja.html", Url.learn);
    ("/learn/tutorials/index.ko.html", Url.learn);
    ("/learn/tutorials/index.it.html", Url.learn);
    ("/learn/tutorials/index.html", Url.learn);
    ("/learn/tutorials/index.zh.html", Url.learn);
    ("/learn/tutorials/index.fr.html", Url.learn);
    ("/learn/tutorials/index.de.html", Url.learn);
    ( "/learn/tutorials/up_and_running.html",
      Url.tutorial "up-and-running-with-ocaml" );
    ( "/learn/tutorials/a_first_hour_with_ocaml.html",
      Url.tutorial "a-first-hour-with-ocaml" );
    ( "/learn/tutorials/guidelines.html",
      Url.tutorial "ocaml-programming-guidelines" );
    ( "/learn/tutorials/compiling_ocaml_projects.ja.html",
      Url.tutorial "compiling-ocaml-projects" );
    ( "/learn/tutorials/compiling_ocaml_projects.html",
      Url.tutorial "compiling-ocaml-projects" );
    ( "/learn/tutorials/data_types_and_matching.it.html",
      Url.tutorial "data-types-and-matching" );
    ( "/learn/tutorials/data_types_and_matching.fr.html",
      Url.tutorial "data-types-and-matching" );
    ( "/learn/tutorials/data_types_and_matching.zh.html",
      Url.tutorial "data-types-and-matching" );
    ( "/learn/tutorials/data_types_and_matching.ja.html",
      Url.tutorial "data-types-and-matching" );
    ( "/learn/tutorials/data_types_and_matching.html",
      Url.tutorial "data-types-and-matching" );
    ( "/learn/tutorials/functional_programming.fr.html",
      Url.tutorial "functional-programming" );
    ( "/learn/tutorials/functional_programming.html",
      Url.tutorial "functional-programming" );
    ( "/learn/tutorials/functional_programming.zh.html",
      Url.tutorial "functional-programming" );
    ( "/learn/tutorials/functional_programming.it.html",
      Url.tutorial "functional-programming" );
    ( "/learn/tutorials/functional_programming.ja.html",
      Url.tutorial "functional-programming" );
    ( "/learn/tutorials/if_statements_loops_and_recursion.ko.html",
      Url.tutorial "if-statements-loops-and-recursions" );
    ( "/learn/tutorials/if_statements_loops_and_recursion.ja.html",
      Url.tutorial "if-statements-loops-and-recursions" );
    ( "/learn/tutorials/if_statements_loops_and_recursion.html",
      Url.tutorial "if-statements-loops-and-recursions" );
    ( "/learn/tutorials/if_statements_loops_and_recursion.fr.html",
      Url.tutorial "if-statements-loops-and-recursions" );
    ( "/learn/tutorials/if_statements_loops_and_recursion.zh.html",
      Url.tutorial "if-statements-loops-and-recursions" );
    ( "/learn/tutorials/if_statements_loops_and_recursion.it.html",
      Url.tutorial "if-statements-loops-and-recursions" );
    ("/learn/tutorials/modules.fr.html", Url.tutorial "modules");
    ("/learn/tutorials/modules.html", Url.tutorial "modules");
    ("/learn/tutorials/modules.zh.html", Url.tutorial "modules");
    ("/learn/tutorials/modules.ja.html", Url.tutorial "modules");
    ("/learn/tutorials/modules.ko.html", Url.tutorial "modules");
    ("/learn/tutorials/labels.zh.html", Url.tutorial "labels");
    ("/learn/tutorials/labels.ja.html", Url.tutorial "labels");
    ("/learn/tutorials/labels.html", Url.tutorial "labels");
    ("/learn/tutorials/pointers.zh.html", Url.tutorial "pointers-in-ocaml");
    ("/learn/tutorials/pointers.html", Url.tutorial "pointers-in-ocaml");
    ( "/learn/tutorials/null_pointers_asserts_and_warnings.ja.html",
      Url.tutorial "null-pointers-asserts-and-warnings" );
    ( "/learn/tutorials/null_pointers_asserts_and_warnings.zh.html",
      Url.tutorial "null-pointers-asserts-and-warnings" );
    ( "/learn/tutorials/null_pointers_asserts_and_warnings.fr.html",
      Url.tutorial "null-pointers-asserts-and-warnings" );
    ( "/learn/tutorials/null_pointers_asserts_and_warnings.it.html",
      Url.tutorial "null-pointers-asserts-and-warnings" );
    ( "/learn/tutorials/null_pointers_asserts_and_warnings.html",
      Url.tutorial "null-pointers-asserts-and-warnings" );
    ("/learn/tutorials/functors.html", Url.tutorial "functors");
    ("/learn/tutorials/objects.ja.html", Url.tutorial "objects");
    ("/learn/tutorials/objects.html", Url.tutorial "objects");
    ("/learn/tutorials/objects.zh.html", Url.tutorial "objects");
    ("/learn/tutorials/error_handling.html", Url.tutorial "error-handling");
    ( "/learn/tutorials/common_error_messages.html",
      Url.tutorial "common-error-messages" );
    ( "/learn/tutorials/common_error_messages.ja.html",
      Url.tutorial "common-error-messages" );
    ( "/learn/tutorials/common_error_messages.zh.html",
      Url.tutorial "common-error-messages" );
    ( "/learn/tutorials/common_error_messages.fr.html",
      Url.tutorial "common-error-messages" );
    ("/learn/tutorials/debug.html", Url.tutorial "debug");
    ("/learn/tutorials/map.html", Url.tutorial "map");
    ("/learn/tutorials/map.ja.html", Url.tutorial "map");
    ("/learn/tutorials/map.zh.html", Url.tutorial "map");
    ("/learn/tutorials/map.fr.html", Url.tutorial "map");
    ("/learn/tutorials/set.fr.html", Url.tutorial "sets");
    ("/learn/tutorials/set.ja.html", Url.tutorial "sets");
    ("/learn/tutorials/set.html", Url.tutorial "sets");
    ("/learn/tutorials/set.zh.html", Url.tutorial "sets");
    ("/learn/tutorials/hashtbl.ja.html", Url.tutorial "hashtables");
    ("/learn/tutorials/hashtbl.html", Url.tutorial "hashtables");
    ("/learn/tutorials/hashtbl.zh.html", Url.tutorial "hashtables");
    ("/learn/tutorials/streams.html", Url.tutorial "streams");
    ("/learn/tutorials/format.fr.html", Url.tutorial "format");
    ("/learn/tutorials/format.html", Url.tutorial "format");
    ( "/learn/tutorials/command-line_arguments.ja.html",
      Url.tutorial "command-line-arguments" );
    ( "/learn/tutorials/command-line_arguments.html",
      Url.tutorial "command-line-arguments" );
    ( "/learn/tutorials/command-line_arguments.zh.html",
      Url.tutorial "command-line-arguments" );
    ( "/learn/tutorials/file_manipulation.zh.html",
      Url.tutorial "file-manipulation" );
    ("/learn/tutorials/file_manipulation.html", Url.tutorial "file-manipulation");
    ( "/learn/tutorials/file_manipulation.ja.html",
      Url.tutorial "file-manipulation" );
    ( "/learn/tutorials/calling_c_libraries.html",
      Url.tutorial "calling-c-libraries" );
    ( "/learn/tutorials/calling_fortran_libraries.html",
      Url.tutorial "calling-fortran-libraries" );
    ( "/learn/tutorials/garbage_collection.zh.html",
      Url.tutorial "garbage-collection" );
    ( "/learn/tutorials/garbage_collection.ja.html",
      Url.tutorial "garbage-collection" );
    ( "/learn/tutorials/garbage_collection.html",
      Url.tutorial "garbage-collection" );
    ( "/learn/tutorials/performance_and_profiling_discussion.html",
      Url.tutorial "performance-and-profiling" );
    ( "/learn/tutorials/performance_and_profiling.ja.html",
      Url.tutorial "performance-and-profiling" );
    ( "/learn/tutorials/comparison_of_standard_containers.html",
      Url.tutorial "performance-and-profiling" );
    ( "/learn/tutorials/comparison_of_standard_containers.zh.html",
      Url.tutorial "performance-and-profiling" );
    ( "/learn/tutorials/performance_and_profiling.html",
      Url.tutorial "performance-and-profiling" );
    ( "/learn/tutorials/comparison_of_standard_containers.ko.html",
      Url.tutorial "comparison-of-standard-containers" );
    ( "/learn/tutorials/comparison_of_standard_containers.ja.html",
      Url.tutorial "comparison-of-standard-containers" );
    ("/learn/tutorials/camlp5.html", Url.learn);
    ("/learn/tutorials/lists.html", Url.tutorial "lists");
    ("/learn/tutorials/humor_proof.html", Url.learn);
    ("/learn/tutorials/introduction_to_gtk.html", Url.learn);
    ("/learn/tutorials/99problems.html", Url.problems);
    ("/learn/libraries.html", Url.books);
    ("/learn/books.html", Url.books);
    ("/learn/portability.html", "/");
    ("/learn/success.fr.html", Url.success_stories);
    ("/consortium/", "/");
    ("/consortium/index.html", "/");
    ("/consortium/index.fr.html", "/");
    ("/contributors.fr.html", "/");
    ("/platform/", "/learn/platform");
    ("/platform/index.html", "/learn/platform");
    ("/platform/ocaml_on_windows.html", "/learn/ocaml-on-windows");
    ("/governance.html", "/governance");
    ("/docs/license.fr.html", "/");
    ("/docs/license.html", "/");
    ("/docs/logos.html", "/");
    ("/docs/install.html", "/");
    ("/docs/consortium-license.html", "/");
    ("/docs/consortium-license.fr.html", "/");
    ("/docs/", "/");
    ("/docs/index.html", "/");
    ("/docs/index.fr.html", "/");
    ("/docs/install.fr.html", "/");
    ("/docs/cheat_sheets.html", "/");
    ("/docs/papers.html", Url.papers);
    ("/index.html", Url.index);
    ("/index.fr.html", Url.index);
    ("/contributors.html", Url.index);
    ("/ocamllabs/index.html", "/");
    ("/about.fr.html", Url.about);
    ( "/meetings/ocaml/2013/program.html",
      Url.workshop "ocaml-users-and-developers-workshop-2013" );
    ( "/meetings/ocaml/2013/talks/index.html",
      Url.workshop "ocaml-users-and-developers-workshop-2013" );
    ( "/meetings/ocaml/2013/call.html",
      Url.workshop "ocaml-users-and-developers-workshop-2013" );
    ( "/meetings/ocaml/2013/index.html",
      Url.workshop "ocaml-users-and-developers-workshop-2013" );
    ( "/meetings/ocaml/2014/program.html",
      Url.workshop "ocaml-users-and-developers-workshop-2014" );
    ( "/meetings/ocaml/2014/ocaml2014_10.html",
      Url.workshop "ocaml-users-and-developers-workshop-2014" );
    ( "/meetings/ocaml/2014/index.html",
      Url.workshop "ocaml-users-and-developers-workshop-2014" );
    ( "/meetings/ocaml/2014/cfp.html",
      Url.workshop "ocaml-users-and-developers-workshop-2014" );
    ( "/meetings/ocaml/2015/program.html",
      Url.workshop "ocaml-users-and-developers-workshop-2015" );
    ( "/meetings/ocaml/2015/index.html",
      Url.workshop "ocaml-users-and-developers-workshop-2015" );
    ( "/meetings/ocaml/2015/cfp.html",
      Url.workshop "ocaml-users-and-developers-workshop-2015" );
    ( "/meetings/ocaml/2012/index.html",
      Url.workshop "ocaml-users-and-developers-workshop-2012" );
    ( "/meetings/ocaml/2008/index.html",
      Url.workshop "ocaml-users-and-developers-workshop-2008" );
    ( "/meetings/ocaml/2009/index.html",
      Url.workshop "ocaml-users-and-developers-workshop-2009" );
    ( "/meetings/ocaml/2017/index.html",
      Url.workshop "ocaml-users-and-developers-workshop-2017" );
    ( "/meetings/ocaml/2010/index.html",
      Url.workshop "ocaml-users-and-developers-workshop-2010" );
    ( "/meetings/ocaml/2019/index.html",
      Url.workshop "ocaml-users-and-developers-workshop-2019" );
    ( "/meetings/ocaml/2020/index.html",
      Url.workshop "ocaml-users-and-developers-workshop-2020" );
    ( "/meetings/ocaml/2018/index.html",
      Url.workshop "ocaml-users-and-developers-workshop-2018" );
    ( "/meetings/ocaml/2011/index.html",
      Url.workshop "ocaml-users-and-developers-workshop-2011" );
    ( "/meetings/ocaml/2016/index.html",
      Url.workshop "ocaml-users-and-developers-workshop-2016" );
    ("/meetings/index.html", Url.community);
    ("/meetings/index.fr.html", Url.community);
    ("/community/planet/index.html", Url.community);
    ("/community/planet/older.html", Url.community);
    ("/community/planet/syndication.html", Url.community);
    ("/community/mailing_lists.fr.html", Url.community);
    ("/community/planet.html", Url.community);
    ("/community/support.fr.html", Url.community);
    ("/community/cwn/index.html", Url.community);
    ("/community/announcements/CompCert_award.html", Url.community);
    ("/community/support.html", Url.community);
    ("/community/index.html", Url.community);
    ("/community/index.fr.html", Url.community);
    ("/community/history/forge.html", Url.community);
    ("/community/media.html", Url.community);
    ("/community/mailing_lists.html", Url.community);
    ("/about.html", Url.about);
    ("/caml-light/license.html", "/");
    ("/caml-light/releases/0.75.html", "/");
    ("/caml-light/releases/index.html", "/");
    ("/caml-light/faq.html", "/");
    ("/caml-light/index.html", "/");
  ]

(* TODO: Change to v2ocaml.org when deploy on ocaml.org *)
let manual =
  [
    (Url.manual, "https://ocaml.org/manual/");
    ( Url.manual_with_version "3.12.1",
      "https://ocaml.org/releases/3.12/manual/index.html" );
    ( Url.manual_with_version "4.00.1",
      "https://ocaml.org/releases/4.00/manual/index.html" );
    ( Url.manual_with_version "4.01.0",
      "https://ocaml.org/releases/4.01/manual/index.html" );
    ( Url.manual_with_version "4.02.3",
      "https://ocaml.org/releases/4.02/manual/index.html" );
    ( Url.manual_with_version "4.03.0",
      "https://ocaml.org/releases/4.03/manual/index.html" );
    ( Url.manual_with_version "4.04.0",
      "https://ocaml.org/releases/4.04/manual/index.html" );
    ( Url.manual_with_version "4.05.0",
      "https://ocaml.org/releases/4.05/manual/index.html" );
    ( Url.manual_with_version "4.06.0",
      "https://ocaml.org/releases/4.06/manual/index.html" );
    ( Url.manual_with_version "4.06.1",
      "https://ocaml.org/releases/4.06/manual/index.html" );
    ( Url.manual_with_version "4.07.0",
      "https://ocaml.org/releases/4.07/manual/index.html" );
    ( Url.manual_with_version "4.07.1",
      "https://ocaml.org/releases/4.07/manual/index.html" );
    ( Url.manual_with_version "4.08.0",
      "https://ocaml.org/releases/4.08/manual/index.html" );
    ( Url.manual_with_version "4.08.1",
      "https://ocaml.org/releases/4.08/manual/index.html" );
    ( Url.manual_with_version "4.09.0",
      "https://ocaml.org/releases/4.09/manual/index.html" );
    ( Url.manual_with_version "4.09.1",
      "https://ocaml.org/releases/4.09/manual/index.html" );
    ( Url.manual_with_version "4.10.0",
      "https://ocaml.org/releases/4.10/manual/index.html" );
    ( Url.manual_with_version "4.10.1",
      "https://ocaml.org/releases/4.10/manual/index.html" );
    ( Url.manual_with_version "4.10.2",
      "https://ocaml.org/releases/4.10/manual/index.html" );
    ( Url.manual_with_version "4.11.0",
      "https://ocaml.org/releases/4.11/manual/index.html" );
    ( Url.manual_with_version "4.11.1",
      "https://ocaml.org/releases/4.11/manual/index.html" );
    ( Url.manual_with_version "4.11.2",
      "https://ocaml.org/releases/4.11/manual/index.html" );
    ( Url.manual_with_version "4.12.0",
      "https://ocaml.org/releases/4.12/manual/index.html" );
    ( Url.manual_with_version "4.12.1",
      "https://ocaml.org/releases/4.12/manual/index.html" );
    ( Url.manual_with_version "4.13.0",
      "https://ocaml.org/releases/4.13/manual/index.html" );
    ( Url.manual_with_version "4.13.1",
      "https://ocaml.org/releases/4.13/manual/index.html" );
  ]
