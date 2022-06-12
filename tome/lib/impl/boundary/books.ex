defmodule Tome.Boundary.Books do
  alias Tome.Repo
  import Tome.Core.BookQuery

  @moduledoc """
  Boundary / Interaction layer to bridge:
    1. the query layer (pure functional core / "computations")
    2. and the repo (impure / "actions") layer

  Serves as a public interface to work with Books ("data")
  """

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
end
