defmodule DayOneTest do
  use ExUnit.Case

  test "day one, gets correct answer for problem one" do
    assert Trebuchet.problem_one() == 55816
  end

  test "day one, gets correct answer for problem two" do
    assert Trebuchet.problem_two() == 54980
  end
end
