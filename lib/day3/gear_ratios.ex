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
          |> Enum.reduce({[], []}, &to_numbers(lines, &1, &2))
          |> elem(1)
          |> Enum.sum()
        else
          0
        end + acc
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

  def to_numbers(lines, gear, {vs, digits}) do
    case expand_num(lines, gear, vs) do
      {visited, val} when val != "" -> {vs ++ visited, digits ++ [get_int(val)]}
      {visited, _val} -> {visited, digits}
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
        reduce: {0, []} do
      {acc, visited} ->
        if char == "*" do
          get_adjacent_numbers(lines, i, j)
          |> Enum.reduce({visited, []}, &to_numbers(lines, &1, &2))
          |> case do
            {_, [a, b]} -> {a * b + acc, visited}
            _ -> {acc, visited}
          end
        else
          {acc, visited}
        end
    end
    |> elem(0)
  end
end
