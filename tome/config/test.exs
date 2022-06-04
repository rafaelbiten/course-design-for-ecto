import Config

config :tome, Tome.Repo,
  database: "tome_test",
  hostname: "localhost",
  username: "postgres",
  password: "postgres",
  pool: Ecto.Adapters.SQL.Sandbox
