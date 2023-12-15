defmodule FifteenTest do
  use ExUnit.Case

  test "day fifteen, gets correct answer for sample one" do
    assert LensLibrary.problem_one("lib/day15/sample.txt") == 1320
  end

  test "day fifteen, gets correct answer for problem one" do
    assert LensLibrary.problem_one() == 510_273
  end

  test "day fifteen, gets correct answer for sample two" do
    assert LensLibrary.problem_two("lib/day15/sample.txt") == 145
  end

  test "day fifteen, gets correct answer for problem two" do
    assert LensLibrary.problem_two() == 212_449
  end
end
