defmodule CTFTime do
  import HTTPoison
  require Logger

  def top do
    case get("https://ctftime.org/api/v1/top/") do
      {:ok, response} -> {:ok, Jason.decode!(response.body)}
      {:error, _} -> {:error, "API Error, try again later."}
    end
  end

  def top(year) do
    case get("https://ctftime.org/api/v1/top/#{year}/") do
      {:ok, response} -> {:ok, Jason.decode!(response.body)}
      {:error, _} -> {:error, "API Error, try again later."}
    end
  end

  def upcoming(date1, date2) do
    case get("https://ctftime.org/api/v1/events/?limit=50&start=#{date1}&finish=#{date2}") do
      {:ok, response} -> {:ok, Jason.decode!(response.body)}
      {:error, _} -> {:error, "API Error, try again later."}
    end
  end
end
