//// Command to initiate the Plex RPC connection. Requires authentication to be setup.

import gleam/io
import glint.{type CommandInput, type Glint}
import util/commands/watch_tool

/// The 'watch' command logic
fn do(_input: CommandInput) {
  io.println("todo")
}

/// Add the 'watch' command to the glint instance
pub fn command(to glint: Glint(Nil)) {
  glint.add(
    to: glint,
    at: ["watch"],
    do: glint.command(do)
      |> glint.description(watch_tool.description),
  )
}
