# TODO

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



### Inline Markdown Editor


# Done
- YAML Editor
