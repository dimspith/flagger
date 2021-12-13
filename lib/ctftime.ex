defmodule CTFTime do
  import HTTPoison
  def top do
    case get("https://ctftime.org/api/v1/top/") do
      {:ok, response} -> response.body
      {:error, error} -> error
    end
  end

  def top(year) do
  end
end
