defmodule Tome.Library.Book do
  use Ecto.Schema
  import Ecto.Changeset

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
  end
end
