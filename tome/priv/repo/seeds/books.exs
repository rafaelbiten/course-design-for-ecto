# Usage
# mix run priv/repo/seeds/books.exs

Tome.Repo.delete_all(Tome.Core.Book)

now = NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)

# Insert some real books

real_books = [
  {"Designing Elixir Systems with OTP", "9781680506617", "Learn some OTP", :published, ~D[2019-12-01]},
  {"Progamming Ecto", "9781680502824", "Learn some Ecto", :published, ~D[2019-04-01]},
  {"Progamming Phoenix LiveView", "9781680508215", "Learn some LiveView", :beta, nil}
]

Tome.Repo.insert_all(
  Tome.Core.Book,
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

# Insert some fake books

statuses = ~w[working published beta retired]a

Tome.Repo.insert_all(
  Tome.Core.Book,
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
