defmodule PhoenixDatatablesExample.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      PhoenixDatatablesExampleWeb.Telemetry,
      # Start the Ecto repository
      PhoenixDatatablesExample.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: PhoenixDatatablesExample.PubSub},
      # Start Finch
      {Finch, name: PhoenixDatatablesExample.Finch},
      # Start the Endpoint (http/https)
      PhoenixDatatablesExampleWeb.Endpoint
      # Start a worker by calling: PhoenixDatatablesExample.Worker.start_link(arg)
      # {PhoenixDatatablesExample.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhoenixDatatablesExample.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PhoenixDatatablesExampleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
