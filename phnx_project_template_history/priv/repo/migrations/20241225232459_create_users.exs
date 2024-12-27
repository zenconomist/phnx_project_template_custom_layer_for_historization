defmodule PhnxProjectTemplateHistory.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
        add :name, :string
        add :email, :string
        add :password, :string
  
      timestamps(type: :utc_datetime)
      add :deleted_at, :utc_datetime
      end
  
      create unique_index(:users, [:email])
  

  
    create table(:users_history) do
      add :entity_id, references(:users, on_delete: :nothing)
      add :dat_from, :utc_datetime
      add :dat_to, :utc_datetime
      add :is_current, :boolean, default: true
      add :name, :string
      add :password, :string
      add :email, :string
      
      timestamps(type: :utc_datetime)
  
    end

    create table(:users_field_log) do
      add :entity_id, references(:users, on_delete: :nothing)
      add :field, :string
      add :old_value, :string
      add :new_value, :string
      add :action, :string
      add :changed_at, :utc_datetime
      timestamps(type: :utc_datetime)
    end

  end # end of change

end