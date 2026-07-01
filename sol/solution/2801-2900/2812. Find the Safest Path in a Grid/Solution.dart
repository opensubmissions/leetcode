import 'dart:collection';

class Solution {
  int maximumSafenessFactor(List<List<int>> grid) {
    int n = grid.length;
    const int INF = 1 << 30;

    List<List<int>> dist =
        List.generate(n, (_) => List.filled(n, INF));

    Queue<List<int>> q = Queue<List<int>>();

    // Multi-source BFS init (all thieves)
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        if (grid[i][j] == 1) {
          dist[i][j] = 0;
          q.add([i, j]);
        }
      }
    }

    List<int> dx = [1, -1, 0, 0];
    List<int> dy = [0, 0, 1, -1];

    // BFS to compute nearest thief distance
    while (q.isNotEmpty) {
      var cur = q.removeFirst();
      int x = cur[0], y = cur[1];

      for (int k = 0; k < 4; k++) {
        int nx = x + dx[k];
        int ny = y + dy[k];

        if (nx < 0 || ny < 0 || nx >= n || ny >= n) continue;

        if (dist[nx][ny] > dist[x][y] + 1) {
          dist[nx][ny] = dist[x][y] + 1;
          q.add([nx, ny]);
        }
      }
    }

    if (dist[0][0] == 0 || dist[n - 1][n - 1] == 0) return 0;

    bool can(int safe) {
      if (dist[0][0] < safe || dist[n - 1][n - 1] < safe) return false;

      List<List<bool>> vis =
          List.generate(n, (_) => List.filled(n, false));

      Queue<List<int>> bfs = Queue<List<int>>();
      bfs.add([0, 0]);
      vis[0][0] = true;

      while (bfs.isNotEmpty) {
        var cur = bfs.removeFirst();
        int x = cur[0], y = cur[1];

        if (x == n - 1 && y == n - 1) return true;

        for (int k = 0; k < 4; k++) {
          int nx = x + dx[k];
          int ny = y + dy[k];

          if (nx < 0 || ny < 0 || nx >= n || ny >= n) continue;
          if (vis[nx][ny]) continue;
          if (dist[nx][ny] < safe) continue;

          vis[nx][ny] = true;
          bfs.add([nx, ny]);
        }
      }

      return false;
    }

    int lo = 0, hi = 2 * n, ans = 0;

    while (lo <= hi) {
      int mid = (lo + hi) >> 1;
      if (can(mid)) {
        ans = mid;
        lo = mid + 1;
      } else {
        hi = mid - 1;
      }
    }

    return ans;
  }
}