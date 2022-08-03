defmodule Banq.Repo do
  use Ecto.Repo,
    otp_app: :banq,
    adapter: Ecto.Adapters.Postgres
end
