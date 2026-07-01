defmodule Solution do
  @spec maximum_safeness_factor(grid :: [[integer]]) :: integer
  def maximum_safeness_factor(grid) do
    n = length(grid)
    inf = n * n + 5

    dist = :array.new(n * n, default: inf)
    queue = :queue.new()

    {dist, queue} =
      Enum.with_index(grid)
      |> Enum.reduce({dist, queue}, fn {row, r}, {d, q} ->
        Enum.with_index(row)
        |> Enum.reduce({d, q}, fn {cell, c}, {d2, q2} ->
          if cell == 1 do
            idx = r * n + c
            {:array.set(idx, 0, d2), :queue.in({r, c}, q2)}
          else
            {d2, q2}
          end
        end)
      end)

    dirs = [{1, 0}, {-1, 0}, {0, 1}, {0, -1}]
    dist = bfs(queue, dist, n, dirs)

    start_safe = :array.get(0, dist)
    end_safe = :array.get(n * n - 1, dist)
    hi = min(start_safe, end_safe)

    binary_search(0, hi, dist, n, dirs)
  end

  defp bfs(queue, dist, n, dirs) do
    case :queue.out(queue) do
      {:empty, _} ->
        dist

      {{:value, {r, c}}, q} ->
        cur = :array.get(r * n + c, dist)

        {dist2, q2} =
          Enum.reduce(dirs, {dist, q}, fn {dr, dc}, {d, qu} ->
            nr = r + dr
            nc = c + dc

            if nr >= 0 and nr < n and nc >= 0 and nc < n do
              idx = nr * n + nc

              if :array.get(idx, d) > cur + 1 do
                {:array.set(idx, cur + 1, d), :queue.in({nr, nc}, qu)}
              else
                {d, qu}
              end
            else
              {d, qu}
            end
          end)

        bfs(q2, dist2, n, dirs)
    end
  end

  defp binary_search(lo, hi, dist, n, dirs) when lo < hi do
    mid = div(lo + hi + 1, 2)

    if can_reach?(mid, dist, n, dirs) do
      binary_search(mid, hi, dist, n, dirs)
    else
      binary_search(lo, mid - 1, dist, n, dirs)
    end
  end

  defp binary_search(lo, _hi, _dist, _n, _dirs), do: lo

  defp can_reach?(limit, dist, n, dirs) do
    if :array.get(0, dist) < limit do
      false
    else
      visited = :array.new(n * n, default: false)
      visited = :array.set(0, true, visited)
      queue = :queue.in({0, 0}, :queue.new())

      dfs(queue, visited, limit, dist, n, dirs)
    end
  end

  defp dfs(queue, visited, limit, dist, n, dirs) do
    case :queue.out(queue) do
      {:empty, _} ->
        false

      {{:value, {r, c}}, q} ->
        if r == n - 1 and c == n - 1 do
          true
        else
          {visited2, q2} =
            Enum.reduce(dirs, {visited, q}, fn {dr, dc}, {vis, qu} ->
              nr = r + dr
              nc = c + dc

              if nr >= 0 and nr < n and nc >= 0 and nc < n do
                idx = nr * n + nc

                if not :array.get(idx, vis) and :array.get(idx, dist) >= limit do
                  {:array.set(idx, true, vis), :queue.in({nr, nc}, qu)}
                else
                  {vis, qu}
                end
              else
                {vis, qu}
              end
            end)

          dfs(q2, visited2, limit, dist, n, dirs)
        end
    end
  end
end