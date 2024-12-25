import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :phnx_project_template_history, PhnxProjectTemplateHistory.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "phnx_project_template_history_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :phnx_project_template_history, PhnxProjectTemplateHistoryWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "kACTr1wKDCLk9o/+3qzFApkBHJ+S2IIRO7NK8Xi6BhyRmMR95JzyZcLFCsykRgZg",
  server: false

# In test we don't send emails
config :phnx_project_template_history, PhnxProjectTemplateHistory.Mailer,
  adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :phnx_project_template_history, PhnxProjectTemplateHistoryWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "L7hkyWc0TTCln3M8xD5wO6x/n0sVTPmadAofWx0bp9GbqBc0C7FJeHzVQN++VN5j",
  server: false

# In test we don't send emails
config :phnx_project_template_history, PhnxProjectTemplateHistory.Mailer,
  adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true
