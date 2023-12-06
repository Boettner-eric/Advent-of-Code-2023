defmodule DaySixTest do
  use ExUnit.Case

  test "day six, gets correct answer for problem one" do
    assert Racing.problem_one() == 74698
  end

  test "day six, gets correct answer for sample problem one" do
    assert Racing.problem_one("lib/day6/sample.txt") == 288
  end

  test "day six, gets correct answer for problem two" do
    assert Racing.problem_two() == 27_563_421
  end

  test "day six, gets correct answer for sample problem two" do
    assert Racing.problem_two("lib/day6/sample.txt") == 71503
  end
end
