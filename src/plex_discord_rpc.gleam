import glint
import argv
// Commands
import commands/sample
import commands/help as help_command
import commands/watch
import commands/auth

pub fn main() {
  // Create a new instance of glint (our command handler)
  glint.new()
  // Name of our application
  |> glint.with_name("plexrpc")
  // Setup our --help flag for our individual commands
  |> glint.without_pretty_help()
  // Add our commands
  |> sample.command()
  |> help_command.command()
  |> watch.command()
  |> auth.command()
  // Parse the stdin arguments
  |> glint.run(argv.load().arguments)
}
