<?php
include 'header.php';
?>

<div class="intro-section-simple">
    <div class="container-fluid">
        <div class="flex md:flex-row md:px-10 lg:p-6 pb-20 items-center md:space-x-36 flex-col-reverse">
            <div class="text-left md:mt-10 lg:mt-0 mt-0 lg:pl-24">
                <a href="opportunities.php" class="flex justify-start space-x-3 items-center text-primary-600 hover:underline font-semibold mb-4 h-12">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
                    </svg>
                    <div>Back to Opportunities</div>
                </a>
                <h2 class="font-bold pb-6">Multicore Application Engineer</h2>
                <div class="text-lg text-body-400">Tarides</div>
                <div class="flex items-center space-x-2 ext-lg text-body-400 mt-4">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                    </svg>
                    <div>Remote</div>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="bg-white">
    <div class="py-10 lg:py-28">
        <div class="container-fluid">
            <div class="prose lg:prose-lg mx-auto max-w-5xl">
                <h2>Work</h2>
                <div class="space-y-10">
                    <p>
                        The Multicore OCaml project aims to add native support for scalable concurrency and shared memory parallelism to the OCaml programming language. At its core, Multicore OCaml extends OCaml with effect handlers for expressing scalable concurrency, and a high-performance concurrent garbage collector aimed at responsive networked applications. Multicore OCaml is also the first industrial-strength language to be equipped with an efficient yet modular memory model, allowing high-level local program reasoning while retaining performance.
                    </p>
                    <p>
                        Multicore OCaml is actively being developed and core features are being upstreamed to OCaml. The multicore project at Tarides is a close collaboration with our industrial partners OCaml Labs and Segfault Systems.
                    </p>
                    <p>
                        As OCaml 5.0 with shared-memory parallelism support is on the horizon, we are ready to build full-fledged OCaml applications that take advantage of the parallelism opportunities. Specifically, the focus is on the Tezos blockchain to improve the transaction throughput, utilising the parallelism support. We believe that adding parallelism support to a complex project such as the Tezos shell would set a precedent for how other projects should utilise parallelism support and help identify pain points that the Multicore OCaml team and the wider community can address.
                    </p>
                    <p>
                        We are looking for an experienced engineer (3y+) to build parallel applications using the Multicore OCaml compiler.
                    </p>
                    <div class="divider flex justify-center space-x-5">
                        <span class="rounded-full bg-gray-200 block"></span>
                        <span class="rounded-full bg-gray-200 block"></span>
                        <span class="rounded-full bg-gray-200 block"></span>
                    </div>

                    <h2>Responsibilities</h2>


                </div>
                Ecosystem Engineering
                Build and maintain Tezos node using the Multicore OCaml compiler.
                Add Tezos-related packages to the OCaml CI.
                Investigate CI failures and report issues to appropriate teams.
                Parallelising
                Work with the Tezos developers to identify the opportunities for parallelism in the Tezos shell.
                Utilise Multicore OCaml parallelism support (such as the Lwt offloading mechanism) to offload compute-intensive tasks such as crypto and serialisation to spare cores.
                Work with the Irmin/Tezos storage team to add parallelism to storage tasks.
                Benchmarking
                Work with the Tezos developers and Irmin team to identify relevant benchmarks.
                Implement those benchmarks for Tezos, and work with the benchmarking team to include them in sandmark and continuous benchmarking infrastructures.
                <ul>
                    <li><strong>Ecosystem Engineering</strong></li>
                    <li>
                        <ul>
                            <li>Build and maintain Tezos node using the Multicore OCaml compiler.</li>
                            <li> Add Tezos-related packages to the OCaml CI.</li>
                            <li> Investigate CI failures and report issues to appropriate teams.</li>
                        </ul>
                    </li>
                    <li><strong>Parallelising</strong></li>
                    <li>
                        <ul>
                            <li>Work with the Tezos developers to identify the opportunities for parallelism in the Tezos shell.</li>
                            <li> Utilise Multicore OCaml parallelism support (such as the Lwt offloading mechanism) to offload compute-intensive tasks such as crypto and serialisation to spare cores.</li>
                            <li>Work with the Irmin/Tezos storage team to add parallelism to storage tasks.</li>
                        </ul>
                    </li>
                    <li><strong>Benchmarking</strong></li>
                    <li>
                        <ul>
                            <li>Work with the Tezos developers and Irmin team to identify relevant benchmarks.</li>
                            <li> Implement those benchmarks for Tezos, and work with the benchmarking team to include them in sandmark and continuous benchmarking infrastructures.</li>
                        </ul>
                    </li>
                </ul>
                <button class="btn btn-lg mt-5">Apply for this position</button>
            </div>
        </div>
    </div>
</div>

<?php
include 'footer.php';
?>
