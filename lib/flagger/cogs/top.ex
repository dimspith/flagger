defmodule Flagger.Cogs.Top do
  @behaviour Nosedrum.Command
  @moduledoc false

  @impl true
  def usage, do: ["top <year>"]

  @impl true
  def description, do: "Show the top ctf teams of the specified year."

  @impl true
  def parse_args([]), do: []
  def parse_args(args) when length(args) >= 2, do: :mul_args
  def parse_args(args) do
    first = Enum.at(args, 0)
    int = Integer.parse(first)
    cond do
      int == :error -> :error
      elem(int, 0) < 2011 -> :inv_year
      true -> elem(int, 0)
    end
  end

  @impl true
  def predicates, do: []

  @impl true
  def command(msg, []) do
    {:ok, _msg} =
      Nostrum.Api.create_message(msg.channel_id, content: "", embeds: [CTFTime.top()])
  end

  def command(msg, :error) do
    {:ok, _msg} =
      Nostrum.Api.create_message(msg.channel_id, content: "Not a valid year!")
  end

  def command(msg, :mul_args) do
    {:ok, _msg} =
      Nostrum.Api.create_message(msg.channel_id, content: "Multiple arguments are not supported!")
  end

  def command(msg, :inv_year) do
    {:ok, _msg} =
      Nostrum.Api.create_message(msg.channel_id, content: "Year must be after 2010!")
  end

  def command(msg, year) do
    {:ok, _msg} =
      Nostrum.Api.create_message(msg.channel_id, content: "", embeds: [CTFTime.top(year)])
  end
end
