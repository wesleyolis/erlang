.PHONY: all app test

ebin/play_erlang.app: src/*.erl src/*/*.erl include/*.hrl
	./rebar compile

clean:
	rm -f ebin/*

test: app test/*.erl
	./rebar eunit

all: clean test

app: ebin/play_erlang.app


