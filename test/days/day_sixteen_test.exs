defmodule SixteenTest do
  use ExUnit.Case

  test "day sixteen, gets correct answer for sample one" do
    assert LavaFloor.problem_one("lib/day16/sample.txt") == 46
  end

  test "day sixteen, gets correct answer for problem one" do
    assert LavaFloor.problem_one() == 8249
  end

  # test "day sixteen, gets correct answer for sample two" do
  #   assert LavaFloor.problem_two("lib/day16/sample.txt") == 51
  # end

  # test "day sixteen, gets correct answer for problem two" do
  #   assert LavaFloor.problem_two() == nil
  # end
end
