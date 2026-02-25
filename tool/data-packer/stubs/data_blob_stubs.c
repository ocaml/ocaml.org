/*
 * C stubs for accessing the embedded data blob from OCaml
 *
 * These functions provide access to the binary data embedded via
 * the .incbin directive in data_blob.S
 *
 * Supported platforms:
 *   - Linux amd64/arm64 (ELF)
 *   - macOS amd64/arm64 (Mach-O)
 */

#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/bigarray.h>
#include <caml/fail.h>
#include <stddef.h>
#include <stdint.h>

/*
 * External symbols defined in data_blob.S
 *
 * On macOS, the C compiler automatically adds underscore prefix,
 * so we reference them without underscore here.
 */
extern const unsigned char ocamlorg_data_blob[];
extern const unsigned char ocamlorg_data_blob_end[];

/*
 * Pre-computed size (also in assembly, but we compute it here too)
 */
extern const uint64_t ocamlorg_data_blob_size;

/*
 * caml_ocamlorg_data_blob_size : unit -> int
 *
 * Return the size of the embedded data blob in bytes.
 */
CAMLprim value caml_ocamlorg_data_blob_size(value unit)
{
    CAMLparam1(unit);
    ptrdiff_t size = ocamlorg_data_blob_end - ocamlorg_data_blob;

    /* Sanity check: size should match the assembly-computed value */
    if (size != (ptrdiff_t)ocamlorg_data_blob_size) {
        caml_failwith("data_blob: size mismatch between computed and stored size");
    }

    /* OCaml int is 63 bits on 64-bit systems, plenty for our data */
    if (size < 0) {
        caml_failwith("data_blob: negative size (symbol order issue?)");
    }

    CAMLreturn(Val_long(size));
}

/*
 * caml_ocamlorg_data_blob : unit -> (char, int8_unsigned_elt, c_layout) Bigarray.Array1.t
 *
 * Return a bigarray view of the embedded data blob.
 *
 * This is zero-copy - the bigarray directly references the data
 * in the binary's read-only data section.
 *
 * CAML_BA_EXTERNAL means:
 *   - OCaml won't try to free the memory
 *   - The data lives for the lifetime of the process
 *   - Perfect for embedded read-only data
 */
CAMLprim value caml_ocamlorg_data_blob(value unit)
{
    CAMLparam1(unit);
    CAMLlocal1(result);

    ptrdiff_t size = ocamlorg_data_blob_end - ocamlorg_data_blob;

    if (size <= 0) {
        caml_failwith("data_blob: invalid size");
    }

    /* Create a 1-dimensional bigarray of unsigned chars */
    intnat dims[1] = { (intnat)size };

    result = caml_ba_alloc(
        CAML_BA_UINT8 | CAML_BA_C_LAYOUT | CAML_BA_EXTERNAL,
        1,                                  /* number of dimensions */
        (void *)ocamlorg_data_blob,         /* data pointer (cast away const for API) */
        dims                                /* dimension sizes */
    );

    CAMLreturn(result);
}

/*
 * caml_ocamlorg_data_blob_ptr : unit -> nativeint
 *
 * Return the raw pointer to the data blob as a nativeint.
 * Useful for Ctypes or other FFI approaches.
 */
CAMLprim value caml_ocamlorg_data_blob_ptr(value unit)
{
    CAMLparam1(unit);
    CAMLreturn(caml_copy_nativeint((intnat)ocamlorg_data_blob));
}

/*
 * caml_ocamlorg_data_blob_check : unit -> bool
 *
 * Verify that the data blob is properly initialized.
 * Returns true if the blob appears valid, false otherwise.
 *
 * This can be used at startup to fail fast if something went wrong
 * with the embedding.
 */
CAMLprim value caml_ocamlorg_data_blob_check(value unit)
{
    CAMLparam1(unit);

    ptrdiff_t size = ocamlorg_data_blob_end - ocamlorg_data_blob;

    /* Size should be positive and reasonable (at least 1KB, less than 1GB) */
    int valid = (size >= 1024 && size <= 1024 * 1024 * 1024);

    CAMLreturn(Val_bool(valid));
}
