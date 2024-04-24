//// Command logic for the authentication tool.

import gleam/io
import glint.{type CommandInput, type Glint}
import util/commands/auth_tool

/// The 'auth' command logic
fn do(_input: CommandInput) {
  io.println("todo")
}

/// Add the 'auth' command to the glint instance
pub fn command(to glint: Glint(Nil)) {
  glint.add(
    to: glint,
    at: ["auth"],
    do: glint.command(do)
      |> glint.description(auth_tool.description),
  )
}
