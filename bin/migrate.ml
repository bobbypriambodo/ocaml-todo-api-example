let migrate () =
  print_endline "creating todos table.";
  let%lwt _ =
    let module Todos = Todos.Make(Db) in
    let%lwt result = Todos.migrate () in
    match result with
    | Ok () -> print_endline "done." |> Lwt.return
    | Error _e -> print_endline "error." |> Lwt.return
  in
  Lwt.return_unit

let () = Lwt_main.run (migrate ())
