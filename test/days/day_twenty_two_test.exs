defmodule TwentytwoTest do
  use ExUnit.Case

  test "day twenty two, gets correct answer for sample one" do
    assert SandSlabs.problem_one("lib/day22/sample.txt") == 5
  end

  test "day twenty two, gets correct answer for problem one" do
    assert SandSlabs.problem_one() == 517
  end

  test "day twenty two, gets correct answer for sample two" do
    assert SandSlabs.problem_two("lib/day22/sample.txt") == 7
  end

  test "day twenty two, gets correct answer for problem two" do
    assert SandSlabs.problem_two() == 61276
  end
end
