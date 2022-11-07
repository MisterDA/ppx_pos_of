open! Ppxlib

let expand ~ctxt payload =
  let loc = Expansion_context.Extension.extension_point_loc ctxt in
  let Location.{ loc_start; loc_end; _ } = loc in
  let open Ast_builder.Default in
  let file = estring ~loc loc_start.pos_fname
  and lnum = eint ~loc loc_start.pos_lnum
  and cnum = eint ~loc (loc_start.pos_cnum - loc_start.pos_bol)
  and enum = eint ~loc (loc_end.pos_cnum - loc_start.pos_bol) in
  [%expr [%e payload] ~pos:([%e file], [%e lnum], [%e cnum], [%e enum])]

let pos_of_extension =
  Extension.V3.declare "pos_of" Extension.Context.expression
    Ast_pattern.(single_expr_payload __)
    expand

let rule = Ppxlib.Context_free.Rule.extension pos_of_extension
let () = Driver.register_transformation ~rules:[ rule ] "ppx_pos_of"
