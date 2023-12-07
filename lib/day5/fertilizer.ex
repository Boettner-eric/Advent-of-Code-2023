defmodule Fertilizer do
  def problem_one(filename \\ "lib/day5/input.txt") do
    [seeds | blob] =
      Aoc23.read_blob(filename)
      |> String.split("\n\n")

    seeds = String.split(seeds, ["seeds: ", " "], trim: true) |> Enum.map(&String.to_integer/1)

    Enum.map(blob, &(String.split(&1, [":", "\n"], trim: true) |> generate_map()))
    |> Enum.reduce(seeds, &lookup_values/2)
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
      map
      |> Map.keys()
      |> Enum.filter(&Kernel.in(value, &1))
      |> case do
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

    seeds =
      String.split(seeds, ["seeds: ", " "], trim: true)
      |> Enum.map(&String.to_integer/1)
      |> expand_seeds()

    # the best solution here would be to use the bounds of each map to bound the input
    # effectively you can reverse the order of the maps and figure out a simple mapping
    # of the lowest options then go through the input till you find a minimum.
    # unfortunately I don't have time for this today
    Enum.map(blob, &(String.split(&1, [":", "\n"], trim: true) |> generate_map()))
    |> Enum.reduce(seeds, &lookup_values/2)
    |> Enum.min()
  end

  def expand_seeds(seeds) do
    Enum.reduce(0..(length(seeds) - 1)//2, [], fn i, acc ->
      # this `Enum.to_list` expansion is whats killing performance, we would rather encode the ranges directly
      # acc ++ [Enum.at(seeds, i)..(Enum.at(seeds, i) + Enum.at(seeds, i + 1) - 1)]

      acc ++ Enum.to_list(Enum.at(seeds, i)..(Enum.at(seeds, i) + Enum.at(seeds, i + 1) - 1))
    end)
  end

  # ideally we replace `lookup_values` with `lookup_ranges` to properly parse inputs
  # if you expand only the intersection of inputs you can duplicate the work from part 1 without
  # actually expanding all of the seeds. I struggled with the expansion / intersection here
  def lookup_ranges(map, values) do
    Enum.map(values, fn value ->
      map
      |> Map.keys()
      |> Enum.map(fn el ->
        get_intersections(el, value)
        |> case do
          nil -> value
          i..j -> (map[el] + i)..(map[el] + j)
        end
      end)
    end)
    |> List.flatten()
    |> Enum.uniq()
  end

  # there are many issues here ...
  def get_intersections(i..j, k..l) do
    cond do
      i < k and k > j and j > k and j < l -> k..l
      j < l and j > k -> k..l
      true -> nil
    end
  end
end
