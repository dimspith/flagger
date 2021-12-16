defmodule Flagger.Cogs.Upcoming do
  @behaviour Nosedrum.Command
  @moduledoc false

  @impl true
  def usage, do: ["upcoming <from_date> <to_date>"]

  @impl true
  def description, do: "Display upcoming events in the supplied time period"

  @impl true
  def parse_args(args) do
    from_date = [Enum.at(args, 0), "T00:00:00Z"] |> Enum.join()
    to_date = [Enum.at(args, 1), "T23:59:00Z"] |> Enum.join()
    dates = [from_date, to_date] |> Enum.map(&DateTime.from_iso8601/1)
    cond do
      length(args) > 2 -> :too_many_args
      Enum.member?(dates, {:error, :invalid_format}) -> :invalid_format
      Enum.member?(dates, {:error, :invalid_date}) -> :invalid_date
      true ->
        [{_, from_date, _}, {_, to_date, _}] = dates
        [from_date, to_date]
    end
  end

  @impl true
  def predicates, do: []



  @impl true
  def command(msg, []) do
    response = "upcoming:"
    {:ok, _msg} = Nostrum.Api.create_message(msg.channel_id, response)    
  end

  def command(msg, :too_many_args) do
    response = "Too many arguments. Only two dates are required."
    {:ok, _msg} = Nostrum.Api.create_message(msg.channel_id, response)    
  end

  def command(msg, :invalid_format) do
    response = "Invalid format! Dates should look like this: **2021-12-31**"
    {:ok, _msg} = Nostrum.Api.create_message(msg.channel_id, response)
  end

  def command(msg, :invalid_date) do
    response = "Invalid date format! Check if your values are correct."
    {:ok, _msg} = Nostrum.Api.create_message(msg.channel_id, response)
  end

  def command(msg, dates) do
    dates = dates |> Enum.map(&DateTime.to_unix/1)
    [from_date, to_date] = dates
    response = CTFTime.upcoming(from_date, to_date)
    {:ok, _msg} = Nostrum.Api.create_message(msg.channel_id, content: "", embeds: [response])
  end
end
