defmodule CTFTime do
  import HTTPoison
  import Nostrum.Struct.Embed
  import Flagger.Utils
  require Logger

  defp construct_top_embed(string) do
    with map <- Jason.decode!(string),
         year <- Enum.at(Map.keys(map), 0),
         json <- map[year] do
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

  def top_embed do
    case get("https://ctftime.org/api/v1/top/") do
      {:ok, response} -> construct_top_embed(response.body)
      {:error, _} -> "API Error, try again later."
    end
  end

  def top_embed(year) do
    case get("https://ctftime.org/api/v1/top/#{year}/") do
      {:ok, response} -> construct_top_embed(response.body)
      {:error, _} -> "API Error, try again later."
    end
  end

  defp construct_upcoming_embed(string) do
    with json <- Jason.decode!(string) do
      %Nostrum.Struct.Embed{}
      |> put_title("Upcoming CTFs")
      # |> put_description("-Time")
      # |> put_url("https://ctftime.org/stats/2021")
      |> put_color(35020)
      |> (fn x ->
            Enum.reduce(Enum.with_index(json), x, fn team, acc ->
              {team, index} = team
              days = team["duration"]["days"]
              hours = team["duration"]["hours"]
              {_, start, _} = DateTime.from_iso8601(team["start"])

              put_field(
                acc,
                "[#{index + 1}] #{team["title"]}",
                "**Start:** #{day_of_week(start)} #{dt_to_string(start)}, **Duration:** #{days} days, #{hours} hours"
              )
            end)
          end).()
    end
  end

  def upcoming_embed(date1, date2) do
    case get("https://ctftime.org/api/v1/events/?limit=50&start=#{date1}&finish=#{date2}") do
      {:ok, response} -> construct_upcoming_embed(response.body)
      {:error, _} -> "API Error, try again later."
    end
  end
end
