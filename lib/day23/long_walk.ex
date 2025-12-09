defmodule LongWalk do
  @infinity 100_000_000_000

  def problem_one(filename \\ "lib/day23/input.txt") do
    grid = Aoc23.read_lines(filename) |> Enum.map(&String.split(&1, "", trim: true))
    start = {Enum.at(grid, 0) |> Enum.find_index(&Kernel.==(&1, ".")), 0}
    goal = {Enum.at(grid, -1) |> Enum.find_index(&Kernel.==(&1, ".")), length(grid) - 1}

    dfs(parse_grid(grid), [], start, goal)
  end

  def problem_two(filename \\ "lib/day23/input.txt") do
    grid = Aoc23.read_lines(filename) |> Enum.map(&String.split(&1, "", trim: true))
    start = {Enum.at(grid, 0) |> Enum.find_index(&Kernel.==(&1, ".")), 0}
    goal = {Enum.at(grid, -1) |> Enum.find_index(&Kernel.==(&1, ".")), length(grid) - 1}

    points = [start] ++ contract_graph(parse_grid(grid), grid) ++ [goal]
    graph = find_paths(parse_grid(grid), points)

    dfs2(graph, MapSet.new(), start, goal)
  end

  def parse_grid(lines) do
    Enum.reduce(Enum.with_index(lines), %{}, fn {line, y}, acc ->
      Enum.reduce(Enum.with_index(line), acc, fn {val, x}, bcc ->
        if val != "#", do: Map.put(bcc, {x, y}, val), else: bcc
      end)
    end)
  end

  def dfs(graph, path, node, goal) do
    val = lookup(graph, node)

    cond do
      val == "#" or node in path ->
        0

      node == goal ->
        length(path)

      true ->
        Enum.reduce(slopes(node, val), 0, fn n, acc ->
          max(dfs(graph, [node | path], n, goal), acc)
        end)
    end
  end

  def lookup(graph, node) do
    Map.get(graph, node, "#")
  end

  def slopes(node, val) do
    case val do
      ">" -> [right(node)]
      "<" -> [left(node)]
      "v" -> [down(node)]
      "^" -> [up(node)]
      _ -> [up(node), left(node), right(node), down(node)]
    end
  end

  def neighbors(graph, node) do
    Enum.filter(
      [up(node), left(node), right(node), down(node)],
      &(Map.get(graph, &1, "#") != "#")
    )
  end

  def left({i, j}), do: {i - 1, j}
  def right({i, j}), do: {i + 1, j}
  def up({i, j}), do: {i, j - 1}
  def down({i, j}), do: {i, j + 1}

  # I had trouble with part2 and had to read up on Longest Paths and
  # edge contraction. This solution finds all the points with multiple
  # branches, finds edges for each path and uses DFS on that set of paths

  def contract_graph(graph, lines) do
    Enum.reduce(Enum.with_index(lines), [], fn {line, y}, acc ->
      Enum.reduce(Enum.with_index(line), acc, fn {val, x}, bcc ->
        if val != "#" and length(neighbors(graph, {x, y})) > 2 do
          bcc ++ [{x, y}]
        else
          bcc
        end
      end)
    end)
  end

  def find_paths(grid, points) do
    Enum.reduce(points, %{}, fn current, graph ->
      queue = [{0, current}]
      seen = MapSet.new([current])
      edges = find_edges(grid, queue, seen, points)
      Map.put(graph, current, edges)
    end)
  end

  defp find_edges(grid, queue, seen, points, edges \\ %{})
  defp find_edges(_grid, [], _seen, _points, edges), do: edges

  defp find_edges(grid, [{cost, point} | queue], seen, points, edges) do
    if cost != 0 and point in points do
      edges = Map.put(edges, point, cost)
      find_edges(grid, queue, seen, points, edges)
    else
      {queue, seen} =
        Enum.reduce(neighbors(grid, point), {queue, seen}, fn neighbor, {st, se} ->
          if neighbor in se,
            do: {st, se},
            else: {[{cost + 1, neighbor} | st], MapSet.put(se, neighbor)}
        end)

      find_edges(grid, queue, seen, points, edges)
    end
  end

  def dfs2(_graph, _seen, goal, goal), do: 0

  def dfs2(graph, seen, point, goal) do
    seen = MapSet.put(seen, point)

    Enum.reduce(Map.get(graph, point, %{}), -@infinity, fn {neighbor, cost}, m ->
      if neighbor not in seen, do: max(m, cost + dfs2(graph, seen, neighbor, goal)), else: m
    end)
  end
end
