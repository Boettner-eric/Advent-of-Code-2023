defmodule MirageMaintenance do
  def problem_one(filename \\ "lib/day9/input.txt") do
    Aoc23.read_lines(filename)
    |> Enum.reduce(0, fn line, acc ->
      line
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> expand_and_lookup_index(-1)
      |> Kernel.+(acc)
    end)
  end

  def expand_and_lookup_index(line, index) do
    cond do
      Enum.all?(line, &Kernel.==(&1, 0)) -> Enum.at(line, index)
      index == -1 -> (expand_line(line) |> expand_and_lookup_index(index)) + Enum.at(line, index)
      index == 0 -> Enum.at(line, index) - (expand_line(line) |> expand_and_lookup_index(index))
    end
  end

  def expand_line(list) do
    case list do
      [a, b | tail] -> [b - a | expand_line([b | tail])]
      _ -> []
    end
  end

  def problem_two(filename \\ "lib/day9/input.txt") do
    Aoc23.read_lines(filename)
    |> Enum.reduce(0, fn line, acc ->
      line
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> expand_and_lookup_index(0)
      |> Kernel.+(acc)
    end)
  end
end
