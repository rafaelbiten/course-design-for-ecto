defmodule Banq.Bank.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :balance, :integer
    field :description, :string

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:description, :balance])
    |> validate_required([:description, :balance])
  end
end
