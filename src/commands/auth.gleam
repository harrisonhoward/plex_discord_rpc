//// Command logic for the authentication tool.

import gleam/int
import gleam/io
import gleam/option.{None, Some}
import glint.{type CommandInput, type Glint}
import plex_pin_auth
import plex_pin_auth/util/parser.{type PlexError, type PlexPin}
import repeatedly
import util/client_identifier
import util/commands/auth_tool
import util/env.{ConfigOption}
import util/terminal

/// The interval in which we poll the server for the token
const interval_ms = 2000

/// The 'auth' command logic
fn do(_input: CommandInput) {
  // First validate the config. If it's not valid then this command can not be executed
  // This command has a reliance on hostname and username
  case env.is_base_config_valid() {
    False -> {
      io.println(
        "You have no setup the config yet! Please run `plexrpc config` first.",
      )
      terminal.exit()
    }
    _ -> Nil
  }

  // Second validate the auth config.
  // If there is already a token we need to confirm with the user that they want to replace the current token
  case env.is_auth_config_valid() {
    True ->
      case
        terminal.confirm(
          "You already have an auth token. Do you want to replace it?",
          default: Some(False),
        )
      {
        True -> {
          // Spacing out the terminal if the prompt was sent
          io.println("")
        }
        False -> terminal.exit()
      }

    _ -> Nil
  }

  // Generate the client identifier
  let assert Ok(client_id) = client_identifier.generate()

  // We need to create the Plex pin and inform the user of the next steps
  let create_pin_response =
    plex_pin_auth.create_pin(client_id)
    |> handle_plex_error

  // Extract the ok response since we know it's okay to go now :)
  let assert Ok(created_pin) = create_pin_response
  // Inform the user what the code is and what to do with it
  io.println(
    "Successfully created your Plex pin as "
    <> client_id
    <> "\nYour Plex code is: "
    <> created_pin.code
    <> "\nYou can open the QR code in the browser user this link: "
    <> created_pin.qr
    <> "\nOtherwise go to https://plex.tv/link and enter the code above."
    <> "\n\nWaiting for you to link your account...",
  )

  // Setup repeatedly so we can poll the server for the token
  repeatedly.call(
    // For now only poll every 2 seconds
    interval_ms,
    Nil,
    fn(_, _) {
      let token_response =
        plex_pin_auth.get_token(client_id, created_pin.id)
        |> handle_plex_error

      let assert Ok(token) = token_response
      case token.auth_token {
        Some(auth_token) -> {
          // Save the token to the config
          case
            env.set_config(ConfigOption(
              hostname: None,
              port: None,
              username: None,
              https: None,
              check_users: None,
              token: Some(auth_token),
            ))
          {
            Ok(_) -> io.println("Successfully authenticated with Plex!")
            Error(err) -> {
              io.println("Failed to save the token to the config")
              io.debug(err)
              Nil
            }
          }
          terminal.exit()
        }
        None -> Nil
      }
    },
  )

  // Sleep for the time it takes for the pin to expire
  terminal.sleep(created_pin.expires_in * 1000)
  Nil
}

/// Add the 'auth' command to the glint instance
pub fn command(to glint: Glint(Nil)) {
  glint.add(
    to: glint,
    at: ["auth"],
    do: glint.command(do)
      |> glint.description(auth_tool.description),
  )
}

/// Handles the usual Plex error and throws it into the terminal
fn handle_plex_error(response: Result(PlexPin, PlexError)) {
  case response {
    Ok(_) -> Nil
    Error(err) -> {
      io.println(
        "Oh no! Something went wrong creating your pin..."
        <> "\nStatus: "
        <> int.to_string(err.status)
        <> "\nCode: "
        <> int.to_string(err.code)
        <> "\nMessage: "
        <> err.message,
      )
      terminal.exit()
    }
  }
  response
}
