/*
 * Assembly wrapper for embedding binary data blob
 *
 * Supported platforms:
 *   - Linux amd64 (x86_64, ELF)
 *   - Linux arm64 (aarch64, ELF)
 *   - macOS amd64 (x86_64, Mach-O)
 *   - macOS arm64 (aarch64/Apple Silicon, Mach-O)
 *
 * This file uses .incbin to embed the data.bin file directly into
 * the binary's read-only data section. The symbols are then accessible
 * from C/OCaml code.
 *
 * Platform-specific notes:
 *   - macOS/Mach-O: C symbols are prefixed with underscore by the compiler
 *   - Linux/ELF: No underscore prefix
 *   - We define both for compatibility
 */

/*
 * Detect platform and architecture
 */
#if defined(__APPLE__)
#  define MACOS 1
#else
#  define MACOS 0
#endif

#if defined(__x86_64__) || defined(_M_X64)
#  define ARCH_AMD64 1
#  define ARCH_ARM64 0
#elif defined(__aarch64__) || defined(_M_ARM64)
#  define ARCH_AMD64 0
#  define ARCH_ARM64 1
#else
#  error "Unsupported architecture: only amd64 and arm64 are supported"
#endif

/*
 * Section directive for read-only data
 */
#if MACOS
    .section __DATA,__const
#else
    .section .rodata,"a",@progbits
#endif

/*
 * Alignment: 8 bytes for 64-bit systems
 * This ensures proper alignment for bin_prot deserialization
 */
#if ARCH_ARM64
    /* ARM64 may benefit from 16-byte alignment for SIMD */
    .balign 16
#else
    .balign 8
#endif

/*
 * Export symbols (with and without underscore for cross-platform compatibility)
 */
    .global ocamlorg_data_blob
    .global _ocamlorg_data_blob
    .global ocamlorg_data_blob_end
    .global _ocamlorg_data_blob_end

/*
 * The embedded data blob
 */
ocamlorg_data_blob:
_ocamlorg_data_blob:
    /*
     * Include the binary data file.
     * The path is relative to where the assembler is invoked.
     * Dune will set this up correctly via the build rules.
     */
    .incbin "data.bin"

ocamlorg_data_blob_end:
_ocamlorg_data_blob_end:

/*
 * Size symbol (for convenience, though C code computes it from end - start)
 */
#if MACOS
    .section __DATA,__data
#else
    .section .data,"aw",@progbits
#endif

    .global ocamlorg_data_blob_size
    .global _ocamlorg_data_blob_size

    .balign 8
ocamlorg_data_blob_size:
_ocamlorg_data_blob_size:
    .quad ocamlorg_data_blob_end - ocamlorg_data_blob

/*
 * ELF-specific: Add symbol sizes for debugging
 */
#if !MACOS
    .size ocamlorg_data_blob, ocamlorg_data_blob_end - ocamlorg_data_blob
    .size ocamlorg_data_blob_size, 8
#endif

/*
 * Mark the stack as non-executable (ELF security best practice)
 */
#if !MACOS
    .section .note.GNU-stack,"",@progbits
#endif
