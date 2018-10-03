defmodule ElixirTodoWorkshopWeb.ItemController do
  use ElixirTodoWorkshopWeb, :controller

  alias ElixirTodoWorkshop.Todo
  alias ElixirTodoWorkshop.Todo.Item

  def index(conn, %{"list" => list} = _params) do
    list = Todo.get_list!(list)
    render(conn, "index.html", list: list, items: list.items)
  end

  def new(conn, %{"list" => list} = _params) do
    list = Todo.get_list!(list)
    changeset = Todo.change_item(%Item{})
    render(conn, "new.html", list: list, changeset: changeset)
  end

  def create(conn, %{"list" => list, "item" => item_params}) do
    list = Todo.get_list!(list)
    case Todo.create_item(item_params, list) do
      {:ok, item} ->
        conn
        |> put_flash(:info, "Item created successfully.")
        |> redirect(to: item_path(conn, :index, item.list))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    item = Todo.get_item!(id)
    render(conn, "show.html", item: item)
  end

  def edit(conn, %{"id" => id}) do
    item = Todo.get_item!(id)
    changeset = Todo.change_item(item)
    render(conn, "edit.html", item: item, changeset: changeset)
  end

  def update(conn, %{"id" => id, "item" => item_params}) do
    item = Todo.get_item!(id)

    case Todo.update_item(item, item_params) do
      {:ok, item} ->
        conn
        |> put_flash(:info, "Item updated successfully.")
        |> redirect(to: item_path(conn, :index, item.list))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", item: item, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    item = Todo.get_item!(id)
    {:ok, _item} = Todo.delete_item(item)

    conn
    |> put_flash(:info, "Item deleted successfully.")
    |> redirect(to: item_path(conn, :index, item.list))
  end
end