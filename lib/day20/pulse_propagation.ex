defmodule PulsePropagation do
  @exit "rx"

  def problem_one(filename \\ "lib/day20/input.txt") do
    Aoc23.read_lines(filename)
    |> Enum.reduce(%{}, &parse_line/2)
    |> update_conjunctions()
    |> Map.merge(%{"counter" => {0, 0}, "solution" => [], "queue" => []})
    |> push_button(1000)
    |> Map.get("counter")
    |> then(fn {l, h} -> l * h end)
  end

  def problem_two(filename \\ "lib/day20/input.txt") do
    Aoc23.read_lines(filename)
    |> Enum.reduce(%{}, &parse_line/2)
    |> update_conjunctions()
    |> find_exits()
    |> Map.merge(%{"counter" => {0, 0}, "solution" => [], "queue" => []})
    |> push_button(5000)
    |> Map.get("solution")
    |> lcm()
  end

  def parse_line(line, map) do
    [module, out] = String.split(line, " -> ", trim: true)
    out = String.split(out, ", ", trim: true)

    case module do
      "broadcaster" -> Map.put(map, module, %{type: :broadcaster, out: out})
      "%" <> name -> Map.put(map, name, %{type: :flip_flop, out: out, state: false})
      "&" <> name -> Map.put(map, name, %{type: :conjunction, out: out, state: %{}})
    end
  end

  # kinda hate this but it works so :shrug:
  def update_conjunctions(circuit) do
    Enum.reduce(circuit, circuit, fn {module, state}, c ->
      Enum.reduce(state[:out], c, fn i, acc ->
        case acc[i] do
          %{type: :conjunction} = c -> Map.put(acc, i, update_conjunction_state(c, module, :low))
          _ -> acc
        end
      end)
    end)
  end

  def update_conjunction_state(module, from, pulse) do
    Map.put(module, :state, Map.put(module[:state], from, pulse))
  end

  def update_flip_flop_state(module, on) do
    Map.put(module, :state, on)
  end

  def push_button(circuit, max) do
    Enum.reduce(1..max, circuit, fn i, c ->
      send_pulse(c, :low, "broadcaster", "button", i)
      |> resolve_queue(i)
    end)
  end

  def resolve_queue(%{"queue" => []} = c, _), do: c

  def resolve_queue(circuit, i) do
    Enum.reduce(circuit["queue"], circuit, fn {pulse, dest, module}, acc ->
      Map.update!(acc, "queue", fn q -> Enum.slice(q, 1..-1//1) end)
      |> send_pulse(pulse, dest, module, i)
    end)
    |> resolve_queue(i)
  end

  def send_pulse(circuit, :high, module, from, index) do
    circuit =
      Map.update!(circuit, "counter", fn {l, h} -> {l, h + 1} end)
      |> update_solution(module, index)

    case Map.get(circuit, module) do
      %{type: :broadcaster, out: out} ->
        add_to_queue(circuit, :high, module, out)

      %{type: :conjunction, out: out} = c ->
        updated_state = update_conjunction_state(c, from, :high)
        circuit = Map.put(circuit, module, updated_state)

        if Enum.all?(Map.values(updated_state[:state]), fn i -> i == :high end) do
          add_to_queue(circuit, :low, module, out)
        else
          add_to_queue(circuit, :high, module, out)
        end

      _ ->
        circuit
    end
  end

  def send_pulse(circuit, :low, module, from, _i) do
    circuit = Map.update!(circuit, "counter", fn {l, h} -> {l + 1, h} end)

    case Map.get(circuit, module) do
      %{type: :broadcaster, out: out} ->
        add_to_queue(circuit, :low, module, out)

      %{type: :flip_flop, state: true, out: out} = c ->
        Map.put(circuit, module, update_flip_flop_state(c, false))
        |> add_to_queue(:low, module, out)

      %{type: :flip_flop, state: false, out: out} = c ->
        Map.put(circuit, module, update_flip_flop_state(c, true))
        |> add_to_queue(:high, module, out)

      %{type: :conjunction, out: out} = c ->
        updated_state = update_conjunction_state(c, from, :low)
        circuit = Map.put(circuit, module, updated_state)

        if Enum.all?(Map.values(updated_state[:state]), fn i -> i == :high end) do
          add_to_queue(circuit, :low, module, out)
        else
          add_to_queue(circuit, :high, module, out)
        end

      _ ->
        circuit
    end
  end

  def add_to_queue(circuit, pulse, src, out) do
    queue = Enum.map(out, fn dest -> {pulse, dest, src} end)
    Map.update!(circuit, "queue", fn q -> q ++ queue end)
  end

  def find_exits(circuit) do
    Enum.reduce(circuit, circuit, fn {module, state}, c ->
      if @exit in state[:out], do: Map.put(c, "exit", module), else: c
    end)
  end

  def update_solution(circuit, module, index) do
    if module == Map.get(circuit, "exit") do
      Map.update!(circuit, "solution", fn i -> [index | i] end)
    else
      circuit
    end
  end

  defp lcm([a | rest]), do: Enum.reduce(rest, a, &lcm/2)
  defp lcm(0, 0), do: 0
  defp lcm(a, b), do: div(a * b, Integer.gcd(a, b))
end
