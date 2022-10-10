defmodule Flagger.Cogs.Top do
  @behaviour Nosedrum.Command
  @moduledoc false

  import CTFTime

  @impl true
  def usage, do: ["top <year>"]

  @impl true
  def description, do: "Show the top CTF teams of the specified year."

  @impl true
  def parse_args([year_str] = args) when length(args) == 1 do
    case Integer.parse(year_str) do
      {year, _} when year > 2010 -> year
      _ -> :error
    end
  end

  def parse_args(_args), do: :error

  @impl true
  def predicates, do: []

  @impl true

  def command(msg, :error) do
    {:ok, _msg} = Nostrum.Api.create_message(msg.channel_id, content: "Invalid year")
  end

  def command(msg, year) do
    {:ok, _msg} =
      Nostrum.Api.create_message(msg.channel_id, content: "", embeds: [top_embed(year)])
  end
end
