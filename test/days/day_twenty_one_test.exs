defmodule TwentyOneTest do
  use ExUnit.Case

  test "day twenty one, gets correct answer for sample one" do
    assert StepCounter.problem_one(6, "lib/day21/sample.txt") == 16
  end

  test "day twenty one, gets correct answer for problem one" do
    assert StepCounter.problem_one(64, "lib/day21/input.txt") == 3764
  end

  test "day twenty one, gets correct answer for sample two" do
    assert StepCounter.problem_one(6, "lib/day21/sample.txt") == 16
    assert StepCounter.problem_one(10, "lib/day21/sample.txt") == 50
    assert StepCounter.problem_one(50, "lib/day21/sample.txt") == 1594
    assert StepCounter.problem_one(100, "lib/day21/sample.txt") == 6536
  end

  test "day twenty one, gets correct answer for problem two" do
    assert StepCounter.problem_two(26_501_365) == 622_926_941_971_282
  end
end
