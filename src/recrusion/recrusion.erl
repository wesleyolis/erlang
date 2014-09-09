-module(recrusion).
-export([sublist/2]).

-ifdef(TEST).
-compile([export_all]).
-endif.

sublist(L,N) -> sublist_tail(L,N,[]).

sublist_tail( _, 0, SubList ) -> SubList;
sublist_tail( [], _, SubList ) -> SubList;
sublist_tail( [H|T], N, SubList ) when N > 0 -> sublist_tail( T, N-1, [H | SubList] ).

