defmodule CamelCards do
  @card_rank ["A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2"]
  def problem_one(filename \\ "lib/day7/input.txt") do
    Aoc23.read_lines(filename)
    |> Enum.map(&parse_hand/1)
    |> Enum.sort(&compare_hands/2)
    |> Enum.with_index()
    |> Enum.reduce(0, fn {{_, bid, _}, i}, acc ->
      (i + 1) * bid + acc
    end)
  end

  def parse_hand(hand, joker \\ false) do
    [hand, bid] = String.split(hand, " ", trim: true)
    hand = String.split(hand, "", trim: true)
    {hand, String.to_integer(bid), rank_hand(hand, joker)}
  end

  def rank_hand(hand, joker \\ false) do
    {freq, jokers} = Enum.frequencies(hand) |> remove_joker(joker)

    Map.values(freq)
    |> Enum.sort(&(&2 <= &1))
    |> add_jokers(jokers)
    |> case do
      [5] -> 7
      [4 | _] -> 6
      [3, 2 | _] -> 5
      [3 | _] -> 4
      [2, 2 | _] -> 3
      [2 | _] -> 2
      _ -> 1
    end
  end

  def remove_joker(%{"J" => v} = map, true) do
    {Map.delete(map, "J"), v}
  end

  def remove_joker(map, _) do
    {map, 0}
  end

  def add_jokers([v | tail], jokers) when jokers > 0 do
    [v + jokers | tail]
  end

  # this is a super annoying edge case that I struggled with
  # effectively if there are 5 Jokers then they have no card to copy
  # so we just keep them
  def add_jokers([], jokers) when jokers > 0 do
    [5]
  end

  def add_jokers(list, _) do
    list
  end

  def compare_hands({hand_a, _, rank_a}, {hand_b, _, rank_b}, joker \\ false) do
    cond do
      rank_a < rank_b -> true
      rank_a == rank_b -> break_tie(hand_a, hand_b, joker)
      true -> false
    end
  end

  def break_tie([a | ra], [b | rb], joker) do
    cond do
      a == b -> break_tie(ra, rb, joker)
      get_card_rank(a, joker) < get_card_rank(b, joker) -> false
      get_card_rank(a, joker) > get_card_rank(b, joker) -> true
      true -> false
    end
  end

  def get_card_rank(card, joker) do
    if joker && card == "J" do
      10000
    else
      Enum.find_index(@card_rank, &Kernel.==(&1, card))
    end
  end

  def problem_two(filename \\ "lib/day7/input.txt") do
    Aoc23.read_lines(filename)
    |> Enum.map(&parse_hand(&1, true))
    |> Enum.sort(&compare_hands(&1, &2, true))
    |> Enum.with_index()
    |> Enum.reduce(0, fn {{_, bid, _}, i}, acc ->
      (i + 1) * bid + acc
    end)
  end
end
