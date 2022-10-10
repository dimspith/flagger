defmodule Flagger.Utils do
  import Nostrum.Struct.Embed

  ## Convert DateTime type to a formatted string
  def dt_to_string(dt) do
    with year <- dt.year,
         month <- String.pad_leading(Integer.to_string(dt.month), 2, "0"),
         day <- String.pad_leading(Integer.to_string(dt.day), 2, "0"),
         hour <- String.pad_leading(Integer.to_string(dt.hour), 2, "0"),
         minute <- String.pad_leading(Integer.to_string(dt.minute), 2, "0") do
      "#{day}-#{month}-#{year} #{hour}:#{minute}"
    end
  end

  ## Get the day of the week from a Datetime type
  def day_of_week(dt) do
    case Date.day_of_week(dt) do
      1 -> "Monday"
      2 -> "Tuesday"
      3 -> "Wednesday"
      4 -> "Thursday"
      5 -> "Friday"
      6 -> "Saturday"
      7 -> "Sunday"
    end
  end

  def list_to_mlstr(list) do
    list |> Enum.reduce("", fn item, acc -> acc <> item <> "\n" end)
  end

  def cog_help_embed(cog, cog_title) do
    %Nostrum.Struct.Embed{}
    |> put_title(cog_title)
    |> put_field("**Usage: **", list_to_mlstr(cog.usage()))
    |> put_field("**Description:: **", cog.description())
  end
end
