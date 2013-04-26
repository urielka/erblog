-module(erblog_views).
-export([post/2,post_list/1,page_template/1]).
-include("erblog_models.hrl").

page_template(Content) ->
  {ehtml,[
        {html,[],
          [{head,[],
            {style,[],"
              #main{
                width:800px;
                margin:40px auto;
              }
            "}
          },
          {body,[],[
                    {'div',[{id,main}],[
                      {h1,[{id,title}],[
                        {'a',[{href,"/"}],"ERblog!"}
                      ]},
                      {'div',[{id,content}],Content}
                    ]}
                   ]
          }]
        }]
  }.

input_field(Name,Display) ->
  {'div',[],[
    {'label',[{for,Name}],Display ++ ":"},
    {'input',[{type,"text"},{name,Name}],[]}
  ]}.

comment_form(Post) ->
  ActionURL = io_lib:format("/post/~p/add_comment",[Post#erblog_post.id]),
  {'form',[{action,ActionURL},{method,"post"}],[
    {'fieldset',[],[
      {'legend',[],"Contribue to the discussion"},
      input_field("author","Name"),
      input_field("content","Content"),
      {'div',[],[
        {'input',[{type,"submit"},{value,"Comment"}],[]}
      ]}
    ]}
  ]}.

post(Post,WithComments) ->
  Comments = case WithComments of
    true ->
      CommentList = [comment(X) || X <- Post#erblog_post.comments],
      [comment_form(Post) | CommentList];
    _ ->
      []
  end,
  NumberComments = length(Post#erblog_post.comments),
  {'div',[{class,post}],[
    {h2,[],{
      a,[{href,io_lib:format("/post/~p",[Post#erblog_post.id])}],
        Post#erblog_post.title
    }},
    {'div',[],Post#erblog_post.content},
    {'div',[],io_lib:format("Comments(~p)",[NumberComments])},
    {'div',[],Comments}
  ]
  }.

comment(Comment) ->
  {'div',[{class,comment}],[
    {h4,[],Comment#erblog_comment.author},
    {p,[],Comment#erblog_comment.content}
  ]}.

post_list(Posts) ->
  page_template([post(X,false) || X <- Posts]).