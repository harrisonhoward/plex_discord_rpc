import gleam/string
import gleam/option.{None}
import survey
import shellout.{exit}

pub fn prompt(text display: String) -> String {
  let assert survey.StringAnswer(response) =
    survey.new_question(
      prompt: display,
      help: None,
      default: None,
      validate: None,
      transform: None,
    )
    |> survey.ask(help: False)
  // If the user types 'exit' close the application
  case string.lowercase(response) {
    "exit" -> {
      exit(0)
      // Still need to return a string even though it exits
      ""
    }
    _ -> response
  }
}
