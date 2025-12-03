defmodule SeventeenTest do
  use ExUnit.Case

  test "day seventeen, gets correct answer for sample one" do
    assert ClumsyCrucible.problem_one("lib/day17/sample.txt") == 102
  end

  test "day seventeen, gets correct answer for problem one" do
    assert ClumsyCrucible.problem_one() == 668
  end

  test "day seventeen, gets correct answer for sample two" do
    assert ClumsyCrucible.problem_two("lib/day17/sample.txt") == 94
  end

  test "day seventeen, gets correct answer for problem two" do
    assert ClumsyCrucible.problem_two() == 788
  end
end
