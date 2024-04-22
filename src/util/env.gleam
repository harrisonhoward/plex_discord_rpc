//// Module for handling reading and writing from the custom env file

import dot_env/env
import gleam/option.{type Option, None, Some}
import gleam/result
import simplifile.{type FileError}

pub const name_of_config_file = "config.env"

/// Represents the user inputted base config
pub type BaseConfigOption {
  BaseConfigOption(
    /// Required (Expected to be a URL)
    hostname: String,
    /// Optional (Default 32400)
    port: Option(Int),
    /// Optional (Default "me")
    username: Option(String),
    /// Optional (Default false)
    https: Option(Bool),
    /// Optional
    check_users: Option(List(String)),
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
