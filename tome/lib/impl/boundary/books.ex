defmodule Tome.Boundary.Books do
  alias Tome.Repo
  import Tome.Core.BookQuery

  @moduledoc """
  Boundary / Interaction layer to bridge:
    1. the query layer (pure functional core / "computations")
    2. and the repo (impure / "actions") layer

  Serves as a public interface to work with Books ("data")
  """

  def all do
    new() |> Repo.all()
  end

  def published do
    new()
    |> published
    # |> as_tuple_title
    |> Repo.all()
  end

  def published_recently do
    new()
    |> published
    |> recent
    |> Repo.all()
  end

  def by_description(partial_description) do
    new()
    |> by_description(partial_description)
    |> Repo.all()
  end

  def order_by(property) when property in ~w[title description status isbn published_on]a do
    new()
    |> order_by(property)
    |> Repo.all()
  end

  def for_page(page, page_size \\ 10) when page >= 0 do
    new()
    |> for_page(page, page_size)
    |> Repo.all()
  end
end
