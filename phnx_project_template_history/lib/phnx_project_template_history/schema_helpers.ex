defmodule PhnxProjectTemplateHistory.SchemaHelpers do
  defmacro timestamps_with_deleted_at(opts \\ []) do
    quote do
      timestamps(unquote(opts))
      field :deleted_at, :utc_datetime
    end
  end
end
