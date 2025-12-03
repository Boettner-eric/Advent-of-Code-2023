defmodule HotSprings do
  use Memoize

  def problem_one(filename \\ "lib/day12/input.txt") do
    Aoc23.read_lines(filename)
    |> Enum.reduce(0, &add_arrangements/2)
  end

  def problem_two(filename \\ "lib/day12/input.txt") do
    Aoc23.read_lines(filename)
    |> Enum.reduce(0, &add_arrangements(&1, &2, 5))
  end

  def add_arrangements(line, acc, copies \\ 1) do
    [springs, groups] = String.split(line, " ", trim: true)
    springs = String.duplicate(springs <> "?", copies) |> String.slice(-0..-2//1)

    groups =
      String.duplicate(groups <> ",", copies)
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)

    acc + expand(springs, "", groups)
  end

  # im sure these cases can be cleaned up but :shrug:
  def expand("", _, []), do: 1
  def expand("", _, [0]), do: 1
  def expand("." <> _, "#" <> _, [i | _]) when i > 0, do: 0

  def expand("." <> line, _, [0 | groups]) do
    expand(line, ".", groups)
  end

  def expand("." <> line, _, groups) do
    expand(line, ".", groups)
  end

  def expand("#" <> line, _, [group | groups]) when group > 0 do
    expand(line, "#", [group - 1 | groups])
  end

  def expand("?" <> line, last, groups) do
    branch("." <> line, last, groups) +
      branch("#" <> line, last, groups)
  end

  def expand(_line, _last, _groups), do: 0

  # I ended up getting help here, it didn't occur to me to memoize
  # these branches. The solution without them finished but takes a ton
  # of time and system resources. This is a good lesson for future me
  # when I am working on wide branching problems
  defmemo branch(lines, last, groups) do
    expand(lines, last, groups)
  end
end
