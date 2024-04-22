//// Command to write the config file for the specific user's environment

import glint.{type CommandInput, type Glint}
import util/commands/watch_tool

/// The 'watch' command logic
fn do(_input: CommandInput) {
  Nil
}

/// Add the 'watch' command to the glint instance
pub fn command(to glint: Glint(Nil)) {
  glint.add(
    to: glint,
    at: ["config"],
    do: glint.command(do)
      |> glint.description(watch_tool.description),
  )
}
