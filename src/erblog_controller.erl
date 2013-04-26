-module(erblog_controller).
-export([all/1,show/2,add_comment/2]).
-include("erblog_models.hrl").

all(_) ->
  Posts = erblog_models:all_posts(),
  erblog_views:post_list(Posts).

show(_,PostID) ->
  Post = erblog_models:get_post(PostID),
  erblog_views:page_template(erblog_views:post(Post,true)).

add_comment(A,PostID) ->
  {ok, Author} = yaws_api:postvar(A,"author"),
  {ok, Content} = yaws_api:postvar(A,"content"),
  erblog_models:add_comment(PostID,Author,Content),
  {redirect,io_lib:format("/post/~p",[PostID])}.