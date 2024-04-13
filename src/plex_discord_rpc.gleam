import gleam/io
import gleam/option.{Some}
import util/terminal

pub fn main() {
  let hello = terminal.prompt("Type something")
  case hello {
    "something" -> {
      io.println("Oh you think you're funny huh?")
      terminal.quit()
    }
    _ -> io.println("You typed: " <> hello)
  }

  // Spacer for readability
  io.println("")

  let correct = terminal.confirm("Is this correct?", Some(True))
  case correct {
    True -> io.println("Awesome! :)")
    False -> io.println("You're dead to me")
  }
}
