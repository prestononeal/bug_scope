# SCOPE

This application helps triage and track issues across different builds and automated test runs.

These issues can include crashes or any other problems that can be defined with a "type" and a "signature".

The cumulative total of all issues across all builds can be viewed in aggregate, or the individual builds can be inspected to see which issues were found. Issues are sorted by number of occurrences to help find the most common issues to help prioritize the resolution of them.

Tickets can be attached to issues (eg. a scrum task), and duplicate issues can be merged together. When viewing a specific issue, similar issues based on the signature will be displayed to provide hints of possible duplicates in other builds.

Installation steps for development (server):

1. Install [rbenv](https://github.com/rbenv/rbenv#installation)
2. `rbenv install 2.3.1`
3. `rbenv global 2.3.1` (or `rbenv local 2.3.1`)
3. `gem install bundler`
4. `rbenv rehash`
4. Install [postgres](https://www.postgresql.org/download/)
5. `bundle install`
6. `bundle exec rake db:create db:migrate`
7. (optional) `bundle exec rake db:seed` to seed the database with some data
8. `bundle exec rails start`

Running server test cases:

1. `bundle exec rspec` (all tests should pass)

Installation steps for development (client):

1. Install node.js
2. Install npm
3. Go to `client` folder
4. `npm install`
5. `npm install -g @angular/cli`
6. `ng serve --open`

Production deployment (POSIX, using Rails to serve client assets):

1. Define `scope_database_username`, and `scope_database_password` in config/application.yml.
2. Build and deploy client side assets by running `ng build --prod` inside the `client` folder
3. Set up and start deployment server (nginx, etc)

Production deployment (Heroku API/Github client):

1. The node packages and Heroku buildpacks were configured as described [here](https://www.angularonrails.com/deploy-angular-cli-webpack-project-heroku/)

