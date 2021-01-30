use Mix.Config

config :action_cube, ActionCubeWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :warn
