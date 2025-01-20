open Core
open Variable
open Int

(* Neural network parameters *)
let n = 100 (* training examples *)
let d_in = 3 (* input features *)
let h = 8 (* hidden layer size *)
let d_out = 1 (* output dimension *)
let num_epochs = 100 (* epochs *)
let learning_rate = 0.01 (* learning rate *)

(* Create synthetic dataset *)
let x_data = 
  let raw = Tensor.random ~seed:42 [| n; d_in |] in
  Tensor.map (fun x -> x *. 2.0 -. 1.0) raw


let y_data = 
  let base = Tensor.sum ~axis:1 x_data in
  let base = Tensor.reshape base [| n; 1 |] in
  (* Make the targets more distinct *)
  Tensor.map (fun x -> if Float.(x > 0.0) then 0.9 else 0.1) base

let x = make x_data
let y = make y_data


let scale_factor a b = 
  let total = float_of_int (a + b) in
  2.0 /. sqrt total

let w1 = ref (make (Tensor.random ~seed:1 [| d_in; h |] 
                    |> Tensor.map (fun x -> x *. scale_factor d_in h *. 0.5)))

let w2 = ref (make (Tensor.random ~seed:2 [| h; d_out |] 
                    |> Tensor.map (fun x -> x *. scale_factor h d_out *. 0.5)))

(* Forward pass function *)
let forward x =
  let h1 = matmul x !w1 in
  let h1_act = leaky_relu ~alpha:0.2 h1 in (* increased leaky ReLU slope *)
  let out = matmul h1_act !w2 in
  sigmoid out


let calculate_accuracy y_true y_pred =
  let pred = Tensor.map (fun x -> if Float.(x > 0.5) then 0.9 else 0.1) y_pred.data in
  let correct = Tensor.map2 (fun t p -> if Float.(abs (t -. p) < 0.2) then 1.0 else 0.0) y_true.data pred in
  let acc = Tensor.sum correct in
  let n_float = float_of_int n in
  Tensor.get acc [||] /. n_float

let () =
  Printf.printf "Training Neural Network\n";
  Printf.printf "Dataset size: %d examples with %d features\n" n d_in;
  Printf.printf "Network architecture: %d -> %d -> %d\n" d_in h d_out;
  Printf.printf "Training for %d epochs with learning rate %f\n\n" num_epochs learning_rate;
  

  for epoch = 1 to num_epochs do
    (* Forward pass *)
    let y_pred = forward x in
    let loss = binary_cross_entropy y y_pred in
    let accuracy = calculate_accuracy y y_pred in
    
    (* Compute gradients *)
    let grad_tbl = gradients loss in
    let dw1 = find grad_tbl !w1 in
    let dw2 = find grad_tbl !w2 in
    
    
    let clip_gradient grad =
      Tensor.map (fun x -> 
        if Float.(x > 2.0) then 2.0
        else if Float.(x < -2.0) then -2.0
        else x) grad
    in
    
    let dw1_clipped = clip_gradient dw1 in
    let dw2_clipped = clip_gradient dw2 in
    
    (* Update weights *)
    let lr = learning_rate *. (1.0 -. float_of_int epoch /. float_of_int (num_epochs * 2)) in
    let lr_tensor = Tensor.create lr in
    w1 := make Tensor.(!w1.data - (dw1_clipped * lr_tensor));
    w2 := make Tensor.(!w2.data - (dw2_clipped * lr_tensor));
    

    if Int.(epoch mod 10 = 0 || epoch = 1) then (
      Printf.printf "Epoch %3d/%d - Loss: %.6f Accuracy: %.2f%% LR: %.6f\n" 
        epoch num_epochs (Tensor.get loss.data [||]) (accuracy *. 100.0) lr
    )
  done;
  
  (* Final predictions on training set *)
  let final_pred = forward x in
  let final_loss = binary_cross_entropy y final_pred in
  let final_accuracy = calculate_accuracy y final_pred in
  
  Printf.printf "\nTraining complete!\n";
  Printf.printf "Final loss: %.6f\n" (Tensor.get final_loss.data [||]);
  Printf.printf "Final accuracy: %.2f%%\n" (final_accuracy *. 100.0);
  
  (* Print example predictions *)
  Printf.printf "\nSample predictions:\n";
  for i = 0 to 4 do
    Printf.printf "True: %.1f, Predicted: %.6f\n" 
      (Tensor.get y.data [|i; 0|]) 
      (Tensor.get final_pred.data [|i; 0|])
  done
