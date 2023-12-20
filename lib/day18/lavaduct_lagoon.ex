defmodule LavaductLagoon do
  def problem_one(filename \\ "lib/day18/input.txt") do
    Aoc23.read_lines(filename)
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.reduce({[], 0}, fn [dir, len, _], {acc, l} ->
      {x, y} = Enum.at(acc, -1, {0, 0})
      len = String.to_integer(len)

      {acc ++
         case dir do
           "R" -> [{x + len, y}]
           "L" -> [{x - len, y}]
           "U" -> [{x, y - len}]
           "D" -> [{x, y + len}]
         end, l + len}
    end)
    |> shoelace()
  end

  # tried solving this with my own alg but ended up circling back to
  # the shoelace algorithm for area of a polygon. I used this simple
  # tutorial https://www.101computing.net/the-shoelace-algorithm/
  def shoelace({loop, len}) do
    {f, g} = Enum.at(loop, 0)
    {j, k} = Enum.at(loop, -1)

    {sum1, sum2} =
      Enum.reduce(0..(length(loop) - 2), {j * g, f * k}, fn i, {sum1, sum2} ->
        {a, b} = Enum.at(loop, i)
        {c, d} = Enum.at(loop, i + 1)
        {sum1 + a * d, sum2 + c * b}
      end)

    div(abs(sum1 - sum2), 2) + div(len, 2) + 1
  end

  # the trick here was just realizing that i didn't need to compute
  # every vertex but could instead just grab one for each direction
  # change. I could further optimize this by doing the shoelace inline
  # but I am behind a few days already....
  def problem_two(filename \\ "lib/day18/input.txt") do
    Aoc23.read_lines(filename)
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.reduce({[], 0}, fn [_, _, color], {acc, l} ->
      {x, y} = Enum.at(acc, -1, {0, 0})
      len = String.to_integer(String.slice(color, 2..-3), 16)

      {acc ++
         case String.at(color, -2) do
           "0" -> [{x + len, y}]
           "2" -> [{x - len, y}]
           "3" -> [{x, y - len}]
           "1" -> [{x, y + len}]
         end, l + len}
    end)
    |> shoelace()
  end
end
