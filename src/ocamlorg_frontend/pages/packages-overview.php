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

<div class="bg-white" x-data="{ d1: true, d2: true, d3 : true, d4: false, d5: false, d6: false, d7:false, d8: true, d9: false, d10: false  }">
    <div class="py-10 lg:py-28">
        <div class="container-fluid">
            <div class="flex justify-between flex-col md:flex-row">
                <div class="flex flex-col">
                    <h4 class="font-bold mb-3">Dream</h4>
                    <div class="text-body-400">Tidy, feature-complete Web framework</div>
                </div>
                <div class="flex justify-between space-y-5 md:space-y-0 md:space-x-5 flex-col md:flex-row w-full md:w-auto my-6 md:my-0">
                    <div class=" h-14 w-full md:w-auto flex-col flex">
                        <label class="font-semibold mb-2">Version</label>
                        <div class="relative">
                            <select class="w-full lg:w-auto appearance-none text-body-600 border rounded-md py-3 pl-6 border-gray-200 pr-14 h-full" name="All Regions" id="">
                                <option value="USA">1.0.0-alpha2</option>
                                <option value="USA">USA</option>
                                <option value="UAE">UAE</option>
                            </select>
                            <div class="absolute h-full flex items-center pr-6 opacity-60 right-0 top-0">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                                </svg>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
            <div class="flex flex-col">
                <div class="flex mt-8 space-x-6 border-b border-gray-200">
                    <a href="packages-overview.php">
                        <button class="border-b-2 hover:border-primary-600 p-4 font-medium border-primary-600 relative text-primary-600">
                            Overview
                        </button>
                    </a>
                    <a href="package-documentation.php"><button class="border-transparent border-b-2 hover:border-primary-600 p-4 font-medium relative text-body-400">
                        Documentation
                        <span class="bg-green-500 ml-2 absolute top-2 p-1 rounded-full inline-block"></span>
                    </button></a>
                    <a href="top-level.php"><button class="border-transparent  border-b-2 hover:border-primary-600 p-4 font-medium relative text-body-400">
                        Top level
                        <span class="bg-green-500 ml-2 absolute top-2 p-1 rounded-full inline-block"></span>
                    </button></a>
                </div>
            </div>
            <div class="flex py-12 lg:space-x-14 flex-col lg:flex-row items-start">
                <div class="flex-1 prose lg:max-w-3xl">
                    <div class="p-3 bg-body-600 bg-opacity-5 rounded font-semibold mb-8">README.md</div>
                    <h5 class="font-bold">Introduction</h5>
                    <p>Dream is <strong> one flat module </strong>in <strong>one package,</strong> documented on<br /> <a href="" class="text-primary-600 no-underline hover:underline">one page</a>, but with <a href="" class="text-primary-600 hover:underline no-underline">many examples</a>. It offers:</p>
                    <p>
                    <ul class="space-y-6 py-2">
                        <li>WebSockets and GraphQL for your modern Web apps.</li>
                        <li> HTML templates with embedded OCaml or Reason — use existing skills!</li>
                        <li> Sessions with pluggable storage back ends.</li>
                        <li> Easy HTTPS and HTTP/2 support — Dream runs without a proxy.</li>
                        <li> Helpers for secure cookies and CSRF-safe forms.</li>
                        <li> Full-stack ML with clients compiled by Melange, ReScript, or js_of_ocaml.</li>
                    </ul>
                    <p>...all without sacrificing ease of use — Dream has:</p>
                    <ul class="space-y-6 py-2">
                        <li>WebSockets and GraphQL for your modern Web apps.</li>
                        <li> HTML templates with embedded OCaml or Reason — use existing skills!</li>
                        <li> Sessions with pluggable storage back ends.</li>
                        <li> Easy HTTPS and HTTP/2 support — Dream runs without a proxy.</li>
                        <li> Helpers for secure cookies and CSRF-safe forms.</li>
                        <li> Full-stack ML with clients compiled by Melange, ReScript, or js_of_ocaml.</li>
                    </ul>
                    </p>
                    <p>Every part of the API is arranged to be easy to understand, use, and remember. Dream sticks to base OCaml types like string and list, introducing only a few types of its own — and some of those are just abbreviations for bare functions!</p>

                    <p>You can even run Dream as a quite bare abstraction over its underlying set of HTTP libraries, where it acts only as minimal glue code between their slightly different interfaces.</p>
                    <p>
                        The neat interface is not a limitation. Everything is still configurable by a large number of optional arguments, and very loose coupling. Where necessary, Dream exposes the lower-level machinery that it is composed from. For example, the basic body and WebSocket readers return strings, but you can also do zero-copy streaming.</p>
                    <p>
                        And, even though Dream is presented as one package for ordinary usage, it is internally factored into several sub-libraries, according to the different dependencies of each, for fast porting to different environments.</p>
                    <p>
                        Dream is a low-level and unopinionated framework, and you can swap out its conveniences. For example, you can use TyXML with server-side JSX instead of Dream's built-in templates. You can bundle assets into a single Dream binary, or use Dream in a subcommand. Dream tries to be as functional as possible, touching global runtime state only lazily, when called into.</p>

                    <h4 class="font-bold">Quick start</h4>
                    <p>This downloads and runs quickstart.sh, which does a sandboxed build of one of the first tutorials, 2-middleware. It's mostly the same as:</p>
                    <p>
                    <pre><code>git clone https://github.com/aantron/dream.git --recursive
