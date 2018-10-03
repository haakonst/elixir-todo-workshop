defmodule ElixirTodoWorkshop.Todo.List do
  use Ecto.Schema
  import Ecto.Changeset


  schema "lists" do
    field :name, :string
    has_many :items, ElixirTodoWorkshop.Todo.Item

    timestamps()
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end