import gleam/io
import lustre
import lustre/element

pub fn main() {
  let app = lustre.element(element.text("Hi there"))
  io.println("Hello from lustre_test!")
  let assert Ok(_) = lustre.start(app, "#app", Nil)
}
