-module(recrusion).
-export([sublist/2, mergeAsTuple/2]).

-ifdef(TEST).
-compile([export_all]).
-endif.

sublist(L,N) -> sublist_tail(L,N,[]).

sublist_tail( _, 0, SubList ) -> SubList;
sublist_tail( [], _, SubList ) -> SubList;
sublist_tail( [H|T], N, SubList ) when N > 0 -> sublist_tail( T, N-1, [H | SubList] ).

mergeAsTuple( LsA, LsB ) -> lists:reverse(mergeAsTuple_tail( LsA, LsB, [] )).

mergeAsTuple_tail( [A|LsA], [B|LsB], Rs ) -> mergeAsTuple_tail( LsA, LsB, [ {A,B} | Rs ]);
mergeAsTuple_tail( [], [B|LsB], Rs) -> mergeAsTuple_tail( [], LsB, [ {undefined, B} | Rs ] );
mergeAsTuple_tail( [A|LsA], [], Rs) -> mergeAsTuple_tail( LsA, [], [ {A, undefined} | Rs ] );
mergeAsTuple_tail( [], [], Rs ) -> Rs.
