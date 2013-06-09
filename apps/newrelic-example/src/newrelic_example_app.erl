%% Feel free to use, reuse and abuse the code in this file.

%% @private
-module(newrelic_example_app).
-behaviour(application).

%% API.
-export([start/2]).
-export([stop/1]).

%% API.

start(_Type, _Args) ->
    Dispatch = cowboy_router:compile([
                                      {'_', [
                                             {"/", toppage_handler, []}
                                            ]}
                                     ]),

    {ok, _} = cowboy:start_http(http, 100, [{port, 8888}], [
                                                            {env, [{dispatch, Dispatch}]},
                                                            {onresponse, fun newrelic_example_responder:respond/4}
                                                           ]),

    %% start up the things we need
    Result = newrelic_example_sup:start_link(),
    
    %% add in a subscriber the statman
    statman_server:add_subscriber(statman_aggregator),

    %% start up the newrelic poller to send off data
    case application:get_env(newrelic,license_key) of
        undefined ->
            ok;
        _ ->
            newrelic_poller:start_link(fun newrelic_statman:poll/0)
    end,

    Result.

stop(_State) ->
    ok.
