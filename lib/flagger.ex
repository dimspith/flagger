defmodule Flagger do
  @commands %{
    "help" => Flagger.Commands.Help,
    "top" => Flagger.Commands.Top,
    "upcoming" => Flagger.Commands.Upcoming,
    "ping" => Flagger.Commands.Ping,
    "ctf" => Flagger.Commands.CTF,
    "category" => Flagger.Commands.Category
  }

  def commands, do: @commands
end
