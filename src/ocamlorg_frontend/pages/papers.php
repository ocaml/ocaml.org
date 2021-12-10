<?php
include 'header.php';
?>

<div class="intro-section-simple">
    <div class="container-fluid">
        <div class="text-center w-full lg:w-2/3 m-auto">
            <h1 class="font-bold mb-6">Papers</h1>
            <p>Eget nibh diam eget velit quisque. Nec ac amet, nunc egestas felis ut. Cras leo amet donec facilisis.
                Bibendum nisl viverra lorem viverra. Gravida quam posuere parturient varius.</p>
        </div>
    </div>
</div>
<div class="bg-pattern lg:py-32 py-20 ">
    <div class="container-fluid">
        <div class=" ">
            <div class="text-center">
                <h2 class="font-bold text-primary-600 mb-16">Recommended Papers</h2>
            </div>
            <div class="flex flex-col lg:flex-row mt-8 space-y-4 lg:space-y-0 lg:space-x-12">
                
                    <a href="" class="flex-1 p-6 border border-gray-200 rounded-xl bg-white card-hover">
                        <div class="font-semibold text-base mb-3">
                            Extending OCaml&#x27;s &#x27;open&#x27;
                        </div>
                        <div class="truncate">
                            The language Eff is an OCaml-like language serving as a prototype implementation of the theory of algebraic effects, intended for experimentation with algebraic effects on a large scale. We present the embedding of Eff into OCaml, using the library of delimited continuations or the multicore OCaml branch. We demonstrate the correctness of the embedding denotationally, relying on the tagless-final-style interpreter-based denotational semantics, including the novel, direct denotational semantics of multi-prompt delimited control. The embedding is systematic, lightweight, performant and supports even higher-order, &#x27;dynamic&#x27; effects with their polymorphism. OCaml thus may be regarded as another implementation of Eff, broadening the scope and appeal of that language.

                        </div>
                        <div class="font-bold text-sm mt-3">
                            Oleg Kiselyov, KC Sivaramakrishnan
                        </div>
                        <div class="flex mt-5 space-x-2">
                            
                                <div
                                    class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                    ocaml-workshop
                                </div>
                                
                                <div
                                    class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                    core
                                </div>
                                
                                <div
                                    class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                    language
                                </div>
                                
                        </div>
                    </a>
                    
                    <a href="" class="flex-1 p-6 border border-gray-200 rounded-xl bg-white card-hover">
                        <div class="font-semibold text-base mb-3">
                            A memory model for multicore OCaml
                        </div>
                        <div class="truncate">
                            We propose a memory model for OCaml, broadly following the design of axiomatic memory models for languages such as C++ and Java, but with a number of differences to provide stronger guarantees and easier reasoning to the programmer, at the expense of not admitting every possible optimisation.

                        </div>
                        <div class="font-bold text-sm mt-3">
                            Stephen Dolan, KC Sivaramakrishnan
                        </div>
                        <div class="flex mt-5 space-x-2">
                            
                                <div
                                    class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                    ocaml-workshop
                                </div>
                                
                                <div
                                    class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                    multicore
                                </div>
                                
                        </div>
                    </a>
                    
                    <a href="" class="flex-1 p-6 border border-gray-200 rounded-xl bg-white card-hover">
                        <div class="font-semibold text-base mb-3">
                            Extending OCaml&#x27;s &#x27;open&#x27;
                        </div>
                        <div class="truncate">
                            We propose a harmonious extension of OCaml&#x27;s &#x27;open&#x27; construct. OCaml&#x27;s existing construct &#x27;open M&#x27; imports the names exported by the module &#x27;M&#x27; into the current scope. At present &#x27;M&#x27; is required to be the path to a module. We propose extending &#x27;open&#x27; to instead accept an arbitrary module expression, making it possible to succinctly address a number of existing scope-related difficulties that arise when writing OCaml programs.

                        </div>
                        <div class="font-bold text-sm mt-3">
                            Runhang Li, Jeremy Yallop
                        </div>
                        <div class="flex mt-5 space-x-2">
                            
                                <div
                                    class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                    ocaml-workshop
                                </div>
                                
                                <div
                                    class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                    core
                                </div>
                                
                                <div
                                    class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                    language
                                </div>
                                
                        </div>
                    </a>
                    
            </div>
        </div>
    </div>
