defmodule ActionCube.Snake.BoardTest do
  use ExUnit.Case
  alias ActionCube.Snake.Board

  describe "start/1" do
    test "builds an initial board" do
      assert %Board{
               content: %{
                 0 => %{0 => :empty, 1 => :empty},
                 1 => %{0 => :empty, 1 => :snake}
               },
               size: 2,
               snake_direction: :up,
               snake_head_coords: {1, 1}
             } = Board.start(2)
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

  describe "spawn_snake/0" do
    test "spawn snakes in the middle if size odd" do
      assert %Board{
               content: %{
                 0 => %{0 => :empty, 1 => :empty, 2 => :empty},
                 1 => %{0 => :empty, 1 => :snake, 2 => :empty},
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
                 2 => %{0 => :empty, 1 => :empty, 2 => :snake, 3 => :empty},
                 3 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty}
               },
               size: 4,
               snake_direction: :up,
               snake_head_coords: {2, 2}
             } = Board.new(4) |> Board.spawn_snake()
    end
  end

  describe "process_tick/1" do
    test "up direction - changes snake placement" do
      board = Board.new(4) |> Board.spawn_snake()

      assert {:ok,
              %Board{
                content: %{
                  0 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty},
                  1 => %{0 => :empty, 1 => :empty, 2 => :snake, 3 => :empty},
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
                  0 => %{0 => :empty, 1 => :empty, 2 => :snake, 3 => :empty},
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
                  3 => %{0 => :empty, 1 => :empty, 2 => :snake, 3 => :empty}
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
                  3 => %{0 => :empty, 1 => :empty, 2 => :snake, 3 => :empty}
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
                  2 => %{0 => :empty, 1 => :snake, 2 => :empty, 3 => :empty},
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
                  2 => %{0 => :snake, 1 => :empty, 2 => :empty, 3 => :empty},
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
                  2 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :snake},
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
                  2 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :snake},
                  3 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty}
                },
                size: 4,
                snake_direction: :right,
                snake_head_coords: {3, 2}
              }} = Board.process_tick(board)
    end
  end

  describe "change_direction/2" do
    test "change to up" do
      assert %Board{
               content: %{
                 0 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty},
                 1 => %{0 => :empty, 1 => :empty, 2 => :empty, 3 => :empty},
                 2 => %{0 => :empty, 1 => :empty, 2 => :snake, 3 => :empty},
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
                 2 => %{0 => :empty, 1 => :empty, 2 => :snake, 3 => :empty},
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
                 2 => %{0 => :empty, 1 => :empty, 2 => :snake, 3 => :empty},
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
                 2 => %{0 => :empty, 1 => :empty, 2 => :snake, 3 => :empty},
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
                 2 => %{0 => :empty, 1 => :empty, 2 => :snake, 3 => :empty},
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
