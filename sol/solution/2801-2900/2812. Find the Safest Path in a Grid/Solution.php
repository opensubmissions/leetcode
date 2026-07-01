class Solution {

    /**
     * @param Integer[][] $grid
     * @return Integer
     */
    function maximumSafenessFactor($grid) {
        $n = count($grid);
        $total = $n * $n;
        $INF = 1 << 30;

        $dist = array_fill(0, $n, array_fill(0, $n, $INF));

        $qx = array_fill(0, $total, 0);
        $qy = array_fill(0, $total, 0);

        $front = 0;
        $back = 0;

        // Multi-source BFS initialization
        for ($i = 0; $i < $n; $i++) {
            for ($j = 0; $j < $n; $j++) {
                if ($grid[$i][$j] == 1) {
                    $dist[$i][$j] = 0;
                    $qx[$back] = $i;
                    $qy[$back] = $j;
                    $back++;
                }
            }
        }

        $dx = [1, -1, 0, 0];
        $dy = [0, 0, 1, -1];

        while ($front < $back) {
            $x = $qx[$front];
            $y = $qy[$front];
            $front++;

            $d = $dist[$x][$y] + 1;

            for ($k = 0; $k < 4; $k++) {
                $nx = $x + $dx[$k];
                $ny = $y + $dy[$k];

                if ($nx < 0 || $ny < 0 || $nx >= $n || $ny >= $n) continue;

                if ($dist[$nx][$ny] > $d) {
                    $dist[$nx][$ny] = $d;
                    $qx[$back] = $nx;
                    $qy[$back] = $ny;
                    $back++;
                }
            }
        }

        // Sort cells by distance descending
        $cells = [];
        for ($i = 0; $i < $n; $i++) {
            for ($j = 0; $j < $n; $j++) {
                $cells[] = [$dist[$i][$j], $i, $j];
            }
        }

        usort($cells, function($a, $b) {
            return $b[0] <=> $a[0];
        });

        $parent = [];
        for ($i = 0; $i < $total; $i++) $parent[$i] = $i;
        $active = array_fill(0, $total, false);

        $find = function($x) use (&$parent) {
            while ($parent[$x] != $x) {
                $parent[$x] = $parent[$parent[$x]];
                $x = $parent[$x];
            }
            return $x;
        };

        $start = 0;
        $end = $total - 1;

        foreach ($cells as $cell) {
            $safe = $cell[0];
            $x = $cell[1];
            $y = $cell[2];

            $id = $x * $n + $y;
            $active[$id] = true;

            for ($k = 0; $k < 4; $k++) {
                $nx = $x + $dx[$k];
                $ny = $y + $dy[$k];

                if ($nx < 0 || $ny < 0 || $nx >= $n || $ny >= $n) continue;

                $nid = $nx * $n + $ny;
                if (!$active[$nid]) continue;

                $pa = $find($id);
                $pb = $find($nid);

                if ($pa != $pb) {
                    $parent[$pa] = $pb;
                }
            }

            if ($active[$start] && $active[$end] &&
                $find($start) == $find($end)) {
                return $safe;
            }
        }

        return 0;
    }
}