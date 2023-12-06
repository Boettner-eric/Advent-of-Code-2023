defmodule Aoc23 do
  @moduledoc """
  Documentation for `Aoc23`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Aoc23.hello()
      :world

  """
  def hello do
    :world
  end

  def read_lines(filename) do
    {:ok, input} = File.read(filename)

    input
    |> String.split("\n")
  end

  def read_blob(filename) do
    {:ok, input} = File.read(filename)

    input
  end
end
