-spec maximum_safeness_factor(Grid :: [[integer()]]) -> integer().
maximum_safeness_factor(Grid) ->
    N = length(Grid),
    GridT = list_to_tuple([list_to_tuple(Row) || Row <- Grid]),
    Dist = multi_source_bfs(GridT, N),
    dijkstra_max_safeness(Dist, N).

make_2d(N, Default) ->
    Row = array:new(N, {default, Default}),
    array:new(N, {default, Row}).

get_val(Arr, R, C) ->
    Row = array:get(R, Arr),
    array:get(C, Row).

set_val(Arr, R, C, V) ->
    Row = array:get(R, Arr),
    NewRow = array:set(C, V, Row),
    array:set(R, NewRow, Arr).

get_cell(GridT, R, C) ->
    element(C + 1, element(R + 1, GridT)).

neighbors(R, C, N) ->
    Cands = [{R - 1, C}, {R + 1, C}, {R, C - 1}, {R, C + 1}],
    [{NR, NC} || {NR, NC} <- Cands, NR >= 0, NR < N, NC >= 0, NC < N].

multi_source_bfs(GridT, N) ->
    Dist0 = make_2d(N, -1),
    {Dist1, Q0} =
        lists:foldl(
            fun(R, {DAcc, QAcc}) ->
                lists:foldl(
                    fun(C, {DAcc2, QAcc2}) ->
                        case get_cell(GridT, R, C) of
                            1 ->
                                {set_val(DAcc2, R, C, 0), queue:in({R, C}, QAcc2)};
                            _ ->
                                {DAcc2, QAcc2}
                        end
                    end,
                    {DAcc, QAcc},
                    lists:seq(0, N - 1)
                )
            end,
            {Dist0, queue:new()},
            lists:seq(0, N - 1)
        ),
    bfs_loop(Q0, Dist1, N).

bfs_loop(Q, Dist, N) ->
    case queue:out(Q) of
        {empty, _} ->
            Dist;
        {{value, {R, C}}, Q1} ->
            DCur = get_val(Dist, R, C),
            {Q2, Dist2} =
                lists:foldl(
                    fun({NR, NC}, {QAcc, DAcc}) ->
                        case get_val(DAcc, NR, NC) of
                            -1 ->
                                {queue:in({NR, NC}, QAcc), set_val(DAcc, NR, NC, DCur + 1)};
                            _ ->
                                {QAcc, DAcc}
                        end
                    end,
                    {Q1, Dist},
                    neighbors(R, C, N)
                ),
            bfs_loop(Q2, Dist2, N)
    end.

dijkstra_max_safeness(Dist, N) ->
    StartVal = get_val(Dist, 0, 0),
    Best0 = set_val(make_2d(N, -1), 0, 0, StartVal),
    PQ0 = gb_sets:singleton({StartVal, 0, 0}),
    dijkstra_loop(PQ0, Best0, Dist, N).

dijkstra_loop(PQ, Best, Dist, N) ->
    case gb_sets:is_empty(PQ) of
        true ->
            get_val(Best, N - 1, N - 1);
        false ->
            {{Val, R, C}, PQ1} = gb_sets:take_largest(PQ),
            case Val =:= get_val(Best, R, C) of
                false ->
                    dijkstra_loop(PQ1, Best, Dist, N);
                true ->
                    case R =:= N - 1 andalso C =:= N - 1 of
                        true ->
                            Val;
                        false ->
                            {PQ2, Best2} =
                                lists:foldl(
                                    fun({NR, NC}, {PQAcc, BestAcc}) ->
                                        NeighDist = get_val(Dist, NR, NC),
                                        Candidate = min(Val, NeighDist),
                                        CurBest = get_val(BestAcc, NR, NC),
                                        case Candidate > CurBest of
                                            true ->
                                                {gb_sets:add({Candidate, NR, NC}, PQAcc),
                                                 set_val(BestAcc, NR, NC, Candidate)};
                                            false ->
                                                {PQAcc, BestAcc}
                                        end
                                    end,
                                    {PQ1, Best},
                                    neighbors(R, C, N)
                                ),
                            dijkstra_loop(PQ2, Best2, Dist, N)
                    end
            end
    end.