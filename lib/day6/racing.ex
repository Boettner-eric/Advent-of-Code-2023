defmodule Racing do
  def problem_one(filename \\ "lib/day6/input.txt") do
    races =
      Aoc23.read_blob(filename)
      |> String.split(["\n", " ", "Time: ", "Distance: "], trim: true)

    {a, b} = Enum.split(races, div(length(races), 2))

    Enum.zip_with(a, b, fn l, r -> {String.to_integer(l), String.to_integer(r)} end)
    |> Enum.reduce(1, fn race, acc ->
      (1 + get_bound(race, :upper) - get_bound(race, :lower)) * acc
    end)
  end

  # this was my initial solution
  # it can be optimized by finding the range of solutions instead of calculating them all
  # def hodl_button({time, distance}) do
  #   for i <- 1..time, reduce: 0 do
  #     acc ->
  #       (i * (time - i) > distance && 1 + acc) || acc
  #   end
  # end

  def problem_two(filename \\ "lib/day6/input.txt") do
    races =
      Aoc23.read_blob(filename)
      |> String.split(["\n", " ", "Time: ", "Distance: "], trim: true)

    {a, b} =
      Enum.split(races, div(length(races), 2))

    a = String.to_integer(Enum.reduce(a, "", fn i, acc -> acc <> i end))
    b = String.to_integer(Enum.reduce(b, "", fn i, acc -> acc <> i end))

    1 + get_bound({a, b}, :upper) - get_bound({a, b}, :lower)
  end

  def get_bound({time, distance}, dir) do
    case dir do
      :upper -> time..1
      :lower -> 1..time
    end
    |> Enum.reduce_while(0, fn i, _ ->
      if i * (time - i) > distance, do: {:halt, i}, else: {:cont, i}
    end)
  end
end
