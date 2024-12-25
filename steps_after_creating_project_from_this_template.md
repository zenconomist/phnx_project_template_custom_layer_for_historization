# 1. Setting Up and Configuring Ecto

Once you’ve cloned the template project, follow these steps to set up Ecto:

Step 1.1: Add Ecto Dependencies

In the mix.exs file of the new project, add Ecto and the database adapter dependencies:

```elixir
defp deps do
  [
    {:ecto_sql, "~> 3.10"},
    {:postgrex, ">= 0.0.0"}, # Replace `postgrex` with your adapter, if different
    {:phoenix_ecto, "~> 4.4"}
  ]
end
```

Install the dependencies:

```bash
mix deps.get
```

## Step 1.2: Configure the Repo

1.	Create a Repo module in lib/<project_name>/repo.ex:

```elixir
defmodule <ProjectName>.Repo do
  use Ecto.Repo,
    otp_app: :<project_name>,
    adapter: Ecto.Adapters.Postgres
end
```

2.	Update config/config.exs to include the database configuration:

```elixir
config :<project_name>, <ProjectName>.Repo,
  username: "postgres",
  password: "postgres",
  database: "<project_name>_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
```

3.	Update lib/<project_name>.application.ex to include the Repo as part of your supervision tree:

```elixir
def start(_type, _args) do
  children = [
    <ProjectName>.Repo,
    # Other workers and supervisors...
  ]

  opts = [strategy: :one_for_one, name: <ProjectName>.Supervisor]
  Supervisor.start_link(children, opts)
end
```

## Step 1.3: Generate a Migration Directory

Run the following command to set up a migration directory and enable Ecto’s migration system:

```bash
mix ecto.gen.repo -r <ProjectName>.Repo
```

## Step 1.4: Add Custom Generators and Migrations

Since your template includes custom generator templates (e.g., for deleted_at, history, and field_logs), set the generator templates in mix.exs:

```elixir
def project do
  [
    # Other project settings...
    generators: [
      migration: "priv/templates/phx.gen.context/migration.exs",
      context: "priv/templates/phx.gen.context",
      html: "priv/templates/phx.gen.html"
    ]
  ]
end
```

Generate a migration for your first table:

```bash
mix ecto.gen.migration create_users
```

## Step 1.5: Create the Database

Once configured, create the database:

```bash
mix ecto.create
```

Run your migrations:

```bash
mix ecto.migrate
```
