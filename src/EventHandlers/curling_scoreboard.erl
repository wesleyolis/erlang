-module(curling_scoreboard).
-behaviour(gen_event).
-export( [init/1, handle_event/2, handle_call/2, handle_info/2, code_change/3, terminate/2] ).

-include("curling_scoreboard.hrl").

init([]) -> {ok, []}. %the tuple with empty state { ok , State = [] }

%handle_event( Events, State) -> { ok, NewState }, { ok, NewState, hibernate}, {swap_handler, Args1, NewState, Handler, Args2 }

handle_event(Teams = #set_teams{} , State ) -> 
       scoreBoardHw:set_teams( Teams#set_teams.teamA, Teams#set_teams.teamB ),
       {ok, State};

handle_event( Event = #add_points{} , State ) -> 
        [ scoreBoardHw:add_point( Event#add_points.team ) || _ <- lists:seq( 1, Event#add_points.n ) ],
        {ok, State};

handle_event( #next_round{}, State ) ->
        scoreBoardHw:next_round(),
        {ok, State};

handle_event( _, State) -> { ok, State }.

% handle_call( Request, State) -> { ok , Replay, NewState}, {.., hibernate}, {swap_handle, terminate"Args1, NewState",Module2"Handler2, Args2"}

handle_call( _Request, State ) -> { ok, ok, State }.

%handle_info( Info, State ) -> returns are the same as handle_event,
%Typicall this handles all no sync events, that are not handled by the call backs of  handle_call, handle_info

handle_info( _, State) -> { ok, State }.

code_change( _Old, State, _Extra ) -> { ok, State }.

terminate( _Reason, _State ) -> io:format( "terminating Reason:~p~n", [_Reason] ),
                                ok.
        



