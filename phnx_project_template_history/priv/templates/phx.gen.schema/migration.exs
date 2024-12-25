defmodule <%= inspect schema.repo %>.Migrations.Create<%= Macro.camelize(schema.table) %> do
  use <%= inspect schema.migration_module %>
  import PhnxProjectTemplateHistory.SchemaHelpers

  def change do
    create table(:<%= schema.table %><%= if schema.binary_id do %>, primary_key: false<% end %><%= if schema.prefix do %>, prefix: :<%= schema.prefix %><% end %>) do
  <%= if schema.binary_id do %>      add :id, :binary_id, primary_key: true
  <% end %><%= for {k, v} <- schema.attrs do %>      add <%= inspect k %>, <%= inspect Mix.Phoenix.Schema.type_for_migration(v) %><%= schema.migration_defaults[k] %>
  <% end %><%= for {_, i, _, s} <- schema.assocs do %>      add <%= inspect(i) %>, references(<%= inspect(s) %>, on_delete: :nothing<%= if schema.binary_id do %>, type: :binary_id<% end %>)
  <% end %>
        PhnxProjectTemplateHistory.SchemaHelpers.timestamps_with_deleted_at()
      end
  <%= if Enum.any?(schema.indexes) do %><%= for index <- schema.indexes do %>
      <%= index %><% end %>
  <% end %>  end

  

  def change do
    create table(:<%= schema.table %>_history) do
      add :entity_id, references(:<%= schema.table %>, on_delete: :nothing)
      add :dat_from, :utc_datetime
      add :dat_to, :utc_datetime
      add :is_current, :boolean, default: true
      <%= for {k, v} <- schema.types do %>add :<%= k %>, :<%= v %><%= schema.defaults[k] %>
      <% end %>
      PhnxProjectTemplateHistory.SchemaHelpers.timestamps_with_deleted_at()
    end
  end


  def change do
    create table(:<%= schema.table %>_field_log) do
      add :entity_id, references(:<%= schema.table %>, on_delete: :nothing)
      add :field, :string
      add :old_value, :string
      add :new_value, :string
      add :action, :string
      add :changed_at, :utc_datetime
      PhnxProjectTemplateHistory.SchemaHelpers.timestamps_with_deleted_at()
    end
  end

end
