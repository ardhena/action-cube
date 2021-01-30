defmodule ActionCube.GameOfLife.GameplayTest do
  use ExUnit.Case
  alias ActionCube.GameOfLife.{Board, Gameplay}

  describe "start/1" do
    test "creates board with initial population" do
      assert %Gameplay{tick_number: 0, board: %Board{size: 5, content: _content}} =
               Gameplay.start(5, "clear")
    end
  end

  describe "process_tick/2" do
    setup do
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

      gameplay = %Gameplay{tick_number: 1, board: blinker_1, subtick_number: 0}

      %{blinker_1: blinker_1, blinker_2: blinker_2, gameplay: gameplay}
    end

    test "with speed = 1, changes board content every tick", %{
      blinker_1: blinker_1,
      blinker_2: blinker_2,
      gameplay: gameplay
    } do
      assert %Gameplay{tick_number: 2, board: ^blinker_2} =
               gameplay
               |> Gameplay.process_tick(1)

      assert %Gameplay{tick_number: 3, board: ^blinker_1} =
               gameplay
               |> Gameplay.process_tick(1)
               |> Gameplay.process_tick(1)

      assert %Gameplay{tick_number: 4, board: ^blinker_2} =
               gameplay
               |> Gameplay.process_tick(1)
               |> Gameplay.process_tick(1)
               |> Gameplay.process_tick(1)

      assert %Gameplay{tick_number: 5, board: ^blinker_1} =
               gameplay
               |> Gameplay.process_tick(1)
               |> Gameplay.process_tick(1)
               |> Gameplay.process_tick(1)
               |> Gameplay.process_tick(1)
    end

    test "with speed = 2, changes board content every second tick", %{
      blinker_1: blinker_1,
      blinker_2: blinker_2,
      gameplay: gameplay
    } do
      assert %Gameplay{subtick_number: 1, tick_number: 1, board: ^blinker_1} =
               gameplay
               |> Gameplay.process_tick(2)

      assert %Gameplay{subtick_number: 0, tick_number: 2, board: ^blinker_2} =
               gameplay
               |> Gameplay.process_tick(2)
               |> Gameplay.process_tick(2)

      assert %Gameplay{subtick_number: 1, tick_number: 2, board: ^blinker_2} =
               gameplay
               |> Gameplay.process_tick(2)
               |> Gameplay.process_tick(2)
               |> Gameplay.process_tick(2)

      assert %Gameplay{subtick_number: 0, tick_number: 3, board: ^blinker_1} =
               gameplay
               |> Gameplay.process_tick(2)
               |> Gameplay.process_tick(2)
               |> Gameplay.process_tick(2)
               |> Gameplay.process_tick(2)

      assert %Gameplay{subtick_number: 1, tick_number: 3, board: ^blinker_1} =
               gameplay
               |> Gameplay.process_tick(2)
               |> Gameplay.process_tick(2)
               |> Gameplay.process_tick(2)
               |> Gameplay.process_tick(2)
               |> Gameplay.process_tick(2)

      assert %Gameplay{subtick_number: 0, tick_number: 4, board: ^blinker_2} =
               gameplay
               |> Gameplay.process_tick(2)
               |> Gameplay.process_tick(2)
               |> Gameplay.process_tick(2)
               |> Gameplay.process_tick(2)
               |> Gameplay.process_tick(2)
               |> Gameplay.process_tick(2)
    end
  end

  describe "toggle_cell/2" do
    test "toggles cell value" do
      gameplay = Gameplay.start(2, "clear")

      assert %Gameplay{
               board: %Board{
                 size: 2,
                 content: %{
                   0 => %{
                     0 => :dead,
                     1 => :alive
                   },
                   1 => %{
                     0 => :dead,
                     1 => :dead
                   }
                 }
               }
             } = Gameplay.toggle_cell(gameplay, {0, 1})

      assert %Gameplay{
               board: %Board{
                 size: 2,
                 content: %{
                   0 => %{
                     0 => :dead,
                     1 => :dead
                   },
                   1 => %{
                     0 => :alive,
                     1 => :dead
                   }
                 }
               }
             } = Gameplay.toggle_cell(gameplay, {1, 0})
    end
  end
end
