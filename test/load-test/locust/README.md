# Locust Load Tests

This directory contains a [locust](https://locust.io/) script for load testing
ocaml.org endpoints.

## Running simple load tests

1. Start the test framework running with

   ``` sh
   ./main.sh
   ```

2. Navigate to http://0.0.0.0:8089

3. Configure
  - the max number of users to simulate
  - the number of new users to add to the simulation every second
  - the host (`https://staging.ocaml.org`, `https://ocaml.org`, etc.)

## Running load tests with multiple cores

``` sh
./main.sh n
```

where `n` is the number of processes to run concurrently.

## Reviewing the load tests

- Click "Stop" when you are finished running your test.
- Review the various tabs, or click "Download data" for options to download the
  test results.
- You can also review prometheus metrics about the staging and prod servers at
  https://status.ocaml.ci.dev/d/be358r0z9ai9sf/ocaml-org

## Adding new routines

Tests are defined as "tasks" (sequences of site traversal) in
[./locustfile.py](./locustfile.py).
