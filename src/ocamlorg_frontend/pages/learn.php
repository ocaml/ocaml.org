<?php
include 'header.php';
?>
<button class="bg-primary-600  p-3 z-30 rounded-r-xl text-white shadow-md top-2/4 fixed md:hidden" :class="sidebar ? 'pl-1 pr-2': ''" x-on:click="sidebar = ! sidebar">
    <div class="transform transition-transform" :class='sidebar ? "" : "rotate-180" '>
        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 17l-5-5m0 0l5-5m-5 5h12" />
        </svg>
    </div>
</button>
<div class="lg:py-24 bg-white pt-10 md:pt-16">

    <div class="container-fluid wide">
        <div class="flex">
            <div class="p-10 z-10 w-full bg-white flex-shrink-0 flex-col absolute md:flex left-0 top-0 md:relative md:w-72 md:p-0 h-screen overflow-auto" x-show="sidebar" x-transition:enter="transition duration-200 transform ease-out" x-transition:enter-start="-translate-x-full" x-transition:leave="transition duration-100 transform ease-in" x-transition:leave-end="-translate-x-full">
                <div class="flex justify-start items-center">
                    <div class="bg-primary-600 text-white rounded w-8 h-8 flex items-center justify-center">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
                        </svg>
                    </div>
                    <div class="ml-2 font-semibold text-primary-600">Learn</div>
                </div>
                <div class="space-y-2 flex mt-10 flex-col">
                    <div class="text-sm font-semibold flex px-3 py-2">GETTING STARTED</div>
                    <a class="flex text-primary-600 bg-primary-100 py-2 px-3 rounded-md text-sm font-semibold" href="">Up and Running with OCaml</a>
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
            <div class="flex-1 flex flex-col md:pl-10">
                <h1 class="font-bold  mb-10 md:mb-16">Learn</h1>
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-8 border-b border-gray-200 pb-10 lg:pb-20">
                    <div class="relative flex-1 bg-gradient-to-br from-orange-300 to-orange-500 rounded-xl text-white">
                        <div class="p-8">
                            <h6 class="font-bold mb-2">Get Started</h6>
                            <div class="font-medium mb-4 opacity-80">Learn how to get Tailwind set up in your project.</div>
                            <a href="getting-started.php"><button class=" bg-black font-semibold h-12 px-5 rounded-md bg-opacity-10 hover:bg-opacity-20 transition-colors">Start now</button></a>
                        </div>
                        <div class="flex justify-end pl-8"><img src="img/learn/learn-get-staretd.svg" class="w-full" alt=""></div>
                    </div>

                    <div class="relative flex-1 bg-gradient-to-br from-purple-400 to-purple-700 rounded-xl text-white">
                        <div class="p-8">
                            <h6 class="font-bold mb-2">Learn with Exercises</h6>
                            <div class="font-medium mb-4 opacity-80">Learning by doing, or do by <br> learning!</div>
                            <a href="#"><button class=" bg-black font-semibold h-12 px-5 rounded-md bg-opacity-10 hover:bg-opacity-20 transition-colors">I'm ready</button></a>
                        </div>
                        <div class="flex justify-end pl-8"><img src="img/learn/learn-exercise.svg" class="w-full" alt=""></div>
                    </div>

                    <div class="relative flex-1 bg-gradient-to-br from-emerald-400 to-emerald-700 rounded-xl text-white">
                        <div class="p-8">
                            <h6 class="font-bold mb-2">Language Manual</h6>
                            <div class="font-medium mb-4 opacity-80">Read the language manual to get a deeper understanding!</div>
                            <a href="manual.php"><button class=" bg-black font-semibold h-12 px-5 rounded-md bg-opacity-10 hover:bg-opacity-20 transition-colors">Take me there</button></a>
                        </div>
                        <div class="flex justify-end pl-8"><img src="img/learn/learn-language.svg" class="w-full" alt=""></div>
                    </div>
                </div>
                <div class="mt-10 lg:mt-20">
                    <h3 class="font-bold">Developer Guides</h3>
                    <div class="mt-6 text-body-400 text-lg">Pharetra mattis maecenas imperdiet eget nam maecenas egestas. Sed mi, pellentesque ornare diam eget aliquet. Lacus mauris turpis neque interdum et mauris, fermentum in. Scelerisque consectetur.</div>
                    <div class="flex flex-col lg:flex-row space-y-5 lg:space-y-0 lg:space-x-5 mt-8 border-b border-gray-200 pb-10 lg:pb-20">
                        <a href="" class="card-hover flex-1 p-4 lg:py-9 lg:px-8 border border-gray-200 rounded-xl">
                            <img src="img/home/mirageOS.png" alt="">
                            <div class="font-semibold text-xl mt-2 lg:mt-8 mb-3">Mirage OS</div>
                            <div>Mirage OS Unikernels lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer at tristique odio. Etiam sodales porta lectus ac malesuada. Proin in odio ultricies, faucibus ligula ut</div>
                        </a>
                        <a href="" class="card-hover flex-1 p-4 lg:py-9 lg:px-8 border border-gray-200 rounded-xl">
                            <img src="img/home/JS.png" alt="">
                            <div class="font-semibold text-xl mt-2 lg:mt-8 mb-3">JS_of_OCaml</div>
                            <div>Browser programming dolor sit amet, consectetur adipiscing elit. Integer at tristique odio. Etiam sodales porta lectus ac maleuada. Proin in odio ultricies, faucibus ligula ut</div>
                        </a>
                    </div>
                </div>
                <div class="mt-10 lg:mt-20 border-b border-gray-200 pb-10 lg:pb-20">
                    <h3 class="font-bold">Papers</h3>
                    <div class="mt-6 text-body-400 text-lg">Aspiring towards greater understanding of the language? Want to push the limits and discover brand new things? Check out papers written by leading OCaml researchers:</div>
                    <div class="flex flex-col lg:flex-row mt-8 space-y-4 lg:space-y-0 lg:space-x-6">
                        <a href="" class="card-hover flex-1 p-6 border border-gray-200 rounded-xl">
                            <div class="font-semibold text-base mb-3">A Syntactic Approach to Type...</div>
                            <div>This paper describes the semantics and the type system of Core ML, and uses a simple syntactic technique to prove that well-typed programs....</div>
                            <div class="font-bold text-sm mt-3">Florencio Dorrance</div>
                            <div class="flex mt-5 space-x-2">
                                <div class=" text-blue-500 py-1 px-3 border border-blue-500 rounded-3xl">Core</div>
                                <div class="text-blue-500 py-1 px-3 border border-blue-500 rounded-3xl">Languages</div>
                            </div>
                        </a>
                        <a href="" class="card-hover flex-1 p-6 border border-gray-200 rounded-xl">
                            <div class="font-semibold text-base mb-3">The Essence of ML Type Inf...</div>
                            <div>This book chapter gives an in-depth abstract of the Core ML type system, with an emphasis on type inference. The type inference algorithm is...</div>
                            <div class="font-bold text-sm mt-3">Elmer Laverty</div>
                            <div class="flex mt-5 space-x-2">
                                <div class=" text-blue-500 py-1 px-3 border border-blue-500 rounded-3xl">Core</div>
                                <div class="text-blue-500 py-1 px-3 border border-blue-500 rounded-3xl">Languages</div>
                            </div>
                        </a>
                        <a href="" class="card-hover flex-1 p-6 border border-gray-200 rounded-xl">
                            <div class="font-semibold text-base mb-3">Relaxing the value restriction</div>
                            <div>This paper explains why it is sound to generalize certain type variables at a `let` binding, even when the expression that is being `let`-bou....</div>
                            <div class="font-bold text-sm mt-3">Daryl Nehls</div>
                            <div class="flex mt-5 space-x-2">
                                <div class=" text-blue-500 py-1 px-3 border border-blue-500 rounded-3xl">Core</div>
                                <div class="text-blue-500 py-1 px-3 border border-blue-500 rounded-3xl">Languages</div>
                            </div>
                        </a>

                    </div>
                    <a href="papers.php"><button class="btn btn-lg btn-secondary mt-8">
                            <span>View all papers</span>
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                            </svg>
                        </button></a>
                </div>
                <div class="mt-10 lg:mt-20 border-b border-gray-200 pb-10 lg:pb-20">
                    <h3 class="font-bold">Releases</h3>
                    <div class="mt-6 text-body-400 text-lg">Pharetra mattis maecenas imperdiet eget nam maecenas egestas. Sed mi, pellentesque ornare diam eget aliquet. Lacus mauris turpis neque interdum et mauris, fermentum in. Scelerisque consectetur.</div>
                    <a href="releases-inner.php">
                        <div class="bg-pattern p-6 mt-8 rounded-xl w-full lg:w-2/3 text-white">
                            <div class="text-primary-600 text-sm mb-4">RECENT RELEASE</div>
                            <h3 class="font-bold mb-6">4.12.0 <span class="text-sm font-medium">(2021-02-24)</span></h3>
                            <ul class="font-medium list-disc px-5 text-sm space-y-5">
                                <li>
                                    Major progress in reducing the difference between the mainline and multicore runtime
                                </li>
                                <li>
                                    A new configuration option ocaml-option-nnpchecker which emits an alarm when the garbage collector finds out-of-heap pointers that could cause a crash in the multicore runtime
                                </li>
                                <li>
                                    Support for macOS/arm64
                                </li>
                                <li>
                                    and many more...
                                </li>
                            </ul>
                        </div>
                    </a>
                    <a href="releases.php"><button class="btn btn-lg btn-secondary mt-8"><span>See all Releases</span> <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                            </svg></button></a>
                </div>
                <div class="mt-10 lg:mt-20">
                    <h3 class="font-bold">Recommended Books</h3>
                    <div class="mt-6 text-body-400 mb-12 text-lg">Varius orci neque mi tincidunt porttitor tellus nisl. Dignissim aliquam suspendisse posuere odio aenean metus. Tortor, vel integer arcu ipsum. Tincidunt elementum cras libero varius. Aliquam id.</div>
                    <div class="grid grid-cols-1 lg:grid-cols-3 gap-20">
                        <a href="" class="flex-1 card-hover">
                            <img src="img/learn/learn-book1-preview.png" class="rounded-2xl lg:w-full border border-gray-200" alt="">
                            <div class="font-semibold mt-6 mb-3">Apprendre à programmer avec OCam</div>
                            <div class="flex space-x-1 mb-6 text-primary-600">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" viewBox="0 0 20 20" fill="currentColor">
                                    <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                                </svg>
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" viewBox="0 0 20 20" fill="currentColor">
                                    <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                                </svg>
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" viewBox="0 0 20 20" fill="currentColor">
                                    <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                                </svg>
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" viewBox="0 0 20 20" fill="currentColor">
                                    <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                                </svg>
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" viewBox="0 0 20 20" fill="currentColor">
                                    <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                                </svg>
                            </div>
                        </a>
                        <a href="" class="flex-1 card-hover">
                            <img src="img/learn/learn-book2-preview.png" class="rounded-2xl lg:w-full border border-gray-200" alt="">
                            <div class="font-semibold mt-6 mb-3">Apprendre à programmer avec OCam</div>
                            <div class="flex space-x-1 mb-6 text-primary-600">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" viewBox="0 0 20 20" fill="currentColor">
                                    <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                                </svg>
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" viewBox="0 0 20 20" fill="currentColor">
                                    <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                                </svg>
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" viewBox="0 0 20 20" fill="currentColor">
                                    <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                                </svg>
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" viewBox="0 0 20 20" fill="currentColor">
                                    <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                                </svg>
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" viewBox="0 0 20 20" fill="currentColor">
                                    <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                                </svg>
                            </div>
                        </a>
                        <a href="" class="flex-1 card-hover">
                            <img src="img/learn/learn-book3-preview.png" class="rounded-2xl lg:w-full border border-gray-200" alt="">
                            <div class="font-semibold mt-6 mb-3">Apprendre à programmer avec OCam</div>
                            <div class="flex space-x-1 mb-6 text-primary-600">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" viewBox="0 0 20 20" fill="currentColor">
                                    <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                                </svg>
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" viewBox="0 0 20 20" fill="currentColor">
                                    <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                                </svg>
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" viewBox="0 0 20 20" fill="currentColor">
                                    <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                                </svg>
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" viewBox="0 0 20 20" fill="currentColor">
                                    <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                                </svg>
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" viewBox="0 0 20 20" fill="currentColor">
                                    <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                                </svg>
                            </div>
                        </a>

                    </div>
                    <a href="books.php"><button class="btn btn-lg btn-secondary mt-12"><span>See all Books</span> <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                            </svg></button></a>
                </div>
            </div>
        </div>
    </div>
</div>
<?php
include 'footer.php';
?>
