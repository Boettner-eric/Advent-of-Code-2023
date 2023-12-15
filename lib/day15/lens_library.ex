defmodule LensLibrary do
  def problem_one(filename \\ "lib/day15/input.txt") do
    Aoc23.read_blob(filename)
    |> String.split(",", trim: true)
    |> Enum.reduce(0, fn i, acc -> hash(i) + acc end)
  end

  def hash(string) do
    String.split(string, "", trim: true)
    |> Enum.reduce(0, &rem((:binary.first(&1) + &2) * 17, 256))
  end

  def lens(string, map) do
    if String.ends_with?(string, "-") do
      [label] = String.split(string, "-", trim: true)
      hash = hash(label)

      Map.update(map, hash, [], fn v -> Enum.filter(v, &(elem(&1, 0) != label)) end)
    else
      [label, len] = String.split(string, "=", trim: true)
      hash = hash(label)

      Map.update(map, hash, [{label, len}], fn a ->
        case Enum.find(a, &(elem(&1, 0) == label)) do
          nil -> a ++ [{label, len}]
          _ -> Enum.map(a, &if(elem(&1, 0) == label, do: {elem(&1, 0), len}, else: &1))
        end
      end)
    end
  end

  def problem_two(filename \\ "lib/day15/input.txt") do
    Aoc23.read_blob(filename)
    |> String.split(",", trim: true)
    |> Enum.reduce(%{}, &lens/2)
    |> Map.to_list()
    |> Enum.sort(&(elem(&1, 0) <= elem(&2, 0)))
    |> Enum.reduce(0, fn {box, i}, acc ->
      Enum.with_index(i)
      |> Enum.reduce(acc, fn {{_, j}, slot}, bcc ->
        (box + 1) * String.to_integer(j) * (slot + 1) + bcc
      end)
    end)
  end
end
