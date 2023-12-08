defmodule DayEightTest do
  use ExUnit.Case

  test "day eight, gets correct answer for problem one" do
    assert HauntedWasteland.problem_one() == 18157
  end

  test "day eight, gets correct answer for sample problem one" do
    assert HauntedWasteland.problem_one("lib/day8/sample.txt") == 2
  end

  test "day eight, gets correct answer for problem two" do
    assert HauntedWasteland.problem_two() == 14_299_763_833_181
  end

  test "day eight, gets correct answer for sample problem two" do
    assert HauntedWasteland.problem_two("lib/day8/ghost.txt") == 6
  end
end
