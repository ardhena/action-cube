defmodule ActionCubeWeb.SnakeLive do
  use ActionCubeWeb, :live_view
  alias ActionCube.Snake.Gameplay

  @init_speed 5

  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(100, self(), "tick")

    {:ok,
     socket
     |> assign(page_title: "Snake")
     |> assign(gameplay: Gameplay.start(20))
     |> assign(game_running: true)
     |> assign(speed: @init_speed)}
  end

  def handle_info("tick", socket) do
    case socket.assigns.game_running do
      true ->
        case Gameplay.process_tick(socket.assigns.gameplay, socket.assigns.speed) do
          {:ok, gameplay} ->
            {:noreply,
             socket
             |> assign(gameplay: gameplay)
             |> assign(speed: score_speed_increase(gameplay.score) || socket.assigns.speed)}

          {:stop, _gameplay} ->
            {:noreply, socket |> assign(game_running: false)}
        end

      false ->
        {:noreply, socket}
    end
  end

  def handle_event("change_direction", %{"key" => value}, socket) do
    new_direction =
      {value, socket.assigns.gameplay.board.snake_direction}
      |> direction_from_key()

    {:noreply,
     socket |> assign(gameplay: Gameplay.change_direction(socket.assigns.gameplay, new_direction))}
  end

  def handle_event("restart", _, socket) do
    {:noreply,
     socket
     |> assign(gameplay: Gameplay.start(20))
     |> assign(game_running: true)
     |> assign(speed: @init_speed)}
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
