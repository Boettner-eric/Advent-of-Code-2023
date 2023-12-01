defmodule Trebuchet do
  @numbers ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]

  def problem_one do
    {:ok, input} = File.read("lib/day1/input.txt")

    input
    |> String.split("\n")
    |> Enum.reduce(0, fn x, acc ->
      digits = get_digits(x)
      ((List.first(digits) <> List.last(digits)) |> String.to_integer()) + acc
    end)
  end

  defp get_digits(string) do
    string
    |> String.split("")
    |> Enum.filter(fn item ->
      case Integer.parse(item) do
        {_, _} -> true
        _ -> false
      end
    end)
  end

  def problem_two do
    {:ok, input} = File.read("lib/day1/input.txt")

    input
    |> String.split("\n")
    |> Enum.reduce(0, fn x, acc ->
      digits = get_all_digits(x)
      ((List.first(digits) <> List.last(digits)) |> String.to_integer()) + acc
    end)
  end

  defp get_all_digits(string) do
    Enum.reduce(@numbers, string, fn digit, acc ->
      String.replace(acc, digit, &get_digit_word/1, global: true)
    end)
    |> String.split("")
    |> Enum.filter(fn item ->
      case Integer.parse(item) do
        {_, _} -> true
        _ -> false
      end
    end)
  end

  defp get_digit_word(word) do
    word <> Integer.to_string(Enum.find_index(@numbers, fn j -> j == word end) + 1) <> word
  end
end
