defmodule GameOfLifeWeb.GameOfLifeLive do
  use Phoenix.LiveView
  alias GameOfLife.Core.Gameplay

  def render(assigns) do
    ~L"""
    <div class="game-of-life-left">
      <h3>Generation: <%= @gameplay.tick_number %></h3>

      <br/>
      <br/>

      <button phx-click="toggle_gameplay">Toggle gameplay</button><br/>
      <p>Game is <%= if @gameplay_running, do: "running", else: "stopped" %></p>

      <br/>
      <br/>

      <form phx-change="apply_settings">
        <h4>Map size: <%= @settings.map_size %></h4>
        <input type="range" min="10" max="100" value="<%= @settings.map_size %>" name="map_size"/>

        <h4>Cell size: <%= @settings.cell_size %></h4>
        <input type="range" min="1" max="50" value="<%= @settings.cell_size %>" name="cell_size"/>

        <h4>Initial pattern: <%= @settings.init_pattern %></h4>
        <select name="init_pattern">
          <%= @init_pattern_options |> Enum.map(fn option -> %>
            <option value="<%= option %>" <%= if option == @settings.init_pattern, do: "selected" %>><%= option %></option>
          <% end) %>
        </select>

        <h4>Speed: <%= @settings.speed / 10%> seconds per tick</h4>
        <input type="range" min="1" max="20" value="<%= @settings.speed %>" name="speed"/>
      </form>
    </div>

    <div class="game-of-life-right">
      <table class="game-of-life">
        <%= 0..(@gameplay.board.size-1) |> Enum.map(fn i -> %>
          <tr>
            <%= 0..(@gameplay.board.size-1) |> Enum.map(fn j -> %>
              <td class="<%= @gameplay.board.content[i][j] %>"
                  style="width: <%= @settings.cell_size %>px; height: <%= @settings.cell_size %>px"
                  phx-click="toggle_cell_state"
                  phx-value="<%= "#{i}-#{j}" %>"
                  id="<%= "#{i}-#{j}" %>"
              ></td>
            <% end) %>
          </tr>
        <% end) %>
      </table>
    </div>
    """
  end

  def mount(_session, socket) do
    if connected?(socket), do: :timer.send_interval(100, self(), :tick)

    {:ok,
     socket
     |> assign(gameplay: Gameplay.start(50, "acorn"))
     |> assign(settings: %{map_size: 50, cell_size: 9, init_pattern: "acorn", speed: 10})
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

  def handle_info(:tick, socket) do
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

  def handle_event("toggle_cell_state", value, socket) do
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
