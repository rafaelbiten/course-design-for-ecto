defmodule Tome.Library.BookQuery do
  import Ecto.Query, only: [from: 2]
  alias Tome.Feedback.Review
  alias Tome.Library.Book

  @valid_statuses Book.list_valid_statuses()

  @moduledoc """
  Module to build Book related queries.
  This is a `core` module, so it only builds queries.
  The boundary layer is resposible for running them.

  Examples:

  Book
    |> BookQuery.published
    |> BookQuery.with_reviews
    |> BookQuery.highly_rated
    |> Repo.all
  """

  # Book implements the Ecto.Queryable protocol (i Book) so
  # `Repo.all Book` is the same as `Repo.all from(b in Book)`

  # A good example to expand this constructor:
  # from b in Book, where: b.status != "deleted"

  # CONSTRUCT

  def new, do: Book

  # REDUCE

  def beta(query), do: from(b in query, where: b.status == :beta)

  def published(query), do: from(b in query, where: b.status == :published)

  def recent(query, after_date \\ Date.add(Date.utc_today(), -7)),
    do: from(b in query, where: b.published_on >= ^after_date)

  def recently_published(query), do: query |> recent |> published

  def by_title(query, partial_title) do
    search_query = "%#{partial_title}%"
    from(b in query, where: ilike(b.title, ^search_query))
  end

  def by_description(query, partial_description) do
    search_query = "%#{partial_description}%"
    from(b in query, where: ilike(b.description, ^search_query))
  end

  def by_status(query, statuses) when is_list(statuses) do
    Enum.reduce(statuses, query, fn status, query -> by_status(query, status) end)
  end

  def by_status(query, status) when status in @valid_statuses do
    from(b in query, or_where: b.status == ^status)
  end

  def order_by(query, property) when property in ~w[title description status isbn published_on]a do
    from(b in query, order_by: [asc: ^property])
  end

  def for_page(query, page, page_size \\ 10) do
    offset = page * page_size
    from(b in query, limit: ^page_size, offset: ^offset)
  end

  def bind_reviews(books) do
    from(b in books,
      join: r in Review,
      on: b.id == r.book_id,
      as: :reviews
    )
  end

  def highly_rated(books, stars \\ 4) when stars in 1..5 do
    from(b in books, where: as(:reviews).stars >= ^stars)
  end

  def poorly_rated(books, stars \\ 2) when stars in 1..5 do
    from(b in books, where: as(:reviews).stars <= ^stars)
  end

  def recently_rated(books, past_date \\ days_ago(14)) do
    from(b in books, where: as(:reviews).inserted_at >= ^past_date)
  end

  # CONVERT

  def as_tuple_title(query),
    do: from(b in query, select: {b.id, b.title}, order_by: [asc: b.title])

  @doc """
  Book |> BookQuery.bind_reviews |> BookQuery.as_ratings_by_book |> Repo.all
  """
  def as_ratings_by_book(books) do
    from(b in books,
      select: {b.title, count(as(:reviews).book_id)},
      group_by: b.title,
      order_by: [desc: count(as(:reviews).book_id)]
    )
  end

  # PRIVATE FNS

  defp days_ago(num_of_days) when is_integer(num_of_days) do
    DateTime.add(DateTime.utc_now(), -1 * num_of_days * 24 * 60 * 60)
  end
end
