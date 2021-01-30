defmodule ActionCube.GameOfLife.BoardTest do
  use ExUnit.Case
  alias ActionCube.GameOfLife.Board

  describe "new/1" do
    test "creates new board of given size" do
      assert %Board{
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
                   1 => :dead,
                   2 => :dead,
                   3 => :dead,
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
             } = Board.new(5)
    end
  end

  describe "next_generation/1" do
    test "a block stays a block" do
      board = %Board{
        size: 4,
        content: %{
          0 => %{
            0 => :dead,
            1 => :dead,
            2 => :dead,
            3 => :dead
          },
          1 => %{
            0 => :dead,
            1 => :alive,
            2 => :alive,
            3 => :dead
          },
          2 => %{
            0 => :dead,
            1 => :alive,
            2 => :alive,
            3 => :dead
          },
          3 => %{
            0 => :dead,
            1 => :dead,
            2 => :dead,
            3 => :dead
          }
        }
      }

      assert ^board = Board.next_generation(board)
    end

    test "a beehive stays a beehive" do
      board = %Board{
        size: 6,
        content: %{
          0 => %{
            0 => :dead,
            1 => :dead,
            2 => :dead,
            3 => :dead,
            4 => :dead,
            5 => :dead
          },
          1 => %{
            0 => :dead,
            1 => :dead,
            2 => :alive,
            3 => :alive,
            4 => :dead,
            5 => :dead
          },
          2 => %{
            0 => :dead,
            1 => :alive,
            2 => :dead,
            3 => :dead,
            4 => :alive,
            5 => :dead
          },
          3 => %{
            0 => :dead,
            1 => :dead,
            2 => :alive,
            3 => :alive,
            4 => :dead,
            5 => :dead
          },
          4 => %{
            0 => :dead,
            1 => :dead,
            2 => :dead,
            3 => :dead,
            4 => :dead,
            5 => :dead
          },
          5 => %{
            0 => :dead,
            1 => :dead,
            2 => :dead,
            3 => :dead,
            4 => :dead,
            5 => :dead
          }
        }
      }

      assert ^board = Board.next_generation(board)
    end

    test "a blinker changes to second stage" do
      board = %Board{
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

      assert %Board{
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
             } = Board.next_generation(board)
    end

    test "a toad changes to second stage" do
      board = %Board{
        size: 6,
        content: %{
          0 => %{
            0 => :dead,
            1 => :dead,
            2 => :dead,
            3 => :dead,
            4 => :dead,
            5 => :dead
          },
          1 => %{
            0 => :dead,
            1 => :dead,
            2 => :dead,
            3 => :alive,
            4 => :dead,
            5 => :dead
          },
          2 => %{
            0 => :dead,
            1 => :alive,
            2 => :dead,
            3 => :dead,
            4 => :alive,
            5 => :dead
          },
          3 => %{
            0 => :dead,
            1 => :alive,
            2 => :dead,
            3 => :dead,
            4 => :alive,
            5 => :dead
          },
          4 => %{
            0 => :dead,
            1 => :dead,
            2 => :alive,
            3 => :dead,
            4 => :dead,
            5 => :dead
          },
          5 => %{
            0 => :dead,
            1 => :dead,
            2 => :dead,
            3 => :dead,
            4 => :dead,
            5 => :dead
          }
        }
      }

      assert %Board{
               size: 6,
               content: %{
                 0 => %{
                   0 => :dead,
                   1 => :dead,
                   2 => :dead,
                   3 => :dead,
                   4 => :dead,
                   5 => :dead
                 },
                 1 => %{
                   0 => :dead,
                   1 => :dead,
                   2 => :dead,
                   3 => :dead,
                   4 => :dead,
                   5 => :dead
                 },
                 2 => %{
                   0 => :dead,
                   1 => :dead,
                   2 => :alive,
                   3 => :alive,
                   4 => :alive,
                   5 => :dead
                 },
                 3 => %{
                   0 => :dead,
                   1 => :alive,
                   2 => :alive,
                   3 => :alive,
                   4 => :dead,
                   5 => :dead
                 },
                 4 => %{
                   0 => :dead,
                   1 => :dead,
                   2 => :dead,
                   3 => :dead,
                   4 => :dead,
                   5 => :dead
                 },
                 5 => %{
                   0 => :dead,
                   1 => :dead,
                   2 => :dead,
                   3 => :dead,
                   4 => :dead,
                   5 => :dead
                 }
               }
             } = Board.next_generation(board)
    end
  end

  describe "process_cell/2" do
    test "Any live cell with fewer than two live neighbours dies, as if by underpopulation" do
      assert :dead = Board.process_cell(:alive, 0)
      assert :dead = Board.process_cell(:alive, 1)
    end

    test "Any live cell with two or three live neighbours lives on to the next generation" do
      assert :alive = Board.process_cell(:alive, 2)
      assert :alive = Board.process_cell(:alive, 3)
    end

    test "Any live cell with more than three live neighbours dies, as if by overpopulation" do
      assert :dead = Board.process_cell(:alive, 4)
      assert :dead = Board.process_cell(:alive, 6)
      assert :dead = Board.process_cell(:alive, 7)
      assert :dead = Board.process_cell(:alive, 8)
    end

    test "Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction" do
      assert :dead = Board.process_cell(:dead, 0)
      assert :dead = Board.process_cell(:dead, 1)
      assert :dead = Board.process_cell(:dead, 2)
      assert :alive = Board.process_cell(:dead, 3)
      assert :dead = Board.process_cell(:dead, 4)
      assert :dead = Board.process_cell(:dead, 5)
      assert :dead = Board.process_cell(:dead, 6)
      assert :dead = Board.process_cell(:dead, 7)
      assert :dead = Board.process_cell(:dead, 8)
    end
  end

  describe "toggle_cell/2" do
    test "toggles cell value" do
      board = %Board{
        size: 2,
        content: %{
          0 => %{
            0 => :dead,
            1 => :dead
          },
          1 => %{
            0 => :dead,
            1 => :dead
          }
        }
      }

      assert %Board{
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
             } = Board.toggle_cell(board, {0, 1})

      assert %Board{
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
             } = Board.toggle_cell(board, {1, 0})
    end
  end
end
