defmodule Flagger.Utils do
  import Nostrum.Struct.Embed

  def list_to_mlstr(list) do
    ## Convert 
    list |> Enum.reduce("", fn item, acc -> acc <> item <> "\n" end)
  end

  def unix_time_to_discord(time) do
    "<t:#{time}:R>"
  end

  def cog_help_embed(cog, cog_title) do
    %Nostrum.Struct.Embed{}
    |> put_title(cog_title)
    |> put_field("**Usage: **", list_to_mlstr(cog.usage()))
    |> put_field("**Description:: **", cog.description())
  end
end
