defmodule Flagger.Cogs.Upcoming do
  @behaviour Nosedrum.Command
  @moduledoc false

  import CTFTime
  import Flagger.Utils
  require Logger
  @impl true
  def usage, do: ["upcoming <days>"]

  @impl true
  def description, do: "Display upcoming events up to <days> days away"

  @impl true
  def parse_args(args) when length(args) == 1 do
    first_int =
      args
      |> Enum.at(0)
      |> Integer.parse()

    case first_int do
      {days, _} -> time_range(days)
      _ -> :error
    end
  end

  def parse_args(_args), do: :error

  defp time_range(days) do
    from = DateTime.utc_now()
    to = from |> DateTime.add(days, :day)
    {from |> DateTime.to_unix(), to |> DateTime.to_unix()}
  end

  @impl true
  def predicates, do: []

  @impl true
  def command(msg, :error) do
    {:ok, _msg} =
      Nostrum.Api.create_message(
        msg.channel_id,
        content: "",
        embeds: [command_help_embed("Upcoming", hd(usage()), description())]
      )
  end

  @impl true
  def command(msg, args) do
    {from_date, to_date} = args
    response = upcoming_embed(from_date, to_date)
    {:ok, _msg} = Nostrum.Api.create_message(msg.channel_id, content: "", embeds: [response])
  end

  # def command(msg, dates) when length(dates) == 2 do
  #   dates = dates |> Enum.map(&DateTime.to_unix/1)
  #   [from_date, to_date] = dates
  #   response = CTFTime.upcoming(from_date, to_date)
  #   {:ok, _msg} = Nostrum.Api.create_message(msg.channel_id, content: "", embeds: [response])
  # end
end
