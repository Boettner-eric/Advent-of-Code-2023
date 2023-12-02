defmodule CubeConundrum do
  def problem_one do
    Aoc23.read_lines("lib/day2/input.txt")
    |> Enum.reduce(0, fn line, acc ->
      [game_num, rounds] = String.split(line, ":")
      [_, num] = String.split(game_num, " ")

      String.split(rounds, [";", ", "])
      |> Enum.all?(fn color ->
        [freq, name] = String.split(color, " ", trim: true)

        case name do
          "red" -> String.to_integer(freq) <= 12
          "green" -> String.to_integer(freq) <= 13
          "blue" -> String.to_integer(freq) <= 14
        end
      end)
      |> case do
        true -> String.to_integer(num) + acc
        false -> acc
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
          freq = String.to_integer(freq)

          case name do
            "red" -> Map.update!(acc, :red, fn i -> max(freq, i) end)
            "green" -> Map.update!(acc, :green, fn i -> max(freq, i) end)
            "blue" -> Map.update!(acc, :blue, fn i -> max(freq, i) end)
          end
        end)

      red * blue * green + total
    end)
  end
end
