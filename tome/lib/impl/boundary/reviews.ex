defmodule Tome.Boundary.Reviews do
  alias Tome.Repo
  alias Tome.Feedback.Review

  def review(%Tome.Library.Book{} = book, stars) do
    review(book.id, stars)
  end

  def review(book_id, stars) do
    %Tome.Library.Book{}
    |> Review.new()
    |> Review.changeset(%{stars: stars, book_id: book_id})
    |> Repo.insert!()
  end
end
