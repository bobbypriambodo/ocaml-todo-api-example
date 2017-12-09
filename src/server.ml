open Opium.Std

let index_page = get "/" (fun _req -> `String "Hello TodoDB\n" |> respond')

let todos_list =
  get "/todos" (fun _req ->
      let%lwt todos = Todos.get_all () in
      let result = List.map Todos.string_of_todo todos in
      let result_json = Ezjsonm.list Ezjsonm.string result in
      `Json result_json |> respond'
    )

let todos_add =
  post "/todos" (fun req ->
    let promise = req |> App.json_of_body_exn in
    Lwt.bind promise (fun json ->
        let open Ezjsonm in
        let json_value = value json in
        let content = get_string (find json_value ["content"]) in
        let%lwt () = Todos.add (Todos.todo_of_string content) in
        `Json (dict [ ("ok", bool true) ]) |> respond'
      )
  )

let start () =
  App.empty
  |> index_page
  |> todos_list
  |> todos_add
  |> App.run_command