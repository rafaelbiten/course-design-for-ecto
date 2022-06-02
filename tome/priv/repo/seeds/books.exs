# Usage
# mix run priv/repo/seeds/books.exs

Tome.Repo.delete_all(Tome.Library.Book)

now = NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)

raw_books = [
  {"Designing Elixir Systems with OTP", "9781680506617", "Learn some OTP", "published", ~D[2019-12-01]},
  {"Progamming Ecto", "9781680502824", "Learn some Ecto", "published", ~D[2019-04-01]},
  {"Progamming Phoenix LiveView", "9781680508215", "Learn some LiveView", "beta", nil}
]

books =
  Enum.map(raw_books, fn {title, isbn, description, status, published_on} ->
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

Tome.Repo.insert_all(Tome.Library.Book, books)
