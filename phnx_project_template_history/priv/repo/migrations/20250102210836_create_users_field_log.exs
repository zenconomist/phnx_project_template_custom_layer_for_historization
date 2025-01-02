defmodule PhnxProjectTemplateHistory.Repo.Migrations.CreateUsersFieldLog do
  use Ecto.Migration

  def change do
    create table(:users_field_log) do
        add :row_id, :integer
        add :action, :string
        add :field_name, :string
        add :old_value, :string
        add :new_value, :string
        add :time_of_change, :utc_datetime
        add :changed_by, :string
  
      timestamps(type: :utc_datetime)
      add :deleted_at, :utc_datetime
      end

  
  end # end of change

end
