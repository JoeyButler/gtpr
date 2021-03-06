#GTPR
The easy way to manage Github Pull Requests across multiple repos.

GTPR is a YASPTOSWLTC (yet another side project turned open-source with
litte test coverage). Basically, this is a really bare bones app that I
hope at least a few people find helpful.

##Features
- Authentication through Github
- Pulls in PRs from all of your repos and aggregates it into a single view

##How to Install
```
git clone git:://github.com/joeybutler/gtpr && cd gtpr
bundle install
rake db:create db:migrate # Depends on postgres
```

In order to authenticate through Github we'll need to [register our application](https://github.com/settings/applications/new). Set the app name to whatever you'd like, then set the url to `http://gtpr.dev:3000/`, and finally the redirect url to `http://gtpr.dev:3000/users/auth/github/callback`. Once completed you should receive a Client ID and a Client Secret, we'll use these shortly.

You'll want to add `127.0.0.1	gtpr.dev` as a record in your `/etc/hosts` file for the redirect to work properly. Please post an issue if you have any problems.

With the app id and app secret in hand we can start the server.

```
export GTPR_ID=the_app_id_from_github
export GTPR_SECRET=the_app_secret_from_github
script/rails server
open http://gtpr.dev:3000/
```

This should be easy to install on Heroku. 

```
heroku create
heroku config:add GTPR_ID=the_app_id_from_github
heroku config:add GTPR_SECRET=the_app_secret_from_github
git push heroku master
```

Note that this is a prototype, so do it at your own risk. (See the software license)

##TODOs
- Build a Chrome extension to wrap this UI in a sidebar and place it next to Github in the main column.
- Add support for labels.
- Add filters around labels.
- Add sorting.

##Screenshots
![](https://www.evernote.com/shard/s83/sh/9094632c-9757-42e2-b082-2c9a0eeb625a/5611f3c04c91e0da8f10df4c0ea1e17f/res/1d5a914a-29ea-4501-9042-f9001a4e7ee1/skitch.png)

![](https://www.evernote.com/shard/s83/sh/31c442c8-5803-4dae-87f4-d0700ecda09f/89c24378108ebd826357bafd0c98e295/res/ae70af58-8def-4156-9993-a84a31582a8d/skitch.png)

##License
Your typical MIT license. See `LICENSE`.
