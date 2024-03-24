defmodule Flagger.Command do
  require Logger

  @callback usage() :: [String.t()]
  @callback description() :: String.t()
  @callback parse_args(args :: String.t()) :: any()
  @callback command(msg :: any(), args :: any()) :: any()

  defmacro __using__(_opts) do
    quote do
      @behaviour Flagger.Command

      require Logger

      def run(msg, args), do: Flagger.Command.run(__MODULE__, msg, args)
    end
  end

  def run(module, msg, args) do
    args = module.parse_args(args)
    Logger.debug("Executing command #{command_name(module)} with args: #{args}")

    case module.command(msg, args) do
      {:error, error} -> Nostrum.Api.create_message(msg.channel_id, error)
      _else -> :ok
    end
  end

  defp command_name(module) do
    module
    |> to_string()
    |> String.split(".")
    |> List.last()
  end
end
