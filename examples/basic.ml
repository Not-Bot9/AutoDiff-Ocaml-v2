
open Core
open Tensor



(*This file is an example of very basic operations using our tensor module*)
let () =
  (* Create tensors *)
  let t1 = create ~dims:[| 2; 2 |] 3.0 in
  let t2 = create ~dims:[| 2; 2 |] 4.0 in

  (* Element-wise addition *)
  let t3 = t1 + t2 in
  Printf.printf "Addition result:\n";
  formatted_print t3;
  Printf.printf "\n";

  (* Element-wise multiplication *)
  let t4 = t1 * t2 in
  Printf.printf "Multiplication result:\n";
  formatted_print t4;
  Printf.printf "\n";

  (* Transpose *)
  let t5 = transpose t1 in
  Printf.printf "Transpose of first tensor:\n";
  formatted_print t5;
  Printf.printf "\n";

  (* Dot product of vectors *)
  let v1 = create ~dims:[| 3 |] 2.0 in
  let v2 = create ~dims:[| 3 |] 3.0 in
  let dot_result = dot v1 v2 in
  Printf.printf "Dot product result: %f\n" (get dot_result [||]);

  (* Matrix multiplication *)
  let mat1 = create ~dims:[| 3; 2 |] 2.0 in
  let mat2 = create ~dims:[| 2; 3 |] 3.0 in
  let matmul_result = matmul mat1 mat2 in
  Printf.printf "Matrix multiplication result:\n";
  formatted_print matmul_result;
  Printf.printf "\n";