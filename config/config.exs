use Mix.Config

config :action_cube, ActionCubeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Z9nTGzcv94Xigr4mclk2bugUzdfOTsvBVsFx8zczbFVPcV9hIh59cLgyE7oEldbX",
  render_errors: [view: ActionCubeWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: ActionCube.PubSub,
  live_view: [signing_salt: "ixz/VHENhl4TOIw6NMmnvX5qwdvH2p4K"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

if File.exists?("config/#{Mix.env()}.exs"), do: import_config("#{Mix.env()}.exs")
