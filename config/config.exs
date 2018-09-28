# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :elixir_todo_workshop,
  ecto_repos: [ElixirTodoWorkshop.Repo]

# Configures the endpoint
config :elixir_todo_workshop, ElixirTodoWorkshopWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "F8RS83K1tpGIGnfz9X6lgupsNXAe44ZxapwkGChvbrpDuVqduwjh7dHQcLG1dnSh",
  render_errors: [view: ElixirTodoWorkshopWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ElixirTodoWorkshop.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
