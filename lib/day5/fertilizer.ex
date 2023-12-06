defmodule Fertilizer do
  def problem_one(filename \\ "lib/day5/input.txt") do
    [seeds | blob] =
      Aoc23.read_blob(filename)
      |> String.split("\n\n")

    seeds = String.split(seeds, ["seeds: ", " "], trim: true) |> Enum.map(&String.to_integer/1)

    Enum.reduce(blob, seeds, fn block, values ->
      String.split(block, [":", "\n"], trim: true)
      |> generate_map()
      |> lookup_values(values)
    end)
    |> Enum.min()
  end

  def generate_map([_ | arr]) do
    Enum.reduce(arr, %{}, fn data, map ->
      with [dst, src, rng] <- String.split(data, " ", trim: true),
           src <- String.to_integer(src),
           rng <- String.to_integer(rng),
           dst <- String.to_integer(dst) do
        Map.put(map, src..(src + rng - 1), dst - src)
      end
    end)
  end

  def lookup_values(map, values) do
    Enum.map(values, fn value ->
      case Map.keys(map)
           |> Enum.filter(&Kernel.in(value, &1)) do
        [el] -> map[el] + value
        [el | _] -> map[el] + value
        _ -> value
      end
    end)
  end

  def problem_two(filename \\ "lib/day5/input.txt") do
    [seeds | blob] =
      Aoc23.read_blob(filename)
      |> String.split("\n\n")

    seeds = String.split(seeds, ["seeds: ", " "], trim: true) |> expand_seeds()

    Enum.reduce(blob, seeds, fn block, values ->
      String.split(block, [":", "\n"], trim: true)
      |> generate_map()
      |> lookup_values(values)
    end)
    |> Enum.min()
  end

  def expand_seeds(seeds) do
    seeds = Enum.map(seeds, &String.to_integer/1)

    Enum.reduce(0..(length(seeds) - 1)//2, [], fn i, acc ->
      acc ++ Enum.to_list(Enum.at(seeds, i)..(Enum.at(seeds, i) + Enum.at(seeds, i + 1) - 1))
    end)
  end
end
