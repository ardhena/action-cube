defmodule ActionCubeWeb.SnakeLiveTest do
  use ActionCubeWeb.ConnCase
  import Phoenix.LiveViewTest

  test "renders initial board view", %{conn: conn} do
    {:ok, live_view, disconnected_html} = live(conn, "/snake")

    assert disconnected_html =~ "<h1>Snake</h1>"

    assert render(live_view) =~ "<h1>Snake</h1>"

    assert render(live_view) =~
             "<div class=\"snake-content\" phx-window-keyup=\"change_direction\">"

    assert render(live_view) =~ "<td class=\"snake_head\" id=\"10-10\"></td>"
    assert render(live_view) =~ "Game is running."
    assert render(live_view) =~ "Score: 0"
  end

  test "processes subtick and tick when message is received", %{conn: conn} do
    {:ok, live_view, _} = live(conn, "/snake")

    send_subtick(live_view, 1)

    assert render(live_view) =~ "<td class=\"snake_head\" id=\"10-10\"></td>"

    send_subtick(live_view, 4)

    assert render(live_view) =~ "<td class=\"empty\" id=\"10-10\"></td>"
    assert render(live_view) =~ "<td class=\"snake_head\" id=\"9-10\"></td>"
  end

  test "ends game when snake goes into wall", %{conn: conn} do
    {:ok, live_view, _} = live(conn, "/snake")

    assert render(live_view) =~ "<td class=\"snake_head\" id=\"10-10\"></td>"

    send_tick(live_view, 5)

    assert render(live_view) =~ "<td class=\"snake_head\" id=\"5-10\"></td>"

    send_tick(live_view, 5)

    assert render(live_view) =~ "<td class=\"snake_head\" id=\"0-10\"></td>"
    assert render(live_view) =~ "Game is running"

    # end of game
    send_tick(live_view, 1)

    assert render(live_view) =~ "<td class=\"snake_head\" id=\"0-10\"></td>"
    assert render(live_view) =~ "Game over. You lost."
    assert render(live_view) =~ "Score: 0"
  end

  test "changes snake direction on key press (wsad)", %{conn: conn} do
    {:ok, live_view, _} = live(conn, "/snake")

    # left a
    render_keyup(live_view, "change_direction", %{"key" => "a"})
    send_tick(live_view, 1)

    assert render(live_view) =~ "<td class=\"empty\" id=\"10-10\"></td>"
    assert render(live_view) =~ "<td class=\"snake_head\" id=\"10-9\"></td>"

    # up w
    render_keyup(live_view, "change_direction", %{"key" => "w"})
    send_tick(live_view, 1)

    assert render(live_view) =~ "<td class=\"empty\" id=\"10-9\"></td>"
    assert render(live_view) =~ "<td class=\"snake_head\" id=\"9-9\"></td>"

    # right d
    render_keyup(live_view, "change_direction", %{"key" => "d"})
    send_tick(live_view, 1)

    assert render(live_view) =~ "<td class=\"empty\" id=\"9-9\"></td>"
    assert render(live_view) =~ "<td class=\"snake_head\" id=\"9-10\"></td>"

    # down s
    render_keyup(live_view, "change_direction", %{"key" => "s"})
    send_tick(live_view, 1)

    assert render(live_view) =~ "<td class=\"empty\" id=\"9-10\"></td>"
    assert render(live_view) =~ "<td class=\"snake_head\" id=\"10-10\"></td>"
  end

  test "changes snake direction on key press (arrows)", %{conn: conn} do
    {:ok, live_view, _} = live(conn, "/snake")

    # left arrow
    render_keyup(live_view, "change_direction", %{"key" => "ArrowLeft"})
    send_tick(live_view, 1)

    assert render(live_view) =~ "<td class=\"empty\" id=\"10-10\"></td>"
    assert render(live_view) =~ "<td class=\"snake_head\" id=\"10-9\"></td>"

    # up arrow
    render_keyup(live_view, "change_direction", %{"key" => "ArrowUp"})
    send_tick(live_view, 1)

    assert render(live_view) =~ "<td class=\"empty\" id=\"10-9\"></td>"
    assert render(live_view) =~ "<td class=\"snake_head\" id=\"9-9\"></td>"

    # right arrow
    render_keyup(live_view, "change_direction", %{"key" => "ArrowRight"})
    send_tick(live_view, 1)

    assert render(live_view) =~ "<td class=\"empty\" id=\"9-9\"></td>"
    assert render(live_view) =~ "<td class=\"snake_head\" id=\"9-10\"></td>"

    # down arrow
    render_keyup(live_view, "change_direction", %{"key" => "ArrowDown"})
    send_tick(live_view, 1)

    assert render(live_view) =~ "<td class=\"empty\" id=\"9-10\"></td>"
    assert render(live_view) =~ "<td class=\"snake_head\" id=\"10-10\"></td>"
  end

  test "restarts game with button when lost", %{conn: conn} do
    {:ok, live_view, _} = live(conn, "/snake")

    send_tick(live_view, 11)
    assert render(live_view) =~ "Game over. You lost."

    render_click(live_view, "restart", %{})
    assert render(live_view) =~ "Game is running."
  end

  defp send_tick(live_view, number), do: send_subtick(live_view, number * 5)

  defp send_subtick(live_view, number),
    do: 0..number |> Enum.each(fn _ -> send(live_view.pid, "tick") end)
end
