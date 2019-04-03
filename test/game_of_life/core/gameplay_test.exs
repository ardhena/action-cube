defmodule GameOfLife.Core.GameplayTest do
  use ExUnit.Case
  alias GameOfLife.Core.{Board, Gameplay}

  describe "start/1" do
    test "creates board with initial random population" do
      assert %Gameplay{tick_number: 0, board: %Board{size: 5, content: _content}} =
               Gameplay.start(5)
    end
  end

  describe "process_tick/1" do
    test "changes board content every tick" do
      blinker_1 = %Board{
        size: 5,
        content: %{
          0 => %{
            0 => :dead,
            1 => :dead,
            2 => :dead,
            3 => :dead,
            4 => :dead
          },
          1 => %{
            0 => :dead,
            1 => :dead,
            2 => :dead,
            3 => :dead,
            4 => :dead
          },
          2 => %{
            0 => :dead,
            1 => :alive,
            2 => :alive,
            3 => :alive,
            4 => :dead
          },
          3 => %{
            0 => :dead,
            1 => :dead,
            2 => :dead,
            3 => :dead,
            4 => :dead
          },
          4 => %{
            0 => :dead,
            1 => :dead,
            2 => :dead,
            3 => :dead,
            4 => :dead
          }
        }
      }

      blinker_2 = %Board{
        size: 5,
        content: %{
          0 => %{
            0 => :dead,
            1 => :dead,
            2 => :dead,
            3 => :dead,
            4 => :dead
          },
          1 => %{
            0 => :dead,
            1 => :dead,
            2 => :alive,
            3 => :dead,
            4 => :dead
          },
          2 => %{
            0 => :dead,
            1 => :dead,
            2 => :alive,
            3 => :dead,
            4 => :dead
          },
          3 => %{
            0 => :dead,
            1 => :dead,
            2 => :alive,
            3 => :dead,
            4 => :dead
          },
          4 => %{
            0 => :dead,
            1 => :dead,
            2 => :dead,
            3 => :dead,
            4 => :dead
          }
        }
      }

      gameplay = %Gameplay{tick_number: 1, board: blinker_1}

      assert %Gameplay{tick_number: 2, board: ^blinker_2} =
               gameplay
               |> Gameplay.process_tick()

      assert %Gameplay{tick_number: 3, board: ^blinker_1} =
               gameplay
               |> Gameplay.process_tick()
               |> Gameplay.process_tick()

      assert %Gameplay{tick_number: 4, board: ^blinker_2} =
               gameplay
               |> Gameplay.process_tick()
               |> Gameplay.process_tick()
               |> Gameplay.process_tick()

      assert %Gameplay{tick_number: 5, board: ^blinker_1} =
               gameplay
               |> Gameplay.process_tick()
               |> Gameplay.process_tick()
               |> Gameplay.process_tick()
               |> Gameplay.process_tick()
    end
  end
end
