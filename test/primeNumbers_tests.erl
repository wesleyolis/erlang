-module(primeNumbers_tests).
-include_lib("eunit/include/eunit.hrl").

setup_test() -> true.

genPrime_test() ->
    ?assertEqual("Yello World", primeNumbers:genPrime(5)),
    true.

teardown_test() -> ?assertEqual(a,a).





