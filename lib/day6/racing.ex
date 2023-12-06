defmodule Racing do
  def problem_one(filename \\ "lib/day6/input.txt") do
    races =
      Aoc23.read_blob(filename)
      |> String.split(["\n", " ", "Time: ", "Distance: "], trim: true)

    {a, b} = Enum.split(races, div(length(races), 2))

    Enum.zip_with(a, b, fn l, r -> {String.to_integer(l), String.to_integer(r)} end)
    |> Enum.reduce(1, fn race, acc ->
      hodl_button(race) * acc
    end)
  end

  def hodl_button({time, distance}) do
    for i <- 1..time, reduce: 0 do
      acc ->
        if i * (time - i) > distance do
          acc + 1
        else
          acc
        end
    end
  end

  def problem_two(filename \\ "lib/day6/input.txt") do
    races =
      Aoc23.read_blob(filename)
      |> String.split(["\n", " ", "Time: ", "Distance: "], trim: true)

    {a, b} =
      Enum.split(races, div(length(races), 2))

    a = String.to_integer(Enum.reduce(a, "", fn i, acc -> acc <> i end))
    b = String.to_integer(Enum.reduce(b, "", fn i, acc -> acc <> i end))

    hodl_button({a, b})
  end
end
