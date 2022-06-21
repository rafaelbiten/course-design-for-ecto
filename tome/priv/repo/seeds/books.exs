# Usage
# mix run priv/repo/seeds/books.exs

defmodule Seed do
  alias Tome.Repo
  alias Tome.Library.Book
  alias Tome.Feedback.Review

  @now NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)

  def books() do
    # Insert some real books
    real_books = [
      {"Designing Elixir Systems with OTP", "9781680506617", "Learn some OTP", :published, ~D[2019-12-01]},
      {"Progamming Ecto", "9781680502824", "Learn some Ecto", :published, ~D[2019-04-01]},
      {"Progamming Phoenix LiveView", "9781680508215", "Learn some LiveView", :beta, nil}
    ]

    Enum.each(real_books, fn {title, isbn, description, status, published_on} ->
      Repo.insert!(%Book{
        title: title,
        isbn: isbn,
        description: description,
        status: status,
        published_on: published_on,
        inserted_at: @now,
        updated_at: @now
      })
    end)

    # Insert some fake books
    statuses = ~w[working published beta retired]a

    Enum.each(1..30, fn n ->
      status = Enum.random(statuses)
      published_on = if status in ~w[published retired]a, do: Date.add(Date.utc_today(), -n), else: nil
      isbn = "1234567891234" |> String.split("", trim: true) |> Enum.shuffle() |> Enum.join()

      %Book{
        isbn: isbn,
        title: "Book title #{n}",
        description: "Book description #{n}",
        status: status,
        published_on: published_on,
        inserted_at: @now,
        updated_at: @now
      }
      |> Repo.insert!()
      |> maybe_add_review()
    end)
  end

  defp maybe_add_review(inserted_book) do
    if Enum.random([true, false]) do
      Repo.insert(%Review{
        stars: :random.uniform(5),
        book_id: inserted_book.id,
        inserted_at: @now,
        updated_at: @now
      })

      maybe_add_review(inserted_book)
    end
  end
end

# Seed the Database

Tome.Repo.delete_all(Book)
Tome.Repo.delete_all(Review)

Seed.books()
