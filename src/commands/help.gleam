//// Command logic for the help command. This is the base help command when entering an unknown command.

import commands/auth.{description as auth_description}
import commands/config.{description as config_description}
import commands/watch.{description as watch_description}
import gleam/io
import glint.{type CommandInput, type Glint}

/// Description for the 'help' command
const description = "Below are the commands that are available in this project.\nIf you need help with a specific command attach the flag '--help' when running the command."

/// Runs the print function for the 'help' command
fn do(_input: CommandInput) {
  io.println(
    description
    <> "\n\n"
    <> "USAGE:\n"
    <> "\tplexrpc [ ARGS ]"
    <> "\n\n"
    <> "SUBCOMMANDS:\n"
    <> "\twatch\t\t"
    <> watch_description
    <> "\n"
    <> "\tauth\t\t"
    <> auth_description
    <> "\n"
    <> "\tconfig\t\t"
    <> config_description,
  )
}

/// Adds the 'help' command to the glint instance.
pub fn command(to glint: Glint(Nil)) {
  glint.add(
    to: glint,
    at: [],
    do: glint.command(do)
      |> glint.description(description),
  )
}
