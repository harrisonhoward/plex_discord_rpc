import argv
import glint

// Config
import dot_env
import util/env.{name_of_config_file}

// Commands
import commands/auth
import commands/config
import commands/help as help_command
import commands/sample
import commands/watch

/// Entry point for the application
pub fn main() {
  // Init the config file
  let _ = env.init_config_file()
  // Load the .env file
  dot_env.load_with_opts(dot_env.Opts(
    path: "./" <> name_of_config_file,
    debug: False,
    capitalize: False,
    ignore_missing_file: False,
  ))
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
  |> config.command()
  // Parse the stdin arguments
  |> glint.run(argv.load().arguments)
}
