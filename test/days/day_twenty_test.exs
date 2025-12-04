defmodule TwentyTest do
  use ExUnit.Case

  test "day twenty, gets correct answer for sample one" do
    assert PulsePropagation.problem_one("lib/day20/sample.txt") == 32_000_000
  end

  test "day twenty, gets correct answer for problem one" do
    assert PulsePropagation.problem_one() == 808_146_535
  end

  test "day twenty, gets correct answer for problem two" do
    assert PulsePropagation.problem_two() == 224_602_953_547_789
  end
end
