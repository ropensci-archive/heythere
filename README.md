heythere
========

NOT USED RIGHT NOW

Heroku robot to ping issues with reminders.

This works by using specific keywords in issues.

* To designate reviewer handles, use e.g., `reviewers: @jane @jill`

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
heroku config:add HEYTHERE_REPOSITORY=<github-repository> (like `owner/repo`)
heroku config:add GITHUB_USERNAME=<github-user>
heroku config:add GITHUB_PAT_OCTOKIT=<github-pat-for-octokit>
heroku config:add HEYTHERE_PRE_DEADLINE_DAYS=<number-of-days-integer>
heroku config:add HEYTHERE_DEADLINE_DAYS=<number-of-days-integer>
heroku config:add HEYTHERE_POST_DEADLINE_EVERY_DAYS=<number-of-days-integer>
heroku config:add HEYTHERE_POST_REVIEW_IN_DAYS=<number-of-days-integer>
heroku config:add HEYTHERE_POST_REVIEW_TOGGLE=<boolean>
heroku config:add HEYTHERE_BOT_NICKNAME=<string>
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

If you have your repo in an env var as above, run the rake task `hey`

```
rake hey
```

If not, then pass the repo to `hey` like

```
rake hey repo=owner/repo
```

The command line `repo` var overrides the saved env var.

Puts last comment in the issue in the image below

![img](http://f.cl.ly/items/2P363L3U1L262E023b10/Screen%20Shot%202015-12-21%20at%2011.30.11%20AM.png)

GH Issues Usage
===================

## assigning reviewers

Always assign reviewers with `Reviewers: @foobar`

## issue labels

We look for and use the GH issue labels:

* `package`
* `editor-assigned`
* `review-in-awaiting-changes`

Thus, do use at least those two.

Env vars
========

Non-secret env vars with what we use in parens, then explanation. The values in parens are the defaults as well.

* `HEYTHERE_REPOSITORY` - no default (of the form `owner/repo`)
* `GITHUB_USERNAME` - no default
* `GITHUB_PAT_OCTOKIT` - no default
* `HEYTHERE_PRE_DEADLINE_DAYS` - (`15`)
* `HEYTHERE_DEADLINE_DAYS` - (`21`)
* `HEYTHERE_POST_DEADLINE_EVERY_DAYS` - (`4`)
* `HEYTHERE_POST_REVIEW_IN_DAYS` - (`14`)
* `HEYTHERE_POST_REVIEW_TOGGLE` - (`false`) - i.e., don't do pings to authors after reviews submitted
* `HEYTHERE_LABEL_TARGET` - (`package`) - which issues to consider (others are ignored)
* `HEYTHERE_LABEL_ASSIGNED` - (`3/reviewers-assigned`) - if assigned, then proceed with algorithm...
* `HEYTHERE_LABEL_REVIEW_IN` - (`4/review-in-awaiting-changes`) - if reviews not in, may need to ping reviewers, if reviews in, may or may not want to ping submitter to remind them
* `HEYTHERE_BOT_NICKNAME` - no default - bot nickname

Rake tasks
==========

* rake hey - checks a repo for any issues that need reminders, and pings if so
* rake envs - lists all the env vars you've set. if you're using heroku, and you've set env vars there, you could also do `heroku config`

To Do
=====

* make command line flags for optional command line use (partly addressed)
* make various options for days since this and that, messages, repos, etc.
