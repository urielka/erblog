-module(erblog_router).
-export([out/1]).
-include("deps/yaws/include/yaws_api.hrl").

match_integer(Str) ->
  case re:run(Str,"^[0-9]+$") of
    {match,_} ->
      list_to_integer(Str);
    _ ->
      false
  end.

out(Arg) ->
  URLParts = re:split(Arg#arg.appmoddata,"/",[{return,list},trim]),
  case URLParts of
    [[]] ->
      erblog_controller:all(Arg);
    ["post",PostID] ->
      case match_integer(PostID) of
        false ->
          {html,"Bad post ID"};
        IntPostID ->
          erblog_controller:show(Arg,IntPostID)
      end;
    ["post",PostID,"add_comment"] ->
      case match_integer(PostID) of
        false ->
          {html,"Bad post ID"};
        IntPostID ->
          erblog_controller:add_comment(Arg,IntPostID)
      end;
    _ ->
      {html,"Not found :("}
  end.