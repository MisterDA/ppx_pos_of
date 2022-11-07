module To_test = struct
  let capitalise = String.uppercase_ascii
  let double_all = List.map (fun a -> a + a)
end

(* ppx_pos_of *)
let test_capitalise_pos_of () =
  To_test.capitalise "b" |> Alcotest.([%pos_of check] string) "strings" "A"

(* ppx_alcotest *)
let test_capitalise_alcotest () =
  To_test.capitalise "b" |> Alcotest.([%check] string) "strings" "A"

(* ppx_here *)
let test_capitalise_here () =
  To_test.capitalise "b" |> Alcotest.(check ~here:[%here] string) "strings" "A"

(* Stdlib.__POS__ *)
let test_capitalise_pos () =
  To_test.capitalise "b" |> Alcotest.(check ~pos:__POS__ string) "strings" "A"

let test_double_all () =
  To_test.double_all [ 1; 1; 2; 3 ]
  |> Alcotest.([%check] (list int)) "int lists" [ 1 ]

let suite1 =
  [
    ( "to_test",
      [
        ("capitalise pos_of", `Quick, test_capitalise_pos_of);
        ("capitalise alcotest", `Quick, test_capitalise_alcotest);
        ("capitalise here", `Quick, test_capitalise_here);
        ("capitalise pos", `Quick, test_capitalise_pos);
        ("double all", `Slow, test_double_all);
      ] );
  ]

let suite2 =
  [
    ( "Ωèone",
      [
        ("Passing test 1", `Quick, fun () -> ());
        ( "Failing test",
          `Quick,
          fun () -> Alcotest.fail "This was never going to work..." );
        ("Passing test 2", `Quick, fun () -> ());
      ] );
  ]

(* Run both suites completely, even if the first contains failures *)
let () =
  try Alcotest.run ~and_exit:false "First suite" suite1
  with Alcotest.Test_error ->
    Printf.printf "Forging ahead regardless!\n%!";
    Alcotest.run ~and_exit:false "Second suite" suite2;
    Printf.printf "Finally done."
