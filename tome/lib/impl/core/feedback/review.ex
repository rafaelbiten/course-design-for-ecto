defmodule Tome.Feedback.Review do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc """
  Module with the Review schema and related changesets

  book = Repo.one (from Book, limit: 1)
  review = Review.new(book)
  cs = book
        |> Review.new
        |> Review.changeset(%{stars: 5})

  cs = %Review{} |> Review.changeset(%{stars: 5, book_id: 1})

  (from Book, preload: :reviews, limit: 1) |> Repo.one

  (from b in Book,
    join: r in Review,
    on: b.id == r.book_id,
    group_by: b.title,
    select: {count(r.id), b.title},
    order_by: count(r.id)
  ) |> Repo.all

  (from b in Book,
    join: r in Review,
    on: b.id == r.book_id,
    as: :review,
    group_by: b.title,
    select: {avg(as(:review).stars), b.title}
  ) |> Repo.all
  """

  # SCHEMA

  schema "reviews" do
    field(:stars, :integer)

    timestamps()
    belongs_to(:book, Tome.Library.Book)
  end

  # CONSTRUCT

  def new(%Tome.Library.Book{} = book) do
    Ecto.build_assoc(book, :reviews)
  end

  # CHANGESET

  def changeset(%__MODULE__{} = review, params \\ %{}) do
    review
    |> cast(params, [:stars, :book_id])
    |> validate_required([:stars, :book_id])
    |> validate_number(:stars, greater_than: 0, less_than: 6)
    |> assoc_constraint(:book)
  end
end
