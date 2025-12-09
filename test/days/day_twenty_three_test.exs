defmodule TwentyThreeTest do
  use ExUnit.Case

  test "day twenty three, gets correct answer for sample one" do
    assert LongWalk.problem_one("lib/day23/sample.txt") == 94
  end

  test "day twenty three, gets correct answer for problem one" do
    assert LongWalk.problem_one() == 1966
  end

  test "day twenty three, gets correct answer for sample two" do
    assert LongWalk.problem_two("lib/day23/sample.txt") == 154
  end

  test "day twenty three, gets correct answer for problem two" do
    assert LongWalk.problem_two() == 6286
  end
end
