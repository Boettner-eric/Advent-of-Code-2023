defmodule Fertilizer do
  def problem_one(filename \\ "lib/day5/input.txt") do
    [seeds | blob] =
      Aoc23.read_blob(filename)
      |> String.split("\n\n")

    seeds = String.split(seeds, ["seeds: ", " "], trim: true) |> Enum.map(&String.to_integer/1)

    blob
    |> Enum.map(&generate_map/1)
    |> Enum.reduce(seeds, &lookup_values/2)
    |> Enum.min()
  end

  def generate_map(blob) do
    [_ | arr] = String.split(blob, [":", "\n"], trim: true)

    Enum.reduce(arr, %{}, fn data, map ->
      [dst, src, rng] = String.split(data, " ", trim: true) |> Enum.map(&String.to_integer/1)
      Map.put(map, src..(src + rng - 1), dst - src)
    end)
  end

  def lookup_values(map, values) do
    Enum.map(values, fn value ->
      Map.keys(map)
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

    seed_ranges =
      String.split(seeds, ["seeds: ", " "], trim: true)
      |> Enum.map(&String.to_integer/1)
      |> get_seed_ranges()

    # the best solution here would be to use the bounds of each map to bound the input
    # effectively you can reverse the order of the maps and figure out a simple mapping
    # of the lowest options then go through the input till you find a minimum.
    # unfortunately I don't have time for this today

    # (update) This festered in my brain for a few days and I finally circled back to solve it
    blob
    |> Enum.map(&generate_map/1)
    |> Enum.reduce(seed_ranges, &lookup_ranges/2)
    |> Enum.min()
    |> Map.get(:first)
  end

  def get_seed_ranges(seeds) do
    Enum.reduce(0..(length(seeds) - 1)//2, [], fn i, acc ->
      # this `Enum.to_list` expansion is whats killing performance, we would rather encode the ranges directly
      # acc ++ Enum.to_list(Enum.at(seeds, i)..(Enum.at(seeds, i) + Enum.at(seeds, i + 1) - 1))

      # (update) yup, it worked
      acc ++ [Enum.at(seeds, i)..(Enum.at(seeds, i) + Enum.at(seeds, i + 1) - 1)]
    end)
  end

  # ideally we replace `lookup_values` with `lookup_ranges` to properly parse inputs
  # if you expand only the intersection of inputs you can duplicate the work from part 1 without
  # actually expanding all of the seeds. I struggled with the expansion / intersection here

  # (update) the main problem here was just my `get_intersection` function
  def lookup_ranges(map, values) do
    Enum.reduce(values, [], fn value, acc ->
      Map.keys(map)
      |> Enum.reduce([], fn key, ranges ->
        case get_intersections(key, value) do
          nil -> ranges
          i..j//_ -> [(map[key] + i)..(map[key] + j) | ranges]
        end
      end)
      |> case do
        # note that this is the identity if there are no ranges
        [] -> [value]
        i -> i
      end
      |> Kernel.++(acc)
    end)
  end

  # there were many issues here ...

  # (update) i had to use pen and paper here, it might still be off
  # but it works for the sample and input so ill call it a day
  def get_intersections(i..j//_, k..l//_) do
    cond do
      k > i and k < j and l < j -> k..l
      k > i and k < j and l > k -> k..j
      k < i and l > i and l < j -> i..l
      k <= i and l >= i and l >= j -> i..j
      true -> nil
    end
  end
end
