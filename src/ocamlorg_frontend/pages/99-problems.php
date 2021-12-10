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

<div class="lg:py-24 bg-white pt-6 lg:pt-16">

    <div class="container-fluid wide">
        <div class="flex">
            <div class="p-10 z-10 w-full bg-white flex-shrink-0 flex-col fixed h-screen overflow-auto md:flex lg:overflow-hidden left-0 top-0 md:relative md:w-60 md:p-0" x-show="sidebar" x-transition:enter="transition duration-200 transform ease-out" x-transition:enter-start="-translate-x-full" x-transition:leave="transition duration-100 transform ease-in" x-transition:leave-end="-translate-x-full">
                <div class="flex justify-start items-center">
                    <div class="ml-2 font-semibold text-base text-body-600">WORKING WITH LISTS</div>
                </div>
                <div class="space-y-2 flex mt-10 flex-col">
                    <a class="flex text-primary-600 bg-primary-100 py-2 px-3 rounded-md text-sm font-semibold" href="">The core language</a>
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
            <div class="flex-1 flex overflow-hidden problems-container">
                <div class="prose prose-orange overflow-hidden z-0 z- lg:max-w-full lg:w-full mx-auto relative py-8 px-6 lg:pt-0 lg:pl-20">
                    <div x-data="{statement: true}">
                        <div class="flex space-y-4 lg:space-y-0 lg:items-center flex-col lg:flex-row lg:justify-between">
                            <h5 class="font-bold text-body-600">Tail of a list</h5>
                            <div class="flex bg-body-600 bg-opacity-5 rounded-md p-1 items-center">
                                <button class="px-3.5 h-9 font-medium flex space-x-2 items-center rounded-lg" x-on:click="statement = true" :class="statement ? 'bg-white text-primary-600': 'text-body-400' ">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                                    </svg>
                                    <span :class="statement ? 'text-body-600' : 'text-body-400'">Statement</span>
                                </button>
                                <button class="px-3.5 h-9 font-medium flex space-x-2 items-center rounded-lg" x-on:click="statement = false" :class="statement ? 'text-body-400': 'bg-white text-primary-600' ">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                                    </svg>
                                    <span :class="statement ? 'text-body-400' : 'text-body-600'">Solution</span>
                                </button>
                            </div>
                        </div>

                        <div x-show="statement">
                            <p>
                                Write a function <strong> `last : 'a list -> a option` </strong> that returns the last element of a list
                            </p>
                            <pre class="overflow-auto w-full">
                                <code>
                                        # last ["a" ; "b" ; "c" ; "d"];;
                                    - : string option = Some "d"
                                    # last [];;
                                    - : 'a option = None
                                </code>
                            </pre>
                        </div>

                        <div x-show="!statement">
                            <p>
                                Write a function <strong> </strong> that returns the last element of a list
                            </p>
                            <pre class="overflow-auto w-full"><code>
                            - : string option = Some "d"
                            # last [];;
                            - : 'a option = None</code></pre>
                        </div>
                    </div>


                    <div class="border-t border-gray-200 my-12"></div>

                    <div x-data="{statement: true}">
                        <div class="flex space-y-4 lg:space-y-0 lg:items-center flex-col lg:flex-row lg:justify-between">
                            <h5 class="font-bold text-body-600">Tail of a list</h5>
                            <div class="flex bg-body-600 bg-opacity-5 rounded-md p-1 items-center">
                                <button class="px-3.5 h-9 font-medium flex space-x-2 items-center rounded-lg" x-on:click="statement = true" :class="statement ? 'bg-white text-primary-600': 'text-body-400' ">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                                    </svg>
                                    <span :class="statement ? 'text-body-600' : 'text-body-400'">Statement</span>
                                </button>
                                <button class="px-3.5 h-9 font-medium flex space-x-2 items-center rounded-lg" x-on:click="statement = false" :class="statement ? 'text-body-400': 'bg-white text-primary-600' ">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                                    </svg>
                                    <span :class="statement ? 'text-body-400' : 'text-body-600'">Solution</span>
                                </button>
                            </div>
                        </div>

                        <div x-show="statement">
                            <p>
                                Write a function <strong> `last : 'a list -> a option` </strong> that returns the last element of a list
                            </p>
                            <pre class="overflow-auto w-full">
                                <code>
                                        # last ["a" ; "b" ; "c" ; "d"];;
                                    - : string option = Some "d"
                                    # last [];;
                                    - : 'a option = None
                                </code>
                            </pre>
                        </div>

                        <div x-show="!statement">
                            <p>
                                Write a function <strong> </strong> that returns the last element of a list
                            </p>
                            <pre class="overflow-auto w-full"><code>
                            - : string option = Some "d"
                            # last [];;
                            - : 'a option = None</code></pre>
                        </div>
                    </div>


                    <div class="border-t border-gray-200 my-12"></div>
                    <div x-data="{statement: true}">
                        <div class="flex space-y-4 lg:space-y-0 lg:items-center flex-col lg:flex-row lg:justify-between">
                            <h5 class="font-bold text-body-600">Tail of a list</h5>
                            <div class="flex bg-body-600 bg-opacity-5 rounded-md p-1 items-center">
                                <button class="px-3.5 h-9 font-medium flex space-x-2 items-center rounded-lg" x-on:click="statement = true" :class="statement ? 'bg-white text-primary-600': 'text-body-400' ">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                                    </svg>
                                    <span :class="statement ? 'text-body-600' : 'text-body-400'">Statement</span>
                                </button>
                                <button class="px-3.5 h-9 font-medium flex space-x-2 items-center rounded-lg" x-on:click="statement = false" :class="statement ? 'text-body-400': 'bg-white text-primary-600' ">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                                    </svg>
                                    <span :class="statement ? 'text-body-400' : 'text-body-600'">Solution</span>
                                </button>
                            </div>
                        </div>

                        <div x-show="statement">
                            <p>
                                Write a function <strong> `last : 'a list -> a option` </strong> that returns the last element of a list
                            </p>
                            <pre class="overflow-auto w-full">
                                <code>
                                        # last ["a" ; "b" ; "c" ; "d"];;
                                    - : string option = Some "d"
                                    # last [];;
                                    - : 'a option = None
                                </code>
                            </pre>
                        </div>

                        <div x-show="!statement">
                            <p>
                                Write a function <strong> </strong> that returns the last element of a list
                            </p>
                            <pre class="overflow-auto w-full"><code>
                            - : string option = Some "d"
                            # last [];;
                            - : 'a option = None</code></pre>
                        </div>
                    </div>

                    <div class="border-t border-gray-200 my-12"></div>

                                        <div x-data="{statement: true}">
                        <div class="flex space-y-4 lg:space-y-0 lg:items-center flex-col lg:flex-row lg:justify-between">
                            <h5 class="font-bold text-body-600">Tail of a list</h5>
                            <div class="flex bg-body-600 bg-opacity-5 rounded-md p-1 items-center">
                                <button class="px-3.5 h-9 font-medium flex space-x-2 items-center rounded-lg" x-on:click="statement = true" :class="statement ? 'bg-white text-primary-600': 'text-body-400' ">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                                    </svg>
                                    <span :class="statement ? 'text-body-600' : 'text-body-400'">Statement</span>
                                </button>
                                <button class="px-3.5 h-9 font-medium flex space-x-2 items-center rounded-lg" x-on:click="statement = false" :class="statement ? 'text-body-400': 'bg-white text-primary-600' ">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                                    </svg>
                                    <span :class="statement ? 'text-body-400' : 'text-body-600'">Solution</span>
                                </button>
                            </div>
                        </div>

                        <div x-show="statement">
                            <p>
                                Write a function <strong> `last : 'a list -> a option` </strong> that returns the last element of a list
                            </p>
                            <pre class="overflow-auto w-full">
                                <code>
                                        # last ["a" ; "b" ; "c" ; "d"];;
                                    - : string option = Some "d"
                                    # last [];;
                                    - : 'a option = None
                                </code>
                            </pre>
                        </div>

                        <div x-show="!statement">
                            <p>
                                Write a function <strong> </strong> that returns the last element of a list
                            </p>
                            <pre class="overflow-auto w-full"><code>
                            - : string option = Some "d"
                            # last [];;
                            - : 'a option = None</code></pre>
                        </div>
                    </div>


                    <div class="border-t border-gray-200 my-12"></div>


                    <div x-data="{statement: true}">
                        <div class="flex space-y-4 lg:space-y-0 lg:items-center flex-col lg:flex-row lg:justify-between">
                            <h5 class="font-bold text-body-600">Tail of a list</h5>
                            <div class="flex bg-body-600 bg-opacity-5 rounded-md p-1 items-center">
                                <button class="px-3.5 h-9 font-medium flex space-x-2 items-center rounded-lg" x-on:click="statement = true" :class="statement ? 'bg-white text-primary-600': 'text-body-400' ">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                                    </svg>
                                    <span :class="statement ? 'text-body-600' : 'text-body-400'">Statement</span>
                                </button>
                                <button class="px-3.5 h-9 font-medium flex space-x-2 items-center rounded-lg" x-on:click="statement = false" :class="statement ? 'text-body-400': 'bg-white text-primary-600' ">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                                    </svg>
                                    <span :class="statement ? 'text-body-400' : 'text-body-600'">Solution</span>
                                </button>
                            </div>
                        </div>

                        <div x-show="statement">
                            <p>
                                Write a function <strong> `last : 'a list -> a option` </strong> that returns the last element of a list
                            </p>
                            <pre class="overflow-auto w-full">
                                <code>
                                        # last ["a" ; "b" ; "c" ; "d"];;
                                    - : string option = Some "d"
                                    # last [];;
                                    - : 'a option = None
                                </code>
                            </pre>
                        </div>

                        <div x-show="!statement">
                            <p>
                                Write a function <strong> </strong> that returns the last element of a list
                            </p>
                            <pre class="overflow-auto w-full"><code>
                            - : string option = Some "d"
                            # last [];;
                            - : 'a option = None</code></pre>
                        </div>
                    </div>

                </div>

            </div>
        </div>
    </div>
</div>
<?php
include 'footer.php';
?>
