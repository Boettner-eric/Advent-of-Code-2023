defmodule ClumsyCrucible do
  @infinity 100_000_000_000
  def problem_one(filename \\ "lib/day17/input.txt") do
    grid = Aoc23.read_lines(filename) |> Enum.map(&String.split(&1, "", trim: true))
    queue = PriorityQueue.new() |> PriorityQueue.put(0, {{0, 0}, nil, 0})

    djikstra({queue, %{}}, grid, &crucible/2)
  end

  def problem_two(filename \\ "lib/day17/input.txt") do
    grid = Aoc23.read_lines(filename) |> Enum.map(&String.split(&1, "", trim: true))
    queue = PriorityQueue.new() |> PriorityQueue.put(0, {{0, 0}, nil, 0})

    djikstra({queue, %{}}, grid, &ultra_crucible/2)
  end

  def djikstra({%PriorityQueue{size: 0}, costs}, grid, _search_fn) do
    target = {length(Enum.at(grid, 0)) - 1, length(grid) - 1}

    Map.to_list(costs)
    |> Enum.filter(fn {{cords, _, _}, _} -> cords == target end)
    |> Enum.min_by(fn {{_, _, _}, cost} -> cost end)
    |> elem(1)
  end

  def djikstra({unvisited, costs}, grid, search_fn) do
    {{cost, current}, queue} = PriorityQueue.pop(unvisited)

    Enum.reduce(search_fn.(grid, current), {queue, costs}, fn neighbor, {q, c} ->
      new_cost = lookup_cost(grid, neighbor) + cost

      if new_cost < Map.get(costs, neighbor, @infinity) do
        {PriorityQueue.put(q, new_cost, neighbor), Map.put(c, neighbor, new_cost)}
      else
        {q, c}
      end
    end)
    |> djikstra(grid, search_fn)
  end

  def out_of_bounds?([row | _] = grid, i, j) do
    i < 0 or j < 0 or i >= length(row) or j >= length(grid)
  end

  def lookup_cost(grid, {{x, y}, _, _}) do
    Enum.at(grid, y) |> Enum.at(x) |> String.to_integer()
  end

  def crucible(grid, node) do
    case node do
      {_, dir, cons} when cons == 3 and dir in [:l, :r] -> [up(node), down(node)]
      {_, dir, cons} when cons == 3 and dir in [:u, :d] -> [left(node), right(node)]
      {_, :l, _} -> [up(node), down(node), left(node)]
      {_, :r, _} -> [up(node), down(node), right(node)]
      {_, :u, _} -> [left(node), right(node), up(node)]
      {_, :d, _} -> [left(node), right(node), down(node)]
      {_, nil, _} -> [down(node), right(node)]
    end
    |> Enum.filter(fn {{a, b}, _, _} -> not out_of_bounds?(grid, a, b) end)
  end

  def ultra_crucible(grid, node) do
    case node do
      {_, :l, cons} when cons < 4 -> [left(node)]
      {_, :r, cons} when cons < 4 -> [right(node)]
      {_, :u, cons} when cons < 4 -> [up(node)]
      {_, :d, cons} when cons < 4 -> [down(node)]
      {_, :l, cons} when cons >= 10 -> [up(node), down(node)]
      {_, :r, cons} when cons >= 10 -> [up(node), down(node)]
      {_, :u, cons} when cons >= 10 -> [left(node), right(node)]
      {_, :d, cons} when cons >= 10 -> [left(node), right(node)]
      {_, :l, _} -> [up(node), down(node), left(node)]
      {_, :r, _} -> [up(node), down(node), right(node)]
      {_, :u, _} -> [left(node), right(node), up(node)]
      {_, :d, _} -> [left(node), right(node), down(node)]
      {_, nil, _} -> [down(node), right(node)]
    end
    |> Enum.filter(fn {{a, b}, _, _} -> not out_of_bounds?(grid, a, b) end)
  end

  def left({{i, j}, :l, cons}), do: {{i - 1, j}, :l, cons + 1}
  def left({{i, j}, _, _}), do: {{i - 1, j}, :l, 1}

  def right({{i, j}, :r, cons}), do: {{i + 1, j}, :r, cons + 1}
  def right({{i, j}, _, _}), do: {{i + 1, j}, :r, 1}

  def up({{i, j}, :u, cons}), do: {{i, j - 1}, :u, cons + 1}
  def up({{i, j}, _, _}), do: {{i, j - 1}, :u, 1}

  def down({{i, j}, :d, cons}), do: {{i, j + 1}, :d, cons + 1}
  def down({{i, j}, _, _}), do: {{i, j + 1}, :d, 1}
end
