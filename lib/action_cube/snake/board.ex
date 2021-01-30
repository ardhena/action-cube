defmodule ActionCube.Snake.Board do
  defstruct [:size, :content, :snake_direction, :snake_head_coords]

  def start(size) do
    size
    |> new()
    |> spawn_snake()
  end

  @doc """
  Builds new empty board of given size
  """
  def new(size) when is_integer(size) do
    row = Enum.reduce(0..(size - 1), %{}, fn i, map -> Map.put(map, i, :empty) end)
    array = Enum.reduce(0..(size - 1), %{}, fn i, map -> Map.put(map, i, row) end)

    %__MODULE__{size: size, content: array, snake_direction: :up}
  end

  @doc """
  Spawns 1-cube long snake in the middle of the board
  """
  def spawn_snake(%__MODULE__{size: size, content: content} = board) do
    snake_index = (size / 2.0) |> trunc()

    %__MODULE__{
      board
      | snake_head_coords: {snake_index, snake_index},
        content:
          content
          |> Map.put(
            snake_index,
            Map.put(content[snake_index], snake_index, :snake)
          )
    }
  end

  def process_tick(
        %__MODULE__{
          content: content,
          size: size,
          snake_direction: direction,
          snake_head_coords: head_coords
        } = board
      ) do
    new_head_coords = increase_coords(direction, head_coords)

    case coords_outside_board?(new_head_coords, size) do
      true ->
        {:stop, board}

      false ->
        {:ok,
         %__MODULE__{
           board
           | content: content |> toggle_cell(head_coords) |> toggle_cell(new_head_coords),
             snake_head_coords: new_head_coords
         }}
    end
  end

  def change_direction(%__MODULE__{} = board, nil), do: board

  def change_direction(%__MODULE__{} = board, direction),
    do: %__MODULE__{board | snake_direction: direction}

  defp increase_coords(:up, {x, y}), do: {x, y - 1}
  defp increase_coords(:down, {x, y}), do: {x, y + 1}
  defp increase_coords(:right, {x, y}), do: {x + 1, y}
  defp increase_coords(:left, {x, y}), do: {x - 1, y}

  defp coords_outside_board?({x, y}, _size) when x < 0 or y < 0, do: true
  defp coords_outside_board?({x, y}, size) when x >= size or y >= size, do: true
  defp coords_outside_board?(_coords, _size), do: false

  defp toggle_cell(content, {x, y}),
    do: content |> Map.put(y, Map.put(content[y], x, toggle_cell_value(content[y][x])))

  defp toggle_cell_value(:snake), do: :empty
  defp toggle_cell_value(:empty), do: :snake
end
