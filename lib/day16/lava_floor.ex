defmodule LavaFloor do
  def problem_one(filename \\ "lib/day16/input.txt") do
    Aoc23.read_lines(filename)
    |> Enum.map(&String.split(&1, "", trim: true))
    |> trace_beam({0, 0, :right}, [])
    |> Enum.uniq_by(&cords/1)
    |> length()
  end

  def trace_beam([row | _] = grid, {x, y, dir}, visited) do
    cond do
      {x, y, dir} in visited ->
        visited

      y >= length(grid) or x >= length(row) or x < 0 or y < 0 ->
        visited

      true ->
        vs = [{x, y, dir} | visited]

        Enum.at(Enum.at(grid, y), x)
        |> next(dir, {x, y})
        |> case do
          [a, b] -> trace_beam(grid, a, trace_beam(grid, b, vs))
          a -> trace_beam(grid, a, vs)
        end
    end
  end

  def next(".", dir, {x, y}) do
    case dir do
      :left -> left(x, y)
      :right -> right(x, y)
      :up -> up(x, y)
      :down -> down(x, y)
    end
  end

  def next("\\", dir, {x, y}) do
    case dir do
      :right -> down(x, y)
      :left -> up(x, y)
      :up -> left(x, y)
      :down -> right(x, y)
    end
  end

  def next("/", dir, {x, y}) do
    case dir do
      :right -> up(x, y)
      :left -> down(x, y)
      :down -> left(x, y)
      :up -> right(x, y)
    end
  end

  def next("|", dir, {x, y}) do
    case dir do
      :up -> up(x, y)
      :down -> down(x, y)
      _ -> [up(x, y), down(x, y)]
    end
  end

  def next("-", dir, {x, y}) do
    case dir do
      :left -> left(x, y)
      :right -> right(x, y)
      _ -> [left(x, y), right(x, y)]
    end
  end

  def left(x, y), do: {x - 1, y, :left}
  def right(x, y), do: {x + 1, y, :right}
  def up(x, y), do: {x, y - 1, :up}
  def down(x, y), do: {x, y + 1, :down}

  # this solution is super inefficient
  # the correct approach is to store the cost of a
  # given coordinate/direction combo then pass that to each iteration
  # this approach calculates the same data a bunch of times
  def problem_two(filename \\ "lib/day16/input.txt") do
    Aoc23.read_lines(filename)
    |> Enum.map(&String.split(&1, "", trim: true))
    |> most_energized()
  end

  def most_energized([row | _] = grid) do
    x = length(row) - 1
    y = length(grid) - 1

    max_row =
      Enum.reduce(0..y, 0, fn i, acc ->
        left = length(trace_beam(grid, {x, i, :left}, []) |> Enum.uniq_by(&cords/1))
        right = length(trace_beam(grid, {0, i, :right}, []) |> Enum.uniq_by(&cords/1))
        Enum.max([right, left, acc])
      end)

    max_col =
      Enum.reduce(0..x, 0, fn i, acc ->
        up = length(trace_beam(grid, {i, y, :up}, []) |> Enum.uniq_by(&cords/1))
        down = length(trace_beam(grid, {i, 0, :down}, []) |> Enum.uniq_by(&cords/1))
        Enum.max([up, down, acc])
      end)

    max(max_col, max_row)
  end

  def cords({x, y, _}), do: {x, y}
end
