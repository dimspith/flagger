defmodule CTFTime do
  import HTTPoison
  import Nostrum.Struct.Embed

  def top_embed(string) do
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

  def top do
    case get("https://ctftime.org/api/v1/top/") do
      {:ok, response} -> top_embed(response.body)
      {:error, _} -> "API Error, try again later."
    end
  end

  def top(year) do
    case get("https://ctftime.org/api/v1/top/#{year}/") do
      {:ok, response} -> top_embed(response.body)
      {:error, _} -> "API Error, try again later."
    end
  end
end
