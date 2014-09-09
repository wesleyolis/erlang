-module(example).

-export( [run/0] ).

run() ->

    Point = {4,5},

    {X,Y} = Point,

    io:format("~p ~p~n", [X, Y]).

%EOF
