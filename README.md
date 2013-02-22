#GTPR
An easier way of managing Github Pull Requests across multiple repos.

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

##License
Your typical MIT license. See `LICENSE`.