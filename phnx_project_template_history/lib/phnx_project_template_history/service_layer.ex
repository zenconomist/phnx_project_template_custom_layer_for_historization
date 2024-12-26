defmodule PhnxProjectTemplateHistory.ServiceLayer do
  alias PhnxProjectTemplateHistory.{RepoHelpers, Repo}

  def get!(schema, id), do: RepoHelpers.get!(schema, id)

  def get_all(schema), do: RepoHelpers.get_all(schema)

  def create(schema_module, attrs) when is_atom(schema_module) do
    changeset = schema_module.changeset(struct(schema_module), attrs)

    Repo.transaction(fn ->
      record = Repo.insert!(changeset)
      log_changes(record, attrs, :create)
      insert_scd2_version(record)
      record
    end)
  end

  def update(record, attrs) do
    changeset = record.__struct__.changeset(record, attrs)

    Repo.transaction(fn ->
      updated_record = Repo.update!(changeset)
      log_changes(record, attrs, :update)
      insert_scd2_version(updated_record)
      updated_record
    end)
  end

  def delete(record) do
    changeset = Ecto.Changeset.change(record, %{deleted_at: DateTime.utc_now()})

    Repo.transaction(fn ->
      Repo.update!(changeset)
      log_changes(record, %{}, :delete)
      mark_scd2_inactive(record)
    end)
  end

  defp log_changes(record, attrs, action) do
    # Implement logic to insert field log changes
    record
  end

  defp insert_scd2_version(record) do
    # Implement logic to insert into SCD2 history table
    record
  end

  defp mark_scd2_inactive(record) do
    # Implement logic to mark SCD2 record as inactive
    record
  end
end