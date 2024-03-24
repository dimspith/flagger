defmodule Flagger.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Flagger.Consumer,
      {CubDB, data_dir: "./kvdb", auto_compact: true}
    ]

    opts = [strategy: :one_for_one, name: Flagger.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
