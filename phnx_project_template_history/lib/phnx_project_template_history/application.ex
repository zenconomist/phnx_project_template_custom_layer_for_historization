defmodule PhnxProjectTemplateHistory.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PhnxProjectTemplateHistoryWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:phnx_project_template_history, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PhnxProjectTemplateHistory.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: PhnxProjectTemplateHistory.Finch},
      # Start a worker by calling: PhnxProjectTemplateHistory.Worker.start_link(arg)
      # {PhnxProjectTemplateHistory.Worker, arg},
      # Start to serve requests, typically the last entry
      PhnxProjectTemplateHistoryWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhnxProjectTemplateHistory.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PhnxProjectTemplateHistoryWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
