defmodule Tome.Library.Book do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc """
  Module with the Book schema and related changesets
  """

  schema "books" do
    field(:title, :string)
    field(:isbn, :string)
    field(:description)
    field(:status, :string, default: "working")
    field(:published_on, :date, default: nil)

    timestamps()
  end

  def create_changeset(params \\ %{}) do
    %__MODULE__{}
    |> cast(params, ~w[title isbn description status published_on]a)
    |> validate_required(~w[title isbn status]a)
    |> validate_inclusion(:status, ~w[working published beta retired])
    |> unique_constraint(:isbn)
  end

  def update_changeset(%__MODULE__{} = book, params \\ %{}) do
    book
    |> cast(params, ~w[title description status published_on]a)
    |> validate_required(~w[title isbn status]a)
    |> validate_inclusion(:status, ~w[published beta retired])
    |> validate_published_on()
  end

  #  Implementation

  defp validate_published_on(changeset), do: require_published_on(changeset, book_status: get_field(changeset, :status))
  defp require_published_on(changeset, book_status: "published"), do: validate_required(changeset, [:published_on])
  defp require_published_on(changeset, book_status: _), do: changeset
end
