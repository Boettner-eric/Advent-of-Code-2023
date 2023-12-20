defmodule EighteenTest do
  use ExUnit.Case

  test "day eighteen, gets correct answer for sample one" do
    assert LavaductLagoon.problem_one("lib/day18/sample.txt") == 62
  end

  test "day eighteen, gets correct answer for problem one" do
    assert LavaductLagoon.problem_one() == 52035
  end

  test "day eighteen, gets correct answer for sample two" do
    assert LavaductLagoon.problem_two("lib/day18/sample.txt") == 952_408_144_115
  end

  test "day eighteen, gets correct answer for problem two" do
    assert LavaductLagoon.problem_two() == 60_612_092_439_765
  end
end
