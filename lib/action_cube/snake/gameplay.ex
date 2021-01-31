defmodule ActionCube.Snake.Gameplay do
  alias ActionCube.Snake.Board

  defstruct [:board, :tick_number, :subtick_number, :score]

  @doc """
  Starts game
  """
  def start(board_size, treat_number) do
    %__MODULE__{
      board: Board.start(board_size, treat_number),
      tick_number: 0,
      subtick_number: 0,
      score: 0
    }
  end

  def check_tick(%__MODULE__{subtick_number: subtick_number}, speed)
      when subtick_number + 1 >= speed,
      do: :tick

  def check_tick(%__MODULE__{}, _speed), do: :subtick

  @doc """
  Processes tick according to given game speed. Game speed is number of subticks needed to change the tick.
  """
  def process_tick(
        %__MODULE__{board: board, tick_number: tick_number, subtick_number: subtick_number} =
          gameplay,
        speed
      )
      when subtick_number + 1 >= speed do
    {status, board} = Board.process_tick(board)

    {status,
     %{
       gameplay
       | board: board,
         tick_number: tick_number + 1,
         subtick_number: 0,
         score: length(board.snake_coords) - 1
     }}
  end

  def process_tick(%__MODULE__{subtick_number: subtick_number} = gameplay, _speed) do
    {:ok, %{gameplay | subtick_number: subtick_number + 1}}
  end

  @doc """
  Changes snake direction
  """
  def change_direction(%__MODULE__{board: board} = gameplay, new_direction) do
    %{gameplay | board: Board.change_direction(board, new_direction)}
  end
end
