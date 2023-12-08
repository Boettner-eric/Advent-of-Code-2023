defmodule GearRatios do
  @symbols ["*", "=", "-", "#", "$", "+", "/", "@", "?", "!", "%", "^", "&", "(", ")"]
  def problem_one(filename \\ "lib/day3/input.txt") do
    lines =
      Aoc23.read_lines(filename)
      |> Enum.map(fn line -> String.split(line, "") end)

    for {line, i} <- Enum.with_index(lines),
        {char, j} <- Enum.with_index(line),
        reduce: 0 do
      acc ->
        if char in @symbols do
          get_adjacent_numbers(lines, i, j)
          |> Enum.reduce({[], "", []}, &expand_num(lines, &1, &2))
          |> elem(2)
          |> Enum.sum()
          |> Kernel.+(acc)
        else
          acc
        end
    end
  end

  def expand_num(arr, {x, y}, {points, _, numbers}) do
    if {x, y} in points do
      {points, "", numbers}
    else
      val = Enum.at(Enum.at(arr, x, []), y, "")

      case get_int(val) do
        nil ->
          {points, "", numbers}

        _ ->
          {points, left, _} = expand_num(arr, {x, y - 1}, {points ++ [{x, y}], "", numbers})
          {points, right, _} = expand_num(arr, {x, y + 1}, {points, "", numbers})
          {points, left <> val <> right, [get_int(left <> val <> right) | numbers]}
      end
    end
  end

  def get_adjacent_numbers(arr, x, y) do
    for i <- (x - 1)..(x + 1), j <- (y - 1)..(y + 1), reduce: [] do
      acc ->
        case get_int(Enum.at(Enum.at(arr, i, []), j, "")) do
          nil -> acc
          _ -> [{i, j} | acc]
        end
    end
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

    for {line, i} <- Enum.with_index(lines),
        {char, j} <- Enum.with_index(line),
        reduce: 0 do
      acc ->
        if char == "*" do
          get_adjacent_numbers(lines, i, j)
          |> Enum.reduce({[], "", []}, &expand_num(lines, &1, &2))
          |> case do
            {_, _, [a, b]} -> a * b
            _ -> 0
          end
          |> Kernel.+(acc)
        else
          acc
        end
    end
  end
end
