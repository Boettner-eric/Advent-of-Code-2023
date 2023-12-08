defmodule HauntedWasteland do
  def problem_one(filename \\ "lib/day8/input.txt") do
    [pattern, mappings] = Aoc23.read_blob(filename) |> String.split("\n\n")

    pattern = String.split(pattern, "", trim: true)

    map =
      String.split(mappings, "\n")
      |> Enum.reduce(%{}, fn map, acc ->
        [key, l, r] = String.split(map, ["=", "(", ",", ")", " "], trim: true)
        Map.put(acc, key, {l, r})
      end)

    lookup(map, "AAA", pattern, 0)
  end

  def lookup(map, key, pattern, steps) do
    direction = Enum.at(pattern, rem(steps, length(pattern)))

    cond do
      key == "ZZZ" -> steps
      direction == "L" -> lookup(map, elem(map[key], 0), pattern, steps + 1)
      direction == "R" -> lookup(map, elem(map[key], 1), pattern, steps + 1)
    end
  end

  def problem_two(filename \\ "lib/day8/input.txt") do
    [pattern, mappings] = Aoc23.read_blob(filename) |> String.split("\n\n")

    pattern = String.split(pattern, "", trim: true)

    map =
      String.split(mappings, "\n")
      |> Enum.reduce(%{}, fn map, acc ->
        [key, l, r] = String.split(map, ["=", "(", ",", ")", " "], trim: true)
        Map.put(acc, key, {l, r})
      end)

    Enum.reduce(Map.keys(map), 1, fn i, acc ->
      if String.at(i, -1) == "A" do
        lookup_two(map, i, pattern, 0) |> lcm(acc)
      else
        acc
      end
    end)
  end

  def lookup_two(map, key, pattern, steps) do
    direction = Enum.at(pattern, rem(steps, length(pattern)))

    cond do
      String.at(key, -1) == "Z" -> steps
      direction == "L" -> lookup_two(map, elem(map[key], 0), pattern, steps + 1)
      direction == "R" -> lookup_two(map, elem(map[key], 1), pattern, steps + 1)
    end
  end

  def lcm(a, b) do
    div(a * b, Integer.gcd(a, b))
  end
end
