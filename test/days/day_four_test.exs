defmodule DayFourTest do
  use ExUnit.Case

  test "day four, gets correct answer for problem one" do
    assert Gondola.problem_one() == 25_004
  end

  test "day four, gets correct answer for sample problem one" do
    assert Gondola.problem_one("lib/day4/sample.txt") == 13
  end

  test "day four, gets correct answer for problem two" do
    assert Gondola.problem_two() == 14_427_616
  end

  test "day four, gets correct answer for sample problem two" do
    assert Gondola.problem_two("lib/day4/sample.txt") == 30
  end
end
