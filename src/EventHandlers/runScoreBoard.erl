-module(runScoreBoard).
-compile([export_all]).

-include("curling_scoreboard.hrl").

-define( PIRATES, 'Pirates').
-define( SCOTESMEN, 'Scotsmen').
-define( CURLING_SCOREBOARD, 'curling_scoreboard' ).

run() ->
{ ok, Pid } = gen_event:start_link(),

ok = gen_event:add_handler( Pid, ?CURLING_SCOREBOARD, [] ),


ok = gen_event:notify( Pid, #set_teams { teamA=?PIRATES, teamB=?SCOTESMEN } ),
ok = gen_event:notify( Pid, #add_points { team=?PIRATES,n= 3 } ),
ok = gen_event:notify( Pid, #next_round {}),

% delete handler ( Pid, Handler, Args"Pass to terminate"
Term = gen_event:delete_handler( Pid, ?CURLING_SCOREBOARD, turn_off ),
ok = io:format( "Termination Response ~p~n", [Term] ),
ok = Term,

ok = gen_event:notify( Pid, next_round ),
init:stop().
