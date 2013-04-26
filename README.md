ERblog (Eralng-based blog)
====================================

This is my first attempt at writing Erlang :)
It is a simple blog written in Erlang using yaws as a webserver and mnesia as DB(aka as LYME stack).

It is not meant to be used by anyone and is probably not a good example of writing erlang.

Requirments
--------------------------------------
I tested it on Erlang R14B04,and the rest of the requirments are handled by rebar

First run
--------------------------------------
Since erblog uses mnesia we first need to create a schema,run:
```bash
priv/start_dev db
```

This will create mnesia schema on this node and insert some dummy data,to close the erlang shell simply type q().

Running the blog
--------------------------------------
just run:
```bash
priv/start_dev
```
The blog should be running on http://localhost:9090

Adding a blog post
--------------------------------------
In the erlang shell type:
```erlang
rr("include/*").
erblog_models:add_post(3,"Your title","Your content").
```
Cleaning the db
--------------------------------------
To restore the db to its initial state run:
```bash
priv/start_dev clean_db
```