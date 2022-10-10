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

  def command_help_embed(command, usage, description) do
    %Nostrum.Struct.Embed{}
    |> put_title(command)
    |> put_field("**Usage: **", usage)
    |> put_field("**Description:: **", description)
  end
end
