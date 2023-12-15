defmodule ParabolicReflectorDish do
  def problem_one(filename \\ "lib/day14/input.txt") do
    Aoc23.read_lines(filename)
    |> Enum.map(&String.split(&1, "", trim: true))
    |> north()
    |> cost()
  end

  def north(board) do
    board
    |> Enum.reverse()
    |> transpose()
    |> cycle()
    |> transpose()
    |> Enum.reverse()
  end

  def south(board) do
    board
    |> transpose()
    |> cycle()
    |> transpose()
  end

  def west(board) do
    board
    |> Enum.map(&Enum.reverse/1)
    |> cycle()
    |> Enum.map(&Enum.reverse/1)
  end

  def cycle(x) do
    case roll_board(x) do
      v when v == x -> v
      v -> cycle(v)
    end
  end

  def roll_board([]), do: []
  def roll_board([line | lines]), do: [roll_rocks(line)] ++ roll_board(lines)

  def roll_rocks([]), do: []
  def roll_rocks([v]), do: [v]
  def roll_rocks(["O", "." | rest]), do: ["." | roll_rocks(["O" | rest])]
  def roll_rocks([f, s | rest]), do: [f | roll_rocks([s | rest])]

  def cost(lines) do
    Enum.with_index(lines)
    |> Enum.reduce(0, fn {line, i}, acc ->
      Enum.count(line, &(&1 == "O")) * (length(lines) - i) + acc
    end)
  end

  def problem_two(filename \\ "lib/day14/input.txt", cycles \\ 1_000_000_000) do
    Aoc23.read_lines(filename)
    |> Enum.map(&String.split(&1, "", trim: true))
    |> cycle([], 0, cycles)
    |> cost()
  end

  def cycle(board, _, i, c) when i == c, do: board

  def cycle(board, boards, i, cycles) do
    if board in boards do
      index = Enum.find_index(boards, &(&1 == board))
      Enum.at(boards, rem(cycles - index, length(boards) - index) + index)
    else
      board
      |> north()
      |> west()
      |> south()
      |> cycle()
      |> cycle(boards ++ [board], i + 1, cycles)
    end
  end

  def transpose(pattern) do
    pattern
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end
end
