defmodule DayTwoTest do
  use ExUnit.Case

  test "day two, gets correct answer for problem one" do
    assert CubeConundrum.problem_one() == 2632
  end

  test "day two, gets correct answer for problem two" do
    assert CubeConundrum.problem_two() == 69629
  end
end
