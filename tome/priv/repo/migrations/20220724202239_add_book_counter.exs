defmodule Tome.Repo.Migrations.AddBookCounter do
  use Ecto.Migration

  def change do
    alter table(:books) do
      add(:count, :integer, null: false, default: 0)
    end
  end
end

# mix ecto.gen.migration add_book_counter
# mix ecto.migrate
