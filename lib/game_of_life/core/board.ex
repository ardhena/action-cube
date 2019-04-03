defmodule GameOfLife.Core.Board do
  defstruct [:size, :content]

  def new(size) when is_integer(size) do
    row = Enum.reduce(0..(size - 1), %{}, fn i, map -> Map.put(map, i, :dead) end)
    array = Enum.reduce(0..(size - 1), %{}, fn i, map -> Map.put(map, i, row) end)

    %__MODULE__{size: size, content: array}
  end

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
                content |> get_alive_neighbours(i, j) |> length()
              )

            Map.put(row, j, new_cell)
          end)
        )
      end)

    %{board | content: next_board}
  end

  defp get_alive_neighbours(content, i, j) do
    [
      content[i - 1][j - 1],
      content[i - 1][j],
      content[i - 1][j + 1],
      content[i][j - 1],
      content[i][j + 1],
      content[i + 1][j - 1],
      content[i + 1][j],
      content[i + 1][j + 1]
    ]
    |> Enum.filter(&(&1 == :alive))
  end

  def process_cell(:alive, alive_neighbours) when alive_neighbours < 2, do: :dead
  def process_cell(:alive, alive_neighbours) when alive_neighbours in [2, 3], do: :alive
  def process_cell(:alive, alive_neighbours) when alive_neighbours > 3, do: :dead
  def process_cell(:dead, 3), do: :alive
  def process_cell(state, _alive_neighbours), do: state
end
