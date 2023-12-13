defmodule DayElevenTest do
  use ExUnit.Case

  test "day eleven, gets correct answer for problem one" do
    assert CosmicExpansion.problem_one() == 9_418_609
  end

  test "day eleven, gets correct answer for sample problem one" do
    assert CosmicExpansion.problem_one("lib/day11/sample.txt") == 374
  end

  test "day eleven, gets correct answer for problem two" do
    assert CosmicExpansion.problem_two("lib/day11/input.txt", 1_000_000) == 593_821_230_983
  end

  test "day eleven, gets correct answer for sample two (10x)" do
    assert CosmicExpansion.problem_two("lib/day11/sample.txt", 10) == 1030
  end

  test "day eleven, gets correct answer for sample two (100x)" do
    assert CosmicExpansion.problem_two("lib/day11/sample.txt", 100) == 8410
  end
end
