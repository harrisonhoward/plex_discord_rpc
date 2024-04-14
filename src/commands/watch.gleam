import gleam/io
import glint.{type CommandInput, type Glint}
import util/watch_tool

fn do(_input: CommandInput) {
  io.println("todo")
}

pub fn command(to glint: Glint(Nil)) {
  glint.add(
    to: glint,
    at: ["watch"],
    do: glint.command(do)
      |> glint.description(watch_tool.description),
  )
}
