defmodule Tome.Library.Book do
  use Ecto.Schema
  # import Ecto.Changeset

  schema "books" do
    field(:title, :string)
    field(:isbn, :string)
    field(:description)
    field(:status, :string, default: "working")
    field(:published_on, :date, default: nil)

    timestamps()
  end
end
