-module(recrusion_tests).
-include_lib("eunit/include/eunit.hrl").

setup_test() -> ?assertEqual( b, b ).

sublist_test() -> ?assertEqual( [4,3,2,1], recrusion:sublist([1,2,3,4,5,6,7,8],4) ),
                  ?assertEqual([{1,5},{2,6},{3,7},{4,8}] , recrusion:mergeAsTuple([1,2,3,4],[5,6,7,8])),
                  ?assertEqual([{1,5},{2,6},{3,7},{undefined,8}] , recrusion:mergeAsTuple([1,2,3],[5,6,7,8])),
                  ?assertEqual([{1,5},{2,6},{3,undefined},{4,undefined}] , recrusion:mergeAsTuple([1,2,3,4],[5,6])),
                  ?assertEqual([{1,undefined},{2,undefined},{3,undefined},{4,undefined}] , recrusion:mergeAsTuple([1,2,3,4],[])).

teardown_test() -> ?assertEqual( a, a ).
