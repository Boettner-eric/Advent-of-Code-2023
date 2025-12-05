defmodule SandSlabs do
  def problem_one(filename \\ "lib/day22/input.txt") do
    Aoc23.read_lines(filename)
    |> parse_blocks()
    |> drop_bricks()
    |> count_free_bricks()
  end

  def problem_two(filename \\ "lib/day22/input.txt") do
    Aoc23.read_lines(filename)
    |> parse_blocks()
    |> drop_bricks()
    |> count_chain_reaction()
  end

  def parse_blocks(lines) do
    Enum.reduce(Enum.with_index(lines), PriorityQueue.new(), fn {line, index}, bricks ->
      [x, y, z, i, j, k] = String.split(line, ["~", ","]) |> Enum.map(&String.to_integer/1)
      PriorityQueue.put(bricks, min(z, k), {index, {x, y, z}, {i, j, k}})
    end)
  end

  def drop_bricks(queue, settled \\ [], deps \\ %{})
  def drop_bricks(%PriorityQueue{size: 0}, settled, deps), do: {settled, deps}

  def drop_bricks(bricks, settled, deps) do
    {{_z, {name, _, _} = brick}, bricks} = PriorityQueue.pop(bricks)
    {settled, d} = drop_brick(brick, settled)

    drop_bricks(bricks, settled, Map.put(deps, name, d))
  end

  def drop_brick({_, {_, _, 1}, {_, _, _}} = b, settled), do: {[b | settled], []}
  def drop_brick({_, {_, _, _}, {_, _, 1}} = b, settled), do: {[b | settled], []}

  def drop_brick({name, {x1, x2, x3}, {y1, y2, y3}} = brick, settled) do
    Enum.reduce(settled, [], fn {name, _, _} = b, acc ->
      if intersect(brick, b), do: acc ++ [name], else: acc
    end)
    |> case do
      [] -> drop_brick({name, {x1, x2, x3 - 1}, {y1, y2, y3 - 1}}, settled)
      hits -> {[brick | settled], hits}
    end
  end

  def intersect(brick_a, brick_b) do
    {_, {x1, y1, z1}, {x2, y2, z2}} = brick_a
    {_, {i1, j1, k1}, {i2, j2, k2}} = brick_b

    min(z1, z2) == 1 + max(k1, k2) and
      ranges_overlap(i1, i2, x1, x2) and
      ranges_overlap(j1, j2, y1, y2)
  end

  def ranges_overlap(a1, a2, b1, b2) do
    max(min(a1, a2), min(b1, b2)) <= min(max(a1, a2), max(b1, b2))
  end

  def count_free_bricks({settled, deps}) do
    Enum.reduce(settled, 0, fn {i, _, _}, count ->
      if Map.values(deps) |> Enum.any?(fn l -> l == [i] end), do: count, else: count + 1
    end)
  end

  def find_structural({settled, deps}) do
    Enum.reduce(settled, [], fn {i, _, _} = b, acc ->
      if Map.values(deps) |> Enum.any?(fn l -> l == [i] end), do: [b | acc], else: acc
    end)
  end

  def count_chain_reaction({settled, deps}) do
    find_structural({settled, deps})
    |> Enum.reduce(0, fn i, count ->
      count + calculate_removal(settled |> Enum.reverse(), deps, i)
    end)
  end

  def calculate_removal(bricks, deps, {key, _, _}) do
    Enum.reduce(bricks, {0, MapSet.new([key])}, fn {name, _, _}, {c, acc} ->
      d = Map.get(deps, name, []) |> MapSet.new()
      # check if the deps 
      if MapSet.size(d) != 0 and MapSet.difference(d, acc) == MapSet.new([]) do
        {c + 1, MapSet.put(acc, name)}
      else
        {c, acc}
      end
    end)
    |> elem(0)
  end
end
