defmodule ElixirTodoWorkshop.Todo.Item do
  use Ecto.Schema
  import Ecto.Changeset


  schema "items" do
    field :description, :string
    belongs_to :list, ElixirTodoWorkshop.Todo.List, on_replace: :nilify

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:description])
    |> validate_required([:description])
  end

  def changeset_create(item, attrs, list) do
    item
    |> cast(attrs, [:description])
    |> validate_required([:description])
    |> put_assoc(:list, list)
  end
end
