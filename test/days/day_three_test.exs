defmodule DayThreeTest do
  use ExUnit.Case

  test "day three, gets correct answer for problem one" do
    assert GearRatios.problem_one() == 553_825
  end

  test "day three, gets correct answer for sample problem one" do
    assert GearRatios.problem_one("lib/day3/sample.txt") == 4361
  end

  test "day three, gets correct answer for problem two" do
    assert GearRatios.problem_two() == 93_994_191
  end

  test "day three, gets correct answer for sample problem two" do
    assert GearRatios.problem_two("lib/day3/sample.txt") == 467_835
  end
end
