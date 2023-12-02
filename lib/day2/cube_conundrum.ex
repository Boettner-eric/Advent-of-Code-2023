defmodule CubeConundrum do
  def problem_one do
    Aoc23.read_lines("lib/day2/input.txt")
    |> Enum.reduce(0, fn line, acc ->
      [game_num, rounds] = String.split(line, ":")
      [_, num] = String.split(game_num, " ")

      String.split(rounds, ";")
      |> Enum.all?(fn game ->
        String.split(game, ", ")
        |> Enum.all?(fn color ->
          [freq, name] = String.split(color, " ", trim: true)

          case name do
            "red" -> String.to_integer(freq) <= 12
            "green" -> String.to_integer(freq) <= 13
            "blue" -> String.to_integer(freq) <= 14
          end
        end)
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
        String.split(rounds, ";")
        |> Enum.reduce(%{red: 0, green: 0, blue: 0}, fn game, acc ->
          String.split(game, ", ")
          |> Enum.map(fn color ->
            [freq, name] = String.split(color, " ", trim: true)
            freq = String.to_integer(freq)

            case name do
              "red" -> Map.update!(acc, :red, fn i -> max(freq, i) end)
              "green" -> Map.update!(acc, :green, fn i -> max(freq, i) end)
              "blue" -> Map.update!(acc, :blue, fn i -> max(freq, i) end)
            end
          end)
          |> Enum.reduce(acc, &max_colors(&1, &2))
        end)

      red * blue * green + total
    end)
  end

  defp max_colors(l, i) do
    %{
      red: max(l.red, i.red),
      green: max(l.green, i.green),
      blue: max(l.blue, i.blue)
    }
  end
end
