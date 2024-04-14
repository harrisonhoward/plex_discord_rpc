import glint.{type Glint}
import util/help_tool

pub fn command(to glint: Glint(Nil)) {
  glint.add(
    to: glint,
    at: [],
    do: glint.command(help_tool.do_command)
      |> glint.description(help_tool.description),
  )
}
