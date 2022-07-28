defmodule Tome.Repo.Migrations.CreateCounts do
  use Ecto.Migration

  def change do
    create table(:counts) do
      add(:name, :string, null: false)
      add(:value, :integer, null: false, default: 0)
    end

    create(constraint("counts", "value_min_zero", check: "value >= 0"))
  end
end

# mix ecto.gen.migration create_counts
# mix ecto.migrate
