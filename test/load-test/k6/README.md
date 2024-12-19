# k6 Load Tests

This directory contains a [k6](https://grafana.com/docs/k6/latest/) script for
load testing ocaml.org endpoints.

- The k6 test script is defined in [./script.js](./script.js). 
- The runner script [./run.sh](./run.sh) will run `./script.js` with the k6
  docker image.
  

## Running load tests

### Prerequisites

- docker
- k6parser
- xdg-open (MacOS users may need to adjust the runner script)

### Usage

``` sh
./run.sh script.js
```

will run a load test against all defined endpoints using 10 virtual users, and
running for 30 seconds.

You can specify different values for the concurrent users and duration using the
`--vus` and `--duration` flags, respectively. E.g., to test with 100 virtual
users for one minute:

``` sh
./run.sh --vus 100 --duration 1m script.js
```

## Reviewing the results

k6 will print out the a summary of results when the test is finished. See
<https://grafana.com/docs/k6/latest/get-started/results-output/> for
documentation on how to interpret the results.

- Detailed results are written to a gzipped JOSN file
  `_results/{day}T{time}-results.gz`.
- A browser will be opened with a visualization plotting general responsiveness,
  loaded with the file `_results/{day}T{time}-results.report`.
