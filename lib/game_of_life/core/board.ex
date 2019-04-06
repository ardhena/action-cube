defmodule GameOfLife.Core.Board do
  defstruct [:size, :content]

  @doc """
  Builds new empty board of given size
  """
  def new(size) when is_integer(size) do
    row = Enum.reduce(0..(size - 1), %{}, fn i, map -> Map.put(map, i, :dead) end)
    array = Enum.reduce(0..(size - 1), %{}, fn i, map -> Map.put(map, i, row) end)

    %__MODULE__{size: size, content: array}
  end

  @doc """
  Populates board with chosen initial board population type.
  Available options are: clear, random_1, random_2, random_3, r_pentomino, diehard, acorn.
  """
  def populate(%__MODULE__{} = board, "clear"), do: board

  def populate(%__MODULE__{size: size} = board, "random_1") do
    starting_living_cells = Enum.random(size..(size + size))
    randomly_populate(board, starting_living_cells)
  end

  def populate(%__MODULE__{size: size} = board, "random_2") do
    starting_living_cells = Enum.random((size + size)..floor(size * size / 2))
    randomly_populate(board, starting_living_cells)
  end

  def populate(%__MODULE__{size: size} = board, "random_3") do
    starting_living_cells = Enum.random(floor(size * size / 2)..(size * size - size))
    randomly_populate(board, starting_living_cells)
  end

  def populate(%__MODULE__{size: size} = board, "r_pentomino") do
    center = floor(size / 2)

    %{
      board
      | content:
          board.content
          |> Map.put(
            center - 1,
            board.content[center - 1]
            |> Map.put(center, :alive)
            |> Map.put(center + 1, :alive)
          )
          |> Map.put(
            center,
            board.content[center]
            |> Map.put(center - 1, :alive)
            |> Map.put(center, :alive)
          )
          |> Map.put(
            center + 1,
            board.content[center + 1]
            |> Map.put(center, :alive)
          )
    }
  end

  def populate(%__MODULE__{size: size} = board, "diehard") do
    center = floor(size / 2)

    %{
      board
      | content:
          board.content
          |> Map.put(
            center - 1,
            board.content[center - 1]
            |> Map.put(center + 3, :alive)
          )
          |> Map.put(
            center,
            board.content[center]
            |> Map.put(center - 3, :alive)
            |> Map.put(center - 2, :alive)
          )
          |> Map.put(
            center + 1,
            board.content[center + 1]
            |> Map.put(center - 2, :alive)
            |> Map.put(center + 2, :alive)
            |> Map.put(center + 3, :alive)
            |> Map.put(center + 4, :alive)
          )
    }
  end

  def populate(%__MODULE__{size: size} = board, "acorn") do
    center = floor(size / 2)

    %{
      board
      | content:
          board.content
          |> Map.put(
            center - 1,
            board.content[center - 1]
            |> Map.put(center - 2, :alive)
          )
          |> Map.put(
            center,
            board.content[center]
            |> Map.put(center, :alive)
          )
          |> Map.put(
            center + 1,
            board.content[center + 1]
            |> Map.put(center - 3, :alive)
            |> Map.put(center - 2, :alive)
            |> Map.put(center + 1, :alive)
            |> Map.put(center + 2, :alive)
            |> Map.put(center + 3, :alive)
          )
    }
  end

  defp randomly_populate(%__MODULE__{size: size} = board, starting_living_cells_amount) do
    1..starting_living_cells_amount
    |> Enum.reduce(board, fn _i, updated_board ->
      col = Enum.random(0..(size - 1))
      row = Enum.random(0..(size - 1))

      %{
        updated_board
        | content:
            Map.put(updated_board.content, col, Map.put(updated_board.content[col], row, :alive))
      }
    end)
  end

  @doc """
  Calculates board content for next generation. Follows the rules of cell transitions in `process_cell`.
  """
  def next_generation(%__MODULE__{size: size, content: content} = board) do
    next_board =
      Enum.reduce(0..(size - 1), %{}, fn i, col ->
        Map.put(
          col,
          i,
          Enum.reduce(0..(size - 1), %{}, fn j, row ->
            cell = content[i][j]

            new_cell =
              process_cell(
                cell,
                count_alive_neighbours(content, i, j)
              )

            Map.put(row, j, new_cell)
          end)
        )
      end)

    %{board | content: next_board}
  end

  defp count_alive_neighbours(content, i, j) do
    0
    |> maybe_increment_counter(content[i - 1][j - 1])
    |> maybe_increment_counter(content[i - 1][j])
    |> maybe_increment_counter(content[i - 1][j + 1])
    |> maybe_increment_counter(content[i][j - 1])
    |> maybe_increment_counter(content[i][j + 1])
    |> maybe_increment_counter(content[i + 1][j - 1])
    |> maybe_increment_counter(content[i + 1][j])
    |> maybe_increment_counter(content[i + 1][j + 1])
  end

  defp maybe_increment_counter(counter, :alive), do: counter + 1
  defp maybe_increment_counter(counter, _), do: counter

  @doc """
  Computes state of cell in the next generation based on the number of alive neighbours.

  The official rules are:
  Any live cell with fewer than two live neighbours dies, as if by underpopulation.
  Any live cell with two or three live neighbours lives on to the next generation.
  Any live cell with more than three live neighbours dies, as if by overpopulation.
  Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
  """
  def process_cell(:alive, alive_neighbours) when alive_neighbours < 2, do: :dead
  def process_cell(:alive, alive_neighbours) when alive_neighbours in [2, 3], do: :alive
  def process_cell(:alive, alive_neighbours) when alive_neighbours > 3, do: :dead
  def process_cell(:dead, 3), do: :alive
  def process_cell(state, _alive_neighbours), do: state

  @doc """
  Toggles state of cell with given column and row index in a board
  """
  def toggle_cell(%__MODULE__{content: content} = board, {col, row}) do
    %{
      board
      | content:
          Map.put(content, col, Map.put(content[col], row, toggle_value(content[col][row])))
    }
  end

  defp toggle_value(:dead), do: :alive
  defp toggle_value(:alive), do: :dead
end
