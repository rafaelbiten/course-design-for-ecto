defmodule Tome.Repo do
  use Ecto.Repo,
    otp_app: :tome,
    adapter: Ecto.Adapters.Postgres

  if Mix.env() in [:dev, :test] do
    def truncate(tome_ecto_schema) do
      table_name = tome_ecto_schema.__schema__(:source)
      query("TRUNCATE TABLE #{table_name} RESTART IDENTITY CASCADE")
    end
  end
end
