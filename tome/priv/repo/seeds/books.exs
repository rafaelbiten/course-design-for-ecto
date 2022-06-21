# Usage
# mix run priv/repo/seeds/books.exs

import Ecto.Query, only: [from: 2]

alias Tome.Repo
alias Tome.Library.Book
alias Tome.Feedback.Review

# Seed the Database

Tome.Repo.delete_all(Review)
Tome.Repo.delete_all(Book)

now = NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)

# Insert real books

real_books = [
  {"Designing Elixir Systems with OTP", "9781680506617", "Learn some OTP", :published, ~D[2019-12-01]},
  {"Progamming Ecto", "9781680502824", "Learn some Ecto", :published, ~D[2019-04-01]},
  {"Progamming Phoenix LiveView", "9781680508215", "Learn some LiveView", :beta, nil}
]

Repo.insert_all(
  Book,
  Enum.map(real_books, fn {title, isbn, description, status, published_on} ->
    %{
      title: title,
      isbn: isbn,
      description: description,
      status: status,
      published_on: published_on,
      inserted_at: now,
      updated_at: now
    }
  end)
)

# Insert fake books

statuses = ~w[working published beta retired]a

Repo.insert_all(
  Book,
  Enum.map(1..30, fn n ->
    status = Enum.random(statuses)
    published_on = if status in ~w[published retired]a, do: Date.add(Date.utc_today(), -n), else: nil
    isbn = "1234567891234" |> String.split("", trim: true) |> Enum.shuffle() |> Enum.join()

    %{
      isbn: isbn,
      title: "Book title #{n}",
      description: "Book description #{n}",
      status: status,
      published_on: published_on,
      inserted_at: now,
      updated_at: now
    }
  end)
)

# Insert fake reviews

book_ids = Repo.all(from(Book, select: [:id])) |> Enum.map(&Map.get(&1, :id))

Repo.insert_all(
  Review,
  Enum.map(1..100, fn n ->
    one_day = 60 * 60 * 24
    days_ago = -:random.uniform(one_day * 100)
    time = NaiveDateTime.add(now, days_ago)

    %{
      stars: :random.uniform(5),
      book_id: Enum.random(book_ids),
      inserted_at: time,
      updated_at: time
    }
  end)
)
