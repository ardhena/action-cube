defmodule ActionCubeWeb.SnakeLive do
  use ActionCubeWeb, :live_view
  alias ActionCube.Snake.Gameplay

  @init_map_size 20
  @init_treat_number 1
  @init_speed 5

  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(100, self(), "tick")

    {:ok,
     socket
     |> assign(
       settings: %{map_size: @init_map_size, treat_number: @init_treat_number, speed: @init_speed}
     )
     |> restart_gameplay()
     |> assign(page_title: "Snake")}
  end

  def handle_info("tick", %{assigns: %{settings: settings}} = socket) do
    case socket.assigns.game_running do
      true ->
        case Gameplay.check_tick(socket.assigns.gameplay, settings.speed) do
          :subtick ->
            {:ok, gameplay} = Gameplay.process_tick(socket.assigns.gameplay, settings.speed)
            {:noreply, socket |> assign(gameplay: gameplay)}

          :tick ->
            socket.assigns.gameplay
            |> Gameplay.change_direction(socket.assigns.new_direction)
            |> Gameplay.process_tick(settings.speed)
            |> case do
              {:ok, gameplay} ->
                {:noreply,
                 socket
                 |> assign(gameplay: gameplay)
                 |> assign(new_direction: nil)
                 |> assign(
                   settings: %{
                     settings
                     | speed: score_speed_increase(gameplay.score) || settings.speed
                   }
                 )}

              {:stop, _gameplay} ->
                {:noreply, socket |> assign(game_running: false)}
            end
        end

      false ->
        {:noreply, socket}
    end
  end

  def handle_event("change_direction", %{"key" => value}, socket) do
    case socket.assigns.new_direction do
      nil ->
        {:noreply,
         socket
         |> assign(
           new_direction:
             {value, socket.assigns.gameplay.board.snake_direction} |> direction_from_key()
         )}

      _ ->
        {:noreply, socket}
    end
  end

  def handle_event("apply_settings", new_settings, %{assigns: %{settings: settings}} = socket) do
    new_map_size = String.to_integer(new_settings["map_size"])
    new_treat_number = String.to_integer(new_settings["treat_number"])

    new_settings = %{settings | map_size: new_map_size, treat_number: new_treat_number}

    {:noreply, socket |> assign(settings: new_settings) |> restart_gameplay()}
  end

  def handle_event("restart", _, socket) do
    {:noreply, restart_gameplay(socket)}
  end

  def restart_gameplay(%{assigns: %{settings: %{map_size: map_size, treat_number: treat_number} = settings}} = socket) do
    socket
    |> assign(gameplay: Gameplay.start(map_size, treat_number))
    |> assign(game_running: true)
    |> assign(settings: %{settings | speed: @init_speed})
    |> assign(new_direction: nil)
  end

  defp score_speed_increase(2), do: 4
  defp score_speed_increase(5), do: 3
  defp score_speed_increase(10), do: 2
  defp score_speed_increase(15), do: 1
  defp score_speed_increase(_), do: nil

  defp direction_from_key({key, current_direction})
       when key in ["a", "ArrowLeft"] and current_direction in [:up, :down],
       do: :left

  defp direction_from_key({key, current_direction})
       when key in ["d", "ArrowRight"] and current_direction in [:up, :down],
       do: :right

  defp direction_from_key({key, current_direction})
       when key in ["w", "ArrowUp"] and current_direction in [:left, :right],
       do: :up

  defp direction_from_key({key, current_direction})
       when key in ["s", "ArrowDown"] and current_direction in [:left, :right],
       do: :down

  defp direction_from_key(_), do: nil
end
