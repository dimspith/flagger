defmodule Flagger.Consumer do
  use Nostrum.Consumer

  alias Nosedrum.Invoker.Split, as: CommandInvoker
  alias Nosedrum.Storage.ETS, as: CommandStorage

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  @commands %{
    "echo" => Flagger.Cogs.Echo,
    "top" => Flagger.Cogs.Top
  }

  def handle_event({:READY, _data, _ws_state}) do
    Enum.each(@commands, fn {name, cog} -> CommandStorage.add_command([name], cog) end)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    CommandInvoker.handle_message(msg, CommandStorage)
  end

  def handle_event(_data), do: :ok
  # "!top" ->
  #   Api.create_message(msg.channel_id, content: "", embeds: [CTFTime.top(2021)])
end
