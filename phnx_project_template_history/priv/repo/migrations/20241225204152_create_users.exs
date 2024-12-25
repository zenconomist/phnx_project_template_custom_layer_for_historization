Using custom migration template for table: users
create table(:users) do
  add :name, :string
  add :password, :string
  add :email, :string
  
  timestamps_with_deleted_at()
end


create table(:users_history) do
  add :entity_id, references(:users, on_delete: :nothing)
  add :dat_from, :utc_datetime
  add :dat_to, :utc_datetime
  add :is_current, :boolean, default: true
  add :name, :string
  add :password, :string
  add :email, :string
  
  timestamps_with_deleted_at()
end

create table(:users_field_log) do
  add :entity_id, references(:users, on_delete: :nothing)
  add :field, :string
  add :old_value, :string
  add :new_value, :string
  add :action, :string
  add :changed_at, :utc_datetime
  timestamps()
end