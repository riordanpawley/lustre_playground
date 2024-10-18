import gleam/int
import gleam/io
import gleam/list
import gleam/result
import lustre
import lustre/attribute
import lustre/effect.{type Effect}
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

pub type Todo {
  Todo(key: Int, text: String)
}

pub type Model =
  #(String, List(Todo))

pub type Msg {
  InputUpdated(text: String)
  TodoAdded
  TodoRemoved(index: Int)
}

pub fn update(model: Model, msg: Msg) -> #(Model, Effect(Msg)) {
  let new_model = case msg, model.0 {
    TodoRemoved(index), text -> {
      let todos =
        model.1
        |> list.filter(fn(todoo) { index != todoo.key })
      #(text, todos)
    }
    TodoAdded, text -> {
      let todos =
        model.1
        |> list.append([Todo(list.length(model.1), text)])
      #("", todos)
    }
    InputUpdated(text), _ -> #(text, model.1)
  }

  #(new_model, effect.none())
}

pub fn init(_) -> #(Model, Effect(Msg)) {
  let model = #("", [Todo(0, "hi")])
  let effect = effect.none()
  #(model, effect)
}

pub fn view(model: Model) -> Element(Msg) {
  html.div([attribute.class("flex flex-col gap-2")], [
    html.form(
      [
        attribute.class("flex flex-col gap-2 justify-centre max-w-96 mx-auto"),
        event.on_submit(TodoAdded),
      ],
      [
        html.input([
          attribute.class("border"),
          attribute.value(model.0),
          event.on_input(InputUpdated),
        ]),
        html.button(
          [
            attribute.class("text-blue-500"),
            attribute.type_("submit"),
            // attribute.on("click", fn(_) { Ok(TodoAdded("test")) }),
          ],
          [html.text("Add todo")],
        ),
      ],
    ),
    element.keyed(html.ul([], _), {
      model.1
      |> list.index_map(fn(todoo, key) {
        #(
          int.to_base8(key),
          html.li([], [
            html.div([attribute.class("gap-2 flex")], [
              html.text(todoo.text),
              html.button(
                [
                  attribute.class("text-blue-500"),
                  event.on_click(TodoRemoved(key)),
                ],
                [html.text("Remove")],
              ),
            ]),
          ]),
        )
      })
    }),
  ])
}

pub fn main() {
  let app = lustre.application(init, update, view)
  io.println("Hello from lustre_test!")
  let assert Ok(_) = lustre.start(app, "#app", Nil)
}
