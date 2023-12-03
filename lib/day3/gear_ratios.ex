defmodule GearRatios do
  @symbols ["*", "=", "-", "#", "$", "+", "/", "@", "?", "!", "%", "^", "&", "(", ")"]
  def problem_one(filename \\ "lib/day3/input.txt") do
    lines =
      Aoc23.read_lines(filename)
      |> Enum.map(fn line -> String.split(line, "") end)

    Enum.reduce(Enum.with_index(lines), 0, fn {line, i}, acc ->
      Enum.reduce(Enum.with_index(line), 0, fn {char, j}, sum ->
        if char in @symbols do
          {_, new_points} =
            get_points(lines, i, j)
            |> Enum.reduce({[], []}, fn point, {vs, digits} ->
              case get_numbers(lines, point, {vs, 0}) do
                {k, l} when l != 0 -> {vs ++ k, digits ++ [l]}
                {k, _} -> {vs ++ k, digits}
              end
            end)

          Enum.sum(new_points) + sum
        else
          sum
        end
      end) + acc
    end)
  end

  def get_numbers(arr, point, {points, acc}) do
    expand_num(arr, point, points)
    |> case do
      {visited, val} when val != "" -> {visited, get_int(val) + acc}
      {visited, _val} -> {visited, acc}
    end
  end

  def expand_num(arr, {x, y}, points) do
    if {x, y} in points do
      {points, ""}
    else
      val = Enum.at(Enum.at(arr, x, []), y, "")

      case get_int(val) do
        nil ->
          {points, ""}

        _ ->
          points = points ++ [{x, y}]

          {points, left} = expand_num(arr, {x, y - 1}, points)
          {points, right} = expand_num(arr, {x, y + 1}, points)

          {points, left <> val <> right}
      end
    end
  end

  def get_points(arr, x, y) do
    for i <- (x - 1)..(x + 1),
        j <- (y - 1)..(y + 1) do
      case get_int(Enum.at(Enum.at(arr, i, []), j, "")) do
        nil -> nil
        _ -> {i, j}
      end
    end
    |> Enum.reject(&is_nil/1)
  end

  def get_int(item) do
    case Integer.parse(item) do
      {val, _} -> val
      _ -> nil
    end
  end

  def problem_two(filename \\ "lib/day3/input.txt") do
    lines =
      Aoc23.read_lines(filename)
      |> Enum.map(fn line -> String.split(line, "") end)

    Enum.reduce(Enum.with_index(lines), 0, fn {line, i}, acc ->
      Enum.reduce(Enum.with_index(line), {0, []}, fn {char, j}, {acc, visited} ->
        if char == "*" do
          get_points(lines, i, j)
          |> Enum.reduce({visited, []}, fn gear, {vs, digits} ->
            case get_numbers(lines, gear, {vs, 0}) do
              {k, l} when l != 0 -> {vs ++ k, digits ++ [l]}
              {k, _} -> {vs ++ k, digits}
            end
          end)
          |> case do
            {_, [a, b]} -> {a * b + acc, visited}
            _ -> {acc, visited}
          end
        else
          {acc, visited}
        end
      end)
      |> then(&(elem(&1, 0) + acc))
    end)
  end
end
