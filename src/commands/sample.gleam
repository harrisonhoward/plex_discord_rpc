//// Hidden sample command.

import gleam/io
import gleam/option.{None, Some}
import glint.{type CommandInput, type Glint}
import util/terminal

/// Runs the basic terminal code for testing the command and terminal logic
fn do(_input: CommandInput) {
  let hello = terminal.prompt("Type something", None)
  case hello {
    "something" -> {
      io.println("Oh you think you're funny huh?")
      terminal.exit()
    }
    _ -> io.println("You typed: " <> hello)
  }
  // Spacer for readability
  io.println("")
  let correct = terminal.confirm("Is this correct?", Some(True))
  case correct {
    True -> "Awesome! :)"
    False -> "You're dead to me"
  }
  |> io.println
}

/// Adds the 'sample' command to the glint instance
pub fn command(to glint: Glint(Nil)) {
  glint.add(
    to: glint,
    at: ["sample"],
    do: glint.command(do)
      |> glint.description("This is a sample command"),
  )
}
