//// The utility file for the help command and flag

import gleam/io

// Command utils
import util/commands/auth_tool
import util/commands/config_tool
import util/commands/watch_tool

/// Description for the 'help' command
pub const description = "Below are the commands that are available in this project.\nIf you need help with a specific command attach the flag '--help' when running the command."

/// The output print for the base 'help' command.\
/// Does not represent the 'help' flag output
pub fn print() {
  io.println(
    description
    <> "\n\n"
    <> "USAGE:\n"
    <> "\tplexrpc [ ARGS ]"
    <> "\n\n"
    <> "SUBCOMMANDS:\n"
    <> "\twatch\t\t"
    <> watch_tool.description
    <> "\n"
    <> "\tauth\t\t"
    <> auth_tool.description
    <> "\n"
    <> "\tconfig\t\t"
    <> config_tool.description,
  )
}
