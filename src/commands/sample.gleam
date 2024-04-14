import gleam/io
import gleam/option.{Some}
import glint.{type CommandInput, type Glint}
import util/terminal

fn do(_input: CommandInput) {
  let hello = terminal.prompt("Type something")
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

pub fn command(to glint: Glint(Nil)) {
  glint.add(
    to: glint,
    at: ["sample"],
    do: glint.command(do)
      |> glint.description("This is a sample command"),
  )
}
