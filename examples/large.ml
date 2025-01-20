open Variable

(*
  ****************************************************************************************
  CPU: 13th Gen Intel(R) Core(TM) i5-13420H
  n = 1000
  Autodiff Gradient Result
  The partial derivative of y with respect to a = 69.526688
  The partial derivative of y with respect to b = -268.788361
  Execution time: 1.104119s
  **************************************************************************************** 
  *)
let n = 1000

let f a b =
  matmul a @@ (transpose (a * (a / b)) + (a + b) + (a * (a / b)) + (a + b))

(*Large variable *)
let a = random ~seed:1 [| n; n |]
let b = random ~seed:2 [| n; n |]

let time f x =
  let t = Sys.time () in
  let fx = f x in
  Printf.printf "Execution time: %fs\n" (Sys.time () -. t);
  fx

let auto_diff_result f =
  print_endline "Autodiff Gradient Result";
  (* Compute gradients *)
  let g_tbl = gradients f in

  (* Get the gradient of d with respect to a *)
  let grad_a = find g_tbl a and grad_b = find g_tbl b in
  match (grad_a, grad_b) with
  | dfda, dfdb ->
      (* Print the partial derivative *)
      Printf.printf "The partial derivative of y with respect to a = %f\n"
      @@ Tensor.get dfda [| 0; 0 |];
      (* Print the partial derivative *)
      Printf.printf "The partial derivative of y with respect to b = %f\n"
      @@ Tensor.get dfdb [| 0; 0 |]

let () =
  print_endline
    "****************************************************************************************";
  time auto_diff_result (f a b);

  print_endline
    "****************************************************************************************"
