defmodule Banq.BankFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Banq.Bank` context.
  """

  @doc """
  Generate a account.
  """
  def account_fixture(attrs \\ %{}) do
    {:ok, account} =
      attrs
      |> Enum.into(%{
        balance: 42,
        description: "some description"
      })
      |> Banq.Bank.create_account()

    account
  end
end
