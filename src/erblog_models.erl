-module(erblog_models).
-export([all_posts/0,get_post/1,add_comment/3,add_post/3]).
-include("erblog_models.hrl").

all_posts() ->
  {atomic,Posts} = mnesia:transaction(fun() -> qlc:e(mnesia:table(erblog_post)) end),
  Posts.

get_post(PostID) ->
  {atomic,[Post]} = mnesia:transaction(fun() -> mnesia:read({erblog_post,PostID}) end),
  Post.

add_comment(PostID,Author,Content) ->
  {atomic,ok} = mnesia:transaction(fun() ->
    [Post] = mnesia:wread({erblog_post, PostID}),
    NewComment = #erblog_comment{author=Author,content=Content},
    NewComments = [NewComment | Post#erblog_post.comments],
    mnesia:write(Post#erblog_post{comments=NewComments})
  end).

add_post(PostID,Title,Content) ->
  {atomic,ok} = mnesia:transaction(fun() ->
    mnesia:write(#erblog_post{id=PostID,
                              title=Title,
                              content=Content
                })
  end).