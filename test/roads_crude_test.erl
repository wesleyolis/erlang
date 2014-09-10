-module(roads_crude_test).
-include_lib("eunit/include/eunit.hrl").

setup_test()->true.

shortest_path_test()->
        ?assertEqual([{b,10},{x,30},{a,5},{x,20},{b,2},{b,8}], roads_crude:shortest_path("50 10 30 5 90 20 40 2 25 10 8 0")).

teardown_test()->true.
