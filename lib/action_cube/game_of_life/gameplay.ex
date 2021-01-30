defmodule ActionCube.GameOfLife.Gameplay do
  alias ActionCube.GameOfLife.Board

  defstruct [:board, :tick_number, :subtick_number]

  @doc """
  Starts game with chosen initial board population type
  """
  def start(board_size, initial_population_type) do
    %__MODULE__{
      board: board_size |> Board.new() |> Board.populate(initial_population_type),
      tick_number: 0,
      subtick_number: 0
    }
  end

  @doc """
  Processes tick according to given game speed. Game speed is number of subticks needed to change the tick.
  """
  def process_tick(
        %__MODULE__{board: board, tick_number: tick_number, subtick_number: subtick_number} =
          gameplay,
        speed
      )
      when subtick_number + 1 >= speed do
    %{
      gameplay
      | board: Board.next_generation(board),
        tick_number: tick_number + 1,
        subtick_number: 0
    }
  end

  def process_tick(%__MODULE__{subtick_number: subtick_number} = gameplay, _speed) do
    %{gameplay | subtick_number: subtick_number + 1}
  end

  @doc """
  Toggles value of given cell. Alive cell becomes dead, dead cell becomes alive.
  """
  def toggle_cell(%__MODULE__{board: board} = gameplay, {col, row}) do
    %{gameplay | board: Board.toggle_cell(board, {col, row})}
  end
end
