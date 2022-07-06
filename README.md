# Bingo Backend

## What it is

This is the backend for a bingo-playing app, and it is the main part of a project for Flatiron School. It uses the [Active Record](https://guides.rubyonrails.org/active_record_basics.html) ORM with a [SQLite](https://www.sqlite.org/index.html) database to handle all the information that it needs to store and interact with. The routes are set up using [Sinatra](http://sinatrarb.com/). The frontend repo is [here](https://github.com/nkulik94/sinatra-react-bingo-frontend).

## How to run it

To run the server, clone the repo and run `bundle install`, then `rake db:migrate` and `rake server`. The database can be populated with dummy data by running `rake db:seed`, but because the seed file simulates 100 full games of bingo, be aware that it'll take some time. The routes can be tested with [Postman](https://www.postman.com/) or by cloning and running the frontend.