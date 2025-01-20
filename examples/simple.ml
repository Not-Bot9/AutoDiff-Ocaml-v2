(* Demonstrates output of auto-differentiation compared to output of numerical estimation *)
open Variable

let f1_custom a b = (a * (a / b)) + (a + b)
let f1_float a b = (a *. (a /. b)) +. (a +. b)
let f2_custom x = x * sin (x * cos x)
let f2_float x = x *. Float.sin (x *. Float.cos x)
let a_f = 230.3
let a = make @@ Tensor.create 230.3
let b_f = 33.2
let b = make @@ Tensor.create 33.2
let x_f = 2.0
let x = make @@ Tensor.create 2.0

let auto_diff_result_f1 f =
  print_endline "Autodiff Gradient Result";
  (* Compute gradients *)
  let g_tbl = gradients f in

  (* Get the gradient of d with respect to a *)
  let grad_a = find g_tbl a and grad_b = find g_tbl b in
  match (grad_a, grad_b) with
  | dfda, dfdb ->
      (* Print the partial derivative *)
      Printf.printf "The partial derivative of y with respect to a = %f\n"
      @@ Tensor.get dfda [||];
      (* Print the partial derivative *)
      Printf.printf "The partial derivative of y with respect to b = %f\n"
      @@ Tensor.get dfdb [||]

let auto_diff_result_f2 f =
  print_endline "Autodiff Gradient Result";
  (* Compute gradients *)
  let g_tbl = gradients f in
  (* Get the gradient of d with respect to a *)
  let grad = find g_tbl x in
  Printf.printf "The partial derivative of y with respect to x = %f\n"
  @@ Tensor.get grad [||]

let numerical_estimate_result_f1 () =
  print_endline "Numerical Estimation (check the result of auto grad)";
  let delta = 0.000001 in
  let grad_a = (f1_float (a_f +. delta) b_f -. f1_float a_f b_f) /. delta in
  (* Print the partial derivative *)
  Printf.printf "The partial derivative of y with respect to a = %f\n" grad_a;
  let grad_b = (f1_float a_f (b_f +. delta) -. f1_float a_f b_f) /. delta in
  Printf.printf "The partial derivative of y with respect to b = %f\n" grad_b;
  print_endline ""

let numerical_estimate_result_f2 () =
  print_endline "Numerical Estimation (check the result of auto grad)";
  let delta = 0.000001 in
  let grad = (f2_float (x_f +. delta) -. f2_float x_f) /. delta in
  (* Print the partial derivative *)
  Printf.printf "The partial derivative of y with respect to x = %f\n" grad

let () =
  print_endline
    "****************************************************************************************";
  auto_diff_result_f1 (f1_custom a b);
  numerical_estimate_result_f1 ();
  auto_diff_result_f2 (f2_custom x);
  numerical_estimate_result_f2 ();
  print_endline
    "****************************************************************************************"
