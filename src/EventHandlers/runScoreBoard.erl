-module(runScoreBoard).
-compile([export_all]).

-include("curling_scoreboard.hrl").
-include("curling_feed_handler.hrl").

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
Term = gen_event:delete_handler( Pid, ?CURLING_SCOREBOARD, #csb_terminate{reason=turn_off} ),
ok = io:format( "Termination Response ~p~n", [Term] ),
true = is_record( Term, csb_delete_handle ),

ok = gen_event:notify( Pid, next_round ),

%% Repeat the previous example using the wrapper.

Pid2 = curling:start_link( 'Pirates', 'Scotsmen' ),
ok = curling:set_teams( Pid2, 'Pirates2', 'Scotsmen2' ),
ok = curling:add_points( Pid2, 'Pirates', 5 ),
ok = curling:next_round( Pid2 ),

%%Repeat this now with the addition of a feed handler

Pid3 = curling:start_link( 'Pirates', 'Scotesmen' ),
FeedHandle = curling:join_feed( Pid3, self() ),
ok = curling:add_points( Pid3, 'Pirates', 3 ),
ok = curling:add_points( Pid3, 'Scotesmen', 4),
ok = curling:next_round( Pid3 ),
ok = curling:game_info( Pid3 ),
ok = curling:leave_feed( Pid3, FeedHandle, #terminate{ reason = 'This is boring. Some lazer augmented onto the ice, might be pretty cool.' } ),


init:stop().