cd dream/example/2-middleware
npm install esy && npx esy
npx esy start</code></pre>
                    </p>
                </div>
                <div class="p-3 py-6 lg:p-8 border border-gray-200 text-sm rounded-xl lg:max-w-md w-full">
                    <div class="text-body-400 mb-3 text-base">Install</div>
                    <div class="bg-black justify-between flex rounded p-3 mb-3 text-white code-preview text-sm items-center">opam install dream.1.0.0~alpha2 <a class="hover:underline" href="">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7v8a2 2 0 002 2h6M8 7V5a2 2 0 012-2h4.586a1 1 0 01.707.293l4.414 4.414a1 1 0 01.293.707V15a2 2 0 01-2 2h-2M8 7H6a2 2 0 00-2 2v10a2 2 0 002 2h8a2 2 0 002-2v-2" />
                            </svg>
                        </a></div>
                    <a href="" class="text-primary-600 hover:underline">https://github.com/aantron/dream <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 ml-2 inline-block -mt-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
                        </svg></a>
                    <div class="flex mt-5 space-x-3">
                        <a href="" class="hover:underline px-2 py-1 text-body-400 font-medium bg-gray-100 rounded">http</a>
                        <a href="" class="px-2 py-1 text-body-400 font-medium bg-gray-100 rounded hover:underline">web</a>
                        <a href="" class="px-2 py-1 text-body-400 font-medium bg-gray-100 rounded hover:underline">framework</a>

                        <a href="" class="px-2 py-1 text-body-400 font-medium bg-gray-100 rounded hover:underline">websocket</a>

                    </div>
                    <div class="flex mt-3 space-x-3">
                        <a href="" class="px-2 py-1 text-body-400 font-medium bg-gray-100 rounded hover:underline">graphql</a>
                        <a href="" class="px-2 py-1 text-body-400 font-medium bg-gray-100 rounded hover:underline">server</a>
                        <a href="" class="px-2 py-1 text-body-400 font-medium bg-gray-100 rounded hover:underline">http2</a>
                        <a href="" class="px-2 py-1 text-body-400 font-medium bg-gray-100 rounded hover:underline">tls</a>
                    </div>
                    <div class="flex flex-col mt-9 space-y-4 text-body-400">
                        <a href="" class="flex items-center hover:text-primary-600">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-2 inline-block" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
                            </svg>
                            Readme</a>
                        <a href="" class="flex items-center hover:text-primary-600">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-2 inline-block" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                            </svg>
                            Changelog</a>
                        <a href="" class="flex items-center hover:text-primary-600">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-2 inline-block" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 6l3 1m0 0l-3 9a5.002 5.002 0 006.001 0M6 7l3 9M6 7l6-2m6 2l3-1m-3 1l-3 9a5.002 5.002 0 006.001 0M18 7l3 9m-3-9l-6-2m0-2v2m0 16V5m0 16H9m3 0h3" />
                            </svg>
                            MIT License</a>
                    </div>
                    <div class="font-semibold mt-8 mb-3 text-base text-body-400">Contributors</div>
                    <div class="flex space-x-3">
                        <a href=""><img src="img/profile-thumbnail.png" class="w-10" alt=""></a>
                        <a href=""><img src="img/profile-thumbnail.png" class="w-10" alt=""></a>
                    </div>
                    <div class="font-semibold mt-8 mb-3 text-base text-body-400">Sources</div>
                    <div class="flex p-3 rounded-xl border border-gray-200 items-center justify-between">
                        <div class="hidden md:flex"><svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 8h14M5 8a2 2 0 110-4h14a2 2 0 110 4M5 8v10a2 2 0 002 2h10a2 2 0 002-2V8m-9 4h4" />
                            </svg></div>
                        <div>dream-1.0.0-alpha2.tar.gz
                            md5=1220f17530522e488653eb9...</div>
                        <div class="hidden md:flex"><a href="" class="hover:bg-primary-600 text-primary-600 overflow-hidden hover:rounded rounded  hover:text-white">
                                <div class="p-2 bg-primary-100 text-base">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4" />
                                    </svg>
                                </div>
                            </a></div>
                    </div>
                    <div class="font-semibold mt-8 mb-3 text-base text-body-400">Dependencies</div>
                    <div class="flex flex-col space-y-3">
                        <div class="flex items-center space-x-3">
                            <a href="" class="text-primary-600 hover:underline">tyxml-ppx</a><a href="" class="px-2 py-1 font-medium text-body-400 font-medium bg-gray-100 rounded hover:underline">twith-test & >= "4.5.0"ls</a>
                        </div>
                        <div class="flex items-center space-x-3">
                            <a href="" class="text-primary-600 hover:underline">tyxml-jsx</a><a href="" class="px-2 py-1 font-medium text-body-400 font-medium bg-gray-100 rounded hover:underline">twith-test & >= "4.5.0"ls</a>
                        </div>
                        <div class="flex items-center space-x-3">
                            <a href="" class="text-primary-600 hover:underline">tyxml</a><a href="" class="px-2 py-1 font-medium text-body-400 font-medium bg-gray-100 rounded hover:underline">twith-test & >= "4.5.0"ls</a>
                        </div>
                        <div class="flex items-center space-x-3">
                            <a href="" class="text-primary-600 hover:underline">reason</a><a href="" class="px-2 py-1 font-medium text-body-400 font-medium bg-gray-100 rounded hover:underline">twith-test & >= "4.5.0"ls</a>
                        </div>
                        <div class="flex items-center space-x-3">
                            <a class="text-primary-600 hover:underline">ppx_yojson_conv</a><a href="" class="px-2 py-1 font-medium text-body-400 font-medium bg-gray-100 rounded hover:underline">twith-test & >= "4.5.0"ls</a>
                        </div>
                    </div>
                    <div class="font-semibold mt-8 mb-3 text-base text-body-400">Reverse dependencies</div>
                    <div class="flex flex-col space-y-3">
                        <div class="flex items-center space-x-3">
                            <a href="" class="hover:underline text-primary-600">tyxml-ppx</a>
                        </div>
                        <div class="flex items-center space-x-3">
                            <a href="" class="hover:underline text-primary-600">tyxml-jsx</a>
                        </div>
                        <div class="flex items-center space-x-3">
                            <a href="" class="hover:underline text-primary-600">tyxml</a>
                        </div>
                        <div class="flex items-center space-x-3">
                            <a href="" class="hover:underline text-primary-600">reason</a>
                        </div>
                        <div class="flex items-center space-x-3">
                            <a href="" class="hover:underline text-primary-600">ppx_yojson_conv</a>
                        </div>
                    </div>
                </div>
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
