import glint
import argv
// Commands
import commands/sample
import commands/help as help_command

pub fn main() {
  // Create a new instance of glint (our command handler)
  glint.new()
  // Name of our application
  |> glint.with_name("plexrpc")
  // Setup our --help flag for our individual commands
  |> glint.without_pretty_help()
  // Add our commands
  |> help_command.command()
  |> sample.command()
  // Parse the stdin arguments
  |> glint.run(argv.load().arguments)
}
