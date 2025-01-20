(*  
visualize.ml
- This file visualizes the computation graph built from a chain of expressions.
- The graph is outputted in the DOT format.

"dot -Tpng graph.dot -o graph.png" can be used to convert the DOT file to a PNG file.

*)


open Variable

let x = make @@ Tensor.create 2.0
let y = make @@ Tensor.create 3.0
let z = make @@ Tensor.create 9.0
let f1 = x + y
let f2 = f1 * x

let f3 = f2 * z


let () =
  visualize f3 "graph.dot"