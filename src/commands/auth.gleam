import gleam/io
import glint.{type CommandInput, type Glint}
import util/auth_tool

fn do(_input: CommandInput) {
  io.println("todo")
}

pub fn command(to glint: Glint(Nil)) {
  glint.add(
    to: glint,
    at: ["auth"],
    do: glint.command(do)
      |> glint.description(auth_tool.description),
  )
}
