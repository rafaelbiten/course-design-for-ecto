defmodule Banq.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :description, :text
      add :balance, :integer

      timestamps()
    end
  end
end
