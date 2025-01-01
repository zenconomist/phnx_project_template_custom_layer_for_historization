defmodule Mix.Tasks.GenScd2 do
  use Mix.Task

  @shortdoc "Generates a schema and migration for a table with SCD Type 2 history tracking"

  def run(args) do
    # Validate input
    unless length(args) >= 3 do
      Mix.raise("""
      Invalid arguments. Usage:
      mix gen_scd2 <context> <schema> <table> <fields>
      Example:
      mix gen_scd2 Accounts User users name:string age:integer
      """)
    end

    # Extract context, schema, table, and fields from args
    [context_name, schema_name, table_name | schema_fields] = args

    # Parse schema fields into a keyword list of field:type pairs
    parsed_fields =
      schema_fields
      |> Enum.map(fn field ->
        case String.split(field, ":") do
          [key, type] -> {String.to_atom(key), String.to_atom(type)}
          _ -> Mix.raise("Invalid field format: #{field}. Expected format is field:type")
        end
      end)

    # Generate the SCD2 history schema and migration
    log_table_name = "#{table_name}_history"

    Mix.Task.run("phx.gen.schema", [
      "#{context_name}.#{schema_name}History",
      log_table_name,
      "entity_id:integer",
      "dat_from:utc_datetime",
      "dat_to:utc_datetime",
      "is_current:boolean",
      "is_deleted:boolean",
      "time_of_change:utc_datetime",
      "changed_by:string"
      | Enum.map(parsed_fields, fn {field, type} -> "#{field}:#{type}" end)
    ])

    # Display success message
    Mix.shell().info("""
    Generated SCD2 schema and migration for #{log_table_name}.
    Context: #{context_name}
    Schema: #{schema_name}
    Table: #{table_name}
    Fields: #{inspect(parsed_fields)}
    """)
  end
end
