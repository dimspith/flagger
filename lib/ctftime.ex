defmodule CTFTime do
  import Req
  require Logger

  def top do
    case get("https://ctftime.org/api/v1/top/") do
      {:ok, response} -> {:ok, response.body}
      {:error, _} -> {:error, "API Error, try again later."}
    end
  end

  def top(year) do
    case get("https://ctftime.org/api/v1/top/#{year}/") do
      {:ok, response} -> {:ok, response.body}
      {:error, _} -> {:error, "API Error, try again later."}
    end
  end

  def upcoming(date1, date2) do
    case get("https://ctftime.org/api/v1/events/?limit=50&start=#{date1}&finish=#{date2}") do
      {:ok, response} -> {:ok, response.body}
      {:error, _} -> {:error, "API Error, try again later."}
    end
  end

  def event_info(event_id) when is_integer(event_id) do
    case get("https://ctftime.org/api/v1/events/#{event_id}/") do
      {:ok, response} -> {:ok, response.body}
      {:error, _} -> {:error, "API Error, try again later."}
    end
  end

  def event_info(link) when is_binary(link) do
    link
    |> URI.parse()
    |> then(& &1.path)
    |> String.split("/", trim: true)
    |> List.last()
    |> String.to_integer()
    |> event_info()
    |> dbg
  end
end
