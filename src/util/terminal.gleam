//// This module is a wrapper for the survey module to handle input and output within the terminal.

import gleam/string
import gleam/option.{type Option, None, Some}
import survey
import shellout.{exit}

/// To prevent having input all arguments this function handles only showing the prompt
fn question(text display: String) -> survey.Survey {
  survey.new_question(
    prompt: display <> ":",
    help: None,
    default: None,
    validate: None,
    transform: None,
  )
}

/// To handle custom confirmations (This will allow the use of exit)
fn confirmation(
  text display: String,
  default default: Option(Bool),
) -> survey.Survey {
  // Indicates what the default is to the user
  // Default is used when the user enters nothing
  // No default is used when the user enters nothing
  let #(default_string, default_value) = {
    case default {
      Some(True) -> #("(Y/n)", Some("true"))
      Some(False) -> #("(y/N)", Some("false"))
      None -> #("(y/n)", None)
    }
  }
  survey.new_question(
    prompt: display <> " " <> default_string,
    help: None,
    default: default_value,
    validate: Some(fn(response) {
      let sanitised_result =
        string.lowercase(response)
        |> string.trim
      case sanitised_result {
        "y" | "n" | "yes" | "no" | "t" | "f" | "true" | "false" | "exit" -> True
        _invalid -> False
      }
    }),
    transform: Some(fn(response) {
      let sanitised_result =
        string.lowercase(response)
        |> string.trim
      case sanitised_result {
        "y" | "yes" | "t" | "true" -> "true"
        "n" | "no" | "f" | "false" -> "false"
        // This can only be exit as described by the validator
        _exit -> "exit"
      }
    }),
  )
}

/// Will prompt the user within the terminal. Returns a string response of their answer.
pub fn prompt(text display: String) -> String {
  let assert survey.StringAnswer(response) =
    question(display)
    |> survey.ask(help: False)
  // If the user types 'exit' close the application
  case string.lowercase(response) {
    "exit" -> {
      quit()
      // Still need to return a string even though it exits
      ""
    }
    _ -> response
  }
}

/// Will confirm the user within the terminal. Returns a boolean response of their answer.
pub fn confirm(text display: String, default default: Option(Bool)) -> Bool {
  let assert survey.StringAnswer(response) =
    confirmation(display, default)
    |> survey.ask(help: False)
  case response {
    "true" -> True
    "false" -> False
    _exit -> {
      quit()
      // Still need to return a boolean even though it exits
      False
    }
  }
}

/// Quit the terminal
pub fn quit() {
  exit(0)
}
