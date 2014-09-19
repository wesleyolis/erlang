%%% This is a simplied interface to the client, that hides the details of the implementation.
-module(curling).

-export([start_link/2, set_teams/3, add_points/3, next_round/1, join_feed/2, leave_feed/3, terminate/2, game_info/1]).


-include ("curling_scoreboard.hrl").
-include ("curling_feed_handler.hrl").


start_link( TeamA, TeamB ) -> 
        { ok , Pid } = gen_event:start_link(),
           ok = gen_event:add_handler( Pid, curling_scoreboard,[] ),
           ok = set_teams( Pid, TeamA, TeamB ),
           Pid.

set_teams( Pid, TeamA, TeamB ) ->
       ok =  gen_event:notify( Pid, #set_teams{ teamA=TeamA, teamB=TeamB } ).

add_points( Pid, Team, N ) ->
       ok =  gen_event:notify( Pid, #add_points{ team=Team, n = N } ).

next_round( Pid ) -> 
       ok = gen_event:notify( Pid, #next_round{} ).

terminate( Pid, Reason ) ->
Response =  #csb_delete_handle{} = gen_event:delete_handler( Pid, curling_scoreboard, #csb_terminate{ reason = Reason } ),
        io:format( "Calling to terminate application, feedback ~p~n", [Response] ).

join_feed( Pid, ToPid ) -> 
        HandlerId = { curling_feed_handler, make_ref() },
        ok = gen_event:add_handler( Pid, HandlerId, #feed_state{ pid = ToPid } ),
        HandlerId.


leave_feed( Pid, HandlerId, Reason ) -> 
        ok = gen_event:delete_handler( Pid , HandlerId, Reason ).

game_info( Pid ) ->  
        ok = gen_event:notify( Pid, #game_info{} ).


