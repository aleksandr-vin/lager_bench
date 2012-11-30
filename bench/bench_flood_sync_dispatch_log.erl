-module(bench_flood_sync_dispatch_log).

-compile([{parse_transform, lager_transform}]).

-define(debug(F, A), lager:debug(F, A)).
-define(info(F, A), lager:info(F, A)).

-export([init/0, terminate/1, test/0]).

init() ->
    file:delete("sync-test.log"),
    file:write_file("sync-test.log", ""),
    error_logger:tty(false),
    application:load(lager),
    application:set_env(lager, handlers, [{lager_file_backend, [{"sync-test.log", info, 10485760, "$D0", 5}]}]),
    application:set_env(lager, error_logger_redirect, false),
    application:set_env(lager, sync_dispatch_log, true),
    application:start(compiler),
    application:start(syntax_tools),
    application:start(lager),
    ok.

terminate(_) ->
%%    file:delete("sync-test.log"),
    application:stop(lager),
    erlang:put(sync_dispatch_log, undefined),
    error_logger:tty(true),
    ok.

test() ->
    iterate(fun one_run/0, 100000).

one_run() ->
    ?debug("Should not see ~p", [this]),
    ?info("Hello ~p", [there]),
    ok.

iterate(_, 0) ->
    ok;
iterate(F, N) when is_integer(N) andalso N > 0 ->
    F(),
    iterate(F, N - 1).
