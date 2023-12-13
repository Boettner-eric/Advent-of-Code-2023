defmodule DayThirteenTest do
  use ExUnit.Case

  test "day thirteen, gets correct answer for problem one" do
    assert LavaIsland.problem_one() == 32723
  end

  test "day thirteen, gets correct answer for sample problem one" do
    assert LavaIsland.problem_one("lib/day13/sample.txt") == 405
  end

  test "day thirteen, gets correct answer for problem two" do
    assert LavaIsland.problem_two("lib/day13/input.txt") == 34536
  end

  test "day thirteen, gets correct answer for sample two" do
    assert LavaIsland.problem_two("lib/day13/sample.txt") == 400
  end
end
