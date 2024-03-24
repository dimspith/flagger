defmodule Flagger do
  @commands %{
    "help" => Flagger.Commands.Help,
    "top" => Flagger.Commands.Top,
    "upcoming" => Flagger.Commands.Upcoming,
    "ping" => Flagger.Commands.Ping
  }

  def commands, do: @commands
end
