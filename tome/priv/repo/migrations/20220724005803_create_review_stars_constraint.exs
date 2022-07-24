defmodule Tome.Repo.Migrations.CreateReviewStarsConstraint do
  use Ecto.Migration

  def change do
    create(constraint("reviews", "stars_min_one", check: "stars > 0"))
    create(constraint("reviews", "stars_max_five", check: "stars < 6"))
  end
end

# mix ecto.gen.migration create_review_stars_constraint
# mix ecto.migrate

# book = Repo.get(Book, 410)
# time = ~N[2022-07-23 00:00:00]
# invalid_review = %{stars: 0, book_id: book.id, inserted_at: time, updated_at: time}
# Repo.insert_all(Review, [review]) # insert_all skip code validations

# ** (Postgrex.Error) ERROR 23514 (check_violation) new row for
# relation "reviews" violates check constraint "stars_min_one"
