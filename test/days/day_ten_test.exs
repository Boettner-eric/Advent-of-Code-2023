defmodule DayTenTest do
  use ExUnit.Case

  test "day ten, gets correct answer for problem one" do
    assert PipeMaze.problem_one() == 6860
  end

  test "day ten, gets correct answer for sample problem one" do
    assert PipeMaze.problem_one("lib/day10/sample.txt") == 8
  end

  test "day ten, gets correct answer for problem two" do
    assert PipeMaze.problem_two() == 343
  end

  test "day ten, gets correct answer for sample (four) problem two" do
    assert PipeMaze.problem_two("lib/day10/four.txt") == 4
  end

  test "day ten, gets correct answer for sample (larger) problem two" do
    assert PipeMaze.problem_two("lib/day10/larger.txt") == 8
  end

  test "day ten, gets correct answer for sample (junk area) problem two" do
    assert PipeMaze.problem_two("lib/day10/junk.txt") == 10
  end
end
