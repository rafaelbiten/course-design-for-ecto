defmodule Counts.Count do
  use Ecto.Schema
  alias Tome.Repo
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  @moduledoc """
  Module to serve as a playground to test concurrent DB updates
  and how to keep integrity with Repo.transaction or Ecto.Multi
  """

  # [CORE] Schema

  schema "counts" do
    field(:name, :string)
    field(:value, :integer, default: 0)
  end

  # [CORE] Changesets

  def create_changeset(name) do
    cast(%__MODULE__{}, %{name: name}, [:name])
  end

  def naive_increment_changeset(count) do
    cast(count, %{value: count.value + 1}, [:value])
  end

  # [CORE] Queries

  def new, do: Counts.Count

  # [BOUNDARY] DB Updates

  def create(name) do
    name
    |> create_changeset()
    |> Repo.insert!()
  end

  def get(name) do
    from(c in Counts.Count, where: c.name == ^name)
    |> Repo.one!()
  end

  def naive_increment(name) do
    name
    |> get()
    |> naive_increment_changeset()
    |> Repo.update!()
  end

  def increment(name) do
    from(c in Counts.Count, update: [inc: [value: 1]], where: c.name == ^name)
    |> Repo.update_all([])
  end

  @doc """
  Creates a new counter and runs the `naive_increment` fn a number of times in parallel

  ## Examples

  iex> Counts.Count.run_stream_of_naive_increments 1000
  :ok
  """
  @spec run_stream_of_naive_increments(integer) :: :ok
  def run_stream_of_naive_increments(increments) when is_integer(increments) do
    counter =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.to_string()
      |> create()

    IO.puts("➡️ Created a new counter named #{counter.name} with value 0")
    IO.puts("➡️ Run #{increments} naive increments in parallel")

    :ok =
      1..increments
      |> Task.async_stream(fn _ -> Counts.Count.naive_increment(counter.name) end)
      |> Stream.run()

    result = get(counter.name)

    IO.puts("➡️ Successfully called naive_increment #{increments} times in parallel")
    IO.puts("➡️ Final counter value is: #{result.value}. Expected: #{increments}")
  end

  @spec run_stream_of_increments(integer) :: :ok
  def run_stream_of_increments(increments) when is_integer(increments) do
    counter =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.to_string()
      |> create()

    IO.puts("➡️ Created a new counter named #{counter.name} with value 0")
    IO.puts("➡️ Run #{increments} increments in parallel")

    :ok =
      1..increments
      |> Task.async_stream(fn _ -> Counts.Count.increment(counter.name) end)
      |> Stream.run()

    result = get(counter.name)

    IO.puts("➡️ Successfully called increment #{increments} times in parallel")
    IO.puts("➡️ Final counter value is: #{result.value}. Expected: #{increments}")
  end
end
