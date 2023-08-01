open Ocamlorg

let fwd_v2 target = (target, Url.v2 ^ target)

(* For assets previously hosted on V2, we redirect the requests to
   v2.ocaml.org. *)
let v2_assets =
  [
    fwd_v2 "/meetings/ocaml/2013/proposals/core-bench.pdf";
    fwd_v2 "/meetings/ocaml/2013/proposals/ctypes.pdf";
    fwd_v2 "/meetings/ocaml/2013/proposals/formats-as-gadts.pdf";
    fwd_v2 "/meetings/ocaml/2013/proposals/frenetic.pdf";
    fwd_v2 "/meetings/ocaml/2013/proposals/goji.pdf";
    fwd_v2 "/meetings/ocaml/2013/proposals/gpgpu.pdf";
    fwd_v2 "/meetings/ocaml/2013/proposals/injectivity.pdf";
    fwd_v2 "/meetings/ocaml/2013/proposals/merlin.pdf";
    fwd_v2 "/meetings/ocaml/2013/proposals/ocamlot.pdf";
    fwd_v2 "/meetings/ocaml/2013/proposals/optimizations.pdf";
    fwd_v2 "/meetings/ocaml/2013/proposals/platform.pdf";
    fwd_v2 "/meetings/ocaml/2013/proposals/profiling-memory.pdf";
    fwd_v2 "/meetings/ocaml/2013/proposals/runtime-types.pdf";
    fwd_v2 "/meetings/ocaml/2013/proposals/weather-related-data.pdf";
    fwd_v2 "/meetings/ocaml/2013/proposals/wxocaml.pdf";
    fwd_v2 "/meetings/ocaml/2013/slides/bourgoin.pdf";
    fwd_v2 "/meetings/ocaml/2013/slides/bozman.pdf";
    fwd_v2 "/meetings/ocaml/2013/slides/canou.pdf";
    fwd_v2 "/meetings/ocaml/2013/slides/carty.pdf";
    fwd_v2 "/meetings/ocaml/2013/slides/chambart.pdf";
    fwd_v2 "/meetings/ocaml/2013/slides/garrigue.pdf";
    fwd_v2 "/meetings/ocaml/2013/slides/guha.pdf";
    fwd_v2 "/meetings/ocaml/2013/slides/henry.pdf";
    fwd_v2 "/meetings/ocaml/2013/slides/james.pdf";
    fwd_v2 "/meetings/ocaml/2013/slides/lefessant.pdf";
    fwd_v2 "/meetings/ocaml/2013/slides/leroy.pdf";
    fwd_v2 "/meetings/ocaml/2013/slides/madhavapeddy.pdf";
    fwd_v2 "/meetings/ocaml/2013/slides/padioleau.pdf";
    fwd_v2 "/meetings/ocaml/2013/slides/sheets.pdf";
    fwd_v2 "/meetings/ocaml/2013/slides/vaugon.pdf";
    fwd_v2 "/meetings/ocaml/2013/slides/white.pdf";
    fwd_v2 "/releases/3.12/notes/Changes";
    fwd_v2 "/releases/3.12/notes/INSTALL";
    fwd_v2 "/releases/3.12/notes/LICENSE";
    fwd_v2 "/releases/3.12/notes/README";
    fwd_v2 "/releases/3.12/notes/README.win32";
    fwd_v2 "/releases/3.12/ocaml-3.12-refman-html.tar.gz";
    fwd_v2 "/releases/3.12/ocaml-3.12-refman-html.zip";
    fwd_v2 "/releases/3.12/ocaml-3.12-refman.dvi.gz";
    fwd_v2 "/releases/3.12/ocaml-3.12-refman.html";
    fwd_v2 "/releases/3.12/ocaml-3.12-refman.html.tar.gz";
    fwd_v2 "/releases/3.12/ocaml-3.12-refman.html.zip";
    fwd_v2 "/releases/3.12/ocaml-3.12-refman.info.tar.gz";
    fwd_v2 "/releases/3.12/ocaml-3.12-refman.pdf";
    fwd_v2 "/releases/3.12/ocaml-3.12-refman.ps.gz";
    fwd_v2 "/releases/3.12/ocaml-3.12-refman.txt";
    fwd_v2 "/releases/4.00/notes/Changes";
    fwd_v2 "/releases/4.00/notes/INSTALL";
    fwd_v2 "/releases/4.00/notes/LICENSE";
    fwd_v2 "/releases/4.00/notes/README";
    fwd_v2 "/releases/4.00/notes/README.win32";
    fwd_v2 "/releases/4.00/ocaml-4.00-refman-html.tar.gz";
    fwd_v2 "/releases/4.00/ocaml-4.00-refman-html.zip";
    fwd_v2 "/releases/4.00/ocaml-4.00-refman.dvi.gz";
    fwd_v2 "/releases/4.00/ocaml-4.00-refman.html";
    fwd_v2 "/releases/4.00/ocaml-4.00-refman.info.tar.gz";
    fwd_v2 "/releases/4.00/ocaml-4.00-refman.pdf";
    fwd_v2 "/releases/4.00/ocaml-4.00-refman.ps.gz";
    fwd_v2 "/releases/4.00/ocaml-4.00-refman.txt";
    fwd_v2 "/releases/4.01/notes/Changes";
    fwd_v2 "/releases/4.01/notes/INSTALL";
    fwd_v2 "/releases/4.01/notes/LICENSE";
    fwd_v2 "/releases/4.01/notes/README";
    fwd_v2 "/releases/4.01/notes/README.win32";
    fwd_v2 "/releases/4.01/ocaml-4.01-refman-html.tar.gz";
    fwd_v2 "/releases/4.01/ocaml-4.01-refman-html.zip";
    fwd_v2 "/releases/4.01/ocaml-4.01-refman.dvi.gz";
    fwd_v2 "/releases/4.01/ocaml-4.01-refman.html";
    fwd_v2 "/releases/4.01/ocaml-4.01-refman.info.tar.gz";
    fwd_v2 "/releases/4.01/ocaml-4.01-refman.pdf";
    fwd_v2 "/releases/4.01/ocaml-4.01-refman.ps.gz";
    fwd_v2 "/releases/4.01/ocaml-4.01-refman.txt";
    fwd_v2 "/releases/4.02/notes/Changes";
    fwd_v2 "/releases/4.02/notes/INSTALL";
    fwd_v2 "/releases/4.02/notes/LICENSE";
    fwd_v2 "/releases/4.02/notes/README";
    fwd_v2 "/releases/4.02/notes/README.win32";
    fwd_v2 "/releases/4.02/ocaml-4.02-refman-html-0.tar.gz";
    fwd_v2 "/releases/4.02/ocaml-4.02-refman-html-0.zip";
    fwd_v2 "/releases/4.02/ocaml-4.02-refman-html-1.tar.gz";
    fwd_v2 "/releases/4.02/ocaml-4.02-refman-html-1.zip";
    fwd_v2 "/releases/4.02/ocaml-4.02-refman-html.tar.gz";
    fwd_v2 "/releases/4.02/ocaml-4.02-refman-html.zip";
    fwd_v2 "/releases/4.02/ocaml-4.02-refman.dvi.gz";
    fwd_v2 "/releases/4.02/ocaml-4.02-refman.html";
    fwd_v2 "/releases/4.02/ocaml-4.02-refman.info.tar.gz";
    fwd_v2 "/releases/4.02/ocaml-4.02-refman.pdf";
    fwd_v2 "/releases/4.02/ocaml-4.02-refman.ps.gz";
    fwd_v2 "/releases/4.02/ocaml-4.02-refman.txt";
    fwd_v2 "/releases/4.03/notes/Changes";
    fwd_v2 "/releases/4.03/notes/INSTALL.adoc";
    fwd_v2 "/releases/4.03/notes/LICENSE";
    fwd_v2 "/releases/4.03/notes/README.adoc";
    fwd_v2 "/releases/4.03/notes/README.win32.adoc";
    fwd_v2 "/releases/4.03/ocaml-4.03-refman-html.tar.gz";
    fwd_v2 "/releases/4.03/ocaml-4.03-refman-html.zip";
    fwd_v2 "/releases/4.03/ocaml-4.03-refman.dvi.gz";
    fwd_v2 "/releases/4.03/ocaml-4.03-refman.html";
    fwd_v2 "/releases/4.03/ocaml-4.03-refman.info.tar.gz";
    fwd_v2 "/releases/4.03/ocaml-4.03-refman.pdf";
    fwd_v2 "/releases/4.03/ocaml-4.03-refman.ps.gz";
    fwd_v2 "/releases/4.03/ocaml-4.03-refman.txt";
    fwd_v2 "/releases/4.04/notes/Changes";
    fwd_v2 "/releases/4.04/notes/INSTALL.adoc";
    fwd_v2 "/releases/4.04/notes/LICENSE";
    fwd_v2 "/releases/4.04/notes/README.adoc";
    fwd_v2 "/releases/4.04/notes/README.win32.adoc";
    fwd_v2 "/releases/4.04/ocaml-4.04-refman-html.tar.gz";
    fwd_v2 "/releases/4.04/ocaml-4.04-refman-html.zip";
    fwd_v2 "/releases/4.04/ocaml-4.04-refman.dvi.gz";
    fwd_v2 "/releases/4.04/ocaml-4.04-refman.html";
    fwd_v2 "/releases/4.04/ocaml-4.04-refman.info.tar.gz";
    fwd_v2 "/releases/4.04/ocaml-4.04-refman.pdf";
    fwd_v2 "/releases/4.04/ocaml-4.04-refman.ps.gz";
    fwd_v2 "/releases/4.04/ocaml-4.04-refman.txt";
    fwd_v2 "/releases/4.05/notes/Changes";
    fwd_v2 "/releases/4.05/notes/INSTALL.adoc";
    fwd_v2 "/releases/4.05/notes/LICENSE";
    fwd_v2 "/releases/4.05/notes/README.adoc";
    fwd_v2 "/releases/4.05/notes/README.win32.adoc";
    fwd_v2 "/releases/4.05/ocaml-4.05-refman-html.tar.gz";
    fwd_v2 "/releases/4.05/ocaml-4.05-refman-html.zip";
    fwd_v2 "/releases/4.05/ocaml-4.05-refman.dvi.gz";
    fwd_v2 "/releases/4.05/ocaml-4.05-refman.html";
    fwd_v2 "/releases/4.05/ocaml-4.05-refman.info.tar.gz";
    fwd_v2 "/releases/4.05/ocaml-4.05-refman.pdf";
    fwd_v2 "/releases/4.05/ocaml-4.05-refman.ps.gz";
    fwd_v2 "/releases/4.05/ocaml-4.05-refman.txt";
    fwd_v2 "/releases/4.06/notes/Changes";
    fwd_v2 "/releases/4.06/notes/Changes.4.06.0+beta1.txt";
    fwd_v2 "/releases/4.06/notes/Changes.4.06.0+beta2.txt";
    fwd_v2 "/releases/4.06/notes/Changes.4.06.0+rc1.txt";
    fwd_v2 "/releases/4.06/notes/INSTALL.adoc";
    fwd_v2 "/releases/4.06/notes/LICENSE";
    fwd_v2 "/releases/4.06/notes/README.adoc";
    fwd_v2 "/releases/4.06/notes/README.win32.adoc";
    fwd_v2 "/releases/4.06/ocaml-4.06-refman-html.tar.gz";
    fwd_v2 "/releases/4.06/ocaml-4.06-refman-html.zip";
    fwd_v2 "/releases/4.06/ocaml-4.06-refman.dvi.gz";
    fwd_v2 "/releases/4.06/ocaml-4.06-refman.html";
    fwd_v2 "/releases/4.06/ocaml-4.06-refman.info.tar.gz";
    fwd_v2 "/releases/4.06/ocaml-4.06-refman.pdf";
    fwd_v2 "/releases/4.06/ocaml-4.06-refman.ps.gz";
    fwd_v2 "/releases/4.06/ocaml-4.06-refman.txt";
    fwd_v2 "/releases/4.07/notes/Changes";
    fwd_v2 "/releases/4.07/notes/INSTALL.adoc";
    fwd_v2 "/releases/4.07/notes/LICENSE";
    fwd_v2 "/releases/4.07/notes/README.adoc";
    fwd_v2 "/releases/4.07/notes/README.win32.adoc";
    fwd_v2 "/releases/4.07/ocaml-4.07-refman-html.tar.gz";
    fwd_v2 "/releases/4.07/ocaml-4.07-refman-html.zip";
    fwd_v2 "/releases/4.07/ocaml-4.07-refman.dvi.gz";
    fwd_v2 "/releases/4.07/ocaml-4.07-refman.html";
    fwd_v2 "/releases/4.07/ocaml-4.07-refman.info.tar.gz";
    fwd_v2 "/releases/4.07/ocaml-4.07-refman.pdf";
    fwd_v2 "/releases/4.07/ocaml-4.07-refman.ps.gz";
    fwd_v2 "/releases/4.07/ocaml-4.07-refman.txt";
    fwd_v2 "/releases/4.08/notes/Changes";
    fwd_v2 "/releases/4.08/notes/INSTALL.adoc";
    fwd_v2 "/releases/4.08/notes/LICENSE";
    fwd_v2 "/releases/4.08/notes/README.adoc";
    fwd_v2 "/releases/4.08/notes/README.win32.adoc";
    fwd_v2 "/releases/4.08/ocaml-4.08-refman-html.tar.gz";
    fwd_v2 "/releases/4.08/ocaml-4.08-refman-html.zip";
    fwd_v2 "/releases/4.08/ocaml-4.08-refman.html";
    fwd_v2 "/releases/4.08/ocaml-4.08-refman.info.tar.gz";
    fwd_v2 "/releases/4.08/ocaml-4.08-refman.pdf";
    fwd_v2 "/releases/4.08/ocaml-4.08-refman.txt";
    fwd_v2 "/releases/4.09/notes/Changes";
    fwd_v2 "/releases/4.09/notes/INSTALL.adoc";
    fwd_v2 "/releases/4.09/notes/LICENSE";
    fwd_v2 "/releases/4.09/notes/README.adoc";
    fwd_v2 "/releases/4.09/notes/README.win32.adoc";
    fwd_v2 "/releases/4.09/ocaml-4.09-refman-html.tar.gz";
    fwd_v2 "/releases/4.09/ocaml-4.09-refman-html.zip";
    fwd_v2 "/releases/4.09/ocaml-4.09-refman.html";
    fwd_v2 "/releases/4.09/ocaml-4.09-refman.info.tar.gz";
    fwd_v2 "/releases/4.09/ocaml-4.09-refman.pdf";
    fwd_v2 "/releases/4.09/ocaml-4.09-refman.txt";
    fwd_v2 "/releases/4.10/notes/Changes";
    fwd_v2 "/releases/4.10/notes/INSTALL.adoc";
    fwd_v2 "/releases/4.10/notes/LICENSE";
    fwd_v2 "/releases/4.10/notes/README.adoc";
    fwd_v2 "/releases/4.10/notes/README.win32.adoc";
    fwd_v2 "/releases/4.10/ocaml-4.10-refman-html.tar.gz";
    fwd_v2 "/releases/4.10/ocaml-4.10-refman-html.zip";
    fwd_v2 "/releases/4.10/ocaml-4.10-refman.html";
    fwd_v2 "/releases/4.10/ocaml-4.10-refman.info.tar.gz";
    fwd_v2 "/releases/4.10/ocaml-4.10-refman.pdf";
    fwd_v2 "/releases/4.10/ocaml-4.10-refman.txt";
    fwd_v2 "/releases/4.11/notes/Changes";
    fwd_v2 "/releases/4.11/notes/INSTALL.adoc";
    fwd_v2 "/releases/4.11/notes/LICENSE";
    fwd_v2 "/releases/4.11/notes/README.adoc";
    fwd_v2 "/releases/4.11/notes/README.win32.adoc";
    fwd_v2 "/releases/4.11/ocaml-4.11-refman-html.tar.gz";
    fwd_v2 "/releases/4.11/ocaml-4.11-refman-html.zip";
    fwd_v2 "/releases/4.11/ocaml-4.11-refman.html";
    fwd_v2 "/releases/4.11/ocaml-4.11-refman.info.tar.gz";
    fwd_v2 "/releases/4.11/ocaml-4.11-refman.pdf";
    fwd_v2 "/releases/4.11/ocaml-4.11-refman.txt";
    fwd_v2 "/releases/4.12/notes/Changes";
    fwd_v2 "/releases/4.12/notes/INSTALL.adoc";
    fwd_v2 "/releases/4.12/notes/LICENSE";
    fwd_v2 "/releases/4.12/notes/README.adoc";
    fwd_v2 "/releases/4.12/notes/README.win32.adoc";
    fwd_v2 "/releases/4.12/ocaml-4.12-refman-html.tar.gz";
    fwd_v2 "/releases/4.12/ocaml-4.12-refman-html.zip";
    fwd_v2 "/releases/4.12/ocaml-4.12-refman.html";
    fwd_v2 "/releases/4.12/ocaml-4.12-refman.info.tar.gz";
    fwd_v2 "/releases/4.12/ocaml-4.12-refman.pdf";
    fwd_v2 "/releases/4.12/ocaml-4.12-refman.txt";
    fwd_v2 "/releases/4.13/notes/Changes";
    fwd_v2 "/releases/4.13/notes/INSTALL.adoc";
    fwd_v2 "/releases/4.13/notes/LICENSE";
    fwd_v2 "/releases/4.13/notes/README.adoc";
    fwd_v2 "/releases/4.13/notes/README.win32.adoc";
    fwd_v2 "/releases/4.13/ocaml-4.13-refman-html.tar.gz";
    fwd_v2 "/releases/4.13/ocaml-4.13-refman-html.zip";
    fwd_v2 "/releases/4.13/ocaml-4.13-refman.html";
    fwd_v2 "/releases/4.13/ocaml-4.13-refman.info.tar.gz";
    fwd_v2 "/releases/4.13/ocaml-4.13-refman.pdf";
    fwd_v2 "/releases/4.13/ocaml-4.13-refman.txt";
    fwd_v2 "/releases/4.14/notes/Changes";
    fwd_v2 "/releases/4.14/notes/INSTALL.adoc";
    fwd_v2 "/releases/4.14/notes/LICENSE";
    fwd_v2 "/releases/4.14/notes/README.adoc";
    fwd_v2 "/releases/4.14/notes/README.win32.adoc";
    fwd_v2 "/releases/4.14/ocaml-4.14-refman-html.tar.gz";
    fwd_v2 "/releases/4.14/ocaml-4.14-refman-html.zip";
    fwd_v2 "/releases/4.14/ocaml-4.14-refman.html";
    fwd_v2 "/releases/4.14/ocaml-4.14-refman.info.tar.gz";
    fwd_v2 "/releases/4.14/ocaml-4.14-refman.pdf";
    fwd_v2 "/releases/4.14/ocaml-4.14-refman.txt";
    fwd_v2 "/releases/5.0/notes/Changes";
    fwd_v2 "/releases/5.0/notes/INSTALL.adoc";
    fwd_v2 "/releases/5.0/notes/LICENSE";
    fwd_v2 "/releases/5.0/notes/README.adoc";
    fwd_v2 "/releases/5.0/notes/README.win32.adoc";
    fwd_v2 "/releases/5.0/ocaml-5.0-refman-html.tar.gz";
    fwd_v2 "/releases/5.0/ocaml-5.0-refman-html.zip";
    fwd_v2 "/releases/5.0/ocaml-5.0-refman.html";
    fwd_v2 "/releases/5.0/ocaml-5.0-refman.info.tar.gz";
    fwd_v2 "/releases/5.0/ocaml-5.0-refman.pdf";
    fwd_v2 "/releases/5.0/ocaml-5.0-refman.txt";
  ]

