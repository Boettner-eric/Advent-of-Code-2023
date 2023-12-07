defmodule DayFiveTest do
  use ExUnit.Case

  test "day five, gets correct answer for problem one" do
    assert Fertilizer.problem_one() == 57_075_758
  end

  test "day five, gets correct answer for sample problem one" do
    assert Fertilizer.problem_one("lib/day5/sample.txt") == 35
  end

  # @tag timeout: :infinity
  # test "day five, gets correct answer for problem two" do
  #   assert Fertilizer.problem_two() == 31_161_857
  # end

  test "day five, gets correct answer for sample problem two" do
    assert Fertilizer.problem_two("lib/day5/sample.txt") == 46
  end
end
