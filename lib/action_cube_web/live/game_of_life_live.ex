defmodule ActionCubeWeb.GameOfLifeLive do
  use Phoenix.LiveView
  alias ActionCube.GameOfLife.Gameplay

  @init_map_size 40
  @init_cell_size 12
  @init_speed 10

  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(100, self(), "tick")

    {:ok,
     socket
     |> assign(gameplay: Gameplay.start(@init_map_size, "acorn"))
     |> assign(
       settings: %{
         map_size: @init_map_size,
         cell_size: @init_cell_size,
         init_pattern: "acorn",
         speed: @init_speed
       }
     )
     |> assign(
       init_pattern_options: [
         "clear",
         "random_1",
         "random_2",
         "random_3",
         "r_pentomino",
         "diehard",
         "acorn"
       ]
     )
     |> assign(gameplay_running: true)}
  end

  def handle_info("tick", socket) do
    case socket.assigns.gameplay_running do
      true ->
        {:noreply,
         assign(socket,
           gameplay: Gameplay.process_tick(socket.assigns.gameplay, socket.assigns.settings.speed)
         )}

      false ->
        {:noreply, socket}
    end
  end

  def handle_event("toggle_cell_state", %{"*" => value}, socket) do
    [col, row] = value |> String.split("-") |> Enum.map(&String.to_integer(&1))

    {:noreply,
     assign(socket, gameplay: Gameplay.toggle_cell(socket.assigns.gameplay, {col, row}))}
  end

  def handle_event("toggle_gameplay", _value, socket) do
    {:noreply, assign(socket, gameplay_running: !socket.assigns.gameplay_running)}
  end

  def handle_event("apply_settings", new_settings, socket) do
    new_map_size = String.to_integer(new_settings["map_size"])
    new_cell_size = String.to_integer(new_settings["cell_size"])
    new_speed = String.to_integer(new_settings["speed"])
    new_init_pattern = new_settings["init_pattern"] || socket.assigns.settings.init_pattern

    new_settings = %{
      map_size: new_map_size,
      cell_size: new_cell_size,
      init_pattern: new_init_pattern,
      speed: new_speed
    }

    if socket.assigns.settings.map_size != new_map_size ||
         socket.assigns.settings.init_pattern != new_init_pattern do
      {:noreply,
       socket
       |> assign(gameplay: Gameplay.start(new_map_size, new_init_pattern))
       |> assign(settings: new_settings)}
    else
      {:noreply, assign(socket, settings: new_settings)}
    end
  end
end
