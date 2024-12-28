defmodule PhnxProjectTemplateHistory.Accounts.UserHistory do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users_history" do
    field :dat_from, :utc_datetime
    field :dat_to, :utc_datetime
    field :is_current, :boolean, default: false
    field :is_deleted, :boolean, default: false
    field :time_of_change, :utc_datetime
    field :changed_by, :string
    field :deleted_at, :utc_datetime, default: nil
    field :entity_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user_history, attrs) do
    user_history
    |> cast(attrs, [:dat_from, :dat_to, :is_current, :is_deleted, :time_of_change, :changed_by])
    |> validate_required([:dat_from, :dat_to, :is_current, :is_deleted, :time_of_change, :changed_by])
  end
end
