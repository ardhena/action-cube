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
      </form>
    </div>

    <div class="game-of-life-right">
      <table class="game-of-life">
        <%= @gameplay.board.content |> to_ordered_list() |> Enum.map(fn {i, row} -> %>
          <tr>
            <%= row |> to_ordered_list |> Enum.map(fn {j, cell} -> %>
              <td class="<%= cell %>"
                  style="width: <%= @settings.cell_size %>px; height: <%= @settings.cell_size %>px"
                  phx-click="toggle_cell_state"
                  phx-value="<%= "#{i}-#{j}" %>"
              ></td>
            <% end) %>
          </tr>
        <% end) %>
      </table>
    </div>
    """
  end

  def mount(_session, socket) do
    if connected?(socket), do: :timer.send_interval(1000, self(), :tick)

    {:ok,
     socket
     |> assign(gameplay: Gameplay.start(40))
     |> assign(settings: %{map_size: 40, cell_size: 10})
     |> assign(gameplay_running: true)}
  end

  def handle_info(:tick, socket) do
    case socket.assigns.gameplay_running do
      true ->
        {:noreply, assign(socket, gameplay: Gameplay.process_tick(socket.assigns.gameplay))}

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
    new_settings = %{map_size: new_map_size, cell_size: new_cell_size}

    if socket.assigns.settings.map_size == new_settings.map_size do
      {:noreply, assign(socket, settings: new_settings)}
    else
      {:noreply,
       socket
       |> assign(gameplay: Gameplay.start(new_settings.map_size))
       |> assign(settings: new_settings)}
    end
  end

  defp to_ordered_list(map) do
    map
    |> Enum.to_list()
    |> Enum.sort(fn {key1, _}, {key2, _} -> key1 < key2 end)
  end
end
