class Solution {
    func maximumSafenessFactor(_ grid: [[Int]]) -> Int {
        let n = grid.count
        let inf = 1_000_000_000

        var dist = Array(repeating: Array(repeating: inf, count: n), count: n)

        var qx = Array(repeating: 0, count: n * n)
        var qy = Array(repeating: 0, count: n * n)

        var front = 0
        var back = 0

        for i in 0..<n {
            for j in 0..<n {
                if grid[i][j] == 1 {
                    dist[i][j] = 0
                    qx[back] = i
                    qy[back] = j
                    back += 1
                }
            }
        }

        let dx = [1, -1, 0, 0]
        let dy = [0, 0, 1, -1]

        // Multi-source BFS
        while front < back {
            let x = qx[front]
            let y = qy[front]
            front += 1

            for k in 0..<4 {
                let nx = x + dx[k]
                let ny = y + dy[k]

                if nx < 0 || ny < 0 || nx >= n || ny >= n {
                    continue
                }

                if dist[nx][ny] > dist[x][y] + 1 {
                    dist[nx][ny] = dist[x][y] + 1
                    qx[back] = nx
                    qy[back] = ny
                    back += 1
                }
            }
        }

        if dist[0][0] == 0 || dist[n - 1][n - 1] == 0 {
            return 0
        }

        func can(_ safe: Int) -> Bool {
            if dist[0][0] < safe || dist[n - 1][n - 1] < safe {
                return false
            }

            var vis = Array(repeating: Array(repeating: false, count: n), count: n)

            front = 0
            back = 0
            qx[back] = 0
            qy[back] = 0
            back += 1
            vis[0][0] = true

            while front < back {
                let x = qx[front]
                let y = qy[front]
                front += 1

                if x == n - 1 && y == n - 1 {
                    return true
                }

                for k in 0..<4 {
                    let nx = x + dx[k]
                    let ny = y + dy[k]

                    if nx < 0 || ny < 0 || nx >= n || ny >= n {
                        continue
                    }

                    if vis[nx][ny] || dist[nx][ny] < safe {
                        continue
                    }

                    vis[nx][ny] = true
                    qx[back] = nx
                    qy[back] = ny
                    back += 1
                }
            }

            return false
        }

        var lo = 0
        var hi = 2 * n

        while lo < hi {
            let mid = (lo + hi + 1) / 2
            if can(mid) {
                lo = mid
            } else {
                hi = mid - 1
            }
        }

        return lo
    }
}