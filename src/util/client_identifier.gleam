//// This module is to handle client_identifier utilities

import util/env

/// Generates a new client identifier based on the current hostname and username
/// if the config isn't valid it throws an error
pub fn generate() -> Result(String, Nil) {
  case env.is_base_config_valid() {
    True -> {
      let base_config = env.get_base_config(True)
      let hostname = base_config.hostname
      let username = base_config.username
      Ok(hostname <> "-" <> username)
    }
    False -> Error(Nil)
  }
}
