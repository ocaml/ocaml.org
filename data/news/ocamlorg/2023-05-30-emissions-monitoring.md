---
title: An Update on the Environmental Impact of the OCaml.org Cluster
description: For the 19 machines we monitor in the OCaml.org cluster we are seeing a figure in the ball park of 70kg of CO2e per week
date: "2023-05-30"
tags: [ocamlorg]
---

*TL;DR For the 19 machines we monitor in the OCaml.org cluster we are seeing a figure in the ball park of 70kg of CO2e per week. [Discussion thread here](https://discuss.ocaml.org/t/initial-emissions-monitoring-of-the-ocaml-org-infrastructure/12335).*

Since the OCaml.org redesign we have, as a community, [committed](https://discuss.ocaml.org/t/ocaml-org-recapping-2022-and-queries-on-the-fediverse/11099/21) to being [accountable for our impact on the environment](https://ocaml.org/policies/carbon-footprint). As a first step we aimed to accurately quantify our impact by calculating the total amount of energy we are using. It is necessary to establish a baseline of present activity to determine whether any changes we make in the future are reducing our CO2e emissions.

This has not been a straightforward number to identify as there is a [large cluster of machines](https://infra.ocaml.org/by-use/general) running day and night providing services such as [ocaml-ci][], [opam-repo-ci][], the [docker base images](https://images.ci.ocaml.org) and services like ocaml.org itself and the federated watch.ocaml.org. These machines span numerous architectures, operating systems, and types (e.g. virtual vs. bare-metal) making it difficult to build portable tools to monitor each machine.

We've used the past few months to build new tools and deploy monitoring devices, to give us as accurate a figure as possible.

## Monitoring Using IPMI-enabled Machines

One method for collecting power usage numbers is to use the Intelligent Platform Management Interface (IPMI). IPMI is a specification for a set of interfaces that allow for the management and monitoring of computers. Quite often the controller used by the IPMI will be the Baseboard Management Controller (BMC). Sensors monitoring the server (including power consumption, temperature and fan speed) often report to the BMC.

[Clarke][] is a tool we've built that provides a common interface for different methods of monitoring and reporting power usage. It can use [ipmitool][] to collect power consumption numbers and report this over to [Prometheus][].

We have installed [Clarke][] on a number of machines that support IPMI and have made modifications to [OCluster][] to pick up the resulting Prometheus outputs for each machine.

## Quantifying the Carbon Intensity of Electricity

Many systems that require electricity to run are powered from a national grid. The electricity from the grid is usually created from a variety of electricity-generating activities and the combination of different activities is usually referred to as the [grid's energy mix](https://www.nationalgrideso.com/electricity-explained/electricity-and-me/great-britains-monthly-electricity-stats).

From this mix, the average *carbon intensity* can be calculated. Carbon intensity is the amount of Carbon Dioxide Equivalent (CO2e) emissions produced in order to supply a kilowatt hour of electricity. The units are grams of CO2e per kilowatt hour (gCO2e/kWh). Why CO2e? Carbon dioxide (CO2) is not the only Greenhouse Gas (for example there is water vapour, methane etc.). The [Carbon Dioxide Equivalent](https://ec.europa.eu/eurostat/statistics-explained/index.php?title=Glossary:Carbon_dioxide_equivalent) unit gives us a way to convert between the various Greenhouse Gases allowing for a fair way to compare different emitting activities.


Fortunately, the machines we can monitor using IMPI, are all located in Cambridge. We can use the [carbon-intensity][] API for accessing real-time numbers for the national grid in Great Britain. In fact, we developed a tool of the same name, [carbon-intensity](https://github.com/geocaml/carbon-intensity), to abstract over the various APIs, providing a single common interface for fetching carbon intensity values.

```ocaml
type t
(** A configuration parameter for the API *)

val get_intensity : t -> int option
(** [get_intensity t] returns the current gCO2/kWh if available. *)
```

## A value for total emissions

With both the cluster's total power draw and a value for the carbon intensity, we can now calculate a value for total emissions from energy use. For a single machine, let's assume a power reading of `250W`. We also know how frequently we are sampling the power reading, for example every `10s`. We can use these values to calculate the `kWh` value.

```
(250 / 1000) * (10 / 3600) = 0.000694
```

If the grid is currently reporting a carbon intensity of `100gC02e/kWh` then the emissions at this particular point in time are:

```
0.000694 * 100 = 0.0694gCO2
```

To put that in perspective, for one person, the single journey from [Heathrow airport in London to Belfast International Airport](https://www.atmosfair.de/en/offset/flight/) (a distance of about 500km) works out at about `160kg` of CO2e. If the fictious machine above were to always draw `250W` and the grid always had the same intensity, it would take about 266 days to equate to the same amount.

We can perform this calculation for every machine, every ten seconds and add them all together to arrive at the total emissions for these machines over some arbitrary amount of time (e.g. a week).

Currently, for the 19 machines we monitor we are seeing a figure in the ball park of **`70kg` of CO2e per week**. This fluctuates depending on the current load on the cluster and the carbon intensity of the grid. At the time of writing, the maximum value for the carbon intensity of the grid today was `125gCO2e/kWh` and a minimum of `55gCO2e/kWh`.

## Next Steps

### Publicly Available Dashboard
The numbers behind the emissions are currently not publicly available. We would like to provide a simple dashboard for interested people to see the real-time numbers.

### Machines without IPMI

Not all machines support IPMI. One possible solution is to obtain power information directly from the hardware. [Variorum][] is a "vendor-neutral library for exposing power and performance capabilities". Using Variorum we can access information such as [Intel's RAPL](https://01.org/blogs/2014/running-average-power-limit-–-rapl) interface. We've worked on [OCaml bindings to this library](https://github.com/patricoferris/ocaml-variorum) which are already incorporated into [Clarke][]. Whilst the power values reported by Variorum might not be perfect or total, they would be a good proxy to enable more types of machines to be monitored.

### Other Emissions

[Embodied energy and carbon](https://principles.green/principles/embodied-carbon/) also make up a large proportion of our impact on the environment. Embodied carbon reflects the amount of carbon pollution required to create and eventually dispose of the machines that run our software. These numbers are not necessarily the easiest to calculate, but we could make a start at trying to work out some figures for the embodied carbon of the hardware we use and also for the rate at which new hardware replaces slow or broken hardware (and what happens to that older hardware).

By combining these figures we would get a more realistic idea of our carbon footprint, giving us a better chance of minimising our impact in the long term.

### Carbon-aware Solutions

Now that we have some idea of our environmental impact, it is a good time to start thinking of ways to minimise it. For example:

 - Carbon-aware scheduling for low-priority jobs. The [carbon-intensity][] API supports fairly accurate forecasts of the grid's carbon intensity, using this we could schedule the Docker base-image builds to only happen when the carbon intensity is low.
 - Reducing the number of builds using better solving. Currently many packages have their dependencies installed in one go during a build. This means that a [solver-service][] works out the exact packages and dependencies needed and installs them in a single build step. This also means that if one down-stream package changes, the entire build step is invalidated resulting in a full rebuild. We could instead split the installation process into multiple steps to help mitigate this problem – particularly for large, more stable packages like dune.



## In Conclusion
The community behind OCaml.org has been working hard to make good on our commitment to sustainability. Our first goal was to establish a way of measuring how much CO2e the OCaml.org cluster consumes over a specific period of time. We have spent the past couple of months developing a method that gives us a good estimate of that number.

There is work left to do to get more accurate results, such as accounting for embedded energy and carbon as well as being able to measure the energy consumption of more types of machines. The goal is to create carbon-aware solutions that minimise the impact of the OCaml.org cluster on the environment.

[ocaml-ci]: https://github.com/ocurrent/ocaml-ci
[opam-repo-ci]: https://github.com/ocurrent/opam-repo-ci
[carbon-intensity]: https://carbonintensity.org.uk
[Clarke]: https://github.com/ocurrent/clarke
[ipmitool]: https://github.com/ipmitool/ipmitool
[Prometheus]: https://prometheus.io
[OCluster]: https://github.com/ocurrent/ocluster
[Variorum]: https://variorum.readthedocs.io/en/latest/
[solver-service]: https://github.com/ocurrent/solver-service
