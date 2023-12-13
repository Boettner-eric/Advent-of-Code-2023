defmodule LavaIsland do
  def problem_one(filename \\ "lib/day13/input.txt") do
    Aoc23.read_blob(filename)
    |> String.split("\n\n")
    |> Enum.map(&String.split(&1, "\n"))
    |> Enum.reduce(0, &(get_reflections(&1) + &2))
  end

  def get_reflections(pattern, smudge \\ false) do
    case find_fold(pattern, smudge) do
      0 -> find_fold(transpose(pattern), smudge) * 100
      val -> val
    end
  end

  def find_fold([row | _] = pattern, smudge) do
    size = String.length(row) - 1

    Enum.reduce(pattern, %{}, fn row, map ->
      Enum.reduce(1..size, map, fn i, acc ->
        case row_overlap(row, i) do
          nil -> Map.put_new(acc, i, [])
          overlap -> Map.update(acc, i, [overlap], &[overlap | &1])
        end
      end)
    end)
    |> Map.to_list()
    |> Enum.reduce(0, fn {index, val}, acc ->
      cond do
        !smudge && length(val) == length(pattern) -> index
        smudge && length(val) == length(pattern) -> acc
        smudge && length(val) == length(pattern) - 1 -> index
        true -> acc
      end
    end)
  end

  def transpose(pattern) do
    pattern
    |> Enum.map(&String.split(&1, "", trim: true))
    |> List.zip()
    |> Enum.map(&(Tuple.to_list(&1) |> Enum.join("")))
  end

  def row_overlap(pattern, x) do
    {a, b} = String.split_at(pattern, x)

    cond do
      String.ends_with?(a, String.reverse(b)) -> x
      String.starts_with?(b, String.reverse(a)) -> x
      true -> nil
    end
  end

  def problem_two(filename \\ "lib/day13/input.txt") do
    Aoc23.read_blob(filename)
    |> String.split("\n\n")
    |> Enum.map(&String.split(&1, "\n"))
    |> Enum.reduce(0, &(get_reflections(&1, true) + &2))
  end
end
