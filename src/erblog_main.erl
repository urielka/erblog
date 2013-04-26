-module(erblog_main).
-export([start/0,create_mnesia/0]).
-include("erblog_models.hrl").

start() ->
  application:start(mnesia),
  application:start(erblog).

create_mnesia() ->
  Nodes = [node()],
  ok = mnesia:create_schema(Nodes),
  application:start(mnesia),
  mnesia:create_table(erblog_post,
    [
     {attributes, record_info(fields, erblog_post)},
     {disc_copies, Nodes}
    ]),
  %% lets create some sample posts
  mnesia:transaction(fun() ->
    mnesia:write(#erblog_post{
      id=1,
      title="My first blog post",
      content="Something something and you know what something else!",
      comments=[]
    }),
    mnesia:write(#erblog_post{
      id=2,
      title="And now my second",
      content="Well this post is more interesting it has comments!",
      comments=[#erblog_comment{
                  author="Me!",
                  content="Boring..."
                },
                #erblog_comment{
                  author="Also Me!",
                  content="Hmmm... no!"
                }]
    })
  end),
  application:stop(mnesia).