let lts_version = Data.Release.lts.version
let latest_version = Data.Release.latest.version

let from_v2 =
  [
    ("/about.fr.html", Url.about);
    ("/about.html", Url.about);
    ("/caml-light/faq.html", Url.index);
    ("/caml-light/index.html", Url.index);
    ("/caml-light", Url.index);
    ("/caml-light/license.html", Url.index);
    ("/caml-light/releases/0.75.html", Url.index);
    ("/community/announcements/CompCert_award.html", Url.community);
    ("/community/cwn/index.html", Url.community);
    ("/community/cwn", Url.community);
    ("/community/history/forge.html", Url.community);
    ("/community/index.fr.html", Url.community);
    ("/community/index.html", Url.community);
    ("/community/mailing_lists.fr.html", Url.community);
    ("/community/mailing_lists.html", Url.community);
    ("/community/media.html", Url.community);
    ("/community/planet.html", Url.blog);
    ("/community/planet/index.html", Url.blog);
    ("/community/planet", Url.blog);
    ("/community/planet/older.html", Url.blog);
    ("/community/planet/syndication.html", Url.blog);
    ("/community/support.fr.html", Url.community);
    ("/community/support.html", Url.community);
    ("/consortium/index.fr.html", Url.index);
    ("/consortium/index.html", Url.index);
    ("/consortium", Url.index);
    ("/contributors.fr.html", Url.index);
    ("/contributors.html", Url.index);
    ("/docs/cheat_sheets.html", Url.learn);
    ("/docs/consortium-license.html", Url.index);
    ("/docs/index.fr.html", Url.learn);
    ("/docs/index.html", Url.learn);
    ("/docs/install.fr.html", Url.getting_started);
    ("/docs/install.html", Url.getting_started);
    ("/docs/license.fr.html", Url.index);
    ("/docs/license.html", Url.index);
    ("/docs/logos.html", Url.index);
    ("/docs/papers.html", Url.papers);
    ("/governance.html", Url.governance);
    ("/index.fr.html", Url.index);
    ("/index.html", Url.index);
    ("/learn/books.html", Url.books);
    ("/learn/companies.html", Url.industrial_users);
    ("/learn/description.html", Url.about);
    ("/learn/faq.html", Url.learn);
    ("/learn/history.fr.html", Url.about);
    ("/learn/history.html", Url.about);
    ("/learn/index.fr.html", Url.learn);
    ("/learn/index.html", Url.learn);
    ("/learn", Url.learn);
    ("/learn/libraries.html", Url.packages);
    ("/learn/portability.html", Url.learn);
    ("/learn/success.fr.html", Url.industrial_users);
    ("/learn/success.html", Url.industrial_users);
    ("/learn/taste.fr.html", Url.learn);
    ("/learn/taste.html", Url.learn);
    ("/learn/teaching-ocaml.html", Url.academic_users);
    ("/learn/tutorials/99problems.html", Url.problems);
    ("/learn/tutorials/a_first_hour_with_ocaml.html", Url.tutorial "first-hour");
    ( "/learn/tutorials/calling_c_libraries.html",
      Url.tutorial "calling-c-libraries" );
    ( "/learn/tutorials/calling_fortran_libraries.html",
      Url.tutorial "calling-fortran-libraries" );
    ("/learn/tutorials/camlp5.html", Url.learn);
    ( "/learn/tutorials/command-line_arguments.ja.html",
      Url.tutorial "cli-arguments" );
    ( "/learn/tutorials/command-line_arguments.html",
      Url.tutorial "cli-arguments" );
    ( "/learn/tutorials/command-line_arguments.zh.html",
      Url.tutorial "cli-arguments" );
    ( "/learn/tutorials/common_error_messages.fr.html",
      Url.tutorial "common-errors" );
    ( "/learn/tutorials/common_error_messages.ja.html",
      Url.tutorial "common-errors" );
    ("/learn/tutorials/common_error_messages.html", Url.tutorial "common-errors");
    ( "/learn/tutorials/common_error_messages.zh.html",
      Url.tutorial "common-errors" );
    ( "/learn/tutorials/comparison_of_standard_containers.ja.html",
      Url.tutorial "data-structures-comparison" );
    ( "/learn/tutorials/comparison_of_standard_containers.ko.html",
      Url.tutorial "data-structures-comparison" );
    ( "/learn/tutorials/comparison_of_standard_containers.html",
      Url.tutorial "data-structures-comparison" );
    ( "/learn/tutorials/comparison_of_standard_containers.zh.html",
      Url.tutorial "data-structures-comparison" );
    ( "/learn/tutorials/compiling_ocaml_projects.ja.html",
      Url.tutorial "compiling-ocaml-projects" );
    ( "/learn/tutorials/compiling_ocaml_projects.html",
      Url.tutorial "compiling-ocaml-projects" );
    ( "/learn/tutorials/data_types_and_matching.fr.html",
      Url.tutorial "data-types" );
    ( "/learn/tutorials/data_types_and_matching.it.html",
      Url.tutorial "data-types" );
    ( "/learn/tutorials/data_types_and_matching.ja.html",
      Url.tutorial "data-types" );
    ("/learn/tutorials/data_types_and_matching.html", Url.tutorial "data-types");
    ( "/learn/tutorials/data_types_and_matching.zh.html",
      Url.tutorial "data-types" );
    ("/learn/tutorials/debug.html", Url.tutorial "debugging");
    ("/learn/tutorials/error_handling.html", Url.tutorial "error-handling");
    ( "/learn/tutorials/file_manipulation.ja.html",
      Url.tutorial "file-manipulation" );
    ("/learn/tutorials/file_manipulation.html", Url.tutorial "file-manipulation");
    ( "/learn/tutorials/file_manipulation.zh.html",
      Url.tutorial "file-manipulation" );
    ("/learn/tutorials/format.fr.html", Url.tutorial "formatting-text");
    ("/learn/tutorials/format.html", Url.tutorial "formatting-text");
    ( "/learn/tutorials/functional_programming.fr.html",
      Url.tutorial "functional-programming" );
    ( "/learn/tutorials/functional_programming.it.html",
      Url.tutorial "functional-programming" );
    ( "/learn/tutorials/functional_programming.ja.html",
      Url.tutorial "functional-programming" );
    ( "/learn/tutorials/functional_programming.html",
      Url.tutorial "functional-programming" );
    ( "/learn/tutorials/functional_programming.zh.html",
      Url.tutorial "functional-programming" );
    ("/learn/tutorials/functors.html", Url.tutorial "functors");
    ( "/learn/tutorials/garbage_collection.ja.html",
      Url.tutorial "garbage-collection" );
    ( "/learn/tutorials/garbage_collection.html",
      Url.tutorial "garbage-collection" );
    ( "/learn/tutorials/garbage_collection.zh.html",
      Url.tutorial "garbage-collection" );
    ("/learn/tutorials/guidelines.html", Url.tutorial "guidelines");
    ("/learn/tutorials/hashtbl.ja.html", Url.tutorial "hash-tables");
    ("/learn/tutorials/hashtbl.html", Url.tutorial "hash-tables");
    ("/learn/tutorials/hashtbl.zh.html", Url.tutorial "hash-tables");
    ("/learn/tutorials/humor_proof.html", Url.learn);
    ( "/learn/tutorials/if_statements_loops_and_recursion.fr.html",
      Url.tutorial "if-statements-and-loops" );
    ( "/learn/tutorials/if_statements_loops_and_recursion.it.html",
      Url.tutorial "if-statements-and-loops" );
    ( "/learn/tutorials/if_statements_loops_and_recursion.ja.html",
      Url.tutorial "if-statements-and-loops" );
    ( "/learn/tutorials/if_statements_loops_and_recursion.ko.html",
      Url.tutorial "if-statements-and-loops" );
    ( "/learn/tutorials/if_statements_loops_and_recursion.html",
      Url.tutorial "if-statements-and-loops" );
    ( "/learn/tutorials/if_statements_loops_and_recursion.zh.html",
      Url.tutorial "if-statements-and-loops" );
    ("/learn/tutorials/index.de.html", Url.learn);
    ("/learn/tutorials/index.fr.html", Url.learn);
    ("/learn/tutorials/index.it.html", Url.learn);
    ("/learn/tutorials/index.ja.html", Url.learn);
    ("/learn/tutorials/index.ko.html", Url.learn);
    ("/learn/tutorials/index.html", Url.learn);
    ("/learn/tutorials", Url.learn);
    ("/learn/tutorials/index.zh.html", Url.learn);
    ("/learn/tutorials/introduction_to_gtk.html", Url.learn);
    ("/learn/tutorials/labels.ja.html", Url.tutorial "labels");
    ("/learn/tutorials/labels.html", Url.tutorial "labels");
    ("/learn/tutorials/labels.zh.html", Url.tutorial "labels");
    ("/learn/tutorials/lists.html", Url.tutorial "lists");
    ("/learn/tutorials/map.fr.html", Url.tutorial "map");
    ("/learn/tutorials/map.ja.html", Url.tutorial "map");
    ("/learn/tutorials/map.html", Url.tutorial "map");
    ("/learn/tutorials/map.zh.html", Url.tutorial "map");
    ("/learn/tutorials/modules.fr.html", Url.tutorial "modules");
    ("/learn/tutorials/modules.ja.html", Url.tutorial "modules");
    ("/learn/tutorials/modules.ko.html", Url.tutorial "modules");
    ("/learn/tutorials/modules.html", Url.tutorial "modules");
    ("/learn/tutorials/modules.zh.html", Url.tutorial "modules");
    ( "/learn/tutorials/null_pointers_asserts_and_warnings.fr.html",
      Url.tutorial "null-pointers-asserts-and-warnings" );
    ( "/learn/tutorials/null_pointers_asserts_and_warnings.it.html",
      Url.tutorial "null-pointers-asserts-and-warnings" );
    ( "/learn/tutorials/null_pointers_asserts_and_warnings.ja.html",
      Url.tutorial "null-pointers-asserts-and-warnings" );
    ( "/learn/tutorials/null_pointers_asserts_and_warnings.html",
      Url.tutorial "null-pointers-asserts-and-warnings" );
    ( "/learn/tutorials/null_pointers_asserts_and_warnings.zh.html",
      Url.tutorial "null-pointers-asserts-and-warnings" );
    ("/learn/tutorials/objects.ja.html", Url.tutorial "objects");
    ("/learn/tutorials/objects.html", Url.tutorial "objects");
    ("/learn/tutorials/objects.zh.html", Url.tutorial "objects");
    ( "/learn/tutorials/performance_and_profiling.ja.html",
      Url.tutorial "profiling" );
    ("/learn/tutorials/performance_and_profiling.html", Url.tutorial "profiling");
    ( "/learn/tutorials/performance_and_profiling_discussion.html",
      Url.tutorial "profiling" );
    ("/learn/tutorials/pointers.html", Url.tutorial "pointers");
    ("/learn/tutorials/pointers.zh.html", Url.tutorial "pointers");
    ("/learn/tutorials/set.fr.html", Url.tutorial "sets");
    ("/learn/tutorials/set.ja.html", Url.tutorial "sets");
    ("/learn/tutorials/set.html", Url.tutorial "sets");
    ("/learn/tutorials/set.zh.html", Url.tutorial "sets");
    ("/learn/tutorials/streams.html", Url.tutorial "streams");
    ("/learn/tutorials/up_and_running.html", Url.tutorial "up-and-running");
    (Url.tutorial "first-hour", Url.tutorial "a-tour-of-ocaml");
    ("/meetings/index.fr.html", Url.community);
    ("/meetings/index.html", Url.community);
    ("/meetings", Url.community);
    ( "/meetings/ocaml/2008/index.html",
      Url.workshop "ocaml-users-and-developers-workshop-2008" );
    ( "/meetings/ocaml/2008",
      Url.workshop "ocaml-users-and-developers-workshop-2008" );
    ( "/meetings/ocaml/2008/index.html",
      Url.workshop "ocaml-users-and-developers-workshop-2008" );
    ( "/meetings/ocaml/2008",
      Url.workshop "ocaml-users-and-developers-workshop-2008" );
    ( "/meetings/ocaml/2009/index.html",
      Url.workshop "ocaml-users-and-developers-workshop-2009" );
    ( "/meetings/ocaml/2009",
      Url.workshop "ocaml-users-and-developers-workshop-2009" );
    ( "/meetings/ocaml/2010/index.html",
      Url.workshop "ocaml-users-and-developers-workshop-2010" );
    ( "/meetings/ocaml/2010",
      Url.workshop "ocaml-users-and-developers-workshop-2010" );
    ( "/meetings/ocaml/2011/index.html",
      Url.workshop "ocaml-users-and-developers-workshop-2011" );
    ( "/meetings/ocaml/2011",
      Url.workshop "ocaml-users-and-developers-workshop-2011" );
    ( "/meetings/ocaml/2012/index.html",
      Url.workshop "ocaml-users-and-developers-workshop-2012" );
    ( "/meetings/ocaml/2013/call.html",
      Url.workshop "ocaml-users-and-developers-workshop-2013" );
    ( "/meetings/ocaml/2013",
      Url.workshop "ocaml-users-and-developers-workshop-2013" );
    ( "/meetings/ocaml/2013/index.html",
      Url.workshop "ocaml-users-and-developers-workshop-2013" );
    ( "/meetings/ocaml/2013/program.html",
      Url.workshop "ocaml-users-and-developers-workshop-2013" );
    ( "/meetings/ocaml/2013",
      Url.workshop "ocaml-users-and-developers-workshop-2013" );
    ( "/meetings/ocaml/2013/talks/index.html",
      Url.workshop "ocaml-users-and-developers-workshop-2013" );
    ( "/meetings/ocaml/2014/cfp.html",
      Url.workshop "ocaml-users-and-developers-workshop-2014" );
    ( "/meetings/ocaml/2014",
      Url.workshop "ocaml-users-and-developers-workshop-2014" );
    ( "/meetings/ocaml/2014/index.html",
      Url.workshop "ocaml-users-and-developers-workshop-2014" );
    ( "/meetings/ocaml/2014/ocaml2014_10.html",
      Url.workshop "ocaml-users-and-developers-workshop-2014" );
    ( "/meetings/ocaml/2014/program.html",
      Url.workshop "ocaml-users-and-developers-workshop-2014" );
    ( "/meetings/ocaml/2015/cfp.html",
      Url.workshop "ocaml-users-and-developers-workshop-2015" );
    ( "/meetings/ocaml/2015",
      Url.workshop "ocaml-users-and-developers-workshop-2015" );
    ( "/meetings/ocaml/2015/index.html",
      Url.workshop "ocaml-users-and-developers-workshop-2015" );
    ( "/meetings/ocaml/2015",
      Url.workshop "ocaml-users-and-developers-workshop-2015" );
    ( "/meetings/ocaml/2015/program.html",
      Url.workshop "ocaml-users-and-developers-workshop-2015" );
    ( "/meetings/ocaml/2015",
      Url.workshop "ocaml-users-and-developers-workshop-2015" );
    ( "/meetings/ocaml/2015/program.txt",
      Url.workshop "ocaml-users-and-developers-workshop-2015" );
    ( "/meetings/ocaml/2015",
      Url.workshop "ocaml-users-and-developers-workshop-2015" );
    ( "/meetings/ocaml/2016/index.html",
      Url.workshop "ocaml-users-and-developers-workshop-2016" );
    ( "/meetings/ocaml/2016",
      Url.workshop "ocaml-users-and-developers-workshop-2016" );
    ( "/meetings/ocaml/2017/index.html",
      Url.workshop "ocaml-users-and-developers-workshop-2017" );
    ( "/meetings/ocaml/2017",
      Url.workshop "ocaml-users-and-developers-workshop-2017" );
    ( "/meetings/ocaml/2018/index.html",
      Url.workshop "ocaml-users-and-developers-workshop-2018" );
    ( "/meetings/ocaml/2018",
      Url.workshop "ocaml-users-and-developers-workshop-2018" );
    ( "/meetings/ocaml/2019/index.html",
      Url.workshop "ocaml-users-and-developers-workshop-2019" );
    ( "/meetings/ocaml/2019",
      Url.workshop "ocaml-users-and-developers-workshop-2019" );
    ( "/meetings/ocaml/2020/index.html",
      Url.workshop "ocaml-users-and-developers-workshop-2020" );
    ( "/meetings/ocaml/2020",
      Url.workshop "ocaml-users-and-developers-workshop-2020" );
    ("/meetings/ocaml/index.html", Url.community);
    ("/meetings/ocaml", Url.community);
    ("/ocamllabs/index.html", Url.index);
    ("/ocamllabs", Url.index);
    ("/platform/index.html", Url.platform);
    ("/platform", Url.platform);
    ("/platform/ocaml_on_windows.html", Url.ocaml_on_windows);
    ("/releases/3.12.1.html", Url.release "3.12.1");
    ("/releases/4.00.1.html", Url.release "4.00.1");
    ("/releases/4.01.0.fr.html", Url.release "4.01.0");
    ("/releases/4.01.0.html", Url.release "4.01.0");
    ("/releases/4.02.0.html", Url.release "4.02.0");
    ("/releases/4.02.1.html", Url.release "4.02.1");
    ("/releases/4.02.2.html", Url.release "4.02.2");
    ("/releases/4.02.3.html", Url.release "4.02.3");
    ("/releases/4.02.html", Url.release "4.02.0");
    ("/releases/4.03.0.html", Url.release "4.03.0");
    ("/releases/4.03.html", Url.release "4.03.0");
    ("/releases/4.04.0.html", Url.release "4.04.0");
    ("/releases/4.04.1.html", Url.release "4.04.1");
    ("/releases/4.04.2.html", Url.release "4.04.2");
    ("/releases/4.04.html", Url.release "4.04.0");
    ("/releases/4.05.0.html", Url.release "4.05.0");
    ("/releases/4.05.html", Url.release "4.05.0");
    ("/releases/4.06.0.html", Url.release "4.06.0");
    ("/releases/4.06.1.html", Url.release "4.06.1");
    ("/releases/4.06.html", Url.release "4.06.0");
    ("/releases/4.07.0.html", Url.release "4.07.0");
    ("/releases/4.07.1.html", Url.release "4.07.1");
    ("/releases/4.08.0.html", Url.release "4.08.0");
    ("/releases/4.08.1.html", Url.release "4.08.1");
    ("/releases/4.09.0.html", Url.release "4.09.0");
    ("/releases/4.09.1.html", Url.release "4.09.1");
    ("/releases/4.10.0.html", Url.release "4.10.0");
    ("/releases/4.10.1.html", Url.release "4.10.1");
    ("/releases/4.10.2.html", Url.release "4.10.2");
    ("/releases/4.11.0.html", Url.release "4.11.0");
    ("/releases/4.11.1.html", Url.release "4.11.1");
    ("/releases/4.11.2.html", Url.release "4.11.2");
    ("/releases/4.12.0.html", Url.release "4.12.0");
    ("/releases/4.12.1.html", Url.release "4.12.1");
    ("/releases/4.13.0.html", Url.release "4.13.0");
    ("/releases/4.13.1.html", Url.release "4.13.1");
    ("/releases/4.14.0.html", Url.release "4.14.0");
    ("/releases/5.0.0.html", Url.release "5.0.0");
    ("/releases/caml-light/faq.html", Url.index);
    ("/releases/caml-light/index.html", Url.index);
    ("/releases/caml-light", Url.index);
    ("/releases/caml-light/license.html", Url.index);
    ("/releases/caml-light/releases/0.75.html", Url.index);
    ("/releases/index.fr.html", Url.releases);
    ("/releases/index.html", Url.releases);
    ("/releases", Url.releases);
    ("/releases/lts", Url.release lts_version);
    ("/releases/lts/index.html", Url.release lts_version);
    ("/releases/lts/manual.html", Url.manual_with_version lts_version);
    ("/releases/lts/manual", Url.manual_with_version lts_version);
    ("/releases/lts/manual/index.html", Url.manual_with_version lts_version);
    ("/releases/lts/htmlman", Url.manual_with_version lts_version);
    ("/releases/lts/htmlman/index.html", Url.manual_with_version lts_version);
    ("/releases/lts/api", Url.api_with_version lts_version);
    ("/releases/lts/pi/index.html", Url.api_with_version lts_version);
    ("/releases/latest", Url.release latest_version);
    ("/releases/latest/index.html", Url.release latest_version);
    ("/releases/latest/manual.html", Url.manual_with_version latest_version);
    ("/releases/latest/manual", Url.manual_with_version latest_version);
    ( "/releases/latest/manual/index.html",
      Url.manual_with_version latest_version );
    ("/releases/latest/htmlman", Url.manual_with_version latest_version);
    ( "/releases/latest/htmlman/index.html",
      Url.manual_with_version latest_version );
    ("/releases/latest/api", Url.api_with_version latest_version);
    ("/releases/latest/api/index.html", Url.api_with_version latest_version);
  ]

