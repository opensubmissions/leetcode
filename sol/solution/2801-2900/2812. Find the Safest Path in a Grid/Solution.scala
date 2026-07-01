import scala.collection.mutable

object Solution {
    def maximumSafenessFactor(grid: List[List[Int]]): Int = {
        val n = grid.length
        val INF = Int.MaxValue / 2

        val dist = Array.fill(n, n)(INF)
        val q = mutable.Queue[(Int, Int)]()

        // Multi-source BFS from all thieves
        for (i <- 0 until n; j <- 0 until n) {
            if (grid(i)(j) == 1) {
                dist(i)(j) = 0
                q.enqueue((i, j))
            }
        }

        val dirs = Array((1,0), (-1,0), (0,1), (0,-1))

        while (q.nonEmpty) {
            val (x, y) = q.dequeue()

            for ((dx, dy) <- dirs) {
                val nx = x + dx
                val ny = y + dy

                if (nx >= 0 && ny >= 0 && nx < n && ny < n) {
                    if (dist(nx)(ny) > dist(x)(y) + 1) {
                        dist(nx)(ny) = dist(x)(y) + 1
                        q.enqueue((nx, ny))
                    }
                }
            }
        }

        if (dist(0)(0) == 0 || dist(n-1)(n-1) == 0) return 0

        def can(safe: Int): Boolean = {
            if (dist(0)(0) < safe || dist(n-1)(n-1) < safe) return false

            val vis = Array.fill(n, n)(false)
            val bfs = mutable.Queue[(Int, Int)]()

            bfs.enqueue((0, 0))
            vis(0)(0) = true

            while (bfs.nonEmpty) {
                val (x, y) = bfs.dequeue()

                if (x == n - 1 && y == n - 1) return true

                for ((dx, dy) <- dirs) {
                    val nx = x + dx
                    val ny = y + dy

                    if (nx >= 0 && ny >= 0 && nx < n && ny < n &&
                        !vis(nx)(ny) && dist(nx)(ny) >= safe) {
                        vis(nx)(ny) = true
                        bfs.enqueue((nx, ny))
                    }
                }
            }

            false
        }

        var lo = 0
        var hi = 2 * n
        var ans = 0

        while (lo <= hi) {
            val mid = (lo + hi) / 2
            if (can(mid)) {
                ans = mid
                lo = mid + 1
            } else {
                hi = mid - 1
            }
        }

        ans
    }
}