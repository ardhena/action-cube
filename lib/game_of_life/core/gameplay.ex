defmodule GameOfLife.Core.Gameplay do
  alias GameOfLife.Core.Board

  defstruct [:board, :tick_number]

  def start(board_size) do
    %__MODULE__{board: board_size |> Board.new() |> Board.randomly_populate(), tick_number: 0}
  end

  def process_tick(%__MODULE__{board: board, tick_number: tick_number} = gameplay) do
    %{gameplay | board: Board.next_generation(board), tick_number: tick_number + 1}
  end

  def toggle_cell(%__MODULE__{board: board} = gameplay, {col, row}) do
    %{gameplay | board: Board.toggle_cell(board, {col, row})}
  end
end
