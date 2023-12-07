defmodule Trebuchet do
  @numbers ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]

  def problem_one do
    Aoc23.read_lines("lib/day1/input.txt")
    |> Enum.reduce(0, &get_digits/2)
  end

  defp get_digits(string, acc) do
    String.split(string, "")
    |> Enum.filter(fn item ->
      case Integer.parse(item) do
        {_, _} -> true
        _ -> false
      end
    end)
    |> then(&(List.first(&1) <> List.last(&1)))
    |> String.to_integer()
    |> Kernel.+(acc)
  end

  def problem_two do
    Aoc23.read_lines("lib/day1/input.txt")
    |> Enum.reduce(0, &get_all_digits/2)
  end

  defp get_all_digits(string, acc) do
    @numbers
    |> Enum.reduce(string, fn digit, acc ->
      String.replace(acc, digit, &get_digit_word/1, global: true)
    end)
    |> String.split("")
    |> Enum.filter(fn item ->
      case Integer.parse(item) do
        {_, _} -> true
        _ -> false
      end
    end)
    |> then(&(List.first(&1) <> List.last(&1)))
    |> String.to_integer()
    |> Kernel.+(acc)
  end

  defp get_digit_word(word) do
    word <> Integer.to_string(Enum.find_index(@numbers, &Kernel.==(&1, word)) + 1) <> word
  end
end
