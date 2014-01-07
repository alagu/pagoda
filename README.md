Pagoda    [![Build Status](https://travis-ci.org/alagu/pagoda.png?branch=master)](https://travis-ci.org/alagu/pagoda) [![Code Climate](https://codeclimate.com/github/alagu/pagoda.png)](https://codeclimate.com/github/alagu/pagoda)
=========

[![Analytics](https://ga-beacon.appspot.com/UA-2819287-7/alagu/pagoda?pixel)](https://github.com/alagu/pagoda)


![http://f.cl.ly/items/3v0Y3q2O461C3K0A221Y/pagoda.png](http://f.cl.ly/items/3v0Y3q2O461C3K0A221Y/pagoda.png)

Zen like **blog editor** for your **Jekyll** blog, heavily inspired by [Svbtle](http://dcurt.is/codename-svbtle) and [Obtvse](https://github.com/natew/obtvse). 

Screenshots
===========

**Dashboard**
![http://cl.ly/image/2u0L362v1L1N/Home.png](http://cl.ly/image/2u0L362v1L1N/Home.png)

**Editor**
![http://cl.ly/image/1u2w2l2F0w1e/Pale%20Blue%20Dot.png](http://cl.ly/image/1u2w2l2F0w1e/Pale%20Blue%20Dot.png)

**Fullscreen editing**
![http://cl.ly/image/0b3Y101Y3g0A/Screen%20Shot%202013-05-14%20at%2011.57.45%20PM.png](http://cl.ly/image/0b3Y101Y3g0A/Screen%20Shot%202013-05-14%20at%2011.57.45%20PM.png)

**Edit YAML Data**

![http://cl.ly/image/2P342Q1W0q1H/Screen%20Shot%202013-06-09%20at%203.13.13%20PM.png](http://cl.ly/image/2P342Q1W0q1H/Screen%20Shot%202013-06-09%20at%203.13.13%20PM.png)


**Mobile Dashboard and Editing**


<img src="http://cl.ly/image/2j1V2n2z0f0s/2013-05-15%2000.10.22.png" width="400"/>......<img src="http://cl.ly/image/030i1G0c3d0u/2013-05-15%2000.10.57.png" width="400"/>


Install
=======

Installing locally
------------------
Two commands, one for installing, another for running.

```sh
  gem install pagoda-jekyll
  pagoda .
```


![http://cl.ly/image/1B3Z1Q3I1g37/pagoda-install.png](http://cl.ly/image/1B3Z1Q3I1g37/pagoda-install.png)


Running it on Heroku
--------------------
Requirements:
1. Heroku
2. Git
3. Your Jekyll Repo

```sh
git clone https://github.com/alagu/pagoda
cd pagoda
heroku create
bundle exec rake heroku
```


Default YAML
=============
Each post created with pagoda will have a default yaml data. To modify it, create a `_default.yml` in your jekyll repository and commit it.


Deploying on your own server
============================
I use basic http authentication in real world use. I've deployed through nginx + unicorn. There could be easier deployment than this. 

This is still not well organized, but the setup works.

## Create sock and pid folders

```sh
mkdir -p tmp/pids
mkdir tmp/sock
```

## Your unicorn configuration (unicorn.rb):

```ruby
pid "./tmp/pids/blog-admin.pid"
listen "unix:./tmp/sock/blog-admin.sock"
ENV['blog'] = '/path/to/your/jekyll/blog'
```

## Script to start Unicorn (start.sh):

```sh
cd /path/to/pagoda
rvm use 1.9.3
unicorn -c unicorn.rb  -D
```
Note: This should be run as bash --login start.sh

## Create htpasswd file for authentication
```
htpasswd -c /path/to/httpasswd/file alagu
New password: <enterpasswd>
Re-type new password: <re-enterpasswd>
Adding password for user alagu
```

## Nginx configuration

`myblog.com` shows the generated blog and `myblog.com/admin` pops up a http authentication for your admin.

```nginx
upstream unicorn_server {
   server unix:/path/to/tmp/sock/blog-admin.sock;
}

server {
        server_name myblog.com;

        listen 80;

        location / {
           root  /path/to/your/jekyll/blog/_site/;
        }

        location /admin {
                auth_basic "Restricted";
                auth_basic_user_file /path/to/htpasswd/file;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header Host $http_host;
                proxy_redirect off;
                proxy_pass http://unicorn_server;
        }
}
```




FAQ/Bugs
========

**I get ArgumentError - invalid byte sequence in US-ASCII**

Set localte to UTF-8

```
export LC_ALL=en_US.UTF-8
```
