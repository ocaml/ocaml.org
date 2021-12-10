<?php
include 'header.php';
?>

<div class="lg:py-24 bg-white pt-10 md:pt-16 pb-10">

    <div class="container-fluid wide">
        <div class="flex">
            <div class="p-10 z-10 w-full bg-white flex-shrink-0 flex-col absolute md:flex left-0 top-0 md:relative md:w-72 md:p-0 sidebar" x-show="sidebar" x-transition:enter="transition duration-200 transform ease-out" x-transition:enter-start="-translate-x-full" x-transition:leave="transition duration-100 transform ease-in" x-transition:leave-end="-translate-x-full">
                <div class="flex justify-start items-center">
                    <div class="bg-primary-600 text-white rounded w-8 h-8 flex items-center justify-center">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
                        </svg>
                    </div>
                    <div class="ml-2 font-semibold text-base text-body-400">Learn</div>
                </div>
                <div class="space-y-2 flex mt-10 flex-col">
                    <div class="text-sm font-semibold flex px-3 py-2">GETTING STARTED</div>
                    <a class="flex active py-2 px-3 rounded-md text-sm font-semibold" href="">Up and Running with OCaml</a>
                    <a href="" class="font-semibold text-sm text-body-400 hover:bg-gray-100 block py-2 px-3">A First Hour with OCaml</a>
                    <a href="" class="font-semibold text-sm text-body-400 hover:bg-gray-100 block py-2 px-3">OCaml Programming Guidelines</a>
                    <a href="" class="font-semibold text-sm text-body-400 hover:bg-gray-100 block py-2 px-3">Compiling OCaml Projects</a>
                </div>
                <div class="space-y-2 flex mt-10 flex-col">
                    <div class="text-sm font-semibold flex px-3 py-2">LANGUAGE FEATURES</div>
                    <a href="" class="font-semibold text-sm text-body-400 hover:bg-gray-100 block py-2 px-3">Data Types and Matching</a>
                    <a href="" class="font-semibold text-sm text-body-400 hover:bg-gray-100 block py-2 px-3">Lists</a>
                    <a href="" class="font-semibold text-sm text-body-400 hover:bg-gray-100 block py-2 px-3">Functional Programming</a>
                    <a href="" class="font-semibold text-sm text-body-400 hover:bg-gray-100 block py-2 px-3">If Statements, Loops and Recursions</a>
                    <a href="" class="font-semibold text-sm text-body-400 hover:bg-gray-100 block py-2 px-3">Modules</a>
                    <a href="" class="font-semibold text-sm text-body-400 hover:bg-gray-100 block py-2 px-3">Labels</a>
                    <a href="" class="font-semibold text-sm text-body-400 hover:bg-gray-100 block py-2 px-3">Pointers</a>
                    <a href="" class="font-semibold text-sm text-body-400 hover:bg-gray-100 block py-2 px-3">Null Pointers, Asserts and Warnings</a>
                    <a href="" class="font-semibold text-sm text-body-400 hover:bg-gray-100 block py-2 px-3">Functors</a>
                    <a href="" class="font-semibold text-sm text-body-400 hover:bg-gray-100 block py-2 px-3">Objects</a>
                    <a href="" class="font-semibold text-sm text-body-400 hover:bg-gray-100 block py-2 px-3">Comparison of Standard Containers</a>
                </div>
                <div class="space-y-2 flex mt-10 flex-col">
                    <div class="text-sm font-semibold flex px-3 py-2">Error and debugging</div>
                    <a href="" class="font-semibold text-sm text-body-400 hover:bg-gray-100 block py-2 px-3">Error Handling</a>
                    <a href="" class="font-semibold text-sm text-body-400 hover:bg-gray-100 block py-2 px-3">Common Error Messages</a>
                </div>


            </div>
            <div class="flex-1 flex overflow-hidden flex-col md:pl-10">

                <!-- accordion-tab  -->
                <div class="outline-none accordion-section mt-6" x-data="{accordion: false}">
                    <div @click="accordion = !accordion" class="flex justify-between h-20 rounded-md border border-gray-200 px-8 py-4 items-center transition cursor-pointer relative">
                        <h6 class="font-bold">Bootstrap a project</h6>
                        <svg class="transform w-5 h-5 transition-transform" :class='accordion ? "rotate-180" : "" ' xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                        </svg>
                    </div>
                    <div class="px-4" x-show="accordion" x-transition:enter="transition ease-out duration-300" x-transition:enter-start="opacity-0 transform scale-90" x-transition:enter-end="opacity-100 transform scale-100" x-transition:leave="transition ease-in duration-300" x-transition:leave-start="opacity-100 transform scale-100" x-transition:leave-end="opacity-0 transform scale-90">
                        <div class="prose mt-10 text-base max-w-full">
                            <p>
                                Help you install OCaml, the Dune build system, and support for your favourite text editor or IDE.
                            </p>

                            <p>
                                This page will help you install OCaml, the Dune build system, and support for your favourite text editor or IDE. These
                                instructions work on Windows, Unix systems like Linux, and macOS.
                            </p>

                            <p>
                                Multicore OCaml is actively being developed and core features are being upstreamed to OCaml. The multicore project at Tarides is a close collaboration with our industrial partners OCaml Labs and Segfault Systems.
                            </p>
                            <p>
                                There are two procedures: one for Unix-like systems, and one for Windows.
                            </p>
                            <strong>For Linux and macOS</strong>
                            <p>
                                We will install OCaml using opam, the OCaml package manager. We will also use opam when we wish to install third-party OCaml libraries.
                            </p>
                            <pre class="overflow-auto w-full"><code># Homebrew
