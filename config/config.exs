import Config

config :nostrum,
  token: ""

config :logger,
  level: :info

config :nosedrum,
  prefix: System.get_env("BOT_PREFIX") || ";"
