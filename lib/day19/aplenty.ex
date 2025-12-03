defmodule Aplenty do
  def problem_one(filename \\ "lib/day19/input.txt") do
    [comps, parts] =
      Aoc23.read_blob(filename)
      |> String.split("\n\n", trim: true)
      |> Enum.map(&String.split(&1, "\n", trim: true))

    map = parse_line(comps)

    parse_parts(parts)
    |> Enum.reduce(0, &(walk("in", &1, map) + &2))
  end

  def parse_line(lines, map \\ %{})
  def parse_line([], map), do: map

  def parse_line([line | lines], map) do
    [key | workflows] = String.split(line, ["{", ",", "}"], trim: true)

    workflows =
      Enum.reduce(Enum.reverse(workflows), {}, fn i, acc ->
        case String.split(i, ":", trim: true) do
          [term, a] -> {parse_comp(term), a, acc}
          [term] -> term
        end
      end)

    parse_line(lines, Map.put(map, key, workflows))
  end

  def parse_comp(comp) do
    cond do
      String.contains?(comp, "<") ->
        {String.at(comp, 0), fn i -> i < String.to_integer(String.slice(comp, 2..-1//1)) end}

      String.contains?(comp, ">") ->
        {String.at(comp, 0), fn i -> i > String.to_integer(String.slice(comp, 2..-1//1)) end}
    end
  end

  def parse_parts(parts) do
    Enum.map(parts, fn i ->
      ["x=" <> x, "m=" <> m, "a=" <> a, "s=" <> s] = String.split(i, ["{", "}", ","], trim: true)
      %{"x" => stoi(x), "m" => stoi(m), "a" => stoi(a), "s" => stoi(s)}
    end)
  end

  def walk("R", _, _), do: 0
  def walk("A", %{"s" => s, "m" => m, "x" => x, "a" => a}, _), do: s + m + x + a

  def walk(key, part, map) do
    expand(map[key], part)
    |> walk(part, map)
  end

  def expand({{k, fun}, a, b}, part) do
    if fun.(part[k]) do
      expand(a, part)
    else
      expand(b, part)
    end
  end

  def expand(term, _), do: term

  def problem_two(filename \\ "lib/day19/input.txt") do
    map =
      Aoc23.read_blob(filename)
      |> String.split("\n\n", trim: true)
      |> Enum.at(0)
      |> String.split("\n", trim: true)
      |> Enum.reduce(%{}, &parse_line_two/2)

    ranges = %{"x" => 1..4000, "m" => 1..4000, "a" => 1..4000, "s" => 1..4000}

    Enum.reduce(walk_two(map, "in", ranges), 0, fn range, count ->
      count + Enum.reduce(Map.values(range), 1, &(Range.size(&1) * &2))
    end)
  end

  def parse_line_two(line, map) do
    [key | exprs] = String.split(line, ["{", ",", "}"], trim: true)

    exprs =
      Enum.reduce(Enum.reverse(exprs), {}, fn i, acc ->
        case String.split(i, ":", trim: true) do
          [term, a] -> {parse_comp_two(term), a, acc}
          [term] -> term
        end
      end)

    Map.put(map, key, exprs)
  end

  def parse_comp_two(comp) do
    cond do
      String.contains?(comp, "<") ->
        {String.at(comp, 0), 1..(String.to_integer(String.slice(comp, 2..-1//1)) - 1)}

      String.contains?(comp, ">") ->
        {String.at(comp, 0), (String.to_integer(String.slice(comp, 2..-1//1)) + 1)..4000}
    end
  end

  def walk_two(_map, {{_key, _range}, "A", "A"}, ranges), do: [ranges]
  def walk_two(_map, {{_arg, _range}, "R", "R"}, _ranges), do: []

  def walk_two(map, {{key, range}, "A", b}, ranges) do
    [left(ranges, key, range)] ++ walk_two(map, b, right(ranges, key, range))
  end

  def walk_two(map, {{key, range}, a, "A"}, ranges) do
    walk_two(map, a, left(ranges, key, range)) ++ [right(ranges, key, range)]
  end

  def walk_two(map, {{key, range}, a, b}, ranges) do
    walk_two(map, a, left(ranges, key, range)) ++ walk_two(map, b, right(ranges, key, range))
  end

  def walk_two(map, key, ranges) do
    case key do
      "R" -> []
      "A" -> [ranges]
      _ -> walk_two(map, map[key], ranges)
    end
  end

  # update the range for key to be the intersection of the existing range and the new range
  def left(ranges, key, range) do
    Map.update!(ranges, key, &intersect_ranges(&1, range))
  end

  # update the range for key to be the intersection of the existing range and the opposite of the new range
  def right(ranges, key, range) do
    Map.update!(ranges, key, &intersect_ranges(&1, opposite_range(range)))
  end

  # 1..200 -> 201..4000 or 200..4000 -> 1..199
  def opposite_range(1..y//_), do: (y + 1)..4000
  def opposite_range(x..4000//_), do: 1..(x - 1)
  def opposite_range(range), do: raise("Invalid range: #{range}")

  def intersect_ranges(a..b//_, x..y//_) do
    cond do
      a < x and b < y -> x..b
      b < y -> a..b
      a > x -> a..y
      true -> x..y
    end
  end

  def stoi(x) do
    String.to_integer(x)
  end
end
