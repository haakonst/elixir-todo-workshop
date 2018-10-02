defmodule ElixirTodoWorkshop.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :description, :string

      timestamps()
    end

  end
end
