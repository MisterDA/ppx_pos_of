let f ~pos () =
  let file, lnum, cnum, enum = pos in
  Printf.printf "File %S, line %d, characters %d-%d\n" file lnum cnum enum

let g ~pos arg0 arg1 arg2 arg3 =
  ignore arg0;
  ignore arg1;
  ignore arg2;
  ignore arg3;
  let file, lnum, cnum, enum = pos in
  Printf.printf "File %S, line %d, characters %d-%d\n" file lnum cnum enum

let () =
  [%pos_of f] ();
  [%pos_of
    g
      [ "this is an"; "extremely"; "long expression" ]
      "that needs to be broken into multiple lines" 42]
    ()
