defmodule ActionCubeWeb.HomeLive do
  use ActionCubeWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(page_title: "Action Cube")}
  end
end
