# Project template setup

To create a template project that includes the desired features, you can follow these steps to implement a clean and reusable setup in your Phoenix application. This involves integrating soft deletes, SCD2 historization, field logging, and a service layer, while modifying Phoenix generators to use the service layer by default.

---
## 1. Base Project Setup

1.	Generate a New Phoenix Project:

```bash
mix phx.new my_template_project --no-ecto --no-assets
cd my_template_project
```

2.	Add Ecto and Database Dependencies:

Update mix.exs with Ecto and PostgreSQL (or your preferred DB) dependencies:

```elixir
defp deps do
  [
    {:ecto_sql, "~> 3.10"},
    {:postgrex, ">= 0.0.0"},
    {:phoenix_ecto, "~> 4.4"},
    {:phoenix_html, "~> 3.3"}
  ]
end
```

```bash
mix deps.get
```

3.	Configure Ecto Repo:

In config/dev.exs, add your database configuration:


```elixir
config :my_template_project, MyTemplateProject.Repo,
  username: "postgres",
  password: "postgres",
  database: "my_template_project_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
```

Create the Repo module in lib/my_template_project/repo.ex:


```elixir
defmodule MyTemplateProject.Repo do
  use Ecto.Repo,
    otp_app: :my_template_project,
    adapter: Ecto.Adapters.Postgres
end
```

Run:

```bash
mix exto.create
```

---
## 2. Soft Deletes

Add deleted_at Field to Every Table
1.	Create a custom timestamps_with_deleted_at macro in lib/my_template_project/schema_helpers.ex:

```elixir
defmodule MyTemplateProject.SchemaHelpers do
  defmacro timestamps_with_deleted_at(opts \\ []) do
    quote do
      timestamps(unquote(opts))
      field :deleted_at, :utc_datetime
    end
  end
end
```

2.	Modify phx.gen.migration to add deleted_at automatically.
Create a custom generator template in priv/templates/phx.gen.context/migration.exs:

```elixir
create table(:<%= schema.table %>) do
  <%= for {k, v} <- schema.types do %>add :<%= k %>, :<%= v %><%= schema.defaults[k] %>
  <% end %>
  timestamps()
  add :deleted_at, :utc_datetime
end
```

3.	Update schema definitions to use the new macro:

```elixir
use MyTemplateProject.SchemaHelpers

schema "users" do
  field :name, :string
  timestamps_with_deleted_at()
end
```
---
## 3. Modify Repo Functions


Create wrapper functions in lib/my_template_project/repo_helpers.ex to exclude soft-deleted records by default:

```elixir
defmodule MyTemplateProject.RepoHelpers do
  import Ecto.Query

  alias MyTemplateProject.Repo

  def get!(queryable, id) do
    Repo.one!(from q in queryable, where: q.id == ^id and is_nil(q.deleted_at))
  end

  def get_all(queryable) do
    Repo.all(from q in queryable, where: is_nil(q.deleted_at))
  end
end
```

---

## 4. Field Logging and SCD2

Field Log Table Migration

Add a migration for the field_logs table:

```elixir
create table(:field_logs) do
  add :entity_type, :string
  add :entity_id, :integer
  add :field, :string
  add :old_value, :string
  add :new_value, :string
  add :action, :string
  add :changed_at, :utc_datetime
  timestamps()
end
```

History Table Generation

Modify the generator templates to include a history table for every model:

```elixir
create table(:<%= schema.table %>_history) do
  add :entity_id, references(:<%= schema.table %>, on_delete: :nothing)
  add :dat_from, :utc_datetime
  add :dat_to, :utc_datetime
  add :is_current, :boolean, default: true
  <%= for {k, v} <- schema.types do %>add :<%= k %>, :<%= v %><%= schema.defaults[k] %>
  <% end %>
  timestamps()
end
```

---

## 5. Service Layer

Implement a centralized service layer to abstract database operations and handle transactions for logging, SCD2, and soft deletes.

Example in lib/my_template_project/service_layer.ex:


```elixir
defmodule MyTemplateProject.ServiceLayer do
  alias MyTemplateProject.{RepoHelpers, Repo}

  def get!(schema, id), do: RepoHelpers.get!(schema, id)

  def get_all(schema), do: RepoHelpers.get_all(schema)

  def create(schema_module, attrs) do
    changeset = schema_module.changeset(%schema_module{}, attrs)

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
  end

  defp insert_scd2_version(record) do
    # Implement logic to insert into SCD2 history table
  end

  defp mark_scd2_inactive(record) do
    # Implement logic to mark SCD2 record as inactive
  end
end
```

---

## 6. Modify Generators to Use the Service Layer

Update generator templates in priv/templates to use the service layer:

Example for context.ex template (priv/templates/phx.gen.context/context.ex):


```elixir
def list_<%= schema.plural %> do
  MyTemplateProject.ServiceLayer.get_all(<%= inspect schema.module %>)
end

def get_<%= schema.singular %>!(id) do
  MyTemplateProject.ServiceLayer.get!(<%= inspect schema.module %>, id)
end

def create_<%= schema.singular %>(attrs \\ %{}) do
  MyTemplateProject.ServiceLayer.create(<%= inspect schema.module %>, attrs)
end

def update_<%= schema.singular %>(%<%= inspect schema.alias %>{} = <%= schema.singular %>, attrs) do
  MyTemplateProject.ServiceLayer.update(<%= schema.singular %>, attrs)
end

def delete_<%= schema.singular %>(%<%= inspect schema.alias %>{} = <%= schema.singular %>) do
  MyTemplateProject.ServiceLayer.delete(<%= schema.singular %>)
end
```

## 7. Save as a Template Project

1.	Commit Changes to Git:

```bash
git init
git add .
git commit -m "Initial commit with soft deletes, SCD2, and service layer"
```

2.	Reuse for New Projects:
Clone the repository and rename it for new projects:

```bash
git clone https://github.com/your-repo/my_template_project new_project
cd new_project
rm -rf .git
git init
```


---
templates

```bash

```

```elixir

```