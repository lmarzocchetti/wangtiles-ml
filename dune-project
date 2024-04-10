(lang dune 3.15)

(name wangml)

(generate_opam_files true)

(source
 (github lmarzocchetti/wangml))

(authors "lmarzocchetti")

(maintainers "lmarzocchetti")

(license MIT)

(documentation https://url/to/documentation)

(package
 (name wangml)
 (synopsis "wangml")
 (description "Wang Tiles generator in ocaml")
 (depends ocaml dune imagelib)
 (tags
  (topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
