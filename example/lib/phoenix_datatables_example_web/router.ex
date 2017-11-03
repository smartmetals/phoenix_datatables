defmodule PhoenixDatatablesExampleWeb.Router do
  use PhoenixDatatablesExampleWeb, :router

  pipeline :browser do
    plug :accepts, ["html", "json"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhoenixDatatablesExampleWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/items", ItemController
  end

  scope "/datatables", PhoenixDatatablesExampleWeb do
    pipe_through :browser

    get "/items", ItemTableController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhoenixDatatablesExampleWeb do
  #   pipe_through :api
  # end
end
