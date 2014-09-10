-module(roads_crude).

-ifdef(TEST).
    -compile([export_all]).
-endif.

-export([main/1,shortest_path/1]).

main([FileName]) -> { ok, Bin } = file:read_file(FileName),
        Path = shortest_path( Bin ),
        io:format("~p~n", [Path]),
        erlang:halt(0).
        
shortest_path(Data)->
          Lst = parse_roads(Data),
          {A,B} = lists:foldl( fun chose_shortest_step/2, {{0,[]},{0,[]}}, Lst ),
          {_Dist, Path } = if hd(element(2,A)) =/= {x,0} -> A;
                             hd(element(2,B)) =/= {x,0} -> B
                          end,
          lists:reverse( Path ).

parse_roads( Data ) when is_binary( Data ) -> 
        parse_roads( binary_to_list( Data ) );
parse_roads( Str ) when is_list( Str ) -> % Re-call that string are esentually lists.
        Vals = [ list_to_integer(X) || X <- string:tokens(Str, "\n\r\t ") ],
        group_values( Vals, [] ).


group_values( [], Acc ) -> lists:reverse(Acc);
group_values( [ A,B,X | Rst ], Acc ) -> 
        group_values( Rst,  [ {A,B,X} | Acc ]).

chose_shortest_step( {A,B,X}, {{DisA, PathA}, {DisB, PathB}} ) -> 
        OpA1 = { DisA + A, [ {a,A} | PathA ] },
        OpA2 = { DisB + B + X, [ {x,X}, {b,B} | PathB ] },
        OpB1 = { DisB + B, [ {b,B} | PathB ] },
        OpB2 = { DisA + A + X, [ {x,X}, {a,A} | PathA ] },
        { erlang:min(OpA1, OpA2), erlang:min(OpB1, OpB2) }.
                    

