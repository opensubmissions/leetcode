/**
 * @param {number[][]} grid
 * @return {number}
 */
var maximumSafenessFactor = function(grid) {
    const n = grid.length;
    const INF = 1e9;

    const dist = Array.from({ length: n }, () => Array(n).fill(INF));

    const q = new Array(n * n);
    let front = 0, back = 0;

    for (let i = 0; i < n; i++) {
        for (let j = 0; j < n; j++) {
            if (grid[i][j] === 1) {
                dist[i][j] = 0;
                q[back++] = [i, j];
            }
        }
    }

    const dirs = [[1,0],[-1,0],[0,1],[0,-1]];

    // Multi-source BFS
    while (front < back) {
        const [x, y] = q[front++];

        for (const [dx, dy] of dirs) {
            const nx = x + dx;
            const ny = y + dy;

            if (nx < 0 || ny < 0 || nx >= n || ny >= n) continue;

            if (dist[nx][ny] > dist[x][y] + 1) {
                dist[nx][ny] = dist[x][y] + 1;
                q[back++] = [nx, ny];
            }
        }
    }

    if (dist[0][0] === 0 || dist[n - 1][n - 1] === 0) {
        return 0;
    }

    function can(safe) {
        if (dist[0][0] < safe || dist[n - 1][n - 1] < safe) {
            return false;
        }

        const vis = Array.from({ length: n }, () => Array(n).fill(false));
        front = back = 0;
        q[back++] = [0, 0];
        vis[0][0] = true;

        while (front < back) {
            const [x, y] = q[front++];

            if (x === n - 1 && y === n - 1) return true;

            for (const [dx, dy] of dirs) {
                const nx = x + dx;
                const ny = y + dy;

                if (nx < 0 || ny < 0 || nx >= n || ny >= n) continue;
                if (vis[nx][ny]) continue;
                if (dist[nx][ny] < safe) continue;

                vis[nx][ny] = true;
                q[back++] = [nx, ny];
            }
        }

        return false;
    }

    let lo = 0, hi = 2 * n;

    while (lo < hi) {
        const mid = (lo + hi + 1) >> 1;

        if (can(mid)) {
            lo = mid;
        } else {
            hi = mid - 1;
        }
    }

    return lo;
};