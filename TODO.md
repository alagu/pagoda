# TODO List

### Deployable in heroku.

Anyone should be able to use heroku to host their pagoda instance, irrespective of where their jekyll git repository is.

-  Heroku is an easy way to self host your jekyll blog's dashboard.
-  Deployment is easy.
-  It should be password protected.
-  Any jekyll-git repository (github, bitbucket, ssh) should be authorable from heroku.

**Ideal world experience:**

```bash
$ git clone git@github.com:alagu/pagoda.git
$ heroku create
Created sushi.herokuapp.com | git@heroku.com:sushi.git

$ heroku config:add PAGODA_REPO=ssh://git@bitbucket.org/alagu/blog.git
$ heroku config:add PAGODA_PRIVATE_KEY="-----BEGIN RSA PRIVATE KEY-----
Proc-Type: 4,ENCRYPTED
DEK-Info: AES-128-CBC,ABCDEFGHIJKLMNOPQRSTUVWXYZ

somenewprivatekeyforpagodathatyoujustcreated
somenewprivatekeyforpagodathatyoujustcreated
somenewprivatekeyforpagodathatyoujustcreated
-----END RSA PRIVATE KEY-----"

$ heroku config:add PAGODA_USER=alagu
$ heroku config:add PAGODA_PASS=`echo "mynewpassword" | md5`

$ git push heroku master
-----> Heroku receiving push
-----> Rails app detected
-----> Compiled slug size is 8.0MB
-----> Launching... done, v1
http://sushi.herokuapp.com deployed to Heroku 

$ open http://sushi.herokuapp.com/
```

Open up your browser and you should have pagoda up and ready!


Probably, it should be even simpler if all this is wrapped inside a shell script.


### Inline Markdown Editor

**Problems with existing Markdown editor**
- Split screen sucks. One screen to preview and another screen to edit. Redundant content.
- You need to remember Markdown syntax.

**How I wish the editor would be**
- The line in which you are editing, you can write in Markdown. Once you move to the next line, the previously edited line should automatically get converted to preview (or) rendered mode.
- When you move your cursor to a specific line, it should automatically be in markdown syntax mode.
- Markdown syntax is fairly simple - but it requires some amount of help around to remember. Still not sure of whether an iconbox is required here or some other way to make me remember syntax.


# Done
- YAML Editor
