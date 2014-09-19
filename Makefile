.PHONY: all app test

ebin/play_erlang.app: src/*.erl src/*/*.erl include/*.hrl
	./rebar compile

clean:
	rm -f ebin/*

test: app test/*.erl
	./rebar eunit

dialyzer: | all dialyzer_core  dialyzer_src
  
dialyzer_src: src/*.erl src/*/*.erl include/*.hrl
	dialyzer -r src --src 

dialyzer_core: /home/wesley/.dialyzer_plt

/home/wesley/.dialyzer_plt:
	dialyzer --build_plt --apps erts kernel stdlib

dialyzer_clean:
	rm -f ~/.dialyzer_plt

all: clean test 

app: ebin/play_erlang.app


