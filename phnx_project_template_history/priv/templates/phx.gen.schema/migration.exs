<%= IO.inspect "Using custom migration template for table: #{schema.table}" %>
create table(:<%= schema.table %>) do
  <%= for {k, v} <- schema.types do %>add :<%= k %>, :<%= v %><%= schema.defaults[k] %>
  <% end %>
  timestamps_with_deleted_at()
end


create table(:<%= schema.table %>_history) do
  add :entity_id, references(:<%= schema.table %>, on_delete: :nothing)
  add :dat_from, :utc_datetime
  add :dat_to, :utc_datetime
  add :is_current, :boolean, default: true
  <%= for {k, v} <- schema.types do %>add :<%= k %>, :<%= v %><%= schema.defaults[k] %>
  <% end %>
  timestamps_with_deleted_at()
end

create table(:<%= schema.table %>_field_log) do
  add :entity_id, references(:<%= schema.table %>, on_delete: :nothing)
  add :field, :string
  add :old_value, :string
  add :new_value, :string
  add :action, :string
  add :changed_at, :utc_datetime
  timestamps()
