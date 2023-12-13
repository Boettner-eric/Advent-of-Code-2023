defmodule DayTwelveTest do
  use ExUnit.Case

  test "day twelve, gets correct answer for problem one" do
    assert HotSprings.problem_one() == 7792
  end

  test "day twelve, gets correct answer for sample problem one" do
    assert HotSprings.problem_one("lib/day12/sample.txt") == 21
  end

  test "day twelve, gets correct answer for problem two" do
    assert HotSprings.problem_two("lib/day12/input.txt") == 13_012_052_341_533
  end

  test "day twelve, gets correct answer for sample two" do
    assert HotSprings.problem_two("lib/day12/sample.txt") == 525_152
  end
end
