import gleam/io
import util/terminal

pub fn main() {
  let hello = terminal.prompt("Type something:")

  io.println("You typed: " <> hello)
}
