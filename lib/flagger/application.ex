defmodule Flagger.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Nosedrum.Storage.ETS,
      Flagger.CommandConsumer
    ]

    opts = [strategy: :one_for_one, name: Flagger.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
