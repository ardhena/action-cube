defmodule ActionCubeWeb.SnakeLive do
  use ActionCubeWeb, :live_view
  alias ActionCube.Snake.Board

  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(500, self(), "tick")

    {:ok,
     socket
     |> assign(page_title: "Snake")
     |> assign(board: Board.start(30))
     |> assign(game_running: true)}
  end

  def handle_info("tick", socket) do
    case Board.process_tick(socket.assigns.board) do
      {:ok, board} ->
        {:noreply,
         socket
         |> assign(board: board)}

      {:stop, _board} ->
        {:noreply, socket |> assign(game_running: false)}
    end
  end

  def handle_event("change_direction", %{"key" => value}, socket) do
    new_direction =
      {value, socket.assigns.board.snake_direction}
      |> case do
        {horizontal_keys, vertical_dir}
        when horizontal_keys in ["a", "ArrowLeft"] and vertical_dir in [:up, :down] ->
          :left

        {horizontal_keys, vertical_dir}
        when horizontal_keys in ["d", "ArrowRight"] and vertical_dir in [:up, :down] ->
          :right

        {vertical_keys, horizontal_dir}
        when vertical_keys in ["w", "ArrowUp"] and horizontal_dir in [:left, :right] ->
          :up

        {vertical_keys, horizontal_dir}
        when vertical_keys in ["s", "ArrowDown"] and horizontal_dir in [:left, :right] ->
          :down

        _ ->
          nil
      end

    {:noreply,
     socket |> assign(board: Board.change_direction(socket.assigns.board, new_direction))}
  end
end
