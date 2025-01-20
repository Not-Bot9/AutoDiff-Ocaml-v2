
open Bigarray

(* Create a 2D Bigarray *)
let create_matrix rows cols =
  Array2.create Float64 C_layout rows cols

(* Fill the matrix with values *)
let fill_matrix matrix =
  let rows = Array2.dim1 matrix in
  let cols = Array2.dim2 matrix in
  for i = 0 to rows - 1 do
    for j = 0 to cols - 1 do
      Array2.set matrix i j (float_of_int (i * cols + j))
    done
  done

(* Print the matrix *)
let print_matrix matrix =
  let rows = Array2.dim1 matrix in
  let cols = Array2.dim2 matrix in
  for i = 0 to rows - 1 do
    for j = 0 to cols - 1 do
      Printf.printf "%6.2f " (Array2.get matrix i j)
    done;
    print_newline ()
  done

(* Add two matrices element-wise *)
let add_matrices a b =
  let rows = Array2.dim1 a in
  let cols = Array2.dim2 a in
  let result = Array2.create Float64 C_layout rows cols in
  for i = 0 to rows - 1 do
    for j = 0 to cols - 1 do
      Array2.set result i j (Array2.get a i j +. Array2.get b i j)
    done
  done;
  result

let () =
  (* Create two matrices *)
  let rows, cols = 3, 3 in
  let matrix1 = create_matrix rows cols in
  let matrix2 = create_matrix rows cols in

  (* Fill matrices with values *)
  fill_matrix matrix1;
  fill_matrix matrix2;

  (* Print the first matrix *)
  Printf.printf "Matrix 1:\n";
  print_matrix matrix1;

  (* Print the second matrix *)
  Printf.printf "\nMatrix 2:\n";
  print_matrix matrix2;

  (* Add the matrices *)
  let sum_matrix = add_matrices matrix1 matrix2 in

  (* Print the result *)
  Printf.printf "\nSum of Matrix 1 and Matrix 2:\n";
  print_matrix sum_matrix;
  print_endline("");

