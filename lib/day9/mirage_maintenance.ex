defmodule MirageMaintenance do
  def problem_one(filename \\ "lib/day9/input.txt") do
    Aoc23.read_lines(filename)
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.reduce(0, fn line, acc ->
      line
      |> Enum.map(&String.to_integer/1)
      |> keep_expanding()
      |> Enum.sum()
      |> Kernel.+(acc)
    end)
  end

  def keep_expanding(line, index \\ -1) do
    last = Enum.at(line, index)

    if Enum.all?(line, &Kernel.==(&1, 0)) do
      [last]
    else
      (expand_line(line) |> keep_expanding(index)) ++ [last]
    end
  end

  def expand_line([a, b | tail]) do
    [b - a | expand_line([b | tail])]
  end

  def expand_line(_) do
    []
  end

  def problem_two(filename \\ "lib/day9/input.txt") do
    Aoc23.read_lines(filename)
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.reduce(0, fn line, acc ->
      line
      |> Enum.map(&String.to_integer/1)
      |> keep_expanding(0)
      |> Enum.reduce(0, &(&1 - &2))
      |> Kernel.+(acc)
    end)
  end
end
