defmodule Flagger.Utils do
  def list_to_mlstr(list) do
    list |> Enum.reduce("", fn item, acc -> acc <> item <> "\n" end)
  end

  def unix_time_to_discord(time) do
    "<t:#{time}:R>"
  end
end
