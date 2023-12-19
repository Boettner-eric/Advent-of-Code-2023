defmodule Aplenty do
  def problem_one(filename \\ "lib/day19/input.txt") do
    [fns, parts] =
      Aoc23.read_blob(filename)
      |> String.split("\n\n", trim: true)
      |> Enum.map(&String.split(&1, "\n", trim: true))

    parse_parts(parts)
    |> eval_parts(Enum.reduce(fns, %{}, &parse_line/2))
  end

  def parse_line(line, map) do
    [key | exprs] = String.split(line, ["{", ",", "}"], trim: true)

    exprs =
      Enum.reduce(Enum.reverse(exprs), {}, fn i, acc ->
        case String.split(i, ":", trim: true) do
          [term, a] -> {parse_comp(term), a, acc}
          [term] -> term
        end
      end)

    Map.put(map, key, exprs)
  end

  def parse_comp(comp) do
    cond do
      String.contains?(comp, "<") ->
        {String.at(comp, 0), fn i -> i < String.to_integer(String.slice(comp, 2..-1)) end}

      String.contains?(comp, ">") ->
        {String.at(comp, 0), fn i -> i > String.to_integer(String.slice(comp, 2..-1)) end}
    end
  end

  def parse_parts(parts) do
    Enum.map(parts, fn i ->
      ["x=" <> x, "m=" <> m, "a=" <> a, "s=" <> s] = String.split(i, ["{", "}", ","], trim: true)

      %{
        "x" => String.to_integer(x),
        "m" => String.to_integer(m),
        "a" => String.to_integer(a),
        "s" => String.to_integer(s)
      }
    end)
  end

  def eval_parts(parts, map) do
    Enum.reduce(parts, 0, fn part, total ->
      walk("in", part, map) + total
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

  def(problem_two(filename \\ "lib/day19/input.txt")) do
    [fns, _] =
      Aoc23.read_blob(filename)
      |> String.split("\n\n", trim: true)
      |> Enum.map(&String.split(&1, "\n", trim: true))

    # |> eval_parts(Enum.reduce(fns, %{}, &parse_line/2))
  end
end
