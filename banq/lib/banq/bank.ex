defmodule Banq.Bank do
  @moduledoc """
  The Bank context.
  """

  alias Ecto.Multi
  import Ecto.Query, warn: false
  alias Banq.Repo

  alias Banq.Bank.Account

  @doc """
  Returns the list of accounts.

  ## Examples

      iex> list_accounts()
      [%Account{}, ...]

  """
  def list_accounts do
    Repo.all(Account)
  end

  @doc """
  Gets a single account.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

      iex> get_account!(123)
      %Account{}

      iex> get_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account!(id), do: Repo.get!(Account, id)

  @doc """
  Creates a account.

  ## Examples

      iex> create_account(%{field: value})
      {:ok, %Account{}}

      iex> create_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a account.

  ## Examples

      iex> update_account(account, %{field: new_value})
      {:ok, %Account{}}

      iex> update_account(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a account.

  ## Examples

      iex> delete_account(account)
      {:ok, %Account{}}

      iex> delete_account(account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account changes.

  ## Examples

      iex> change_account(account)
      %Ecto.Changeset{data: %Account{}}

  """
  def change_account(%Account{} = account, attrs \\ %{}) do
    Account.changeset(account, attrs)
  end

  @spec transfer(from_account_id: integer, to_account_id: integer, amount: integer) :: any
  def transfer(from_account_id: from_account_id, to_account_id: to_account_id, amount: amount) do
    # core related (safe)
    from_account = from(Account, where: [id: ^from_account_id])
    to_account = from(Account, where: [id: ^to_account_id])

    Multi.new()
    |> Multi.update_all(:withdraw, from_account, inc: [balance: -amount])
    |> Multi.update_all(:deposit, to_account, inc: [balance: amount])
    |> Multi.run(:check_transaction, &check_transaction/2)

    # boundary related (unsafe)
    |> Repo.transaction()
    |> case do
      {:ok, %{check_transaction: nil} = result} ->
        # Handle success case
        {:ok, result}

      {:error, action, _error, _changes_so_far} ->
        # Handle failure case, ie.:
        # {:error, :check_transaction, "Transfer failed", %{deposit: {0, nil}, withdraw: {1, nil}}}
        {:error, "Failed #{action}"}
    end
  end

  defp check_transaction(_repo, %{withdraw: {1, nil}, deposit: {1, nil}}), do: {:ok, nil}
  defp check_transaction(_repo, _changes_so_far), do: {:error, "Failed transaction check"}

  @spec transfer_run(from_account_id: integer, to_account_id: integer, amount: integer) :: any
  def transfer_run(from_account_id: from_account_id, to_account_id: to_account_id, amount: amount) do
    Multi.new()
    |> Multi.run(:transaction, fn repo, _ ->
      from_account = from(Account, where: [id: ^from_account_id], select: [:balance])
      to_account = from(Account, where: [id: ^to_account_id], select: [:balance])

      with {1, [withdrawal_account]} <- repo.update_all(from_account, inc: [balance: -amount]),
           {1, [deposit_account]} <- repo.update_all(to_account, inc: [balance: amount]) do
        IO.inspect(withdrawal_account.balance, label: "New withdrawal account balance:")
        IO.inspect(deposit_account.balance, label: "New deposit account balance:")
        {:ok, nil}
      else
        _ -> {:error, "Failed to transfer"}
      end
    end)
    |> Repo.transaction()
  end
end
