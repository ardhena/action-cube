defmodule ActionCube.Snake.Board do
  defstruct [:size, :content, :snake_direction, :snake_head_coords, :snake_coords]

  def start(size) do
    size
    |> new()
    |> spawn_snake()
    |> spawn_treat()
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
        snake_coords: [{snake_index, snake_index}],
        content: content |> toggle_cell({snake_index, snake_index}, :snake_head)
    }
  end

  @doc """
  Spawns treat in one cube on the board
  """
  def spawn_treat(%__MODULE__{size: size, content: content} = board) do
    coord_range = 0..(size - 1)

    x = Enum.random(coord_range)
    y = Enum.random(coord_range)

    case content[y][x] do
      :empty ->
        %__MODULE__{board | content: content |> toggle_cell({x, y}, :treat)}

      value when value in [:snake, :snake_head] ->
        spawn_treat(board)
    end
  end

  def process_tick(
        %__MODULE__{
          content: content,
          size: size,
          snake_direction: direction,
          snake_head_coords: head_coords,
          snake_coords: snake_coords
        } = board
      ) do
    {x, y} = new_head_coords = increase_coords(direction, head_coords)

    case coords_outside_board?(new_head_coords, size) || snake_eating_itself?(new_head_coords, snake_coords) do
      true ->
        {:stop, board}

      false ->
        case content[y][x] == :treat do
          true -> {:ok, move_snake(:eat, board, new_head_coords)}
          false -> {:ok, move_snake(:move, board, new_head_coords)}
        end
    end
  end

  defp move_snake(
         :eat,
         %__MODULE__{
           content: content,
           snake_head_coords: head_coords,
           snake_coords: snake_coords
         } = board,
         new_head_coords
       ) do
    %__MODULE__{
      board
      | content:
          content
          |> toggle_cell(new_head_coords, :snake_head)
          |> toggle_cell(head_coords, :snake),
        snake_head_coords: new_head_coords,
        snake_coords: snake_coords ++ [new_head_coords]
    }
    |> spawn_treat()
  end

  defp move_snake(
         :move,
         %__MODULE__{
           content: content,
           snake_head_coords: head_coords,
           snake_coords: [last_tail_coords | snake_without_last_tail_coords]
         } = board,
         new_head_coords
       ) do
    %__MODULE__{
      board
      | content:
          content
          |> toggle_cell(new_head_coords, :snake_head)
          |> toggle_cell(head_coords, :snake)
          |> toggle_cell(last_tail_coords),
        snake_head_coords: new_head_coords,
        snake_coords: snake_without_last_tail_coords ++ [new_head_coords]
    }
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

  defp snake_eating_itself?(fragment, [fragment | _tail]), do: true
  defp snake_eating_itself?(_coords, []), do: false
  defp snake_eating_itself?(coords, [_fragment | tail]), do: snake_eating_itself?(coords, tail)

  defp toggle_cell(content, {x, y}, type \\ nil),
    do: content |> Map.put(y, Map.put(content[y], x, toggle_cell_value(content[y][x], type)))

  defp toggle_cell_value(:snake_head, :snake), do: :snake
  defp toggle_cell_value(:snake_head, _type), do: :empty
  defp toggle_cell_value(:snake, _type), do: :empty
  defp toggle_cell_value(:treat, _type), do: :snake_head

  defp toggle_cell_value(:empty, :snake_head), do: :snake_head
  defp toggle_cell_value(:empty, :treat), do: :treat
  defp toggle_cell_value(:empty, _type), do: :snake
end
