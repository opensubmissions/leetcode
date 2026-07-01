class Solution {
    fun maximumSafenessFactor(grid: List<List<Int>>): Int {
        val n = grid.size
        val inf = 1_000_000_000

        val dist = Array(n) { IntArray(n) { inf } }
        val qx = IntArray(n * n)
        val qy = IntArray(n * n)

        var front = 0
        var back = 0

        for (i in 0 until n) {
            for (j in 0 until n) {
                if (grid[i][j] == 1) {
                    dist[i][j] = 0
                    qx[back] = i
                    qy[back] = j
                    back++
                }
            }
        }

        val dx = intArrayOf(1, -1, 0, 0)
        val dy = intArrayOf(0, 0, 1, -1)

        // Multi-source BFS
        while (front < back) {
            val x = qx[front]
            val y = qy[front]
            front++

            for (k in 0 until 4) {
                val nx = x + dx[k]
                val ny = y + dy[k]

                if (nx !in 0 until n || ny !in 0 until n) continue

                if (dist[nx][ny] > dist[x][y] + 1) {
                    dist[nx][ny] = dist[x][y] + 1
                    qx[back] = nx
                    qy[back] = ny
                    back++
                }
            }
        }

        if (dist[0][0] == 0 || dist[n - 1][n - 1] == 0) return 0

        fun can(safe: Int): Boolean {
            if (dist[0][0] < safe || dist[n - 1][n - 1] < safe) return false

            val vis = Array(n) { BooleanArray(n) }

            front = 0
            back = 0
            qx[back] = 0
            qy[back] = 0
            back++
            vis[0][0] = true

            while (front < back) {
                val x = qx[front]
                val y = qy[front]
                front++

                if (x == n - 1 && y == n - 1) return true

                for (k in 0 until 4) {
                    val nx = x + dx[k]
                    val ny = y + dy[k]

                    if (nx !in 0 until n || ny !in 0 until n) continue
                    if (vis[nx][ny]) continue
                    if (dist[nx][ny] < safe) continue

                    vis[nx][ny] = true
                    qx[back] = nx
                    qy[back] = ny
                    back++
                }
            }

            return false
        }

        var lo = 0
        var hi = 2 * n

        while (lo < hi) {
            val mid = (lo + hi + 1) / 2
            if (can(mid)) {
                lo = mid
            } else {
                hi = mid - 1
            }
        }

        return lo
    }
}