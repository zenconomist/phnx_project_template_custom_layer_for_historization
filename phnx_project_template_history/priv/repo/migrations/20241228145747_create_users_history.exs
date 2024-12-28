defmodule PhnxProjectTemplateHistory.Repo.Migrations.CreateUsersHistory do
  use Ecto.Migration

  def change do
    create table(:users_history) do
        add :dat_from, :utc_datetime
        add :dat_to, :utc_datetime
        add :is_current, :boolean, default: false, null: false
        add :is_deleted, :boolean, default: false, null: false
        add :time_of_change, :utc_datetime
        add :changed_by, :string
        add :entity_id, references(:users, on_delete: :nothing)
  
      timestamps(type: :utc_datetime)
      add :deleted_at, :utc_datetime
      end
  
      create index(:users_history, [:entity_id])
  


    create table(:users_history_history) do
      add :entity_id, references(:users_history, on_delete: :nothing)
      add :dat_from, :utc_datetime
      add :dat_to, :utc_datetime
      add :is_current, :boolean, default: true
      add :is_deleted, :boolean, default: false
      add :dat_from, :utc_datetime
      add :dat_to, :utc_datetime
      add :is_current, :boolean, default: false
      add :is_deleted, :boolean, default: false
      add :time_of_change, :utc_datetime
      add :changed_by, :string
      
      timestamps(type: :utc_datetime)
    end
  end # end of change

end
