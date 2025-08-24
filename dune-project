(lang dune 3.7)
(name mach)
(generate_opam_files true)

(license BSD-3-Clause)
(maintainers "Tim McGilchrist <timmcgil@gmail.com>")
(authors "Tim McGilchrist <timmcgil@gmail.com>")
(source (github tmcgilchrist/mach))

(package
 (name mach)
 (tags (bindings macos mach))
 (synopsis "OCaml interface to Mach 3.0 kernel in macOS")
 (description "An OCaml interface to the user-space API of the Mach 3.0 kernel that underlies macOS.")
 (depends
   (ocaml (>= 4.14))
  (ctypes-foreign (>= 0.23.0))

   ; Development dependencies
  (ocamlformat (and :with-dev-setup (= 0.27.0)))))