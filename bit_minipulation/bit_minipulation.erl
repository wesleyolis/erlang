-module(bit_minipulation).
-compile(export_all).

bit_minipulation() -> 
Number = 16#F000000F,
Pixel = <<Number:24>>,
io:format("~p~n", [Pixel]),

BSL = 2#1001011 bsl 1,
io:format("~p~n", [BSL]),

BSL2 = 2#0001011 bsl 1,
io:format("~p~n", [BSL2]),

BSR = 2#0001011 bsr 1,
io:format("~p~n", [BSR]),

BSR2 = 2#110101100 bsr 1,
io:format("~p~n", [BSR2]),

<<X1/unsigned>> = <<-44>>,
io:format("~p~n", [X1]),

<<Packet:2/little-unit:16>> = <<16#0FF0:16,16#1FF8:16>>,
<<PA,PB,PC,PD>> = <<Packet:2/integer-little-unit:16>>,

%<<PA,PB,PC,PD>> = <<Packet:32/integer>>,
io:format("~p~n", [PA]),
io:format("~p~n", [PB]),
io:format("~p~n", [PC]),
io:format("~p~n", [PD]),

io:format("~p~n", [Packet]).

