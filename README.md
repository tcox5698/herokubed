![Travis CI build status](https://api.travis-ci.org/tcox5698/herokubed.svg)



# herokubed

Command line conveniences for heroku in a gem


# Usage

Build the gem

    gem build herokubed.gemspec
    
Install the gem
    
    gem install --no-ri --no-rdoc herokubed-<version>.gem
    
Transfer a postgres db from one heroku app to another

    ktransferdb source_app target_app
    
Download a backup of a postgres db from an heroku app to the .dbwork directory
 
    kbackupdb source_app
    
Load an app's dump file to your local postgres instance

    kloaddumplocally source_app local_db
    
# Development
    
## To run specs and features:    
    
1. Clone the repository
1. `vagrant up`
1. `vagrant ssh`
1. `cd /vagrant`
1. `bundle install`
1. `export HEROKU_USERNAME=<your heroku username`
1. `export HEROKU_TOKEN=<your heroku auth token, not your password, found in ~/.netrc>`
1. `bundle exec rake`

# Release

1. merge release to master
1. merge master to release
1. on release, finalize the version in the gemspec file
1. `bundle install`
1. commit 
1. tag with the version from the gemspec file
1. push release and tags to github
1. checkout master
1. merge release to master
1. bump gemspec version to new .pre version
1. commit and push
