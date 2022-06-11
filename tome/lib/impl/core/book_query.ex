defmodule Tome.Core.BookQuery do
  import Ecto.Query, only: [from: 2]
  alias Tome.Core.Book

  @moduledoc """
  Module to build Book related queries.
  This is a `core` module, so it only builds queries.
  The boundary layer is resposible for running them.
  """

  # Book implements the Ecto.Queryable protocol (i Book) so
  # `Repo.all Book` is the same as `Repo.all from(b in Book)`

  # A good example to expand this constructor:
  # from b in Book, where: b.status != "deleted"

  # CONSTRUCT

  def new, do: Book

  # REDUCE

  def beta(query), do: from(b in query, where: b.status == "beta")

  def published(query), do: from(b in query, where: b.status == "published")

  def recent(query, after_date \\ Date.add(Date.utc_today(), -7)),
    do: from(b in query, where: b.published_on >= ^after_date)

  def recently_published(query), do: query |> recent |> published

  # CONVERT

  def as_tuple_title(query),
    do: from(b in query, select: {b.id, b.title}, order_by: [asc: b.title])
end
