defmodule ActionCube.Snake.BoardTest do
  use ExUnit.Case
  alias ActionCube.Snake.Board

  describe "start/2" do
    test "builds an initial board" do
      board = Board.start(2)

      assert %Board{
               content: %{
                 0 => %{0 => _, 1 => _},
                 1 => %{0 => _, 1 => :snake_head}
               },
               size: 2,
               snake_direction: :up,
               snake_head_coords: {1, 1}
             } = board

      assert :treat =
               (Map.values(board.content[0]) ++ Map.values(board.content[1]))
               |> Enum.find(&(&1 == :treat))

      assert [:empty, :empty] =
               (Map.values(board.content[0]) ++ Map.values(board.content[1]))
               |> Enum.filter(&(&1 == :empty))
    end

    test "builds an initial board with more treats" do
      assert %Board{
               content: %{
                 0 => %{0 => :treat, 1 => :treat},
                 1 => %{0 => :treat, 1 => :snake_head}
               },
               size: 2,
               snake_direction: :up,
               snake_head_coords: {1, 1}
             } = Board.start(2, 3)
    end
  end

  describe "new/1" do
    test "build a map with as many keys as board size" do
      assert %Board{
               content: %{
                 0 => %{0 => :empty, 1 => :empty},
                 1 => %{0 => :empty, 1 => :empty}
               },
               size: 2,
               snake_direction: :up
             } = Board.new(2)
    end
  end

  describe "spawn_snake/1" do
    test "spawn snakes in the middle if size odd" do
      assert %Board{
               content: %{
                 0 => %{0 => :empty, 1 => :empty, 2 => :empty},
                 1 => %{0 => :empty, 1 => :snake_head, 2 => :empty},
                 2 => %{0 => :empty, 1 => :empty, 2 => :empty}
               },
               size: 3,
               snake_direction: :up,
               snake_head_coords: {1, 1}
             } = Board.new(3) |> Board.spawn_snake()
    end

    test "spawn snakes near the middle if size even" do
      assert %Board{
               content: %{
                 0 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty},
                 1 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty},
                 2 => %{0 => :empty, 1 => :empty, 2 => :snake_head, 3 => :empty},
                 3 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty}
               },
               size: 4,
               snake_direction: :up,
               snake_head_coords: {2, 2}
             } = Board.new(4) |> Board.spawn_snake()
    end
  end

  describe "spawn_treat/1" do
    test "spawns treat somewhere" do
      board = Board.new(2) |> Board.spawn_treat()

      assert :treat =
               (Map.values(board.content[0]) ++ Map.values(board.content[1]))
               |> Enum.find(&(&1 == :treat))
    end

    test "spawns treat somewhere that is not a snake" do
      assert %Board{
               content: %{
                 0 => %{0 => :snake, 1 => :snake_head},
                 1 => %{0 => :snake, 1 => :treat}
               },
               size: 2,
               snake_direction: :down,
               snake_head_coords: {1, 0}
             } =
               %Board{
                 content: %{
                   0 => %{0 => :snake, 1 => :snake_head},
                   1 => %{0 => :snake, 1 => :empty}
                 },
                 size: 2,
                 snake_direction: :down,
                 snake_head_coords: {1, 0}
               }
               |> Board.spawn_treat()
    end
  end

  describe "process_tick/1" do
    test "up direction - changes snake placement" do
      board = Board.new(4) |> Board.spawn_snake()

      assert {:ok,
              %Board{
                content: %{
                  0 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty},
                  1 => %{0 => :empty, 1 => :empty, 2 => :snake_head, 3 => :empty},
                  2 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty},
                  3 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty}
                },
                size: 4,
                snake_direction: :up,
                snake_head_coords: {2, 1}
              }} = Board.process_tick(board)
    end

    test "up direction - changes snake placement and stops the game if it touches a wall" do
      {:ok, board} = Board.new(4) |> Board.spawn_snake() |> Board.process_tick()
      {:ok, board} = board |> Board.process_tick()

      assert {:stop,
              %Board{
                content: %{
                  0 => %{0 => :empty, 1 => :empty, 2 => :snake_head, 3 => :empty},
                  1 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty},
                  2 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty},
                  3 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty}
                },
                size: 4,
                snake_direction: :up,
                snake_head_coords: {2, 0}
              }} = Board.process_tick(board)
    end

    test "down direction - changes snake placement" do
      board = Board.new(4) |> Board.spawn_snake() |> Board.change_direction(:down)

      assert {:ok,
              %Board{
                content: %{
                  0 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty},
                  1 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty},
                  2 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty},
                  3 => %{0 => :empty, 1 => :empty, 2 => :snake_head, 3 => :empty}
                },
                size: 4,
                snake_direction: :down,
                snake_head_coords: {2, 3}
              }} = Board.process_tick(board)
    end

    test "down direction - changes snake placement and stops the game if it touches a wall" do
      {:ok, board} =
        Board.new(4)
        |> Board.spawn_snake()
        |> Board.change_direction(:down)
        |> Board.process_tick()

      assert {:stop,
              %Board{
                content: %{
                  0 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty},
                  1 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty},
                  2 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty},
                  3 => %{0 => :empty, 1 => :empty, 2 => :snake_head, 3 => :empty}
                },
                size: 4,
                snake_direction: :down,
                snake_head_coords: {2, 3}
              }} = Board.process_tick(board)
    end

    test "left direction - changes snake placement" do
      board = Board.new(4) |> Board.spawn_snake() |> Board.change_direction(:left)

      assert {:ok,
              %Board{
                content: %{
                  0 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty},
                  1 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty},
                  2 => %{0 => :empty, 1 => :snake_head, 2 => :empty, 3 => :empty},
                  3 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty}
                },
                size: 4,
                snake_direction: :left,
                snake_head_coords: {1, 2}
              }} = Board.process_tick(board)
    end

    test "left direction - changes snake placement and stops the game if it touches a wall" do
      {:ok, board} =
        Board.new(4)
        |> Board.spawn_snake()
        |> Board.change_direction(:left)
        |> Board.process_tick()

      {:ok, board} = board |> Board.process_tick()

      assert {:stop,
              %Board{
                content: %{
                  0 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty},
                  1 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty},
                  2 => %{0 => :snake_head, 1 => :empty, 2 => :empty, 3 => :empty},
                  3 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty}
                },
                size: 4,
                snake_direction: :left,
                snake_head_coords: {0, 2}
              }} = Board.process_tick(board)
    end

    test "right direction - changes snake placement" do
      board = Board.new(4) |> Board.spawn_snake() |> Board.change_direction(:right)

      assert {:ok,
              %Board{
                content: %{
                  0 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty},
                  1 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty},
                  2 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :snake_head},
                  3 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty}
                },
                size: 4,
                snake_direction: :right,
                snake_head_coords: {3, 2}
              }} = Board.process_tick(board)
    end

    test "right direction - changes snake placement and stops the game if it touches a wall" do
      {:ok, board} =
        Board.new(4)
        |> Board.spawn_snake()
        |> Board.change_direction(:right)
        |> Board.process_tick()

      assert {:stop,
              %Board{
                content: %{
                  0 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty},
                  1 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty},
                  2 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :snake_head},
                  3 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty}
                },
                size: 4,
                snake_direction: :right,
                snake_head_coords: {3, 2}
              }} = Board.process_tick(board)
    end

    test "eats treat, becomes longer and spawns new treat" do
      board = %Board{
        content: %{
          0 => %{0 => :empty, 1 => :snake_head},
          1 => %{0 => :empty, 1 => :treat}
        },
        size: 2,
        snake_direction: :down,
        snake_head_coords: {1, 0},
        snake_coords: [{1, 0}]
      }

      assert {:ok, board} = board |> Board.process_tick()

      assert %Board{
               content: %{
                 0 => %{0 => _, 1 => :snake},
                 1 => %{0 => _, 1 => :snake_head}
               },
               size: 2,
               snake_direction: :down,
               snake_head_coords: {1, 1}
             } = board

      assert :treat =
               (Map.values(board.content[0]) ++ Map.values(board.content[1]))
               |> Enum.find(&(&1 == :treat))
    end

    test "moves with longer snake" do
      board = %Board{
        content: %{
          0 => %{0 => :empty, 1 => :snake_head, 2 => :empty},
          1 => %{0 => :empty, 1 => :snake, 2 => :snake},
          2 => %{0 => :empty, 1 => :empty, 2 => :empty}
        },
        size: 3,
        snake_direction: :left,
        snake_head_coords: {1, 0},
        snake_coords: [{2, 1}, {1, 1}, {1, 0}]
      }

      assert {:ok, board} = board |> Board.process_tick()

      assert %Board{
               content: %{
                 0 => %{0 => :snake_head, 1 => :snake, 2 => :empty},
                 1 => %{0 => :empty, 1 => :snake, 2 => :empty},
                 2 => %{0 => :empty, 1 => :empty, 2 => :empty}
               },
               size: 3,
               snake_direction: :left,
               snake_head_coords: {0, 0},
               snake_coords: [{1, 1}, {1, 0}, {0, 0}]
             } = board

      assert {:ok, board} = board |> Board.change_direction(:down) |> Board.process_tick()

      assert %Board{
               content: %{
                 0 => %{0 => :snake, 1 => :snake, 2 => :empty},
                 1 => %{0 => :snake_head, 1 => :empty, 2 => :empty},
                 2 => %{0 => :empty, 1 => :empty, 2 => :empty}
               },
               size: 3,
               snake_direction: :down,
               snake_head_coords: {0, 1},
               snake_coords: [{1, 0}, {0, 0}, {0, 1}]
             } = board
    end

    test "stops the game if snakes eats itself" do
      board = %Board{
        content: %{
          0 => %{0 => :empty, 1 => :snake, 2 => :empty},
          1 => %{0 => :empty, 1 => :snake, 2 => :snake},
          2 => %{0 => :empty, 1 => :snake_head, 2 => :snake}
        },
        size: 3,
        snake_direction: :up,
        snake_head_coords: {1, 2},
        snake_coords: [{1, 0}, {1, 1}, {2, 1}, {2, 2}, {1, 2}]
      }

      assert {:stop, ^board} = board |> Board.process_tick()
    end
  end

  describe "change_direction/2" do
    test "change to up" do
      assert %Board{
               content: %{
                 0 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty},
                 1 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty},
                 2 => %{0 => :empty, 1 => :empty, 2 => :snake_head, 3 => :empty},
                 3 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty}
               },
               size: 4,
               snake_direction: :up,
               snake_head_coords: {2, 2}
             } =
               Board.new(4)
               |> Board.spawn_snake()
               |> Board.change_direction(:left)
               |> Board.change_direction(:up)
    end

    test "change to down" do
      assert %Board{
               content: %{
                 0 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty},
                 1 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty},
                 2 => %{0 => :empty, 1 => :empty, 2 => :snake_head, 3 => :empty},
                 3 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty}
               },
               size: 4,
               snake_direction: :down,
               snake_head_coords: {2, 2}
             } = Board.new(4) |> Board.spawn_snake() |> Board.change_direction(:down)
    end

    test "change to left" do
      assert %Board{
               content: %{
                 0 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty},
                 1 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty},
                 2 => %{0 => :empty, 1 => :empty, 2 => :snake_head, 3 => :empty},
                 3 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty}
               },
               size: 4,
               snake_direction: :left,
               snake_head_coords: {2, 2}
             } = Board.new(4) |> Board.spawn_snake() |> Board.change_direction(:left)
    end

    test "change to right" do
      assert %Board{
               content: %{
                 0 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty},
                 1 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty},
                 2 => %{0 => :empty, 1 => :empty, 2 => :snake_head, 3 => :empty},
                 3 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty}
               },
               size: 4,
               snake_direction: :right,
               snake_head_coords: {2, 2}
             } = Board.new(4) |> Board.spawn_snake() |> Board.change_direction(:right)
    end

    test "doesn't change if given nil" do
      assert %Board{
               content: %{
                 0 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty},
                 1 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty},
                 2 => %{0 => :empty, 1 => :empty, 2 => :snake_head, 3 => :empty},
                 3 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty}
               },
               size: 4,
               snake_direction: :right,
               snake_head_coords: {2, 2}
             } =
               Board.new(4)
               |> Board.spawn_snake()
               |> Board.change_direction(:right)
               |> Board.change_direction(nil)
    end
  end
end
