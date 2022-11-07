# `ppx_pos_of` / `ppx_alcotest`

OCaml Stdlib has:

``` ocaml
val __POS__ : string * int * int * int
(** [__POS__] returns a tuple [(file,lnum,cnum,enum)], corresponding to the
 location at which this expression appears in the file currently being parsed by
 the compiler. [file] is the current filename, [lnum] the line number, [cnum]
 the character position in the line and [enum] the last character position in
 the line. *)
```

and

``` ocaml
val __POS_OF__ : 'a -> (string * int * int * int) * 'a
(** [__POS_OF__ expr] returns a pair [(loc,expr)], where [loc] is a tuple
 [(file,lnum,cnum,enum)] corresponding to the location at which the expression
 [expr] appears in the file currently being parsed by the compiler. [file] is
 the current filename, [lnum] the line number, [cnum] the character position in
 the line and [enum] the last character position in the line.
```

but what I'd really want is the ability for an expression to refer to its own
position, something such as:

``` ocaml
val __POS_OF_F__ : ((string * int * int * int) -> 'a) -> 'a
(** [__POS_OF_F__ f] returns [f loc], where [loc] is a tuple
 [(file,lnum,cnum,enum)] corresponding to the location at which the expression
 [f] appears in the file currently being parsed by the compiler. [file] is
 the current filename, [lnum] the line number, [cnum] the character position in
 the line and [enum] the last character position in the line.
```

This gives, with the help of a PPX:

``` ocaml
let f ~pos () =
  let file, lnum, cnum, enum = pos in
  Printf.printf "File %S, line %d, characters %d-%d\n" file lnum cnum enum

let () = [%pos_of f] ()
```

See [example.ml](./example.ml), and [alcotest.ml](./alcotest.ml) for a possible
adaptation of the idea to [Alcotest](https://github.com/mirage/alcotest).

Comparing with Alcotest and [`ppx_here`](https://github.com/janestreet/ppx_here):

``` ocaml
(* ppx_pos_of *)
let test_capitalise () =
  To_test.capitalise "b" |> Alcotest.([%pos_of check] string) "strings" "A"
(* ASSERT strings
   File "alcotest.ml", line 8, character 38:
   FAIL strings *)

(* ppx_alcotest *)
let test_capitalise () =
  To_test.capitalise "b" |> Alcotest.([%check] string) "strings" "A"
(* ASSERT strings
   File "alcotest.ml", line 12, character 38:
   FAIL strings *)

(* ppx_here *)
let test_capitalise () =
  To_test.capitalise "b" |> Alcotest.(check ~here:[%here] string) "strings" "A"
(* ASSERT strings
   File "alcotest.ml", line 16, character 50:
   FAIL strings *)

(* Stdlib.__POS__ *)
let test_capitalise () =
  To_test.capitalise "b" |> Alcotest.(check ~pos:__POS__ string) "strings" "A"
(* ASSERT strings
   File "alcotest.ml", line 20, character 49:
   FAIL strings *)
```
