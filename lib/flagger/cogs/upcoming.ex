defmodule Flagger.Cogs.Upcoming do
  @behaviour Nosedrum.Command
  @moduledoc false

  import CTFTime
  import Flagger.Utils
  import Nostrum.Struct.Embed
  require Logger

  defp upcoming_embed(json) do
    ## Construct an embed of upcoming CTFs

    %Nostrum.Struct.Embed{}
    |> put_title("Upcoming CTFs")
    |> put_description("I found `#{length(json)}` CTFs.")
    |> put_color(35020)
    |> put_url("https://ctftime.org/event/list/upcoming")
    |> put_thumbnail("https://placekitten.com/700/500")
    |> put_timestamp(DateTime.utc_now() |> DateTime.to_iso8601())
    |> (fn x ->
      Enum.reduce(Enum.with_index(json), x,
        fn {team, index}, acc ->
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

  
  @impl true
  def usage, do: ["upcoming <days>"]

  @impl true
  def description, do: "Display upcoming events up to <days> days away"

  @impl true
  def parse_args([]), do: :ok
  def parse_args(_args), do: :help

  @impl true
  def predicates, do: []

  @impl true
  def command(msg, :help) do
    {:ok, _msg} =
      Nostrum.Api.create_message(
        msg.channel_id,
        content: "",
        embeds: [cog_help_embed(__MODULE__, "Upcoming")]
      )
  end

  @impl true
  def command(msg, :ok) do
    {from_date, to_date} = time_range(7)
    case upcoming(from_date, to_date) do
      {:ok, json} -> Nostrum.Api.create_message(msg.channel_id, content: "", embeds: [upcoming_embed(json)])
      {:error, error} -> Nostrum.Api.create_message(msg.channel_id, content: error)
    end
  end
end
