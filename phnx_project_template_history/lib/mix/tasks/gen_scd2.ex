# similarly to gen_field_logs.ex, this module generates a schema and migration for a table that will store the history of changes to a table
# call this generator with `mix gen_scd2 <context> <schema> <table> <fields>`
# example: mix gen_with_logs Accounts User users


## below should be generated as migration
# create table(:<%= schema.table %>_history) do
#   add :entity_id, references(:<%= schema.table %>, on_delete: :nothing)
#   add :dat_from, :utc_datetime
#   add :dat_to, :utc_datetime
#   add :is_current, :boolean, default: true
#   add :is_deleted, :boolean, default: false
#   <%= for {k, v} <- schema.types do %>add :<%= k %>, :<%= v %><%= schema.defaults[k] %>
#   <% end %>
#   timestamps(<%= if schema.timestamp_type != :naive_datetime, do: "type: #{inspect schema.timestamp_type}" %>)

# end

defmodule Mix.Tasks.GenScd2 do
  use Mix.Task

  @shortdoc "Generates a resource with a corresponding field_log table"

  def run(args) do

    # Extract table name and context details from args
    [context_name, schema_name, table_name | schema_fields] = args

    # get fields from schema

    # Generate the _field_log schema and migration
    log_table_name = "#{table_name}_history"
    Mix.Task.run("phx.gen.schema", [
      "#{context_name}.#{schema_name}History",
      log_table_name,
      "entity_id:references:#{table_name}",
      "dat_from:utc_datetime",
      "dat_to:utc_datetime",
      "is_current:boolean",
      "is_deleted:boolean",
      "time_of_change:utc_datetime",
      "changed_by:string",
      #schema_fields |> Enum.map(fn [field, type] -> "#{field}:#{type}" end) |> List.to_string(", \n")
    ]
    )


  end
end
