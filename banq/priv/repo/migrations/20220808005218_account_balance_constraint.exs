defmodule Banq.Repo.Migrations.AccountBalanceConstraint do
  use Ecto.Migration

  def change do
    create constraint("accounts", :balance_must_be_positive, check: "balance > 0")
  end
end

# mix ecto.gen.migration account_balance_constraint
# mix ecto.migrate
