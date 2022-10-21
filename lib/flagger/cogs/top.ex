defmodule Flagger.Cogs.Top do
  @behaviour Nosedrum.Command
  @moduledoc false

  import CTFTime

  import Nostrum.Struct.Embed

  defp top_embed(json) do
    with year <- Enum.at(Map.keys(json), 0),
         json <- json[year] do
      %Nostrum.Struct.Embed{}
      |> put_title("Top 10 CTF Teams of #{year}")
      |> put_description("from CTF-Time")
      |> put_url("https://ctftime.org/stats/2021")
      |> put_color(14_876_683)
      |> (fn x ->
        Enum.reduce(Enum.with_index(json), x, fn team, acc ->
          {team, index} = team

          put_field(
            acc,
            "#{index + 1}) #{team["team_name"]}",
            "Points: **#{round(team["points"])}**"
          )
        end)
      end).()
    end
  end

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
    case top(year) do
      {:ok, json} -> Nostrum.Api.create_message(msg.channel_id, content: "", embeds: [top_embed(json)])
      {:error, error} -> Nostrum.Api.create_message(msg.channel_id, content: error)
    end
  end
end

