//// Module for handling reading and writing from the custom env file

import dot_env/env
import gleam/bool
import gleam/int
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string
import simplifile.{type FileError}

pub const name_of_config_file = "config.env"

/// Represents the user inputted config. All options are optional.
pub type ConfigOption {
  ConfigOption(
    hostname: Option(String),
    port: Option(Int),
    username: Option(String),
    https: Option(Bool),
    check_users: Option(List(String)),
    token: Option(String),
  )
}

/// Represents the base config for the application
pub type BaseConfig {
  BaseConfig(
    /// Required (Expected to be a URL)
    hostname: String,
    /// Optional (Default 32400)
    port: Int,
    /// Optional (Default "me")
    username: String,
    /// Optional (Default false)
    https: Bool,
    /// Optional
    check_users: List(String),
  )
}

/// Represents the auth config for the application
pub type AuthConfig {
  AuthConfig(token: String)
}

/// Returns a boolean if the config file exists or not
fn check_for_config_file() -> Bool {
  case simplifile.verify_is_file("./" <> name_of_config_file) {
    Ok(result) -> result
    Error(_) -> False
  }
}

/// Initialise config file if it does not exist
pub fn init_config_file() -> Result(Nil, FileError) {
  // Check for the config file
  let file_exists = check_for_config_file()

  case file_exists {
    True -> Ok(Nil)
    False ->
      // Create the config file (This will an empty config file)
      // To fill this file the user needs to run through the prompt generation
      simplifile.create_file("./" <> name_of_config_file)
  }
}

/// Will return a boolean if the current config is valid to the base config type\
/// Essentially just checks if hostname is present and returns true or false
pub fn is_base_config_valid() -> Bool {
  // Check all required keys and return true or false
  let hostname = env.get("hostname")
  let username = env.get("username")
  case hostname, username {
    // Don't allow empty strings
    Ok(""), Ok("") -> False
    Ok(_), Ok(_) -> True
    _, _ -> False
  }
}

/// Returns the base config\
/// if should_panic is true (Will error if hostname isn't provided)
pub fn get_base_config(should_panic should_panic: Bool) -> BaseConfig {
  // Read each config key
  let hostname = case env.get("hostname") {
    Ok(value) -> value
    Error(_) if should_panic -> panic as "Hostname not found in config file"
    Error(_) -> ""
  }
  let username = case env.get("username") {
    Ok(value) -> value
    Error(_) if should_panic -> panic as "Username not found in config file"
    Error(_) -> ""
  }
  let port =
    env.get_int("port")
    |> result.unwrap(32_400)
  let https =
    env.get_bool("https")
    |> result.unwrap(False)
  let check_users =
    env.get_or("check_users", "")
    |> string.split(on: ",")

  BaseConfig(
    hostname: hostname,
    port: port,
    username: username,
    https: https,
    check_users: check_users,
  )
}

/// Will return a boolean if the current config is valid to the auth config type\
/// Essentially just checks if token is present and returns true or false
pub fn is_auth_config_valid() -> Bool {
  // Check all required keys and return true or false
  case env.get("token") {
    // Don't allow empty strings
    Ok("") -> False
    Ok(_) -> True
    Error(_) -> False
  }
}

/// Returns the auth config\
/// if should_panic is true (Will error if token isn't provided)
pub fn get_auth_config(should_panic should_panic: Bool) -> AuthConfig {
  // Read each config key
  let token = case env.get("token") {
    Ok(value) -> value
    Error(_) if should_panic -> panic as "Token not found in config file"
    Error(_) -> ""
  }

  AuthConfig(token: token)
}

/// Writes to the base config file\
/// Will remove all bad keys and write the new keys to the file
pub fn set_config(input: ConfigOption) -> Result(Nil, FileError) {
  // Get current config (Don't panic if host_name isn't present)
  let current_config = get_base_config(should_panic: False)
  let current_auth = get_auth_config(should_panic: False)

  // Get the new values
  let new_hostname = case input.hostname {
    Some(hostname) -> hostname
    None -> current_config.hostname
  }
  let new_port = case input.port {
    Some(port) -> int.to_string(port)
    None -> int.to_string(current_config.port)
  }
  let new_username = case input.username {
    Some(username) -> username
    None -> current_config.username
  }
  let new_https = case input.https {
    Some(https) -> bool.to_string(https)
    None -> bool.to_string(current_config.https)
  }
  let new_check_users = case input.check_users {
    Some(users) -> string.join(users, ",")
    None -> string.join(current_config.check_users, ",")
  }
  let new_token = case input.token {
    Some(token) -> token
    None -> current_auth.token
  }

  // Write to the file (overwrites)
  simplifile.write(
    to: "./" <> name_of_config_file,
    contents: "hostname='"
      <> new_hostname
      <> "'\n"
      <> "port='"
      <> new_port
      <> "'\n"
      <> "username='"
      <> new_username
      <> "'\n"
      <> "https="
      <> new_https
      <> "\n"
      <> "check_users='"
      <> new_check_users
      <> "'\n"
      <> "token='"
      <> new_token
      <> "'",
  )
}
