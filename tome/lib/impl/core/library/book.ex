defmodule Tome.Library.Book do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc """
  Module with the Book schema and related changesets
  """

  def list_valid_statuses, do: Ecto.Enum.values(__MODULE__, :status)

  # SCHEMA

  schema "books" do
    field(:title, :string)
    field(:isbn, :string)
    field(:description)
    field(:status, Ecto.Enum, values: ~w[working published beta retired]a, default: :working)
    field(:published_on, :date, default: nil)
    field(:count, :integer, default: 0)

    timestamps()
    has_many(:reviews, Tome.Feedback.Review)
  end

  # CHANGESET

  def create_changeset(params \\ %{}) do
    %__MODULE__{}
    |> cast(params, ~w[title isbn description status published_on]a)
    |> validate_required(~w[title isbn status]a)
    |> unique_constraint(:isbn)
  end

  def update_changeset(%__MODULE__{} = book, params \\ %{}) do
    book
    |> cast(params, ~w[title description status published_on]a)
    |> validate_required(~w[title isbn status]a)
    |> validate_inclusion(:status, ~w[published beta retired]a)
    |> validate_published_on()
  end

  #  Implementation

  defp validate_published_on(changeset) do
    case get_field(changeset, :status) in [:published, :beta] do
      true -> validate_required(changeset, [:published_on])
      _ -> changeset
    end
  end

  # |> validate_required_when(%{key: :status, value: "published"}, require_field: :published_on)
  # defp validate_required_when(changeset, %{key: key, value: value}, require_field: require_field) do
  #   field_value = get_field(changeset, key)

  #   case field_value == value do
  #     true -> validate_required(changeset, require_field)
  #     _ -> changeset
  #   end
  # end

  # CONVERT

  def to_json(%__MODULE__{} = book) do
    book
    |> Map.from_struct()
    |> Map.drop([:__meta__, :id])
    |> Poison.encode!()
  end
end
