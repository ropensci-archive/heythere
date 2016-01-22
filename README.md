heythere
========

Heroku robot to ping issues with reminders.

Install
=====

```
git clone git@github.com:ropenscilabs/heythere.git
cd heythere
```

Setup
=====

Create the app (use a different name, of course)

```
heroku apps:create ropensci-hey-there
```

Create a GitHub personal access token just for this application. You'll need to set a env var for your username and the token. We read these in the app.

```
heroku config:add GITHUB_USERNAME=<github-user>
heroku config:add GITHUB_PAT_OCTOKIT=<github-pat>
```

Push your app to Heroku

```
git push heroku master
```

Add the scheduler to your heroku app

```
heroku addons:create scheduler:standard
heroku addons:open scheduler
```

Add the task ```rake hey``` to your heroku scheduler and set to whatever schedule you want.


Usage
=====

run `hey`

```
rake hey
```

Puts last comment in the issue in the image below

![img](http://f.cl.ly/items/2P363L3U1L262E023b10/Screen%20Shot%202015-12-21%20at%2011.30.11%20AM.png)

To Do
=====

* make command line flags for optional command line use
* make various options for days since this and that, messages, repos, etc.
* document what's needed in the repos that are being checked, so far:
    * consistent way to assign reviewers
    * consistent use of tags
