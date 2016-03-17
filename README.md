heythere
========

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
heroku config:add GITHUB_USERNAME=<github-user>
heroku config:add GITHUB_PAT_OCTOKIT=<github-pat-for-octokit>
heroku config:add HEYTHERE_PRE_DEADLINE_DAYS=<number-of-days-integer>
heroku config:add HEYTHERE_DEADLINE_DAYS=<number-of-days-integer>
heroku config:add HEYTHERE_POST_DEADLINE_EVERY_DAYS=<number-of-days-integer>
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

* `GITHUB_USERNAME`
* `GITHUB_PAT_OCTOKIT`
* `HEYTHERE_PRE_DEADLINE_DAYS` - (`15`)
* `HEYTHERE_DEADLINE_DAYS` - (`21`)
* `HEYTHERE_POST_DEADLINE_EVERY_DAYS` - (`4`)
* `HEYTHERE_LABEL_TARGET` - (`package`) - which issues to consider (others are ignored)
* `HEYTHERE_LABEL_ASSIGNED` - (`editor-assigned`) - if assigned, then proceed with algorithm...
* `HEYTHERE_LABEL_REVIEW_IN` - (`review-in-awaiting-changes`) - if reviews not in, may need to ping reviewers, if reviews in, may or may not want to ping submitter to remind them

To Do
=====

* make command line flags for optional command line use
* make various options for days since this and that, messages, repos, etc.
