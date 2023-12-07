defmodule CubeConundrum do
  defguard color_max(red, green, blue) when red <= 12 and green <= 13 and blue <= 14

  def problem_one do
    Aoc23.read_lines("lib/day2/input.txt")
    |> Enum.reduce(0, fn line, acc ->
      [game_num, rounds] = String.split(line, ":")
      [_, num] = String.split(game_num, " ")

      String.split(rounds, [";", ", "])
      |> Enum.reduce(%{red: 0, green: 0, blue: 0}, fn color, acc ->
        [freq, name] = String.split(color, " ", trim: true)
        Map.update!(acc, String.to_atom(name), &max(String.to_integer(freq), &1))
      end)
      |> case do
        %{red: r, green: g, blue: b} when color_max(r, g, b) -> String.to_integer(num) + acc
        _ -> acc
      end
    end)
  end

  def problem_two do
    Aoc23.read_lines("lib/day2/input.txt")
    |> Enum.reduce(0, fn line, total ->
      [_, rounds] = String.split(line, ":")

      %{red: red, green: green, blue: blue} =
        String.split(rounds, [";", ", "])
        |> Enum.reduce(%{red: 0, green: 0, blue: 0}, fn color, acc ->
          [freq, name] = String.split(color, " ", trim: true)
          Map.update!(acc, String.to_atom(name), &max(String.to_integer(freq), &1))
        end)

      red * blue * green + total
    end)
  end
end
