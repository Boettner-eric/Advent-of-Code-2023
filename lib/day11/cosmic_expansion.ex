defmodule CosmicExpansion do
  def problem_one(filename \\ "lib/day11/input.txt") do
    Aoc23.read_lines(filename)
    |> Enum.map(&String.split(&1, "", trim: true))
    |> get_points()
  end

  def get_points(space, size \\ 2) do
    points =
      for y <- 0..(length(space) - 1),
          x <- 0..(length(Enum.at(space, 0, 0)) - 1),
          reduce: [] do
        acc ->
          if Enum.at(Enum.at(space, y), x) == "#", do: [{x, y} | acc], else: acc
      end

    columns =
      Enum.reduce(0..(length(space) - 1), [], fn i, acc ->
        if Enum.any?(points, &(elem(&1, 0) == i)), do: acc, else: [i | acc]
      end)

    rows =
      Enum.reduce(0..(length(Enum.at(space, 0, 0)) - 1), [], fn j, acc ->
        if Enum.any?(points, &(elem(&1, 1) == j)), do: acc, else: [j | acc]
      end)

    # add column offsets
    points =
      Enum.reduce(columns, points, fn i, acc ->
        Enum.map(acc, fn {x, y} -> if x > i, do: {x + size - 1, y}, else: {x, y} end)
      end)

    # add row offsets
    points =
      Enum.reduce(rows, points, fn j, acc ->
        Enum.map(acc, fn {x, y} -> if y > j, do: {x, y + size - 1}, else: {x, y} end)
      end)

    Enum.reduce(0..(length(points) - 1), 0, fn index, acc ->
      Enum.slice(points, (index + 1)..(length(points) - 1)//1)
      |> Enum.reduce(0, &(shortest_path(&1, Enum.at(points, index)) + &2))
      |> Kernel.+(acc)
    end)
  end

  def shortest_path({x, y}, {i, j}) do
    abs(y - j) + abs(x - i)
  end

  def problem_two(filename \\ "lib/day11/input.txt", size \\ 2) do
    Aoc23.read_lines(filename)
    |> Enum.map(&String.split(&1, "", trim: true))
    |> get_points(size)
  end
end
