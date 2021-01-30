defmodule ActionCubeWeb.Router do
  use ActionCubeWeb, :router
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ActionCubeWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ActionCubeWeb do
    pipe_through :browser

    live "/", HomeLive
    live "/game_of_life", GameOfLifeLive
    live_dashboard "/dashboard"
  end
end
