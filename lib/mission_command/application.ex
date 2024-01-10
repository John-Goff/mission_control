defmodule MissionCommand.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    Nx.global_default_backend({EXLA.Backend, client: :host})

    children = [
      MissionCommand.Chat
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MissionCommand.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
