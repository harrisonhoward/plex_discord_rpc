//// Command to initiate the Plex RPC connection. Requires authentication to be setup.

import gleam/io
import glint.{type CommandInput, type Glint}

/// Description for the 'watch' command
pub const description = "Initiate the Plex RPC. Requires Plex auth and Discord to be open."

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
      |> glint.description(description),
  )
}
