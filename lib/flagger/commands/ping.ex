defmodule Flagger.Commands.Ping do
  @moduledoc false

  use Flagger.Command
  alias Nostrum.Api

  @impl true
  def usage, do: ["ping"]

  @impl true
  def description, do: "Ping!"

  @impl true
  def parse_args(_args), do: nil

  @impl true
  def command(msg, _args) do
    Api.create_message(msg.channel_id, content: "pong!")
  end
end
