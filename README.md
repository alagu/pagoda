Pagoda    [![Build Status](https://travis-ci.org/alagu/pagoda.png?branch=master)](https://travis-ci.org/alagu/pagoda) [![Code Climate](https://codeclimate.com/github/alagu/pagoda.png)](https://codeclimate.com/github/alagu/pagoda)
=========


![http://f.cl.ly/items/3v0Y3q2O461C3K0A221Y/pagoda.png](http://f.cl.ly/items/3v0Y3q2O461C3K0A221Y/pagoda.png)

Zen like **blog editor** for your **Jekyll** blog, heavily inspired by Svbtle. 

Screenshots
===========

**Dashboard**
![http://cl.ly/image/2u0L362v1L1N/Home.png](http://cl.ly/image/2u0L362v1L1N/Home.png)

**Editor**
![http://cl.ly/image/1u2w2l2F0w1e/Pale%20Blue%20Dot.png](http://cl.ly/image/1u2w2l2F0w1e/Pale%20Blue%20Dot.png)

**Fullscreen editing**
![http://cl.ly/image/0b3Y101Y3g0A/Screen%20Shot%202013-05-14%20at%2011.57.45%20PM.png](http://cl.ly/image/0b3Y101Y3g0A/Screen%20Shot%202013-05-14%20at%2011.57.45%20PM.png)

**Mobile Dashboard and Editing**



Install
=======

Two commands, one for installing, another for running.

```
  gem install pagoda-jekyll
  pagoda .
```


![http://cl.ly/image/1B3Z1Q3I1g37/pagoda-install.png](http://cl.ly/image/1B3Z1Q3I1g37/pagoda-install.png)



Deploying on your own server
============================

Right now there is no auth mechanism. The way I use it is http auth at nginx.


FAQ/Bugs
========

**I get ArgumentError - invalid byte sequence in US-ASCII**

Set localte to UTF-8

```
export LC_ALL=en_US.UTF-8
```
