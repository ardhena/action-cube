defmodule ActionCube.Snake.GameplayTest do
  use ExUnit.Case
  alias ActionCube.Snake.{Board, Gameplay}

  describe "start/1" do
    test "creates board" do
      assert %Gameplay{
               tick_number: 0,
               subtick_number: 0,
               score: 0,
               board: %Board{size: 5, content: _content}
             } = Gameplay.start(5)
    end
  end

  describe "process_tick/2" do
    test "with speed = 1, changes board content every tick" do
      %{board: board} = gameplay = Gameplay.start(5)

      assert {:ok, %Gameplay{tick_number: 1, board: last_board} = gameplay} =
               gameplay
               |> Gameplay.process_tick(1)

      assert last_board != board
      board = last_board

      assert {:ok, %Gameplay{tick_number: 2, board: last_board} = gameplay} =
               gameplay
               |> Gameplay.process_tick(1)

      assert last_board != board
      board = last_board

      assert {:stop, %Gameplay{tick_number: 3, board: last_board}} =
               gameplay
               |> Gameplay.process_tick(1)

      assert last_board == board
    end

    test "with speed = 2, changes board content every second tick" do
      %{board: board} = gameplay = Gameplay.start(5)

      assert {:ok, %Gameplay{tick_number: 0, subtick_number: 1, board: last_board} = gameplay} =
               gameplay
               |> Gameplay.process_tick(2)

      assert last_board == board
      board = last_board

      assert {:ok, %Gameplay{tick_number: 1, subtick_number: 0, board: last_board} = gameplay} =
               gameplay
               |> Gameplay.process_tick(2)

      assert last_board != board
      board = last_board

      assert {:ok, %Gameplay{tick_number: 1, subtick_number: 1, board: last_board} = gameplay} =
               gameplay
               |> Gameplay.process_tick(2)

      assert last_board == board
      board = last_board

      assert {:ok, %Gameplay{tick_number: 2, subtick_number: 0, board: last_board} = gameplay} =
               gameplay
               |> Gameplay.process_tick(2)

      assert last_board != board
      board = last_board

      assert {:ok, %Gameplay{tick_number: 2, subtick_number: 1, board: last_board} = gameplay} =
               gameplay
               |> Gameplay.process_tick(2)

      assert last_board == board
      board = last_board

      assert {:stop, %Gameplay{tick_number: 3, subtick_number: 0, board: last_board}} =
               gameplay
               |> Gameplay.process_tick(2)

      assert last_board == board
    end
  end

  describe "change_direction/2" do
    test "changes direction in board" do
      assert %Gameplay{
               tick_number: 0,
               subtick_number: 0,
               score: 0,
               board: %Board{size: 5, snake_direction: :down}
             } = Gameplay.start(5) |> Gameplay.change_direction(:down)
    end
  end
end
