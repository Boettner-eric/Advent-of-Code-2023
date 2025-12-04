defmodule StepCounter do
  def problem_one(goal, filename \\ "lib/day21/input.txt") do
    # I rewrote most of my solution to fit problem two
    # so part one might seem overly complex since it isn't bound
    Aoc23.read_lines(filename)
    |> parse_garden()
    |> count_steps(goal)
  end

  def problem_two(goal, filename \\ "lib/day21/input.txt") do
    {garden, start} = Aoc23.read_lines(filename) |> parse_garden()

    size = length(garden)
    edge = div(size, 2)

    a = count_steps({garden, start}, edge)
    b = count_steps({garden, start}, edge + 1 * size)
    c = count_steps({garden, start}, edge + 2 * size)
    quadratic([a, b, c], div(goal - edge, size))
  end

  def quadratic([x0, x1, x2], n) do
    # had to look this up
    a = div(x2 - 2 * x1 + x0, 2)
    b = x1 - x0 - a
    c = x0
    a * (n * n) + b * n + c
  end

  def parse_garden(lines) do
    Enum.with_index(lines)
    |> Enum.reduce({[], nil}, fn {line, y}, {garden, start} ->
      row = String.split(line, "", trim: true)

      case Enum.find_index(row, fn i -> i == "S" end) do
        nil -> {garden ++ [row], start}
        x -> {garden ++ [row], {x, y}}
      end
    end)
  end

  def count_steps({garden, start}, goal) do
    queue = PriorityQueue.new() |> PriorityQueue.put(0, start)
    step(garden, queue, MapSet.new(), MapSet.new(), goal) |> MapSet.size()
  end

  def step(_garden, %PriorityQueue{size: 0}, plots, _visited, _goal), do: plots

  def step(garden, queue, plots, visited, goal) do
    {{cost, {x, y}}, queue} = PriorityQueue.pop(queue)

    cond do
      MapSet.member?(visited, {x, y, cost}) ->
        step(garden, queue, plots, visited, goal)

      cost == goal ->
        step(garden, queue, MapSet.put(plots, {x, y}), visited, goal)

      true ->
        visited = MapSet.put(visited, {x, y, cost})
        queue = next(garden, {x, y}, cost + 1, queue)
        step(garden, queue, plots, visited, goal)
    end
  end

  def next(garden, {x, y}, cost, queue) do
    [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
    |> Enum.reduce(queue, fn coords, q ->
      case lookup_plot(garden, coords) do
        "." -> PriorityQueue.put(q, cost, coords)
        "S" -> PriorityQueue.put(q, cost, coords)
        _ -> q
      end
    end)
  end

  # note that negative indices are implicitly handled
  # by the fact that the garden is repeating
  # i.e {0, -1} is the same as {0, length(garden)}
  def lookup_plot([row | _] = garden, {x, y}) do
    garden
    |> Enum.at(rem(y, length(garden)))
    |> Enum.at(rem(x, length(row)))
  end

  def draw_results(garden, posts) do
    Enum.reduce(MapSet.to_list(posts), garden, fn {x, y}, g ->
      List.update_at(g, y, fn row -> List.replace_at(row, x, "O") end)
    end)
  end
end
