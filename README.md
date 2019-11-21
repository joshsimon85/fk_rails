# README

* Ruby Version 2.5.7

* Run bundle install

* Run rake db:migrate

* Local dependencies
This app requires the use of sidekiq and redis, make sure they are set up locally

Foreman is also used to start the app locally

* Run test suite
bundle exec rspec

* Seeding the database
If you want to seed the database start up redis then sidekiq locally then seed the database

* Local development
To run the app locally user foreman start -f Procfile-dev
