let read_file filename =
  let ic = open_in filename in
  let content = really_input_string ic (in_channel_length ic) in
  close_in ic;
  content

let execute_command cmd =
  let _, stdin_w = Unix.pipe () in
  let stdout_r, stdout_w = Unix.pipe () in
  let stderr_r, stderr_w = Unix.pipe () in
  
  Unix.close stdin_w;
  
  let pid = Unix.create_process "dune" 
    [|"dune"; "exec"; "--"; "./examples/" ^ cmd ^ ".exe"|] 
    stdout_r stdout_w stderr_w in
  
  Unix.close stdout_w;
  Unix.close stderr_w;
  
  let stdout = Unix.in_channel_of_descr stdout_r in
  let stderr = Unix.in_channel_of_descr stderr_r in
  
  let rec read_output channel acc =
    try
      let line = input_line channel in
      read_output channel (line :: acc)
    with End_of_file -> List.rev acc
  in
  
  let stdout_lines = read_output stdout [] in
  let stderr_lines = read_output stderr [] in
  
  let _ = Unix.waitpid [] pid in
  (stdout_lines, stderr_lines)

let handle_example example =
  match example with
  | "basic" | "simple" | "large" | "printed" | "visualize" | "nn" ->
      let stdout, stderr = execute_command example in
      if List.length stderr > 0 then
        String.concat "\n" stderr
      else
        String.concat "\n" stdout
  | _ -> "Invalid example name"

let ensure_directory_exists dir =
  if not (Sys.file_exists dir) then
    Unix.mkdir dir 0o755

let generate_graph _output graph_type =
  Printf.printf "\nGenerating graph for type: %s\n" graph_type;
  try
    let (dot_file, png_file, graph_name) = match graph_type with
      | "basic" -> ("frontend/static/graph_basic.dot", "frontend/static/graph_basic.png", "graph_basic")
      | "simple" -> ("frontend/static/graph_simple.dot", "frontend/static/graph_simple.png", "graph_simple")
      | "large" -> ("frontend/static/graph_large.dot", "frontend/static/graph_large.png", "graph_large")
      | "computational_graph" -> ("frontend/static/graph_computational.dot", "frontend/static/graph_computational.png", "graph_computational")
      | "nn" -> ("frontend/static/graph_nn.dot", "frontend/static/graph_nn.png", "graph_nn")
      | _ -> failwith (Printf.sprintf "Unknown graph type: %s" graph_type)
    in
    
    Printf.printf "Looking for DOT file at: %s\n" dot_file;
    if Sys.file_exists dot_file then (
      Printf.printf "DOT file found\n";
      let cmd = Printf.sprintf "dot -Tpng %s -o %s" dot_file png_file in
      Printf.printf "Executing command: %s\n" cmd;
      let result = Sys.command cmd in
      Printf.printf "Command result: %d\n" result;
      
      if result = 0 && Sys.file_exists png_file then (
        let path = Printf.sprintf "/static/%s.png" graph_name in
        Printf.printf "Returning graph path: %s\n" path;
        Some path
      ) else (
        Printf.printf "Failed to generate PNG. File exists: %b\n" (Sys.file_exists png_file);
        None
      )
    ) else (
      Printf.printf "DOT file not found\n";
      None
    )
  with e -> 
    Printf.printf "Error generating graph: %s\n%s\n" 
      (Printexc.to_string e) 
      (Printexc.get_backtrace());
    None

let () =
  ensure_directory_exists "frontend";
  ensure_directory_exists "frontend/static";
  
  Dream.run ~interface:"0.0.0.0" ~port:8080
  @@ Dream.logger
  @@ Dream.router [
    Dream.get "/" (fun _ ->
      let content = read_file "frontend/index.html" in
      Dream.html content);

    Dream.get "/static/**" (Dream.static "./frontend/static");

    Dream.get "/run/:example" (fun request ->
      let example = Dream.param request "example" in
      Dream.respond ~headers:["Content-Type", "text/plain"] (handle_example example));

    Dream.get "/graph/:type" (fun request ->
      let graph_type = Dream.param request "type" in
      let output = handle_example graph_type in
      match generate_graph output graph_type with
      | Some path -> 
          Dream.respond ~headers:["Content-Type", "text/plain"] path
      | None ->
          Dream.respond 
            ~status:`Internal_Server_Error 
            ~headers:["Content-Type", "text/plain"]
            "Failed to generate graph");
  ]