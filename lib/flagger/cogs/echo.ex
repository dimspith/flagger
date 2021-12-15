defmodule Flagger.Cogs.Echo do
  @behaviour Nosedrum.Command
  @moduledoc false

  @impl true
  def usage, do: ["echo <text...>"]

  @impl true
  def description, do: "display a line of text"

  @impl true
  def parse_args(args), do: Enum.join(args, " ")

  @impl true
  def predicates, do: []

  @impl true
  def command(msg, "") do
    response = "Need something to echo"
    {:ok, _msg} = Nostrum.Api.create_message(msg.channel_id, response)
  end

  def command(msg, text) do
    {:ok, _msg} = Nostrum.Api.create_message(msg.channel_id, text)
  end
end
