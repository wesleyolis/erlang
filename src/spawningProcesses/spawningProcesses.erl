-module(spawningProcesses).

-ifdef(TEST).
-compile([export_all]).
-endif.

-export([main/0,aProcess/1]).


main() -> {ProA_Dog,DogRef} = spawn_monitor( fun() -> aProcess(dog) end ),
          {ProA_Cat,CatRef} = spawn_monitor( ?MODULE, aProcess, [cat] ),

             ProA_Dog ! { self(), dog },
             ProA_Dog ! { self(), cat },
%             ProA_Dog !   self(),

             ProA_Cat ! { self(), dog },
             ProA_Cat ! { self(), cat },
%             ProA_Cat !   self(),
             ProA_Cat ! empty,
             ProA_Dog ! empty,

             ok = wait_all_to_exit([DogRef, CatRef]),             

%            receive 
%                    {'DOWN',DogRef,process,ProA_Dog,normal} -> io:format("The dog is dead~n");
%                    {'DOWN',CatRef,process,ProA_Cat,normal} -> io:format("The cat is dead~n") end,

             io:format("The main is still runing~n"),
             init:stop().

wait_all_to_exit([_|_] = RefList) ->

        receive {'DOWN', SomeRef, process, _SomePid, _Reason} ->
             demonitor(SomeRef, [flush]),
             wait_all_to_exit(lists:delete(SomeRef, RefList))
        after 10000 -> io:format("Functon process havn't had a chance to died yet~n")
        end;
             
wait_all_to_exit([]) -> ok.






aProcess(WhatAmI) -> 
        receive
                {From, WhatAmI} when is_bitstring(WhatAmI) -> From ! "I am a " ++ WhatAmI,
                        aProcess(WhatAmI);
                {From, WhatAmI} when is_list(WhatAmI) ->
                        From ! "I am a multitude of things " ++ WhatAmI,
                        aProcess(WhatAmI);
                {From, kill} -> From ! "aProcess has been kill";
                
                {From,_} -> From ! { error, "this is not a valid message" },
                        aProcess(WhatAmI);

                _ -> io:format("Stop send me crap~n"),
                     timer:sleep(10000)
        end.



