//// The utility file for the help command and flag

import gleam/io
import glint.{type CommandInput}
// Command utils
import util/watch_tool
import util/auth_tool

pub const description = "Below are the commands that are available in this project.\nIf you need help with a specific command attach the flag '--help' when running the command."

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
    <> auth_tool.description,
  )
}

pub fn do_command(_input: CommandInput) {
  print()
}
