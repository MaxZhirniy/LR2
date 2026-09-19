defmodule PerfectSquare do
  def main do
    count = 
      IO.stream(:stdio, :line)
      |> Stream.map(&String.trim/1)
      |> Stream.take_while(&(&1 != ""))
      |> Stream.flat_map(&split_tokens/1)
      |> Stream.map(&parse_integer/1)
      |> Stream.filter(&is_perfect_square?/1)
      |> Enum.count()
    
    IO.puts(count)
  end

  defp split_tokens(line) do
    line
    |> String.replace(",", " ")
    |> String.split(~r/\s+/, trim: true)
  end

  defp parse_integer(token) do
    case Integer.parse(token) do
      {num, ""} when num >= 0 -> num
      {_, _} -> raise "Invalid input: #{token}"
      :error -> raise "Invalid input: #{token}"
    end
  end

  defp is_perfect_square?(n) do
    sqrt_n = :math.sqrt(n) |> trunc()
    sqrt_n * sqrt_n == n ||
    (sqrt_n + 1) * (sqrt_n + 1) == n ||
    (sqrt_n - 1) * (sqrt_n - 1) == n
  end
end

PerfectSquare.main()