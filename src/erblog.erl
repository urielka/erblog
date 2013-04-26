-module(erblog).
-behaviour(application).
-export([start/2, stop/1]).

-include("deps/yaws/include/yaws.hrl").

start(normal, _Args) ->
  Id = "erblog",
  GconfList = [{logdir, filename:absname("./logs")},
               {ebin_dir, [filename:absname("./ebin")]},
               {id, Id}],
  Docroot = filename:absname("."),
  SconfList = [{docroot, Docroot},
               {port, 9090},
               {listen, {127,0,0,1}},
               {appmods, [{"/", erblog_router,["static"]}]}],
  yaws:start_embedded(Docroot, SconfList, GconfList, Id),
  {ok,self()}.

stop(_State) ->
  ok.