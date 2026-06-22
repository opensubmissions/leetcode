defmodule Solution do
  def three_sum(nums) do
    nums =
      nums
      |> Enum.sort()
      |> List.to_tuple()
    n = tuple_size(nums)
    0..(n - 3)
    |> Enum.reduce([], fn i, acc ->
      if i > 0 and elem(nums, i) == elem(nums, i - 1) do
        acc
      else
        two_pointer(nums, i, i + 1, n - 1, acc)
      end
    end)
    |> Enum.reverse()
  end
  defp two_pointer(nums, i, left, right, acc) when left < right do
    a = elem(nums, i)
    b = elem(nums, left)
    c = elem(nums, right)
    sum = a + b + c
    cond do
      sum < 0 ->
        two_pointer(nums, i, left + 1, right, acc)
      sum > 0 ->
        two_pointer(nums, i, left, right - 1, acc)
      true ->
        left = move_left(nums, left, right, b)
        right = move_right(nums, left, right, c)
        two_pointer(
          nums,
          i,
          left,
          right,
          [[a, b, c] | acc]
        )
    end
  end
  defp two_pointer(_, _, _, _, acc), do: acc
  defp move_left(nums, left, right, value) do
    cond do
      left < right and elem(nums, left) == value ->
        move_left(nums, left + 1, right, value)
      true ->
        left
    end
  end
  defp move_right(nums, left, right, value) do
    cond do
      left < right and elem(nums, right) == value ->
        move_right(nums, left, right - 1, value)
      true ->
        right
    end
  end
end