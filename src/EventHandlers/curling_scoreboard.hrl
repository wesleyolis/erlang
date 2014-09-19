%%%Communication Protocal


-record( set_teams, { teamA, teamB } ). 
-type set_teams() :: #set_teams{}.

-record( add_points, { team, n } ).
-type add_points() :: #add_points{}.

-record( next_round, { } ).
-type next_round() :: #next_round{}.

-record( game_info, {} ).
-type game_info() :: #game_info{}.

-type events() :: game_info() | set_teams() | add_points() | next_round().

-record( csb_terminate, { reason } ).
-type csb_terminate() :: #csb_terminate{}.

-record( csb_delete_handle, { error, status } ).
-type csb_delete_handle() :: #csb_delete_handle{}.


