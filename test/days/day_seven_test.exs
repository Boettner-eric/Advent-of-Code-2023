defmodule DaySevenTest do
  use ExUnit.Case

  test "day seven, gets correct answer for problem one" do
    assert CamelCards.problem_one() == 251_287_184
  end

  test "day seven, gets correct answer for sample problem one" do
    assert CamelCards.problem_one("lib/day7/sample.txt") == 6440
  end

  test "day seven, gets correct answer for problem two" do
    assert CamelCards.problem_two() == 250_757_288
  end

  test "day seven, gets correct answer for sample problem two" do
    assert CamelCards.problem_two("lib/day7/sample.txt") == 5905
  end
end
