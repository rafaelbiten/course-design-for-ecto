import Config

config :logger, level: :info
config :tome, ecto_repos: [Tome.Repo]

import_config "#{Mix.env()}.exs"
