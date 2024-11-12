import http from "k6/http";
import { sleep } from "k6";

export const options = {
  // A number specifying the number of VUs to run concurrently.
  vus: 10,
  // A string specifying the total duration of the test run.
  duration: "30s",

  // The following section contains configuration options for execution of this
  // test script in Grafana Cloud.
  //
  // See https://grafana.com/docs/grafana-cloud/k6/get-started/run-cloud-tests-from-the-cli/
  // to learn about authoring and running k6 test scripts in Grafana k6 Cloud.
  //
  // cloud: {
  //   // The ID of the project to which the test is assigned in the k6 Cloud UI.
  //   // By default tests are executed in default project.
  //   projectID: "",
  //   // The name of the test in the k6 Cloud UI.
  //   // Test runs with the same name will be grouped.
  //   name: "script.js"
  // },

  // Uncomment this section to enable the use of Browser API in your tests.
  //
  // See https://grafana.com/docs/k6/latest/using-k6-browser/running-browser-tests/ to learn more
  // about using Browser API in your test scripts.
  //
  // scenarios: {
  //   // The scenario name appears in the result summary, tags, and so on.
  //   // You can give the scenario any name, as long as each name in the script is unique.
  //   ui: {
  //     // Executor is a mandatory parameter for browser-based tests.
  //     // Shared iterations in this case tells k6 to reuse VUs to execute iterations.
  //     //
  //     // See https://grafana.com/docs/k6/latest/using-k6/scenarios/executors/ for other executor types.
  //     executor: 'shared-iterations',
  //     options: {
  //       browser: {
  //         // This is a mandatory parameter that instructs k6 to launch and
  //         // connect to a chromium-based browser, and use it to run UI-based
  //         // tests.
  //         type: 'chromium',
  //       },
  //     },
  //   },
  // }
};

// The function that defines VU logic.
//
// See https://grafana.com/docs/k6/latest/examples/get-started-with-k6/ to learn more
// about authoring k6 scripts.

const base_url = "https://staging.ocaml.org";
// base_url = "https://ocaml.com"

function endpoint(u) {
  return base_url + u;
}

export default function () {
  // Landing page
  http.get(endpoint("/"));

  // Core doc page
  http.get(endpoint("/p/core/latest/doc/index.html"));

  // Top level pages
  http.get(endpoint("/install"));
  http.get(endpoint("/docs/tour-of-ocaml"));
  http.get(endpoint("/docs"));
  http.get(endpoint("/platform"));
  http.get(endpoint("/packages"));
  http.get(endpoint("/community"));
  http.get(endpoint("/changelog"));
  http.get(endpoint("/play"));
  http.get(endpoint("/industrial-users"));
  http.get(endpoint("/academic-users"));

  // some package searches
  // Grouping the urls, see https://grafana.com/docs/k6/latest/using-k6/http-requests/#url-grouping
  const package_search_tag = { tags: { name: "PacakageSearch" } };
  ["http", "server", "cli", "core", "eio", "graph"].forEach((q) => {
    http.get(endpoint(`/packages/autocomplete?q=${q}`), package_search_tag);
    http.get(endpoint(`/packages/search?q=${q}`), package_search_tag);
  });
}
