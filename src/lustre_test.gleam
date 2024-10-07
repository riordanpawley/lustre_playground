import gleam/io
import lustre
import lustre/element

pub fn main() {
  let app = lustre.element(element.text("Hi"))
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  io.println("Hello from lustre_test!")
}
