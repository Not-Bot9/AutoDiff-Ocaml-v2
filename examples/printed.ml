(* Demonstration of the print_table function, which shows how a function is broken down into elementary compositions *)
open Core
open Variable

let f1_custom a b = (a * (a / b)) + (a + b)
let a = make @@ Tensor.create 230.3
let b = make @@ Tensor.create 33.2 

let auto_diff_result f =
  print_endline "Autodiff Gradient Result for f(a, b) = (a * (a / b)) + (a + b)";
  (* Compute gradients *)
  let g_tbl = gradients f in

  (* Get the gradient of d with respect to a *)
  let grad_a = find g_tbl a and grad_b = find g_tbl b in
  match (grad_a, grad_b) with
  | dfda, dfdb ->
      (* Print the partial derivative *)
      Printf.printf "The partial derivative of f with respect to a = %f\n"
      @@ Tensor.get dfda [||];
      (* Print the partial derivative *)
      Printf.printf "The partial derivative of f with respect to b = %f\n"
      @@ Tensor.get dfdb [||]; 
      print_table g_tbl

      
let () =
  print_endline
    "****************************************************************************************";
  print_endline 
    "This demo borrows a function shown in simple.ml, and shows the underlying hashtable used for calculations.";
  print_endline 
    "id numbers 0 and 1 correspond to variables a and b, while the rest of the hashtable is built out in order of inner elementary functions.";
  print_endline 
    "Partial derivatives are found through the local gradients associated with each variable.";
  auto_diff_result (f1_custom a b); 
  print_endline
    "****************************************************************************************"