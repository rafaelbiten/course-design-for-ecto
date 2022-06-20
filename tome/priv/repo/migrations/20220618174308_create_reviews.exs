defmodule Tome.Repo.Migrations.CreateReviews do
  use Ecto.Migration

  def change do
    create table(:reviews) do
      add(:stars, :integer, null: false)
      add(:book_id, references(:books))

      timestamps()
    end

    create(index(:reviews, :book_id))
  end
end

# mix ecto.gen.migration create_reviews
# mix ecto.migrate
