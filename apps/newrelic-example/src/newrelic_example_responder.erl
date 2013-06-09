-module(newrelic_example_responder).

-export([respond/4]).

respond(404, Headers, <<>>, Req) ->
    {Path, Req2} = cowboy_req:path(Req),
    statman_counter:incr({Path, {error, {404, <<"Not found">>}}}),

    Body = <<"404 Not Found: \"", Path/binary, "\" is not the path you are looking for.\n">>,
    Headers2 = lists:keyreplace(<<"content-length">>, 1, Headers,
                                {<<"content-length">>, integer_to_list(byte_size(Body))}),
    {ok, Req3} = cowboy_req:reply(404, Headers2, Body, Req2),
    Req3;

respond(Code, Headers, <<>>, Req) when is_integer(Code), Code >= 400 ->
    {Path, Req2} = cowboy_req:path(Req),
    statman_counter:incr({Path, {error, {Code, <<"ERROR">>}}}),
    Body = <<"HTTP Error ", (integer_to_list(Code))/binary, "\n">>,
    Headers2 = lists:keyreplace(<<"content-length">>, 1, Headers,
                                {<<"content-length">>, integer_to_list(iolist_size(Body))}),
    {ok, Req3} = cowboy_req:reply(Code, Headers2, Body, Req2),
    Req3;

respond(_Code, _Headers, _Body, Req) ->
    Req.
