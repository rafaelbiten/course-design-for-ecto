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

  def with_reviews(query) do
    from(b in query,
      join: r in Review,
      on: b.id == r.book_id,
      as: :reviews
    )
  end

  def highly_rated(query, stars \\ 4) when stars in 1..5 do
    from(b in query, where: as(:reviews).stars >= ^stars)
  end

  def poorly_rated(query, stars \\ 2) when stars in 1..5 do
    from(b in query, where: as(:reviews).stars <= ^stars)
  end

  def recently_rated(query, hours_ago \\ 1) do
    hours_ago = DateTime.add(DateTime.utc_now(), -:timer.hours(hours_ago))
    from(b in query, where: as(:reviews).inserted_at >= ^hours_ago)
  end

  # CONVERT

  def as_tuple_title(query),
    do: from(b in query, select: {b.id, b.title}, order_by: [asc: b.title])
end
