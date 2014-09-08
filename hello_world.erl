-module(hello_world).

-export([
    go/0
    ]).

go() ->
    io:format("~s~n", ["Hello World"]).


%EOF
