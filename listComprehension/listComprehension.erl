-module(listComprehension).

-compile(export_all).


run() ->
RestaurantMenu = [ {steak, 5.99}, {beer, 3.99}, {potinue, 3.5}, {kiten, 20.99}, {water, 0.0}, {bla, 5, 6}, 500 ],
Siders = [{wax, 1}, {ice, 2}, {brandy,3}, {cooldrink, 4}],
       Res = [{Index, Gen, Price} || Gen <- RestaurantMenu, {_,Index} <- Siders, Index =< 2,
begin
case Gen of 
{_,Price} -> true;
_ -> Price = undefined, true
end
end],
io:format("~p~n",[Res]).
