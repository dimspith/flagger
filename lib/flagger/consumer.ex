defmodule Flagger.Consumer do
  use Nostrum.Consumer

  require Logger

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    with true <- String.starts_with?(msg.content, ";"),
         [command | args] <- parse_command(msg.content),
         module <- Flagger.commands()[command],
         true <- module != nil do
      case args do
        [] -> module.run(msg, "")
        [args] -> module.run(msg, args)
      end
    else
      _error -> :ignore
    end
  end

  def handle_event(_event) do
    :noop
  end

  defp parse_command(command) do
    command
    |> String.slice(1..-1//1)
    |> String.split(" ", parts: 2)
  end
end