let redirect_p pattern =
  let handler req =
    let target = Dream.target req in
    Dream.redirect req (Url.v2 ^ target)
  in
  Dream.get pattern handler

let fwd_v2 origin =
  Dream.get origin (fun req -> Dream.redirect req (Url.v2 ^ origin))

let manual =
  [
    redirect_p "/api/**";
    fwd_v2 "/api";
    redirect_p "/manual/**";
    fwd_v2 "/manual";
    redirect_p "/releases/3.12/htmlman/**";
    fwd_v2 "/releases/3.12/htmlman";
    redirect_p "/releases/4.00/htmlman/**";
    fwd_v2 "/releases/4.00/htmlman";
    redirect_p "/releases/4.01/htmlman/**";
    fwd_v2 "/releases/4.01/htmlman";
    redirect_p "/releases/4.02/htmlman/**";
    fwd_v2 "/releases/4.02/htmlman";
    redirect_p "/releases/4.03/htmlman/**";
    fwd_v2 "/releases/4.03/htmlman";
    redirect_p "/releases/4.04/htmlman/**";
    fwd_v2 "/releases/4.04/htmlman";
    redirect_p "/releases/4.05/htmlman/**";
    fwd_v2 "/releases/4.05/htmlman";
    redirect_p "/releases/4.06/htmlman/**";
    fwd_v2 "/releases/4.06/htmlman";
    redirect_p "/releases/4.07/htmlman/**";
    fwd_v2 "/releases/4.07/htmlman";
    redirect_p "/releases/4.08/htmlman/**";
    fwd_v2 "/releases/4.08/htmlman";
    redirect_p "/releases/4.09/htmlman/**";
    fwd_v2 "/releases/4.09/htmlman";
    redirect_p "/releases/4.10/htmlman/**";
    fwd_v2 "/releases/4.10/htmlman";
    redirect_p "/releases/4.11/htmlman/**";
    fwd_v2 "/releases/4.11/htmlman";
    redirect_p "/releases/4.12/api/**";
    fwd_v2 "/releases/4.12/api";
    redirect_p "/releases/4.12/htmlman/**";
    fwd_v2 "/releases/4.12/htmlman";
    redirect_p "/releases/4.12/manual/**";
    fwd_v2 "/releases/4.12/manual";
    redirect_p "/releases/4.13/api/**";
    fwd_v2 "/releases/4.13/api";
    redirect_p "/releases/4.13/htmlman/**";
    fwd_v2 "/releases/4.13/htmlman";
    redirect_p "/releases/4.13/manual/**";
    fwd_v2 "/releases/4.13/manual";
    redirect_p "/releases/4.14/api/**";
    fwd_v2 "/releases/4.14/api";
    redirect_p "/releases/4.14/htmlman/**";
    fwd_v2 "/releases/4.14/htmlman";
    redirect_p "/releases/4.14/manual/**";
    fwd_v2 "/releases/4.14/manual";
    redirect_p "/releases/5.0/api/**";
    fwd_v2 "/releases/5.0/api";
    redirect_p "/releases/5.0/htmlman/**";
    fwd_v2 "/releases/5.0/htmlman";
    redirect_p "/releases/5.0/manual/**";
    fwd_v2 "/releases/5.0/manual";
  ]

