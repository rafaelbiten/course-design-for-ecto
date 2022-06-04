defmodule Tome.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books) do
      add(:title, :string, null: false)
      add(:isbn, :string, null: false)
      add(:description, :text, null: false)
      add(:status, :string, null: false, default: "working")
      add(:published_on, :date)

      timestamps()
    end
  end

  unique_index("books", [:isbn])
end

# mix ecto.create
# mix ecto.gen.migration create_books
# mix ecto.migrate
