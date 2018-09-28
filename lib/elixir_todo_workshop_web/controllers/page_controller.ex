defmodule ElixirTodoWorkshopWeb.PageController do
  use ElixirTodoWorkshopWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
