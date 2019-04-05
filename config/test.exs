use Mix.Config

config :game_of_life, GameOfLifeWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :warn
