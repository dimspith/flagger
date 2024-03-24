defmodule Flagger.Commands.Top do
  @moduledoc false

  use Flagger.Command

  import CTFTime

  import Nostrum.Struct.Embed

  @impl true
  def usage, do: ["top <year>"]

  @impl true
  def description, do: "Show the top CTF teams of the specified year."

  @impl true
  def parse_args(args) do
    args
    |> String.trim()
    |> Integer.parse()
    |> then(fn args ->
      case args do
        {year, _} when year > 2010 -> year
        _ -> :error
      end
    end)
  end

  @impl true
  def command(_msg, :error) do
    {:error, "Error: Invalid year!"}
  end

  @impl true
  def command(msg, year) do
    case top(year) do
      {:ok, json} ->
        Nostrum.Api.create_message(msg.channel_id, content: "", embeds: [top_embed(json)])

      {:error, error} ->
        Nostrum.Api.create_message(msg.channel_id, content: error)
    end
  end

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
end
