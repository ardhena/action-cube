defmodule ActionCubeWeb.SnakeLiveTest do
  use ActionCubeWeb.ConnCase
  import Phoenix.LiveViewTest

  test "renders initial board view", %{conn: conn} do
    {:ok, live_view, disconnected_html} = live(conn, "/snake")

    assert disconnected_html =~ "<h1>Snake</h1>"

    assert render(live_view) =~ "<h1>Snake</h1>"

    assert render(live_view) =~
             "<div class=\"snake-content\" phx-window-keyup=\"change_direction\">"

    assert render(live_view) =~ "<td class=\"snake_head\" id=\"15-15\"></td>"
    assert render(live_view) =~ "Game is running"
  end

  test "processes tick when message is received", %{conn: conn} do
    {:ok, live_view, _} = live(conn, "/snake")

    send(live_view.pid, "tick")

    assert render(live_view) =~ "<td class=\"empty\" id=\"15-15\"></td>"
    assert render(live_view) =~ "<td class=\"snake_head\" id=\"14-15\"></td>"
  end

  test "ends game when snake goes into wall", %{conn: conn} do
    {:ok, live_view, _} = live(conn, "/snake")

    assert render(live_view) =~ "<td class=\"snake_head\" id=\"15-15\"></td>"

    send(live_view.pid, "tick")
    send(live_view.pid, "tick")
    send(live_view.pid, "tick")
    send(live_view.pid, "tick")
    send(live_view.pid, "tick")

    assert render(live_view) =~ "<td class=\"snake_head\" id=\"10-15\"></td>"

    send(live_view.pid, "tick")
    send(live_view.pid, "tick")
    send(live_view.pid, "tick")
    send(live_view.pid, "tick")
    send(live_view.pid, "tick")

    assert render(live_view) =~ "<td class=\"snake_head\" id=\"5-15\"></td>"

    send(live_view.pid, "tick")
    send(live_view.pid, "tick")
    send(live_view.pid, "tick")
    send(live_view.pid, "tick")
    send(live_view.pid, "tick")

    assert render(live_view) =~ "<td class=\"snake_head\" id=\"0-15\"></td>"
    assert render(live_view) =~ "Game is running"

    # end of game
    send(live_view.pid, "tick")
    assert render(live_view) =~ "<td class=\"snake_head\" id=\"0-15\"></td>"
    assert render(live_view) =~ "Game is over"
  end

  test "changes snake direction on key press (wsad)", %{conn: conn} do
    {:ok, live_view, _} = live(conn, "/snake")

    # left a
    render_keyup(live_view, "change_direction", %{"key" => "a"})
    send(live_view.pid, "tick")

    assert render(live_view) =~ "<td class=\"empty\" id=\"15-15\"></td>"
    assert render(live_view) =~ "<td class=\"snake_head\" id=\"15-14\"></td>"

    # up w
    render_keyup(live_view, "change_direction", %{"key" => "w"})
    send(live_view.pid, "tick")

    assert render(live_view) =~ "<td class=\"empty\" id=\"15-14\"></td>"
    assert render(live_view) =~ "<td class=\"snake_head\" id=\"14-14\"></td>"

    # right d
    render_keyup(live_view, "change_direction", %{"key" => "d"})
    send(live_view.pid, "tick")

    assert render(live_view) =~ "<td class=\"empty\" id=\"14-14\"></td>"
    assert render(live_view) =~ "<td class=\"snake_head\" id=\"14-15\"></td>"

    # down s
    render_keyup(live_view, "change_direction", %{"key" => "s"})
    send(live_view.pid, "tick")

    assert render(live_view) =~ "<td class=\"empty\" id=\"14-15\"></td>"
    assert render(live_view) =~ "<td class=\"snake_head\" id=\"15-15\"></td>"
  end

  test "changes snake direction on key press (arrows)", %{conn: conn} do
    {:ok, live_view, _} = live(conn, "/snake")

    # left arrow
    render_keyup(live_view, "change_direction", %{"key" => "ArrowLeft"})
    send(live_view.pid, "tick")

    assert render(live_view) =~ "<td class=\"empty\" id=\"15-15\"></td>"
    assert render(live_view) =~ "<td class=\"snake_head\" id=\"15-14\"></td>"

    # up arrow
    render_keyup(live_view, "change_direction", %{"key" => "ArrowUp"})
    send(live_view.pid, "tick")

    assert render(live_view) =~ "<td class=\"empty\" id=\"15-14\"></td>"
    assert render(live_view) =~ "<td class=\"snake_head\" id=\"14-14\"></td>"

    # right arrow
    render_keyup(live_view, "change_direction", %{"key" => "ArrowRight"})
    send(live_view.pid, "tick")

    assert render(live_view) =~ "<td class=\"empty\" id=\"14-14\"></td>"
    assert render(live_view) =~ "<td class=\"snake_head\" id=\"14-15\"></td>"

    # down arrow
    render_keyup(live_view, "change_direction", %{"key" => "ArrowDown"})
    send(live_view.pid, "tick")

    assert render(live_view) =~ "<td class=\"empty\" id=\"14-15\"></td>"
    assert render(live_view) =~ "<td class=\"snake_head\" id=\"15-15\"></td>"
  end
end
