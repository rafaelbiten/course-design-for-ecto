defmodule Banq.BankTest do
  use Banq.DataCase

  alias Banq.Bank

  describe "accounts" do
    alias Banq.Bank.Account

    import Banq.BankFixtures

    @invalid_attrs %{balance: nil, description: nil}

    test "list_accounts/0 returns all accounts" do
      account = account_fixture()
      assert Bank.list_accounts() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Bank.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      valid_attrs = %{balance: 42, description: "some description"}

      assert {:ok, %Account{} = account} = Bank.create_account(valid_attrs)
      assert account.balance == 42
      assert account.description == "some description"
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bank.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      update_attrs = %{balance: 43, description: "some updated description"}

      assert {:ok, %Account{} = account} = Bank.update_account(account, update_attrs)
      assert account.balance == 43
      assert account.description == "some updated description"
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Bank.update_account(account, @invalid_attrs)
      assert account == Bank.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = Bank.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Bank.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Bank.change_account(account)
    end
  end
end
