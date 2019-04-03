defmodule GameOfLife.Core.Gameplay do
  alias GameOfLife.Core.Board

  defstruct [:board, :tick_number]

  def start(board_size) do
    board_size
    |> Board.new()

    # |> Board.randomly_populate()
  end

  def process_tick(%__MODULE__{board: board, tick_number: tick_number} = gameplay) do
    %{gameplay | board: Board.next_generation(board), tick_number: tick_number + 1}
  end
end
