defmodule PhnxProjectTemplateHistory.Accounts.UserFieldLog do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users_field_log" do
    field :new_value, :string
    field :row_id, :integer
    field :field_name, :string
    field :old_value, :string
    field :time_of_change, :utc_datetime
    field :changed_by, :string
    field :deleted_at, :utc_datetime, default: nil

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user_field_log, attrs) do
    user_field_log
    |> cast(attrs, [:row_id, :field_name, :old_value, :new_value, :time_of_change, :changed_by])
    |> validate_required([:row_id, :field_name, :old_value, :new_value, :time_of_change, :changed_by])
  end
end
