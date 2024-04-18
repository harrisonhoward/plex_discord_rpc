import argv
import glint

// Commands
import commands/auth
import commands/help as help_command
import commands/sample
import commands/watch

/// Entry point for the application
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
