//// Command to write the config file for the specific user's environment

import gleam/bool
import gleam/int
import gleam/io
import gleam/option.{None, Some}
import gleam/string
import glint.{type CommandInput, type Glint}
import util/commands/watch_tool
import util/env.{ConfigOption}
import util/terminal

/// The 'config' command logic
fn do(_input: CommandInput) {
  // Basic information for user to understand what's going on
  io.println(
    "Welcome, this command is for entering the config information for your Plex Media Server.\n"
    <> "You can enter 'exit' at any time to leave the command, this will abort all operations.\n\n"
    <> "Required options are indicated by the '*' suffixed at the end of the prompt.\n"
    <> "Defaults are indicated by 'default=X'.\n"
    <> "Existing config information has priority over default and is indicated by 'current=X'\n"
    <> "If the prompt doesn't have a default then entering nothing will unset it regardless of the current value.\n\n",
  )

  // Current config information if present
  let current_base_config = env.get_base_config(should_panic: False)

  // Handle the variables for showing the current information
  let current_hostname =
    "*"
    <> case current_base_config.hostname {
      // Empty string is the default therefore don't show it
      "" -> ""
      current -> " 'current=" <> current <> "'"
    }
  let current_port =
    " 'default=32400'"
    <> case current_base_config.port {
      // Default port is 32400
      32_400 -> ""
      current -> " 'current=" <> int.to_string(current) <> "'"
    }
  let current_username =
    " 'default=me'"
    <> case current_base_config.username {
      // Default username is me
      "me" -> ""
      current -> " 'current=" <> current <> "'"
    }
  let current_https =
    " 'default=False'"
    <> case current_base_config.https {
      // Default https is False
      False -> ""
      current -> " 'current=" <> bool.to_string(current) <> "'"
    }
  let current_check_users = case current_base_config.check_users {
    // Empty string is the default therefore don't show it
    [""] | [] -> ""
    current -> " 'current=" <> string.join(current, ",") <> "'"
  }

  // Ask for the base config information
  let hostname =
    terminal.prompt("Enter your hostname" <> current_hostname, default: None)
  let port =
    terminal.prompt_int(
      "Enter your port" <> current_port,
      default: Some(current_base_config.port),
    )
  let username =
    terminal.prompt(
      "Enter your username" <> current_username,
      default: Some(current_base_config.username),
    )
  let https =
    terminal.confirm(
      "Do you use HTTPS?" <> current_https,
      default: Some(current_base_config.https),
    )
  let check_users =
    terminal.prompt(
      "Enter the users to check (example='user1,user2')" <> current_check_users,
      // This is not a required option, so the default is an empty string
      default: Some(""),
    )

  case
    env.set_config(ConfigOption(
      hostname: Some(hostname),
      port: Some(port),
      username: Some(username),
      https: Some(https),
      check_users: Some(string.split(check_users, ",")),
      // This doesn't handle token, this will keep whatever is there
      token: None,
    ))
  {
    Ok(_) -> {
      io.println(
        "\n\nConfig information saved successfully\n"
        <> "hostname: "
        <> hostname
        <> "\n"
        <> "port: "
        <> int.to_string(port)
        <> "\nusername: "
        <> username
        <> "\nhttps: "
        <> bool.to_string(https)
        <> "\ncheck_users: "
        <> check_users,
      )
    }
    Error(err) -> {
      io.println("\n\nError saving config information: " <> string.inspect(err))
    }
  }
}

/// Add the 'config' command to the glint instance
pub fn command(to glint: Glint(Nil)) {
  glint.add(
    to: glint,
    at: ["config"],
    do: glint.command(do)
      |> glint.description(watch_tool.description),
  )
}
