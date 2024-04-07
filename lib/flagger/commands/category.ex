defmodule Flagger.Commands.Category do
  @moduledoc false

  use Flagger.Command
  alias Nostrum.Api

  @impl true
  def usage,
    do: [
      "category create <ctftime_link | event_id>",
    ]

  @impl true
  def description, do: "Create or delete a CTF"

  @impl true
  def parse_args(args) do
    String.split(args, " ", trim: true)
  end

  @impl true
  def command(_msg, args) when length(args) < 2 do
    {:error, "Insufficient arguments!"}
  end

  def command(msg, ["create", link | _rest]) do
    {:ok, event_info} = CTFTime.event_info(link)

    {:ok, category} = Api.create_guild_channel(msg.guild_id, type: 4, name: event_info["title"])

    Api.create_guild_channel(msg.guild_id,
      name: event_info["title"],
      topic: event_info["description"],
      parent_id: category.id
    )

    Api.create_guild_channel(msg.guild_id, name: "notes", parent_id: category.id)
    Api.create_message(msg.channel_id, content: "Created category for ##{event_info["title"]}")
  end
end
