defmodule DayNineTest do
  use ExUnit.Case

  test "day nine, gets correct answer for problem one" do
    assert MirageMaintenance.problem_one() == 1_987_402_313
  end

  test "day nine, gets correct answer for sample problem one" do
    assert MirageMaintenance.problem_one("lib/day9/sample.txt") == 114
  end

  test "day nine, gets correct answer for problem two" do
    assert MirageMaintenance.problem_two() == 900
  end

  test "day nine, gets correct answer for sample problem two" do
    assert MirageMaintenance.problem_two("lib/day9/sample.txt") == 2
  end
end
