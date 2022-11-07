(lang dune 3.5)
(generate_opam_files true)

(maintainers "Antonin Décimo <antonin@tarides.com>")
(authors "Antonin Décimo <antonin@tarides.com>")
(source (github MisterDA/ppx_pos_of))
(license MIT)

(package
 (name ppx_pos_of)
 (synopsis "PPX allowing expressions to refer to their own position")
 (depends
  ppxlib))

(package
 (name ppx_alcotest)
 (synopsis "PPX setting accurate position for Alcotest check")
 (depends
  ppxlib
  (alcotest :with-test)
  (ppx_here :with-test)
  (ppx_pos_of (and (= :version) :with-test))))
