defmodule PipeMaze do
  @mappings %{
    "-" => %{left: :left, right: :right},
    "|" => %{top: :top, bottom: :bottom},
    "7" => %{left: :top, bottom: :right},
    "F" => %{right: :top, bottom: :left},
    "L" => %{right: :bottom, top: :left},
    "J" => %{left: :bottom, top: :right}
  }
  @next %{left: :right, right: :top, top: :bottom, bottom: nil}

  def problem_one(filename \\ "lib/day10/input.txt") do
    loop =
      Aoc23.read_lines(filename)
      |> Enum.map(&String.split(&1, "", trim: true))
      |> get_loop()

    Enum.map(0..(length(loop) - 1), fn i ->
      min(i + 1, length(loop) - i)
    end)
    |> Enum.max()
  end

  def start(lines, coords \\ {0, 0})
  def start([], _), do: nil

  def start([line | lines], {x, y}) do
    cond do
      x == length(line) -> start(lines, {0, y + 1})
      Enum.at(line, x) == "S" -> {x, y}
      true -> start([line | lines], {x + 1, y})
    end
  end

  def get_loop(arr, coords \\ nil, dir \\ nil)
  def get_loop(arr, nil, nil), do: get_loop(arr, start(arr), :left)

  def get_loop(arr, coords, dir) do
    loop = walk_pipe(arr, next_coord(dir, coords), dir)

    if nil in loop do
      get_loop(arr, coords, @next[dir])
    else
      loop
    end
  end

  def next_coord(dir, {x, y}) do
    case dir do
      :top -> {x, y + 1}
      :bottom -> {x, y - 1}
      :left -> {x + 1, y}
      :right -> {x - 1, y}
    end
  end

  def walk_pipe(arr, {x, y}, dir) do
    val = get_val(arr, {x, y})

    cond do
      val == "S" ->
        []

      Map.has_key?(@mappings[val], dir) ->
        [{x, y} | walk_pipe(arr, next_coord(@mappings[val][dir], {x, y}), @mappings[val][dir])]

      true ->
        [nil]
    end
  end

  def get_val(arr, {x, y}) do
    Enum.at(Enum.at(arr, y, []), x, ".")
  end

  def problem_two(filename \\ "lib/day10/input.txt") do
    arr =
      Aoc23.read_lines(filename)
      |> Enum.map(&String.split(&1, "", trim: true))

    loop = get_loop(arr)

    cache =
      Enum.reduce(loop, [], fn {i, j}, acc ->
        if get_val(arr, {i, j}) in ["|", "L", "J"], do: [{i, j} | acc], else: acc
      end)
      |> Enum.group_by(&elem(&1, 1), &elem(&1, 0))

    for y <- 0..(length(arr) - 1),
        x <- 0..(length(Enum.at(arr, 0, 0)) - 1),
        {x, y} not in loop and get_val(arr, {x, y}) != "S",
        reduce: 0 do
      acc ->
        acc + if count_intersections(x, Map.get(cache, y, [])), do: 1, else: 0
    end
  end

  def count_intersections(x, loop) do
    Enum.reduce(loop, 0, fn i, acc ->
      acc + if i < x, do: 1, else: 0
    end)
    |> rem(2)
    |> Kernel.!=(0)
  end
end
