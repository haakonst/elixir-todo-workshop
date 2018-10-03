defmodule ElixirTodoWorkshopWeb.Router do
  use ElixirTodoWorkshopWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ElixirTodoWorkshopWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/lists", ListController
    resources "/items", ItemController, only: [:new, :create, :edit, :update, :delete]
    get "/items/:list", ItemController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", ElixirTodoWorkshopWeb do
  #   pipe_through :api
  # end
end