</div>
<div class="bg-white">
    <div class="py-10 lg:py-28">
        <div class="container-fluid">
            <div class="flex justify-between items-center flex-col md:flex-row">
                
                <h5 class="font-bold mb-5 md:mb-0">39 Papers</h5>
                <form action="/papers" method="GET" class="form-input">
                    <div class="form-input__icon">
                        <svg xmlns="http://www.w3.org/2000/svg" class="-mt-1 h-5 w-5 text-body-400" fill="none"
                            viewBox="0 0 24 24" stroke="rgba(26, 32, 44, 1)">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                        </svg>
                    </div>
                    <label for="q" class="sr-only">Papers</label>
                    <input id="q" name="q" type="search" placeholder="Search for an paper" value="">
                </form>
            </div>
            <div class="overflow-x-scroll lg:overflow-hidden mt-5 lg:mt-10">
                
                <table class="max-w-5xl lg:max-w-full align-top">
                    <thead class="bg-body-700 text-white text-left rounded-xl">
                        <tr>
                            <th class="py-4 px-6 rounded-l-lg text-x w-2/5">Title</th>
                            <th class="py-4 px-6">Years</th>
                            <th class="py-4 px-6 ">Tags</th>
                            <th class="py-4 px-6 w-2/5">Authors</th>
                            <th class="py-4 px-6  rounded-r-lg">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        
                            <tr>
                                <td class="py-4 px-6 font-semibold">
                                    <div class="font-semibold">
                                        The ZINC experiment, an Economical Implementation of the ML language
                                    </div>
                                    <div class="font-normal">
                                        This report contains a abstract of the ZINC compiler, which later evolved into Caml Light, then into OCaml. Large parts  of this report are out of date, but it is still valuable as a abstract of the abstract machine used in Caml Light and  (with some further simplifications and speed improvements) in OCaml.

                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    1990
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    <div class="flex space-x-2">
                                        
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                compiler
                                            </div>
                                            
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                runtime
                                            </div>
                                            
                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    Xavier Leroy
                                </td>
                                <td class="py-4 px-6 align-top">
                                    
                                        <a href="https://caml.inria.fr/pub/papers/xleroy-zinc.pdf" class="text-primary-600 font-medium block">
                                            Download PDF
                                        </a>
                                        
                                        <a href="https://caml.inria.fr/pub/papers/xleroy-zinc.ps.gz" class="text-primary-600 font-medium block">
                                            Download PostScript
                                        </a>
                                        
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="py-4 px-6 font-semibold">
                                    <div class="font-semibold">
                                        A Concurrent, Generational Garbage Collector for a Multithreaded Implementation of ML
                                    </div>
                                    <div class="font-normal">
                                        Superseded by &quot;Portable, Unobtrusive Garbage Collection for Multiprocessor Systems&quot;

                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    1993
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    <div class="flex space-x-2">
                                        
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                garbage collection
                                            </div>
                                            
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                runtime
                                            </div>
                                            
                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    Damien Doligez, Xavier Leroy
                                </td>
                                <td class="py-4 px-6 align-top">
                                    
                                        <a href="https://caml.inria.fr/pub/papers/doligez_xleroy-concurrent_gc-popl93.pdf" class="text-primary-600 font-medium block">
                                            Download PDF
                                        </a>
                                        
                                        <a href="https://caml.inria.fr/pub/papers/doligez_xleroy-concurrent_gc-popl93.ps.gz" class="text-primary-600 font-medium block">
                                            Download PostScript
                                        </a>
                                        
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="py-4 px-6 font-semibold">
                                    <div class="font-semibold">
                                        A Syntactic Approach to Type Soundness
                                    </div>
                                    <div class="font-normal">
                                        This paper describes the semantics and the type system of Core ML,  and uses a simple syntactic technique to prove that well-typed programs cannot go wrong.

                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    1994
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    <div class="flex space-x-2">
                                        
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                core
                                            </div>
                                            
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                language
                                            </div>
                                            
                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    Andrew K. Wright, Matthias Felleisen
                                </td>
                                <td class="py-4 px-6 align-top">
                                    
                                        <a href="https://www.cs.rice.edu/CS/PLT/Publications/Scheme/ic94-wf.ps.gz" class="text-primary-600 font-medium block">
                                            Download PostScript
                                        </a>
                                        
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="py-4 px-6 font-semibold">
                                    <div class="font-semibold">
                                        Manifest Types, Modules, and Separate Compilation
                                    </div>
                                    <div class="font-normal">
                                        This paper presents a variant of the Standard ML module system that introduces a strict distinction between abstract  and manifest types. The latter are types whose definitions explicitly appear as part of a module interface. This proposal  is meant to retain most of the expressive power of the Standard ML module system, while providing much better support for  separate compilation. This work sets the formal bases for OCaml&#x27;s module system.

                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    1994
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    <div class="flex space-x-2">
                                        
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                core
                                            </div>
                                            
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                language
                                            </div>
                                            
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                modules
                                            </div>
                                            
                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    Xavier Leroy
                                </td>
                                <td class="py-4 px-6 align-top">
                                    
                                        <a href="https://caml.inria.fr/pub/papers/xleroy-manifest_types-popl94.pdf" class="text-primary-600 font-medium block">
                                            Download PDF
                                        </a>
                                        
                                        <a href="https://caml.inria.fr/pub/papers/xleroy-manifest_types-popl94.ps.gz" class="text-primary-600 font-medium block">
                                            Download PostScript
                                        </a>
                                        
                                        <a href="https://caml.inria.fr/pub/papers/xleroy-manifest_types-popl94.dvi.gz" class="text-primary-600 font-medium block">
                                            Download DVI
                                        </a>
                                        
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="py-4 px-6 font-semibold">
                                    <div class="font-semibold">
                                        Portable, Unobtrusive Garbage Collection for Multiprocessor Systems
                                    </div>
                                    <div class="font-normal">
                                        This paper describes a concurrent version of the garbage collector found in Caml Light and OCaml&#x27;s runtime system.

                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    1994
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    <div class="flex space-x-2">
                                        
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                garbage collection
                                            </div>
                                            
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                runtime
                                            </div>
                                            
                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    Damien Doligez, Georges Gonthier
                                </td>
                                <td class="py-4 px-6 align-top">
                                    
                                        <a href="https://caml.inria.fr/pub/papers/doligez_gonthier-gc-popl94.pdf" class="text-primary-600 font-medium block">
                                            Download PDF
                                        </a>
                                        
                                        <a href="https://caml.inria.fr/pub/papers/doligez_gonthier-gc-popl94.ps.gz" class="text-primary-600 font-medium block">
                                            Download PostScript
                                        </a>
                                        
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="py-4 px-6 font-semibold">
                                    <div class="font-semibold">
                                        Applicative Functors and Fully Transparent Higher-order Modules
                                    </div>
                                    <div class="font-normal">
                                        This work extends the above paper by introducing so-called applicative functors, that is, functors that produce compatible  abstract types when applied to provably equal arguments. Applicative functors are also a feature of OCaml.

                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    1995
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    <div class="flex space-x-2">
                                        
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                core
                                            </div>
                                            
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                language
                                            </div>
                                            
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                modules
                                            </div>
                                            
                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    Xavier Leroy
                                </td>
                                <td class="py-4 px-6 align-top">
                                    
                                        <a href="https://caml.inria.fr/pub/papers/xleroy-applicative_functors-popl95.pdf" class="text-primary-600 font-medium block">
                                            Download PDF
                                        </a>
                                        
                                        <a href="https://caml.inria.fr/pub/papers/xleroy-applicative_functors-popl95.ps.gz" class="text-primary-600 font-medium block">
                                            Download PostScript
                                        </a>
                                        
                                        <a href="https://caml.inria.fr/pub/papers/xleroy-applicative_functors-popl95.dvi.gz" class="text-primary-600 font-medium block">
                                            Download DVI
                                        </a>
                                        
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="py-4 px-6 font-semibold">
                                    <div class="font-semibold">
                                        Conception, réalisation et certification d&#x27;un glaneur de cellules concurrent
                                    </div>
                                    <div class="font-normal">
                                        All you ever wanted to know about the garbage collector found in Caml Light and OCaml&#x27;s runtime system.

                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    1995
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    <div class="flex space-x-2">
                                        
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                garbage collection
                                            </div>
                                            
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                runtime
                                            </div>
                                            
                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    Damien Doligez, Georges Gonthier
                                </td>
                                <td class="py-4 px-6 align-top">
                                    
                                        <a href="https://caml.inria.fr/pub/papers/doligez-these.pdf" class="text-primary-600 font-medium block">
                                            Download PDF
                                        </a>
                                        
                                        <a href="https://caml.inria.fr/pub/papers/doligez-these.ps.gz" class="text-primary-600 font-medium block">
                                            Download PostScript
                                        </a>
                                        
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="py-4 px-6 font-semibold">
                                    <div class="font-semibold">
                                        The Effectiveness of Type-based Unboxing
                                    </div>
                                    <div class="font-normal">
                                        This paper surveys and compares several data representation strategies, including the one used in the OCaml native-code compiler.

                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    1997
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    <div class="flex space-x-2">
                                        
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                compiler
                                            </div>
                                            
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                runtime
                                            </div>
                                            
                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    Xavier Leroy
                                </td>
                                <td class="py-4 px-6 align-top">
                                    
                                        <a href="https://caml.inria.fr/pub/papers/xleroy-unboxing-tic97.pdf" class="text-primary-600 font-medium block">
                                            Download PDF
                                        </a>
                                        
                                        <a href="https://caml.inria.fr/pub/papers/xleroy-unboxing-tic97.ps.gz" class="text-primary-600 font-medium block">
                                            Download PostScript
                                        </a>
                                        
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="py-4 px-6 font-semibold">
                                    <div class="font-semibold">
                                        Objective ML: An effective object-oriented extension to ML
                                    </div>
                                    <div class="font-normal">
                                        This paper provides theoretical foundations for OCaml&#x27;s object-oriented layer, including dynamic and static semantics.

                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    1998
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    <div class="flex space-x-2">
                                        
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                core
                                            </div>
                                            
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                language
                                            </div>
                                            
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                objects
                                            </div>
                                            
                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    Didier Rémy, Jérôme Vouillon
                                </td>
                                <td class="py-4 px-6 align-top">
                                    
                                        <a href="https://caml.inria.fr/pub/papers/remy_vouillon-objective_ml-tapos98.pdf" class="text-primary-600 font-medium block">
                                            Download PDF
                                        </a>
                                        
                                        <a href="https://caml.inria.fr/pub/papers/remy_vouillon-objective_ml-tapos98.ps.gz" class="text-primary-600 font-medium block">
                                            Download PostScript
                                        </a>
                                        
                                        <a href="https://caml.inria.fr/pub/papers/remy_vouillon-objective_ml-tapos98.dvi.gz" class="text-primary-600 font-medium block">
                                            Download DVI
                                        </a>
                                        
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="py-4 px-6 font-semibold">
                                    <div class="font-semibold">
                                        Programming with Polymorphic Variants
                                    </div>
                                    <div class="font-normal">
                                        This paper briefly explains what polymorphic variants are about and how they are compiled.

                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    1998
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    <div class="flex space-x-2">
                                        
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                core
                                            </div>
                                            
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                language
                                            </div>
                                            
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                polymorphic variants
                                            </div>
                                            
                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    Jacques Garrigue
                                </td>
                                <td class="py-4 px-6 align-top">
                                    
                                        <a href="https://caml.inria.fr/pub/papers/garrigue-polymorphic_variants-ml98.pdf" class="text-primary-600 font-medium block">
                                            Download PDF
                                        </a>
                                        
                                        <a href="https://caml.inria.fr/pub/papers/garrigue-polymorphic_variants-ml98.ps.gz" class="text-primary-600 font-medium block">
                                            Download PostScript
                                        </a>
                                        
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="py-4 px-6 font-semibold">
                                    <div class="font-semibold">
                                        Extending ML with Semi-Explicit Higher-Order Polymorphism
                                    </div>
                                    <div class="font-normal">
                                        This paper proposes a device for re-introducing first-class polymorphic values into ML while preserving its type inference  mechanism. This technology underlies OCaml&#x27;s polymorphic methods.

                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    1999
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    <div class="flex space-x-2">
                                        
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                core
                                            </div>
                                            
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                language
                                            </div>
                                            
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                objects
                                            </div>
                                            
                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    Jacques Garrigue, Didier Rémy
                                </td>
                                <td class="py-4 px-6 align-top">
                                    
                                        <a href="https://caml.inria.fr/pub/papers/garrigue_remy-poly-ic99.pdf" class="text-primary-600 font-medium block">
                                            Download PDF
                                        </a>
                                        
                                        <a href="https://caml.inria.fr/pub/papers/garrigue_remy-poly-ic99.ps.gz" class="text-primary-600 font-medium block">
                                            Download PostScript
                                        </a>
                                        
                                        <a href="https://caml.inria.fr/pub/papers/garrigue_remy-poly-ic99.dvi.gz" class="text-primary-600 font-medium block">
                                            Download DVI
                                        </a>
                                        
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="py-4 px-6 font-semibold">
                                    <div class="font-semibold">
                                        A Modular Module System
                                    </div>
                                    <div class="font-normal">
                                        This accessible paper describes a simplified implementation of the OCaml module system, emphasizing the fact that the module system  is largely independent of the underlying core language. This is a good tutorial to learn both how modules can be used and how  they are typechecked.

                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    2000
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    <div class="flex space-x-2">
                                        
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                core
                                            </div>
                                            
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                language
                                            </div>
                                            
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                modules
                                            </div>
                                            
                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    Xavier Leroy
                                </td>
                                <td class="py-4 px-6 align-top">
                                    
                                        <a href="https://caml.inria.fr/pub/papers/xleroy-modular_modules-jfp.pdf" class="text-primary-600 font-medium block">
                                            Download PDF
                                        </a>
                                        
                                        <a href="https://caml.inria.fr/pub/papers/xleroy-modular_modules-jfp.ps.gz" class="text-primary-600 font-medium block">
                                            Download PostScript
                                        </a>
                                        
                                        <a href="https://caml.inria.fr/pub/papers/xleroy-modular_modules-jfp.dvi.gz" class="text-primary-600 font-medium block">
                                            Download DVI
                                        </a>
                                        
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="py-4 px-6 font-semibold">
                                    <div class="font-semibold">
                                        Code Reuse through Polymorphic Variants
                                    </div>
                                    <div class="font-normal">
                                        This short paper explains how to design a modular, extensible interpreter using polymorphic variants.

                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    2000
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    <div class="flex space-x-2">
                                        
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                core
                                            </div>
                                            
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                language
                                            </div>
                                            
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                polymorphic variants
                                            </div>
                                            
                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    Jacques Garrigue
                                </td>
                                <td class="py-4 px-6 align-top">
                                    
                                        <a href="https://caml.inria.fr/pub/papers/garrigue-variant-reuse-2000.ps.gz" class="text-primary-600 font-medium block">
                                            Download PostScript
                                        </a>
                                        
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="py-4 px-6 font-semibold">
                                    <div class="font-semibold">
                                        Labeled and Optional Arguments for Objective Caml
                                    </div>
                                    <div class="font-normal">
                                        This paper offers a dynamic semantics, a static semantics, and a compilation scheme for OCaml&#x27;s labeled  and optional function parameters.

                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    2001
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    <div class="flex space-x-2">
                                        
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                core
                                            </div>
                                            
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                language
                                            </div>
                                            
                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    Jacques Garrigue
                                </td>
                                <td class="py-4 px-6 align-top">
                                    
                                        <a href="https://caml.inria.fr/pub/papers/garrigue-labels-ppl01.pdf" class="text-primary-600 font-medium block">
                                            Download PDF
                                        </a>
                                        
                                        <a href="https://caml.inria.fr/pub/papers/garrigue-labels-ppl01.ps.gz" class="text-primary-600 font-medium block">
                                            Download PostScript
                                        </a>
                                        
                                        <a href="https://caml.inria.fr/pub/papers/garrigue-labels-ppl01.dvi.gz" class="text-primary-600 font-medium block">
                                            Download DVI
                                        </a>
                                        
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="py-4 px-6 font-semibold">
                                    <div class="font-semibold">
                                        Optimizing Pattern Matching
                                    </div>
                                    <div class="font-normal">
                                        All you ever wanted to know about the garbage collector found in Caml Light and OCaml&#x27;s runtime system.

                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    2001
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    <div class="flex space-x-2">
                                        
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                pattern-matching
                                            </div>
                                            
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                runtime
                                            </div>
                                            
                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    Fabrice Le Fessant, Luc Maranget
                                </td>
                                <td class="py-4 px-6 align-top">
                                    
                                        <a href="https://dl.acm.org/citation.cfm?id=507641" class="text-primary-600 font-medium block">
                                            View Online
                                        </a>
                                        
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="py-4 px-6 font-semibold">
                                    <div class="font-semibold">
                                        Simple Type Inference for Structural Polymorphism
                                    </div>
                                    <div class="font-normal">
                                        This paper explains most of the typechecking machinery behind polymorphic variants.  At its heart is an extension of Core ML&#x27;s type discipline with so-called local constraints.

                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    2002
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    <div class="flex space-x-2">
                                        
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                core
                                            </div>
                                            
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                language
                                            </div>
                                            
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                polymorphic variants
                                            </div>
                                            
                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    Jacques Garrigue
                                </td>
                                <td class="py-4 px-6 align-top">
                                    
                                        <a href="https://caml.inria.fr/pub/papers/garrigue-structural_poly-fool02.pdf" class="text-primary-600 font-medium block">
                                            Download PDF
                                        </a>
                                        
                                        <a href="https://caml.inria.fr/pub/papers/garrigue-structural_poly-fool02.ps.gz" class="text-primary-600 font-medium block">
                                            Download PostScript
                                        </a>
                                        
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="py-4 px-6 font-semibold">
                                    <div class="font-semibold">
                                        A Proposal for Recursive Modules in Objective Caml
                                    </div>
                                    <div class="font-normal">
                                        This note describes the experimental recursive modules introduced in OCaml 3.07.

                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    2003
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    <div class="flex space-x-2">
                                        
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                core
                                            </div>
                                            
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                language
                                            </div>
                                            
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                modules
                                            </div>
                                            
                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    Xavier Leroy
                                </td>
                                <td class="py-4 px-6 align-top">
                                    
                                        <a href="https://caml.inria.fr/pub/papers/xleroy-recursive_modules-03.pdf" class="text-primary-600 font-medium block">
                                            Download PDF
                                        </a>
                                        
                                        <a href="https://caml.inria.fr/pub/papers/xleroy-recursive_modules-03.ps.gz" class="text-primary-600 font-medium block">
                                            Download PostScript
                                        </a>
                                        
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="py-4 px-6 font-semibold">
                                    <div class="font-semibold">
                                        Relaxing the value restriction
                                    </div>
                                    <div class="font-normal">
                                        This paper explains why it is sound to generalize certain type variables at a `let` binding, even when the expression that is being `let`-bound is not a value. This relaxed version of Wright&#x27;s classic “value restriction” was introduced in OCaml 3.07.

                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    2004
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    <div class="flex space-x-2">
                                        
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                core
                                            </div>
                                            
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                language
                                            </div>
                                            
                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    Jacques Garrigue
                                </td>
                                <td class="py-4 px-6 align-top">
                                    
                                        <a href="https://caml.inria.fr/pub/papers/garrigue-value_restriction-fiwflp04.pdf" class="text-primary-600 font-medium block">
                                            Download PDF
                                        </a>
                                        
                                        <a href="https://caml.inria.fr/pub/papers/garrigue-value_restriction-fiwflp04.ps.gz" class="text-primary-600 font-medium block">
                                            Download PostScript
                                        </a>
                                        
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="py-4 px-6 font-semibold">
                                    <div class="font-semibold">
                                        Typing Deep Pattern-matching in Presence of Polymorphic Variants
                                    </div>
                                    <div class="font-normal">
                                        This paper provides more details about the technical machinery behind polymorphic variants, focusing  on the rules for typechecking deep pattern matching constructs.

                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    2004
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    <div class="flex space-x-2">
                                        
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                core
                                            </div>
                                            
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                language
                                            </div>
                                            
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                polymorphic variants
                                            </div>
                                            
                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    Jacques Garrigue
                                </td>
                                <td class="py-4 px-6 align-top">
                                    
                                        <a href="https://caml.inria.fr/pub/papers/garrigue-deep-variants-2004.pdf" class="text-primary-600 font-medium block">
                                            Download PDF
                                        </a>
                                        
                                        <a href="https://caml.inria.fr/pub/papers/garrigue-deep-variants-2004.ps.gz" class="text-primary-600 font-medium block">
                                            Download PostScript
                                        </a>
                                        
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="py-4 px-6 font-semibold">
                                    <div class="font-semibold">
                                        The Essence of ML Type Inference
                                    </div>
                                    <div class="font-normal">
                                        This book chapter gives an in-depth abstract of the Core ML type system, with an emphasis on type inference.  The type inference algorithm is described as the composition of a constraint generator, which produces a system  of type equations, and a constraint solver, which is presented as a set of rewrite rules.

                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    2005
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    <div class="flex space-x-2">
                                        
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                core
                                            </div>
                                            
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                language
                                            </div>
                                            
                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    François Pottier, Didier Rémy
                                </td>
                                <td class="py-4 px-6 align-top">
                                    
                                        <a href="https://cristal.inria.fr/attapl/preversion.ps.gz" class="text-primary-600 font-medium block">
                                            Download PostScript
                                        </a>
                                        
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="py-4 px-6 font-semibold">
                                    <div class="font-semibold">
                                        Xen and the Art of OCaml
                                    </div>
                                    <div class="font-normal">
                                        In this talk, we will firstly describe the architecture of XenServer and the XenAPI and discuss the challenges faced with implementing  an Objective Caml based solution. These challenges range from the low-level concerns of interfacing with Xen and the  Linux kernel, to the high-level algorithmic problems such as distributed failure planning. In addition, we will  discuss the challenges imposed by using OCaml in a commercial environment, such as supporting product upgrades,  enhancing supportability and scaling the development team.

                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    2008
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    <div class="flex space-x-2">
                                        
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                industrial
                                            </div>
                                            
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                application
                                            </div>
                                            
                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    Anil Madhavapeddy
                                </td>
                                <td class="py-4 px-6 align-top">
                                    
                                        <a href="https://cufp.org/archive/2008/slides/MadhavapeddyAnil.pdf" class="text-primary-600 font-medium block">
                                            Download PDF
                                        </a>
                                        
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="py-4 px-6 font-semibold">
                                    <div class="font-semibold">
                                        Meta-programming Tutorial with CamlP4
                                    </div>
                                    <div class="font-normal">
                                        Meta-programming tutorial with Camlp4
                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    2010
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    <div class="flex space-x-2">
                                        
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                core
                                            </div>
                                            
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                language
                                            </div>
                                            
                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    Jake Donham
                                </td>
                                <td class="py-4 px-6 align-top">
                                    
                                        <a href="https://github.com/jaked/cufp-metaprogramming-tutorial" class="text-primary-600 font-medium block">
                                            View Online
                                        </a>
                                        
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="py-4 px-6 font-semibold">
                                    <div class="font-semibold">
                                        OCaml for the Masses
                                    </div>
                                    <div class="font-normal">
                                        Why the next language you learn should be functional.

                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    2011
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    <div class="flex space-x-2">
                                        
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                industrial
                                            </div>
                                            
                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    Yaron Minsky
                                </td>
                                <td class="py-4 px-6 align-top">
                                    
                                        <a href="https://queue.acm.org/detail.cfm?id=2038036" class="text-primary-600 font-medium block">
                                            View Online
                                        </a>
                                        
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="py-4 px-6 font-semibold">
                                    <div class="font-semibold">
                                        Extending OCaml&#x27;s &#x27;open&#x27;
                                    </div>
                                    <div class="font-normal">
                                        The language Eff is an OCaml-like language serving as a prototype implementation of the theory of algebraic effects, intended for experimentation with algebraic effects on a large scale. We present the embedding of Eff into OCaml, using the library of delimited continuations or the multicore OCaml branch. We demonstrate the correctness of the embedding denotationally, relying on the tagless-final-style interpreter-based denotational semantics, including the novel, direct denotational semantics of multi-prompt delimited control. The embedding is systematic, lightweight, performant and supports even higher-order, &#x27;dynamic&#x27; effects with their polymorphism. OCaml thus may be regarded as another implementation of Eff, broadening the scope and appeal of that language.

                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    2016
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    <div class="flex space-x-2">
                                        
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                ocaml-workshop
                                            </div>
                                            
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                core
                                            </div>
                                            
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                language
                                            </div>
                                            
                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    Oleg Kiselyov, KC Sivaramakrishnan
                                </td>
                                <td class="py-4 px-6 align-top">
                                    
                                        <a href="https://arxiv.org/pdf/1812.11664.pdf" class="text-primary-600 font-medium block">
                                            Download PDF
                                        </a>
                                        
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="py-4 px-6 font-semibold">
                                    <div class="font-semibold">
                                        A memory model for multicore OCaml
                                    </div>
                                    <div class="font-normal">
                                        We propose a memory model for OCaml, broadly following the design of axiomatic memory models for languages such as C++ and Java, but with a number of differences to provide stronger guarantees and easier reasoning to the programmer, at the expense of not admitting every possible optimisation.

                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    2017
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    <div class="flex space-x-2">
                                        
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                ocaml-workshop
                                            </div>
                                            
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                multicore
                                            </div>
                                            
                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    Stephen Dolan, KC Sivaramakrishnan
                                </td>
                                <td class="py-4 px-6 align-top">
                                    
                                        <a href="https://kcsrk.info/papers/memory_model_ocaml17.pdf" class="text-primary-600 font-medium block">
                                            Download PDF
                                        </a>
                                        
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="py-4 px-6 font-semibold">
                                    <div class="font-semibold">
                                        Chemoinformatics and Structural Bioinformatics in OCaml
                                    </div>
                                    <div class="font-normal">
                                        In this article, we share our experience in prototyping chemoinformatics and structural bioinformatics software in OCaml

                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    2019
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    <div class="flex space-x-2">
                                        
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                industrial
                                            </div>
                                            
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                application
                                            </div>
                                            
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                bioinformatics
                                            </div>
                                            
                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    François Berenger, Kam Y. J. Zhang, Yoshihiro Yamanishi
                                </td>
                                <td class="py-4 px-6 align-top">
                                    
                                        <a href="https://jcheminf.biomedcentral.com/articles/10.1186/s13321-019-0332-0" class="text-primary-600 font-medium block">
                                            View Online
                                        </a>
                                        
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="py-4 px-6 font-semibold">
                                    <div class="font-semibold">
                                        Extending OCaml&#x27;s &#x27;open&#x27;
                                    </div>
                                    <div class="font-normal">
                                        We propose a harmonious extension of OCaml&#x27;s &#x27;open&#x27; construct. OCaml&#x27;s existing construct &#x27;open M&#x27; imports the names exported by the module &#x27;M&#x27; into the current scope. At present &#x27;M&#x27; is required to be the path to a module. We propose extending &#x27;open&#x27; to instead accept an arbitrary module expression, making it possible to succinctly address a number of existing scope-related difficulties that arise when writing OCaml programs.

                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    2019
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    <div class="flex space-x-2">
                                        
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                ocaml-workshop
                                            </div>
                                            
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                core
                                            </div>
                                            
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                language
                                            </div>
                                            
                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    Runhang Li, Jeremy Yallop
                                </td>
                                <td class="py-4 px-6 align-top">
                                    
                                        <a href="https://arxiv.org/pdf/1905.06543.pdf" class="text-primary-600 font-medium block">
                                            Download PDF
                                        </a>
                                        
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="py-4 px-6 font-semibold">
                                    <div class="font-semibold">
                                        A Declarative Syntax Definition for OCaml
                                    </div>
                                    <div class="font-normal">
                                        In this talk we present our work on a syntax definition for the OCaml language in the syntax definition formalism SDF3.  SDF3 supports high-level definition of concrete and abstract syntax through declarative disambiguation and definition of  constructors, enabling a direct mapping to abstract syntax. Based on the SDF3 syntax definition, the Spoofax language  workbench produces a complete syntax aware editor with a parser, syntax checking, parse error recovery, syntax highlighting,  formatting with correct parenthesis insertion, and syntactic completion. The syntax definition should provide a good  basis for experiments with the design of OCaml and the development of further tooling. In the talk we will highlight  interesting aspects the syntax definition, discuss issues we encountered in the syntax of OCaml, and demonstrate the editor.

                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    2020
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    <div class="flex space-x-2">
                                        
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                ocaml-workshop
                                            </div>
                                            
                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    Luis Eduardo de Souza Amorim, Eelco Visser
                                </td>
                                <td class="py-4 px-6 align-top">
                                    
                                        <a href="https://eelcovisser.org/talks/2020/08/28/ocaml/" class="text-primary-600 font-medium block">
                                            View Online
                                        </a>
                                        
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="py-4 px-6 font-semibold">
                                    <div class="font-semibold">
                                        A Simple State-Machine Framework for Property-Based Testing in OCaml
                                    </div>
                                    <div class="font-normal">
                                        Since their inception state-machine frameworks have proven their worth by finding defects in everything  from the underlying AUTOSAR components of Volvo cars to digital invoicing sys- tems. These case studies were carried  out with Erlang’s commercial QuickCheck state-machine framework from Quviq, but such frameworks are now also available  for Haskell, F#, Scala, Elixir, Java, etc. We present a typed state-machine framework for OCaml based on the QCheck  library and illustrate a number concepts common to all such frameworks: state modeling, commands, interpreting commands, preconditions, and agreement checking.

                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    2020
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    <div class="flex space-x-2">
                                        
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                ocaml-workshop
                                            </div>
                                            
                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    Jan Midtgaard
                                </td>
                                <td class="py-4 px-6 align-top">
                                    
                                        <a href="https://janmidtgaard.dk/papers/Midtgaard%3AOCaml20.pdf" class="text-primary-600 font-medium block">
                                            Download PDF
                                        </a>
                                        
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="py-4 px-6 font-semibold">
                                    <div class="font-semibold">
                                        AD-OCaml: Algorithmic Differentiation for OCaml
                                    </div>
                                    <div class="font-normal">
                                        AD-OCaml is a library framework for calculating mathematically exact derivatives and  deep power series approximations of almost arbitrary OCaml programs via algorithmic  differentiation. Unlike similar frameworks, this includes programs with side effects,  aliasing, and programs with nested derivative operators. The framework also offers implicit  parallelization of both user programs and their transformations. The presentation will provide  a short introduction to the mathematical problem, the difficulties of implementing a solution,  the design of the library, and a demonstration of its capabilities.

                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    2020
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    <div class="flex space-x-2">
                                        
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                ocaml-workshop
                                            </div>
                                            
                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    Markus Mottl
                                </td>
                                <td class="py-4 px-6 align-top">
                                    
                                        <a href="https://icfp20.sigplan.org/details/ocaml-2020-papers/12/AD-OCaml-Algorithmic-Differentiation-for-OCaml" class="text-primary-600 font-medium block">
                                            View Online
                                        </a>
                                        
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="py-4 px-6 font-semibold">
                                    <div class="font-semibold">
                                        API migration: compare transformed
                                    </div>
                                    <div class="font-normal">
                                        In this talk we describe our experience in using an automatic API-migration strategy dedicated at changing  the signatures of OCaml functions, using the Rotor refactoring tool for OCaml. We perform a case study on  open source Jane Street libraries by using Rotor to refactor comparison functions so that they return a  more precise variant type rather than an integer. We discuss the difficulties of refactoring the Jane Street  code base, which makes extensive use of ppx macros, and ongoing work implementing new refactorings.

                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    2020
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    <div class="flex space-x-2">
                                        
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                ocaml-workshop
                                            </div>
                                            
                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    Joseph Harrison, Steven Varoumas, Simon Thompson, Reuben Rowe
                                </td>
                                <td class="py-4 px-6 align-top">
                                    
                                        <a href="https://icfp20.sigplan.org/details/ocaml-2020-papers/7/API-migration-compare-transformed" class="text-primary-600 font-medium block">
                                            View Online
                                        </a>
                                        
                                        <a href="https://www.cs.kent.ac.uk/people/staff/sjt/Pubs/OCaml_workshop2020.pdf" class="text-primary-600 font-medium block">
                                            Download PDF
                                        </a>
                                        
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="py-4 px-6 font-semibold">
                                    <div class="font-semibold">
                                        Irmin v2
                                    </div>
                                    <div class="font-normal">
                                        Irmin is an OCaml library for building distributed databases with the same design principles as Git.  Existing Git users will find many familiar features: branching/merging, immutable causal history for  all changes, and the ability to restore to any previous state. Irmin v2 adds new accessibility methods  to the store: we can now use Irmin from a CLI, or in a browser using irmin-graphql. It also has a new  backend, irmin-pack, which is optimised for space usage and is used by the Tezos blockchain.

                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    2020
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    <div class="flex space-x-2">
                                        
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                ocaml-workshop
                                            </div>
                                            
                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    Clément Pascutto, Ioana Cristescu, Craig Ferguson, Thomas Gazagnaire, Romain Liautaud
                                </td>
                                <td class="py-4 px-6 align-top">
                                    
                                        <a href="https://icfp20.sigplan.org/details/ocaml-2020-papers/10/Irmin-v2" class="text-primary-600 font-medium block">
                                            View Online
                                        </a>
                                        
                                        <a href="https://tarides.com/blog/2019-11-21-irmin-v2" class="text-primary-600 font-medium block">
                                            View Online
                                        </a>
                                        
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="py-4 px-6 font-semibold">
                                    <div class="font-semibold">
                                        LexiFi Runtime Types
                                    </div>
                                    <div class="font-normal">
                                        LexiFi maintains an OCaml compiler extension that enables introspection through runtime type representations.  Recently, we implemented a syntax extension (PPX) that enables the use of LexiFi runtime types on vanilla compilers.  We propose to present our publicly available runtime types and their features. Most notably, we want to present  a mechanism for pattern matching on runtime types with holes.

                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    2020
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    <div class="flex space-x-2">
                                        
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                ocaml-workshop
                                            </div>
                                            
                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    Patrik Keller, Marc Lasson
                                </td>
                                <td class="py-4 px-6 align-top">
                                    
                                        <a href="https://icfp20.sigplan.org/details/ocaml-2020-papers/9/LexiFi-Runtime-Types" class="text-primary-600 font-medium block">
                                            View Online
                                        </a>
                                        
                                        <a href="https://informationsecurity.uibk.ac.at/pdfs/KL2020_LexiFi_Runtime_Types_OCAML.pdf" class="text-primary-600 font-medium block">
                                            Download PDF
                                        </a>
                                        
                                        <a href="https://www.lexifi.com/blog/ocaml/runtime-types/" class="text-primary-600 font-medium block">
                                            View Online
                                        </a>
                                        
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="py-4 px-6 font-semibold">
                                    <div class="font-semibold">
                                        OCaml Under the Hood: SmartPy
                                    </div>
                                    <div class="font-normal">
                                        SmartPy is a complete system to develop smart-contracts for the Tezos blockchain. It is an embedded EDSL in python  to write contracts and their tests scenarios. It includes an online IDE, a chain explorer, and a command line interface.  Python is used to generate programs in an imperative, type inferred, intermediate language called SmartML. SmartML is  also the name of the OCaml library which provides an interpreter, a compiler to Michelson (the smart-contract language of Tezos),  as well as a scenario “on-chain” interpreter. The IDE uses a mix of OCaml built with js_of_ocaml and pure Javascript.  The command line interface also builds with js_of_ocaml to run on Node.js.

                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    2020
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    <div class="flex space-x-2">
                                        
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                ocaml-workshop
                                            </div>
                                            
                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    Sebastien Mondet
                                </td>
                                <td class="py-4 px-6 align-top">
                                    
                                        <a href="https://icfp20.sigplan.org/details/ocaml-2020-papers/11/OCaml-Under-The-Hood-SmartPy" class="text-primary-600 font-medium block">
                                            View Online
                                        </a>
                                        
                                        <a href="https://wr.mondet.org/paper/smartpy-ocaml-2020.pdf" class="text-primary-600 font-medium block">
                                            Download PDF
                                        </a>
                                        
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="py-4 px-6 font-semibold">
                                    <div class="font-semibold">
                                        OCaml-CI: A Zero-Configuration CI
                                    </div>
                                    <div class="font-normal">
                                        OCaml-CI is a CI service for OCaml projects. It uses metadata from the project’s opam and dune files to work out what to build,  and uses caching to make builds fast. It automatically tests projects against multiple OCaml versions and OS platforms. The CI has been deployed on around 50 projects so far on GitHub, and many of them see response times an order of magnitude quicker than  with less integrated CI solutions. This talk will introduce the CI service and then look at some of the technologies used to build it.

                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    2020
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    <div class="flex space-x-2">
                                        
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                ocaml-workshop
                                            </div>
                                            
                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    Thomas Leonard, Craig Ferguson, Kate Deplaix, Magnus Skjegstad, Anil Madhavapeddy
                                </td>
                                <td class="py-4 px-6 align-top">
                                    
                                        <a href="https://icfp20.sigplan.org/details/ocaml-2020-papers/6/OCaml-CI-A-Zero-Configuration-CI" class="text-primary-600 font-medium block">
                                            View Online
                                        </a>
                                        
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="py-4 px-6 font-semibold">
                                    <div class="font-semibold">
                                        Parallelising your OCaml Code with Multicore OCaml
                                    </div>
                                    <div class="font-normal">
                                        With the availability of multicore variants of the recent OCaml versions (4.10 and 4.11) that maintain  backwards compatibility with the existing OCaml C-API, there has been increasing interest in the wider  OCaml community for parallelising existing OCaml code.

                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    2020
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    <div class="flex space-x-2">
                                        
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                ocaml-workshop
                                            </div>
                                            
                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    Sadiq Jaffer, Sudha Parimala, KC Sivaramarkrishnan, Tom Kelly, Anil Madhavapeddy
                                </td>
                                <td class="py-4 px-6 align-top">
                                    
                                        <a href="https://github.com/ocaml-multicore/multicore-talks/blob/master/ocaml2020-workshop-parallel/multicore-ocaml20.pdf" class="text-primary-600 font-medium block">
                                            Download PDF
                                        </a>
                                        
                                        <a href="https://icfp20.sigplan.org/details/ocaml-2020-papers/5/Parallelising-your-OCaml-Code-with-Multicore-OCaml" class="text-primary-600 font-medium block">
                                            View Online
                                        </a>
                                        
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="py-4 px-6 font-semibold">
                                    <div class="font-semibold">
                                        The ImpFS Filesystem
                                    </div>
                                    <div class="font-normal">
                                        This proposal describes a presentation to be given at the OCaml’20 workshop. The presentation will cover a new OCaml filesystem,  ImpFS, and the related libraries. The filesystem makes use of a B-tree library presented at OCaml’17, and a key-value store  presented at ML’19. In addition, there are a number of other support libraries that may be of interest to the community. ImpFS  represents a single point in the filesystem design space, but we hope that the libraries we have developed will enable others to  build further filesystems with novel features.

                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    2020
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    <div class="flex space-x-2">
                                        
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                ocaml-workshop
                                            </div>
                                            
                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    Tom Ridge
                                </td>
                                <td class="py-4 px-6 align-top">
                                    
                                        <a href="https://icfp20.sigplan.org/details/ocaml-2020-papers/8/The-ImpFS-filesystem" class="text-primary-600 font-medium block">
                                            View Online
                                        </a>
                                        
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="py-4 px-6 font-semibold">
                                    <div class="font-semibold">
                                        The final pieces of the OCaml documentation puzzle
                                    </div>
                                    <div class="font-normal">
                                        Odoc is the latest attempt at creating a documentation tool which handles the full complexity of the OCaml language. It has been a long  time coming as tackling both the module system and rendering into rich documents makes for a difficult task. Nevertheless we believe  the two recent developments provides the final pieces of the OCaml documentation puzzle. This two improvements split odoc in two  layers: a model layer, with a deep understanding of the module system, and a document layer allowing for easy definition of new outputs.

                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    2020
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    <div class="flex space-x-2">
                                        
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                ocaml-workshop
                                            </div>
                                            
                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    Jonathan Ludlam, Gabriel Radanne, Leo White
                                </td>
                                <td class="py-4 px-6 align-top">
                                    
                                        <a href="https://icfp20.sigplan.org/details/ocaml-2020-papers/4/The-final-pieces-of-the-OCaml-documentation-puzzle" class="text-primary-600 font-medium block">
                                            View Online
                                        </a>
                                        
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="py-4 px-6 font-semibold">
                                    <div class="font-semibold">
                                        Types in Amber
                                    </div>
                                    <div class="font-normal">
                                        Coda is a new cryptocurrency that uses zk-SNARKs to dramatically reduce the size of data needed by nodes running its protocol. Nodes communicate  in a format automatically derived from type definitions in OCaml source files. As the Coda software evolves, these formats for sent data may change. We wish to allow nodes running older versions of the software to communicate with newer versions. To achieve that, we identify stable types that  must not change over time, so that their serializations also do not change.

                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    2020
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    <div class="flex space-x-2">
                                        
                                            <div
                                                class="text-blue-500 h-8 inline-flex items-center text-sm px-3 border border-blue-500 rounded-3xl">
                                                ocaml-workshop
                                            </div>
                                            
                                    </div>
                                </td>
                                <td class="py-4 px-6 font-medium align-top">
                                    Paul Steckler, Matthew Ryan
                                </td>
                                <td class="py-4 px-6 align-top">
                                    
                                        <a href="https://icfp20.sigplan.org/details/ocaml-2020-papers/3/Types-in-amber" class="text-primary-600 font-medium block">
                                            View Online
                                        </a>
                                        
                                </td>
                            </tr>
                            
                    </tbody>
                </table>
                
            </div>
        </div>
    </div>
</div>
    <?php
    include 'footer.php';
    ?>
