%% Feel free to use, reuse and abuse the code in this file.

-module(newrelic_example).

%% API.
-export([start/0]).

%% API.

start() ->
    ok = application:start(crypto),
    ok = application:start(ranch),
    ok = application:start(cowboy),
    ok = application:start(statman),
    ok = application:start(newrelic),
    ok = application:start(newrelic_example).
