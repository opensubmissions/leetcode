# @param {Integer[][]} grid
# @return {Integer}
def maximum_safeness_factor(grid)
  n = grid.size
  total = n * n
  inf = 1 << 60

  dist = Array.new(n) { Array.new(n, inf) }

  qx = Array.new(total)
  qy = Array.new(total)
  front = 0
  back = 0

  n.times do |i|
    n.times do |j|
      if grid[i][j] == 1
        dist[i][j] = 0
        qx[back] = i
        qy[back] = j
        back += 1
      end
    end
  end

  dx = [1, -1, 0, 0]
  dy = [0, 0, 1, -1]

  # Multi-source BFS
  while front < back
    x = qx[front]
    y = qy[front]
    front += 1

    d = dist[x][y] + 1

    4.times do |k|
      nx = x + dx[k]
      ny = y + dy[k]

      next if nx < 0 || ny < 0 || nx >= n || ny >= n
      next if dist[nx][ny] <= d

      dist[nx][ny] = d
      qx[back] = nx
      qy[back] = ny
      back += 1
    end
  end

  cells = []
  n.times do |i|
    n.times do |j|
      cells << [dist[i][j], i, j]
    end
  end

  cells.sort_by! { |x| -x[0] }

  parent = Array.new(total) { |i| i }
  active = Array.new(total, false)

  find = lambda do |x|
    while parent[x] != x
      parent[x] = parent[parent[x]]
      x = parent[x]
    end
    x
  end

  union = lambda do |a, b|
    pa = find.call(a)
    pb = find.call(b)
    parent[pa] = pb if pa != pb
  end

  start = 0
  finish = total - 1

  cells.each do |safe, x, y|
    id = x * n + y
    active[id] = true

    4.times do |k|
      nx = x + dx[k]
      ny = y + dy[k]

      next if nx < 0 || ny < 0 || nx >= n || ny >= n

      nid = nx * n + ny
      next unless active[nid]

      union.call(id, nid)
    end

    if active[start] && active[finish] &&
       find.call(start) == find.call(finish)
      return safe
    end
  end

  0
end