let make ?(permanent = false) t =
  let status = if permanent then `Moved_Permanently else `See_Other in
  Dream.scope ""
    [ Dream_encoding.compress ]
    (List.filter_map
       (fun (origin, new_) ->
         if origin = new_ then None
         else
           Some (Dream.get origin (fun req -> Dream.redirect ~status req new_)))
       t)

let package req =
  let package = Dream.param req "name" in
  Dream.redirect req (Url.Package.overview package)

let package_docs req =
  let package = Dream.param req "name" in
  Dream.redirect req (Url.Package.documentation package)

let t =
  Dream.scope "" []
    [
      make from_v2;
      make v2_assets;
      Dream.scope "" [ Dream_encoding.compress ] manual;
      make ~permanent:true [ ("/opportunities", "/jobs") ];
      make ~permanent:true
        [ ("/carbon-footprint", "/policies/carbon-footprint") ];
      make ~permanent:true [ ("/privacy-policy", "/policies/privacy-policy") ];
      make ~permanent:true [ ("/governance", "/policies/governance") ];
      make ~permanent:true [ ("/code-of-conduct", "/policies/code-of-conduct") ];
      make ~permanent:true [ ("/opportunities", "/jobs") ];
      make ~permanent:false [ (Url.workshops, Url.community ^ "#workshops") ];
      Dream.get "/p/:name" package;
      Dream.get "/u/:hash/p/:name" package;
      Dream.get "/p/:name/doc" package_docs;
    ]
