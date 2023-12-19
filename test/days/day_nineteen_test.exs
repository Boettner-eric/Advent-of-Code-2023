defmodule NineteenTest do
  use ExUnit.Case

  test "day nineteen, gets correct answer for sample one" do
    assert Aplenty.problem_one("lib/day19/sample.txt") == 19114
  end

  test "day nineteen, gets correct answer for problem one" do
    assert Aplenty.problem_one() == 391_132
  end

  # test "day nineteen, gets correct answer for sample two" do
  #   assert Aplenty.problem_two("lib/day19/sample.txt") == 167_409_079_868_000
  # end

  # test "day nineteen, gets correct answer for problem two" do
  #   assert Aplenty.problem_two() == nil
  # end
end
