%% Feel free to use, reuse and abuse the code in this file.

%% @doc Hello world handler.
-module(toppage_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

init(_Transport, Req, []) ->
    {ok, Req, undefined}.

handle(Req, State) ->
    Start = now(),
    {ok, Req2} = cowboy_req:reply(200, [], <<"Hello world!">>, Req),
    {PathB, Req3} = cowboy_req:path(Req2),

    statman_histogram:record_value({PathB, total},
                                   Start),    
    {ok, Req3, State}.

terminate(_Reason, _Req, _State) ->
    ok.
