-module(curling_scoreboard).
-behaviour(gen_event).
-export( [init/1, handle_event/2, handle_call/2, handle_info/2, code_change/3, terminate/2] ).

-export_type( [csb_team/0, csb_state/0] ).

-include("curling_scoreboard.hrl").

-record( csb_team, { name, score = 0 } ).
-opaque csb_team() :: # csb_team{}.

-record( csb_state, { teams = [] :: [{ atom(), csb_team() }] | [] } ).
-opaque csb_state() :: #csb_state{}.

init([]) -> { ok, #csb_state{} }. %the tuple with empty state { ok , State = [] }
%handle_event( Events, State) -> { ok, NewState }, { ok, NewState, hibernate}, {swap_handler, Args1, NewState, Handler, Args2 }

-spec add_team( TName , State ) -> RState when
         TName :: atom(),
          State :: csb_state(),
          RState :: csb_state().

add_team( TName, State = #csb_state{} ) ->

        case proplists:is_defined ( TName, State#csb_state.teams ) of
                true  -> State;
                false ->
                       Team = #csb_team{ name = TName },
                       State#csb_state{ teams = [ { TName, Team } | State#csb_state.teams ] }
        end.


-spec add_points_to_team( TName :: atom(), N :: integer() , State :: csb_state() ) -> csb_state().

add_points_to_team( TName, N , State = #csb_state{} ) ->
        case  OTeam = proplists:get_value( TName, State#csb_state.teams ) of 
        
            undefined -> io:format("Team was not found ~p~n", [TName] ),
                 error_logger:error_msg("Team was not found", [ TName ] ),
                 State;
            _ ->
                Team = #csb_team{ name = TName, score = (N + OTeam#csb_team.score) },
                NTeams =  proplists:delete( TName, State#csb_state.teams ),
                N2_Teams = [ {TName, Team } | NTeams ],       
                State#csb_state{ teams = N2_Teams }
        end.


-spec handle_event( events() , csb_state() ) -> { ok, csb_state() }.

handle_event( Teams = #set_teams{}, State = #csb_state{} ) -> 
       TA_Key = Teams#set_teams.teamA,
       TB_Key = Teams#set_teams.teamB,

       N_State = add_team( TA_Key, State ),
       N2_State = add_team( TB_Key, N_State ),

       scoreBoardHw:set_teams( Teams#set_teams.teamA, Teams#set_teams.teamB ),
       {ok, N2_State};

handle_event( Event = #add_points{} , State ) ->

        NState = add_points_to_team( Event#add_points.team, Event#add_points.n, State ),        

        [ scoreBoardHw:add_point( Event#add_points.team ) || _ <- lists:seq( 1, Event#add_points.n ) ],
        {ok, NState};

handle_event( #next_round{}, State ) ->
        scoreBoardHw:next_round(),
        { ok, State };

handle_event( #game_info{}, State ) ->
        io:format( "Game info: ~p~n", [State#csb_state.teams] ),
        { ok , State };

handle_event( _Event, State ) -> 
         { ok , State }.


% handle_call( Request, State) -> { ok , Replay, NewState}, {.., hibernate}, {swap_handle, terminate"Args1, NewState",Module2"Handler2, Args2"}

handle_call( _Request, State ) -> { ok, ok, State }.

%handle_info( Info, State ) -> returns are the same as handle_event,
%Typicall this handles all no sync events, that are not handled by the call backs of  handle_call, handle_info

handle_info( _, State) -> { ok, State }.

code_change( _Old, State, _Extra ) -> { ok, State }.

terminate( _Reason = #csb_terminate{}, _State ) -> 
        io:format( "terminating using protocal ~p~n", [_Reason] ),
        #csb_delete_handle{ error = ok, status = 'Good to terminate'};

terminate( _Reason, _State ) -> io:format( "crude termination:~p~n", [_Reason] ),
                                undefined.
        



