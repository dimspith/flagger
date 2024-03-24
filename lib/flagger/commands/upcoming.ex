defmodule Flagger.Commands.Upcoming do
  @moduledoc false

  use Flagger.Command

  import CTFTime
  import Flagger.Utils
  import Nostrum.Struct.Embed
  require Logger

  @impl true
  def usage, do: ["upcoming <days>"]

  @impl true
  def description, do: "Display upcoming events up to <days> days away"

  @impl true
  def parse_args(""), do: 7

  def parse_args(args) do
    args
    |> String.trim()
    |> Integer.parse()
    |> then(fn args ->
      case args do
        {days, _} -> days
        _ -> :error
      end
    end)
  end

  @impl true
  def command(msg, :error),
    do: Nostrum.Api.create_message(msg.channel_id, content: "Invalid arguments")

  @impl true
  def command(msg, days) do
    {from_date, to_date} = time_range(days)

    case upcoming(from_date, to_date) do
      {:ok, json} ->
        Nostrum.Api.create_message(msg.channel_id,
          content: "",
          embeds: [upcoming_embed(json, days)]
        )

      {:error, error} ->
        Nostrum.Api.create_message(msg.channel_id, content: error)
    end
  end

  defp upcoming_embed(json, days) do
    %Nostrum.Struct.Embed{}
    |> put_title("Upcoming CTFs (#{days} days)")
    |> put_description("Found `#{length(json)}` CTFs.")
    |> put_color(35020)
    |> put_url("https://ctftime.org/event/list/upcoming")
    |> put_thumbnail("https://placekitten.com/700/500")
    |> put_timestamp(DateTime.utc_now() |> DateTime.to_iso8601())
    |> (fn x ->
          Enum.reduce(Enum.with_index(json), x, fn {team, index}, acc ->
            days = team["duration"]["days"]
            hours = team["duration"]["hours"]
            {_, start, _} = DateTime.from_iso8601(team["start"])

            acc
            |> put_field(
              "#{index + 1}. #{team["title"]}",
              "Starts " <>
                unix_time_to_discord(DateTime.to_unix(start)) <>
                "\n**Duration:** #{days} days #{hours} hours" <>
                "\n**[LINK](#{team["url"]})** - " <> "**[CTFTIME](#{team["ctftime_url"]})**",
              true
            )
          end)
        end).()
  end

  defp time_range(days) do
    ## Time range from now to some days aways

    from = DateTime.utc_now()
    to = from |> DateTime.add(days, :day)
    {from |> DateTime.to_unix(), to |> DateTime.to_unix()}
  end
end
