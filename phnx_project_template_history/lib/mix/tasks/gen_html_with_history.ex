defmodule Mix.Tasks.GenHtmlWithHistory do
  use Mix.Task

  @shortdoc "Generates HTML with history tracking"

  def run(args) do
    if length(args) < 1 do
      Mix.shell().error("Usage: mix gen_html_with_history <arguments>")
      System.halt(1)
    end

    Mix.Task.run("gen_field_logs", args)
    Mix.Task.run("gen_scd2", args)
    Mix.Task.run("phx.gen.html", args)
  end
end
