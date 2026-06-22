-spec three_sum(Nums :: [integer()]) -> [[integer()]].
three_sum(Nums) ->
    Sorted = lists:sort(Nums),
    N = length(Sorted),
    V = list_to_tuple(Sorted),
    Result = three_sum_i(0, N - 2, V, []),
    Result.
%% i from 0 to n-3
three_sum_i(I, MaxI, V, Acc) when I > MaxI ->
    lists:reverse(Acc);
three_sum_i(I, MaxI, V, Acc) ->
    VI = element(I + 1, V),
    Acc1 =
        case I > 0 andalso VI =:= element(I, V) of
            true ->
                Acc;
            false ->
                Acc2 = two_sum(I, I + 1, tuple_size(V) - 1, V, Acc),
                Acc2
        end,
    three_sum_i(I + 1, MaxI, V, Acc1).
%% two pointers
two_sum(I, L, R, V, Acc) when L < R ->
    Sum = element(I + 1, V) + element(L + 1, V) + element(R + 1, V),
    case Sum of
        S when S < 0 ->
            two_sum(I, L + 1, R, V, Acc);
        S when S > 0 ->
            two_sum(I, L, R - 1, V, Acc);
        0 ->
            A = element(I + 1, V),
            B = element(L + 1, V),
            C = element(R + 1, V),
            NewAcc = [[A, B, C] | Acc],
            NL = skip_left(L + 1, R, B, V),
            NR = skip_right(L, R - 1, C, V),
            two_sum(I, NL, NR, V, NewAcc)
    end;
two_sum(_, _, _, _, Acc) ->
    Acc.
%% skip duplicates on left
skip_left(L, R, Val, V) when L < R, element(L + 1, V) =:= Val ->
    skip_left(L + 1, R, Val, V);
skip_left(L, _, _, _) ->
    L.
%% skip duplicates on right
skip_right(L, R, Val, V) when L < R, element(R + 1, V) =:= Val ->
    skip_right(L, R - 1, Val, V);
skip_right(_, R, _, _) ->
    R.