defmodule Flagger.Commands.Help do
  @moduledoc false

  use Flagger.Command
  import Nostrum.Struct.Embed
  alias Nostrum.Api

  @impl true
  def usage, do: ["help <command>"]

  @impl true
  def description, do: "Show help for a specific command"

  @impl true
  def parse_args(args), do: String.trim(args)

  @impl true
  def command(msg, command) do
    case Flagger.commands()[command] do
      nil ->
        Api.create_message(msg.channel_id, content: "Unknown command")

      module ->
        embed =
          %Nostrum.Struct.Embed{}
          |> put_title("Upcoming")
          |> put_description(module.description())
          |> put_color(14_876_683)
          |> then(fn embed ->
            Enum.reduce(module.usage(), embed, fn example, embed ->
              put_field(embed, "Example:", example)
            end)
          end)

        Nostrum.Api.create_message(msg.channel_id, content: "", embeds: [embed])
    end
  end
end
