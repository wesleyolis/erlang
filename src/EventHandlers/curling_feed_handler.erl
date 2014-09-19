-module(curling_feed_handler).
-behaviour(gen_event).

-include("curling_feed_handler.hrl").

-export([init/1, handle_event/2, handle_call/2, handle_info/2, code_change/3, terminate/2]).

init( State = #feed_state{} ) ->
    {ok, State}.   

handle_event( Event, State = #feed_state{ pid = ClientPid } ) -> 
                ClientPid ! { curling_feed, Event },
                { ok, State };

handle_event( _, State ) -> 
                { ok , State }.

% Typcially function signature, or parameters usuage
% handle_call( Request, State ) -> { ok, Reply, NewState } ...
handle_call( _, State ) -> { ok, ok, State }.

handle_info( _, State ) ->
        { ok, State }.

code_change( _Old, State, _Extra ) -> { ok, State }. % we don't have and upgrade procedure as of yet

terminate( Reason = #terminate{}, _State ) ->
        io:format( "Terminating feed handler:~p~n", [Reason#terminate.reason] ),
        ok;

terminate( _Reason, _State ) ->
        unexpected.
