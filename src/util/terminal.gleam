//// This module is a wrapper for the survey module to handle input and output within the terminal.

import gleam/int
import gleam/option.{type Option, None, Some}
import gleam/string
import shellout
import survey

/// To prevent having input all arguments this function handles only showing the prompt
fn question(
  text display: String,
  default default: Option(String),
) -> survey.Survey {
  survey.new_question(
    prompt: display <> ":",
    help: None,
    default: default,
    validate: None,
    transform: None,
  )
}

/// Traditional question but will return a string with "exit" or string representation of an int
fn question_int(
  text display: String,
  default default: Option(Int),
) -> survey.Survey {
  let default_as_string = case default {
    Some(num) -> Some(int.to_string(num))
    None -> None
  }
  survey.new_question(
    prompt: display <> ":",
    help: None,
    default: default_as_string,
    validate: Some(fn(response) {
      // Represents the response as a string
      let sanitised_result =
        string.lowercase(response)
        |> string.trim
      // Represents the response as a number
      let result_as_number = int.parse(sanitised_result)
      case sanitised_result, result_as_number {
        // If the user types exit, that is valid
        "exit", _ -> True
        // If the user types a number, that is valid
        _, Ok(_) -> True
        _, _ -> False
      }
    }),
    transform: Some(fn(response) {
      string.lowercase(response)
      |> string.trim
    }),
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
    prompt: display <> " " <> default_string <> ":",
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
pub fn prompt(text display: String, default default: Option(String)) -> String {
  let assert survey.StringAnswer(response) =
    question(display, default)
    |> survey.ask(help: False)
  // If the user types 'exit' close the application
  case
    string.lowercase(response)
    |> string.trim
  {
    "exit" -> {
      exit()
      // Still need to return a string even though it exits
      ""
    }
    _ -> response
  }
}

/// Will prompt the user within the terminal. Returns an int response of their answer.
/// If the user doesn't enter a number, it will prompt them until they do.
pub fn prompt_int(text display: String, default default: Option(Int)) -> Int {
  let assert survey.StringAnswer(response) =
    question_int(display, default)
    |> survey.ask(help: False)
  let response_int = int.parse(response)
  case response, response_int {
    "exit", _ -> {
      exit()
      // Still need to return an int even though it exits
      0
    }
    _, Ok(num) -> num
    // Impossible to get to but needed for the compiler
    _, _ -> 0
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
      exit()
      // Still need to return a boolean even though it exits
      False
    }
  }
}

/// Exits the terminal
pub fn exit() {
  shellout.exit(0)
}
