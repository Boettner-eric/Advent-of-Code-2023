defmodule FourteenTest do
  use ExUnit.Case

  test "day fourteen, gets correct answer for problem one" do
    assert ParabolicReflectorDish.problem_one() == 108_857
  end

  test "day fourteen, gets correct answer for sample one" do
    assert ParabolicReflectorDish.problem_one("lib/day14/sample.txt") == 136
  end

  test "day fourteen, gets correct answer for problem two" do
    assert ParabolicReflectorDish.problem_two() == 95273
  end

  test "day fourteen, gets correct answer for sample two" do
    assert ParabolicReflectorDish.problem_two("lib/day14/sample.txt") == 64
  end
end
