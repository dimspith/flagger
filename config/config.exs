import Config

config :nostrum,
  token: ""

config :logger,
  level: :warn

config :nosedrum,
  prefix: System.get_env("BOT_PREFIX") || ";"
