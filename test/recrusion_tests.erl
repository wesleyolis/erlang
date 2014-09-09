-module(recrusion_tests).
-include_lib("eunit/include/eunit.hrl").

setup_test() -> ?assertEqual( b, b ).

sublist_test() -> ?assertEqual( [4,3,2,1], recrusion:sublist([1,2,3,4,5,6,7,8],4) ).

teardown_test() -> ?assertEqual( a, a ).
