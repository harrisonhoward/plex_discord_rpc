//// Command logic for the help command. This is the base help command when entering an unknown command.

import glint.{type CommandInput, type Glint}
import util/commands/help_tool

/// Runs the print function for the 'help' command
fn do(_input: CommandInput) {
  help_tool.print()
}

/// Adds the 'help' command to the glint instance.
pub fn command(to glint: Glint(Nil)) {
  glint.add(
    to: glint,
    at: [],
    do: glint.command(do)
      |> glint.description(help_tool.description),
  )
}
