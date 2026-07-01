typedef struct
{
    int x, y;
} Node;

int maximumSafenessFactor(int **grid, int gridSize, int *gridColSize)
{
    int n = gridSize;
    const int INF = 1000000000;

    int *distMem = (int *)malloc(n * n * sizeof(int));
    int **dist = (int **)malloc(n * sizeof(int *));
    for (int i = 0; i < n; i++)
    {
        dist[i] = distMem + i * n;
    }

    Node *queue = (Node *)malloc(n * n * sizeof(Node));
    int front = 0, back = 0;

    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < n; j++)
        {
            if (grid[i][j] == 1)
            {
                dist[i][j] = 0;
                queue[back++] = (Node){i, j};
            }
            else
            {
                dist[i][j] = INF;
            }
        }
    }

    int dx[4] = {1, -1, 0, 0};
    int dy[4] = {0, 0, 1, -1};

    while (front < back)
    {
        Node cur = queue[front++];

        for (int k = 0; k < 4; k++)
        {
            int nx = cur.x + dx[k];
            int ny = cur.y + dy[k];

            if (nx < 0 || ny < 0 || nx >= n || ny >= n)
                continue;

            if (dist[nx][ny] > dist[cur.x][cur.y] + 1)
            {
                dist[nx][ny] = dist[cur.x][cur.y] + 1;
                queue[back++] = (Node){nx, ny};
            }
        }
    }

    if (dist[0][0] == 0 || dist[n - 1][n - 1] == 0)
    {
        free(queue);
        free(dist);
        free(distMem);
        return 0;
    }

    char *visited = (char *)malloc(n * n);

    int left = 0, right = 2 * n;

    while (left < right)
    {
        int mid = (left + right + 1) / 2;

        if (dist[0][0] < mid || dist[n - 1][n - 1] < mid)
        {
            right = mid - 1;
            continue;
        }

        memset(visited, 0, n * n);

        front = back = 0;
        queue[back++] = (Node){0, 0};
        visited[0] = 1;

        int found = 0;

        while (front < back)
        {
            Node cur = queue[front++];

            if (cur.x == n - 1 && cur.y == n - 1)
            {
                found = 1;
                break;
            }

            for (int k = 0; k < 4; k++)
            {
                int nx = cur.x + dx[k];
                int ny = cur.y + dy[k];

                if (nx < 0 || ny < 0 || nx >= n || ny >= n)
                    continue;

                int id = nx * n + ny;

                if (visited[id])
                    continue;

                if (dist[nx][ny] < mid)
                    continue;

                visited[id] = 1;
                queue[back++] = (Node){nx, ny};
            }
        }

        if (found)
            left = mid;
        else
            right = mid - 1;
    }

    free(visited);
    free(queue);
    free(dist);
    free(distMem);

    return left;
}