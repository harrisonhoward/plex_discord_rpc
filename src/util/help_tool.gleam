//// The utility file for the help command and flag

import gleam/io
import glint.{type CommandInput}

pub const description = "Below are the commands that are available in this project.\nIf you need help with a specific command attach the flag '--help' when running the command."

pub fn print() {
  io.println(
    description
    <> "\n\n"
    <> "USAGE:\n"
    <> "\tplexrpc [ ARGS ]"
    <> "\n\n"
    <> "SUBCOMMANDS:\n"
    <> "\twatch\t\t...\n"
    <> "\tauth\t\t...",
  )
}

pub fn do_command(_input: CommandInput) {
  print()
}
