defmodule Gondola do
  def problem_one(filename \\ "lib/day4/input.txt") do
    Aoc23.read_lines(filename)
    |> Enum.map(fn line ->
      [_, winners, mine] = String.split(line, [":", "|"])
      winners = MapSet.new(String.split(winners, " ", trim: true))
      mine = MapSet.new(String.split(mine, " ", trim: true))

      MapSet.intersection(mine, winners)
      |> MapSet.to_list()
      |> length()
      |> factorial()
    end)
    |> Enum.sum()
  end

  def factorial(num) do
    cond do
      num <= 1 -> num
      num -> 2 * factorial(num - 1)
    end
  end

  def problem_two(filename \\ "lib/day4/input.txt") do
    Aoc23.read_lines(filename)
    |> Enum.with_index()
    |> Enum.reduce(Map.new(), fn {scorecard, index}, copies ->
      [_, winners, mine] = String.split(scorecard, [":", "|"])
      winners = MapSet.new(String.split(winners, " ", trim: true))
      mine = MapSet.new(String.split(mine, " ", trim: true))

      MapSet.intersection(mine, winners)
      |> MapSet.to_list()
      |> length()
      |> add_copies(copies, index + 1)
    end)
    |> Map.to_list()
    |> Enum.reduce(0, fn {_, val}, total -> total + val end)
  end

  def add_copies(range, map, current) do
    map = Map.put_new(map, current, 1)
    copies = Map.get(map, current)

    if range < 1 do
      map
    else
      Enum.reduce(Enum.to_list((current + 1)..(current + range)), map, fn i, new_map ->
        Map.update(new_map, i, 1 + copies, fn old -> old + copies end)
      end)
    end
  end
end
