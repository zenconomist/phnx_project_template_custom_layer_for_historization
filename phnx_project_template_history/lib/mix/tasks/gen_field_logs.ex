# call this generator with `mix gen_field_logs <context> <schema> <table>`
# example: mix gen_with_logs Accounts User users

defmodule Mix.Tasks.GenFieldLogs do
  use Mix.Task

  @shortdoc "Generates a resource with a corresponding field_log table"

  def run(args) do

    # Extract table name and context details from args
    [context_name, schema_name, table_name | _rest] = args

    # Generate the _field_log schema and migration
    log_table_name = "#{table_name}_field_log"
    Mix.Task.run("phx.gen.schema", [
      "#{context_name}.#{schema_name}FieldLog",
      log_table_name,
      "row_id:integer",
      "action:string",
      "field_name:string",
      "old_value:string",
      "new_value:string",
      "time_of_change:utc_datetime",
      "changed_by:string"
    ]
    )

  end
end