brew install opam

# MacPort
port install opam
</code></pre>
                        </div>
                    </div>
                </div>
                <!-- accordion-tab -->

                <!-- accordion-tab  -->
                <div class="outline-none accordion-section mt-6" x-data="{accordion: false}">
                    <div @click="accordion = !accordion" class="flex justify-between h-20 rounded-md border border-gray-200 px-8 py-4 items-center transition cursor-pointer relative">
                        <h6 class="font-bold ">Installing dependencies</h6>

                        <svg class="transform w-5 h-5 transition-transform" :class='accordion ? "rotate-180" : "" ' xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                        </svg>
                    </div>
                    <div class="px-4" x-show="accordion" x-transition:enter="transition ease-out duration-300" x-transition:enter-start="opacity-0 transform scale-90" x-transition:enter-end="opacity-100 transform scale-100" x-transition:leave="transition ease-in duration-300" x-transition:leave-start="opacity-100 transform scale-100" x-transition:leave-end="opacity-0 transform scale-90">
                        <div class="prose mt-10 text-base max-w-full">
                            <p>
                                Help you install OCaml, the Dune build system, and support for your favourite text editor or IDE.
                            </p>

                            <p>
                                This page will help you install OCaml, the Dune build system, and support for your favourite text editor or IDE. These
                                instructions work on Windows, Unix systems like Linux, and macOS.
                            </p>

                            <p>
                                Multicore OCaml is actively being developed and core features are being upstreamed to OCaml. The multicore project at Tarides is a close collaboration with our industrial partners OCaml Labs and Segfault Systems.
                            </p>
                            <p>
                                There are two procedures: one for Unix-like systems, and one for Windows.
                            </p>
                            <strong>For Linux and macOS</strong>
                            <p>
                                We will install OCaml using opam, the OCaml package manager. We will also use opam when we wish to install third-party OCaml libraries.
                            </p>
                            <pre class="overflow-auto w-full"><code># Homebrew
brew install opam

# MacPort
port install opam
</code></pre>
                        </div>
                    </div>
                </div>
                <!-- accordion-tab -->


                <!-- accordion-tab  -->
                <div class="outline-none accordion-section mt-6" x-data="{accordion: false}">
                    <div @click="accordion = !accordion" class="flex justify-between h-20 rounded-md border border-gray-200 px-8 py-4 items-center transition cursor-pointer relative">
                        <h6 class="font-bold">Updating development dependencies</h6>
                        <svg class="transform w-5 h-5 transition-transform" :class='accordion ? "rotate-180" : "" ' xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                        </svg>
                    </div>
                    <div class=" px-4 " x-show="accordion" x-transition:enter="transition ease-out duration-300" x-transition:enter-start="opacity-0 transform scale-90" x-transition:enter-end="opacity-100 transform scale-100" x-transition:leave="transition ease-in duration-300" x-transition:leave-start="opacity-100 transform scale-100" x-transition:leave-end="opacity-0 transform scale-90">
                        <div class="prose mt-10 text-base max-w-full">
                            <div class="prose mt-10 text-base max-w-full">
                                <p>
                                    Help you install OCaml, the Dune build system, and support for your favourite text editor or IDE.
                                </p>

                                <p>
                                    This page will help you install OCaml, the Dune build system, and support for your favourite text editor or IDE. These
                                    instructions work on Windows, Unix systems like Linux, and macOS.
                                </p>

                                <p>
                                    Multicore OCaml is actively being developed and core features are being upstreamed to OCaml. The multicore project at Tarides is a close collaboration with our industrial partners OCaml Labs and Segfault Systems.
                                </p>
                                <p>
                                    There are two procedures: one for Unix-like systems, and one for Windows.
                                </p>
                                <strong>For Linux and macOS</strong>
                                <p>
                                    We will install OCaml using opam, the OCaml package manager. We will also use opam when we wish to install third-party OCaml libraries.
                                </p>
                                <pre class="overflow-auto w-full"><code># Homebrew
brew install opam

# MacPort
port install opam
</code></pre>
                            </div>
                        </div>
                    </div>
                    <!-- accordion-tab -->
                </div>
            </div>
        </div>
    </div>
</div>
<?php
include 'footer.php';
?>
